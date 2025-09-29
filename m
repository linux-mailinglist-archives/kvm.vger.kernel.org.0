Return-Path: <kvm+bounces-59012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 988C9BA9F25
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21AE87A6202
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A8A330F549;
	Mon, 29 Sep 2025 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUORJnsv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F83D30EF8E;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161909; cv=none; b=MD3lD16//+7331NNS2cLC8fu0J/vJbNsHj073jTeMPIwzyB09Io7URPs+PLuavtsTAV9x/f3sCmizBzJJTdtAtQB2jgTzzcuFetlGGBEhDV0cehZx2yibqC/87kx5gA0RDCaeXNpAKOGSRb6q6yg13d1CH5OYqUb7MXz+MnPJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161909; c=relaxed/simple;
	bh=xf14NnyMKHem7v0GFcButVI1oYqRG6KefQ4B2vRe5+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9SoE7wtXp3a7ZXFSHYnmLnP6Fk3Na7ijp9elPwjJd4Cc1BYw+8dMpobA5XyIqB/PBFQj8QHokXhCnXduWuB/I9Vrilo+O3OsLx7V3gMFgWMiu4nYkzdQCe2byACbFys7IGmW5QRYT1iK4S1LuWagFDDXFDoeAaxUkEbaRWEXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUORJnsv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FC3C4CEF4;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161908;
	bh=xf14NnyMKHem7v0GFcButVI1oYqRG6KefQ4B2vRe5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUORJnsvm3yTBHTq5QrTy8DnN6hmend8BtrBkXa0lDViVCD93T7FN9sQtJd94UPBc
	 J2dOF/dJW/h+ucsurQkK40W+s1PBdhrAq0Qcc9QafX3bQ0EJalIgt3z+PmZs7As9k5
	 GUMp4l5E/+dga/DRTdy8qdoP8og5E1pgj+hXyylfD9jDonvmU9UatFkPxtYVE4p56o
	 HfFUQXqdZhhalTnSTtuAwUY1L6FT2ttkrNjybK4Afdg9Lv567j4mFhWrwFR6uBvbvv
	 5uN96mP/s6tiddu1uYSwu8oprD+b0OZXdvxjZlmCZdYliTbOoAxkT9Iw3zu3tASF9S
	 Vev6M9TENpseg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN8-0000000AHqo-1xoU;
	Mon, 29 Sep 2025 16:05:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 13/13] KVM: arm64: selftest: Fix misleading comment about virtual timer encoding
Date: Mon, 29 Sep 2025 17:04:57 +0100
Message-ID: <20250929160458.3351788-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The userspace-visible encoding for CNTV_CVAL_EL0 and CNTVCNT_EL0
have been swapped for as long as usersapce has had access to the
registers. This is documented in arch/arm64/include/uapi/asm/kvm.h.

Despite that, the get_reg_list test has unhelpful comments indicating
the wrong register for the encoding.

Replace this with definitions exposed in the include file, and
a comment explaining again the brokenness.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../testing/selftests/kvm/arm64/get-reg-list.c  | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 7a238755f0728..c9b84eeaab6b2 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -348,9 +348,20 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(3),	/* KVM_REG_ARM_VENDOR_HYP_BMAP_2 */
-	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
-	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
-	ARM64_SYS_REG(3, 3, 14, 0, 2),
+
+	/*
+	 * EL0 Virtual Timer Registers
+	 *
+	 * WARNING:
+	 * KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT are not defined
+	 * with the appropriate register encodings.  Their values have been
+	 * accidentally swapped.  As this is set API, the definitions here
+	 * must be used, rather than ones derived from the encodings.
+	 */
+	KVM_ARM64_SYS_REG(SYS_CNTV_CTL_EL0),
+	KVM_REG_ARM_TIMER_CVAL,
+	KVM_REG_ARM_TIMER_CNT,
+
 	ARM64_SYS_REG(3, 0, 0, 0, 0),	/* MIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 6),	/* REVIDR_EL1 */
 	ARM64_SYS_REG(3, 1, 0, 0, 1),	/* CLIDR_EL1 */
-- 
2.47.3


