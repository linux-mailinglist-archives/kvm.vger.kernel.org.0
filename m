Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2799391F80
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhEZSsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:48:51 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:11327 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhEZSst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054838; x=1653590838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=pld8/2iHCmHBmcUk+DOeD11tuO59SRdSmjIqaELXV0w=;
  b=qAFqRKZWe4GWjlLRNOi49EOll81PlDx/2Tg9ZhkyEzZRRqE08Bmskebt
   CWIcZ7l1Iy5V7DUvSdWPkysHNfqOdvpHNymDI5V/GLRhEx29aILostmoP
   tVxKzNLS+/R4uyeJ9/4El1rnwfTgNhJbEFWnqkQEyQX+Eyymny8imNlkz
   w=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="3484176"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 26 May 2021 18:47:17 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id EFA0EC042D;
        Wed, 26 May 2021 18:47:12 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:47:11 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:47:11 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:47:10 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 10/11] KVM: nVMX: Enable nested TSC scaling
Date:   Wed, 26 May 2021 19:44:17 +0100
Message-ID: <20210526184418.28881-11-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Calculate the TSC offset and multiplier on nested transitions and expose
the TSC scaling feature to L1.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 239154d3e4e7..e8183e224706 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2277,7 +2277,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				  SECONDARY_EXEC_ENABLE_VMFUNC);
+				  SECONDARY_EXEC_ENABLE_VMFUNC |
+				  SECONDARY_EXEC_TSC_SCALING);
 		if (nested_cpu_has(vmcs12,
 				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;
@@ -2532,6 +2533,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
 	}
 
+	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
+			vcpu->arch.l1_tsc_offset,
+			vmx_get_l2_tsc_offset(vcpu),
+			vmx_get_l2_tsc_multiplier(vcpu));
+
+	vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
+			vcpu->arch.l1_tsc_scaling_ratio,
+			vmx_get_l2_tsc_multiplier(vcpu));
+
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
 	if (kvm_has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
@@ -3353,8 +3363,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	enter_guest_mode(vcpu);
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
@@ -4462,8 +4470,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (nested_cpu_has_preemption_timer(vmcs12))
 		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
 
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
+	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING)) {
+		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
+		if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
+			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
+	}
 
 	if (likely(!vmx->fail)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
@@ -6473,7 +6484,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES;
+		SECONDARY_EXEC_XSAVES |
+		SECONDARY_EXEC_TSC_SCALING;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.17.1

