Return-Path: <kvm+bounces-42456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EDFA789DA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFF8D18941C2
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCE12356B4;
	Wed,  2 Apr 2025 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXVL9Y7l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CC6235345;
	Wed,  2 Apr 2025 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743582541; cv=none; b=SKDQ3q8LdoObt4C9Aq4/W/VxQ8MjRH/216ZI/AiuGIbYGCiTfntEbHpcmrH8sRSOnJEfgFdMZ7M9qrxmOshAArD1JURttneyNQGsETonQBt587VaPsCWaYpaFLj+7ILadsF/K5H6ccraW+fvERWHKOaQdjp2MdR4QLixyCRX8gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743582541; c=relaxed/simple;
	bh=qsoMQHTj//pCEF/87fqAN8n1IMk0mkMhN1wdo63yAac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F87Ec9pArOIbJZfHxuRshL6x93Q2P0NkbU15frUjfJBczNiB0dyC2IKh0u3EmzeVduKhjPDyRf9eQMZyozm7DDKdyb6XKJf89gApbN8CyIDCG1KOCKVHZOIzPbc9Oj6cE8XKpmhJPH6jaTIg8zS0WJ3PSlEgHMr7NYUPBOZpvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXVL9Y7l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96072C4CEE5;
	Wed,  2 Apr 2025 08:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743582540;
	bh=qsoMQHTj//pCEF/87fqAN8n1IMk0mkMhN1wdo63yAac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXVL9Y7lFk+Vr5cwHTTczdcYJwFXEji3oXktkKKVUjHEC65na374szCiQO0sF1JOL
	 ZUbQSa393HNaPRUPg5cejHppprtXJXt12tIoLJLvv6+uZUrVYNKoa8jVQ1esR7CwgS
	 m4APczX0yvJoKXWkrxdOD8Do4YgqNCO7P2oRFxm/sDS+UsWGXShYw+B84cEPGu2pIR
	 rxdfHeMd23Kon1ZJDek+c04V7tegWapOXd7mgtd0+9G4bl9PA65AFlTNIs5sd6mv+R
	 RpcA5UwRhNeLzwA4ZUKeqcZtJBLmpWW/iUZkwiKkTUVFYy8ppgc0OGI1tKessyBnm/
	 EINSMWaB3UhCg==
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
Subject: [RFC PATCH v4 1/2] x86: kvm: svm: set up ERAPS support for guests
Date: Wed,  2 Apr 2025 10:28:32 +0200
Message-ID: <20250402082833.9835-2-amit@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402082833.9835-1-amit@kernel.org>
References: <20250402082833.9835-1-amit@kernel.org>
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

Additional note - not relevant for the hypervisor usecase - CPUs with
this feature also flush the RSB when the CR3 is updated (i.e. whenever
there's a context switch),  to prevent one userspace process poisoning
the RSB that may affect another process.

The hardware feature is always-on, and the host context uses the full
default RSB size without any software changes necessary.  The presence
of this feature allows software (both in host and guest contexts) to
drop all RSB filling routines in favour of the hardware doing it.
However, guests continue to use the older default RSB size and behaviour
for backwards compatibility.  The hypervisor needs to set a bit in the
VMCB in addition exposing the CPUID bits to allow guests to also use the
full default RSB size in addition to hardware RSB flushes.

There are two guest/host configurations that need to be addressed before
allowing a guest to use this feature: nested guests, and hosts using
shadow paging (or when NPT is disabled):

1. Nested guests: the ERAPS feature adds host/guest tagging to entries
   in the RSB, but does not distinguish between the guest ASIDs.  To
   prevent the case of an L2 guest poisoning the RSB to attack the L1
   guest, the CPU exposes a new VMCB bit (FLUSH_RAP_ON_VMRUN) that the
   hypervisor sets on a nested exit.  This results in the CPU flushing
   the contents of the RSB tagged 'guest' to protect the L1 guest from
   the L2 guest.

2. Hosts that disable NPT: the ERAPS feature also flushes the RSB
   entries when the CR3 is updated.  When using shadow paging, CR3
   updates within the guest do not update the CPU's CR3 register.  In
   this case, do not expose the ERAPS feature to guests, so the guests
   continue to fill the RSB.

This patch to KVM ensures both those conditions are met, and sets the
new ALLOW_LARGER_RAP VMCB bit that exposes this feature to the guest.
That allows the new default RSB size to be used in guest contexts as
well, and allows the guest to drop its RSB flushing routines.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               | 10 +++++++++-
 arch/x86/kvm/svm/svm.c             |  7 +++++++
 arch/x86/kvm/svm/svm.h             | 15 +++++++++++++++
 5 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..25c82d8fcf16 100644
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
index 5e4d4934c0d3..9662c055d9d8 100644
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
@@ -1758,8 +1761,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index d5d0c5c3300b..b5de6341080b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1369,6 +1369,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 
+	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)
+		vmcb_enable_extended_rap(svm->vmcb);
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -3422,6 +3425,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -3603,6 +3607,9 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
+		if (vmcb_is_extended_rap(svm->vmcb01.ptr))
+			vmcb_flush_guest_rap(svm->vmcb01.ptr);
+
 		vmexit = nested_svm_exit_special(svm);
 
 		if (vmexit == NESTED_EXIT_CONTINUE)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..0a29b0d294bb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -491,6 +491,21 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
+static inline void vmcb_flush_guest_rap(struct vmcb *vmcb)
+{
+	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
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


