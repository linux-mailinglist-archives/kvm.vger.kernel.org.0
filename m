Return-Path: <kvm+bounces-52323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BEAB03E9A
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FBE517DFA2
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CFE24DCEB;
	Mon, 14 Jul 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKTTrUJj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14513248F4C;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496005; cv=none; b=r1Dg/8tYRgwKmoBy351g9oEb+PViPRsGh9nk8S6rYuQBAWT/J20E7catgK7OaNyhyMm5T0dsvOppbj5LusfMyR5rGeaRxRbxe3oAeaCRSbcqg2xkvoRlrOaKQKFTsJqXyAVMb58g3O3NaoGO1C7EYzYqVGMrotZpyHkFELnTb34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496005; c=relaxed/simple;
	bh=wtfqoXcRMslLsoh24WJYRV7azLDNEc1yXs96hSCaaMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fe77KOa2Z32IdxgUWok/f15VUTu4DtK5YXcE9Ypr0D2vLVgt9eIZyq2EAquCBJ2WPO/WRy7exVR9jvAYGo0wl32Zw78dXfzyUZYpgmC2kNdk9mThsj1i2ucnT5O13HlR5yd1M9eodgr7EWijy0+kA4D7jnfXNm59ghtkZ3RabFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKTTrUJj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A49C4CEF6;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496005;
	bh=wtfqoXcRMslLsoh24WJYRV7azLDNEc1yXs96hSCaaMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKTTrUJjleWuCKQxhY82WEA2H3wk5XYt0Tn5lCHiNnl6tNaqGsbKYgthYg73lnn4c
	 JjJ5EiNpgpAg7fgQpaIUsxVdhyU/4ldbaPdPPcaLor54c30YWPwAHivlZlskopTBJn
	 TcfNE7IwSrBTT9Ag52uX953KiRKekS3eaGnGQN7FoCsc4yJs/lxQPBU4eTa9041k69
	 /T9Yir8HncyhvmX/ZSEo9jPqrMDyKB6VNnV+qVIN8AqRnuXNsi0oiNGYghdA+Xwxds
	 Bfj7Y2F6ryqEr1lkrdoDjwrUF+R+WZ+rrPOX+T/0mx/VeqWHegQ8pMy0pwMsa1IYO9
	 LPVg5TB0WJ1WA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGZ-00FW7V-6A;
	Mon, 14 Jul 2025 13:26:43 +0100
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
Subject: [PATCH 08/11] KVM: arm64: Advertise FGT2 registers to userspace
Date: Mon, 14 Jul 2025 13:26:31 +0100
Message-Id: <20250714122634.3334816-9-maz@kernel.org>
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

While a guest is able to use the FEAT_FGT2 registers, we're missing
them being exposed to userspace. Add them to the (very long) list.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b441049368c7e..554c7145ec1cd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2592,6 +2592,16 @@ static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, tcr2_visibility);
 }
 
+static unsigned int fgt2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	if (el2_visibility(vcpu, rd) == 0 &&
+	    kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, FGT, FGT2))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static unsigned int fgt_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
 {
@@ -3341,9 +3351,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 vncr_el2_visibility),
 
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
+	EL2_REG_VNCR_FILT(HDFGRTR2_EL2, fgt2_visibility),
+	EL2_REG_VNCR_FILT(HDFGWTR2_EL2, fgt2_visibility),
+	EL2_REG_VNCR_FILT(HFGRTR2_EL2, fgt2_visibility),
+	EL2_REG_VNCR_FILT(HFGWTR2_EL2, fgt2_visibility),
 	EL2_REG_VNCR_FILT(HDFGRTR_EL2, fgt_visibility),
 	EL2_REG_VNCR_FILT(HDFGWTR_EL2, fgt_visibility),
 	EL2_REG_VNCR_FILT(HAFGRTR_EL2, fgt_visibility),
+	EL2_REG_VNCR_FILT(HFGITR2_EL2, fgt2_visibility),
 	EL2_REG_REDIR(SPSR_EL2, reset_val, 0),
 	EL2_REG_REDIR(ELR_EL2, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
-- 
2.39.2


