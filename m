Return-Path: <kvm+bounces-54842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6151B292EE
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA2621881BF7
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F031239567;
	Sun, 17 Aug 2025 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haZkg418"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDDB199FAB;
	Sun, 17 Aug 2025 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755433173; cv=none; b=aXMjkqVX+YS0OhCT27/WNXgkGk1oVVNwpdz3Wa/w1cPlgYeEHGw6P4vwl5X/GCkrwYKp/Taa71jNo4EKH6wSwhrtNvol13ks3uM9zFYLnRFyXdWhHmWvMreg0Co5pJIxpwx44UqL0j5SErNN+ZtoM7Pb7Sm5mOcrOCtusKY2fHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755433173; c=relaxed/simple;
	bh=6O3ZVvHdrs8pMLhU0xKvwyNZZW4I8MNdbGA++gTccPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sxXAxl1z4dK+sE7gvRvLISl4ZSEPSGHJWDxxs/4Efym12O7t8FGNDSeOwj9XWTuEcfJssA112WHvmkFzMi8eBd4dwXhOsNtX8S0mdsdEP7+KXX+5WuGPtWtenKBrUqYBGsWGIXCIJyDyEZBuG5JiJeKo6dFpT3lgNwSpzJMHG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haZkg418; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDB3C4CEEB;
	Sun, 17 Aug 2025 12:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755433172;
	bh=6O3ZVvHdrs8pMLhU0xKvwyNZZW4I8MNdbGA++gTccPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haZkg418UdG9q9K+quCbAsm664rxL+8kNtzH18ZgS0fCfu+nlW2yriUpd5A+IneKH
	 L2DV8LO4FU29iZlcMrPqqgPfyaynqRnj1grCZ5MEzwNFEyVPdAX3rBcN+VDuCM62Bi
	 VhR6RDzCWMxs+2KzBvXB6yGY92n1MSyUwsYFbLQJvElZek2LXwXDWbH6ZevoRJsY5X
	 skx+sVw7EHFn8Y5CHcBIC1CJ0LLWk5nlNCPga/jsO/L43Pk44Bu5TIryBg4C4Lk+oM
	 VjhslD36wcNmubmOOK+seE2GG0lqqdC/1kMDQkNt2gRkboV8KlALGBkjyFyQbpBPZc
	 dzUQeqSebYRPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uncME-008L0z-Hj;
	Sun, 17 Aug 2025 13:19:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/4] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the 32bit state
Date: Sun, 17 Aug 2025 13:19:23 +0100
Message-Id: <20250817121926.217900-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817121926.217900-1-maz@kernel.org>
References: <20250817121926.217900-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like c6e35dff58d3 ("KVM: arm64: Check for SYSREGS_ON_CPU before
accessing the CPU state") fixed the 64bit state access, add a check
for the 32bit state actually being on the CPU before writing it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 95d186e0bf54f..3e67333197ab2 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -59,7 +59,7 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
 {
-	if (has_vhe())
+	if (has_vhe() && vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
 		write_sysreg(val, spsr_abt);
 	else
 		vcpu->arch.ctxt.spsr_abt = val;
@@ -67,7 +67,7 @@ static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
 
 static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 {
-	if (has_vhe())
+	if (has_vhe() && vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
 		write_sysreg(val, spsr_und);
 	else
 		vcpu->arch.ctxt.spsr_und = val;
-- 
2.39.2


