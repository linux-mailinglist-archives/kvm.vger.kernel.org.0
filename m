Return-Path: <kvm+bounces-28313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E11F997533
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86B24B22124
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B911E1C24;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkrSQvDA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9391E1328;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=A9Je3+t4PxMJRbUATJZpyJpNqgsR6E1/s0+RUVBFdhDe1EeH4RLCcN8oEz5ZBCTFMv8BJooKa+qyvD/k4jyb6ZaXHpzSEV7GsmjZ7yiFm1ClQNRg15s9s//k0W6WE+KAuavbKe1Dbn/18Q6NH3c1B4ih31x36/QOvDdkc5itcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=iNfYJ4JXlpAYVqAHGPpB7Ak03akbgaV2OHGu0ciE5wM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qeR93pnTBtvNF674d6JqN8QM02BwJmoVuch/OzFJZitLVZLFqw7e42QhZ0KyG06tLY2Z40WAPZ4+Ri2FAHITcSYB1l6/KWobjzNDKguuVHd7YA+J0ITg0muCGurupncwYxvCMXPqthvbB/MWVnZsZ4n7K4sQVVI1IE4eDaLqb3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkrSQvDA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47A6C4CECC;
	Wed,  9 Oct 2024 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500442;
	bh=iNfYJ4JXlpAYVqAHGPpB7Ak03akbgaV2OHGu0ciE5wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkrSQvDABTfqKy/8W7Lg0lZdxXeutxQcy/EeLEJ5JmenRLHHpJzwK8rm0QTkWxSMU
	 LUJvNYkGLeOqNexzl0ruz+c8aSz/+jFQrh7K4ny46ywVkpBsX7uCP0+As8/q20HoCx
	 s7ZEc+Cjj65FcZ/5dF+tPnzi2dc4sna7Sw9pbuI61KY06KUoLpaey4HZ1ZNSNZ9Pnt
	 K+UyT8p9jlIHbrJDP3oKvOQsHKjUNRHryxuahgF9auniEoVkjmCZScv1eB2phzb5dd
	 ER8KOSlAjofIAETXr3ldJNoDEhejgM4/fwuxM/3coLet5n2DBDzP7TQtjbNvNtKKUi
	 /+Krbgs4ewJSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvM-001wcY-QI;
	Wed, 09 Oct 2024 20:00:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 01/36] arm64: Drop SKL0/SKL1 from TCR2_EL2
Date: Wed,  9 Oct 2024 19:59:44 +0100
Message-Id: <20241009190019.3222687-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite what the documentation says, TCR2_EL2.{SKL0,SKL1} do not exist,
and the corresponding information is in the respective TTBRx_EL2. This
is a leftover from a development version of the architecture.

This change makes TCR2_EL2 similar to TCR2_EL1 in that respect.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8d637ac4b7c6b..ee3adec6a7c82 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2819,8 +2819,7 @@ Field	13	AMEC1
 Field	12	AMEC0
 Field	11	HAFT
 Field	10	PTTWI
-Field	9:8	SKL1
-Field	7:6	SKL0
+Res0	9:6
 Field	5	D128
 Field	4	AIE
 Field	3	POE
-- 
2.39.2


