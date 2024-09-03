Return-Path: <kvm+bounces-25757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE11F96A2FB
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C45EAB26731
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8923618BC11;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgAnPN2a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E23189508;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377921; cv=none; b=I7FGWx9sgVBerhsaqRWZneNrBVDo5lZiKfHGCc4YyMbtN0+RtiMG5KTblLtD3b8p2R5OOiNE1AvSTvCr/bdPO0Ya7c1hMme2tku6PrzlVQQ8IrtGIXueg2uD7/zyplys5m5QQEAbZGjXY2/P/UDYfvZAwxVIg8d/6Fyf4WPQFbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377921; c=relaxed/simple;
	bh=flPSXZ/rkSqCan+6HF2mXNni6q/f/eIKX2LhnH8BXhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PcSehR1UN9yl6P3OLpIUXccpblTbvCdmTJ83/HrriS/kiVfskDrieYWZDXDC+LjITJ5xFWuS2ZAJI/27DOPTdInLbDdWxGtCfkNL71UXCxmEC89SlfuNrH6c44oRVkbq6PtYmBKHNY7/lPXhIvy6BZZJYMRobhems0wDUGw7UKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgAnPN2a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E41C4CECB;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377921;
	bh=flPSXZ/rkSqCan+6HF2mXNni6q/f/eIKX2LhnH8BXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgAnPN2aPoNwFJgQhDnbIagPewUwCkK/tVk+QGRUZbiU4LT7tv3NeDDxYA36CnDjn
	 dphE0i2pmPxUxf0L6dpiFWt2fjA7OqgVeG0hP5K5p/W10gkxMAev8eWQ/T8P6DgZnI
	 8lVWT1evAQB6TNQrDfqW9RoVyuxiokGDtGL6xPsGmvE37TNylo4xgI9vBLT7oD2qK0
	 dAHIcdBi+bf2E0zmGhZX/l7+og44jkwJ2NyzYUFj8UV0FtgdCgyLJAlTRLDzV0eeHp
	 ZfqDTuUCprgHM8v59+LyZb/YuUN5aSoGh/LVl5drGn/WWtRPRegUjjnYAQP8kQhSLO
	 Klmr/7OIG81DA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc7-009Hr9-Fx;
	Tue, 03 Sep 2024 16:38:39 +0100
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
Subject: [PATCH v2 05/16] arm64: Add encoding for PIRE0_EL2
Date: Tue,  3 Sep 2024 16:38:23 +0100
Message-Id: <20240903153834.1909472-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
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

PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7ceaa1e0b4bc..8e1aed548e93 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2853,6 +2853,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
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


