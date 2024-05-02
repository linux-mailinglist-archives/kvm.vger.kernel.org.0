Return-Path: <kvm+bounces-16428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F35698B9FEE
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 20:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA3428207B
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 18:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121C9171084;
	Thu,  2 May 2024 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJCM1CK6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B1B16FF44;
	Thu,  2 May 2024 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714672804; cv=none; b=Rw7WUuPuXjWuW07lV/NPxR7cz1moQBo5IBVvmS1otaQLNghL1cnoCtbbVe+mcvxVzAOh7rPwKkh3Ixgv0WYuNrchxdyF8oZn5glfFdRh/waB2tzDZKkF1xhhtIJDbtOMl8UppanKI6y/mp+gU2oODMirtiWY+VONFVMYkdE1O5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714672804; c=relaxed/simple;
	bh=Uztgc0jtuFiH+ctT5hhpEehjUN1LGFtTpk6OV22QByE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SW2eGIxSZ2BnAOtYDynhus23JB04N6RCAmiO3JHFKFZ5Kxlw9impOEsiha3bVPezI3somc8GMWfC1vgUyO5ZwAGY/cjxqicLjE+lEGxgQJ0OV2WojX9WpQF7cfEhXs42U2lUuEPGi4N5bQnJ22z3J5qe8ihvMaWX9FVqaWPcOs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJCM1CK6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C8EC113CC;
	Thu,  2 May 2024 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714672802;
	bh=Uztgc0jtuFiH+ctT5hhpEehjUN1LGFtTpk6OV22QByE=;
	h=From:To:Cc:Subject:Date:From;
	b=dJCM1CK64dicof8h9x/SWA1dySmkf96gTwGaxSzHUV0qLTRO/R1yGYnaP8PTABake
	 4KFOGLuNT/Tzj6XLKPoiXEcQ6s8TvHHusoiHXjWwTkKG+9dU5PC57UAlCYxuN6YHrJ
	 ub7470/h1X5xYAgZMojufrfVsmAk3fXRWLmSM7uvjJBWM7lxGQtRYC7qwvi5rlZG+X
	 5R7z9+976H6IGUe+KuWnPjtf8Zv3Iau5o0KGkl7CBtN0SkHl6c2lAFbvUsPYVKWBPH
	 rOYog1WugWsd6m9QBqPGYda4r4nrrDDnOt6MfAHFuOWFqE3w8hU32Mm7KKUgvivklK
	 W+O3jZmroInug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2ait-00A52w-S9;
	Thu, 02 May 2024 19:00:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
Date: Thu,  2 May 2024 18:59:56 +0100
Message-Id: <20240502175956.3215496-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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


