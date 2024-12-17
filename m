Return-Path: <kvm+bounces-33948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B6F9F4D8F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BFEA16B321
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6551F706F;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUwDUlZ1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63371F543B;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445407; cv=none; b=ptAitj2if1RTM8k8qw7fNmvm24RNpuMmGXLvavdM8wCWa75YzmvCM2L3fsfAl4TdPLo4XZnQofaoezaL9MejyEm2yW3Qpu2TO8NqTiVmTirm1ftDZ4DDRjZXDJYGU4eG3CJugsyxiL4lKnl8JLrQhNKlb/HOaxMEgDz/uJzXOSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445407; c=relaxed/simple;
	bh=iwynNgxiTg5tjMuA1lb6CebO8gbDVUKdRJuqBc3tjBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lHn0G83D7yg/WXe/4DeM+gsDJ2SLfj9Q6mK4Yhw87Vj1+eOxCVXv0vvZJ+Avsghy3pfOgd/Nvw0U0l/s9dWH6TYwV98mRrSl8Ii5SzRKI82fhHliy4vIM5DweJ04qWSfo7aEN+IF0q9Qm6zkk3CcSCLqXNLqxOgFleFvCNdTxPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUwDUlZ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C82DC4CEDE;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445407;
	bh=iwynNgxiTg5tjMuA1lb6CebO8gbDVUKdRJuqBc3tjBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUwDUlZ13uocPrHiEJ0w5lrsyAf0fi99yJKhuTOCmYRCbM9BffmtOyJhJCrv9J+4d
	 2DZugmkGL/GQjTaMuCn2UTwWIKvJBeY+n7a/3xBcT6sGQQm3JSkGfXq1X9punmkLjs
	 H3QqO4w0Ma73sUfFYPgOqiy1Yj2YIZkXcj8byazVBZe1MOAuLXrswgkNu4+hCo2+Ye
	 FCKHRyaFeorplTXkXp6F2OdMkDPjB35m/u3ZEGSu/PtL6osatg6gYDJi2NJlnUW5Oh
	 JoeQVVqONwi9RVe9ZE4CfyXrazTHu66Dmi213JSXq4toETg6tI6HY50kFlIOOk7JJY
	 xkqlv1aEoMcdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTt-004aJx-FZ;
	Tue, 17 Dec 2024 14:23:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 05/12] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in use
Date: Tue, 17 Dec 2024 14:23:13 +0000
Message-Id: <20241217142321.763801-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although FEAT_ECV allows us to correctly emulate the timers, it also
reduces performances pretty badly.

Mitigate this by emulating the CTL/CVAL register reads in the
inner run loop, without returning to the general kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c             | 21 +-----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 ++
 arch/arm64/kvm/hyp/vhe/switch.c         | 99 +++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h            | 15 ++++
 4 files changed, 122 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index b6a06bda9e534..6f04f31c0a7f2 100644
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
@@ -964,10 +949,10 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
 	 * which allows trapping of the timer registers even with NV2.
 	 * Still, this is still worse than FEAT_NV on its own. Meh.
 	 */
-	if (cpus_have_final_cap(ARM64_HAS_ECV) || !is_hyp_ctxt(vcpu))
-		return;
-
 	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		if (cpus_have_final_cap(ARM64_HAS_ECV))
+			return;
+
 		/*
 		 * A non-VHE guest hypervisor doesn't have any direct access
 		 * to its timers: the EL2 registers trap (and the HW is
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 34f53707892df..30e572de28749 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -501,6 +501,11 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
+{
+	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
+}
+
 static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *ctxt;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c39959..51119d58ecff8 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -256,6 +256,102 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 	host_data_ptr(host_ctxt)->__hyp_running_vcpu = NULL;
 }
 
+static u64 compute_emulated_cntx_ctl_el0(struct kvm_vcpu *vcpu,
+					 enum vcpu_sysreg reg)
+{
+	unsigned long ctl;
+	u64 cval, cnt;
+	bool stat;
+
+	switch (reg) {
+	case CNTP_CTL_EL0:
+		cval = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		ctl  = __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		cnt  = compute_counter_value(vcpu_ptimer(vcpu));
+		break;
+	case CNTV_CTL_EL0:
+		cval = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		ctl  = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		cnt  = compute_counter_value(vcpu_vtimer(vcpu));
+		break;
+	default:
+		BUG();
+	}
+
+	stat = cval <= cnt;
+	__assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &ctl, stat);
+
+	return ctl;
+}
+
+static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr, val;
+
+	/*
+	 * Having FEAT_ECV allows for a better quality of timer emulation.
+	 * However, this comes at a huge cost in terms of traps. Try and
+	 * satisfy the reads from guest's hypervisor context without
+	 * returning to the kernel if we can.
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
+		val = compute_emulated_cntx_ctl_el0(vcpu, CNTP_CTL_EL0);
+		break;
+	case SYS_CNTP_CTL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val = read_sysreg_el0(SYS_CNTP_CTL);
+		else
+			val = compute_emulated_cntx_ctl_el0(vcpu, CNTP_CTL_EL0);
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
+		val = compute_emulated_cntx_ctl_el0(vcpu, CNTV_CTL_EL0);
+		break;
+	case SYS_CNTV_CTL_EL0:
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val = read_sysreg_el0(SYS_CNTV_CTL);
+		else
+			val = compute_emulated_cntx_ctl_el0(vcpu, CNTV_CTL_EL0);
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
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
@@ -409,6 +505,9 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_tlbi_el2(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_timer(vcpu, exit_code))
+		return true;
+
 	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
 		return true;
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6e3f6b7ff2b22..c1ba31fab6f52 100644
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


