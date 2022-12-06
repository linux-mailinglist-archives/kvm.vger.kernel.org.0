Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1372C643E97
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLFI3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiLFI3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:29:43 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060216435
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670315383; x=1701851383;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xH88F9LFNkxAdFgGY4E5K1XM7tcl1F4mWQoygpSaKQc=;
  b=Bpp1g8ulBQhyECJhkjjsw3Zt9ThzRxLYGS/YJAbOpRiahkVrVphXuGLA
   wBGxWLfO8kTyK+5kd9dEGHeZZACwOsAiXAkgJNgVjac/IuLfc3OqNL/Cf
   dnH29vUARJKO/wlfLJC/Irig3eCo8K5USWcKl1rS0ifnlG1/HqPKCwJU7
   GKxp5wzVkFiFqMtsImrG5tGvhxqkbNZxo8kpiXsnVBvU8Ejh9LwRroKk6
   wueyfXYu5UZHjOnfZnN584EKTFoD2DNz7Vg5zWF50xW2NSgiu8tuIkJFR
   RNF59wj4FTtAPBMBVSSdANbRYHkDNgtUKcD1Xyqcfmgs04zfToDyzTwvU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="317710234"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="317710234"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 00:29:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734910613"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734910613"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Dec 2022 00:29:38 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct mode
Date:   Tue,  6 Dec 2022 15:39:51 +0800
Message-Id: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the code by introducing a wrapper, mmu_is_direct(),
instead of using vcpu->arch.mmu->root_role.direct everywhere.

Meanwhile, use temporary variable 'direct', in routines such
as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
vcpu->arch.mmu->root_role.direct repeatedly.

No functional change intended.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
 arch/x86/kvm/x86.c     |  9 +++++----
 arch/x86/kvm/x86.h     |  5 +++++
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4736d7849c60..d2d0fabdb702 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2280,7 +2280,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->root_role.direct)
+	    !mmu_is_direct(vcpu))
 		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
@@ -2677,7 +2677,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (mmu_is_direct(vcpu))
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
@@ -3918,7 +3918,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (mmu_is_direct(vcpu))
 		return;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
@@ -4147,7 +4147,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->root_role.direct;
+	arch.direct_map = mmu_is_direct(vcpu);
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
@@ -4157,17 +4157,16 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
+	bool direct = mmu_is_direct(vcpu);
 
-	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
-	      work->wakeup_all)
+	if ((work->arch.direct_map != direct) || work->wakeup_all)
 		return;
 
 	r = kvm_mmu_reload(vcpu);
 	if (unlikely(r))
 		return;
 
-	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	if (!direct && work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
@@ -5331,14 +5330,15 @@ EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
+	bool direct = mmu_is_direct(vcpu);
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
+	r = mmu_topup_memory_caches(vcpu, !direct);
 	if (r)
 		goto out;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	if (vcpu->arch.mmu->root_role.direct)
+	if (direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
@@ -5575,7 +5575,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-	bool direct = vcpu->arch.mmu->root_role.direct;
+	bool direct = mmu_is_direct(vcpu);
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
@@ -5606,8 +5606,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	 * paging in both guests. If true, we simply unprotect the page
 	 * and resume the guest.
 	 */
-	if (vcpu->arch.mmu->root_role.direct &&
-	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
+	if (((error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) &&
+	    direct) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72ac6bf05c8b..b95984a49700 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8420,6 +8420,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
+	bool direct = mmu_is_direct(vcpu);
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -8428,7 +8429,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct) {
+	if (!direct) {
 		/*
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
@@ -8461,7 +8462,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_release_pfn_clean(pfn);
 
 	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->root_role.direct) {
+	if (direct) {
 		unsigned int indirect_shadow_pages;
 
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -8529,7 +8530,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
-	if (!vcpu->arch.mmu->root_role.direct)
+	if (!mmu_is_direct(vcpu))
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
@@ -8830,7 +8831,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->root_role.direct) {
+		if (mmu_is_direct(vcpu)) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..aca11db10a8f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -171,6 +171,11 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
+static inline bool mmu_is_direct(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmu->root_role.direct;
+}
+
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
-- 
2.25.1

