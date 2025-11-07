Return-Path: <kvm+bounces-62279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E77C3C3F2B4
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 10:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 501BD188E638
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 09:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5E730217D;
	Fri,  7 Nov 2025 09:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHiaKIOc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE30184;
	Fri,  7 Nov 2025 09:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762507991; cv=none; b=Q2ShHkqdu/YM0/Zx3rJtp0SPZf7jDwa6I4LeruQYKybBj/1YuuLP0st6gM9YtLFFuv6jpevzwTazQxUb2DY6meosriglMvoF5Of+5afvrSPUJZwkI5C3r5mQLUDytM29FjD6byKYE9UkxXQ5sBzdV70CMSc7SOGZpkPha1NBE1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762507991; c=relaxed/simple;
	bh=czy9XKo+XAdeYmdn7xB6rMbOWop0t7PmagLzJn7PDdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8jrmQxM9iglXwPDb3iWihWCGGIpcIEwwYcyNB8pq91nXiB0D/ykAT5qPEnfcRJ9Mw+vrGTJzZHWVKJmvrsetPQ9+fNJvxdvbJGLOp0SqrfofB2ANYWYqiyaFRgdADYjMtYFTfnY3nkZ+OGoFEUi1cP/4IC+9UO83QH3Rre3U8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHiaKIOc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537ABC19422;
	Fri,  7 Nov 2025 09:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762507988;
	bh=czy9XKo+XAdeYmdn7xB6rMbOWop0t7PmagLzJn7PDdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHiaKIOcpqO3o02nXVQExIBnVDDnAJ9G7F0+zfXE5LPNlsC837Z9yxAaI2JU3j3+m
	 an6tYmelTNB68rFzUKIQYYTXLxH3EMQM6p+Txwa8oDo16UJZGk56r8jKPQwGCULXK2
	 zqMzfZZ8iFHm01E73BiYHUxQMUNM/Ruru4PlHDX5m9fNxqphxfS/xZwmX38JcovBGm
	 TBK/9iON4oLJFtcjZlccHBqXslXowStjRyEGFbEMU1+iYWMMiZ5PkzQJFmPx7imrp9
	 gqa+LVNFfl5F6MSpAYF6YVH5DwvSVGixepf4UuiiMRuq0tO6yLYXg2/1wiA2AjVheP
	 nTGOJSkA3GvXw==
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
Subject: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Date: Fri,  7 Nov 2025 10:32:39 +0100
Message-ID: <20251107093239.67012-2-amit@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107093239.67012-1-amit@kernel.org>
References: <20251107093239.67012-1-amit@kernel.org>
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

The hardware feature is always-on, and the host context uses the full
default RSB size without any software changes necessary.  The presence
of this feature allows software (both in host and guest contexts) to
drop all RSB filling routines in favour of the hardware doing it.

There are two guest/host configurations that need to be addressed before
allowing a guest to use this feature: nested guests, and hosts using
shadow paging (or when NPT is disabled):

1. Nested guests: the ERAPS feature adds host/guest tagging to entries
   in the RSB, but does not distinguish between the guest ASIDs.  To
   prevent the case of an L2 guest poisoning the RSB to attack the L1
   guest, the CPU exposes a new VMCB bit (CLEAR_RAP).  The next
   VMRUN with a VMCB that has this bit set causes the CPU to flush the
   RSB before entering the guest context.  Set the bit in VMCB01 after a
   nested #VMEXIT to ensure the next time the L1 guest runs, its RSB
   contents aren't polluted by the L2's contents.  Similarly, before
   entry into a nested guest, set the bit for VMCB02, so that the L1
   guest's RSB contents are not leaked/used in the L2 context.

2. Hosts that disable NPT: the ERAPS feature flushes the RSB entries on
   several conditions, including CR3 updates.  Emulating hardware
   behaviour on RSB flushes is not worth the effort for NPT=off case,
   nor is it worthwhile to enumerate and emulate every trigger the
   hardware uses to flush RSB entries.  Instead of identifying and
   replicating RSB flushes that hardware would have performed had NPT
   been ON, do not let NPT=off VMs use the ERAPS features.

This patch to KVM ensures both those caveats are addressed, and sets the
new ALLOW_LARGER_RAP VMCB bit that allows the CPU to operate with ERAPS
enabled in guest contexts.

This feature is documented in AMD APM Vol 2 (Pub 24593), in revisions
3.43 and later.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               |  8 +++++++-
 arch/x86/kvm/svm/nested.c          |  6 ++++++
 arch/x86/kvm/svm/svm.c             | 11 +++++++++++
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37a..edc76a489aae 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -467,6 +467,7 @@
 #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
 
 #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predictor Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 17f6c3fedeee..d4602ee4cf1f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -131,7 +131,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
-	u8 reserved_2[3];
+	u8 erap_ctl;
+	u8 reserved_2[2];
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
@@ -182,6 +183,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
+#define ERAP_CONTROL_CLEAR_RAP BIT(1)
+
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52524e0ca97f..93934d4f8f11 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1795,8 +1795,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->edx = 0;
+		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+			entry->ebx &= GENMASK(23, 16);
+		else
+			entry->ebx = 0;
+
 		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6443feab252..de51595e875c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -869,6 +869,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		}
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+		vmcb02->control.erap_ctl |= ERAP_CONTROL_CLEAR_RAP;
+
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
@@ -1164,6 +1167,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	kvm_nested_vmexit_handle_ibrs(vcpu);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+		vmcb01->control.erap_ctl |= ERAP_CONTROL_CLEAR_RAP;
+
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..ff110a1fb5f0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1147,6 +1147,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS) && npt_enabled)
+		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -3267,6 +3270,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -4321,6 +4325,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	}
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	if (cpu_feature_enabled(X86_FEATURE_ERAPS))
+		svm->vmcb->control.erap_ctl &= ~ERAP_CONTROL_CLEAR_RAP;
+
 	vmcb_mark_all_clean(svm->vmcb);
 
 	/* if exit due to PF check for async PF */
@@ -5265,6 +5272,10 @@ static __init void svm_set_cpu_caps(void)
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
 
+	/* CPUID 0x80000021 */
+	if (npt_enabled)
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
+
 	/*
 	 * Clear capabilities that are automatically configured by common code,
 	 * but that require explicit SVM support (that isn't yet implemented).
-- 
2.51.1


