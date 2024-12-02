Return-Path: <kvm+bounces-32835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AB99E0B7F
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D73AB831C8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B9A1DE2A6;
	Mon,  2 Dec 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqcITScS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608751DB922;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160139; cv=none; b=lQiEnZCHGqnLCCWfO0N5AOnTGxh7GScxXXg8mwrlTqtPZnqsPcrUhh0qChJtD/xi4xguBQKymVet8nNn81dBRzABZUcC89MG4NLtple7IvvEiUvm1LAdQtPeM2sjsCCMdAmM9MlTEEe0va8HRPuEnJhk22RA/SiukWDkd/bWTAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160139; c=relaxed/simple;
	bh=d0OVGALV9EL3RmlbVg9qcHbPiwRgVMx9tdZ7QRWENWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y9lshVQX+dOFykrHy2cuFl4bjHy5N8s8uuhQzNBMgzoDMtxY/Q+/V4/YJ14MblxjSmJ0nw3MhXQVRBsdWnZoC+6S1/1TKifhj8d/G+AP7PLyMORzuZrj2aPDzN6GkPbgxVr8szQ5dHRp2wF26RdPVp+w8opZCs0RLNTOV8DD6ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqcITScS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CF8C4CED1;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160139;
	bh=d0OVGALV9EL3RmlbVg9qcHbPiwRgVMx9tdZ7QRWENWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqcITScSTDZNbauRSj6PsBCkUBmgF39q2HVjegYcl5mEoRfVD/JGlhsbBcL+uAUyC
	 1Jt3A30Bxy9lcNT9Y52K5UrdT0AYDljZAKyZ6xjo4nt8PC4eCx7PE4Edn/oe1AQP29
	 YPT4Ln8bK91MjC8STyjzRKm55z3qK1Vm8UPTZIzW/pLVd3Ctj/PE3S6R9UUKyQeTC1
	 jIe3sWr4i/DVDD7h34u639ZL60tJyAPuqbX1Abdq0ODLFZd4KGFb2Mm/INaHiVK+II
	 Pg7mIrlhobXLcA/N0bWx/QRSG3PgUy5bydHn23fT+stWBUdl1YJnWBDSHbsgWvy6Rg
	 r9NreX7ehmGJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7l-00HQcf-Hn;
	Mon, 02 Dec 2024 17:22:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 09/11] KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
Date: Mon,  2 Dec 2024 17:21:32 +0000
Message-Id: <20241202172134.384923-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Allow a guest hypervisor to trap accesses to CNT{P,V}CT_EL02 by
propagating these trap bits to the host trap configuration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 2c4499dd63732..f4607c4f68d2e 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -822,6 +822,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	 * Apply the enable bits that the guest hypervisor has requested for
 	 * its own guest. We can only add traps that wouldn't have been set
 	 * above.
+	 * Implementation choices: we do not support NV when E2H=0 in the
+	 * guest, and we don't support configuration where E2H is writable
+	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
+	 * not both). This simplifies the handling of the EL1NV* bits.
 	 */
 	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
 		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
@@ -832,6 +836,9 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 		tpt |= !(val & (CNTHCTL_EL1PCEN << 10));
 		tpc |= !(val & (CNTHCTL_EL1PCTEN << 10));
+
+		tpt02 |= (val & CNTHCTL_EL1NVPCT);
+		tvt02 |= (val & CNTHCTL_EL1NVVCT);
 	}
 
 	/*
-- 
2.39.2


