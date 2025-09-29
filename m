Return-Path: <kvm+bounces-59004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7161BA9F19
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A33FE189C4E2
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752B430E0DD;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAO8Irxg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0437F30CD9F;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=Hpa0wuornpzot58GyCPa3sqxS4yRm03voYRgcvOOCGUqaha0z4n7l0zMUrRwscyC/rYkxDY98wzegwWr2Hmr1TZ301Ss3KFfRc8TEUySNVQRkGCCni86FQMuPo6CzHMM7/uZ/Elmwe7NPFFga2M1hvMAvyWDmUKVfy7UYczb50w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=u6G8PNKp2xjKEJAmhCH+1Uo0BopwqaufjMccdpUo0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoyPb+jEY1lzH4Im+Blr9HTkE2u17U+TN6j5pOAyTZX2nsgYjvETvQhRpl7sH8QxiqBQ2Gl12h0pBLrsm4q4kiMaIg9gzr8i59+1+QIFESsheQBHr71k/zqYH+mknlRUj7l/q7Gq8drs2ReFrDLRxzNVnK4CXdg7jWyP04rc/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAO8Irxg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD56C4CEF7;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161906;
	bh=u6G8PNKp2xjKEJAmhCH+1Uo0BopwqaufjMccdpUo0cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAO8IrxgkAahyJbHN8LOOj963a09cpU8UCioFH5LVgL0zSNVJ0OUcPqT9jw9WTkOL
	 mc9jC+MucvIQE8jhnVinyGzz39Q4MZRW3sfM8UiACn5Kw13DK5bGjaz1jMKmRZWtOO
	 +KJ9vpBtkSF9vQ17gUEl9T26++18/t+Pf2eybQV51Ow1mFnQHfEurYABgzIf9l5pxe
	 gP5R3zU1JBkaoiP03vCNQZe0q2s66az866Voy4zSZ1u2VR0r82CunrBdgbLoC/bB7q
	 u3BCqiSvovee0hPsKKuKHV+SUzps/zbm2/HpryCP4+8PRF6ndLS0jvHxLbAEFYdYPY
	 s7SYg+uNciFMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN7-0000000AHqo-06KI;
	Mon, 29 Sep 2025 16:05:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/13] KVM: arm64: Move CNT*_CVAL_EL0 userspace accessors to generic infrastructure
Date: Mon, 29 Sep 2025 17:04:51 +0100
Message-ID: <20250929160458.3351788-8-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As for the control registers, move the comparator registers to
the common infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c    | 4 ----
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dea648706fd52..c23ec9be4ce27 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -593,9 +593,7 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 
 static const u64 timer_reg_list[] = {
 	KVM_REG_ARM_TIMER_CNT,
-	KVM_REG_ARM_TIMER_CVAL,
 	KVM_REG_ARM_PTIMER_CNT,
-	KVM_REG_ARM_PTIMER_CVAL,
 };
 
 #define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
@@ -604,9 +602,7 @@ static bool is_timer_reg(u64 index)
 {
 	switch (index) {
 	case KVM_REG_ARM_TIMER_CNT:
-	case KVM_REG_ARM_TIMER_CVAL:
 	case KVM_REG_ARM_PTIMER_CNT:
-	case KVM_REG_ARM_PTIMER_CVAL:
 		return true;
 	}
 	return false;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d97aacf4c1dc9..68e88d5c0dfb5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3512,11 +3512,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTVCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
 	TIMER_REG(CNTP_CTL_EL0, NULL),
-	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
+	TIMER_REG(CNTP_CVAL_EL0, NULL),
 
 	{ SYS_DESC(SYS_CNTV_TVAL_EL0), access_arch_timer },
 	TIMER_REG(CNTV_CTL_EL0, NULL),
-	{ SYS_DESC(SYS_CNTV_CVAL_EL0), access_arch_timer },
+	TIMER_REG(CNTV_CVAL_EL0, NULL),
 
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
@@ -3715,11 +3715,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
 	TIMER_REG(CNTHP_CTL_EL2, el2_visibility),
-	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
+	TIMER_REG(CNTHP_CVAL_EL2, el2_visibility),
 
 	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer, .visibility = cnthv_visibility },
 	TIMER_REG(CNTHV_CTL_EL2, cnthv_visibility),
-	EL2_REG_FILTERED(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0, cnthv_visibility),
+	TIMER_REG(CNTHV_CVAL_EL2, cnthv_visibility),
 
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
 
-- 
2.47.3


