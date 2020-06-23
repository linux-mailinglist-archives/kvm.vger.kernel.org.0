Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26B9205BD9
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgFWTfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:11007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387430AbgFWTfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:44 -0400
IronPort-SDR: sJ9sRrvxb1h5Okc9pcBYB6agzuUxgWFnBl5k//utyzCFXv1OdBKibJm+1+i3gUy5SWrC7W9i6J
 im2bQ1BqbqXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="142430969"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="142430969"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:35:44 -0700
IronPort-SDR: f/IL09ce9Xl12I9sC84qWOGB+ALwlnlDkcqdbVGwKzExiEQfaqkLOU6xbOyYA/jWnWsc4Xx629
 B2L/gsVdejgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="263428289"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 12:35:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: x86/mmu: Don't put invalid SPs back on the list of active pages
Date:   Tue, 23 Jun 2020 12:35:39 -0700
Message-Id: <20200623193542.7554-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623193542.7554-1-sean.j.christopherson@intel.com>
References: <20200623193542.7554-1-sean.j.christopherson@intel.com>
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
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3dd0af7e7515..8e7df4ed4b55 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2757,10 +2757,23 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	if (!sp->root_count) {
 		/* Count self */
 		(*nr_zapped)++;
-		list_move(&sp->link, invalid_list);
+
+		/*
+		 * Already invalid pages (previously active roots) are not on
+		 * the active page list.  See list_del() in the "else" case of
+		 * !sp->root_count.
+		 */
+		if (sp->role.invalid)
+			list_add(&sp->link, invalid_list);
+		else
+			list_move(&sp->link, invalid_list);
 		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
-		list_move(&sp->link, &kvm->arch.active_mmu_pages);
+		/*
+		 * Remove the active root from the active page list, the root
+		 * will be explicitly freed when the root_count hits zero.
+		 */
+		list_del(&sp->link);
 
 		/*
 		 * Obsolete pages cannot be used on any vCPUs, see the comment
@@ -5727,12 +5740,11 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
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
@@ -6010,7 +6022,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
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

