Return-Path: <kvm+bounces-25758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 788DB96A2F8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 300531F29E6D
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DD218BC0E;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzPudsav"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50822301;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377921; cv=none; b=BU5i5Qv1C69R8t/bIks1+fuL4Y+EEk/YBnoCsutICYdncJfLBgOtx99okWsULHqan4gfNQPorKnCePST4PQW0B411FT7ZGH2J28khjLNWf69yWxCaoFDDHZb79v9lVlZPfiLLyvgh558OBIoeO36PByKL9vXQJu7bAotamKeUJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377921; c=relaxed/simple;
	bh=g+kqzslT3yLhM8F9bZvGdGv/NXD+1ywfyxIl7FgOAnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fus840/xwainTFyO/DKfuI3tTsL34anYIQ9D2EDHBOy5SmSYeZ4z+6FOEGZ2neg8gK4C2vJs266whuWNkiKJRiGz7wsnIfow75n2hju9Xb5K/0n9qeCdPQ4+11sv3i5xSVVS3G204Kilk87Ik+veU7/ae2YV8WIrtJk2MzJ0LSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzPudsav; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71872C4CEC8;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377921;
	bh=g+kqzslT3yLhM8F9bZvGdGv/NXD+1ywfyxIl7FgOAnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzPudsavkYkqGG6qSLuYcTpJ4iLRvdXAqiIUORQkLLdSVPUjqFyOyBLo+LIYSwxeU
	 59Q4E1uuFl1hXuq7boa3PryjVQbKMQfGu3tsIqW0g6z8KfkAfyVTpVgZ4EPiASioEp
	 mvKGyHduWnsKP7Zw3enrt/bzfl3rqyqXUuTy0OerIo5nvL+g9kWI4W5QaNEbt98uQS
	 AbqAMU4lpZIIYJ6fAStIAbs00OBn8S4ch4yL91L81B2LEA+z+qaH+H55x4ZqtbiH2I
	 ftgaFKthjfU0lQbjMFQFSd6arXy86WY93EIBmTrXcj7d2BLAfSirG431FAPUZ0jd3v
	 wc6UjOUQ42LhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc7-009Hr9-NF;
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
Subject: [PATCH v2 06/16] arm64: Remove VNCR definition for PIRE0_EL2
Date: Tue,  3 Sep 2024 16:38:24 +0100
Message-Id: <20240903153834.1909472-7-maz@kernel.org>
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


