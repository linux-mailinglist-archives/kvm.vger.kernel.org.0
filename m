Return-Path: <kvm+bounces-26515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C566B9754AA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8419A286128
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153771A3A98;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcFwrJJB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168F1A265E;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062719; cv=none; b=KktGRuvt2EhGGrtknd6X3k9Gspy8lLogQHpTuHrC1UN5NcekPNXG2m0gi+O9FUrqqac9uGXd3kto4LMYKjhK0/dkcstM3f2zNFkZcb/YvH/jRcmJJ/iJFTF+RjHkekEUY+FQeGtyZbqrfnJYwTF2ZS5emIdDaMfNjBUzfinOijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062719; c=relaxed/simple;
	bh=DoItppUl16RwlwUFW5kd+LC35Szb7CzFjd1PiApkHmo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gf8/d0JnnmWu/ZqJtHw15gniXz449IRnccQRwgG4LNSmXEcB3YK77IAu8mOerWMr+FTEboXvf5YL92A5YESViiRE9sHGOxmiJyznBe9GCWPy4ZSzJTnPg2l2c+7tC6LQ7+fSE7upHQ7zNFYcgCW6F27eTTU/OTigtW9CyYLnIlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcFwrJJB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9A2C4CECE;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062718;
	bh=DoItppUl16RwlwUFW5kd+LC35Szb7CzFjd1PiApkHmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcFwrJJBZyW9IBUIad7hcx/w0CRdP2g5+UAYI/pZoGk7fsoOfHCQJOsqdNbafwebt
	 lPqrz14oLGpMbVFQATWU5aL5o9J/4JTK+Lry870bqzUZY0vZj5jVnSyXgpH0YHfVnL
	 aQP1YJL6e1zH8ecPAf49YXGPZoMn5jMiWXqwSaLxzhNri79GnlP0/UcZRGqLW/kpPl
	 qpZXt9sZEBB9TPLWBeKqRaU7hM/NtRgd+Ge8qHI+L7nq+P9EQHfWx2Vm/wV4Zr9+IT
	 2U2wYkgRvunxX3YojCNvK4gw/vQKLv/JaKceGxERUAPI0z7RXuJvyszm4YySmddECP
	 iULjnIIS/gGaQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlE-00C7tL-K3;
	Wed, 11 Sep 2024 14:51:56 +0100
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
Subject: [PATCH v3 02/24] arm64: Remove VNCR definition for PIRE0_EL2
Date: Wed, 11 Sep 2024 14:51:29 +0100
Message-Id: <20240911135151.401193-3-maz@kernel.org>
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

As of the ARM ARM Known Issues document 102105_K.a_04_en, D22677
fixes a problem with the PIRE0_EL2 register, resulting in its
removal from the VNCR page (it had no purpose being there the
first place).

Follow the architecture update by removing this offset.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index df2c47c559728..9e593bb609750 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -50,7 +50,6 @@
 #define VNCR_VBAR_EL1           0x250
 #define VNCR_TCR2_EL1		0x270
 #define VNCR_PIRE0_EL1		0x290
-#define VNCR_PIRE0_EL2		0x298
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_ICH_LR0_EL2        0x400
 #define VNCR_ICH_LR1_EL2        0x408
-- 
2.39.2


