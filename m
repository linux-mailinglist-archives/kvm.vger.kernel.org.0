Return-Path: <kvm+bounces-32831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0098A9E09BC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4DFB2828F4
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2641DDC23;
	Mon,  2 Dec 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdcoHz4i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE71DAC95;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160139; cv=none; b=LXsls9IwywMXGl5zP1VJJJhgi3dpZUDo4X/WISCRsPKjKEQTBQ6y+7DncYtqZEEsZ+kGQ5xF1rKfzC6WhjkYSf/Akw7+Zuj0hAPVS3jUkLb7ES3LSJAJ3Ce2HwWbw/5TANx+JRibXxAwu2Usy3o3xrGhvuNdsoxHnlvZmxNwPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160139; c=relaxed/simple;
	bh=J7TuCkQQXw+zmd80r09KMLYg2hEdv2a0XVnhIHkAbss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bSQ/Kt5RExcDO0l5CxI/c9Y7ESZPs8YVPamVHPH/N6L9JPQawxDwsbJXtERDTP8pY8IpagiUtuls4PPo4QyJIM4dBUkmmSPhRnKUYYl6nBTC7UrCEsKIalARfRFcxKCPURRMQ5Ivy1mGIYntjLq6caNdmB89olag03O3QqDpzbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdcoHz4i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F1DC4CED9;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160138;
	bh=J7TuCkQQXw+zmd80r09KMLYg2hEdv2a0XVnhIHkAbss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdcoHz4iTIJIXtUnsr61yVLJ8PmKBzRNZKiU81xSEL+NiO3t2JPPtc1OrgHlwRyM2
	 H70RAVFBHtpl9zDZKhpRJ+fuiOtZA6FRkvm+uaiCmJ3X7BUNUdthCi5WC+O/3RKRi/
	 DL4L04g+IxHM3AwSQM3Y728ZDnBhfc9BRdWUiR4CtQEI728XAnbV+u+Mux3mETLnIT
	 /glsemXKqWYqIG/6np74nCuk++sZINMLMfc3zrJZCo3K5Up7xgx8jI5b94UmmgO0LL
	 g9YQa+yKB9sOG53wJcG0NJOBmfms95UZ2KMlPsLaxzQ2UY1LKpCNYgjDJtNwrpERgo
	 yEdhUutLoqAjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7k-00HQcf-Of;
	Mon, 02 Dec 2024 17:22:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 05/11] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in use
Date: Mon,  2 Dec 2024 17:21:28 +0000
Message-Id: <20241202172134.384923-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although FEAT_ECV allows us to correctly emulate the timers, it also
reduces performances pretty badly.

Mitigate this by emulating the CTL/CVAL register reads in the
inner run loop, without returning to the general kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c     | 15 -------
 arch/arm64/kvm/hyp/vhe/switch.c | 71 +++++++++++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h    | 15 +++++++
 3 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c9a46d34b40cf..2c4499dd63732 100644
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
index 80581b1c39959..b014b0b10bf5d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -256,6 +256,74 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 	host_data_ptr(host_ctxt)->__hyp_running_vcpu = NULL;
 }
 
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
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
@@ -409,6 +477,9 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
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


