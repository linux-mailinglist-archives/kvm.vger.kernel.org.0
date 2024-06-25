Return-Path: <kvm+bounces-20478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8987C91690A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 461FF28A873
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFA115F31D;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MApEtANP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40316193C;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322524; cv=none; b=QshdJvTS26naAOxZ3y4bkKIVs58f7Kz9HYmraZxEQkvMSYfpXHKojTcXF2wQ8lTt01Quv4jG2ByazCCyfb/ZBUTiE7svJONBMHFRvkW9lO8S1TMEBApAgbnWIbqm/RMty2I6SL3jn1ePMClZijldIvQw1z2wrRHGx/1VKUhhQGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322524; c=relaxed/simple;
	bh=Z5W8y2Ri1k0XaNhTI73pukGuPrGrEy3whjorOmdnemc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AwJc2gF6VSRYKEGc7462lpLux2sz9Kk2zsFwF7pkjNfvMCkhu/XRjCu1nmAJL0mgoPSRYBj7X60httbMVza3vS13WF+OzJWXTyhhrQh3UuPR58IbLOtnguHEZ0Usw9eHkRaNC7zrsFvFdjcJD/wSpr6uhzbcfXqpZGQKBFAwKNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MApEtANP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79F8C32786;
	Tue, 25 Jun 2024 13:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322523;
	bh=Z5W8y2Ri1k0XaNhTI73pukGuPrGrEy3whjorOmdnemc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MApEtANP/FQVQfIUI2nuQag+jwmsncFPyFRDcdPyGXjAMcgMpTt8QIzkMcXEr2mDO
	 1/kCTvx0/RNm5bja4P1fvJTEE8C9P7S2nKp/F9c92hWdKKf/9AahPWRwrOmyhjuaqn
	 vfWYUfvIEctLk1YGV4EAkwyleIEFNKcx4/5lM4PNfWICx73AhHoOxrGIdAMGIcwaH7
	 JesC22GdBAglMZt8sTuRq6zr1vg5iQ9cnYUve3ouWOs4Y+1m5XgltfUngqkxhzQlU3
	 M4MH2xGh+Tcizng5SO7Me1IqWYdL2hDuVuIAPPFMWeXXMEfr8WfGdtespgQdJsCl0m
	 KfwazE7tvZTFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-1I;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 01/12] arm64: Add missing APTable and TCR_ELx.HPD masks
Date: Tue, 25 Jun 2024 14:35:00 +0100
Message-Id: <20240625133508.259829-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although Linux doesn't make use of hierarchical permissions (TFFT!),
KVM needs to know where the various bits related to this feature
live in the TCR_ELx registers as well as in the page tables.

Add the missing bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h       | 1 +
 arch/arm64/include/asm/pgtable-hwdef.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b2adc2c6c82a5..c93ee1036cb09 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -108,6 +108,7 @@
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
+#define TCR_EL2_HPD		(1 << 24)
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 9943ff0af4c96..f75c9a7e6bd68 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -146,6 +146,7 @@
 #define PMD_SECT_UXN		(_AT(pmdval_t, 1) << 54)
 #define PMD_TABLE_PXN		(_AT(pmdval_t, 1) << 59)
 #define PMD_TABLE_UXN		(_AT(pmdval_t, 1) << 60)
+#define PMD_TABLE_AP		(_AT(pmdval_t, 3) << 61)
 
 /*
  * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
@@ -307,6 +308,12 @@
 #define TCR_TCMA1		(UL(1) << 58)
 #define TCR_DS			(UL(1) << 59)
 
+#define TCR_HPD0_SHIFT		41
+#define TCR_HPD0		BIT(TCR_HPD0_SHIFT)
+
+#define TCR_HPD1_SHIFT		42
+#define TCR_HPD1		BIT(TCR_HPD1_SHIFT)
+
 /*
  * TTBR.
  */
-- 
2.39.2


