Return-Path: <kvm+bounces-58999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87466BA9F13
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4686F1C6099
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28C930CD9D;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkUoQwcr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB23081DB;
	Mon, 29 Sep 2025 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161906; cv=none; b=n+De1pRX521o7d8JC0P1bSI87ZZssZp6OdH8bKWJ0TGH7D8zfzj4P6KZGHCh1pZY6A7owDvN2NyjmBizK6NR93EzOsDzAcKpBpwdrGL8XKqtVlt1cd92vhD3DRqljHSzaccR2Vyr9KAfN0tyEqzOI5znQyj/D90rQnlz3yR+9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161906; c=relaxed/simple;
	bh=vM2LsAfY9nrvp2BkddcX72dJdqZ7gW3wqW7BXtGgiIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o762w5kEU3qvugbbeUWo2Wbi3tqX1oLdGAgWEGRbF9YFMMVaeQDfdDgNta5eLSUNa4eE1LXjVQoLCD0dPJtWnGHVIwwGK+OadEldnw4CyCmfUDESAviDD+yfubLCDrzXgF8DnBTfx//tQ98IZhJ3ejmJHhVeuztdYGN6tHG8jhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkUoQwcr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1147C4CEF4;
	Mon, 29 Sep 2025 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161905;
	bh=vM2LsAfY9nrvp2BkddcX72dJdqZ7gW3wqW7BXtGgiIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkUoQwcrtyBt9lrr7rqDlQ/M6DrrpdxDFoGWd5jlWOiNzlc1U7/a2anrvbOOcHySE
	 TgnOOdEpwuk9vSUDb4UJrWzil4xu69lrJoprxm4nJnbZS3deolPSO6oD6ZNMflIZDv
	 pxEgPWlYo6kk/fijdj6kh2BjRs/yLIId9gt4N4w9fiEIBPeaESIHzre9t5jScpYbSV
	 1qRKOgkHRABQg82eaFoz4RlbjYyJiWtxTvchJcTSHYiqvJND/17GakZjogTPH2WO/d
	 OxQHjxBoql1IScTOVKA/MC0xFYp11iQjAV1RnLwHARZWB4f8iqlZJY1NaizjqQ8Yju
	 /PtQkSrIIGPsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN5-0000000AHqo-1kXi;
	Mon, 29 Sep 2025 16:05:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 01/13] KVM: arm64: Hide CNTHV_*_EL2 from userspace for nVHE guests
Date: Mon, 29 Sep 2025 17:04:45 +0100
Message-ID: <20250929160458.3351788-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we correctly UNDEF any CNTHV_*_EL2 access from the guest
when E2H==0, we still expose these registers to userspace, which
is a bad idea.

Drop the ad-hoc UNDEF injection and switch to a .visibility()
callback which will also hide the register from userspace.

Fixes: 0e45981028550 ("KVM: arm64: timer: Don't adjust the EL2 virtual timer offset")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ee8a7033c85bf..9f2f4e0b042e8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1594,16 +1594,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool access_hv_timer(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
-{
-	if (!vcpu_el2_e2h_is_set(vcpu))
-		return undef_access(vcpu, p, r);
-
-	return access_arch_timer(vcpu, p, r);
-}
-
 static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 				    s64 new, s64 cur)
 {
@@ -2831,6 +2821,16 @@ static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, s1pie_visibility);
 }
 
+static unsigned int cnthv_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd)
+{
+	if (vcpu_has_nv(vcpu) &&
+	    !vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2_E2H0))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static bool access_mdcr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3691,9 +3691,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
 	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
 
-	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_hv_timer },
-	EL2_REG(CNTHV_CTL_EL2, access_hv_timer, reset_val, 0),
-	EL2_REG(CNTHV_CVAL_EL2, access_hv_timer, reset_val, 0),
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer, .visibility = cnthv_visibility },
+	EL2_REG_FILTERED(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0, cnthv_visibility),
+	EL2_REG_FILTERED(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0, cnthv_visibility),
 
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
 
-- 
2.47.3


