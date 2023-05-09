Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726DE6FC8B2
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbjEIOTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbjEIOTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:19:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3D63585;
        Tue,  9 May 2023 07:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641922; x=1715177922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=lYfoWretd3oIEUlT2oKkOmxI8HPDaPMFZhzR+BA1bdY=;
  b=R1ZP1/et5p5gxKrL6cQVByFWsCE9Pr7gQOEycyg9VEvl5gnd75Y0CKVc
   RI1xUDy9YwF3/sTa4z3ARdRJ80SFvJVJVGGVMclyRY34+zzLjlgoRfjYU
   nMkZPu6/oqHbn/McwLWBrRMf0wOiZVsT8/T46JsHt73T5gxb859nFxiMT
   7JyFDfJ+B4/B4arfDwSd0ERGkgYwiooi0FzXb1kCENbODVdxtbIW9Dnas
   gfB8uk3cV+yxkWRHyJQMaQqgfKPp71H4Ltm1Y4NuMiTeATP7j8dY2P8Jk
   HBINYDY00rGbjE2e8F39j1dW+PX8Ye9a0OrS1P9QLCNqgknQjztYjPYtM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="330300180"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="330300180"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:18:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788546139"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="788546139"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:18:40 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 6/6] KVM: x86/mmu: use per-VM based MTRR for EPT
Date:   Tue,  9 May 2023 21:53:43 +0800
Message-Id: <20230509135343.1925-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509134825.1523-1-yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM mmu checking guest MTRR, check the per-VM one and only zap EPT if
per-VM MTRR (MTRR of vCPU 0) changes.

Before this patch, if there're noncoherent DMA, EPT violation handler
will reference the guest MTRR state of the vCPU causing the violation.
EPT leaf entries will be zapped if MTRR settings of each vCPU changes.
But as one EPT leaf entry can only have one memory type, it may still cause
problem if vCPUs have different MTRR state.
So, insane guests without consistent MTRR state across vCPUs will only
cause problem to its own.

Therefore, this patch switches to use per-VM MTRR and only zap EPT when
this per-VM MTRR changes, which can avoid several EPT zap during guest
boot.

A reference data (average of 10 times of guest boot) is as below:

Physical CPU frequency: 3100 MHz
       | vCPU cnt |  memory | EPT zap cnt | EPT zap cycles | bootup time
before |     8    |   2G    |    84       |     4164.57M   |   19.38s
after  |     8    |   2G    |    14       |       16.07M   |   18.83s
before |     8    |  16G    |    84       |     4163.38M   |   24.51s
after  |     8    |  16G    |    14       |       16.68M   |   23.94s

Legends:
before:         before this patch
after:          after this patch
vCPU cnt:       guest vCPU count of a VM
memory:         guest memory size
EPT zap cnt:    the count of EPT zap caused by update_mtrr() during guest
                boot
EPT zap cycles: the cpu cyles of EPT zap caused by update_mtrr() during
                guest boot
bootup time:    guest bootup time, measured from starting QEMU to guest
                rc.local

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/mtrr.c    | 88 +++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.h     |  4 +-
 4 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2706754794d1..4b05ce1f0241 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4532,7 +4532,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			gfn_t base = gfn_round_for_level(fault->gfn,
 							 fault->max_level);
 
-			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
+			if (kvm_mtrr_check_gfn_range_consistency(vcpu->kvm, base, page_num))
 				break;
 		}
 	}
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 1ae80c756797..9be8ed40e226 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -105,7 +105,7 @@ static u8 mtrr_default_type(struct kvm_mtrr *mtrr_state)
 	return mtrr_state->deftype & IA32_MTRR_DEF_TYPE_TYPE_MASK;
 }
 
-static u8 mtrr_disabled_type(struct kvm_vcpu *vcpu)
+static u8 mtrr_disabled_type(struct kvm *kvm)
 {
 	/*
 	 * Intel SDM 11.11.2.2: all MTRRs are disabled when
@@ -117,10 +117,7 @@ static u8 mtrr_disabled_type(struct kvm_vcpu *vcpu)
 	 * enable MTRRs and it is obviously undesirable to run the
 	 * guest entirely with UC memory and we use WB.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_MTRR))
-		return MTRR_TYPE_UNCACHABLE;
-	else
-		return MTRR_TYPE_WRBACK;
+	return kvm->arch.has_mtrr ? MTRR_TYPE_UNCACHABLE : MTRR_TYPE_WRBACK;
 }
 
 /*
@@ -310,6 +307,12 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	gfn_t start, end;
 	int index;
 
+	/*  MTRR is consistency between all the processors in the system
+	 *  so just update the TDP according to MTRR settings in vcpu0
+	 */
+	if (vcpu->vcpu_id)
+		return;
+
 	if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
 	      !kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return;
@@ -635,10 +638,11 @@ static void mtrr_lookup_next(struct mtrr_iter *iter)
 	for (mtrr_lookup_init(_iter_, _mtrr_, _gpa_start_, _gpa_end_); \
 	     mtrr_lookup_okay(_iter_); mtrr_lookup_next(_iter_))
 
-u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
+u8 kvm_mtrr_get_guest_memory_type(struct kvm *kvm, gfn_t gfn)
 {
-	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	struct kvm_mtrr *mtrr_state;
 	struct mtrr_iter iter;
+	int srcu_idx;
 	u64 start, end;
 	int type = -1;
 	const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
@@ -647,6 +651,16 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 	start = gfn_to_gpa(gfn);
 	end = start + PAGE_SIZE;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	mtrr_state = srcu_dereference(kvm->arch.mtrr_state, &kvm->srcu);
+	/* kvm mtrr_state points to mtrr_state of vcpu0.
+	 * should not reach here unless vcpu0 is destroyed
+	 */
+	if (WARN_ON(!mtrr_state)) {
+		type = mtrr_disabled_type(kvm);
+		goto out;
+	}
+
 	mtrr_for_each_mem_type(&iter, mtrr_state, start, end) {
 		int curr_type = iter.mem_type;
 
@@ -694,12 +708,16 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 		return MTRR_TYPE_WRBACK;
 	}
 
-	if (iter.mtrr_disabled)
-		return mtrr_disabled_type(vcpu);
+	if (iter.mtrr_disabled) {
+		type = mtrr_disabled_type(kvm);
+		goto out;
+	}
 
 	/* not contained in any MTRRs. */
-	if (type == -1)
-		return mtrr_default_type(mtrr_state);
+	if (type == -1) {
+		type = mtrr_default_type(mtrr_state);
+		goto out;
+	}
 
 	/*
 	 * We just check one page, partially covered by MTRRs is
@@ -707,38 +725,64 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 	 */
 	WARN_ON(iter.partial_map);
 
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return type;
 }
 EXPORT_SYMBOL_GPL(kvm_mtrr_get_guest_memory_type);
 
-bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
+bool kvm_mtrr_check_gfn_range_consistency(struct kvm *kvm, gfn_t gfn,
 					  int page_num)
 {
-	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	struct kvm_mtrr *mtrr_state;
 	struct mtrr_iter iter;
+	int srcu_idx;
 	u64 start, end;
 	int type = -1;
+	int ret;
 
 	start = gfn_to_gpa(gfn);
 	end = gfn_to_gpa(gfn + page_num);
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	mtrr_state = srcu_dereference(kvm->arch.mtrr_state, &kvm->srcu);
+	/* kvm mtrr_state points to mtrr_state of vcpu0.
+	 * should not reach here unless vcpu0 is destroyed
+	 */
+	if (WARN_ON(!mtrr_state)) {
+		ret = true;
+		goto out;
+	}
+
 	mtrr_for_each_mem_type(&iter, mtrr_state, start, end) {
 		if (type == -1) {
 			type = iter.mem_type;
 			continue;
 		}
 
-		if (type != iter.mem_type)
-			return false;
+		if (type != iter.mem_type) {
+			ret = false;
+			goto out;
+		}
 	}
 
-	if (iter.mtrr_disabled)
-		return true;
+	if (iter.mtrr_disabled) {
+		ret = true;
+		goto out;
+	}
 
-	if (!iter.partial_map)
-		return true;
+	if (!iter.partial_map) {
+		ret = true;
+		goto out;
+	}
 
-	if (type == -1)
-		return true;
+	if (type == -1) {
+		ret = true;
+		goto out;
+	}
 
-	return type == mtrr_default_type(mtrr_state);
+	ret = (type == mtrr_default_type(mtrr_state));
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	return ret;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..2ae9d5f3da99 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7540,7 +7540,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 	}
 
-	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
+	return kvm_mtrr_get_guest_memory_type(vcpu->kvm, gfn) << VMX_EPT_MT_EPTE_SHIFT;
 }
 
 static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx, u32 new_ctl)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d0a7e50de739..a7acfeacbc04 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -310,11 +310,11 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu);
 void kvm_mtrr_init(struct kvm_vcpu *vcpu);
 void kvm_mtrr_destroy(struct kvm_vcpu *vcpu);
-u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
+u8 kvm_mtrr_get_guest_memory_type(struct kvm *kvm, gfn_t gfn);
 bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
-bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
+bool kvm_mtrr_check_gfn_range_consistency(struct kvm *kvm, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
-- 
2.17.1

