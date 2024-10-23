Return-Path: <kvm+bounces-29522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 179449ACDDB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A650FB2470C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134FA1CF7D4;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOa9l1fL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6E91ADFE4;
	Wed, 23 Oct 2024 14:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695232; cv=none; b=dCVs4IYPtPPvN+8T5tLnuZoq3HTguGmiFFq4ZMRXASXC8LsBR9U8w8dxc+Ojq6MO3TKODxBDjE0p4zKsH/FJs1fXx+H7ZwW7kGbO5889DHyr72dkcoPYiEqFjFZ2v/cc85ldDFo2r1b9YmKlZ7fYvkVyvZ+6EDkmUIWoMZQng/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695232; c=relaxed/simple;
	bh=iNfYJ4JXlpAYVqAHGPpB7Ak03akbgaV2OHGu0ciE5wM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FiqTySwD0Ktd+oLBUorvA3JUa4qZZkmecHpBYpmrmzGP55imjNQq9wc7Lr0zPFvQb27LneNT4ZxVGf4xV0Bpqgo5iulyHP09X4uY3k1CrVHCQwlDKRXqReO3W8DGt3AZxLj54XqKCixv2rVCTmFHOZ0u5/qbFPB8dfgVjFOus8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOa9l1fL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27FAC4CEE6;
	Wed, 23 Oct 2024 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695231;
	bh=iNfYJ4JXlpAYVqAHGPpB7Ak03akbgaV2OHGu0ciE5wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOa9l1fLqxHoh/XYX8XHW0anBL3x6wpjc4bpwozLdbM2uPVZtcuFmFLvh4I2duAIF
	 kv2RAx1vnmSjRv14ItIOx/RYeYxHLfDV0Y+R6niwTzgbSyv7UOvMmqzI7xxIGnJ78B
	 jQCXnee4CQTSuXEXhYmpLkLhrDGJ7ngqQ/88eaGK0KsvAKgif1CevJ+PjhafKHYNuL
	 avRFIQAMVE+gsyfqxuvvcm+SgCTXnyrzPyRiJzhZ/G+5GZyVJab0zYeLC6GDyuG8Zo
	 tBHZC5LJdqsMefKpJ+6fJNydVOIx2/sP6I8FyOqRAiR86Dx+1rOHATT7oPRhak+/JE
	 ZFBIJPJOQTeKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ck9-0068vz-N6;
	Wed, 23 Oct 2024 15:53:49 +0100
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
Subject: [PATCH v5 01/37] arm64: Drop SKL0/SKL1 from TCR2_EL2
Date: Wed, 23 Oct 2024 15:53:09 +0100
Message-Id: <20241023145345.1613824-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
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


