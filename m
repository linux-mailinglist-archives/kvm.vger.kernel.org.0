Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ACF391F82
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhEZSs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:48:56 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:27682 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbhEZSsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054844; x=1653590844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OoyYtF6x3IG1coV85+nkBAzyCgT+6pLRLqQkBqOr044=;
  b=GaGCpHUN34YvjdoL9Vr2eJoB3CwMKzmAdXz7TXZalKKP0xZ8dd8lCIDI
   SQHmcgEgoGaPXMqDxwYfh4wrSQc0uSH4LuMb9MjGvdQEZPboxrJ1lfhDW
   UWfps88iYsLZqSSiMF/PuJpOJlRzJqm9HrH7VrBQpPm+k3rpJARw0MVGt
   I=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="111927114"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 26 May 2021 18:47:23 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id E5959A1A7B;
        Wed, 26 May 2021 18:47:18 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:59 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:59 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:46:57 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 09/11] KVM: X86: Add vendor callbacks for writing the TSC multiplier
Date:   Wed, 26 May 2021 19:44:16 +0100
Message-ID: <20210526184418.28881-10-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently vmx_vcpu_load_vmcs() writes the TSC_MULTIPLIER field of the
VMCS every time the VMCS is loaded. Instead of doing this, set this
field from common code on initialization and whenever the scaling ratio
changes.

Additionally remove vmx->current_tsc_ratio. This field is redundant as
vcpu->arch.tsc_scaling_ratio already tracks the current TSC scaling
ratio. The vmx->current_tsc_ratio field is only used for avoiding
unnecessary writes but it is no longer needed after removing the code
from the VMCS load path.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/kvm/vmx/nested.c          |  9 ++++-----
 arch/x86/kvm/vmx/vmx.c             | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.h             |  8 --------
 arch/x86/kvm/x86.c                 | 28 +++++++++++++++++++++++-----
 7 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 029c9615378f..34ad7a17458a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -90,6 +90,7 @@ KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
+KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f099277b993d..a334ce7741ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1308,6 +1308,7 @@ struct kvm_x86_ops {
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
 	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
 	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
 
 	/*
 	 * Retrieve somewhat arbitrary exit information.  Intended to be used
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8dfb2513b72a..cb701b42b08b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1103,6 +1103,11 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
+static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+{
+	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+}
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
@@ -4528,6 +4533,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
 	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
 	.write_tsc_offset = svm_write_tsc_offset,
+	.write_tsc_multiplier = svm_write_tsc_multiplier,
 
 	.load_mmu_pgd = svm_load_mmu_pgd,
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..239154d3e4e7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2533,9 +2533,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	}
 
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
-
 	if (kvm_has_tsc_control)
-		decache_tsc_multiplier(vmx);
+		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
 
@@ -4501,12 +4500,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
+	if (kvm_has_tsc_control)
+		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
+
 	if (vmx->nested.l1_tpr_threshold != -1)
 		vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
 
-	if (kvm_has_tsc_control)
-		decache_tsc_multiplier(vmx);
-
 	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
 		vmx->nested.change_vmcs01_virtual_apic_mode = false;
 		vmx_set_virtual_apic_mode(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4b70431c2edd..bf845a08995e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1390,11 +1390,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		vmx->loaded_vmcs->cpu = cpu;
 	}
-
-	/* Setup TSC multiplier */
-	if (kvm_has_tsc_control &&
-	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
-		decache_tsc_multiplier(vmx);
 }
 
 /*
@@ -1813,6 +1808,11 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcs_write64(TSC_OFFSET, offset);
 }
 
+static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+{
+	vmcs_write64(TSC_MULTIPLIER, multiplier);
+}
+
 /*
  * nested_vmx_allowed() checks whether a guest should be allowed to use VMX
  * instructions and MSRs (i.e., nested VMX). Nested VMX is disabled for
@@ -7707,6 +7707,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
 	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
 	.write_tsc_offset = vmx_write_tsc_offset,
+	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index aa97c82e3451..3eaa86a0ba3e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -322,8 +322,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	u64 current_tsc_ratio;
-
 	unsigned long host_debugctlmsr;
 
 	/*
@@ -532,12 +530,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
 			      GFP_KERNEL_ACCOUNT);
 }
 
-static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
-{
-	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
-	vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
-}
-
 static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 {
 	return vmx->secondary_exec_control &
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 801fa1e8e915..8afe2c29183c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2179,14 +2179,15 @@ static u32 adjust_tsc_khz(u32 khz, s32 ppm)
 	return v;
 }
 
+static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier);
+
 static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 {
 	u64 ratio;
 
 	/* Guest TSC same frequency as host TSC? */
 	if (!scale) {
-		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
-		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
+		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
 		return 0;
 	}
 
@@ -2212,7 +2213,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 		return -1;
 	}
 
-	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
+	kvm_vcpu_write_tsc_multiplier(vcpu, ratio);
 	return 0;
 }
 
@@ -2224,8 +2225,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	/* tsc_khz can be zero if TSC calibration fails */
 	if (user_tsc_khz == 0) {
 		/* set tsc_scaling_ratio to a safe value */
-		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
-		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
+		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
 		return -1;
 	}
 
@@ -2383,6 +2383,23 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }
 
+static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
+{
+	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
+
+	/* Userspace is changing the multiplier while L2 is active */
+	if (is_guest_mode(vcpu))
+		vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
+			l1_multiplier,
+			static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
+	else
+		vcpu->arch.tsc_scaling_ratio = l1_multiplier;
+
+	if (kvm_has_tsc_control)
+		static_call(kvm_x86_write_tsc_multiplier)(
+			vcpu, vcpu->arch.tsc_scaling_ratio);
+}
+
 static inline bool kvm_check_tsc_unstable(void)
 {
 #ifdef CONFIG_X86_64
@@ -10444,6 +10461,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 		return;
 	vcpu_load(vcpu);
 	kvm_synchronize_tsc(vcpu, 0);
+	kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */
-- 
2.17.1

