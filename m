Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B134155DEEC
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiF0V6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbiF0V4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:56:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C16635B;
        Mon, 27 Jun 2022 14:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366910; x=1687902910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bhAtEF2Mdu4UXBndNKCUO9swGoEHm6wP1u6/sytdEM4=;
  b=X+f33A/onUpqxkuRnf+n4ciDfYYm3ZMBf/dW2wDVrZlHmHEkEEzVVeaE
   dGAPKev270JQAl0aoZJyPiGo1+/NZsPRC+yMzlDXS/tjAGDgwFj2YG/pC
   m3xZy3q+cbr6/4g2PxqOgW0eaUvsr3Hf7wJQEf6uMhbIy/4dJZ/A8RWW2
   4Sl73wpMYfl7WqzToPKBZfkTe/eQtTQWotkM778e/nmCFCifaUoEViLLz
   sKIhzylFRycU6JQf7v0vmgSJV6j3AXEsEUiBo3IFMXsPomAuC1ML1GsQi
   tqCCcy71gabnHe6C4/+JODTUbuSEgscwYsbNy6KO6W7VJ8hXBYyR6FLtE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116154"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116154"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863773"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 099/102] KVM: TDX: Silently ignore INIT/SIPI
Date:   Mon, 27 Jun 2022 14:54:31 -0700
Message-Id: <e8658a728314c0253a25fcb24a998b0a5d3bd044.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/lapic.c               | 16 +++++++++++-----
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/vmx/main.c            | 22 +++++++++++++++++++++-
 5 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ec98b3f734a2..ff658969cfff 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -136,6 +136,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
+KVM_X86_OP(vcpu_deliver_init)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP(check_processor_compatibility)
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42d209fe0a4f..2b79d1c9cabb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1649,6 +1649,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void (*vcpu_deliver_init)(struct kvm_vcpu *vcpu);
 
 	/*
 	 * Returns vCPU specific APICv inhibit reasons
@@ -1858,6 +1859,7 @@ int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector, int seg);
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu);
 
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 67dbc26aa1bd..596955070721 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2996,6 +2996,16 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	return 0;
 }
 
+void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_reset(vcpu, true);
+	if (kvm_vcpu_is_bsp(vcpu))
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_init);
+
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -3043,11 +3053,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 
 	if (test_bit(KVM_APIC_INIT, &pe)) {
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
-		kvm_vcpu_reset(vcpu, true);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-		else
-			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		static_call(kvm_x86_vcpu_deliver_init)(vcpu);
 	}
 	if (test_bit(KVM_APIC_SIPI, &pe)) {
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0abc43d6a115..0f4ce62b30c0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4829,6 +4829,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_init = kvm_vcpu_deliver_init,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 };
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 294919913dfd..552f2576d3ae 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -295,6 +295,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
 }
 
+static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
+static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		/* TDX doesn't support INIT.  Ignore INIT event */
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		return;
+	}
+
+	kvm_vcpu_deliver_init(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -616,7 +635,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_init = vt_vcpu_deliver_init,
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
-- 
2.25.1

