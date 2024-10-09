Return-Path: <kvm+bounces-28312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B67F997532
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B3E7B22523
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE9B1E1C1A;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLBdMSuK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E41E105F;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=MI1wUBWoughRisVb6NINnLxZXhIv6R+jlmAv6rJ5AYyGto5mMo0YwBPsoZuZunSd1D98ntC1dstZxsivvtu9Mngky09FUVf0vRpYReelBZATD5TLFYxxr06cnx5Dq9VQxnfnOZDiVyapGVmu13uHLTnl6DGi/55ECuwOC+znazY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=MBWM0D7McX9GDlu1l75I+bXhMtl73ItIQYTO8Q7XfS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pQdEOydywr0zv/0R3Rf4iQXOTaSadsbmBDR5AvSFvcd4MvUylEMowiQSdrKipnA1UnkRnN/kHcb2nHW33QfiRucBozlBrzEcrjNovLkhXNDFDTGHYZdNPC5GyX7AcWkAnOz8zLO+KK3clQs7fTJN6Ztu85lo4xEOkRlq/ezwD20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLBdMSuK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E897CC4CECF;
	Wed,  9 Oct 2024 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=MBWM0D7McX9GDlu1l75I+bXhMtl73ItIQYTO8Q7XfS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLBdMSuKQ9O4DJgso9R4CZP9UMrx6pEsHucbfh5OyZ1T1suytf/F1kgCKO59239X9
	 /RTsznin6N4R1OjUn2qWtNV8fOWKusH9TL3+4eC0o/5f44uN05SGWyoAL7KVbEmtAy
	 rpY8SfGUg++hlCMeSArWElI/VfqIkiS+m0LrCmTRdHmyxSXd8G9sO24NSeJC1mnGJc
	 Un+tRANS2h+nfnfr20QpC34Mf+Vf8uvt9TSJp/5kEPV2waxU3r61Fgcbs3vVuE9Pf2
	 eJDubf2v3kXEU90qO5DKy2FHLpbzi5jgVP2aYuJKehBPAIUu4PdkOJH5iAp+YGTKhi
	 0n2Wf7tnj26KQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvN-001wcY-0Q;
	Wed, 09 Oct 2024 20:00:41 +0100
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
Subject: [PATCH v4 02/36] arm64: Remove VNCR definition for PIRE0_EL2
Date: Wed,  9 Oct 2024 19:59:45 +0100
Message-Id: <20241009190019.3222687-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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
index 06f8ec0906a6e..4f9bbd4d6c267 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -50,7 +50,6 @@
 #define VNCR_VBAR_EL1           0x250
 #define VNCR_TCR2_EL1		0x270
 #define VNCR_PIRE0_EL1		0x290
-#define VNCR_PIRE0_EL2		0x298
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_POR_EL1		0x2A8
 #define VNCR_ICH_LR0_EL2        0x400
-- 
2.39.2


