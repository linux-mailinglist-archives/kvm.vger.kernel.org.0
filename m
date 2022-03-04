Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D8F4CDD8E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiCDT7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCDT7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36227269A76;
        Fri,  4 Mar 2022 11:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423438; x=1677959438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yZvt824DDrlOBsR8+5xXANYwUJhPov5Rl143h3UTjL0=;
  b=YhtE9mphf7afCqU2LFBHaQrZCKS1aR7rljNBXfa+x8iX0k2bnFlTJNgm
   /kSO8k2gs/oQDw6pk/uCfK5KRh0dWokI/lPFLKcEgSz758QSi98D1uNPf
   TpSMpydyE1XKfL5Bn2lLMqmcbVznrEvQG71assGwiZ2eU+OLow/AV4fWP
   +7fARovdCmmB5VmzGEcZ+751mpHNj9tVNQts4xjGlxsPTpXIIesVjAotm
   tME4N7LfJhryy0SQKiblbpIDkBVRsGMqv+ElUFwjhM888NCd4P1Mdszpb
   9RpEcu729dEk7ikWE9WQHX7SVuJ0oMIodVKzceeLAUf0EgAYVB40sO4QU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779626"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779626"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344492"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:36 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 075/104] KVM: x86: Check for pending APICv interrupt in kvm_vcpu_has_events()
Date:   Fri,  4 Mar 2022 11:49:31 -0800
Message-Id: <d28f3b27c281e0c6a8f93c01bb4da78980d654c8.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
i.e. needs to generate a posted interrupt and more importantly can't
manually move requested interrupts into the vIRR (which it also doesn't
have access to).

Because pi_has_pending_interrupt() is heavy operation which uses two atomic
test bit operations and one atomic 256 bit bitmap check, introduce new
callback for this check instead of reusing dy_apicv_has_pending_interrupt()
callback to avoid affecting the exiting code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/main.c         | 9 +++++++++
 arch/x86/kvm/x86.c              | 5 ++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 489374a57b66..8dab9f16f559 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1491,6 +1491,7 @@ struct kvm_x86_ops {
 	void (*start_assignment)(struct kvm *kvm);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 882358ac270b..d75caf0d6861 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -148,6 +148,14 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	return vmx_vcpu_load(vcpu, cpu);
 }
 
+static bool vt_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return pi_has_pending_interrupt(vcpu);
+
+	return false;
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -297,6 +305,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+	.apicv_has_pending_interrupt = vt_apicv_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89d04cd64cd0..314ae43e07bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12111,7 +12111,10 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
-	    kvm_guest_apic_has_interrupt(vcpu)))
+	     kvm_guest_apic_has_interrupt(vcpu) ||
+	     (vcpu->arch.apicv_active &&
+	      kvm_x86_ops.apicv_has_pending_interrupt &&
+	      kvm_x86_ops.apicv_has_pending_interrupt(vcpu))))
 		return true;
 
 	if (kvm_hv_has_stimer_pending(vcpu))
-- 
2.25.1

