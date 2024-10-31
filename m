Return-Path: <kvm+bounces-30201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 112199B7EAE
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 346E41C215D0
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B336D1B3F30;
	Thu, 31 Oct 2024 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULJr67lf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C860613342F;
	Thu, 31 Oct 2024 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389188; cv=none; b=Q2yEpoM/FsrBKj/h6JzMPXy8ur0LB4WiVdvZb0AswQQjKT6yR33fPOUpLkQT5izCtTm4LRCUPX4cmsb7CjuJ7+1t51ICl8Dy65wdi0R5P7B2JYJU7xHDrprpkBNe/CO4ZXMEQ7eyTDiLbfx6TTUu+TVd4R6VVJFNRkXa0OEWFsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389188; c=relaxed/simple;
	bh=e71oB15xt8MmnWusRVcbVCxjQ6isEJHcrB9uA5JO/lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzG24kNMjH+nbgwtpMPhyQthX2CZQHRdf/OoLdowa6RWAbxKcHb4THxAVm4Rs1KwCxxrxgUqbt8Xf6fOmU6Lq2AhbPVsw8GJaE7wg/9dDd2Epw7REwVu3sHnYZ6buRjAc5whX2IlYZHrK0bsmzOsUyIshX92WAYSPv8Sd8P1jTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULJr67lf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D37EC4DDEF;
	Thu, 31 Oct 2024 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730389188;
	bh=e71oB15xt8MmnWusRVcbVCxjQ6isEJHcrB9uA5JO/lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULJr67lf+4KQuW7r9rwL1KDzGbwqfAOwmRBvRkKoF5RTN0gheHbDyKT2Pu/35w7b4
	 5W6JIA5KGaiO/y/ZgVNQ1wZpH7ahk4rym+A9YNHjQinVWzt/1HlI6NI/DXdWoEzAC4
	 7nHahXbe1dWWH7yxUNX7YQDiPGi1aQC1Mg1C5xYB1liy7Ad1MCUMnlhbUIiP+1QTy5
	 L66yUwMWP8SkJ8VRO3NnnzWbzyTyI5rLpnzJ8lAEm4jLLmp2DVl1q982ezeajQGymB
	 0PXinBfOeZlEDSlcZ6G/MIYtUpuv6vsOQ/ji6PhM7TSIVD07W4QpR5NN87X5HZKKYS
	 TdnJpk0OBhJJw==
From: Amit Shah <amit@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com
Subject: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and FLUSH_RAP_ON_VMRUN
Date: Thu, 31 Oct 2024 16:39:25 +0100
Message-ID: <20241031153925.36216-3-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241031153925.36216-1-amit@kernel.org>
References: <20241031153925.36216-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

AMD CPUs with the ERAPS feature (Turin+) have a larger RSB (aka RAP).
While the new default RSB size is used on the host without any software
modification necessary, the RSB usage for guests is limited to the older
value (32 entries) for backwards compatibility.  With this patch, KVM
enables guest mode to also use the default number of entries by setting
the new ALLOW_LARGER_RAP bit in the VMCB.

The two cases for backward compatibility that need special handling are
nested guests, and guests using shadow paging (or when NPT is disabled):

For nested guests: the ERAPS feature adds host/guest tagging to entries
in the RSB, but does not distinguish between ASIDs.  On a nested exit,
the L0 hypervisor instructs the microcode (via another new VMCB bit,
FLUSH_RAP_ON_VMRUN) to flush the RSB on the next VMRUN to prevent RSB
poisoning attacks from an L2 guest to an L1 guest.  With that in place,
this feature can be exposed to guests.

For shadow paging guests: do not expose this feature to guests; only
expose if nested paging is enabled, to ensure context switches within
guests trigger TLB flushes on the CPU -- thereby ensuring guest context
switches flush guest RSB entries.  For shadow paging, the CPU's CR3 is
not used for guest processes, and hence cannot benefit from this
feature.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/include/asm/svm.h |  6 +++++-
 arch/x86/kvm/cpuid.c       | 15 ++++++++++++-
 arch/x86/kvm/svm/svm.c     | 44 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h     | 15 +++++++++++++
 4 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2b59b9951c90..f8584a63c859 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -129,7 +129,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
-	u8 reserved_2[3];
+	u8 erap_ctl;
+	u8 reserved_2[2];
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
@@ -175,6 +176,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define ERAP_CONTROL_ALLOW_LARGER_RAP 0
+#define ERAP_CONTROL_FLUSH_RAP 1
+
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..2c2a60964a2e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -797,6 +797,8 @@ void kvm_set_cpu_caps(void)
 		F(WRMSR_XX_BASE_NS)
 	);
 
+	if (tdp_enabled)
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
@@ -1357,8 +1359,19 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		unsigned int ebx_mask = 0;
+
+		entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+
+		/*
+		 * Bits 23:16 in EBX indicate the size of the RSB.
+		 * Expose the value in the hardware to the guest.
+		 */
+		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+			ebx_mask |= GENMASK(23, 16);
+
+		entry->ebx &= ebx_mask;
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..ecd290ff38f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1360,6 +1360,28 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
+	/*
+	 * If the hardware has a larger RSB, use it in the guest context as
+	 * well.
+	 *
+	 * When running nested guests: the hardware tags host and guest RSB
+	 * entries, but the entries are ASID agnostic.  Differentiating L1 and
+	 * L2 guests isn't possible in hardware.  To prevent L2->L1 RSB
+	 * poisoning attacks in this case, the L0 hypervisor must set
+	 * FLUSH_RAP_ON_VMRUN in the L1's VMCB on a nested #VMEXIT to ensure
+	 * the next VMRUN flushes the RSB.
+	 *
+	 * For shadow paging / NPT disabled case: the CPU's CR3 does not
+	 * contain the CR3 of the running guest process, and hence intra-guest
+	 * context switches will not cause a hardware TLB flush, which in turn
+	 * does not result in a guest RSB flush that the ERAPS feature
+	 * provides.  Do not expose ERAPS or the larger RSB to the guest in
+	 * this case, so the guest continues implementing software mitigations
+	 * as well as only sees 32 entries for the RSB.
+	 */
+	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)
+		vmcb_set_larger_rap(svm->vmcb);
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -3393,6 +3415,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -3559,6 +3582,27 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
+		if (boot_cpu_has(X86_FEATURE_ERAPS)
+		    && vmcb_is_larger_rap(svm->vmcb01.ptr)) {
+			/*
+			 * XXX a few further optimizations can be made:
+			 *
+			 * 1. In pre_svm_run() we can reset this bit when a hw
+			 * TLB flush has happened - any context switch on a
+			 * CPU (which causes a TLB flush) auto-flushes the RSB
+			 * - eg when this vCPU is scheduled on a different
+			 * pCPU.
+			 *
+			 * 2. This is also not needed in the case where the
+			 * vCPU is being scheduled on the same pCPU, but there
+			 * was a context switch between the #VMEXIT and VMRUN.
+			 *
+			 * 3. If the guest returns to L2 again after this
+			 * #VMEXIT, there's no need to flush the RSB.
+			 */
+			vmcb_set_flush_rap(svm->vmcb01.ptr);
+		}
+
 		vmexit = nested_svm_exit_special(svm);
 
 		if (vmexit == NESTED_EXIT_CONTINUE)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..8a7877f46dc5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -500,6 +500,21 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
+static inline void vmcb_set_flush_rap(struct vmcb *vmcb)
+{
+	__set_bit(ERAP_CONTROL_FLUSH_RAP, (unsigned long *)&vmcb->control.erap_ctl);
+}
+
+static inline void vmcb_set_larger_rap(struct vmcb *vmcb)
+{
+	__set_bit(ERAP_CONTROL_ALLOW_LARGER_RAP, (unsigned long *)&vmcb->control.erap_ctl);
+}
+
+static inline bool vmcb_is_larger_rap(struct vmcb *vmcb)
+{
+	return test_bit(ERAP_CONTROL_ALLOW_LARGER_RAP, (unsigned long *)&vmcb->control.erap_ctl);
+}
+
 static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
 {
 	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
-- 
2.47.0


