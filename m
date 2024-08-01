Return-Path: <kvm+bounces-22918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB0B94482B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98F13284A0B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59C01A08A4;
	Thu,  1 Aug 2024 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhqVPvaf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC857170A37;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504149; cv=none; b=lFiL2HHU/uU3Co2aEHqUTdvaxebz3MkfqPHgGx0wNAnDnj6moJYARwmqN8xuZ5HLDNTTHB02BTYHVrtfdf8wBVWOprl17+TpbCb2+ZAElrNYRUM18e25UCbq2ZKhFculVksl7OJ1o9okDL8QstJ5YVcJm6UQmge20efpipUdgJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504149; c=relaxed/simple;
	bh=Xu/A5wRo87cCV/14kvsmL7JZiq2gS7qhR9OHy9H2AHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XzK+cD8ECG2MhH+jB7Y5GjDPERXMlJW+qXXPr4kkEo1cCQFM9rA7sHw3njCqVv4erxXeXHbrd51yZc5Jp3xLpcgTCttCHFlfwAd/BmJMIGqZaTjQd31WUTEw1rrpOX6O0I/J9+2yF8oFjlOSi/gQQe8BhPkK+rsFnyU5/cgj5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhqVPvaf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB01C32786;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504149;
	bh=Xu/A5wRo87cCV/14kvsmL7JZiq2gS7qhR9OHy9H2AHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhqVPvafnl8Anxk2NuReshvN5RzJri4ekYed+/VQ+QcTAnDN6y7wcrKDfHU9zf988
	 Pzf8KdipR41679BOhiEG2Ft5rdJvbg4tv5gA4QH6S+8waVI1Bsxvg+azpjEbdciGUP
	 5uRnZH2IYYA1XMRUBOi2QZqP0+dJ5QKQLVdmSnRObZwRQ0L16kx2jSzP0xKUcyhlr8
	 xXpvX1cPi/NydeKp2TYneC3PCST2ocMM3+Bu1AIJ18anPcCW4cuctkagQeA9++CYwa
	 XxXQRos9MpulOAIQCyA8PJM84+crZUwNcdFs2qc4LWTtPsPsrrW4i2p15ygzIOKqj4
	 tuV5BM8KudRZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRyb-00HKNZ-LE;
	Thu, 01 Aug 2024 10:20:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
Date: Thu,  1 Aug 2024 10:19:55 +0100
Message-Id: <20240801091955.2066364-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Everything is now in place for a guest to "enjoy" FP8 support.
Expose ID_AA64PFR2_EL1 to both userspace and guests, with the
explicit restriction of only being able to clear FPMR.

All other features (MTE* at the time of writing) are hidden
and not writable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51627add0a72..da6d017f24a1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1722,6 +1722,15 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_sanitised_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
+
+	/* We only expose FPMR */
+	return val & ID_AA64PFR2_EL1_FPMR;
+}
+
 #define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
 ({									       \
 	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
@@ -2381,7 +2390,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
+	{ SYS_DESC(SYS_ID_AA64PFR2_EL1),
+	  .access	= access_id_reg,
+	  .get_user	= get_id_reg,
+	  .set_user	= set_id_reg,
+	  .reset	= read_sanitised_id_aa64pfr2_el1,
+	  .val		= ID_AA64PFR2_EL1_FPMR, },
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.39.2


