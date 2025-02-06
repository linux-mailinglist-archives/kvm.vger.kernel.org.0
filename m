Return-Path: <kvm+bounces-37495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F923A2ACFC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6617169C1D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353CF4C8E;
	Thu,  6 Feb 2025 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkgFik/R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4625F232360;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856982; cv=none; b=s9VHIutI3RQehX18EvfhSZk0KS7ewiOWNKTEyT1p1AFUxPmP9A2daRNW96dUqGLE2KxHTI6r04lJavtG6awSRchovf5JOSrxhxnOWK71681ZyDoEpDdl5R0srsZZ4W0BR5A9Sm5NVkbG/VupA4Tr9RXTigRySSOua8bqwO6BYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856982; c=relaxed/simple;
	bh=kJD6aMoTO7I76BGZFNoXThdgd5zqwB3hMKG+1tg5hBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jAr/8r6KTgk2uL3DPs1Bh3kPHbpsqyOmGgvMt3uUmvANprGLZ1vyhqOVtv+isEDn5A4T8XX3oiXd9tF7dwBWzG+8u2Mn2IQm7kJoZVNVNqKzZf3eEF1wk0GPVd5frjGiT6WdmyGkN9u/y0PVoJvEaV8D+rWqkx+qn6moZvqljKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkgFik/R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0C5C4CEE5;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856981;
	bh=kJD6aMoTO7I76BGZFNoXThdgd5zqwB3hMKG+1tg5hBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkgFik/RKI89TcGLfUavb6ww03+/l/5gEvBAPfK6F9NCAszRg1DJmv5GulrcJKS42
	 ECiAcxkGdtMTZlgPWgJu8ULz6JV1HVWkl4ewhwj0lShsh5qwcP6A/YNN054DI6zjjO
	 C3HX96gtHt1pGuSCyGtbP6IVT1RzFJK705Yw+nsuOIloq0KUy5wAkNNl6tV4PoEyCr
	 TDYd1ErHsHKrG3dFamfnVIB6nYty5ApkiwJiuvACw6i3FSD96mOMdecn2s74t2U1Jx
	 FNfWeIKXnUpHuHmUihpLYWZQ2+zw8BtCnKesCZr8f6XXhunCMVpNaij3HxsHsS2Ket
	 URcZlKlmbNICQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48J-001BOX-Sa;
	Thu, 06 Feb 2025 15:49:39 +0000
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
Subject: [PATCH v3 04/16] KVM: arm64: nv: Load timer before the GIC
Date: Thu,  6 Feb 2025 15:49:13 +0000
Message-Id: <20250206154925.1109065-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
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

In order for vgic_v3_load_nested to be able to observe which timer
interrupts have the HW bit set for the current context, the timers
must have been loaded in the new mode and the right timer mapped
to their corresponding HW IRQs.

At the moment, we load the GIC first, meaning that timer interrupts
injected to an L2 guest will never have the HW bit set (we see the
old configuration).

Swapping the two loads solves this particular problem.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 646e806c6ca69..f3ffd8a6aebe2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -576,8 +576,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 nommu:
 	vcpu->cpu = cpu;
 
-	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
-- 
2.39.2


