Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241FC6B77F9
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 13:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCMMtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCMMs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 08:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC322CFFC
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 05:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E329B81071
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 12:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C73C433D2;
        Mon, 13 Mar 2023 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678711733;
        bh=4bJ3J6pFQm4HD8LaHyxFJDa0kckSx5QJN4hO2pYexLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VI00s0pxYPllC0AMB7o+M+YZqmdXzaLBVHuRBOLN36DUZJGALP+eKtciIq+9xgfcy
         eP6eRTvbpSDmydE3rNH5vfqJfM3HGzNbkXqW8GHEIPx0AMcSL/Pci9/dBR9AJNin8k
         MyhPBnhSBRb/tYKRUsWmZtnfUSx7tjQo5mBKhge9ZLklagzv6Cj7Fcnj/bKBW7DJB3
         0/V8PWU/ZLXk03bfcyRA+BRMVXyTK403AL/2wrMOh/r9CHi3TMA7dYo6xAD5n19bRT
         Iq+tVkPzQAFo343FDUj6x+BH7bOnNN/Zk0b7qZT/UtVUc5DUt1UPktf7ISkkH+H90G
         39gEq6pvItSXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbf-00HEdE-PY;
        Mon, 13 Mar 2023 12:48:51 +0000
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
Subject: [PATCH v2 01/19] KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
Date:   Mon, 13 Mar 2023 12:48:19 +0000
Message-Id: <20230313124837.2264882-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having a per-vcpu virtual offset is a pain. It needs to be synchronized
on each update, and expands badly to a setup where different timers can
have different offsets, or have composite offsets (as with NV).

So let's start by replacing the use of the CNTVOFF_EL2 shadow register
(which we want to reclaim for NV anyway), and make the virtual timer
carry a pointer to a VM-wide offset.

This simplifies the code significantly. It also addresses two terrible bugs:

- The use of CNTVOFF_EL2 leads to some nice offset corruption
  when the sysreg gets reset, as reported by Joey.

- The kvm mutex is taken from a vcpu ioctl, which goes against
  the locking rules...

Reported-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230224173915.GA17407@e124191.cambridge.arm.com
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arch_timer.c       | 45 +++++++------------------------
 arch/arm64/kvm/hypercalls.c       |  2 +-
 include/kvm/arm_arch_timer.h      | 15 +++++++++++
 4 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..bcd774d74f34 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -193,6 +193,9 @@ struct kvm_arch {
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
+	/* Timers */
+	struct arch_timer_vm_data timer_data;
+
 	/* Mandated version of PSCI */
 	u32 psci_version;
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 00610477ec7b..e1af4301b913 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -84,14 +84,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
+	if (ctxt->offset.vm_offset)
+		return *ctxt->offset.vm_offset;
 
-	switch(arch_timer_ctx_index(ctxt)) {
-	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
-	default:
-		return 0;
-	}
+	return 0;
 }
 
 static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
@@ -128,15 +124,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
-	switch(arch_timer_ctx_index(ctxt)) {
-	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
-		break;
-	default:
+	if (!ctxt->offset.vm_offset) {
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+		return;
 	}
+
+	WRITE_ONCE(*ctxt->offset.vm_offset, offset);
 }
 
 u64 kvm_phys_timer_read(void)
@@ -765,25 +758,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/* Make the updates of cntvoff for all vtimer contexts atomic */
-static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
-{
-	unsigned long i;
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_vcpu *tmp;
-
-	mutex_lock(&kvm->lock);
-	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
-
-	/*
-	 * When called from the vcpu create path, the CPU being created is not
-	 * included in the loop above, so we just set it here as well.
-	 */
-	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
-	mutex_unlock(&kvm->lock);
-}
-
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -791,10 +765,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	vtimer->vcpu = vcpu;
+	vtimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.voffset;
 	ptimer->vcpu = vcpu;
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
-	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
+	timer_set_offset(vtimer, kvm_phys_timer_read());
 	timer_set_offset(ptimer, 0);
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
@@ -840,7 +815,7 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
 		timer = vcpu_vtimer(vcpu);
-		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
+		timer_set_offset(timer, kvm_phys_timer_read() - value);
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
 		timer = vcpu_vtimer(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 64c086c02c60..5da884e11337 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -44,7 +44,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	feature = smccc_get_arg1(vcpu);
 	switch (feature) {
 	case KVM_PTP_VIRT_COUNTER:
-		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.voffset;
 		break;
 	case KVM_PTP_PHYS_COUNTER:
 		cycles = systime_snapshot.cycles;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 71916de7c6c4..c52a6e6839da 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -23,6 +23,19 @@ enum kvm_arch_timer_regs {
 	TIMER_REG_CTL,
 };
 
+struct arch_timer_offset {
+	/*
+	 * If set, pointer to one of the offsets in the kvm's offset
+	 * structure. If NULL, assume a zero offset.
+	 */
+	u64	*vm_offset;
+};
+
+struct arch_timer_vm_data {
+	/* Offset applied to the virtual timer/counter */
+	u64	voffset;
+};
+
 struct arch_timer_context {
 	struct kvm_vcpu			*vcpu;
 
@@ -32,6 +45,8 @@ struct arch_timer_context {
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
 
+	/* Offset for this counter/timer */
+	struct arch_timer_offset	offset;
 	/*
 	 * We have multiple paths which can save/restore the timer state onto
 	 * the hardware, so we need some way of keeping track of where the
-- 
2.34.1

