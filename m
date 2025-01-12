Return-Path: <kvm+bounces-35244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9045A0AB27
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2A3A3A71F3
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCEF1C5F01;
	Sun, 12 Jan 2025 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nn7phORi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6721C3BF8;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701733; cv=none; b=IL7WE6CNYDxHoXs7JCQDoRkos5wlRp66SbKBukaMPlijsXtDPUmkb44T5Xt6i3+eKoZzwtgKJTzLAWOc2JH5F0QiyYI8mNV84BijcB4psvHAe5WeD2RDej1vBmj7IJ0jMmwanUC8ulc/QOOV8ufez29GGAYIU6adzciNOYM0/RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701733; c=relaxed/simple;
	bh=yZevPphbLIaRcs4edJZitg1YrBi5XxHxu0Vy608/eXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JV3p7K33h0HfboN/N4+l+IngzD95Tfw3sXiHwtCJu0fVmf96knSY7bR7+j3GOlR86/XmhZFJCWGMNrb4ExxJvMaFTTj8MzGt6qwfoDJxmXiEaLyhqIuEwnQ1CGPTj0QYJHbHQrkcTWR9YNPVpsMFQp0RJNVk2Maj1MlpU+0EV4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nn7phORi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5217DC4CEE6;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701733;
	bh=yZevPphbLIaRcs4edJZitg1YrBi5XxHxu0Vy608/eXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nn7phORi2D2cdJrrCJ+J6XtT2kCIx/ox4PbjewvjK1uRkcpBRd+9/2hI4lyE5DBD+
	 hF0+YtYEPlfkOlmag5yRgNE/Ub2KZ5XUaJuFcZZzlBnZDg0RLhLVufnupE2OsIv9wV
	 a05ymBZlYer07/uisCAd3hhfg5/sqywBiTEFpHO55hcC1A1FxPy0o/XL/zKvwXfEii
	 EbY1PJWHlINaQG5K0PE/YJLNHQGeCtf3i5LESOzrp2o8/KqNkVW65CBcf+qm43e3xA
	 y9mnaXMCLa6filTVH6z8oGjzbKmWTXRaZnfaIw7KmDHF1+x7ivyDw+Ld7j2RnXNkb1
	 /R/FWHJ37ZM7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SF-00BNxR-Et;
	Sun, 12 Jan 2025 17:08:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 12/17] KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting
Date: Sun, 12 Jan 2025 17:08:40 +0000
Message-Id: <20250112170845.1181891-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Jintack Lim <jintack.lim@linaro.org>

Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
they are not coming from the virtual EL2 and virtual HCR_EL2.TWx is set.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++++++
 arch/arm64/kvm/handle_exit.c         |  6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c9..5d2af20f75890 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -281,6 +281,19 @@ static __always_inline u64 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline bool guest_hyp_wfx_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
+	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return false;
+
+	return ((is_wfe && (hcr_el2 & HCR_TWE)) ||
+		(!is_wfe && (hcr_el2 & HCR_TWI)));
+}
+
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9ed..206eb6698db70 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -129,8 +129,12 @@ static int kvm_handle_fpasimd(struct kvm_vcpu *vcpu)
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
 
-	if (esr & ESR_ELx_WFx_ISS_WFE) {
+	if (guest_hyp_wfx_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	if (is_wfe) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 	} else {
-- 
2.39.2


