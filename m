Return-Path: <kvm+bounces-57561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF618B578DB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB339445272
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9885730216B;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KucY3wyZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D0F301015;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936699; cv=none; b=WF80hdxY+tY15EnArJV295ji+4C73q/ZMTSgeh5fygLzci4sKC2oZQVVMlqoNEtMRYOlfcM7/r4J7UTipoTXKnauQPnFyUeeYDBkE8aiUwUwkxH4iDBgl6pd00eD75DchebKE6cLD2Evbn1BVh0OdFYUbW7vk7klpAvcMJPbBhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936699; c=relaxed/simple;
	bh=2TF/zey+KtgVTwTjGrxKxIt7FD4E/OPw0nUb/TkWf2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pMWizGKjO1iEGkhsAZWeZeonjPsqm0rUqrRYQ6RdI/O+5AqrQ6EOH1Fxpp93iFH8JO5JyrBzgC8dtxDI9xIOnPu+/KykVLPdgv8QqpsqAVAW+Ij04+51rGfZ8FGB09srN+A0ylH7KN4xBpAfHFvxMyUqO6POcl9pi5GJXe1Y7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KucY3wyZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A54C4CEF1;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936699;
	bh=2TF/zey+KtgVTwTjGrxKxIt7FD4E/OPw0nUb/TkWf2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KucY3wyZ7ey4BOfRCjfbLr0+D5mWLUvhVrg9PvRWDaErQRg3o5JOBBdBrKU1uErKj
	 QT7YognH7WcR/TBciahDpN4IRUqqfV1z+FwiBuZtCPQsK1KuYVgqrPkpiI6K972hiP
	 Cfhb1x/wDgfbMaXXA/5p6LZ131sk9qwzEpdiDs4TkGW9sz5uZyL0TTgU0+3FlwBNT0
	 Hwrk0y+nvc09kNkoinngMJG93fy6c+yZ33wg+yHxPMtx55igs4URKm6a2V/QfQsMtm
	 BhJszbm9RhrPB0eMDGHGKB8A7eeyaTbZrcCwiQn+xA9AV5AQGHGUgEg5GrwsoV5cTZ
	 SGb+HUv7GHLBQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dh-00000006MDw-1NvK;
	Mon, 15 Sep 2025 11:44:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 12/16] KVM: arm64: Don't switch MMU on translation from non-NV context
Date: Mon, 15 Sep 2025 12:44:47 +0100
Message-Id: <20250915114451.660351-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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
index c84a021067daf..2f6f83cc8d19d 100644
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


