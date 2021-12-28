Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCCF480906
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 13:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhL1MOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 07:14:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhL1MOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 07:14:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6027B811A3
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 12:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FE1C36AE7;
        Tue, 28 Dec 2021 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640693659;
        bh=dC2K7UYn0C5HLYz6aHEjkd2hSiUU/BCOy54X/ouxHuo=;
        h=From:To:Cc:Subject:Date:From;
        b=B16JMu0f3re31lMirqT1+cqjEjfuGoNeME9f3UL12m23z41aEmxIpXQHZzG8Ypl+K
         +7DKSXuGbwzGWWUnT3LdK1NgFnbAx4CkItXJBya/O7ufLwnhj3GAqanQG4n6/TYSLN
         8CRoWszCov3DTtcO9Xy76nDEFegzY0dNai4ggbUsdiUi4piy0EiZf5Pw8m+ZiKZIVm
         wBA3oDEHMYl6iFKXpEJKgXpQjhE34Q7G1e+8BeUF9hD7VYfbITA+i9zNy7/3PaLdMJ
         nhLWK14KBJpp8baWrq2T3nwZ7XcA3F+fSGSQBOD44fDFzvEs9vcJQhrPwLAz3pHu/q
         DevKrEjdmy/7w==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n2BMv-00EiLp-Gj; Tue, 28 Dec 2021 12:14:17 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: selftests: get-reg-list: Add pauth configuration
Date:   Tue, 28 Dec 2021 12:14:14 +0000
Message-Id: <20211228121414.1013250-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The get-reg-list test ignores the Pointer Authentication features,
which is a shame now that we have relatively common HW with this feature.

Define two new configurations (with and without PMU) that exercise the
KVM capabilities.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..f769fc6cd927 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -1014,6 +1014,22 @@ static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
 };
 
+static __u64 pauth_addr_regs[] = {
+	ARM64_SYS_REG(3, 0, 2, 1, 0),	/* APIAKEYLO_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 1, 1),	/* APIAKEYHI_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 1, 2),	/* APIBKEYLO_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 1, 3),	/* APIBKEYHI_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 2, 0),	/* APDAKEYLO_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 2, 1),	/* APDAKEYHI_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 2, 2),	/* APDBKEYLO_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 2, 3)	/* APDBKEYHI_EL1 */
+};
+
+static __u64 pauth_generic_regs[] = {
+	ARM64_SYS_REG(3, 0, 2, 3, 0),	/* APGAKEYLO_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 3, 1),	/* APGAKEYHI_EL1 */
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -1025,6 +1041,21 @@ static __u64 sve_rejects_set[] = {
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
 	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+#define PAUTH_SUBLIST							\
+	{								\
+		.name 		= "pauth_address",			\
+		.capability	= KVM_CAP_ARM_PTRAUTH_ADDRESS,		\
+		.feature	= KVM_ARM_VCPU_PTRAUTH_ADDRESS,		\
+		.regs		= pauth_addr_regs,			\
+		.regs_n		= ARRAY_SIZE(pauth_addr_regs),		\
+	},								\
+	{								\
+		.name 		= "pauth_generic",			\
+		.capability	= KVM_CAP_ARM_PTRAUTH_GENERIC,		\
+		.feature	= KVM_ARM_VCPU_PTRAUTH_GENERIC,		\
+		.regs		= pauth_generic_regs,			\
+		.regs_n		= ARRAY_SIZE(pauth_generic_regs),	\
+	}
 
 static struct vcpu_config vregs_config = {
 	.sublists = {
@@ -1056,11 +1087,30 @@ static struct vcpu_config sve_pmu_config = {
 	{0},
 	},
 };
+static struct vcpu_config pauth_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	PAUTH_SUBLIST,
+	{0},
+	},
+};
+static struct vcpu_config pauth_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	PAUTH_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
 	&sve_config,
 	&sve_pmu_config,
+	&pauth_config,
+	&pauth_pmu_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.30.2

