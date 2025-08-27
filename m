Return-Path: <kvm+bounces-55902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3CFB38785
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9E55682972
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE3A35AABE;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmxjIxsq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7629356904;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=LfM1YaxiXWTk0edc1NMwF66B7tvJ1aLNKiJYYsGlpgoKOeWLKae1btH9IEGIQqDh9ttqTtfvWLe98A4VzuH/XhHjiKnF9WZo8ODLs7TrP0qXyVg9nnjeC9MvyPiaDNDkE1fWAYUwokT2Ocs5tVWKWIJ9ICxKLj4xEvEyNhH+99E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=xFiCwHRpBjad861jtcnFFkFJ2NjU7rHSKrxDbaqViw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WI9VQFKu8VYsDz461diZmZ22A9hDL63ItxaVY7BNb1vvuKD0sqnTRVJnzi7m74yrHnpgwu039c/vz8qyGVgSaDdU/iMtBClt4ptPtkqLm7cW4VZV5MfBMJy++gBoNqE03x20KQ7l7uO3txOOx/1XSKCZy/NPUYK3pdp/MDW1KJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmxjIxsq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F9DC4CEEB;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=xFiCwHRpBjad861jtcnFFkFJ2NjU7rHSKrxDbaqViw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmxjIxsqqct2ILUHI/DaYjU0Ow28xwE193EI3P8bxq1F48zpXL2Qv6o9+DmhKLaTN
	 AdlQUOyC5I3Sd7sA7amjmtP0Qr4fGADKL7AOIPoLBDMYiFIXGqp2RXEUIBef8iCYNr
	 8Q/HMdYASlP+OtXqHogsKGWYi4PkT1Nt37DPjOmvYYUjm/2axJrVY8XGLSEa+t8Ruk
	 xQdfDvOtZY2CUU0VBgvkTPgSlesr2Bbtuf4MLpnz5mBJcx7CIpExHdUq/RRlC4eE4/
	 RV+ZHfevMtlUEgm0mlGQIO4G8MTAZwfUiuNKpYrl/lcR3UaJNnL0yxk2LjDmDn2BjX
	 1HwAJDXuUSANg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjY-00000000yGc-3lZs;
	Wed, 27 Aug 2025 16:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 12/16] KVM: arm64: Don't switch MMU on translation from non-NV context
Date: Wed, 27 Aug 2025 17:10:34 +0100
Message-Id: <20250827161039.938958-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If calling into the AT code from guest EL1, there is no need
to consider any context switch, as we are guaranteed to be
in the correct context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 76745e81bd9c8..6e767ae3c495a 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1294,7 +1294,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	struct mmu_config config;
 	struct kvm_s2_mmu *mmu;
-	bool fail;
+	bool fail, mmu_cs;
 	u64 par;
 
 	par = SYS_PAR_EL1_F;
@@ -1310,8 +1310,13 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * If HCR_EL2.{E2H,TGE} == {1,1}, the MMU context is already
 	 * the right one (as we trapped from vEL2). If not, save the
 	 * full MMU context.
+	 *
+	 * We are also guaranteed to be in the correct context if
+	 * we're not in a nested VM.
 	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+	mmu_cs = (vcpu_has_nv(vcpu) &&
+		  !(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)));
+	if (!mmu_cs)
 		goto skip_mmu_switch;
 
 	/*
@@ -1379,7 +1384,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
-	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+	if (mmu_cs)
 		__mmu_config_restore(&config);
 
 	return par;
-- 
2.39.2


