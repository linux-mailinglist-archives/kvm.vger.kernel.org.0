Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB90237C328
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhELPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:44 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:53424 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhELPO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832400; x=1652368400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aODMbDqUW++xg0p7BAJBzog0uWqHgdYh2MyWroPFvxU=;
  b=C1PbLD+djI8nNqGrx1eTlpZuV4CSgPTuWEVQ3lrONP0R9FEMhnKfrsJn
   GaV1/9xV4xWJ8ogOemX7Y1ug/CEApTqnJoVBIK2o9UcgNjOGH9mvf3TAH
   9MPjE8dGBpmp+C2Th/1Z3CEp7PsGusda20Mg5lowqRrkHjTsD9JvX8H9y
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="125400149"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 12 May 2021 15:13:19 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id C0FB6A1D3B;
        Wed, 12 May 2021 15:13:15 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:05 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:05 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:13:03 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 08/10] KVM: VMX: Set the TSC offset and multiplier on nested entry and exit
Date:   Wed, 12 May 2021 16:09:43 +0100
Message-ID: <20210512150945.4591-9-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that nested TSC scaling is supported we need to calculate the
correct 02 values for both the offset and the multiplier using the
corresponding functions. On L2's exit the L1 values are restored.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/vmx/nested.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..f1dff1ebaccb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3354,8 +3354,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	enter_guest_mode(vcpu);
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
+
+	kvm_set_02_tsc_offset(vcpu);
+	kvm_set_02_tsc_multiplier(vcpu);
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
@@ -4463,8 +4464,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (nested_cpu_has_preemption_timer(vmcs12))
 		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
 
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
-		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
+		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
+
+		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
+			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
+	}
 
 	if (likely(!vmx->fail)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
-- 
2.17.1

