Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012A537C326
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhELPRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:43 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:49216 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhELPOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832387; x=1652368387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dCPeFV5B3yxfSMAfc1TaVPUCDD3dKVYzbYjdG1JDI2I=;
  b=fdTOJWlhcEM8wq86RmQXoWSozflwxcgjRBTXAzgVsvt8j/EsEU9VH41Q
   DhkNK83EW4O5cDDftU1M+7pn0SFT7gsPYUZqFBvuxMOrfeEcG2qs0Ki2P
   oZf1+xWvbSPgXzxyEBiP6zpkiQseqw1jlWN1IaNTugfTBh4EmGtsZxCw4
   0=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="932813036"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 May 2021 15:13:05 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id 40E49BA432;
        Wed, 12 May 2021 15:13:02 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:51 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:51 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:12:49 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 07/10] KVM: X86: Move write_l1_tsc_offset() logic to common code and rename it
Date:   Wed, 12 May 2021 16:09:42 +0100
Message-ID: <20210512150945.4591-8-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
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

This patch renames the function and moves the common logic to the
caller. The vmx/svm-specific code now merely sets the given offset to
the corresponding hardware structure.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  3 +--
 arch/x86/kvm/svm/svm.c             | 21 ++++-----------------
 arch/x86/kvm/vmx/vmx.c             | 23 +++--------------------
 arch/x86/kvm/x86.c                 | 17 ++++++++++++++++-
 5 files changed, 25 insertions(+), 41 deletions(-)

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
index 57a25d8e8b0f..61cf201c001a 100644
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
index 679b2fc1a3f9..b18f60463073 100644
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
index 575e13bddda8..3c4eb14a1e86 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1810,26 +1810,9 @@ static u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return multiplier;
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
@@ -7725,7 +7708,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
 	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
+	.write_tsc_offset = vmx_write_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1db6cfc2079f..f3ba1be4d5b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2377,8 +2377,23 @@ EXPORT_SYMBOL_GPL(kvm_set_02_tsc_multiplier);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
+	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+				   vcpu->arch.l1_tsc_offset,
+				   offset);
+
 	vcpu->arch.l1_tsc_offset = offset;
-	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
+	vcpu->arch.tsc_offset = offset;
+
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * We're here if L1 chose not to trap WRMSR to TSC and
+		 * according to the spec this should set L1's TSC (as opposed
+		 * to setting L1's offset for L2).
+		 */
+		kvm_set_02_tsc_offset(vcpu);
+	}
+
+	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }
 
 static inline bool kvm_check_tsc_unstable(void)
-- 
2.17.1

