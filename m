Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD91391F7C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhEZSsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:48:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:38377 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbhEZSs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054818; x=1653590818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=I8ApvQev0AHEFIvl3utBjCWgx7jyKMKW4PFHIeNPNPg=;
  b=WtnijPUr7abXn4SqkNzi6e852xka85rqI++kzKPWbGCCa6WD1w9KohYX
   mfsb3n6wdMMiniOqH7AMBrN2GzI2NyYMscjUXt1M9wU7wnXV9R8SJdfD6
   5FOrGv9n+8BTu1opDRuaMc4OJEecQ/S+0tcKPPDXFkWBBiCQjSPJFXdBG
   4=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="137029979"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 26 May 2021 18:46:52 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id CB5F4A2171;
        Wed, 26 May 2021 18:46:50 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:25 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:46:24 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 06/11] KVM: X86: Add functions for retrieving L2 TSC fields from common code
Date:   Wed, 26 May 2021 19:44:13 +0100
Message-ID: <20210526184418.28881-7-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to implement as much of the nested TSC scaling logic as
possible in common code, we need these vendor callbacks for retrieving
the TSC offset and the TSC multiplier that L1 has set for L2.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  3 +++
 5 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 323641097f63..2063616fba1c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -87,6 +87,8 @@ KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_NULL(has_wbinvd_exit)
+KVM_X86_OP(get_l2_tsc_offset)
+KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_l1_tsc_offset)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b14c2b2b2e21..0f2cf5d1240c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,8 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
+	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
+	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
 	/* Returns actual tsc_offset set in active VMCS */
 	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05eca131eaf2..ca70e46f9194 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1082,6 +1082,18 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
 }
 
+static u64 svm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->nested.ctl.tsc_offset;
+}
+
+static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	return kvm_default_tsc_scaling_ratio;
+}
+
 static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4526,6 +4538,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
+	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
 	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
 
 	.load_mmu_pgd = svm_load_mmu_pgd,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3e4dda8177bb..1c83605eccc1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1787,6 +1787,27 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	vmx->guest_uret_msrs_loaded = false;
 }
 
+u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+
+	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING))
+		return vmcs12->tsc_offset;
+
+	return 0;
+}
+
+u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+
+	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING) &&
+	    nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
+		return vmcs12->tsc_multiplier;
+
+	return kvm_default_tsc_scaling_ratio;
+}
+
 static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -7700,6 +7721,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
+	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
 	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 16e4e457ba23..aa97c82e3451 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -404,6 +404,9 @@ void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 
+u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
+u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.17.1

