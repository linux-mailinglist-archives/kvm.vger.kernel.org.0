Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F8667F30
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjALT3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbjALT2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4ED3D5D4
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C867BB82016
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DE7C433EF;
        Thu, 12 Jan 2023 19:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551335;
        bh=QEG88zyfm5SRLWmB48pP3vUC2BcSBXgnShDy7zw2sM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3WpODTxdJ5NFN3RsvWeydnjW0fH/WEoz+JL0HxVK+yAKojm7VhutCLu5P6us1naW
         EONW3S03LChZdaws5geZ/h9Flj5eZGiNOpWYmmGdEl3S84+o9cMQjlY4T4orzQFNG5
         WjNLI0bDgquXrqPYaP8GdZNuHcrMLvNPz5J9TXXpKRZjYeJMpQj8sisdxqZqLA8HwK
         j7FRL9uTh55/JbLBRrR7eExw50PQvdVBk+MJ7hfHQcP8gFs2XKOFTF7hsRxvJ2SPpW
         Lb0iniPJmY8pvgY6XKmVTIIpM9CEKvBnnSHTfPmIdnMIS9WobFVAKF+mmLn1WY34BU
         GoKRGf+ZrQOyg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG374-001IWu-CV;
        Thu, 12 Jan 2023 19:19:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 28/68] KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
Date:   Thu, 12 Jan 2023 19:18:47 +0000
Message-Id: <20230112191927.1814989-29-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: EL12_REG(), register visibility]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 152b2e52ea47..f010e7073896 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1703,6 +1703,26 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -2282,6 +2302,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.34.1

