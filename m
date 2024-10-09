Return-Path: <kvm+bounces-28324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1AF997540
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED231C20AAD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFDF1E32C5;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBaDfm2V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3B1E1A0F;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500445; cv=none; b=FYBLDE2SdESl4AoffOI9kH2sIpg+enlFJAT/5QuKP13rkREP1NAOnfLhREVTCIoPLooCUsX78h2yru2pGoXL/8C6k0JzXlTi1RaWozJlpygKciEC/ZMZoDGpjfus2SBaILgEcP7bqHqkZVo8pBe54aLcQfiWvSgz9zhrU6lmBXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500445; c=relaxed/simple;
	bh=9+/nsAR67kcoOIR04scqwy0Kbr8w0EBa0T/U1HOQkjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nnm4wXldcLO8aIKN7GOBBTfxRsO5kBnBiZmYYPyToNdZO/b+KBVz0tDU6Zrrhy5Rp6aW3R4UaeeF+Noh3NLF6VaT8ZFzprhiGrN0RxweoSofTzvt24riBaUEmLPuH5DG1htf8ePu1jfT33itF2Ow96V1AdFfIxY6hchbT4IM0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBaDfm2V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2059FC4CEC3;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500445;
	bh=9+/nsAR67kcoOIR04scqwy0Kbr8w0EBa0T/U1HOQkjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBaDfm2VFGp4HRkhfVouny1HquYl6PDN43aKltJMOjaL0StKpF9DQ5dw0qv0bH3cn
	 uj1IxoXwV4QsZBDRw9NheKh2wvnNpkmEGatjVzgMPMbYXIZZORDXReAiWeWK62dxVh
	 h4P6Az0Jrtgu6OcWq0NW8yqF9OuxmUPNwUo5d/FM7EylY9ScCLOJ2w9cDLU2bduGdK
	 PFyyPJr2UMLux8RVODtcfrySjyL/MhMBn+XAlge7a1FyKO2ZzbSSozGMx/jgovIOGH
	 SsQI8Vddl8XzVk1+9s5kdZ1L7zkSV/rubaxWT3xVLFniZnBm1qjOLh5/ibmHAATCyK
	 nb5XXj/Mo8tBQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvP-001wcY-9u;
	Wed, 09 Oct 2024 20:00:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 13/36] KVM: arm64: Add save/restore for TCR2_EL2
Date: Wed,  9 Oct 2024 19:59:56 +0100
Message-Id: <20241009190019.3222687-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Like its EL1 equivalent, TCR2_EL2 gets context-switched.
This is made conditional on FEAT_TCRX being adversised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index e0df14ead2657..5f69a1f713cfe 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,6 +51,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
+		if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+			__vcpu_sys_reg(vcpu, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -108,6 +111,10 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
+	if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR2_EL2), SYS_TCR2);
+
+
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


