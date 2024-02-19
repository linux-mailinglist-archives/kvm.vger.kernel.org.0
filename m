Return-Path: <kvm+bounces-9054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 556A0859F80
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11BC22834FF
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3830B24A0A;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmMmWLNn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5654822F0E;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=EMzr72wQZIzjxXNb37Zk8Q7uYCZBCiwZoyUIBcmqE16oSM1mJFSPa8ruqkvy3ZzTgYb1wpgAwWumMIYsJTHwi7LtenFn2QrVrp/VRxSHNQxPIBbDiwo9IoCBsbgKD71J1Ixa1LD1kR7f2uSU9jQjoWAoBOd7etAORHibEqhPMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=o1Ph3OO1c4EdF4VuyObf2uVzB4bNnlJcJufbMYmIJXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mBcNx1iivMIw5n98sYBEHiTFnM0/tKF/JgYx1d0KsJUhNJMolHff0vOL/D003fPaajDmXxRvfAEaoR4CSwzFdD3RKDmYmg8AfppEE7FaZOfkSB94sfNsX3BG98iHjSfBOY1zf1tH/ujdwr1WNQaOEDFiP8Uxjm6i9SBgZgWQ+38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmMmWLNn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE317C43394;
	Mon, 19 Feb 2024 09:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334423;
	bh=o1Ph3OO1c4EdF4VuyObf2uVzB4bNnlJcJufbMYmIJXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmMmWLNnjtkQ+2UxibAZipLUgaukJLI7EIA74lJdrMxEGlnZ93hie/shHjn0e4knL
	 fQxU0qv3r/MT66AVw4gL+xSXbX4tx0YYA8Udscr0GkaGsISoVfVlRVvHQQBTcko2+6
	 qKxYxUcMqfbypa6m5MTU1VvK25a6TuKyVubQ0efiqMaESRhfhyRcXEOAwQi/ZYG5Zt
	 +DTQUag20T6wENZobhbiwa1Grq0j+zd4ea7zW8YwFgEcrJmceNiOpcMiUiKDrPIjhV
	 xUVQ9Q/VDd9jl5FUZd2XWHdiyetUdwUBY32/TJ4lFl+/YonqUmk1wSr8jmvgdmF8hv
	 1ODKvzQjFnUwg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzoz-004WBZ-SP;
	Mon, 19 Feb 2024 09:20:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 02/13] KVM: arm64: Clarify ESR_ELx_ERET_ISS_ERET*
Date: Mon, 19 Feb 2024 09:20:03 +0000
Message-Id: <20240219092014.783809-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ESR_ELx_ERET_ISS_ERET* macros are a bit confusing:

- ESR_ELx_ERET_ISS_ERET really indicates that we have trapped an
  ERETA* instruction, as opposed to an ERET

- ESR_ELx_ERET_ISS_ERETA reallu indicates that we have trapped
  an ERETAB instruction, as opposed to an ERETAA.

Repaint the two helpers such as:

- ESR_ELx_ERET_ISS_ERET becomes ESR_ELx_ERET_ISS_ERETA

- ESR_ELx_ERET_ISS_ERETA becomes ESR_ELx_ERET_ISS_ERETAB

At the same time, use BIT() instead of raw values.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 4 ++--
 arch/arm64/kvm/handle_exit.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 353fe08546cf..72c7810ccf2c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -290,8 +290,8 @@
 		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
 
 /* ISS field definitions for ERET/ERETAA/ERETAB trapping */
-#define ESR_ELx_ERET_ISS_ERET		0x2
-#define ESR_ELx_ERET_ISS_ERETA		0x1
+#define ESR_ELx_ERET_ISS_ERETA		BIT(1)
+#define ESR_ELx_ERET_ISS_ERETAB		BIT(0)
 
 /*
  * ISS field definitions for floating-point exception traps
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..0646c623d1da 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -219,7 +219,7 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
+	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETA)
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
-- 
2.39.2


