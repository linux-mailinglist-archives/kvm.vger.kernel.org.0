Return-Path: <kvm+bounces-15228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC558AACCF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE731C20F35
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6247F46A;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8e7nfMo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3173C7E116;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=itNSeH5XBv04S/EQHUiCbFcyoSoGaHbaGStaPLAO7dZuVs5zMupvOphWz1YDBEneCm40z8ZDYlNMdF7ggfz8PHOntdillyA6H0hrr/C0e9DKhU2HYk8NqWEGIUCD4XRrJoWz1nz0PMx9qo815l9QzxkZs+cs9wmsNA1nwOlHY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=6QJByFrrQaSRx5IB/H5CGrbHLbcChZnGbU2cGpXqnno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0HGVlN7ui9TwKCh9jSrUdRrVG+WrDWsKE7lDnQNnWLkX0mIpxHdsaruXvXmujM6zyyoZL5MCRTWSF6M7ERTZFF+o3WBjBIYZBmE+vq2tMHMI4cPQxzYuZJprLjZlrB7ZLJaKxN2mqx4147SeNacGhFfxyR6MKvZbrLeknVKwoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8e7nfMo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4ADC32782;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522591;
	bh=6QJByFrrQaSRx5IB/H5CGrbHLbcChZnGbU2cGpXqnno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8e7nfMonY2RPqtD8IWFv6/LXRK+Un/ctfMyOmNLGdxd9Qrju/FZrE+Y83Whn15Ma
	 Lqlw7+4ZON8ppVRxFwQ4CWk5aeMNtEX+Lj7asUB8ptmSbg3s4YaN2+Lt2GKcGofIbX
	 cKWBomEoBIpkAlfM2B8SWfyWG4GhytFOrpeZeWPv5jb0MKUvHnouyAjJ6yqYPYaPRt
	 dpdiM6bF6GTZykXdgaNgRraEB+6mtHcYtij6UA5k5kGzwcbX+JbSgVUrMGdNpp4efR
	 fDfxllFElDeRwraxFcDmH7+jtpwfVL7Wx0ugSqEmq6vuQR/2Gcn3g85xvYI5squKQ0
	 FVcd10KwPfVBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV7-00636W-BS;
	Fri, 19 Apr 2024 11:29:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 02/15] KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
Date: Fri, 19 Apr 2024 11:29:22 +0100
Message-Id: <20240419102935.1935571-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ESR_ELx_ERET_ISS_ERET* macros are a bit confusing:

- ESR_ELx_ERET_ISS_ERET really indicates that we have trapped an
  ERETA* instruction, as opposed to an ERET

- ESR_ELx_ERET_ISS_ERETA really indicates that we have trapped
  an ERETAB instruction, as opposed to an ERETAA.

We could repaint those to make more sense, but these are the
names that are present in the ARM ARM, and we are sentimentally
attached to those.

Instead, add two new helpers:

- esr_iss_is_eretax() being true tells you that you need to
  authenticate the ERET

- esr_iss_is_eretab() tells you that you need to use the B key
  instead of the A key

Following patches will make use of these primitives.

Suggested-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 12 ++++++++++++
 arch/arm64/kvm/handle_exit.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 81606bf7d5ac..7abf09df7033 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -404,6 +404,18 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_ACCESS;
 }
 
+/* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
+static inline bool esr_iss_is_eretax(unsigned long esr)
+{
+	return esr & ESR_ELx_ERET_ISS_ERET;
+}
+
+/* Indicate which key is used for ERETAx (false: A-Key, true: B-Key) */
+static inline bool esr_iss_is_eretab(unsigned long esr)
+{
+	return esr & ESR_ELx_ERET_ISS_ERETA;
+}
+
 const char *esr_get_class_string(unsigned long esr);
 #endif /* __ASSEMBLY */
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..15221e481ccd 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -219,7 +219,7 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
+	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
-- 
2.39.2


