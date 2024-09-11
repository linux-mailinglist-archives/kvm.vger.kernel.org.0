Return-Path: <kvm+bounces-26518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D2A9754AC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 981BC1F2285B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5680E1A76AB;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J66UcdtC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087F1A3A8B;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062720; cv=none; b=VzvnqyldnyGplVZUHkx8oeBF+HfGJYdXu7VP7aS4O9E0e2jURiBooEtN9jkxd/pzPoWr4uHdrhAmtghaQluMeNQQTPM2eauJ6X1JI7r070kIqptz02P759MgBWINCT2ELrZrKdiz/a2n2KFI4Zn/B1gTPdzV6zkxOL/lBxfLlZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062720; c=relaxed/simple;
	bh=8e6gLed48oKUcHyOYabXY63JqmsGEGzCUL2kNdzV7n4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DbQobXnawvys0BzDK2ive/zDFGF7INg3xtwHEluusRCx+NY3Dw29NKvRYhuKp16Kso80XaLigDl87/+NnWxLPzX5Ltc33NfbvGjprRfrTiZSRXGBz4uaARDcvT7GnW7jyX9f6ohnjwfmJhQetPj5gymIK00dkY+EFwrVvHlEucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J66UcdtC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACA0C4CED2;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062719;
	bh=8e6gLed48oKUcHyOYabXY63JqmsGEGzCUL2kNdzV7n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J66UcdtChJD9kDw2JF/6JZdO35SgLVQvuh4LvWKAcvRwac/0DqFiZglaRish+F+bX
	 0xukxHfgrUIXN4HkyTSTJ1dsBKgGA8Tr+haM8sZnNiUPnN05nXjlo22NZdahV76Xen
	 KPC/2JdovWVaG/GlnTPIy9a05/EzXlGi7qySsZaPVXGQEPZ/ib5s4cjbYOPRVAv6S9
	 3idHsuIKkNoeD+u9RZvlWizNItCd9wfKQtKvX7xcdvoAwe8u3b2gYNhHMYKvGefj6Z
	 Wwj0gOmACJP1swL68OV92CnktngzrWzDC8e6bj+3dTvo3WRalzBrtIVvOyVSXask/Z
	 qiEB7rf9oXoIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlG-00C7tL-3K;
	Wed, 11 Sep 2024 14:51:58 +0100
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
Subject: [PATCH v3 09/24] arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
Date: Wed, 11 Sep 2024 14:51:36 +0100
Message-Id: <20240911135151.401193-10-maz@kernel.org>
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

This definition is missing, and we are going to need it to sanitise
TCR2_ELx.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index d80859565547e..c1c0a45b896fb 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1688,6 +1688,7 @@ UnsignedEnum	3:0	HAFDBS
 	0b0000	NI
 	0b0001	AF
 	0b0010	DBM
+	0b0011	HAFT
 EndEnum
 EndSysreg
 
-- 
2.39.2


