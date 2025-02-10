Return-Path: <kvm+bounces-37709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A4AA2F784
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E73291665B3
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0159C2566D7;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRFw3gYP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0437025A2B9;
	Mon, 10 Feb 2025 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212920; cv=none; b=ll5trB6oyCfokwYuank8F6E5zWYuZNOL9dgeavStCWAJ0PcpGwaV8bERuR6mbXnZJAGLKnE8qJon/inEn01m6sn6fi/0wwtGo8rWYIWxKz1syumEcUqdsDZw3AE2RYoB+xTHHACCyB66q2SMcc8wwnv3CzDRmDwdmdpal2XkH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212920; c=relaxed/simple;
	bh=m74jfUKAjF1AZA6q50yggxbhx52u63cIVgdy05odc3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gQNV97sZQobacQALURu10eCzwi/b8M7SqAm98LUglJxjnGRi6KeNzn6Z5TsiCb1P1aSttWoTOF9QglrYsbcUE8oyGp5DvDm3oWlegZFzLfy1hVIF2vyIJkJnON5jHJJ5wVhlc6DN8FegExqazWwtsEwUdvb2ecuFin4DUyGjPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRFw3gYP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB94C4CEE6;
	Mon, 10 Feb 2025 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212919;
	bh=m74jfUKAjF1AZA6q50yggxbhx52u63cIVgdy05odc3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRFw3gYPDmA7j5LH7ee8LXO81L+3Gge9vYUVZagNDhacwEhstaZLlAHL5euse0k+k
	 l5HVBiBbTv2lA14lbNitvqXDWjIHSnUmykbun1aRwXhOuE9hYAyiUiYbJlpKF0PcXD
	 p55/g57tpgCcobHN7is6TcCU0TtIBcAIjxvxYdtRqCVlTKPo0OuC3y+TgUKoPi8MVC
	 9Vaj2y9fCLHK2sd800EJuSudydMPCZeBW04l7n9wYuFKNhoHPhWiA902umLTMLvP0G
	 iM1OlZaZXNfqSOA59TeG9EIfa3hmeIF6uu8QqwtLmeACTRSJ0PPoB3azXg7p6zl22H
	 RZ1W/VhHDdTxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjF-002g2I-KX;
	Mon, 10 Feb 2025 18:41:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 02/18] arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
Date: Mon, 10 Feb 2025 18:41:33 +0000
Message-Id: <20250210184150.2145093-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Provide the architected EC and ISS values for all the FEAT_LS64*
instructions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d1b1a33f9a8b0..d5c2fac21a16c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -20,7 +20,8 @@
 #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
 #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
 #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
-/* Unallocated EC: 0x0A - 0x0B */
+#define ESR_ELx_EC_LS64B	UL(0x0A)
+/* Unallocated EC: 0x0B */
 #define ESR_ELx_EC_CP14_64	UL(0x0C)
 #define ESR_ELx_EC_BTI		UL(0x0D)
 #define ESR_ELx_EC_ILL		UL(0x0E)
@@ -174,6 +175,11 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
+/* ISS definitions for LD64B/ST64B instructions */
+#define ESR_ELx_ISS_ST64BV	(0)
+#define ESR_ELx_ISS_ST64BV0	(1)
+#define ESR_ELx_ISS_LDST64B	(2)
+
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
  * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
-- 
2.39.2


