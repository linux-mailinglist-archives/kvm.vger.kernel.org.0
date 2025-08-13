Return-Path: <kvm+bounces-54594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B54B2500A
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 18:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 590661AA407C
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 16:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91AE6287510;
	Wed, 13 Aug 2025 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej+BuRtH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF9717C77;
	Wed, 13 Aug 2025 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755103076; cv=none; b=kDozzWWn/Ll67CdsdVrXObWX3Ne9aO7Eh9cf/N1shUMwBMeZB8AYS6oGTxkn/BSMxdQwo8hkFYwPsJsGlPzZ8YbgJC9c40X0odSMHK2XLi6/5iHcXlGSVOFE9ynhOhAItsjH0nUNwdyMLQqbYd30Hi/pKEDbRzvwC1yOk1dis7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755103076; c=relaxed/simple;
	bh=XaTAPeXA/rBryBYJZPO4Z48aKfyT2O49Yl0Pjy0EML8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XhqdNcb3C7syypIep1JCeyl14WlQNF7ub5/hggqrIWxHMBXjsTWtlm1l2x4jX+hFjya2DZTCE8YbgqVHSu18YysdqjCi0kMx5m21HIoggb6Z1o84KMqpZQKe1c7Ub1qm8isfzLnUyBwYS6Q/FJlgpkYji1k4PhYX68UY8Y0jt5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ej+BuRtH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A78EC4CEEB;
	Wed, 13 Aug 2025 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755103076;
	bh=XaTAPeXA/rBryBYJZPO4Z48aKfyT2O49Yl0Pjy0EML8=;
	h=From:To:Cc:Subject:Date:From;
	b=Ej+BuRtHNSaFdrNsXUYWJ13uXDkHRinYP61Vfcdxg6xROgiNgaO+m6Nis3Jsj5nTO
	 JvYhaS0YtU1MIBnFOLff8vYl6xzbRcnf7SHVOcjq/owD2AULvMRAttV6QSCvNDAliS
	 m+SM1zqc6N6MS4SD05emaoFdD/YQ80NGVDHFmJCrQxogLbK9H9jMW6UntumOtd6J3y
	 6PeJRriiwkci9J9CoZUU7KboomxRduZvjBGnNEqEw+sXRyoGpWG7dKw1CIMzhLKqRh
	 hrhyTDrfplE5wcGcnojIFegzm5gTUVAkLJ9iqOslTidAn85sATnZB2GjVgkssoNkHa
	 xFNt/I+kLs4pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1umEU2-0078fx-Sn;
	Wed, 13 Aug 2025 17:37:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
Date: Wed, 13 Aug 2025 17:37:47 +0100
Message-Id: <20250813163747.2591317-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
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

vcoy_write_sys_reg()'s signature is not totally obvious, and it
is rather easy to write something that looks correct, except that...
Oh wait...

Swap addr and FAR_EL2 to restore some sanity in the nested SEA
department.

Fixes: 9aba641b9ec2a ("KVM: arm64: nv: Respect exception routing rules for SEAs")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 90cb4b7ae0ff7..af69c897c2c3a 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2833,7 +2833,7 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 			     iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
 	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, FAR_EL2, addr);
+	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
 
 	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
 		return kvm_inject_nested(vcpu, esr, except_type_serror);
-- 
2.39.2


