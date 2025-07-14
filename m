Return-Path: <kvm+bounces-52329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 596B1B03EA0
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6329417E0FC
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1DF2505A5;
	Mon, 14 Jul 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGIxjV1V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534524DD00;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496006; cv=none; b=ic1tINqjnEyTBXAgV+YRg8wseHfKqD2iT4V8GbmEVY5lLsxMqfbQLiG+1cA4kINVYqH5ACMGV3GUKcs6ISE594vx1VI+D2B2E0KxpnDk+Nx/oTYh+f6moxRzjZdz2JMGDxBWQsaZqtx9fUYM/IRmJfbHtcWrSi3pJcXdQG23aCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496006; c=relaxed/simple;
	bh=Maovpa248I7CBxH/PejkKeRqHw0v3C94HDRXqdy2Gn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H/DCLpvpGc57K5aIxYj+rSUVyupKbu526VaQMB+hUqm1QNEEROALag8KiUT8P0JsbvE4n47cywuXoxZfKbdC37NhBsYowUGHsl4DLgWFWv8zsb4xQocn242H9iZDdiHWawaZnXDndDc99ZhzJrhvwursGl39jHei93WBIsJzkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGIxjV1V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347F8C4CEF8;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496004;
	bh=Maovpa248I7CBxH/PejkKeRqHw0v3C94HDRXqdy2Gn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGIxjV1VLwuQ9bjvR8ejkKTI4UlvucRA1/U7qw4hnYK8IkMLAjMAMIZrHQJxC64X0
	 1aOSGT+EYPZqXEf3DswiINdBCJjK0mA5Dqbkpa7nTNUiK3X4FfziMc15GESZE29V4U
	 1pgP6Nh8XT/AJsChmuTfvc53QLmUlPyiCo1OnCtWFPJ6eSDMUO6gtlWOt7IDcVmCbz
	 hrcSd5sLm7MxBf5mp5yIF0pn6sdS/HI5sAziFo3rIz/gryJ7Hz/ZmmX5YibJFGzAoj
	 9yX4gUjLt1bw0ioTew/zebE5nBrXAPaRzpM4mq8B4bTrc525TqOnTN3okaZvNc+iqo
	 C6vtgwqe6KkGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-D3;
	Mon, 14 Jul 2025 13:26:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 04/11] KVM: arm64: Define helper for ICH_VTR_EL2
Date: Mon, 14 Jul 2025 13:26:27 +0100
Message-Id: <20250714122634.3334816-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Move the computation of the ICH_VTR_EL2 value to a common location,
so that it can be reused by the save/restore code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c  |  6 +-----
 arch/arm64/kvm/vgic/vgic.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6981c1b34c2c4..6763910fdf1f3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2521,11 +2521,7 @@ static bool access_gic_vtr(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = kvm_vgic_global_state.ich_vtr_el2;
-	p->regval &= ~(ICH_VTR_EL2_DVIM 	|
-		       ICH_VTR_EL2_A3V		|
-		       ICH_VTR_EL2_IDbits);
-	p->regval |= ICH_VTR_EL2_nV4;
+	p->regval = kvm_get_guest_vtr_el2();
 
 	return true;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index af4bf80b785c3..67233fa04e709 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -66,6 +66,21 @@
 
 #define KVM_ICC_SRE_EL2		(ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |	\
 				 ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB)
+#define KVM_ICH_VTR_EL2_RES0	(ICH_VTR_EL2_DVIM 	|	\
+				 ICH_VTR_EL2_A3V	|	\
+				 ICH_VTR_EL2_IDbits)
+#define KVM_ICH_VTR_EL2_RES1	ICH_VTR_EL2_nV4
+
+static inline u64 kvm_get_guest_vtr_el2(void)
+{
+	u64 vtr;
+
+	vtr  = kvm_vgic_global_state.ich_vtr_el2;
+	vtr &= ~KVM_ICH_VTR_EL2_RES0;
+	vtr |= KVM_ICH_VTR_EL2_RES1;
+
+	return vtr;
+}
 
 /*
  * As per Documentation/virt/kvm/devices/arm-vgic-its.rst,
-- 
2.39.2


