Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1557E49F939
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348450AbiA1MUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55710 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348443AbiA1MUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2829B82569
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9DFC340EC;
        Fri, 28 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372410;
        bh=bZqI580P2IHiNArMHEy4+BGpKIlBWxGj6oBL43KinD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDGHHzANGOoiVH3tYR0m2YWPVVDQsSJdmq30PxxLqT3B6kkf5JKajG1x/COiXUKM3
         wbj7TWKRHvDuNVXBjGHdkgj6rckS1r0SN0zz9eQKHcmfy4sD8jZ+aJmnxZXIEhdqU1
         X0y5q6dexCwFWh+kWsdhc2jho+2pzdsOz+PswC86kXoEWMoN8psyq+DRvZ8J8gS9Pl
         ZBGnFqxDIAQijoRnJRZSnaUrAHHdmfAcUIJYGo93htYce4/Xb2ku8hK2wsoTlYsCaF
         pdMljfhDOpJ8Mb3ixXg4rksIzgSD3NTzxMeVJ9QzLGFYkgmQE9qPca4/alWOQ2vNYS
         xL+lJlDnP8BHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE7-003njR-Oz; Fri, 28 Jan 2022 12:19:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 28/64] KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
Date:   Fri, 28 Jan 2022 12:18:36 +0000
Message-Id: <20220128121912.509006-29-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
trap to EL2. Handle those traps just like we do for EL1 registers.

One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
bit.  Therefore, add a handler for it and don't treat it as a
non-trap-registers when preparing a shadow context.

These registers, being only a view on their EL1 counterpart, are
permanently hidden from userspace.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: EL12_REG(), register visibility]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0c9bbe5eee5e..697bf0bca550 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1634,6 +1634,26 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+/*
+ * EL{0,1}2 registers are the EL2 view on an EL0 or EL1 register when
+ * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
+ * handling traps. Given that, they are always hidden from userspace.
+ */
+static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	return REG_HIDDEN_USER;
+}
+
+#define EL12_REG(name, acc, rst, v) {		\
+	SYS_DESC(SYS_##name##_EL12),		\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name##_EL1,			\
+	.val = v,				\
+	.visibility = elx2_visibility,		\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -2194,6 +2214,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
+	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
+	EL12_REG(CPACR, access_rw, reset_val, 0),
+	EL12_REG(TTBR0, access_vm_reg, reset_unknown, 0),
+	EL12_REG(TTBR1, access_vm_reg, reset_unknown, 0),
+	EL12_REG(TCR, access_vm_reg, reset_val, 0),
+	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
+	{ SYS_DESC(SYS_ELR_EL12), access_elr},
+	EL12_REG(AFSR0, access_vm_reg, reset_unknown, 0),
+	EL12_REG(AFSR1, access_vm_reg, reset_unknown, 0),
+	EL12_REG(ESR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(FAR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(MAIR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(AMAIR, access_vm_reg, reset_amair_el1, 0),
+	EL12_REG(VBAR, access_rw, reset_val, 0),
+	EL12_REG(CONTEXTIDR, access_vm_reg, reset_val, 0),
+	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
+
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
-- 
2.30.2

