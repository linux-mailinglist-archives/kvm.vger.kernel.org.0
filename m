Return-Path: <kvm+bounces-33947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047009F4D8D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4272C16899E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E54F1F63E1;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLBvQcXg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8181F4E43;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445407; cv=none; b=OJvOyradLC7MXL90yfrW0Eur4AmsddBLiLo2KCQvD/GGDAasGdbKR2vgxtkOc7IjRI8RN+pX+Pt27F/kjwNE9le2NM5IkTnlPH+XUhUw2KYqyXtte+uC8gIobHAQ8Br4xQUEKxnQ6xOuLzVNDTzY6qszXTHWt2e8gzDUlzWyZnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445407; c=relaxed/simple;
	bh=Rochb5i1Ho0E+qV9J9IDq57ZQiT0touGYCNFRT4vxqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MipwUZjqI5TYHMoSXJ7emjJEWDrrRnUX71Du/XgqN5vzcoWmoXh4mN2CGg/MpIdsdy4+gEcUaSeeAghdT7s04K8LYnfUzBjdHT2Rh4XAx+dvib9EGoG6kLA4D9mw35BIJDjhIZ/dehtCCqBYH9uQAeazwisxA8UD5B29niku424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLBvQcXg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D08C4CED3;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445407;
	bh=Rochb5i1Ho0E+qV9J9IDq57ZQiT0touGYCNFRT4vxqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLBvQcXghpWgE53TCFFOadQ4c1ZtbDM4Q2zGxBj4aIOnK2qC9fzgydztkgDnqhqIQ
	 0LheE6Hx1Lzyr6htrOiy/Dfv33YxbArTJSQErd5eaoFYdaqUkJ1tdnNAhuivBNRWTE
	 T/C8dcavqWTMDOjZEdfYF2+IxFHZ/Iwc8X+jLnaaZT5rjoq7Gzk9OQzSTbIkseA5U4
	 M1H1Gj7tiu6JOL8e9K1KF0VxhfnzXTFchS4n+hjvCsNESWwg0umEMa+QE+w5QCVdIg
	 s365Wq/vi/aLgzEOQrBNO/tNMOAgm4Yxg1uWVPfYKkQ0Au9/+n2MARIkKQqlqYMXLJ
	 05qTftxMVcl1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTt-004aJx-6e;
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
Subject: [PATCH v2 04/12] KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
Date: Tue, 17 Dec 2024 14:23:12 +0000
Message-Id: <20241217142321.763801-5-maz@kernel.org>
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
index 8bff913ed1264..b6a06bda9e534 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -783,7 +783,7 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 
 static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	bool tpt, tpc;
+	bool tvt, tpt, tvc, tpc, tvt02, tpt02;
 	u64 clr, set;
 
 	/*
@@ -798,7 +798,29 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	 * within this function, reality kicks in and we start adding
 	 * traps based on emulation requirements.
 	 */
-	tpt = tpc = false;
+	tvt = tpt = tvc = tpc = false;
+	tvt02 = tpt02 = false;
+
+	/*
+	 * NV2 badly breaks the timer semantics by redirecting accesses to
+	 * the EL1 timer state to memory, so let's call ECV to the rescue if
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
@@ -838,6 +860,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
 	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
+	assign_clear_set_bit(tvt, CNTHCTL_EL1TVT, clr, set);
+	assign_clear_set_bit(tvc, CNTHCTL_EL1TVCT, clr, set);
+	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
+	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
 
 	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
 	sysreg_clear_set(cnthctl_el2, clr, set);
@@ -933,8 +959,12 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
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


