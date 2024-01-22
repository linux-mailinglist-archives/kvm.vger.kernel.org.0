Return-Path: <kvm+bounces-6679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43987837869
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67BFD1C26433
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EA47E594;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djSWp8pv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B777F2F;
	Mon, 22 Jan 2024 23:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967769; cv=none; b=iOSK2xwJiCBzSh2RMJ55XT+TvrYf/Qo1G+C9SJDmzZQCE/yrT2fBlIpcqnQ4kNHD1QKChhRaI21Aik8c1duEj2uHHxFzUG6aNeFdscZEmi95FcgPjCDYQBfku5b5+aKqtmAUr74/PTemFIfC1Z+EBvIeWkHjawKLcwLtt10nc+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967769; c=relaxed/simple;
	bh=oTKHyCehm2xtGSC9joChYZZr51aBw6t+bPtV7/JXeTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GDE05J00VsdKp/03hqZPnUNniVFm3EAt3FybIxiXC0LO0mmT7OGAg5vNUQ8HpgwhPlz95uwWJx7a08IJ6UF0PwxPmYv4X6ok/AeKf7sF1Z0JG6OxscycdSvxBOgYsCUrJZbV6hTjJljLrRD0cOja4ilNKb8ZvjhUQ7Vf3/ePKmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djSWp8pv; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967767; x=1737503767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oTKHyCehm2xtGSC9joChYZZr51aBw6t+bPtV7/JXeTo=;
  b=djSWp8pvH/sHPBRFHaqSVE5L4FLs9ajbIXYeJbI9Qgftmbk/NX4GdNQz
   WY7pVHP3W2RLGZxL2vrr/M9jkVuoSakWGw3lQzk/NK/zIz4WgjnyDA9HV
   Dg6IBCuqgqVrTVItP9E0XbO98Efk8vJG2NVdIyRKpUPsDZ771uIHBV8B2
   Y39QwSd3lDzI1zzMuYZGy9e2nwL+8zj+RRzzQO26LVNweR5PoEf8lcjm3
   KrfsLHpKF07V4qfPiIBFMJcHcy6tmdm28aeSD1BbpitE7TRU7K1RGMgec
   LQTs1rfogize+kL4kadVICegTvgL54XsW5gzyppvCqjSfLCRFMeAXOAH0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217901"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217901"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818005"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:54 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 106/121] KVM: TDX: Silently ignore INIT/SIPI
Date: Mon, 22 Jan 2024 15:54:22 -0800
Message-Id: <44f8ab73dc25f36e2ddc4dc5f7ef7025dc426d61.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/x86/kvm/lapic.c               | 19 +++++++++++-------
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/vmx/main.c            | 32 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c             |  4 ++--
 6 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 23197e9e2b7f..ee0b82817c63 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -149,6 +149,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
+KVM_X86_OP(vcpu_deliver_init)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c29f822dc360..59a1c55c48f0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1853,6 +1853,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void (*vcpu_deliver_init)(struct kvm_vcpu *vcpu);
 
 	/*
 	 * Returns vCPU specific APICv inhibit reasons
@@ -2101,6 +2102,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void kvm_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector, int seg);
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu);
 
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8025c7f614e0..431074679e83 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3268,6 +3268,16 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
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
@@ -3299,13 +3309,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
-		kvm_vcpu_reset(vcpu, true);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-		else
-			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
-	}
+	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events))
+		static_call(kvm_x86_vcpu_deliver_init)(vcpu);
 	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			/* evaluate pending_events before reading the vector */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f76dd52d29ba..27546d993809 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5037,6 +5037,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_init = kvm_vcpu_deliver_init,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 };
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index cf0d8ed4d18e..7eeefb29ed90 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -335,6 +335,14 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_apic_init_signal_blocked(vcpu);
+}
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -363,6 +371,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
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
 	if (is_td_vcpu(vcpu)) {
@@ -726,13 +753,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 #endif
 
 	.check_emulate_instruction = vmx_check_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vt_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
+	.vcpu_deliver_init = vt_vcpu_deliver_init,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2dd5fe926a0e..21cf12a859fd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -819,8 +819,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 
-	/* Ignore INIT silently because TDX doesn't support INIT event. */
-	if (init_event)
+	/* vcpu_deliver_init method silently discards INIT event. */
+	if (KVM_BUG_ON(init_event, vcpu->kvm))
 		return;
 	if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
 		return;
-- 
2.25.1


