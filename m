Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF1738C4C4
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhEUK3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:29:35 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:65388 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhEUK2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592849; x=1653128849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=X0lrR9FL0WD2Y6e8YGazXKa7Vce1W1ZnUPxL/zsvVgo=;
  b=fPHYi4WhEbPxNx3feNuYdbRb/OYK8tWvv/ejrPjfCJk12otO7ovhJpVy
   Pp2/ml0NMUUEJkrbprUJ8d9Nt/TgFS5FDQTf0bVLtO5VZu07sDohumbvr
   ME1fIp+qmtm2FQ4YlzayMSk548cxpiIq8tiEMk5/lLNFSFijtgNcCaUlM
   o=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="113767681"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 21 May 2021 10:27:21 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id A069CA1D72;
        Fri, 21 May 2021 10:27:19 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:16 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:27:16 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:27:15 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and decache_tsc_multiplier()
Date:   Fri, 21 May 2021 11:24:46 +0100
Message-ID: <20210521102449.21505-10-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vmx->current_tsc_ratio field is redundant as
vcpu->arch.tsc_scaling_ratio already tracks the current TSC scaling
ratio. Removing this field makes decache_tsc_multiplier() an one-liner
so remove that too and do a vmcs_write64() directly in order to be more
consistent with surrounding code.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/vmx/nested.c | 9 ++++-----
 arch/x86/kvm/vmx/vmx.c    | 5 ++---
 arch/x86/kvm/vmx/vmx.h    | 8 --------
 3 files changed, 6 insertions(+), 16 deletions(-)

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
index 4b70431c2edd..7c52c697cfe3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1392,9 +1392,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 	}
 
 	/* Setup TSC multiplier */
-	if (kvm_has_tsc_control &&
-	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
-		decache_tsc_multiplier(vmx);
+	if (kvm_has_tsc_control)
+		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 }
 
 /*
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
-- 
2.17.1

