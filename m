Return-Path: <kvm+bounces-63340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EF97AC6322F
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D2B7E4EC550
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612313271E5;
	Mon, 17 Nov 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSg8Bt0B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F46324B2A;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=Boi8BgaUgJWPzZeyRroSOodOwXsCSc4uT1XN9gRKq9tEfTHXUIkKPi8bYzsxjxl9alSXd3w3UciM6ZDlLh4baSSXBorthtTQ0thwlFNfDXRyuTqP4ZRfqBNlgxvO/WhIzSkao+7DFUlMXoU4yomuefxi7yawFBrUt2HpbPzM86Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=/C45AVhwxcbfmGnWQDgEhd+JCA1eBfJ8Dc8LALrDDmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTgeriBG2J58+TyOpy9DZq8jlIp2of3cc9UiRKeTDCCs64YYvB/bvlhndN9oOwc1XpmBnCrnSweCvGtu2sRtlRk5R7z02+mtO7ktOB/wP5LNM//DFM13pc/EIdwjPgW8FiM+n3iaE/SJLtsjE3JUvH4HiYiEhMjEJkWHF/JlQUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSg8Bt0B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4FBC4AF52;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370941;
	bh=/C45AVhwxcbfmGnWQDgEhd+JCA1eBfJ8Dc8LALrDDmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSg8Bt0BqSwHhYjQtoje1u+k2RBy8dQ87yR/Bs4uAaCvTmSbtl2ACGRx5E9bHBZk1
	 ohczO2mg4ZRG0C9QsdyOXYcj27qHjdO0vHnpFsHEue/ciNI9dC2PwtZtggDhaXn/KT
	 tXutSYNAQhvusb040UPOeO129XDuezryOM7foVGY2Qd/WCuWjmTkWk9rt36ElzfS7t
	 tWu8JHmrd3Fpm9A12MaTwKDcbnwfY8YSP+gpC/13+r+bTVIue8t5k64SijX2+FjTL7
	 kRfUJjjuV/FySUEio1qHfDa84XGzEcUIsnAPtthtBpnhRaDVlpBt52l5Ok/Ka1DAda
	 P1q7rxg8j76dg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKk-00000005lB2-32gG;
	Mon, 17 Nov 2025 09:15:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 1/5] KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1 when no vgic is configured
Date: Mon, 17 Nov 2025 09:15:23 +0000
Message-ID: <20251117091527.1119213-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Configuring GICv3 to deal with the lack of GIC in the guest relies
on not setting ICH_HCR_EL2.En in the shadow register, as this is
an indication of the fact that we want to trap all system registers
to report an UNDEF in the guest.

Make sure we leave vgic_hcr untouched in this case.

Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/r/72e1e8b5-e397-4dc5-9cd6-a32b6af3d739@sirena.org.uk
Fixes: 877324a1b5415 ("KVM: arm64: Revamp vgic maintenance interrupt configuration")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 598621b14a30d..1d6dd1b545bdd 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -26,6 +26,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
 	cpuif->vgic_hcr = ICH_HCR_EL2_En;
 
 	if (irqs_pending_outside_lrs(als))
-- 
2.47.3


