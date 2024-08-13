Return-Path: <kvm+bounces-24007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E0595081F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC2D21F23298
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DC51A0707;
	Tue, 13 Aug 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf5Q24ZK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705D11A00D0;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=UGNq33MjOMEMp9dZKPfJdjoV86MZ/T21cE4Hl1cZhmO8uXtIqPYjaYJ8GcyT4bzPzwadekUMYgAqLsdo65LsoqPP6UY32XraunO97HM+aXUMQb2l8En8FyhKVX8wWy66tyzeUxlDOycSFOeQCDLYLCEvQZR6wGX1T8uKdTmau1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=ffoZGFIxqM7xv66FGMTRLGczJEXgIqnAiwt3W1CgEKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pseuJgpr7ayB1ckvilGbBmlJa8MpfXNFaHuwjWqkyheXCvxJmoXtEa2sb0H2Eo1NqIV9n7PlWzVCGnXm5qytYOMpR5tetcOUaNcoXaP5LFxrp9evVOms/8tUtrTPpLqftBXoHqinvu/HChhNlP0M5+DhyxXYKC1IiD8F80oFZpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf5Q24ZK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13077C4AF0B;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560479;
	bh=ffoZGFIxqM7xv66FGMTRLGczJEXgIqnAiwt3W1CgEKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf5Q24ZK02j7lMO+tm5EQ320nqC4YCnMQreegy+3BhzJBpruYdeGwVnEg36lccXaq
	 FokVoW2eO6crbLwId9e+grv5dxHFJoWvRuyA9YvtIt9v3SQJY+lXM1kDphLOYKLMFx
	 z8aOj8kXSD3r5mr9DPQ3z9QYBOW0YntMKTUC2lVwYU/rihAjDJKiOeDDnR3XKk35/C
	 bCI2dA4jJ0xAxTiTsPhKNfR5nDHjeIxC4OfIDnXV+nyOeYUxteQKme3w23Cqcjpbz6
	 Zj6ojUdyaFTxU/eXNi/LFsETSygosjbr8kQQkNkf5EY8vN99CYhli90SMDTljM/oIn
	 4eER39So1t51A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoX-003O27-Aj;
	Tue, 13 Aug 2024 15:47:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 06/10] arm64: Remove VNCR definition for PIRE0_EL2
Date: Tue, 13 Aug 2024 15:47:34 +0100
Message-Id: <20240813144738.2048302-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As of the ARM ARM Known Issues document 102105_K.a_04_en, D22677
fixes a problem with the PIRE0_EL2 register, resulting in its
removal from the VNCR page (it had no purpose being there the
first place).

Follow the architecture update by removing this offset.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index df2c47c55972..9e593bb60975 100644
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


