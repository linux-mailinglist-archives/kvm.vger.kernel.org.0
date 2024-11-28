Return-Path: <kvm+bounces-32746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8274A9DB8A5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 425C028497C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EBA1ADFF9;
	Thu, 28 Nov 2024 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIUPHRE7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3201AB533;
	Thu, 28 Nov 2024 13:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732800540; cv=none; b=Z5Aj7MMTE3FnQRCfYV2OSBSG5DjLC3q/d1gXVW07r7WFR51O324GTKrHadCY0LyePJwG0wjptbZx1k1ZZ5LYXfoXX/2jKr5Ep0r5XkYxfhMo8fNW2YUqpIFnVvD7D7ZDdj1RmLHTzf0nnYbiJ6U/eQDOPZn9roswm7w7qPlL6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732800540; c=relaxed/simple;
	bh=I1ID2WIuqHpOcZgLW8clxhoQ8zafa7qAXA+I09IFfNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwbaImLAvXtTYQbtNbJtNh0AwS1lkwR3IpM26MBgxbKqsqp2saySr2zRmaVn/wGF91SYgHEUawr4NnQi1ZsG47Bbu5GRYnDWjUnn8r312T+1hY538xWSs/Aa0Jb2KPKUsbmFghsorGLPl2MEfWmqEG9qfM8TkpA8dbE4xP6l9Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIUPHRE7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6D1C4CED4;
	Thu, 28 Nov 2024 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732800539;
	bh=I1ID2WIuqHpOcZgLW8clxhoQ8zafa7qAXA+I09IFfNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIUPHRE7entb9mnNYgvr81LaD3zOMSV5SSkp7vV/fPRp0PTTmMaH+16L4W/m00+f5
	 oqgtM665qYGS570CrPZF1U7ZGbXv6Gi6as6hHiMQtA9UgI9U5sztXRXaZO4XulmCY8
	 jPrRU4TeR7YDL8vuzGAsjQ7Yz0qnTz/y7SVk+9/LwesZ/2x6PnRmi5XAyP2C+6NcCX
	 0vBuxaJeExBXYNB2ZbAdPiS9qmb1e4eTs6Kh99iU2pR+lAdHXRUeP3SFhGP0UJH4jG
	 V3uehfd6XS9E06iCz27V7bf0yz6hgIBgI/kA+KFDJVzVCK+922v/GIxDTiZXnqErZi
	 kRdgfJ6DB5VUg==
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
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [RFC PATCH v3 2/2] x86: kvm: svm: advertise ERAPS (larger RSB) support to guests
Date: Thu, 28 Nov 2024 14:28:34 +0100
Message-ID: <20241128132834.15126-3-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241128132834.15126-1-amit@kernel.org>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <20241128132834.15126-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

AMD CPUs with the ERAPS feature (Zen5+) have a larger RSB (aka RAP).
While the new default RSB size is used on the host without any software
modification necessary, the RSB size for guests is limited to the older
value (32 entries) for backwards compatibility.  With this patch, KVM
enables guest mode to also use the default number of entries by setting
the new ALLOW_LARGER_RAP bit in the VMCB.

The two cases for backward compatibility that need special handling are
nested guests, and guests using shadow paging (or when NPT is disabled):

For nested guests: the ERAPS feature adds host/guest tagging to entries
in the RSB, but does not distinguish between ASIDs.  On a nested exit,
the L0 hypervisor instructs the hardware (via another new VMCB bit,
FLUSH_RAP_ON_VMRUN) to flush the RSB on the next VMRUN to prevent RSB
poisoning attacks from an L2 guest to an L1 guest.  With that in place,
this feature can be exposed to guests.

For shadow paging guests: do not expose this feature to guests; only
expose if nested paging is enabled, to ensure a context switch within
a guest triggers a context switch on the CPU -- thereby ensuring guest
context switches flush guest RSB entries.  For shadow paging, the CPU's
CR3 is not used for guest processes, and hence cannot benefit from this
feature.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/include/asm/svm.h |  6 +++++-
 arch/x86/kvm/cpuid.c       | 18 ++++++++++++++++--
 arch/x86/kvm/svm/svm.c     | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h     | 15 +++++++++++++++
 4 files changed, 65 insertions(+), 3 deletions(-)

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
index 097bdc022d0f..dd589670a716 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -803,6 +803,8 @@ void kvm_set_cpu_caps(void)
 		F(WRMSR_XX_BASE_NS)
 	);
 
+	if (tdp_enabled)
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
@@ -1362,10 +1364,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x80000020:
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
-	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+	case 0x80000021: {
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
+	}
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
 		union cpuid_0x80000022_ebx ebx;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..9b055de079cb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1360,6 +1360,13 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
+	/*
+	 * If the hardware has a larger RSB, use it in the guest context as
+	 * well.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_ERAPS) && npt_enabled)
+		vmcb_set_larger_rap(svm->vmcb);
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -3395,6 +3402,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -3561,6 +3569,27 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
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


