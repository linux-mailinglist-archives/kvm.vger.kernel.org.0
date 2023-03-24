Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF076C8033
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjCXOr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCXOrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2762B227A2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE0A262B4C
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18287C4339C;
        Fri, 24 Mar 2023 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669240;
        bh=1gXO2zyC5cMbwHmpOXydUnlVRW0dys6Eh86UA8fF158=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxmg+SSR4qORfOhjyxgAJGXrNb7zUFFbBCNgkXWf9zyUN5I4ZpHKDOVxo8A3IegKZ
         ieReoS6h0UdtElrio2pO0wO9NF7bqkUsMiVZmm7HBdSGk2dEeikYElB3Esq+UmOkKQ
         nBwdG/YAF7mlfSukjLE6BOm2jCQ/7KAl1CqW9eM2eRFmPdBsOSU0on0z2H2ZgQq5KT
         GUwxHFDuqlTiFgW+XwIWB3GLxDSkHErOZ50mgAEHACp2RyPVUu8vKyEFBpFC6ENXyT
         WT0aIq71BZW5qjjyTu9bhHxAwU0wlnAZEpTFSBdK0l0py06Gjyj82ZBPsLseDc4Y24
         Qho9MNY1LWfcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihJ-002qBP-TV;
        Fri, 24 Mar 2023 14:47:17 +0000
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
Subject: [PATCH v3 04/18] KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
Date:   Fri, 24 Mar 2023 14:46:50 +0000
Message-Id: <20230324144704.4193635-5-maz@kernel.org>
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

With ECV and CNTPOFF_EL2, it is very easy to offer an offset for
the physical timer. So let's do just that.

Nothing can set the offset yet, so this should have no effect
whatsoever (famous last words...).

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c          | 18 +++++++++++++++++-
 arch/arm64/kvm/hypercalls.c          |  2 +-
 include/clocksource/arm_arch_timer.h |  1 +
 include/kvm/arm_arch_timer.h         |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 9515c645f03d..3118ea0a1b41 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -52,6 +52,11 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
 
+static bool has_cntpoff(void)
+{
+	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
+}
+
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
@@ -84,7 +89,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	if (ctxt->offset.vm_offset)
+	if (ctxt && ctxt->offset.vm_offset)
 		return *ctxt->offset.vm_offset;
 
 	return 0;
@@ -432,6 +437,12 @@ static void set_cntvoff(u64 cntvoff)
 	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
 }
 
+static void set_cntpoff(u64 cntpoff)
+{
+	if (has_cntpoff())
+		write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
+}
+
 static void timer_save_state(struct arch_timer_context *ctx)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(ctx->vcpu);
@@ -480,6 +491,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		write_sysreg_el0(0, SYS_CNTP_CTL);
 		isb();
 
+		set_cntpoff(0);
 		break;
 	case NR_KVM_TIMERS:
 		BUG();
@@ -550,6 +562,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
+		set_cntpoff(timer_get_offset(ctx));
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
@@ -767,6 +780,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	vtimer->vcpu = vcpu;
 	vtimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.voffset;
 	ptimer->vcpu = vcpu;
+	ptimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.poffset;
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	timer_set_offset(vtimer, kvm_phys_timer_read());
@@ -1297,6 +1311,8 @@ void kvm_timer_init_vhe(void)
 	val = read_sysreg(cnthctl_el2);
 	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
 	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
+	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
+		val |= CNTHCTL_ECV;
 	write_sysreg(val, cnthctl_el2);
 }
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5da884e11337..39a4707e081d 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -47,7 +47,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.voffset;
 		break;
 	case KVM_PTP_PHYS_COUNTER:
-		cycles = systime_snapshot.cycles;
+		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.poffset;
 		break;
 	default:
 		return;
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 057c8964aefb..cbbc9a6dc571 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -21,6 +21,7 @@
 #define CNTHCTL_EVNTEN			(1 << 2)
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
+#define CNTHCTL_ECV			(1 << 12)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 70d47c4adc6a..2dd0fd2406fb 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -34,6 +34,8 @@ struct arch_timer_offset {
 struct arch_timer_vm_data {
 	/* Offset applied to the virtual timer/counter */
 	u64	voffset;
+	/* Offset applied to the physical timer/counter */
+	u64	poffset;
 };
 
 struct arch_timer_context {
-- 
2.34.1

