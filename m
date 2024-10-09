Return-Path: <kvm+bounces-28314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C60E997534
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 345FC1F24F03
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E1E1E2039;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQJmCFiC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19071E1A0D;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=rr7aT2m9+IUN0mz+fLdlYGXZEp+IwMAkTDVw1M2fUIqbeuMC2l5laG34Y5nbDus9uOhPZ61PZE03IZ9Zsh72+GasdLGQZtskjgVD7szubH/Ov9Ncx3TFGiBUKd9wgcNx1wPd0piF1B2VTVJxqNAkBbgK/vBNEydrDdjQ9zgwh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=2p8gtbngTQycKdtoWZv63noAS1lUhgvWdrHkUVI0VQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FtqSSTGFYa0L/XP8WfKm0L3n07ENYBQXwoe7zYR0oP5VcchAMojwaPyQqEbyIlwTTKWIf4U5y9J44zmU1wx41+3Sf6x34O7BXgzVmHAB9yXjdTbJTtdmQ+R24XqHKi3UwSAb51Yk9B/tSwQKLdA2BGbHcqTu1Hk/K5cp5Yfoif4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQJmCFiC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE3FC4CED2;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=2p8gtbngTQycKdtoWZv63noAS1lUhgvWdrHkUVI0VQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQJmCFiCLEbWrnX9rzGiZHcKLj0g2oGFp9XUfrRMDuy4QQn2AypL+YWabOFCNPt8c
	 8+lGgHPs6pfGVyPq0vFHhe3sw7rTzrT6r/4JFhXvx9jWH4YQ/CSXUbJ3xUTHvqP1qN
	 p8rjqJiwu2tqidb6qYMibj1R2v3WZd2gbYMbfDSwq4I5HGBr1bO7MzFAUL/VxqT3I2
	 sWpD47Z/byKGArs1yi1TM5fEinT7T1k4iGqbo8fDOjdLGix4EpmQ1pokBDwDCCDDgv
	 nYAIHdyivk2X/u0q89sk328xFq55HZTMkfz9IQWKYhmpAgdHIGq7eYT2iLIBQ1wMoQ
	 /47uS3pmtQiXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvN-001wcY-6s;
	Wed, 09 Oct 2024 20:00:41 +0100
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
Subject: [PATCH v4 03/36] arm64: Add encoding for PIRE0_EL2
Date: Wed,  9 Oct 2024 19:59:46 +0100
Message-Id: <20241009190019.3222687-4-maz@kernel.org>
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

PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ee3adec6a7c82..3c812fd28eca2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2882,6 +2882,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	PIRE0_EL2	3	4	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	PIR_EL1		3	0	10	2	3
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2


