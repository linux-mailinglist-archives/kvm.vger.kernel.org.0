Return-Path: <kvm+bounces-22806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C52AE94368E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8606C28197F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311B115FCE7;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUTO6iUP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F461381D5;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454855; cv=none; b=pSxeFh5p/KDPvMJQfsKNnqd3sxZty+QiMOpdgSuERMf70adEJCQBlg8Q4iw2+5mdx635I6ClMLPEjQaIr1fTYoCItCdCeyuTJ1HYkW0Y9JeQLKEYTwL64oDW4UgBM4jO6gAzxBH5MwHGj/sKuz8iO5c8rONtABtdbw0e2dNgqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454855; c=relaxed/simple;
	bh=6AJ3yfD98r+FO9E5vQFX7wbiwlpQp9Jx1Chm1J9PyGU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EZLVz0ukJLJisHnEuP8C0jp8e782ykp4INkEH2g7NvZSanpOGZJK4rHqPbr0b5yFPbHX131R/A6AFESbGPtOfDRw7yxSbEsOwTnFgfvaYXUrbnL6rFJ1WmW/pWYGao/IhLdh1h6eMehcHFhv2OmPI0sRkxM69rz0jOi8LYCA5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUTO6iUP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003BFC4AF09;
	Wed, 31 Jul 2024 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454855;
	bh=6AJ3yfD98r+FO9E5vQFX7wbiwlpQp9Jx1Chm1J9PyGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUTO6iUPBDyO4GGvEN60Y9hyNAAqAurAwpsNeyn6ulHSNtmxOJxrT8dio0eAGV4y9
	 PrUA4CyqCI0TntaLu5GfdIsyEiNfDHXYMe4JTAiSIrLThwPY4X52oWHAODaNI3GXP3
	 GkaKTIs1/N7tYaZVKPfufKimpUlgmQLMg/2bECzq1KlLYrasrz6ZQNWnv6vCjdHJYY
	 woonkLFxc3ATDhjTpbdFoBHd/tW/upfvyiV7rwrhRA9QpL9pycoT3HewWkfcBGFBXC
	 d17ubEsChWkjr1AoZAq5YjKmFzwCYX0mujg19Ho+ZQE35cZcii7lVtawiQQN/rJgGc
	 yhn+R9/4bQtuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBt-00H6Gh-4M;
	Wed, 31 Jul 2024 20:40:53 +0100
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 01/17] arm64: Add missing APTable and TCR_ELx.HPD masks
Date: Wed, 31 Jul 2024 20:40:14 +0100
Message-Id: <20240731194030.1991237-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although Linux doesn't make use of hierarchical permissions (TFFT!),
KVM needs to know where the various bits related to this feature
live in the TCR_ELx registers as well as in the page tables.

Add the missing bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h       | 1 +
 arch/arm64/include/asm/pgtable-hwdef.h | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d81cc746e0eb..109a85ee6910 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,6 +107,7 @@
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
+#define TCR_EL2_HPD		(1 << 24)
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 1f60aa1bc750..07dfbdb14bab 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -204,6 +204,11 @@
  */
 #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
 
+/*
+ * Hierarchical permission for Stage-1 tables
+ */
+#define S1_TABLE_AP		(_AT(pmdval_t, 3) << 61)
+
 /*
  * Highest possible physical address supported.
  */
@@ -298,6 +303,10 @@
 #define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_HD			(UL(1) << 40)
+#define TCR_HPD0_SHIFT		41
+#define TCR_HPD0		(UL(1) << TCR_HPD0_SHIFT)
+#define TCR_HPD1_SHIFT		42
+#define TCR_HPD1		(UL(1) << TCR_HPD1_SHIFT)
 #define TCR_TBID0		(UL(1) << 51)
 #define TCR_TBID1		(UL(1) << 52)
 #define TCR_NFD0		(UL(1) << 53)
-- 
2.39.2


