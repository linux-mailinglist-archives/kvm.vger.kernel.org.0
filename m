Return-Path: <kvm+bounces-52965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB72FB0C129
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F86317F3B7
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3F628F524;
	Mon, 21 Jul 2025 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/0xZwp2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949DA28DF4A;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093208; cv=none; b=GWBbW3TnaM6+Ah6K/0P+mAYOq8+5ZkxiwA5ilC7nF7iIhZSvsxWRzmasHXpKMJoXKLmaFptrLKw61inrtShXwDAeLhyNpTZbGH3KSe933oc/d2Gh6nt45UHFJ1KUTL8EGE/iLAsLvI3RjzuH4bgf1PghXicz0+9fvcpC8CWKQ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093208; c=relaxed/simple;
	bh=gFDYm7TB6lkDfF9GDf5OjAQa1yBvnoVEllSD1/QRnvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E+2AvcjMc+xhFW0zlml1g7ofsXr5Dtub4dR1jio1yx2ONNWhlceEV11eeNO1ar67VqwQvHQbkZXLJU0icAdN5UcU2jP44nxhSd8TGPLJKT2KrTF9WKZopcFloHOpFUWmVrJc4XEsbQdZrr0D1UoFU1tDmOMGBp3g2bqm7z5S0X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/0xZwp2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E80C4CEF7;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093208;
	bh=gFDYm7TB6lkDfF9GDf5OjAQa1yBvnoVEllSD1/QRnvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/0xZwp2xenh9Aknrbc2sbnMrygH2j/vnPz51+Y4oDqAedhGTF7oaDMazOgGcIzPI
	 d2Faw4FCC4aJiojN74c+LuszB8BQm1IETSHTz4iewz+AXvF6Im1GN5Yl4rAgLUSv7w
	 hrKKhxnEia5AbvIe7+AW3t78/ry6b8Ku+MyRqEuGKiiI2Joxk4QCVjajlniOqTw/66
	 Xdo5S+2bF568YO5tLsO2VE/Xo4EW+2zJIYFRRYqGNS2uVGuxix3F79bMdP4uJhZWVL
	 lbWWxerVnuED/FEEtt/qVYipPSpVXlcOWqmy+Tl31aYAjx+9hsJxIfWti8m+YpJYpo
	 0im1/gd9hjkQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncs-00HZDF-Jp;
	Mon, 21 Jul 2025 11:20:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6/7] KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
Date: Mon, 21 Jul 2025 11:19:54 +0100
Message-Id: <20250721101955.535159-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If we have RASv1p1 on the host, advertise it to the guest in the
"canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
the convoluted RAS+RAS_frac method.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9fb2812106cb0..549766d7abca8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1800,6 +1800,15 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	if (!vcpu_has_sve(vcpu))
 		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
 
+	/*
+	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
+	 * is cleared separately.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN)) {
+		val &= ~ID_AA64PFR0_EL1_RAS;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, V1P1);
+	}
+
 	/*
 	 * The default is to expose CSV2 == 1 if the HW isn't affected.
 	 * Although this is a per-CPU feature, we make it global because
-- 
2.39.2


