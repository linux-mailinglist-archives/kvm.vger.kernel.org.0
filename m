Return-Path: <kvm+bounces-18138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E5C8CE6E2
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA2A4281E60
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683B012C814;
	Fri, 24 May 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyEO5d+C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF812C528;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560413; cv=none; b=Bx5SBT6G1RhiFnUZ+EEbM10Mt4rrvTD6TSONbDdVKzJPCinh/nKVRckIw6sjOrmcYbZsoRqQzB8RC+2RDqWoi7fDrFSIyF2p0T98cHPfb/vm86f1SwQEyAvWeE8RUTJ879DZLycwBRvklqNsTZSlF/n/GLhM3J7TcyF5Sen1+X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560413; c=relaxed/simple;
	bh=xU072VGyeAHT1DAYktQWseuVolvnjzRb0w0T1x/SsfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FAAPEQfjIyjDI3JUOQ8tqk2tQ40UlTC7aqT78qY6A/Svs1lXJZ1chvglQL1RqH0iAPlIz3vt0mv3FZCRyFGTgw/5nZi0GxIkam7IrBEaSYk3hgwkuF7WxY/E1SIF8g9UlmFrep9kI8P/DQfEPbv6gfVy5+fditeXah0BcUmoVp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyEO5d+C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8EAC32789;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716560413;
	bh=xU072VGyeAHT1DAYktQWseuVolvnjzRb0w0T1x/SsfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyEO5d+CsXAivITK9xTi9dn8/WtNYTJw5jpxXG5r0yGjOywMWPE7G/kVPC+4oZdye
	 cTYgT697wzfyv+el/4e3z3vC9YgcKC8KW2jrkcDvJk+usF6diuYVup0N7cVa8mA0vf
	 cC4BDaaN101b+WwI/4TD1xwuQ3Ebcx7rJWzvjXTYh2t8sYkgbUwbLF7Wn5jWoLC7Nh
	 qX2Y9ML270+Udkcrupp1xbiXb6SAADoQGXyfUw7G3/01w5N2D5scWz10mc9VUnvhdq
	 rFiLzMj+1FBRd3AwKPTYNJ1EWrhoUwNriLpE229kwVO3gZCVFUL8fJuFwrlfH+buJq
	 9osT0Zwvl0z3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sAVmF-00FRdK-8k;
	Fri, 24 May 2024 15:20:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
Date: Fri, 24 May 2024 15:19:56 +0100
Message-Id: <20240524141956.1450304-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240524141956.1450304-1-maz@kernel.org>
References: <20240524141956.1450304-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, nsg@linux.ibm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We recently upgraded the view of ESR_EL2 to 64bit, in keeping with
the requirements of the architecture.

However, the AArch32 emulation code was left unaudited, and the
(already dodgy) code that triages whether a trap is spurious or not
(because the condition code failed) broke in a subtle way:

If ESR_EL2.ISS2 is ever non-zero (unlikely, but hey, this is the ARM
architecture we're talking about), the hack that tests the top bits
of ESR_EL2.EC will break in an interesting way.

Instead, use kvm_vcpu_trap_get_class() to obtain the EC, and list
all the possible ECs that can fail a condition code check.

While we're at it, add SMC32 to the list, as it is explicitly listed
as being allowed to trap despite failing a condition code check (as
described in the HCR_EL2.TSC documentation).

Fixes: 0b12620fddb8 ("KVM: arm64: Treat ESR_EL2 as a 64-bit register")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/hyp/aarch32.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index 8d9670e6615d..449fa58cf3b6 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -50,9 +50,23 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 	u32 cpsr_cond;
 	int cond;
 
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_esr(vcpu) >> 30)
+	/*
+	 * These are the exception classes that could fire with a
+	 * conditional instruction.
+	 */
+	switch (kvm_vcpu_trap_get_class(vcpu)) {
+	case ESR_ELx_EC_CP15_32:
+	case ESR_ELx_EC_CP15_64:
+	case ESR_ELx_EC_CP14_MR:
+	case ESR_ELx_EC_CP14_LS:
+	case ESR_ELx_EC_FP_ASIMD:
+	case ESR_ELx_EC_CP10_ID:
+	case ESR_ELx_EC_CP14_64:
+	case ESR_ELx_EC_SVC32:
+		break;
+	default:
 		return true;
+	}
 
 	/* Is condition field valid? */
 	cond = kvm_vcpu_get_condition(vcpu);
-- 
2.39.2


