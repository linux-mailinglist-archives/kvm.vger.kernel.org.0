Return-Path: <kvm+bounces-62448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD2DC4440A
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1413A491E
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5468230DEC1;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjU+4+rZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990730BF52;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708596; cv=none; b=IdzQWZb8PFmVnSrblZZtGxx3IUK9tdIedUg4Wx69o2jv7qrRpinehR+XyNbkKL5sljtvP1uxIah+jwLbLjugLu0qF9xIFzVI3LO9Ns+NNQlXP0bRcfjS+ofXC3zRonhHXhCBqkE1ltqZB0QyjiLT1CnYN3AEx0eOmlxCkhoWQVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708596; c=relaxed/simple;
	bh=CYzmDh+aILcVXNDBixgJ9TUitMasGg2mcGGqo+VCx+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWBaZzCLiIqzOHmfVH8rniG1NOwQF4IE4i8RySTDaV3CKH3Pz0veHtwoCWm5hCcmVUJ02pkvjfVS5e1vMBuWcigt5xZUmvhcgtmlhHga2vKuODQvjfF+G5bYLsB3chXklGd3n5meVwx4XGqPKIm1c2lJOMzi4Eogt9bbn50sPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjU+4+rZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A901C116B1;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708596;
	bh=CYzmDh+aILcVXNDBixgJ9TUitMasGg2mcGGqo+VCx+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjU+4+rZj6Tep2SKHZL1gVMNKyqmb5KTVV02at3ZuKPVQCSUhQZPyMa+9mQjR4wKr
	 JpDiv/cmaQLhktlFwWM97yGHLIiI9V++dBQWrFeeB0UQrCAqChp+V/oHjjA/mAzCWm
	 q0tHXEj8OQ52GWIhdrmoeP9uavp5WxYFF0dpbrp/eRsMCwWi85v8IvbxsASQWk+bM3
	 z3LDCqyAiNfUr3OBMCChsy9ldd03UopASCTtOaEkRysAe9j7GTQ+Rj9EXxqk7PFJqn
	 xfjb4HUyLBI12K2u/8/XQ4wxbKo5HRmUNB2Ta5B01sWqbFFGHmiB6QdPwlTD9NI3Pd
	 gPATqS+KgdpbA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91m-00000003exw-0mUb;
	Sun, 09 Nov 2025 17:16:34 +0000
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
Subject: [PATCH v2 25/45] KVM: arm64: Use MI to detect groups being enabled/disabled
Date: Sun,  9 Nov 2025 17:15:59 +0000
Message-ID: <20251109171619.1507205-26-maz@kernel.org>
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

Add the maintenance interrupt to force an exit when the guest
enables/disables individual groups, so that we can resort the
ap_list accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 18856186be7be..9a2de03f74c30 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -39,6 +39,11 @@ void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu,
 		cpuif->vgic_hcr |= GICH_HCR_LRENPIE;
 	if (irqs_outside_lrs(als))
 		cpuif->vgic_hcr |= GICH_HCR_UIE;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP0_MASK) ?
+		GICH_HCR_VGrp0DIE : GICH_HCR_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP1_MASK) ?
+		GICH_HCR_VGrp1DIE : GICH_HCR_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u32 lr_val)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 5a57f3c299b56..b5cf68bc1ea9f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -36,6 +36,11 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |= ICH_HCR_EL2_vSGIEOICount;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
-- 
2.47.3


