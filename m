Return-Path: <kvm+bounces-46698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F731AB8AC0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005323B04E6
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A202218AB4;
	Thu, 15 May 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecmDgqjJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9CD211A0D;
	Thu, 15 May 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747322832; cv=none; b=GgFZFl7j0r2kUJtrDvRwseHCiOevnXiMBHk/2jiTEUPOfY1RhkgvwhP3PEugh+j0SQYjt0uWOI5BgAX8lST5bvrVYwZRFuRvqP4n07DG17Jea3h4pyfyxFOD/pIq3ZCHs+Eu//+VdzwojKYJXj7JWJjmEw/o7jDWnllSJEw2BBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747322832; c=relaxed/simple;
	bh=nr+4cN5p4XIOjM4+t0xr2Xv0tBCCyVsUxlGcnPT+xIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfb115oYJjmCdj6EVnbD1+UNqMulGWXKYLtM2OW8eIp7kehjlEsGNTvE6EbGbBBi47tUA6543O/WlKvBr6knQye6asFS0r8XF9rmESdHiwvbJXtTtx5ZgAUsJJ91EraIoLWNGXnU5uDLgr3+qWCrD9tFt8WmEF4diLXagw/DN1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecmDgqjJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B114CC4CEEB;
	Thu, 15 May 2025 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747322832;
	bh=nr+4cN5p4XIOjM4+t0xr2Xv0tBCCyVsUxlGcnPT+xIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecmDgqjJXLtAXOvJYVKnm9nqHyEROU+CH/vYkZblmoNwdjdP9MR/XCEF6XP/rnTpX
	 ogRWOaCNY9hMw0qv4onCLCT1zsPT2y25U7rjVZg8l9dqe8LgnN6UuFxgXFcoPi4DFh
	 267FFw6sbXpdhYjSDC5PQo/pTzlaZghWarts+hyXoKEjALdMKt+6+nfbn9pXFO1k60
	 pnCRil0ZISWIuk5rspXnhfFvZmmKOsxeTO7tI0+j4qznewT3DAqhm31cmUWOd+3mQu
	 PgYV0OkJywkFHoCx4YX4FHEgdAg+ibB3Ov+BfTc5TXsXAza4cgb1ziPDJfs8TfLIxY
	 AJCOZB2j/XI8g==
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
Subject: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
Date: Thu, 15 May 2025 17:26:21 +0200
Message-ID: <20250515152621.50648-2-amit@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515152621.50648-1-amit@kernel.org>
References: <20250515152621.50648-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

AMD CPUs with the Enhanced Return Address Predictor (ERAPS) feature
Zen5+) obviate the need for FILL_RETURN_BUFFER sequences right after
VMEXITs.  The feature adds guest/host tags to entries in the RSB (a.k.a.
RAP).  This helps with speculation protection across the VM boundary,
and it also preserves host and guest entries in the RSB that can improve
software performance (which would otherwise be flushed due to the
FILL_RETURN_BUFFER sequences).  This feature also extends the size of
the RSB from the older standard (of 32 entries) to a new default
enumerated in CPUID leaf 0x80000021:EBX bits 23:16 -- which is 64
entries in Zen5 CPUs.

In addition to flushing the RSB across VMEXIT boundaries, CPUs with
this feature also flush the RSB when the CR3 is updated (i.e. whenever
there's a context switch), to prevent one userspace process poisoning
the RSB that may affect another process.  The relevance of this for KVM
is explained below in caveat 2.

The hardware feature is always-on, and the host context uses the full
default RSB size without any software changes necessary.  The presence
of this feature allows software (both in host and guest contexts) to
drop all RSB filling routines in favour of the hardware doing it.

For guests to observe and use this feature, the hypervisor needs to
expose the CPUID bit, and also set a VMCB bit.  Without one or both of
those, guests continue to use the older default RSB size and behaviour
for backwards compatibility.  This means the hardware RSB size is
limited to 32 entries for guests that do not have this feature exposed
to them.

There are two guest/host configurations that need to be addressed before
allowing a guest to use this feature: nested guests, and hosts using
shadow paging (or when NPT is disabled):

1. Nested guests: the ERAPS feature adds host/guest tagging to entries
   in the RSB, but does not distinguish between the guest ASIDs.  To
   prevent the case of an L2 guest poisoning the RSB to attack the L1
   guest, the CPU exposes a new VMCB bit (FLUSH_RAP_ON_VMRUN).  The next
   VMRUN with a VMCB that has this bit set causes the CPU to flush the
   RSB before entering the guest context.  In this patch, we set the bit
   in VMCB01 after a nested #VMEXIT to ensure the next time the L1 guest
   runs, its RSB contents aren't polluted by the L2's contents.
   Similarly, when an exit from L1 to the hypervisor happens, we set
   that bit for VMCB02, so that the L1 guest's RSB contents are not
   leaked/used in the L2 context.

2. Hosts that disable NPT: the ERAPS feature also flushes the RSB
   entries when the CR3 is updated.  When using shadow paging, CR3
   updates within the guest do not update the CPU's CR3 register.  In
   this case, do not expose the ERAPS feature to guests, and the guests
   continue with existing mitigations to fill the RSB.

This patch to KVM ensures both those caveats are addressed, and sets the
new ALLOW_LARGER_RAP VMCB bit that exposes this feature to the guest.
That allows the new default RSB size to be used in guest contexts as
well, and allows the guest to drop its RSB flushing routines.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               | 10 +++++++++-
 arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h             | 20 ++++++++++++++++++++
 5 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 39e61212ac9a..57264d5ab162 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -457,6 +457,7 @@
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
 
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predictor Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..cf6a94e64e58 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -130,7 +130,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
-	u8 reserved_2[3];
+	u8 erap_ctl;
+	u8 reserved_2[2];
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
@@ -176,6 +177,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
+#define ERAP_CONTROL_FLUSH_RAP BIT(1)
+
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 571c906ffcbf..0cca1865826e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1187,6 +1187,9 @@ void kvm_set_cpu_caps(void)
 		F(SRSO_USER_KERNEL_NO),
 	);
 
+	if (tdp_enabled)
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
+
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
 		F(PERFMON_V2),
 	);
@@ -1756,8 +1759,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+			entry->ebx &= GENMASK(23, 16);
+		else
+			entry->ebx = 0;
+
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a89c271a1951..a2b075ed4133 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1363,6 +1363,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
+	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)
+		vmcb_enable_extended_rap(svm->vmcb);
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -3482,6 +3485,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -3663,6 +3667,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
+		if (vmcb_is_extended_rap(svm->vmcb01.ptr)) {
+			vmcb_set_flush_guest_rap(svm->vmcb01.ptr);
+			vmcb_clr_flush_guest_rap(svm->nested.vmcb02.ptr);
+		}
+
 		vmexit = nested_svm_exit_special(svm);
 
 		if (vmexit == NESTED_EXIT_CONTINUE)
@@ -3670,6 +3679,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 		if (vmexit == NESTED_EXIT_DONE)
 			return 1;
+	} else {
+		if (vmcb_is_extended_rap(svm->vmcb01.ptr) && svm->nested.initialized) {
+			vmcb_set_flush_guest_rap(svm->nested.vmcb02.ptr);
+			vmcb_clr_flush_guest_rap(svm->vmcb01.ptr);
+		}
 	}
 
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f16b068c4228..7f44f7c9b1d5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -493,6 +493,26 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
+static inline void vmcb_set_flush_guest_rap(struct vmcb *vmcb)
+{
+	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
+}
+
+static inline void vmcb_clr_flush_guest_rap(struct vmcb *vmcb)
+{
+	vmcb->control.erap_ctl &= ~ERAP_CONTROL_FLUSH_RAP;
+}
+
+static inline void vmcb_enable_extended_rap(struct vmcb *vmcb)
+{
+	vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
+}
+
+static inline bool vmcb_is_extended_rap(struct vmcb *vmcb)
+{
+	return !!(vmcb->control.erap_ctl & ERAP_CONTROL_ALLOW_LARGER_RAP);
+}
+
 static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
 {
 	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VGIF) &&
-- 
2.49.0


