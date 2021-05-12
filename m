Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E13437C317
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhELPRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:19 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:50091 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhELPNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832361; x=1652368361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kWONKALLAAkYdmcXihmg29EhGTugBqvFORDq7cQCa9M=;
  b=N4AItl63aD/Mq7z771WX0BfojIAWw1X2qqFKE8QEv3reK1Iv0IDuhq7D
   rT1e1oVrmj/r+Z8q4bqHzZlLgW3fwXRwDt0AwQzIRzxS3aKSuy4pucXa0
   deMukJvCjWmucBg15qyo/CgenU0j4uYhSKKamUH1w6YfGzPH0w+hSB/hA
   8=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="111783534"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 May 2021 15:12:36 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id EFC89A072C;
        Wed, 12 May 2021 15:12:32 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:32 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:32 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:12:30 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 05/10] KVM: X86: Add functions for retrieving L2 TSC fields from common code
Date:   Wed, 12 May 2021 16:09:40 +0100
Message-ID: <20210512150945.4591-6-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to implement as much of the nested TSC scaling logic as
possible in common code, we need these vendor callbacks for retrieving
the TSC offset and the TSC multiplier that L1 has set for L2.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 25 +++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

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
index be59197e5eb7..4c4a3fefff57 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,8 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
+	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
+	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
 	/* Returns actual tsc_offset set in active VMCS */
 	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa351e605de..679b2fc1a3f9 100644
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
index 4bceb5ca3a89..575e13bddda8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1787,6 +1787,29 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	vmx->guest_uret_msrs_loaded = false;
 }
 
+static u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u64 offset = 0;
+
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
+		offset = vmcs12->tsc_offset;
+
+	return offset;
+}
+
+static u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u64 multiplier = kvm_default_tsc_scaling_ratio;
+
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING &&
+	    vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
+		multiplier = vmcs12->tsc_multiplier;
+
+	return multiplier;
+}
+
 static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -7700,6 +7723,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
+	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
 	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
-- 
2.17.1

