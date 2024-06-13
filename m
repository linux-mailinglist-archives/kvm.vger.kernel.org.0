Return-Path: <kvm+bounces-19631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 909FD907D61
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2177F282BE6
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ACD413A252;
	Thu, 13 Jun 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UvhE5h5S"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B81494BC
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309938; cv=none; b=BfI1utz4Fn+liMO0oo86qBEgtKJFklbNvrM4xCdpGYAuuIckfX+RBemVCyM7DcyQcPIQndMDGWeWDgLLEG9oz4/oVxT2bjOAI1ypG0rjUEQ2asNAshbquiLsyDJvLXH6gTYfP/4eDOeJQ8ehhnXrn4VzE+t2Hevqr9cNIWQvQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309938; c=relaxed/simple;
	bh=Nd1zR3qVzwfSq3pK/xhfElA+Dvfml9cbHq8wbNH4bDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLQ8hYO9SwHK6YO+EaC/Cfg1z74bRGrHJ55C9CW1ZrpDGX5jbaAsVB/QKSst3XSMj9XNT7IjmXC1GNCWm8a3qcmma/6WgphSjlIZMBbGjUgh2FkJ7KxRoZa1sVMrtwJR+xzSj0MuA8ef3OCgA3GIuLgA4QSMI2IoJOyU5bEMUuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UvhE5h5S; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lurBkmTiXsQRuEPJm1jOCsTlH6E/g+spAtItDlE7qKQ=;
	b=UvhE5h5SJWz4EujALgnmnPx4lqYyt1VLrFDsVqPP3/5xV29rAQ11VHnnRSTJ5jSJrnyHuz
	rCCkMjNP5GZfmambTOqurGiAS6RULZE0cjmn6LqWFiLv4awbszZQwiJQ9GWOiwK3+dWDju
	c2avybFJS+by4np7v7FMf1kiIEWnkqw=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 14/15] KVM: arm64: nv: Add additional trap setup for CPTR_EL2
Date: Thu, 13 Jun 2024 20:17:55 +0000
Message-ID: <20240613201756.3258227-15-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

We need to teach KVM a couple of new tricks. CPTR_EL2 and its
VHE accessor CPACR_EL1 need to be handled specially:

- CPACR_EL1 is trapped on VHE so that we can track the TCPAC
  and TTA bits

- CPTR_EL2.{TCPAC,E0POE} are propagated from L1 to L2

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b0b1935a3626..d30fee61fb17 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -87,11 +87,23 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	if (!vcpu_has_nv(vcpu))
+		goto write;
+
+	/*
+	 * The architecture is a bit crap (what a surprise): an EL2 guest
+	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
+	 * as they are RES0 in the guest's view. To work around it, trap the
+	 * sucker using the very same bit it can't set...
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
+		val |= CPTR_EL2_TCPAC;
+
 	/*
 	 * Layer the guest hypervisor's trap configuration on top of our own if
 	 * we're in a nested context.
 	 */
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+	if (is_hyp_ctxt(vcpu))
 		goto write;
 
 	cptr = vcpu_sanitised_cptr_el2(vcpu);
@@ -115,6 +127,11 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 	if (!(SYS_FIELD_GET(CPACR_ELx, ZEN, cptr) & BIT(0)))
 		val &= ~CPACR_ELx_ZEN;
 
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+		val |= cptr & CPACR_ELx_E0POE;
+
+	val |= cptr & CPTR_EL2_TCPAC;
+
 write:
 	write_sysreg(val, cpacr_el1);
 }
-- 
2.45.2.627.g7a2c4fd464-goog


