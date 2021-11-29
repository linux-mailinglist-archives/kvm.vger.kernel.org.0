Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFA54623B6
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhK2Vvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhK2Vtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:49:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DA1C091D33
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 03F5DCE1415
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A25C53FAD;
        Mon, 29 Nov 2021 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216435;
        bh=73WEl2HJUcNvT9k7Ef97DgLn0GX0d41PDzy3ICstomo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACVv2xOGlyYai2+rLvYimdDuBF7DCOsW3O/vWj3NCEWeKfgeciNo8hXMdUIrIm19Z
         r+8LRRLKMC9hkza8gErRokgllQ/cl22Raga/zhEqsCdTVFug4nunjzklplm8Z6cplT
         kqz4/UVpL+M1yZwiWwcBAvXBTdf6uUgGUfcqRUCKhXX58kSWbIeBSqyNi933ZeQt4S
         kbhc58vyabkcDLgYOZQYuNzJoLtYmC0U6DZvSUk7XiKu7FU9HcEHGXBJD112h3UaFI
         TuM12uE3juqt64+s9c3ikulgbGPtBZwLCGcOi7Zx6iOvlKYfrHfoGxTNbjHInvPCBI
         DdzL2jrUGfZRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrI-008gvR-03; Mon, 29 Nov 2021 20:02:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 65/69] KVM: arm64: nv: Sync nested timer state with ARMv8.4
Date:   Mon, 29 Nov 2021 20:01:46 +0000
Message-Id: <20211129200150.351436-66-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Emulating the ARMv8.4-NV timers is a bit odd, as the timers can
be reconfigured behind our back without the hypervisor even
noticing. In the VHE case, that's an actual regression in the
architecture...

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 37 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c         |  3 +++
 include/kvm/arm_arch_timer.h |  1 +
 3 files changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3e80c3bdd8ce..35fbf0e83b38 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -786,6 +786,43 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	set_cntvoff(0);
 }
 
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
+{
+	if (!is_hyp_ctxt(vcpu))
+		return;
+
+	/*
+	 * Guest hypervisors using ARMv8.4 enhanced nested virt support have
+	 * their EL1 timer register accesses redirected to the VNCR page.
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		/*
+		 * For a non-VHE guest hypervisor, we update the hardware
+		 * timer registers with the latest value written by the guest
+		 * to the VNCR page and let the hardware take care of the
+		 * rest.
+		 */
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
+	} else {
+		/*
+		 * For a VHE guest hypervisor, the emulated state (which
+		 * is stored in the VNCR page) could have been updated behind
+		 * our back, and we must reset the emulation of the timers.
+		 */
+
+		struct timer_map map;
+		get_timer_map(vcpu, &map);
+
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
+		soft_timer_cancel(&map.emul_ptimer->hrtimer);
+		timer_emulate(map.emul_vtimer);
+		timer_emulate(map.emul_ptimer);
+	}
+}
+
 /*
  * With a userspace irqchip we have to check if the guest de-asserted the
  * timer and if so, unmask the timer irq signal on the host interrupt
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index dc1fda709cf5..f20bdf1deb72 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -902,6 +902,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_user(vcpu);
 
+		if (enhanced_nested_virt_in_use(vcpu))
+			kvm_timer_sync_nested(vcpu);
+
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
 		/*
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 0a76dac8cb6a..89b08e5b456e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -68,6 +68,7 @@ int kvm_timer_hyp_init(bool);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
-- 
2.30.2

