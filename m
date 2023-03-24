Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0B6C80C8
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjCXPLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjCXPLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7B16AEA
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAEDFB824F6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974E5C433D2;
        Fri, 24 Mar 2023 15:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679670654;
        bh=EFdKmxMZ/L8dcuppLUDaXdLCYutzcEPNTP5KAinuIs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0frkdyM4fbtMYYrs7K2ETLGLjVgD1bosXgawHRwAXUBb2o3ouQ/U8c8nfAEkz9iU
         sgKU0p1rJmiiSAqCrVzSGhUCgdxhfSTOExBQQT/4UFwDAApAUQQIY1rT8QxCOf+rfp
         e7Zect75UkydVNwcSWaGDjt1EEc6m7ipmfKGNZQUAKwUEBQtfch72XsN4B1ZV6uuMt
         WqrFpKwibWR0zAN8pDFP78uC2ILEbQiw0cqy/GZymU3O8pIRVSMuuRRujawuxV0tqS
         SIj25dExVHB5RtoJazp+u2b4ZAkqelTYISIlAwd86W1UAnxlf3nEOkQ0VuG68eqg58
         80giQmENnEpLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihL-002qBP-Jm;
        Fri, 24 Mar 2023 14:47:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v3 11/18] KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
Date:   Fri, 24 Mar 2023 14:46:57 +0000
Message-Id: <20230324144704.4193635-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having the timer IRQs duplicated into each vcpu isn't great, and
becomes absolutely awful with NV. So let's move these into
the per-VM arch_timer_vm_data structure.

This simplifies a lot of code, but requires us to introduce a
mutex so that we can reason about userspace trying to change
an interrupt number while another vcpu is running, something
that wasn't really well handled so far.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/arch_timer.c       | 104 +++++++++++++++++-------------
 arch/arm64/kvm/arm.c              |   2 +
 include/kvm/arm_arch_timer.h      |  18 ++++--
 4 files changed, 78 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 116233a390e9..1280154c9ef3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -223,6 +223,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
 	/* VM counter offset */
 #define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
+	/* Timer PPIs made immutable */
+#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
 
 	unsigned long flags;
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 7cd0b0947454..88a38d45d352 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -851,7 +851,6 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	hrtimer_init(&ctxt->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	ctxt->hrtimer.function = kvm_hrtimer_expire;
-	timer_irq(ctxt) = default_ppi[timerid];
 
 	switch (timerid) {
 	case TIMER_PTIMER:
@@ -880,6 +879,13 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	timer->bg_timer.function = kvm_bg_timer_expire;
 }
 
+void kvm_timer_init_vm(struct kvm *kvm)
+{
+	mutex_init(&kvm->arch.timer_data.lock);
+	for (int i = 0; i < NR_KVM_TIMERS; i++)
+		kvm->arch.timer_data.ppi[i] = default_ppi[i];
+}
+
 void kvm_timer_cpu_up(void)
 {
 	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
@@ -1292,44 +1298,52 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	int vtimer_irq, ptimer_irq, ret;
-	unsigned long i;
+	u32 ppis = 0;
 
-	vtimer_irq = timer_irq(vcpu_vtimer(vcpu));
-	ret = kvm_vgic_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
-	if (ret)
-		return false;
+	mutex_lock(&vcpu->kvm->arch.timer_data.lock);
 
-	ptimer_irq = timer_irq(vcpu_ptimer(vcpu));
-	ret = kvm_vgic_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
-	if (ret)
-		return false;
+	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+		struct arch_timer_context *ctx;
+		int irq;
 
-	kvm_for_each_vcpu(i, vcpu, vcpu->kvm) {
-		if (timer_irq(vcpu_vtimer(vcpu)) != vtimer_irq ||
-		    timer_irq(vcpu_ptimer(vcpu)) != ptimer_irq)
-			return false;
+		ctx = vcpu_get_timer(vcpu, i);
+		irq = timer_irq(ctx);
+		if (kvm_vgic_set_owner(vcpu, irq, ctx))
+			break;
+
+		/*
+		 * We know by construction that we only have PPIs, so
+		 * all values are less than 32.
+		 */
+		ppis |= BIT(irq);
 	}
 
-	return true;
+	set_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE, &vcpu->kvm->arch.flags);
+
+	mutex_unlock(&vcpu->kvm->arch.timer_data.lock);
+
+	return hweight32(ppis) == NR_KVM_TIMERS;
 }
 
 bool kvm_arch_timer_get_input_level(int vintid)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-	struct arch_timer_context *timer;
 
 	if (WARN(!vcpu, "No vcpu context!\n"))
 		return false;
 
-	if (vintid == timer_irq(vcpu_vtimer(vcpu)))
-		timer = vcpu_vtimer(vcpu);
-	else if (vintid == timer_irq(vcpu_ptimer(vcpu)))
-		timer = vcpu_ptimer(vcpu);
-	else
-		BUG();
+	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+		struct arch_timer_context *ctx;
+
+		ctx = vcpu_get_timer(vcpu, i);
+		if (timer_irq(ctx) == vintid)
+			return kvm_timer_should_fire(ctx);
+	}
 
-	return kvm_timer_should_fire(timer);
+	/* A timer IRQ has fired, but no matching timer was found? */
+	WARN_RATELIMIT(1, "timer INTID%d unknown\n", vintid);
+
+	return false;
 }
 
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
@@ -1385,23 +1399,10 @@ void kvm_timer_init_vhe(void)
 		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
 }
 
-static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
-{
-	struct kvm_vcpu *vcpu;
-	unsigned long i;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		timer_irq(vcpu_vtimer(vcpu)) = vtimer_irq;
-		timer_irq(vcpu_ptimer(vcpu)) = ptimer_irq;
-	}
-}
-
 int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	int irq;
+	int irq, idx, ret = 0;
 
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return -EINVAL;
@@ -1412,21 +1413,36 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (!(irq_is_ppi(irq)))
 		return -EINVAL;
 
-	if (vcpu->arch.timer_cpu.enabled)
-		return -EBUSY;
+	mutex_lock(&vcpu->kvm->arch.timer_data.lock);
+
+	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
+		     &vcpu->kvm->arch.flags)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
-		set_timer_irqs(vcpu->kvm, irq, timer_irq(ptimer));
+		idx = TIMER_VTIMER;
 		break;
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
-		set_timer_irqs(vcpu->kvm, timer_irq(vtimer), irq);
+		idx = TIMER_PTIMER;
 		break;
 	default:
-		return -ENXIO;
+		ret = -ENXIO;
+		goto out;
 	}
 
-	return 0;
+	/*
+	 * We cannot validate the IRQ unicity before we run, so take it at
+	 * face value. The verdict will be given on first vcpu run, for each
+	 * vcpu. Yes this is late. Blame it on the stupid API.
+	 */
+	vcpu->kvm->arch.timer_data.ppi[idx] = irq;
+
+out:
+	mutex_unlock(&vcpu->kvm->arch.timer_data.lock);
+	return ret;
 }
 
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1c8a4bbae684..4c5e9dfbf83a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -148,6 +148,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_vgic_early_init(kvm);
 
+	kvm_timer_init_vm(kvm);
+
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 27cada09f588..f093ea9f540d 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -36,14 +36,16 @@ struct arch_timer_vm_data {
 	u64	voffset;
 	/* Offset applied to the physical timer/counter */
 	u64	poffset;
+
+	struct mutex	lock;
+
+	/* The PPI for each timer, global to the VM */
+	u8	ppi[NR_KVM_TIMERS];
 };
 
 struct arch_timer_context {
 	struct kvm_vcpu			*vcpu;
 
-	/* Timer IRQ */
-	struct kvm_irq_level		irq;
-
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
 	u64				ns_frac;
@@ -57,6 +59,11 @@ struct arch_timer_context {
 	 */
 	bool				loaded;
 
+	/* Output level of the timer IRQ */
+	struct {
+		bool			level;
+	} irq;
+
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
 };
@@ -86,6 +93,8 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
+void kvm_timer_init_vm(struct kvm *kvm);
+
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
 int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
 
@@ -109,7 +118,8 @@ bool kvm_arch_timer_get_input_level(int vintid);
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
-#define timer_irq(ctx)			((ctx)->irq.irq)
+#define timer_vm_data(ctx)		(&(ctx)->vcpu->kvm->arch.timer_data)
+#define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx)])
 
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
-- 
2.34.1

