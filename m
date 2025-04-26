Return-Path: <kvm+bounces-44425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8E2A9DA98
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D47D5A4DB4
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC76F25179A;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLOj6V3p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C28A24EAB2;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670534; cv=none; b=bAJQZfyYz6SnpJvjg6QdSqgBxqPObqdfr6MMpoxxyJ/qur/gBG7ZhFIDmzNfK7JmL02cYuAuLa2ubGJCvGtAi6Zre2tLaeCnikQ5/f+IPihNXe0X19P61zdp5AN5a5WAp9KAJJ/L4xltx58L+LANHgKdP7KV0d3V6A4k9YoykQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670534; c=relaxed/simple;
	bh=PoJlZP+/3N5jgtrCxZmNfWdQYoZWYYc0jdBNCXnOc1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=brPPewxkVU4tToksRQvMoiqQqbGERtR5Pp5fATVrsZS0Ni5cdZAUJocKJoJCLDKd9bfvbQWj5Crni2Sd1IX3aD1ViIlUJaoO6cfMebXGCFD5Mt7/wN9kk8cGp1QjJufCTC1GKDQHOPflMyrUyKlu8D5UzdS8lHSYVs2v8GabtcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLOj6V3p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC72FC4CEE2;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670533;
	bh=PoJlZP+/3N5jgtrCxZmNfWdQYoZWYYc0jdBNCXnOc1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLOj6V3puHcZO2BQhQ6Q+vp7avw65ngSdLEPOp11grCja6NbW6Yoalm2eC1bDQgpo
	 eEwI8CzyUcM8PCe/r8HzWLwrzVWD5D6DogW3ENR6L1ObxsSu+nMo0d9KrsCqOv+7i7
	 JTHKALclTfmlyPMqKPmtJtsLRZePsU+s3m4L60agjVQ1mZ3gWJG87TJ5OSflknmWMG
	 JCF3BvQIPbzeeDwfMn2yuWDTWxb7VXACdm5RFft2Wk/hP3mAQZiEz/cK7oHCw5Olyh
	 +R6B6GavjK45QIkZ8XMpaocY1rFgCzen7kliYJa13ZWJRMngZTRVT3wlaw8SjQ6dGE
	 GZ8/LoZ42aHag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeK-0092VH-0L;
	Sat, 26 Apr 2025 13:28:52 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 13/42] arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
Date: Sat, 26 Apr 2025 13:28:07 +0100
Message-Id: <20250426122836.3341523-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Provide the architected EC and ISS values for all the FEAT_LS64*
instructions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e4f77757937e6..a0ae66dd65da9 100644
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
@@ -181,6 +182,11 @@
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


