Return-Path: <kvm+bounces-2113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF957F141F
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D9AB1C216B8
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2513032C;
	Mon, 20 Nov 2023 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmqACQRa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDCF225D0;
	Mon, 20 Nov 2023 13:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AECC433C7;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485861;
	bh=Br/kj0Vn+4hLI9ZQgSRNyujZTVGG2XeMTcdvl3gvXa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmqACQRaguiSNWTpnw9MSgzc2PqqaZA+OY6xePomlynIkJMD6Gv2pFDtTcYK0uWB5
	 begeyUdtrzPZy9+wul4+qPKC/I0aAcKOFGD96JEI/+uyq8/uQRUkDZAOQBvuTNIvJF
	 O4N1GxBmw1su6ioF2TW5rL2o0rcYh+0cagbkhGgHPVApAJSqSX8NJV3ZzALxijfGGo
	 imJ4P8/Ht1+n2ydqKm9ucFO+FiVptcmzKm2k6CSX4QR56KGwlnE3cEoyciTnGV5lP+
	 JSYsAPwjV8S0k2YXbL05WHBB6n6I9MXJGdvlkjCcr/BsdWYbo15ESSwQNhZV9CekIK
	 xvgVAQt008+cA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543I-00EjnU-1h;
	Mon, 20 Nov 2023 13:11:00 +0000
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
Subject: [PATCH v11 42/43] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
Date: Mon, 20 Nov 2023 13:10:26 +0000
Message-Id: <20231120131027.854038-43-maz@kernel.org>
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

Although FEAT_ECV allows us to correctly enable the timers, it also
reduces performances pretty badly (a L2 guest doing a lot of virtio
emulated in L1 userspace results in a 30% degradation).

Mitigate this by emulating the CTL/CVAL register reads in the
inner run loop, without returning to the general kernel. This halves
the overhead described above.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c     | 15 -------
 arch/arm64/kvm/hyp/vhe/switch.c | 70 +++++++++++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h    | 15 +++++++
 3 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 860f6e190e63..1ee1ede23607 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -101,21 +101,6 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 	}
 }
 
-static u64 timer_get_offset(struct arch_timer_context *ctxt)
-{
-	u64 offset = 0;
-
-	if (!ctxt)
-		return 0;
-
-	if (ctxt->offset.vm_offset)
-		offset += *ctxt->offset.vm_offset;
-	if (ctxt->offset.vcpu_offset)
-		offset += *ctxt->offset.vcpu_offset;
-
-	return offset;
-}
-
 static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 360328aaaf7c..8d1e9d1adabe 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -258,11 +258,81 @@ static bool kvm_hyp_handle_tlbi_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr, val;
+
+	/*
+	 * Having FEAT_ECV allows for a better quality of timer emulation.
+	 * However, this comes at a huge cost in terms of traps. Try and
+	 * satisfy the reads without returning to the kernel if we can.
+	 */
+	if (!is_hyp_ctxt(vcpu))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) != ESR_ELx_SYS64_ISS_DIR_READ)
+		return false;
+
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_CNTP_CTL_EL02:
+		val = __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		break;
+	case SYS_CNTP_CTL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val = read_sysreg_el0(SYS_CNTP_CTL);
+		else
+			val = __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		break;
+	case SYS_CNTP_CVAL_EL02:
+		val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		break;
+	case SYS_CNTP_CVAL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu)) {
+			val = read_sysreg_el0(SYS_CNTP_CVAL);
+
+			if (!has_cntpoff())
+				val -= timer_get_offset(vcpu_hptimer(vcpu));
+		} else {
+			val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		}
+		break;
+	case SYS_CNTV_CTL_EL02:
+		val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		break;
+	case SYS_CNTV_CTL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val = read_sysreg_el0(SYS_CNTV_CTL);
+		else
+			val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		break;
+	case SYS_CNTV_CVAL_EL02:
+		val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		break;
+	case SYS_CNTV_CVAL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val = read_sysreg_el0(SYS_CNTV_CVAL);
+		else
+			val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		break;
+	default:
+		return false;
+	}
+
+	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el1(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_timer(vcpu, exit_code))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6e3f6b7ff2b2..c1ba31fab6f5 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -156,4 +156,19 @@ static inline bool has_cntpoff(void)
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
 }
 
+static inline u64 timer_get_offset(struct arch_timer_context *ctxt)
+{
+	u64 offset = 0;
+
+	if (!ctxt)
+		return 0;
+
+	if (ctxt->offset.vm_offset)
+		offset += *ctxt->offset.vm_offset;
+	if (ctxt->offset.vcpu_offset)
+		offset += *ctxt->offset.vcpu_offset;
+
+	return offset;
+}
+
 #endif
-- 
2.39.2


