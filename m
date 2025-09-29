Return-Path: <kvm+bounces-59011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B098BBA9F2B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3871F1922CB9
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63CC30DD33;
	Mon, 29 Sep 2025 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMPN5496"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209630C608;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161908; cv=none; b=nVKD9VVuaYonOBvPvpKPeZbVZc5xecLfOISUpWLaflmnESDMR7d6T3mbZ7MKLgp41pGnHp2l+72CAG0QJ/Jm2O0WvzM9/nphjY6J2z9pDBtfZxm/pn89M/6ji/mJabxpjvh9Ex/6bd+Py26O51h1Z2pNHFjKcxY4TuAy+UaA82Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161908; c=relaxed/simple;
	bh=kcyjoSnEwVRb40n5xPJ2q3xE6tZqe4Q5DJgl5/ozZd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAx3hJgA9mLjkUHiwj2WFAvCuiqgNl92igFL1CjVhHd5ze1c8l6dahCc+kS8SPVNoHbtm5s6kdJZmL0T2LwGlQBVUXxI7Xc+jhaw9RVS6Puy3nl7AvxoDLSgxzWB0BZDms3fhGwwHY2NXCqDrUoWxU8HvSzK3ra/XS9LbnwdGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMPN5496; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3266BC4CEF7;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161908;
	bh=kcyjoSnEwVRb40n5xPJ2q3xE6tZqe4Q5DJgl5/ozZd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMPN5496p3YhiMHtijNPxGOLjOq/BeECzsOMX83uOZSFONif4iAu7xSOjIreNpFsb
	 Ib+BVm/F/K0IOzOFP/nmylecJGK+VOurBan3s6M5NXbOeej6wOuGHkADLCAnko9FFV
	 +Gm/DM7hatdJFNhkkufk4gMxIWl7T/urCKTUbVOuu7yjWRlBXCz0amsseeOzTzgszQ
	 rLa6KcLVMqHVDh3YvJltTy8mKIUEfZ75kOq1IR61tSWe1C/NmfKWvVbYAZ3STVwP8P
	 1MSHsqYTT9lRwH+f95H5Hc6Ck2SLoPcU04JyZ+XOvEtnRqvvb2Oy9Rb0OyNHAvQCHp
	 9ZGkKaWeeBw5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN8-0000000AHqo-0ziP;
	Mon, 29 Sep 2025 16:05:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 12/13] KVM: arm64: selftests: Add an E2H=0-specific configuration to get_reg_list
Date: Mon, 29 Sep 2025 17:04:56 +0100
Message-ID: <20250929160458.3351788-13-maz@kernel.org>
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

Add yet another configuration, this time dealing E2H=0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/arm64/get-reg-list.c        | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 0a4cfb368512a..7a238755f0728 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -758,6 +758,10 @@ static __u64 el2_regs[] = {
 	SYS_REG(VSESR_EL2),
 };
 
+static __u64 el2_e2h0_regs[] = {
+	/* Empty */
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -792,6 +796,15 @@ static __u64 el2_regs[] = {
 		.regs		= el2_regs,			\
 		.regs_n		= ARRAY_SIZE(el2_regs),		\
 	}
+#define EL2_E2H0_SUBLIST					\
+	EL2_SUBLIST,						\
+	{							\
+		.name 		= "EL2 E2H0",			\
+		.capability	= KVM_CAP_ARM_EL2_E2H0,		\
+		.feature	= KVM_ARM_VCPU_HAS_EL2_E2H0,	\
+		.regs		= el2_e2h0_regs,		\
+		.regs_n		= ARRAY_SIZE(el2_e2h0_regs),	\
+	}
 
 static struct vcpu_reg_list vregs_config = {
 	.sublists = {
@@ -900,6 +913,65 @@ static struct vcpu_reg_list el2_pauth_pmu_config = {
 	},
 };
 
+static struct vcpu_reg_list el2_e2h0_vregs_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	VREGS_SUBLIST,
+	{0},
+	},
+};
+
+static struct vcpu_reg_list el2_e2h0_vregs_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	VREGS_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
+
+static struct vcpu_reg_list el2_e2h0_sve_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	SVE_SUBLIST,
+	{0},
+	},
+};
+
+static struct vcpu_reg_list el2_e2h0_sve_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	SVE_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
+
+static struct vcpu_reg_list el2_e2h0_pauth_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	VREGS_SUBLIST,
+	PAUTH_SUBLIST,
+	{0},
+	},
+};
+
+static struct vcpu_reg_list el2_e2h0_pauth_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	EL2_E2H0_SUBLIST,
+	VREGS_SUBLIST,
+	PAUTH_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
+
 struct vcpu_reg_list *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
@@ -914,5 +986,12 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&el2_sve_pmu_config,
 	&el2_pauth_config,
 	&el2_pauth_pmu_config,
+
+	&el2_e2h0_vregs_config,
+	&el2_e2h0_vregs_pmu_config,
+	&el2_e2h0_sve_config,
+	&el2_e2h0_sve_pmu_config,
+	&el2_e2h0_pauth_config,
+	&el2_e2h0_pauth_pmu_config,
 };
 int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.47.3


