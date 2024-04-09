Return-Path: <kvm+bounces-14018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC2289E1EE
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 816291C21738
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B163C157466;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlbmXWc5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97338156C61;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685323; cv=none; b=JUhiAHgrtg0QEhot1S5kWiLkzVLJ1uSeCmJQrWTBSW14LJ0s6+AIN12S33cnjWZaiqzgJBBpPcqSiKP/Veczq25KYAfQ2T6O/qA4zwF6XPMi/uI8tnBtHqWOg5gtefyHWSuYPh/sf28fSrMreLVUMQPg8B3ZvJm0JPXNXAvWagE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685323; c=relaxed/simple;
	bh=CPCdUGUUqnw4qGyDRUvLFmV/6Mz5cBLoWsS3L5UzAiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DKqxiKdU9NE9F06Ki0aVyV9gcuFei1DnDLfNhhU3z3BfgVToZR2nlkf3WBpLUFK+03VK8zUNsWA5kj2p1/7MbLCvACl5+VBRfQQpz3NMAlbDiTFGrHvZBPOeRqhFh9UcT/ADftkdLHGoTgwqgi/JnbuFf52z+xNq/hvKDovuQxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlbmXWc5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5440CC43601;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685323;
	bh=CPCdUGUUqnw4qGyDRUvLFmV/6Mz5cBLoWsS3L5UzAiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlbmXWc5onu3N+kJINvN1oxPuJODevdeNhjbU8PyMWw2DX2iw+JtUvw6msDhEYdPO
	 2fQsX2q82mKTHnuQXuCi+3NrxGM3/wegB5lmmO8jKPBymMq9OLzqRccbphouA15/NT
	 yOiZDwdP8AprpNoWe/Jcd/wMpvJ/AtsaTb9lwiowVyKgLYZ9LxlQtm8WHS5mUK69zy
	 B0njEh6bXvp/pisBEoVMLmCohFZb73rTX9e6kJW3kePtwdAbix0pMzrD3LqcwwPzMk
	 pTEvZXwgKn67ibmsmvEdAs/M4J7/o8+MTyoex6NtqB3fnQ2VOSYDOMQfvEXIsCfnuR
	 MWDvPQkOYTpmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgn-002szC-Jn;
	Tue, 09 Apr 2024 18:55:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 09/16] KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
Date: Tue,  9 Apr 2024 18:54:41 +0100
Message-Id: <20240409175448.3507472-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TLBI ALLE1* is a pretty big hammer that invalides all S1/S2 TLBs.

This translates into the unmapping of all our shadow S2 PTs, itself
resulting in the corresponding TLB invalidations.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4be090ceb2ba..24e7d9c494c4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2744,6 +2744,29 @@ static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
 	return true;
 }
 
+static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * Drop all shadow S2s, resulting in S1/S2 TLBIs for each of the
+	 * corresponding VMIDs.
+	 */
+	kvm_nested_s2_unmap(vcpu->kvm);
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
 /* Only defined here as this is an internal "abstraction" */
 union tlbi_info {
 	struct {
@@ -2867,7 +2890,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
 
-- 
2.39.2


