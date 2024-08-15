Return-Path: <kvm+bounces-24251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EFF952EA4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1A91B2681A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EEE19F47A;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG+M6Wdt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AE219D89D;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=SDbl6iLEWrHqJk2sXvai3GMqpou8Ym9Vpkc+woqsk2DFH3Pv4ilIuGizm9dpHMQqDUcL1X6SxDsoRQV/91RW7Q2ppvmp3rKlioxkG2mcqhgfvUKHUQ6ybUJR4syCCgBdD8Jd7qP0OLDNEx0a7uBofGSSsfoCr9JdWEwxPux8PoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=Rw+oG70QnJ4dX4Pty/A4PbvCVTYBSSQWvkzzsj/HeD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kYc+ht9mRQjT/qGvzBjnbjXUqv4WPemqsjn905dYgJaCWbQtnopuK0YPyhFNz4jaglhurkxLNmVO3gg1vYZKhPXAIVFaG2r63PORDqkt2Kncyfgpj9pKriLZtRuTC+bZAao2MoToEIPKtDcjp6kvIsjAWvzhdlPt5oywqlWXkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG+M6Wdt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6083C4AF0E;
	Thu, 15 Aug 2024 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726804;
	bh=Rw+oG70QnJ4dX4Pty/A4PbvCVTYBSSQWvkzzsj/HeD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG+M6Wdtlj0+qoeUh2LReYONRjTITOVjA9LGIpPpuzYn7t8mWDM+i4tsJq3F1kbYU
	 qaA4TnAjshvZ+U3syJU8E+nux7L+YxAKcLejuH973JFIHMevu58mYIWzXQ0hg1l/nP
	 42gz7Zru+DwEub9ig3GQ95LbYv4ucO+/lS7FVRT7swSpZmaLAat2DV1uiFcn7oCo47
	 dzm3mMBMv5RX5WF7zByIxqGHzrmmO7EjXea6Kb2gmXtnO5ExmxHeQQgyGCE+Z4uzC5
	 nZzusfopgzSnwnwD01dAdb0N+zF14NBEkKEmukyZ+Dpfyui6q2q3Bg4xzvDT6xmfWm
	 OljWi5+BREWVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5D-003xld-3N;
	Thu, 15 Aug 2024 14:00:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 02/11] arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
Date: Thu, 15 Aug 2024 13:59:50 +0100
Message-Id: <20240815125959.2097734-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Provide the architected EC and ISS values for all the FEAT_LS64*
instructions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 56c148890daf..4a76883616ab 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -20,7 +20,8 @@
 #define ESR_ELx_EC_FP_ASIMD	(0x07)
 #define ESR_ELx_EC_CP10_ID	(0x08)	/* EL2 only */
 #define ESR_ELx_EC_PAC		(0x09)	/* EL2 and above */
-/* Unallocated EC: 0x0A - 0x0B */
+#define ESR_ELx_EC_LS64B	(0x0A)
+/* Unallocated EC: 0x0B */
 #define ESR_ELx_EC_CP14_64	(0x0C)
 #define ESR_ELx_EC_BTI		(0x0D)
 #define ESR_ELx_EC_ILL		(0x0E)
@@ -172,6 +173,11 @@
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


