Return-Path: <kvm+bounces-32832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D559E0B60
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AEFAB82C8C
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1651DDC1C;
	Mon,  2 Dec 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8KHb45W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B351DAC97;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160139; cv=none; b=BWuTg5j9ALcGlw2IrZQdVndMhSzertKITpN3PRKz7zHabp2ZEpoNRvmn383870sDpI9x8OzWcvSjj6fvcKFqYzHYn3jB/hN4IPV3Giww3qkJQN2q280b7rb1JSzIVf1wVCoXhH1EOxxVcGk+6spb9dkJ7Z3rSbS8XqYaR8VPsUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160139; c=relaxed/simple;
	bh=CGFMUWAc7R/pzG+BdDvL9qb/+zRbaJapu9cFFQKoOsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fUm0rnJJ90KDzNoU27OuzD9Uyx4e1pglPpfjG1Rdjjw7cmQns+ZteQ+dDTM3BqlINKvp+iBLeMwz+SUu2gaFU2azI/8TcCLCifCv3zNL8PvRF7xZov7ffKWe5Ae4OzuzB5Oj9pK8WWROD3fYhSdOF6IQrKHAes88UEGRmuMDOZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8KHb45W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBEDC4CED2;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160138;
	bh=CGFMUWAc7R/pzG+BdDvL9qb/+zRbaJapu9cFFQKoOsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8KHb45Wq9YzhPKnCSo+9tKf/rlMmZm1JIWGAp2+qbTDUdO1Yv/zGOJ7+8WvUQJby
	 BlLsX0RTj86yKbBWe7BTl12zE4NfD0qiPd4V5XCWfIKWkb5hpLOyKuB37w1uCzeQ+C
	 7RqDH3tc7cA6GQC55cI/8+UrL+yDcdMDkptcUFnO5StCGT0TNv3VpcShUalrU1dk3o
	 y6pnm+ELB0oAsvN2F8JfDsQ5FOQT0j8m03vIH+HQAOpVUtJBeLaDjU9E0MlgiQ1Dvm
	 DrmLkjBr8LIMMPdqzJouOcD7EJ1OsJK9LTc2Mwup61j2PMIxKIhm+A/RtsMrbrqHtl
	 JACZTjkZDfpVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7k-00HQcf-IA;
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
Subject: [PATCH 04/11] KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
Date: Mon,  2 Dec 2024 17:21:27 +0000
Message-Id: <20241202172134.384923-5-maz@kernel.org>
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

Although FEAT_NV2 makes most things fast, it also makes it impossible
to correctly emulate the timers, as the sysreg accesses are redirected
to memory.

FEAT_ECV addresses this by giving a hypervisor the ability to trap
the EL02 sysregs as well as the virtual timer.

Add the required trap setting to make use of the feature, allowing
us to elide the ugly resync in the middle of the run loop.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c          | 36 +++++++++++++++++++++++++---
 include/clocksource/arm_arch_timer.h |  2 ++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 231040090697e..c9a46d34b40cf 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -781,7 +781,7 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 
 static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	bool tpt, tpc;
+	bool tvt, tpt, tvc, tpc, tvt02, tpt02;
 	u64 clr, set;
 
 	/*
@@ -796,7 +796,29 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	 * within this function, reality kicks in and we start adding
 	 * traps based on emulation requirements.
 	 */
-	tpt = tpc = false;
+	tvt = tpt = tvc = tpc = false;
+	tvt02 = tpt02 = false;
+
+	/*
+	 * NV2 badly breaks the timer semantics by redirecting accesses to
+	 * the EL0 timer state to memory, so let's call ECV to the rescue if
+	 * available: we trap all CNT{P,V}_{CTL,CVAL,TVAL}_EL0 accesses.
+	 *
+	 * The treatment slightly varies depending whether we run a nVHE or
+	 * VHE guest: nVHE will use the _EL0 registers directly, while VHE
+	 * will use the _EL02 accessors. This translates in different trap
+	 * bits.
+	 *
+	 * None of the trapping is required when running in non-HYP context,
+	 * unless required by the L1 hypervisor settings once we advertise
+	 * ECV+NV in the guest, or that we need trapping for other reasons.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_ECV) && is_hyp_ctxt(vcpu)) {
+		if (vcpu_el2_e2h_is_set(vcpu))
+			tvt02 = tpt02 = true;
+		else
+			tvt = tpt = true;
+	}
 
 	/*
 	 * We have two possibility to deal with a physical offset:
@@ -836,6 +858,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
 	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
+	assign_clear_set_bit(tvt, CNTHCTL_EL1TVT, clr, set);
+	assign_clear_set_bit(tvc, CNTHCTL_EL1TVCT, clr, set);
+	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
+	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
 
 	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
 	sysreg_clear_set(cnthctl_el2, clr, set);
@@ -931,8 +957,12 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
 	 * accesses redirected to the VNCR page. Any guest action taken on
 	 * the timer is postponed until the next exit, leading to a very
 	 * poor quality of emulation.
+	 *
+	 * This is an unmitigated disaster, only papered over by FEAT_ECV,
+	 * which allows trapping of the timer registers even with NV2.
+	 * Still, this is still worse than FEAT_NV on its own. Meh.
 	 */
-	if (!is_hyp_ctxt(vcpu))
+	if (cpus_have_final_cap(ARM64_HAS_ECV) || !is_hyp_ctxt(vcpu))
 		return;
 
 	if (!vcpu_el2_e2h_is_set(vcpu)) {
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 877dcbb2601ae..c62811fb41309 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -24,6 +24,8 @@
 #define CNTHCTL_ECV			(1 << 12)
 #define CNTHCTL_EL1TVT			(1 << 13)
 #define CNTHCTL_EL1TVCT			(1 << 14)
+#define CNTHCTL_EL1NVPCT		(1 << 15)
+#define CNTHCTL_EL1NVVCT		(1 << 16)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.39.2


