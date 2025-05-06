Return-Path: <kvm+bounces-45633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACDDAACB55
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 425313A2703
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE582874E9;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbT1vkHt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3589286D56;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549852; cv=none; b=KqKRhK+9RO+Oc5dHwEoa/RrAUHiF1gAlGl/T/ciMWN/ZSnJc6NFiUkLTsxuRcNdBKw5AY66Er+de4lM/i/G9Ki34UirJ+xOSvQemkO4ArajLYgVL9NQjyTf20oWNCa7+PlRXcvvY/FhSko6MzIHq9DEAQoQcFi/tTapV4P3oHhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549852; c=relaxed/simple;
	bh=4gVu6PuCEYwqR8T4hiE7L+z2SsXJBvzsxceLEkn+bGU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aegpFTGQZx/YR41AHNI21ja8wIsHposgTvm+m1KBrj3Nc1xXdUW8Bp4WEp1YFVWS1LUm2KfqrhDBHODtQSbU8IZWXHFbn2ocvlz6eJwbwY1PoOBmdNYzA7WUqnfu2eT5BUQUyA1xUS/KWK9zqJkCmIm/0Btp0aFeLi+NUPTzv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbT1vkHt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65002C4CEF1;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549852;
	bh=4gVu6PuCEYwqR8T4hiE7L+z2SsXJBvzsxceLEkn+bGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbT1vkHtonjtWVfetsIP4h+6PJL1Sq3gBgSZ+jvaGg5Mwt64UTix2hgBNLe7dp82A
	 L+F2md7wbd8NqONehEXmUlG2qcBZjHHCK3fk6f4wpSDRc3TPXNp6Bi/vYX0OUa+sJr
	 bgKV6t6NT2WKjEvpQB2a8XT0dXZVMSI8Nwnl24c+MOFmG6Bd63YSp7YukHqtRwKqbn
	 qXbF/42PJQsP8EdDf9gM+MFYazU2k2fBQV9vDn+ZR+RZZjchYRnxGIOYCMtZsBcotf
	 K1o3xfYnjT/AvKdREhNjXIaj9Dg8wuoUwlVYaBb04Olj73o+5nJBN9wTML4AFj5Mma
	 of9hmY6BCb4/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOs-00CJkN-Kl;
	Tue, 06 May 2025 17:44:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 20/43] KVM: arm64: Don't treat HCRX_EL2 as a FGT register
Date: Tue,  6 May 2025 17:43:25 +0100
Message-Id: <20250506164348.346001-21-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Treating HCRX_EL2 as yet another FGT register seems excessive, and
gets in a way of further improvements. It is actually simpler to
just be explicit about the masking, so just to that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 3150e42d79341..027d05f308f75 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -261,12 +261,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		u64 hcrx = vcpu->arch.hcrx_el2;
 		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
-			u64 clr = 0, set = 0;
-
-			compute_clr_set(vcpu, HCRX_EL2, clr, set);
-
-			hcrx |= set;
-			hcrx &= ~clr;
+			u64 val = __vcpu_sys_reg(vcpu, HCRX_EL2);
+			hcrx |= val & __HCRX_EL2_MASK;
+			hcrx &= ~(~val & __HCRX_EL2_nMASK);
 		}
 
 		write_sysreg_s(hcrx, SYS_HCRX_EL2);
-- 
2.39.2


