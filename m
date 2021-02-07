Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68275312158
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 05:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBGEn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 23:43:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:51358 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhBGEn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 23:43:28 -0500
IronPort-SDR: jHaulizGzHvYvaVPL8f95MvnA2+eOyRS2aRGHvTWEyp5nqiULqy7GMAcjoU6r7QNZjz5Gz7khw
 AOG9hGt6GpZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="160738821"
X-IronPort-AV: E=Sophos;i="5.81,158,1610438400"; 
   d="scan'208";a="160738821"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 20:41:41 -0800
IronPort-SDR: zLoETFuczy8Gk4DSBOAKv2O33JzVPzOSRfVuX+iLAGm+5/ZXoQfQmVNt6qK+HgCWel57jEV96t
 Izy++QQ5Tacg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,158,1610438400"; 
   d="scan'208";a="374846616"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.148])
  by fmsmga008.fm.intel.com with ESMTP; 06 Feb 2021 20:41:40 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
Date:   Sun,  7 Feb 2021 20:22:54 +0800
Message-Id: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In shadow page table, only leaf SPs may be marked as unsync.
And for non-leaf SPs, we use unsync_children to keep the number
of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
shall always be zero for the root SP, , hence no need to check
it. Instead, a warning inside mmu_sync_children() is added, in
case someone incorrectly used it.

Also, clarify the mmu_need_write_protect(), by moving the warning
into kvm_unsync_page().

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
Changes in V2:
- warnings added based on Sean's suggestion.

 arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86af582..c4797a00cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
+	/*
+	 * Only 4k SPTEs can directly be made unsync, the parent pages
+	 * should never be unsyc'd.
+	 */
+	WARN_ON_ONCE(sp->unsync);
+
 	while (mmu_unsync_walk(parent, &pages)) {
 		bool protected = false;
 
@@ -2502,6 +2508,8 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
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
1.9.1

