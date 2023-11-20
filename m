Return-Path: <kvm+bounces-2112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E03727F141E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91A1B1F23088
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC1E3032B;
	Mon, 20 Nov 2023 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0ZtClgV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19978225CF;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF86C433C8;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485861;
	bh=bRludizE5NQCECJo9FD7J0cAYV08s1Q2t2n9frysPJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0ZtClgVqdZ4FJiVgSYtgkDaCrOaMX//eQ0SDQNkvvjTyRSURFaCOlIliv8vtcJ5w
	 jvC76q/DAbv0IYtAtMTbuTj3tI7u/bxXisOQUHthZaxV1x5GSifVH+tPbvGYt2oywe
	 gJcp230VJNagtx/XV9XQzAAOxHU5GbS5cSqbqfq+znKxIKT20mFDekgPAQDKpCjuiV
	 lfrdWilY5P+CVPjNEn+pg3PZVIZ+wl36hM9fm1cYJ8kSN6jDbvJTzLFNQCPodoOWys
	 wLzhc5lR0yL3VA6bC7DMYT3hk7+ngoQqa2g1sU57wR9TsrGdT6IQOHrfAnCmqeKCEu
	 SCgtHPgaQ/z0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543H-00EjnU-R0;
	Mon, 20 Nov 2023 13:10:59 +0000
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
Subject: [PATCH v11 41/43] KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
Date: Mon, 20 Nov 2023 13:10:25 +0000
Message-Id: <20231120131027.854038-42-maz@kernel.org>
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
 include/clocksource/arm_arch_timer.h |  4 ++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index dba92bbe4617..860f6e190e63 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -782,7 +782,7 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 
 static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	bool tpt, tpc;
+	bool tvt, tpt, tvc, tpc, tvt02, tpt02;
 	u64 clr, set;
 
 	/*
@@ -797,7 +797,29 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
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
@@ -837,6 +859,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
 	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
+	assign_clear_set_bit(tvt, CNTHCTL_EL1TVT, clr, set);
+	assign_clear_set_bit(tvc, CNTHCTL_EL1TVCT, clr, set);
+	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
+	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
 
 	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
 	sysreg_clear_set(cnthctl_el2, clr, set);
@@ -932,8 +958,12 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
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
index cbbc9a6dc571..c62811fb4130 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -22,6 +22,10 @@
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
 #define CNTHCTL_ECV			(1 << 12)
+#define CNTHCTL_EL1TVT			(1 << 13)
+#define CNTHCTL_EL1TVCT			(1 << 14)
+#define CNTHCTL_EL1NVPCT		(1 << 15)
+#define CNTHCTL_EL1NVVCT		(1 << 16)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.39.2


