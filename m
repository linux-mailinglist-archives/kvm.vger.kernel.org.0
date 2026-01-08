Return-Path: <kvm+bounces-67432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 388D3D05259
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B78C23749E10
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590592FB616;
	Thu,  8 Jan 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVUsMFRY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35C2DB7B6;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=sLLw2Ennlkw8uTYzY6uKV3aGgtFHLSWOwlyTZg3dNwCrZy7dRphcWnN/csv49GU2GdB30Fade/ZwHV6JNWHP4nXOm509A+73fj737kq0snb40a5ZvjasxYQM0K/PsWjttqtRNwRZxdgUM2qtzZARCHSORyEgzyxK+MNpy7kOsWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=Xj44DQdqV1S1FH+CaQ8UHzwqnVw9PNPNWxqnBoyEVeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/+gHb+yOV6tlT9Q1erUXc30szxhLU2rdDwsVroRDeV8zM0NmL2hpdBcFKLyXIS8Ptgsu503sDvSDZC4BBQ9hY/MqxRhuZgV4qpFr2UmrRttdgtSW6e/G2ENf11VdZs51ejEnIqrg3+20eBPeAnmHEg7SzjdUVAjFqd0TrK78AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVUsMFRY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6DC19423;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893559;
	bh=Xj44DQdqV1S1FH+CaQ8UHzwqnVw9PNPNWxqnBoyEVeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVUsMFRYkph+uER7WXoXMczyseLyTDVw8fPZ9MRccIFRoQ23E2SfziK2peQDgNUv8
	 s7dyFi2m1SzJAE2nuk3pAVssSH/99yGWYZCn9OMcVCJtcXYWmXLO0jDlACSN9tHMK+
	 //iUYbgIDJsJJTl5hp7td1HvsH5McM/QL30I9tTiw2BdHmXuSIIH2XdHt9MQnRyvQs
	 ACETvTRGZPeMPKrfT4YH7NSh3wX6NEaaYyLgapkldMlI9wZKmPuE44iOSoKHE2vdjU
	 NRCi9LG7VFHIQNiZ20jvNrnJqVgZtMDIDiZ+8kp+4Z+MIk86uRnGXz/8rX2MYTb1Ro
	 fRmTpTbp1L4og==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsD-00000000W9F-2zKy;
	Thu, 08 Jan 2026 17:32:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 6/9] KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
Date: Thu,  8 Jan 2026 17:32:30 +0000
Message-ID: <20260108173233.2911955-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
to force GMID_EL1 being trapped. Such trap will be handled by the
FEAT_IDST handling.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a2b14ca2a702b..3de206b494849 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5576,6 +5576,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 
 	if (kvm_has_mte(vcpu->kvm))
 		vcpu->arch.hcr_el2 |= HCR_ATA;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID5;
 
 	/*
 	 * In the absence of FGT, we cannot independently trap TLBI
-- 
2.47.3


