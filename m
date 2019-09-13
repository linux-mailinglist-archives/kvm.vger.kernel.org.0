Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB69BB174A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfIMCqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:58611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbfIMCqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159533"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 11/11] KVM: x86/mmu: Skip invalid pages during zapping iff root_count is zero
Date:   Thu, 12 Sep 2019 19:46:12 -0700
Message-Id: <20190913024612.28392-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not skip invalid shadow pages when zapping obsolete pages if the
pages' root_count has reached zero, in which case the page can be
immediately zapped and freed.

Update the comment accordingly.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a7b14750cde9..5e41b1f77a6d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5692,11 +5692,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			break;
 
 		/*
-		 * Since we are reversely walking the list and the invalid
-		 * list will be moved to the head, skip the invalid page
-		 * can help us to avoid the infinity list walking.
+		 * Skip invalid pages with a non-zero root count, zapping pages
+		 * with a non-zero root count will never succeed, i.e. the page
+		 * will get thrown back on active_mmu_pages and we'll get stuck
+		 * in an infinite loop.
 		 */
-		if (sp->role.invalid)
+		if (sp->role.invalid && sp->root_count)
 			continue;
 
 		/*
-- 
2.22.0

