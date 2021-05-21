Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC5A38C4C7
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhEUK3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:29:40 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:54164 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhEUK2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592852; x=1653128852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gJKsCY28F4ZLGUgdSXVBf/gDpr3idRcgNIlrdPGhFc4=;
  b=KV93PHl5tUr38Ti3zaHoOFwHPKSKNZ37rQNypnqFtec3NNqTy82uJyYO
   L6Ad7XTdn10IqtHyFlBurdvr3Z4g1DbZFZE8RgZTHq7ixBGKTDWM3/w91
   obwjhHZdpeCGc+Z27PIQfp1A+9R2sgQ9M5yGFGAmOgzfl3x+dBBtsnAru
   s=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2612406"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 May 2021 10:27:26 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id EACC41201C3;
        Fri, 21 May 2021 10:27:24 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:04 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:27:03 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 08/12] KVM: X86: Move write_l1_tsc_offset() logic to common code and rename it
Date:   Fri, 21 May 2021 11:24:45 +0100
Message-ID: <20210521102449.21505-9-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The write_l1_tsc_offset() callback has a misleading name. It does not
set L1's TSC offset, it rather updates the current TSC offset which
might be different if a nested guest is executing. Additionally, both
the vmx and svm implementations use the same logic for calculating the
current TSC before writing it to hardware.

Rename the function and move the common logic to the caller. The vmx/svm
specific code now merely sets the given offset to the corresponding
hardware structure.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  3 +--
 arch/x86/kvm/svm/svm.c             | 21 ++++-----------------
 arch/x86/kvm/vmx/vmx.c             | 23 +++--------------------
 arch/x86/kvm/x86.c                 | 24 +++++++++++++++++++++---
 5 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 2063616fba1c..029c9615378f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -89,7 +89,7 @@ KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
-KVM_X86_OP(write_l1_tsc_offset)
+KVM_X86_OP(write_tsc_offset)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aaf756442ed1..f099277b993d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1307,8 +1307,7 @@ struct kvm_x86_ops {
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
 	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
-	/* Returns actual tsc_offset set in active VMCS */
-	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
 	/*
 	 * Retrieve somewhat arbitrary exit information.  Intended to be used
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca70e46f9194..8dfb2513b72a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1094,26 +1094,13 @@ static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return kvm_default_tsc_scaling_ratio;
 }
 
-static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u64 g_tsc_offset = 0;
-
-	if (is_guest_mode(vcpu)) {
-		/* Write L1's TSC offset.  */
-		g_tsc_offset = svm->vmcb->control.tsc_offset -
-			       svm->vmcb01.ptr->control.tsc_offset;
-		svm->vmcb01.ptr->control.tsc_offset = offset;
-	}
-
-	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-				   svm->vmcb->control.tsc_offset - g_tsc_offset,
-				   offset);
-
-	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
 
+	svm->vmcb01.ptr->control.tsc_offset = vcpu->arch.l1_tsc_offset;
+	svm->vmcb->control.tsc_offset = offset;
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
-	return svm->vmcb->control.tsc_offset;
 }
 
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
@@ -4540,7 +4527,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
 	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
-	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
+	.write_tsc_offset = svm_write_tsc_offset,
 
 	.load_mmu_pgd = svm_load_mmu_pgd,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c83605eccc1..4b70431c2edd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1808,26 +1808,9 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return kvm_default_tsc_scaling_ratio;
 }
 
-static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	u64 g_tsc_offset = 0;
-
-	/*
-	 * We're here if L1 chose not to trap WRMSR to TSC. According
-	 * to the spec, this should set L1's TSC; The offset that L1
-	 * set for L2 remains unchanged, and still needs to be added
-	 * to the newly set TSC to get L2's TSC.
-	 */
-	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
-		g_tsc_offset = vmcs12->tsc_offset;
-
-	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-				   vcpu->arch.tsc_offset - g_tsc_offset,
-				   offset);
-	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
-	return offset + g_tsc_offset;
+	vmcs_write64(TSC_OFFSET, offset);
 }
 
 /*
@@ -7723,7 +7706,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
 	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
+	.write_tsc_offset = vmx_write_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04abaacb9cfc..2f91259070e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2359,10 +2359,28 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
 }
 EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
 
-static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 {
-	vcpu->arch.l1_tsc_offset = offset;
-	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
+	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+				   vcpu->arch.l1_tsc_offset,
+				   l1_offset);
+
+	vcpu->arch.l1_tsc_offset = l1_offset;
+
+	/*
+	 * If we are here because L1 chose not to trap WRMSR to TSC then
+	 * according to the spec this should set L1's TSC (as opposed to
+	 * setting L1's offset for L2).
+	 */
+	if (is_guest_mode(vcpu))
+		vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
+			l1_offset,
+			static_call(kvm_x86_get_l2_tsc_offset)(vcpu),
+			static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
+	else
+		vcpu->arch.tsc_offset = l1_offset;
+
+	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }
 
 static inline bool kvm_check_tsc_unstable(void)
-- 
2.17.1

