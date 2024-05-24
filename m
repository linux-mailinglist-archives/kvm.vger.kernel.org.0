Return-Path: <kvm+bounces-18135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A778CE6E0
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4CD31C22165
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1108A12C7E3;
	Fri, 24 May 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9ntX7qs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3045086262;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560413; cv=none; b=Ks7lnoLekfZY4FGO4PD7cYQVaRvQOtmbzEJXYn7U/b+nT20mr2a6yYfHjjeOvauccw86RLEk+7f3rBC5Flazss8BbiKyGOK4Z0z2yMVKQud4drfqESHdZSBXcZoM0b4AK2OKXIeiqcf7IXcXi6pfZ/0XLqfVpLoCWPd2spi0IiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560413; c=relaxed/simple;
	bh=UBoLwNGuQCcRtKQYXG4UrSzJ5ovYyH9dKoajeluIiAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3YKpgMhbmy2KT9uWf9uThERL9AzmZiK9sLNTy13QbzryEKSp3oWcaOmZolWQLR92klnxCwbomcl60gDgQvwrlyny9ifGJp1gGZnLq2YWMZYdxh+JxWKzOuc3mGpA/Y9B8tgkM8q027EgTTJ+xJ72+vdH9+JCicEc77IEimGMTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9ntX7qs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4DBC2BBFC;
	Fri, 24 May 2024 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716560412;
	bh=UBoLwNGuQCcRtKQYXG4UrSzJ5ovYyH9dKoajeluIiAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9ntX7qs8kqzO1p6AolukxanwQs5o+WPLe6sF1b/3V4NhCQoa/ZNNXbdCxwolozPQ
	 3xm65YF4JuOxWlXldjpSSSSxvPHM5HrmwdMaEzQPEpyZRgkey5M277zg97bBm1PpBC
	 +sGD4WkU9EhP9MIlCcCevZwwvc+8BEG1OMTOAPXs4dMKEdnyyVk6Knw2SR97tonwGn
	 k3RfSG6+rXaRK7PJdtLALG2YNG6EFwnIDDZG3+0gcZ8+jJsNR7RMv8gLZHxkOTVqau
	 FraVuTeH++kNnSG1wQ8UNuIFLUCeX6Doz7Wyt6utMXLXFZGvHxxupeIFh/q/XQJQhw
	 vg/z99n5m4OZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sAVmE-00FRdK-S2;
	Fri, 24 May 2024 15:20:10 +0100
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
Subject: [PATCH 1/3] KVM: arm64: Fix AArch32 register narrowing on userspace write
Date: Fri, 24 May 2024 15:19:54 +0100
Message-Id: <20240524141956.1450304-2-maz@kernel.org>
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

When userspace writes to once of the core registers, we make
sure to narrow the corresponding GPRs if PSTATE indicates
an AArch32 context.

The code tries to check whether the context is EL0 or EL1 so
that it narrows the correct registers. But it does so by checking
the full PSTATE instead of PSTATE.M.

As a consequence, and if we are restoring an AArch32 EL0 context
in a 64bit guest, and that PSTATE has *any* bit set outside of
PSTATE.M, we narrow *all* registers instead of only the first 15,
destroying the 64bit state.

Obviously, this is not something the guest is likely to enjoy.

Correctly masking PSTATE to only evaluate PSTATE.M fixes it.

Fixes: 90c1f934ed71 ("KVM: arm64: Get rid of the AArch32 register mapping code")
Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e2f762d959bb..d9617b11f7a8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -276,7 +276,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
 		int i, nr_reg;
 
-		switch (*vcpu_cpsr(vcpu)) {
+		switch (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
 		/*
 		 * Either we are dealing with user mode, and only the
 		 * first 15 registers (+ PC) must be narrowed to 32bit.
-- 
2.39.2


