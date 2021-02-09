Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8E314B88
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 10:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhBIJ0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 04:26:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:53959 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhBIJVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 04:21:46 -0500
IronPort-SDR: K6Dgfz/b2BTMnL3io6eKqqwYcX64bAE1ykXj5LprFnRCpekaaMd1UWMvoxJkRZWtLtPIAmQs5r
 tGk3ub347WWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="179293958"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="179293958"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 01:20:00 -0800
IronPort-SDR: /Yng3oo8OGEW+f8mThOaJfZqvh6dvvjoINZvY8Mo6ZXCEOWGCH3ABS7tYP9xw4NKFaZp4b8rTM
 iCpo+c/tUpWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="396042075"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.148])
  by orsmga008.jf.intel.com with ESMTP; 09 Feb 2021 01:19:57 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: [PATCH v3] KVM: x86/MMU: Do not check unsync status for root SP.
Date:   Wed, 10 Feb 2021 01:01:11 +0800
Message-Id: <20210209170111.4770-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In shadow page table, only leaf SPs may be marked as unsync;
instead, for non-leaf SPs, we store the number of unsynced
children in unsync_children. Therefore, in kvm_mmu_sync_root(),
sp->unsync shall always be zero for the root SP and there is
no need to check it. Remove the check, and add a warning
inside mmu_sync_children() to assert that the flags are used
properly.

While at it, move the warning from mmu_need_write_protect()
to kvm_unsync_page().

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86af58294272..5f482af125b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
+	/*
+	 * Only 4k SPTEs can directly be made unsync, the parent pages
+	 * should never be unsyc'd.
+	 */
+	WARN_ON_ONCE(parent->unsync);
+
 	while (mmu_unsync_walk(parent, &pages)) {
 		bool protected = false;
 
@@ -2502,6 +2508,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
 
 static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
+	WARN_ON(sp->role.level != PG_LEVEL_4K);
+
 	trace_kvm_mmu_unsync_page(sp);
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
@@ -2524,7 +2532,6 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (sp->unsync)
 			continue;
 
-		WARN_ON(sp->role.level != PG_LEVEL_4K);
 		kvm_unsync_page(vcpu, sp);
 	}
 
@@ -3406,8 +3413,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		 * mmu_need_write_protect() describe what could go wrong if this
 		 * requirement isn't satisfied.
 		 */
-		if (!smp_load_acquire(&sp->unsync) &&
-		    !smp_load_acquire(&sp->unsync_children))
+		if (!smp_load_acquire(&sp->unsync_children))
 			return;
 
 		write_lock(&vcpu->kvm->mmu_lock);
-- 
2.17.1

