Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19431203FF7
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 21:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgFVTSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 15:18:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:65396 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgFVTSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 15:18:53 -0400
IronPort-SDR: wrrSBOPmd16Q1WVpsKl6gCnksCDNcI2K4n6bbk+3Sdw9iZXUWzqNpWfF2YEno758VxMJoKNEUg
 AAyyGUgw0egA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142104136"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142104136"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 12:18:52 -0700
IronPort-SDR: YVmGmOk4LxL2JOfJJgRpdCtim8lytnwabCI48Si0wsEpZcel5g8mmnT70/lza4l6ki1cS5jCpe
 8nU3TqECXK3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478491690"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2020 12:18:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Don't put invalid SPs back on the list of active pages
Date:   Mon, 22 Jun 2020 12:18:50 -0700
Message-Id: <20200622191850.8529-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete a shadow page from the invalidation list instead of throwing it
back on the list of active pages when it's a root shadow page with
active users.  Invalid active root pages will be explicitly freed by
mmu_free_root_page() when the root_count hits zero, i.e. they don't need
to be put on the active list to avoid leakage.

Use sp->role.invalid to detect that a shadow page has already been
zapped, i.e. is not on a list.

WARN if an invalid page is encountered when zapping pages, as it should
now be impossible.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..fa5bd3f987dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2757,10 +2757,13 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	if (!sp->root_count) {
 		/* Count self */
 		(*nr_zapped)++;
-		list_move(&sp->link, invalid_list);
+		if (sp->role.invalid)
+			list_add(&sp->link, invalid_list);
+		else
+			list_move(&sp->link, invalid_list);
 		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
-		list_move(&sp->link, &kvm->arch.active_mmu_pages);
+		list_del(&sp->link);
 
 		/*
 		 * Obsolete pages cannot be used on any vCPUs, see the comment
@@ -5732,12 +5735,11 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			break;
 
 		/*
-		 * Skip invalid pages with a non-zero root count, zapping pages
-		 * with a non-zero root count will never succeed, i.e. the page
-		 * will get thrown back on active_mmu_pages and we'll get stuck
-		 * in an infinite loop.
+		 * Invalid pages should never land back on the list of active
+		 * pages.  Skip the bogus page, otherwise we'll get stuck in an
+		 * infinite loop if the page gets put back on the list (again).
 		 */
-		if (sp->role.invalid && sp->root_count)
+		if (WARN_ON(sp->role.invalid))
 			continue;
 
 		/*
@@ -6015,7 +6017,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
-		if (sp->role.invalid && sp->root_count)
+		if (WARN_ON(sp->role.invalid))
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
-- 
2.26.0

