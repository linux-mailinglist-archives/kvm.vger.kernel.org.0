Return-Path: <kvm+bounces-61888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F46C2D518
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D228188F43D
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECAD328629;
	Mon,  3 Nov 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQ62wa2K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89435325724;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188933; cv=none; b=hEaTmF637mkot28LSpsgWHdC2dRkovWyyFWt0Wr6LEQFN3Ie0OiawfUDa9kwWxY4PCtxncUNvieQu3bVMeu0nWXkJlOU6mZhsQsWE5wo0MBq/PE5UyeDy7Vxdi7cj/uYvi0MaMC/0mhg8rTk+BEJ5zIr/bRuL6not5ucQaLgKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188933; c=relaxed/simple;
	bh=SSlfW/+7HWw9rK2mmIk4XCpAis8A8oR5bsAxkFPZ9A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVdLP4f8v+oKnWP52zEDr37ji1oQMDdRC15448289aubb8Yz5uUVFCa/lYXqXqJOpMzfwiT7HquHL5/tnT8jp8U0ju1CEBTpEGvMzAO+QJ4za1YiI83LC2622woWzoilIeTpC7MUiZbxSZ+Erpe5Qe9uE4/Zg/+k+xBNKVWwUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQ62wa2K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656DFC16AAE;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188933;
	bh=SSlfW/+7HWw9rK2mmIk4XCpAis8A8oR5bsAxkFPZ9A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ62wa2KbwIOxfesl8ZakyjIXny3ml4rkrIL/Z2QbERyL9unmCByIJ1m4JBEBWsJF
	 vRoE3NlroXITB5vDTj7tpBmxWEjabpqdE0LqsNcaIfBWwJg/OvyHNl3AHCCi8LZqt7
	 XOUEMzwY1/UY/zcNpxANEwm5xSoinoW59vgnm5aafJafUNCbRoPJ9iL1ljgdN2A6Sn
	 KFfsYZ30LSxH0xHbgIls5K8Pj29jFREmhZVf2zDgkA4gHLEtpruRTOcKYedSq/miO5
	 9uUl7lkwL9zVUaeGbHFUai961h5zROjH57XY0vXPG4Xpu0q2dA1xl6r3O0y/aCpP9I
	 f/0UiUniwqc0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq7-000000021VN-2k1V;
	Mon, 03 Nov 2025 16:55:31 +0000
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
Subject: [PATCH 29/33] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
Date: Mon,  3 Nov 2025 16:55:13 +0000
Message-ID: <20251103165517.2960148-30-maz@kernel.org>
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

Now that we are ready to handle deactivation through ICV_DIR_EL1,
set the trap bit if we have active interrupts outside of the LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 5131a9bfeffb3..f638fd1f95020 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
 	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
+
+	/*
+	 * Note that we set the trap irrespective of EOIMode, as that
+	 * can change behind our back without any warning...
+	 */
+	if (irqs_active_outside_lrs(als))
+		cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
-- 
2.47.3


