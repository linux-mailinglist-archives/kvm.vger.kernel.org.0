Return-Path: <kvm+bounces-40622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C47D0A5943A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F1CD3A8092
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED620227EBD;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZ6g8f5W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46A226CE0;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609513; cv=none; b=inmvp5EQDnqB46BKJzNumtUClPGR70EowF16rNJIb+ADK34v5TjBMzl1Qa0x0jz7ZP8lUfN3EQXxpZ7XptV/tDu7NaxnLawPOPf32zZD3/8QOniAdngi4t+ZAiQHzkzZR4bco2da3LG+w5mlGMF2sWy9ABF5TG5aAHBCg9EZeNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609513; c=relaxed/simple;
	bh=fj639nJ75hJ7XRyZ1GdaHisZDlAah8z6A5PljJGIyGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kuAKSfynlbKc3pvSPS50kM2UoJK7MDU3Ew+PbIYXJOASn8gK1PjMdxiZcDglA5ggp2PjOMrjG65nRHulHHlB4tq7Z7NNwnPxSD2fwvHPm9wNodPQWCC+SunLY8ujrnTQJw04aV810ViLIOKmSvULdPknU1cvRrOfJiC4uO65nRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZ6g8f5W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89E0C4CEEA;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609512;
	bh=fj639nJ75hJ7XRyZ1GdaHisZDlAah8z6A5PljJGIyGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ6g8f5WQILV0fQZgOJxbeKjGxrP78q/rSiKDIO0mBBPvPOeCfzlmUatudU4NXT5O
	 /hRice3ANXMoEQGaSd8uSDJ+fYj5hsq+LH0w3WvRIYSGEsxnhDak966LZavrgiFeRZ
	 BBsTJbP5pNBbyP+RFcAZLqtnGcUVVMkLLwh5KmfHHD4nmX/qkl8HmK0Ot2m0/Nazer
	 XgrH323IuB9IZfeKdMkTJqFwVl4wMvf1piRMBOzmzM86n6cAPlIprGUOHPkAmowkp1
	 ghwBMeH59V3i+qtQnzL46K0rCKwTqEH9epNTuYzb4zVwPADnZjkUHH75Z+Ei3tKCk7
	 K9/V/EHDEGdlw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBy-00CAea-R1;
	Mon, 10 Mar 2025 12:25:10 +0000
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
Subject: [PATCH v2 04/23] arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
Date: Mon, 10 Mar 2025 12:24:46 +0000
Message-Id: <20250310122505.2857610-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
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
index d1b1a33f9a8b0..547b4e857a3e2 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -20,7 +20,8 @@
 #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
 #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
 #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
-/* Unallocated EC: 0x0A - 0x0B */
+#define ESR_ELx_EC_OTHER	UL(0x0A)
+/* Unallocated EC: 0x0B */
 #define ESR_ELx_EC_CP14_64	UL(0x0C)
 #define ESR_ELx_EC_BTI		UL(0x0D)
 #define ESR_ELx_EC_ILL		UL(0x0E)
@@ -174,6 +175,11 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
+/* ISS definitions for LD64B/ST64B instructions */
+#define ESR_ELx_ISS_OTHER_ST64BV	(0)
+#define ESR_ELx_ISS_OTHER_ST64BV0	(1)
+#define ESR_ELx_ISS_OTHER_LDST64B	(2)
+
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
  * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
-- 
2.39.2


