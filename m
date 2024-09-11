Return-Path: <kvm+bounces-26532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D36569754BC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9851628267A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A36C1AC880;
	Wed, 11 Sep 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfWY+q7h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998101AB6FC;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062722; cv=none; b=k/bsGnO8037zXx09n+Mbj5szny/MPAIM1URaV7R9oAgQLCfTRSuTcY9e5CJAEp7z9WjlZn4UTHU0DnOtN8wVMurB7+PJrMRUOY/DihnL5TW2ifd0ZyI87iDPIv6R4HDTYI1/RY503VEd8UAQmreyGPK0AKof6yJvtLmv8hhGzSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062722; c=relaxed/simple;
	bh=9wll8OqQjlqrsplg+nrb6R9KnmHRu/XX5kZAhqt22a8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qul1iMZV273kRcDEUY0mPzYO2nlGTCt2mX/PRUdyjSo0fay3DYk2muiSyrL1oKkk0sAriPIktxDc4uv/XIPegLrrQJgEK/LpsBFMBEeL5ZPjUD8bo6OtIhaue+XKlaDj+qanlXBPfyVtf804o91a6KTT+RHIZkIgJJ/m2b5k1ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfWY+q7h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1D8C4CEC5;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062722;
	bh=9wll8OqQjlqrsplg+nrb6R9KnmHRu/XX5kZAhqt22a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfWY+q7hl5ilvbMmr+TBZsNYNkvvZLVEFvCx5nfAmLkAuXwklEPwCzFl0BwoXraUx
	 5LcY/yOrywaIQHLvs5O7BKuYRcRTjPEjS2eh4OH64q2SS87YaccBrNvdmt4KLB/GjV
	 euBugXGO6nEX7v+q2hl/2VQ5G6e4Fmg+EviLPSSOxpaYMhhjlRLxA7Iy+n481n212L
	 2CJ9Ulc2e/ftB5xiVZIGY2RNA3g4mVOgfXiaUhWyQh+6LfW8hW5P6sbmi4R0cJ1e7a
	 f4/4UzVD3Ev+5oLg56UbtP1NEkh1IvDS5aA5NyDOirVpM2g2gS5hPiGSqm5vyX0U8l
	 z4TPFI7c20oww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlI-00C7tL-JO;
	Wed, 11 Sep 2024 14:52:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 21/24] KVM: arm64: Define helper for EL2 registers with custom visibility
Date: Wed, 11 Sep 2024 14:51:48 +0100
Message-Id: <20240911135151.401193-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Mark Brown <broonie@kernel.org>

In preparation for adding more visibility filtering for EL2 registers add
a helper macro like EL2_REG() which allows specification of a custom
visibility operation.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-1-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ffffcbaf80da4..41063079ed941 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2151,6 +2151,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
+	SYS_DESC(SYS_##name),			\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name,				\
+	.visibility = filter,			\
+	.val = v,				\
+}
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2818,8 +2827,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
-	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
-	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+	EL2_REG_FILTERED(ZCR_EL2, access_zcr_el2, reset_val, 0,
+			 sve_el2_visibility),
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
-- 
2.39.2


