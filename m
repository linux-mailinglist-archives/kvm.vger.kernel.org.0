Return-Path: <kvm+bounces-58259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0FA4B8B84D
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21AE1A819F1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823002FFFB2;
	Fri, 19 Sep 2025 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ORo1mG1W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD92FFF8B
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321243; cv=none; b=gcSgSQokcbuZW/9OhB/s6YPj6WrfUxQulkS1satN68suSyEAV7p9gQ/LuyCsA6RWHUlFb4qInOX4Jytu0tik8W65GlIPaRht0zOhFKJJtSHe1CKg8FmHBECrnw7AH2az3FcHMwKFy8+4Hw5yC+XhV20xF23oogLPv8b34T4V4b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321243; c=relaxed/simple;
	bh=XfJrhk1n3kRk/UlDU4xmYWmCpho5OCt3/GJ8TH3UtvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SBjRFlK0HDvkj3r+o4lDDPFXhZltsmqZ1hdSdkXEdgJno4laWzthDzlZzlQ0mJDgUfYrJsixvhe/n+d7zbPOuIjqG7kzU/9gphztqLaGzqcr3iVdaIWtGiweTIUnIL6ztVglAT3UmESenMZ7gQXsObqE8mb5mHlS1HzN1dGTCUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ORo1mG1W; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-330a4d5c4efso860371a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321241; x=1758926041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8kqhi1JD3QmHgz3kxUx5l9MmZIyWLcKKHvCESvJAmjQ=;
        b=ORo1mG1W8WFLvJluxDJCQ0dSf4ar9z7ct+O+63Vs+XU0cf/9fIdMc4WoG8gagVmwsY
         N0QE6SsIfa7tyytikRsnUrair/WKk1obBsPiL26lt6zRTI3Or5tIcrN9qj/B/B4Pii2t
         n5xZfaA8p86Iaiixy0bcnWd9Xxe9p0WMmpX+6mYmfQfvzVOVYDYDbVuJO5UWUJnFJrzm
         K80Adux+/HL5fr8nDcsEEG9pjChELehou5eOZxZLGMsZIdho0v3jbNQiNoFueRZ8pgv/
         xvoHqc5R1qczQaUZ+OPWwKnZ1TR6Sp1KrQ/BQXVkiwlkxakj0deNZzSt+ZTgbFWz+1u7
         S1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321241; x=1758926041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kqhi1JD3QmHgz3kxUx5l9MmZIyWLcKKHvCESvJAmjQ=;
        b=vdhNAIitYwUy5HLwyLvaAcBRKitDRrc1IP5wuLrFEXGrtywzCBLNkQvwrB3f9STyC1
         LR3FthXXpQNd0a92vDuZaaVbOR8IGLIRNUs9e/QkKd7sxFfSQ331VsRR563pXaK5bqvT
         VC75MNJ0LsRJJk83WOHXfyzuLZDrD9QEm6w7GFdB/qXKn9Zd7+v83Sx2xdKckirda8kn
         AQYJmZ0VK/drYhklNyh8qeiuFE6KkpuKHght9t6EOeoPQppEujxRUltLXwpo5YfW7rXk
         O691O5RSzoIS5cN7sjW+s6yV79cznKp5Uk+amwAG93jOdTPLnxVQ7ivy85luV/9+cJCp
         3Qcw==
X-Gm-Message-State: AOJu0Yzr10MuHlUKLQ1u/iTW4SXQeWpecwKa53jkfAya9luq5+6bvGbK
	szzTc5TKw0dx5r3CXYv/zyHA7An6CMmVNDBnPzgagUb7EIyKk5JGEm+U1RjPrbAor8mew9Dpwcz
	FPDsjqQ==
X-Google-Smtp-Source: AGHT+IF6QYLX33wuMQYK42eRORiBumlN60G5rSQC+45wsSGH+z+X34t++k9a/tBmDBzfbe47yD0zrWKQIjY=
X-Received: from pjbnd17.prod.google.com ([2002:a17:90b:4cd1:b0:32e:b34b:92eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57ce:b0:327:83e1:5bf
 with SMTP id 98e67ed59e1d1-3309836301bmr5341557a91.28.1758321241091; Fri, 19
 Sep 2025 15:34:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:38 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-32-seanjc@google.com>
Subject: [PATCH v16 31/51] KVM: nVMX: Prepare for enabling CET support for
 nested guest
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
to enable CET for nested VM.

vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
to resume L2, that way correct CET states can be observed by one another.

Please note that consistency checks regarding CET state during VM-Entry
will be added later to prevent this patch from becoming too large.
Advertising the new CET VM_ENTRY/EXIT control bits are also be deferred
until after the consistency checks are added.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 77 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.c |  6 +++
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++-
 arch/x86/kvm/vmx/vmx.c    |  2 +
 arch/x86/kvm/vmx/vmx.h    |  3 ++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b644f4599f70..11e5d3569933 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -721,6 +721,24 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_MPERF, MSR_TYPE_R);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_U_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2521,6 +2539,32 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	}
 }
 
+static void vmcs_read_cet_state(struct kvm_vcpu *vcpu, u64 *s_cet,
+				u64 *ssp, u64 *ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		*s_cet = vmcs_readl(GUEST_S_CET);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		*ssp = vmcs_readl(GUEST_SSP);
+		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
+}
+
+static void vmcs_write_cet_state(struct kvm_vcpu *vcpu, u64 s_cet,
+				 u64 ssp, u64 ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, s_cet);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, ssp);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
+	}
+}
+
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
@@ -2637,6 +2681,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)
+		vmcs_write_cet_state(&vmx->vcpu, vmcs12->guest_s_cet,
+				     vmcs12->guest_ssp, vmcs12->guest_ssp_tbl);
+
 	set_cr4_guest_host_mask(vmx);
 }
 
@@ -2676,6 +2724,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
+
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		vmcs_write_cet_state(vcpu, vmx->nested.pre_vmenter_s_cet,
+				     vmx->nested.pre_vmenter_ssp,
+				     vmx->nested.pre_vmenter_ssp_tbl);
+
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
@@ -3551,6 +3606,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		vmcs_read_cet_state(vcpu, &vmx->nested.pre_vmenter_s_cet,
+				    &vmx->nested.pre_vmenter_ssp,
+				    &vmx->nested.pre_vmenter_ssp_tbl);
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
@@ -4634,6 +4695,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
+
+	vmcs_read_cet_state(&vmx->vcpu, &vmcs12->guest_s_cet,
+			    &vmcs12->guest_ssp,
+			    &vmcs12->guest_ssp_tbl);
 }
 
 /*
@@ -4759,6 +4824,18 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	/*
+	 * Load CET state from host state if VM_EXIT_LOAD_CET_STATE is set.
+	 * otherwise CET state should be retained across VM-exit, i.e.,
+	 * guest values should be propagated from vmcs12 to vmcs01.
+	 */
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
+		vmcs_write_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+				     vmcs12->host_ssp_tbl);
+	else
+		vmcs_write_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+				     vmcs12->guest_ssp_tbl);
+
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 106a72c923ca..4233b5ca9461 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELD(GUEST_S_CET, guest_s_cet),
+	FIELD(GUEST_SSP, guest_ssp),
+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
 	FIELD(HOST_CR0, host_cr0),
 	FIELD(HOST_CR3, host_cr3),
 	FIELD(HOST_CR4, host_cr4),
@@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(HOST_S_CET, host_s_cet),
+	FIELD(HOST_SSP, host_ssp),
+	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 56fd150a6f24..4ad6b16525b9 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -117,7 +117,13 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width host_s_cet;
+	natural_width host_ssp;
+	natural_width host_ssp_tbl;
+	natural_width guest_s_cet;
+	natural_width guest_ssp;
+	natural_width guest_ssp_tbl;
+	natural_width paddingl[2]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -294,6 +300,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(host_s_cet, 680);
+	CHECK_OFFSET(host_ssp, 688);
+	CHECK_OFFSET(host_ssp_tbl, 696);
+	CHECK_OFFSET(guest_s_cet, 704);
+	CHECK_OFFSET(guest_ssp, 712);
+	CHECK_OFFSET(guest_ssp_tbl, 720);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 29e1bc118479..509487a1f04a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7748,6 +7748,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index af8224e074ee..ea93121029f9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -181,6 +181,9 @@ struct nested_vmx {
 	 */
 	u64 pre_vmenter_debugctl;
 	u64 pre_vmenter_bndcfgs;
+	u64 pre_vmenter_s_cet;
+	u64 pre_vmenter_ssp;
+	u64 pre_vmenter_ssp_tbl;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.51.0.470.ga7dc726c21-goog


