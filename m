Return-Path: <kvm+bounces-28338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A095C99754E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9F91B234D7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FA61E7C16;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9Yece0F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231E1E5720;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500448; cv=none; b=NOm+2SIrbGucKfgDIxrSirdXYtc5/zPOHkPx0gJQveTtRMiRx5HdwibupXm/4Irrr46jLCB1SycuJx8eqLLLY29y7EFq1QbnFiTCD0fZVMJfzaIB2VbnTohQCQCygw9HC3OyPfTLp+FHOWsW4+bWzsbFz4qcoSNX/+yHP3mGgbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500448; c=relaxed/simple;
	bh=2MWftYygg8uIBjl90XXJMB7RiCbzJSCjHPiHWt2IHTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pucDfMkkGQd8NoQWGlK4m1OYzkhjdEJoDm6jaPjY2frYwzQTHU4L0jp+RQ6wO8ZB8DB4hTp0nnWWZedDqzP6Qsn6hzK4mj50Lmu8Q3XzmhouJeandtOo3WhEH7inVFAxH/jxpyTwolux/YEfvGwpWsFICp1Bsz/xaWJSnGmgowA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9Yece0F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE38C4CEC3;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500448;
	bh=2MWftYygg8uIBjl90XXJMB7RiCbzJSCjHPiHWt2IHTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9Yece0FlprB/TjuDIKdFHlBt5jDQ905j2CvG4eJXV2FkG/8UcZoS5TyOsM30uCYj
	 Qw+nWMlWAvpem9LW/B9gg0mH6RbIZFCK6dNq8iZ38HlEZXJ6FkhvMkpPPYSUvnuI8e
	 FmFLjJsH+Xm3FUwCr4tbZyq34hHcitRwv+X5SkVaCouYIq7cMyI9yZt8t0VMSL5K+6
	 uGF6vlDBcpZvZb3J7lCFnJoL5RCm32GacEUJP6dGZPfUxZ+bD4jqQtVpjrXtDBM9cL
	 EPspELq8MNs2is3yVBbf2+jiyzR6Asu7MwAjTCVxhc8DFs3qzYoVF18Sgyab9oBdEE
	 AY/vB/+NZlfew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvS-001wcY-Be;
	Wed, 09 Oct 2024 20:00:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 27/36] KVM: arm64: Add a composite EL2 visibility helper
Date: Wed,  9 Oct 2024 20:00:10 +0100
Message-Id: <20241009190019.3222687-28-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We are starting to have a bunch of visibility helpers checking
for EL2 + something else, and we are going to add more.

Simplify things somehow by introducing a helper that implement
extractly that by taking a visibility helper as a parameter,
and convert the existing ones to that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b5c2662662af9..6c20de8607b2d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2277,16 +2277,18 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
+static unsigned int __el2_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd,
+				     unsigned int (*fn)(const struct kvm_vcpu *,
+							const struct sys_reg_desc *))
+{
+	return el2_visibility(vcpu, rd) ?: fn(vcpu, rd);
+}
+
 static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
 				       const struct sys_reg_desc *rd)
 {
-	unsigned int r;
-
-	r = el2_visibility(vcpu, rd);
-	if (r)
-		return r;
-
-	return sve_visibility(vcpu, rd);
+	return __el2_visibility(vcpu, rd, sve_visibility);
 }
 
 static bool access_zcr_el2(struct kvm_vcpu *vcpu,
@@ -2332,13 +2334,7 @@ static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
 static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 				    const struct sys_reg_desc *rd)
 {
-	unsigned int r;
-
-	r = el2_visibility(vcpu, rd);
-	if (r)
-		return r;
-
-	return tcr2_visibility(vcpu, rd);
+	return __el2_visibility(vcpu, rd, tcr2_visibility);
 }
 
 static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
@@ -2353,13 +2349,7 @@ static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
 static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *rd)
 {
-	unsigned int r;
-
-	r = el2_visibility(vcpu, rd);
-	if (r)
-		return r;
-
-	return s1pie_visibility(vcpu, rd);
+	return __el2_visibility(vcpu, rd, s1pie_visibility);
 }
 
 /*
-- 
2.39.2


