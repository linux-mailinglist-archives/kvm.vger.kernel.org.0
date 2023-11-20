Return-Path: <kvm+bounces-2099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F77D7F1411
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A051F24561
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18575200DC;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oljyLwoA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D801E50B;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72E3C433CD;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485857;
	bh=0nft63NYc6bBNSjAmNVmQLyhM3s05TqWgIIc+BwACEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oljyLwoADwOs8D5KYZOJXc5ZSF9CihGbS2REl85AqazzYiuzJO05v01aOYvvaTz+g
	 fSqZ3leGdtR30kV+RFN4aaotZRn1qPQ7HepeVNMRIFgnqMz4+8aA6FvSzpGOQJr9Ul
	 7szxE94iTBVXxzDR/Hy5TxpK/1WKV7wqkvyNEs9Y8kQ9qB+Gvfew05s26RqfrTmr9B
	 dA1S0pnHBkL9xPiTFKDCZoR9FvnWiUHoYizAvasQXq0QspvRHEtipExlix8RSTH+P3
	 pFyagn4HMfATgMK6AcO4WKA4X3i3fAH4XG2TUKqMAjeLwaAnPbwbHYdkyitL/5funk
	 g/OApTRXkeffg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543E-00EjnU-0w;
	Mon, 20 Nov 2023 13:10:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 27/43] KVM: arm64: nv: Sync nested timer state with FEAT_NV2
Date: Mon, 20 Nov 2023 13:10:11 +0000
Message-Id: <20231120131027.854038-28-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Emulating the timers with FEAT_NV2 is a bit odd, as the timers
can be reconfigured behind our back without the hypervisor even
noticing. In the VHE case, that's an actual regression in the
architecture...

Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 44 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c         |  3 +++
 include/kvm/arm_arch_timer.h |  1 +
 3 files changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 9dec8c419bf4..e3f6feef2c83 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -906,6 +906,50 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 		kvm_timer_blocking(vcpu);
 }
 
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When NV2 is on, guest hypervisors have their EL0 timer register
+	 * accesses redirected to the VNCR page. Any guest action taken on
+	 * the timer is postponed until the next exit, leading to a very
+	 * poor quality of emulation.
+	 */
+	if (!is_hyp_ctxt(vcpu))
+		return;
+
+	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		/*
+		 * A non-VHE guest hypervisor doesn't have any direct access
+		 * to its timers: the EL2 registers trap (and the HW is
+		 * fully emulated), while the EL0 registers access memory
+		 * despite the access being notionally direct. Boo.
+		 *
+		 * We update the hardware timer registers with the
+		 * latest value written by the guest to the VNCR page
+		 * and let the hardware take care of the rest.
+		 */
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
+	} else {
+		/*
+		 * For a VHE guest hypervisor, the EL2 state is directly
+		 * stored in the host EL0 timers, while the emulated EL0
+		 * state is stored in the VNCR page. The latter could have
+		 * been updated behind our back, and we must reset the
+		 * emulation of the timers.
+		 */
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
index 2e76892c1a56..35f079c3026c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1093,6 +1093,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_user(vcpu);
 
+		if (vcpu_has_nv(vcpu))
+			kvm_timer_sync_nested(vcpu);
+
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
 		/*
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index fd650a8789b9..6e3f6b7ff2b2 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -98,6 +98,7 @@ int __init kvm_timer_hyp_init(bool has_gic);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
-- 
2.39.2


