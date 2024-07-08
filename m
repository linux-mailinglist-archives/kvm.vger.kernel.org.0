Return-Path: <kvm+bounces-21105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1AA792A5FD
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49BA9B21C10
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D057146A76;
	Mon,  8 Jul 2024 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRyoxTCQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB26A14532B;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=Eg69t7uzSnI5XJ0pT2kAhubdaTx1+32SOLWzX4Fwx8s0cAEoQiFkBq/Mosfi4iaMr91PDUqjxHv5r95WY8xqXhUFUcm+BMCOUSb+DPEGjoU6AhXoRoWA7k0x4LJsIGUwVfF44dm9rD71BlROHXGx6eAXLTZHLkBu2doQQfg9sHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=Uv0z9ntISDWqUONsGZqFUTjAheaQ1E1mlpLqi6+ng6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BynuGTs8iSUiU+RVD8htGxnuC2HzJT2Y+u+/921qAJ0E0b3lVUAbDGfHx3tsBmoflWGXHI+mkEtSW3uVZTKgSQSs8pKututBY5XueK8h5JYSQvpF71sO6NEGjuLadG8Qn6KRO/BGTvQWKbyKpQpXzCzrOAvf9BCey9LfPC65QDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRyoxTCQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B358FC4AF11;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453495;
	bh=Uv0z9ntISDWqUONsGZqFUTjAheaQ1E1mlpLqi6+ng6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRyoxTCQSNWbyMYEHSAdVp0bBfgm63kTrCTK4sKrZ7D1jt0sYg0AieQ968QNw9AyI
	 J+/A4sLDMwriiaD/2MtU2sRGwj3uwSoGx25+4XdiihXQ8evspg2dOCf6ymS6PFi6bu
	 k4/4p6OgE1KwtIVLCZpBg6WEXnoZ7bzi43aGf0aV1LTRtyIRdpWKVr5ZJqnXCGBiSm
	 gyNtclQmEtfCPchp6aAw5Ydlpt1KOIGfPl5m4kgyEM2eCfvtbTNf/E2uz3gL7U6Xmr
	 0kKBejlDN8pZpvqW1Jbtu3WdI0r+HpZJcTOuNjYYn8zsf85U30ohPXjLAzfBLuZbSm
	 nvPaGr0BT/CSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXt-00Ae1P-Ua;
	Mon, 08 Jul 2024 16:44:54 +0100
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
Subject: [PATCH 7/7] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
Date: Mon,  8 Jul 2024 16:44:38 +0100
Message-Id: <20240708154438.1218186-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
References: <20240708154438.1218186-1-maz@kernel.org>
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
index 8b5caad651512..e6f9e380283ea 100644
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


