Return-Path: <kvm+bounces-9792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D93C6867145
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7924B29D4C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC3E5647B;
	Mon, 26 Feb 2024 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rciItyHt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9C56457;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942056; cv=none; b=qCxzOz0zKwPXkaEVMKKXybaEwkCWylI/5jybxELhfAzFbOtvI+ZGOoS0OGlbYe491TwDPlv137MSO7Ew2JG9nSXP6hiTl7nxY3QfJ0ES7PomC0IKcXTVfkr+uR13tt4QRDolQtqeUr+3AWnU/v/v8lZ53gd+mmtN/tAIjB8kbII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942056; c=relaxed/simple;
	bh=2S7NEMoKfNTgcluAtTdkrdP+Yrj29Y/5gaGZNZQ3q4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OkVGLoeaQbWoVmXYWuhbgvSW6J9PBCxre+ZRVuGTdvn4+fDCA5sQU1pQsCl9DiyGKkzufhSq1ZvotJC3SFeofSH0ggHxRn2rDvuGmgVboV36xE6JLfenEkKk6kMSBQ7ew+vTCEkDWEQzApGCEBSE6Iz72vS6QZLd8R29isCS2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rciItyHt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34336C43399;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942056;
	bh=2S7NEMoKfNTgcluAtTdkrdP+Yrj29Y/5gaGZNZQ3q4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rciItyHtxUP03xtZ0cTH6X1PxaTuV99GZd1WOIMUBkZ3jFEtav1yEUzV2rWGKBef6
	 bwP2EbrIrrYoPrkZwNs1YbOpBOohCebMTqmfRCcqZA7+iDLZFxDfupb0yr1Jc+6jNW
	 NHBwyM2Y50hi+Yty2RC0v1HnahVOz7UDwIgDvLVjM3xnZAjFzVynOSXNJ7BndhDeHl
	 NhoTuG5L3ENgnpJfEdRf7eU/6fhJTgdZDt3jeICgy5GPnCGd+nLu4cmkWaCqylQ4tK
	 X1bIN/56q9awNap2GK7GYJH7oA/3MfQYxs2u8eMErFcG1FGKs0vJSyPIRKkwtt4gmj
	 XVFKXOn6eH0kg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtV-006nQ5-1J;
	Mon, 26 Feb 2024 10:07:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 02/13] KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
Date: Mon, 26 Feb 2024 10:05:50 +0000
Message-Id: <20240226100601.2379693-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
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
index 353fe08546cf..98008c16025e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -407,6 +407,18 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
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


