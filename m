Return-Path: <kvm+bounces-45649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F50AACB68
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A4B73BD17F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E454D288CA5;
	Tue,  6 May 2025 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHC+ubz6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ED9288C22;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549857; cv=none; b=rSpdZHTIiJ0G2lWGVkV5907d9vmE15hDd5qf0My4iOWjYF5chrHNY/JHnu7ZJiqExzypQe/coDMRD8/UASq4txbsezMFcEBhYObQtjHdu9torVggZOxYnl3GPFs09ihIrSPhUbeoo+lIdrWvL3MMCL9StWTsY2b/2bB2+yrAUXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549857; c=relaxed/simple;
	bh=5X3YyZc0yV/prtY2KpDQtJAXr40u4CELtIg3JxZkaAo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T2ZSWOs1PSYEPW7Azf2KO4SOOs/V9zxDClb8AJv287t8Nolt7tfWZ5qUM8MY6T6WhVKpc2JS6UzxbquwHsbhwHa6gqJfqNNfu2ZcpZcE6aMWqH/QgkisuJbhEszXp2bEp65V6E4MaapiRvP5O7QA8qz9AXKtZtCq4Fb8tTHwYW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHC+ubz6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85292C4CEF1;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549856;
	bh=5X3YyZc0yV/prtY2KpDQtJAXr40u4CELtIg3JxZkaAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHC+ubz6buW6plF+5AZ/I9W0CfHqbODtGZd+NU6vm3y8sEF2xl/UY1ioThVjxnr04
	 LUN/EP8QFRNfp3ClZuB7pLQH/DC+Q108Ctgb2CfYtaNGur3ccLJQ2aPZra4D/kIbp1
	 IqSrQr/qu2Q8NpX7F0KH5MKGb38qPu0sQczLbCIyC3FNIxiujGqRLM1Fu/ifdYwoum
	 tdznhgf5/jd6kqPtdsGy1mmeQEqxg7xKzWJbOz2ZiA904o0EAMn4CZA+iUOq080nNr
	 uR85IjHOqKkY9Y26mQfIn+l0RWYpSD5bSf+YHbiIVTzBQKkeIUcfrJahR0M0qPQTgi
	 JnASa5XNL0Ugg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOw-00CJkN-PB;
	Tue, 06 May 2025 17:44:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 37/43] KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
Date: Tue,  6 May 2025 17:43:42 +0100
Message-Id: <20250506164348.346001-38-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The FEAT_FGT2 registers are part of the VNCR page. Describe the
corresponding offsets and add them to the vcpu sysreg enumeration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     | 5 +++++
 arch/arm64/include/asm/vncr_mapping.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b5fc64c4085c..abe45f97266c5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -562,6 +562,11 @@ enum vcpu_sysreg {
 	VNCR(HDFGRTR_EL2),
 	VNCR(HDFGWTR_EL2),
 	VNCR(HAFGRTR_EL2),
+	VNCR(HFGRTR2_EL2),
+	VNCR(HFGWTR2_EL2),
+	VNCR(HFGITR2_EL2),
+	VNCR(HDFGRTR2_EL2),
+	VNCR(HDFGWTR2_EL2),
 
 	VNCR(CNTVOFF_EL2),
 	VNCR(CNTV_CVAL_EL0),
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 4f9bbd4d6c267..6f556e9936443 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -35,6 +35,8 @@
 #define VNCR_CNTP_CTL_EL0       0x180
 #define VNCR_SCXTNUM_EL1        0x188
 #define VNCR_TFSR_EL1		0x190
+#define VNCR_HDFGRTR2_EL2	0x1A0
+#define VNCR_HDFGWTR2_EL2	0x1B0
 #define VNCR_HFGRTR_EL2		0x1B8
 #define VNCR_HFGWTR_EL2		0x1C0
 #define VNCR_HFGITR_EL2		0x1C8
@@ -52,6 +54,9 @@
 #define VNCR_PIRE0_EL1		0x290
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_POR_EL1		0x2A8
+#define VNCR_HFGRTR2_EL2	0x2C0
+#define VNCR_HFGWTR2_EL2	0x2C8
+#define VNCR_HFGITR2_EL2	0x310
 #define VNCR_ICH_LR0_EL2        0x400
 #define VNCR_ICH_LR1_EL2        0x408
 #define VNCR_ICH_LR2_EL2        0x410
-- 
2.39.2


