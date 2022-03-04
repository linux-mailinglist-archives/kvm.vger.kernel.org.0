Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B924CDD9D
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiCDT7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiCDT7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D514F2335D1;
        Fri,  4 Mar 2022 11:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423448; x=1677959448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j1gxVYzCdWkQln2A6jUvygCnZnz9AWqpPhl0nF6jwFo=;
  b=i59Spg/Tvg3ldT5B0FvwSqR56ls3/7QuPNpicnkrni/iRwmQ5izjY/Bs
   Y1Xk5uHRQZx5iof5d+dTuURqIcGfyDvnuVXPXFu6R8/rXmQFFj1NHnxyG
   prifkLCFZw0OyKkxynazUFdb5SLyaaqulDEU3u88PdYpWNJekyMka8Qra
   BiAzcBeYy351jrGH6+Oteh2YT6j5WTMmyH699GS5tH4DorF2jEOExdA0j
   E5EDKGDpL8iXlGEU03Zoz5dVdgF7j7WTksIXfZjZUWjCMY74sg61iKXu8
   ja5HgHDeNj2j/Wz/QuqOqcdPk8COvwVKHfZr66tzMfTxrf+Q0q5CENPt6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779667"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779667"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:48 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344620"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:48 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Date:   Fri,  4 Mar 2022 11:49:57 -0800
Message-Id: <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
Instead it defines the different protocols to boot application processors.
Ignore INIT and SIPI events for the TDX guest.

There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
error to guest TDs somehow.  Given that TDX guest is paravirtualized to
boot AP, the option 1 is chosen for simplicity.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c    | 21 +++++++++++++++++----
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 arch/x86/kvm/x86.h      |  5 +++++
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d49f029ef0e3..e27653d5e630 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2921,11 +2921,20 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 
 	if (test_bit(KVM_APIC_INIT, &pe)) {
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
-		kvm_vcpu_reset(vcpu, true);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
+		if (kvm_init_sipi_unsupported(vcpu->kvm))
+			/*
+			 * TDX doesn't support INIT.  Ignore INIT event.  In the
+			 * case of SIPI, the callback of
+			 * vcpu_deliver_sipi_vector ignores it.
+			 */
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-		else
-			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		else {
+			kvm_vcpu_reset(vcpu, true);
+			if (kvm_vcpu_is_bsp(apic->vcpu))
+				vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+			else
+				vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		}
 	}
 	if (test_bit(KVM_APIC_SIPI, &pe)) {
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
@@ -2933,6 +2942,10 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			/* evaluate pending_events before reading the vector */
 			smp_rmb();
 			sipi_vector = apic->sipi_vector;
+			/*
+			 * If SINIT isn't supported, the callback ignores SIPI
+			 * request.
+			 */
 			kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		}
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 478aa63acefa..de9b4a270f20 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -264,6 +264,14 @@ static bool vt_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -586,7 +594,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
 
 	.mem_enc_op = vt_mem_enc_op,
 	.mem_enc_op_vcpu = vt_mem_enc_op_vcpu,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f15bf1c0aeb1..c789d72ab408 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -405,6 +405,11 @@ static inline void kvm_machine_check(void)
 #endif
 }
 
+static __always_inline bool kvm_init_sipi_unsupported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.25.1

