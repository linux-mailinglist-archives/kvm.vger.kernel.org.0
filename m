Return-Path: <kvm+bounces-62459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB30C4443A
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB8FC3B40E4
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3470310645;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhL+Hu91"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A3730FC0F;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708599; cv=none; b=IPlBMfGyiphGlbExFypdvNhMa/mucZccRJPMZSCmi8sslxfzMRIZy+0slvXzfFaczLuh+fcxb0Jk5xSFcqbh7kyF9dwl3eCIpstoep8VGepMy9CkGzMBtzUMM/qauniCB1z/v7ga2qre09PC/TAi2T0+QGPcgY7tmXcChQuoMEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708599; c=relaxed/simple;
	bh=uWaIZt7QL7AACVK5FkurBms+yakL81yrNHL11N09IJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATYxEZGgz3BQO6fa4YaFZATaMv+oVDEFjXXtT4CGEGIUYvVR6xBwn1QjHsD/BB4QkUIbrnspT4a+oqPCFD+EBYonmCk9oEUJ0Bn4lpx+eNwhklJeH04kgYFgbMaYYG47S3bM2sjilRm334FaZy81Jj3SHbeeA/+vKhmQuWii72w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhL+Hu91; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E96C4CEF8;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708598;
	bh=uWaIZt7QL7AACVK5FkurBms+yakL81yrNHL11N09IJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhL+Hu91qCoYiuqLDWpGrQXRUUSpufSblByDc/MI3yA42qwh97H74j6lkVGghmMef
	 OyImshEx4aaWOKVDSq+7w5oboo5CUjCdmJ++ik1QKofYBZPFHllIV89Ga8x2040rll
	 RP4v68BSamaleQDOB55tIGC531lhY6Us0hUWYayBvxR1KInwbKs52KvWpz1xxUIpcl
	 0p+IfFAd3BHKdGvSnzsYaYQvTMZFJhyqb2fHksWvtfaF/5f7AtDGHpNBVirEi0Ym3m
	 hzGLJW00R1PTs08bDNJBXRASUjx01LnKAhJFshhNGiZV08KbrPQcr0nkaol6PF4/+L
	 hPhZpfDEyvqRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91o-00000003exw-2iQC;
	Sun, 09 Nov 2025 17:16:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 35/45] KVM: arm64: GICv2: Always trap GICV_DIR register
Date: Sun,  9 Nov 2025 17:16:09 +0000
Message-ID: <20251109171619.1507205-36-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
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
index bc52d44a573d5..585491fbda807 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -457,7 +457,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
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


