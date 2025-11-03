Return-Path: <kvm+bounces-61891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B70C0C2D51E
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3022E189C79D
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C612328B4E;
	Mon,  3 Nov 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSS4DWT6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2633271F7;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188934; cv=none; b=XzcmuW/DIrFyunm1RVuW2FiJssUn/P3mYYRUaXh/ouxAm7KW/M/ALJvJXf35H9bNG1fefvhlspFOtBjMiQKfAmZm1i70cF6T52Hy778iVe45Y0S6s4ieE1YDJh6w6nEMVa7tP4DcU8hvXoTDmR2R19T1l3KpBpxnIk+7gNQ/Wr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188934; c=relaxed/simple;
	bh=MuJA4k4s9ChXN15wYrgJFMzwPZmjn6xR8Dy9RWxkAUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfyI8AGHbsI8beKuPWztXzWpTWyMiww6Y4vEVYbb0HrF6mqDkI6gSo2YW6tSFiLCpidyPimaY4JGg3xP+Tk0pYsc7GQP5G6wcD5Yx59jNZsxKD6C78Htcqsh4Ki4OHaMwoIwhypyyvQ+cmYYDRl73IWvFTioVaqPugDpCEmEvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSS4DWT6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECD1C113D0;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188934;
	bh=MuJA4k4s9ChXN15wYrgJFMzwPZmjn6xR8Dy9RWxkAUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSS4DWT62OFqJq8AHhaUXmtBWD9TYN88Ryj/ul1/K1dkqPFXpbpfjHGKUI8luNxFT
	 yCfF0YdVTQTtooFSugkjvJWu3DYi7BcjcjuaYrxZpgckegzrkIQllphD3LBvWwvHVG
	 ot2B16De9rq6M7UE7K3bnVy6BOryAp+Ds7xSydeHCGTOB/5e6XH337SE6NqFXnSKMX
	 ATS+5aBd1N/m24ejuBpiQKPjQcmy7f2pmoeqzv+UHxjuxsUBKVFdJ9his18iLaMv3m
	 mxDRffqu16jRnwBSOK4fBDicOfGeor4tCpynnCY8J5H/yrpaGJapxZX5IMVDYD6eRn
	 iIhU+37KQwsSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq8-000000021VN-1Tgn;
	Mon, 03 Nov 2025 16:55:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 32/33] KVM: arm64: GICv2: Always trap GICV_DIR register
Date: Mon,  3 Nov 2025 16:55:16 +0000
Message-ID: <20251103165517.2960148-33-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we can't decide to trap the DIR register on a per-vcpu basis,
always trap the second page of the GIC CPU interface. Yes, this is
costly. On the bright side, no sane SW should use EOImode==1 on
GICv2...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 4 ++++
 arch/arm64/kvm/vgic/vgic-v2.c            | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 78579b31a4205..5fd99763b54de 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -63,6 +63,10 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 	}
 
+	/* Handle deactivation as a normal exit */
+	if ((fault_ipa - vgic->vgic_cpu_base) >= GIC_CPU_DEACTIVATE)
+		return 0;
+
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
 	addr  = kvm_vgic_global_state.vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 5ab29c6755ade..37efffefdb710 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -485,7 +485,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
-					    KVM_VGIC_V2_CPU_SIZE, true);
+					    KVM_VGIC_V2_CPU_SIZE - SZ_4K, true);
 		if (ret) {
 			kvm_err("Unable to remap VGIC CPU to VCPU\n");
 			return ret;
-- 
2.47.3


