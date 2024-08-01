Return-Path: <kvm+bounces-22916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DD094482C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83738B28C30
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97EC1A0734;
	Thu,  1 Aug 2024 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQgq3rmA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7B7170A33;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504149; cv=none; b=UmrLkxFcrM3lROWNJyUUIFrEibJTTk3U/Jz7rD41+morgb0+JzcyyKsv7qUfDY/5HPmHejHR2fpTulEMF8eMvfIJdpKJgVouw+BVQR/XeYknV20BOo0ALvsPPXdiBKtC6xHoS48Ri3+Cf2cqHsylumQdZGpgE7a+OG6hLF0CIsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504149; c=relaxed/simple;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GFH2A9yI3lMugz3+YVwYPel17EF+q/hugSQtm+FfcFREeLmJYp6UN1u+18qO+yIsTsfnBUv4xamvUuaI4q2psxujqbRaz6zRQAzpvOZ9Hvp7Gtb71RGWQRmiHenE8M7y6A8ywNHuoM4qE+nPgJdECuw3OD7R+qg78WcvKO9A3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQgq3rmA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A98C4AF0B;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504149;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQgq3rmAGnBq5Ot53TWe8ag+xh848jukPFqjcPIi8KUy8Sr7cwP1wKVCiBq51YK18
	 RBvmGjqOEFGnSi5LXy/hlEt2eBvvvCFpUnL4WlIftVvzvVSVNy5spBPaECAbCMydBS
	 Yzlbw3U+EsnILQjD/HcwyuAImVFFX10FpuoIBhwsdguyiqUMXFdjE25qmAacDEy5sU
	 p6iBpzt953czwn5/ZyBE597La+RgafxIr+O5d0ekES8BgQMDEHoW7nuNXX3rDBvmrA
	 Op9F5OEaAhUn1KSFlLkeMFCSw0RKKkD4Ir4RusTPeeA5cWoCTqLDPi8v5QGrCAz4uQ
	 k/EJi4NTs+Ajg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRyb-00HKNZ-CO;
	Thu, 01 Aug 2024 10:20:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 7/8] KVM: arm64: Enable FP8 support when available and configured
Date: Thu,  1 Aug 2024 10:19:54 +0100
Message-Id: <20240801091955.2066364-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If userspace has enabled FP8 support (by setting ID_AA64PFR2_EL1.FPMR
to 1), let's enable the feature by setting HCRX_EL2.EnFPM for the vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4c2f7c0af537..51627add0a72 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4579,6 +4579,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_fpmr(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
 	}
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-- 
2.39.2


