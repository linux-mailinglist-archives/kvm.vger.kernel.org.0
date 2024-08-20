Return-Path: <kvm+bounces-24593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B20958395
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9431C21440
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FA018DF77;
	Tue, 20 Aug 2024 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DvLW+ven"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307FB18CC11;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148374; cv=none; b=kkr3SpUk5XYSPSuo4brEUWlI6Vo94beyn9NAgLXo5iAOyUn+acT4LEgz4Q99L2ClVLVjYih6RdwOg/ZAz/pDYHZp9mhTE+yyvIObQCG+HPV2P6FH2bxeCUMUlo5gj/wZ1nVjIwOc1DUHdkdpktPDpupqEapln2uI4bCXOj3iTxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148374; c=relaxed/simple;
	bh=E/nM2POA+NHfwljXrvdH/h3sCeH2WrlMJBrRxe2DE3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c9f5n7VbiSaCE8lS1uSy7hEI0R2sw1gsiyYyidZISIdNq+b7h0OTeiQHXJD/exuuFEVJKWigvkm60e7m2VS5oW00y9/R6NXTsumQ1YlfQEJJENZZW6Vc2PMnAi9uoI8+WcdAw6Gdu1GLtPP/3rEmHYCuYviH0G53LSaN5mKnCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DvLW+ven; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6CDC4AF09;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148374;
	bh=E/nM2POA+NHfwljXrvdH/h3sCeH2WrlMJBrRxe2DE3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvLW+venMugjBN9tE9/DVQaHmIKVBdRPqOvldK1YfJfy+l4W/U4TFGDGL8S/cHK1E
	 5A+aTOX405kRoeL+xYLuVhmJQucnNyTa1+Z2l95BB98Tyd8XFPQVgisV202C6A4O1N
	 rXi/acM8WkXGEjHAEmcNSIVEjH7o3G2321oa+ZESDvgOkB9Wjp/z/S7kp6Bl5g8mxM
	 43FetMu3l98hjdjE4CpPq5SbYosLhYslPFd+KGdMbu2YgHaWnfLHOyLBfKzpmarWCt
	 Tx/IbWoY4DdeU0O0QVWDZtl1ZWiRAPNnVmQB4d62wnrHkWW7mLRpppZjDFZchWKBFA
	 W1R/ZYQvUhBjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLki-005Dk2-3i;
	Tue, 20 Aug 2024 11:06:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 06/12] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest
Date: Tue, 20 Aug 2024 11:03:43 +0100
Message-Id: <20240820100349.3544850-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be consistent, we shouldn't advertise a GICv3 when none
is actually usable by the guest.

Wipe the feature when these conditions apply, and allow the field
to be written from userspace.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bc2d54da3827..7d00d7e359e1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2365,7 +2365,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_MPAM |
 		   ID_AA64PFR0_EL1_SVE |
 		   ID_AA64PFR0_EL1_RAS |
-		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
@@ -4634,6 +4633,11 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
+	if (!kvm_has_gicv3(kvm)) {
+		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
+		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;
+	}
+
 	if (vcpu_has_nv(vcpu)) {
 		int ret = kvm_init_nv_sysregs(kvm);
 		if (ret)
-- 
2.39.2


