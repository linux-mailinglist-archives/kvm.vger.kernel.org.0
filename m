Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6938C4D4
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhEUKaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:30:25 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:58150 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhEUK3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592879; x=1653128879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=4S42b6Ei1Kkgo7n2MOt8tEEKji2/LK2PdjzIhzOYtY8=;
  b=Ga0i+vR9LC3sSoRLNVuoZGSmsQadx+zm6WYFkHBM/ugI/cwtUiTqeL8N
   XlY2t+D0s1l5wSUuvAW6bqjkQnYmJEyA0mz7NHxl/z4OCwXc3t2Hp5HYN
   bAmaBvwCOB02M4j6tATSBUulUpA7UjLoz0R0JMWLQfDokwG3PNfAn5jZU
   4=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2588334"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 21 May 2021 10:27:53 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 7CED01201C3;
        Fri, 21 May 2021 10:27:52 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:29 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:29 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:27:27 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 10/12] KVM: VMX: Set the TSC offset and multiplier on nested entry and exit
Date:   Fri, 21 May 2021 11:24:47 +0100
Message-ID: <20210521102449.21505-11-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Calculate the nested TSC offset and multiplier on entering L2 using the
corresponding functions. Restore the L1 values on L2's exit.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 239154d3e4e7..f75c4174cbcf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2532,6 +2532,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -3353,8 +3362,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	enter_guest_mode(vcpu);
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
@@ -4462,8 +4469,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
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
-- 
2.17.1

