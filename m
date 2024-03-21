Return-Path: <kvm+bounces-12407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E00E8885CAE
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7074DB22F3F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C0A8528F;
	Thu, 21 Mar 2024 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSwDoi4D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F82A1292CE;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036472; cv=none; b=c4deW01F+ocb3io47hRkWzUK5a0s9lf3L4U+lJN7h1eTQK/jWNVMEf8FTHq1RCUg1WkJdaC6JMlkC/QBzJa9768gnpaJYucfPNWy3r7nvNkqoMChhjSyeY10BSoAxcmnCydTCZYGoGUxzhsFWdam7r7h1MkbmaQIbxpA6SWHT6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036472; c=relaxed/simple;
	bh=2S7NEMoKfNTgcluAtTdkrdP+Yrj29Y/5gaGZNZQ3q4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XZ4fQVHo6vjfRD35H17sumHWLIa9mGbtYFEqfVVyUoSaTICP1pcNtSU0KTEdxDaPgNr0XRS34TzvuAImVPo5xVqwgOAnFhWjbtwJzwWe64PCzwljx3HbdMUXJie1lm/Z2PAyN/0Q3ZlSOL9JoJk0VBhvG+9FFon7tfReXsJv2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSwDoi4D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83CCC43394;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036472;
	bh=2S7NEMoKfNTgcluAtTdkrdP+Yrj29Y/5gaGZNZQ3q4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSwDoi4DuhyCE2xfpoxZPGLCb6S6bLcuN7IwljtxQr7M3PrcYWIXISzji+D6kNmr7
	 S3TLKgrJqBZQmIYkBX2f9lR+mMzjLnuJhx726hjPYUHlbZuZ10oh+p0UcHmFAbNMh3
	 xd4TjATve6LvsD1a8BSJTuzGZkO7pugkNQkoxQh5GDKQPVztYR29w6anKCIx/1j+iJ
	 4025KadysMULZmvHEhqxXhhwSq9bdWoVaoGigDg3yEbZhBllCGGcx8YuD2F7aVW4v4
	 iqvPoXMQDQIvkXDds1cpdbru7LG6SM0CUcWcYIZvDEdD3gRbWD9xj/W8l6Ko7855b2
	 hn4gIh9CC5Iag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkP-00EEqz-Os;
	Thu, 21 Mar 2024 15:54:29 +0000
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
Subject: [PATCH v3 02/15] KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
Date: Thu, 21 Mar 2024 15:53:43 +0000
Message-Id: <20240321155356.3236459-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
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


