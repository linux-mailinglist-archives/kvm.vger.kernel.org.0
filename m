Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47959667F21
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbjALT16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbjALT1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:27:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC3632199
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0460B81FF6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03EC433D2;
        Thu, 12 Jan 2023 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551283;
        bh=VcE5R6SmkNiedouhMzGZSI0/6/cU30SgVaBgzhk/R6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbcVL4forIydBURuGZpe1zlPPispwaBO1FWAaX4d3xtSjHknf5sReruwSQt2zaEbI
         ItPmadsDEia9UTMzaH9h67PjPL1A5eO6j55T5Zt71LuOBxCR/Kh7uzQTrygZ5Wgutf
         E07xmJ5KN6VArJCMDLp+ZeLgL/MVpF4Awp6mDTE6RvPPlTkTzEDvh/cyjpGPyKfMer
         pgv7+8lqrbJSmyJkXIRoD1jg8SSgHdsw1KdCT2NI/t4yDNRXaBPKxPUElknDNXAji1
         NNi3H/mWHMB14646Y20X077kWh02ehTdqzoFsoWDa2oaRgb0nCe7BG8loB1x4Tmjr+
         +M5hgIDYvPz/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG374-001IWu-4J;
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
Subject: [PATCH v7 27/68] KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
Date:   Thu, 12 Jan 2023 19:18:46 +0000
Message-Id: <20230112191927.1814989-28-maz@kernel.org>
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

So far, we never needed to distinguish between registers hidden
from userspace and being hidden from a guest (they are always
either visible to both, or hidden from both).

With NV, we have the ugly case of the EL02 and EL12 registers,
which are only a view on the EL0 and EL1 registers. It makes
absolutely no sense to expose them to userspace, since it
already has the canonical view.

Add a new visibility flag (REG_HIDDEN_USER) and a new helper that
checks for it and REG_HIDDEN when checking whether to expose
a sysreg to userspace. Subsequent patches will make use of it.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c |  6 +++---
 arch/arm64/kvm/sys_regs.h | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 86b8d0c14d26..152b2e52ea47 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3231,7 +3231,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	int ret;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r)
+	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user) {
@@ -3275,7 +3275,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		return -EFAULT;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r)
+	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (sysreg_user_write_ignore(vcpu, r))
@@ -3369,7 +3369,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden(vcpu, rd))
+	if (sysreg_hidden_user(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index e4ebb3a379fd..6b11f2cc7146 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -85,8 +85,9 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
-#define REG_USER_WI		(1 << 2) /* WI from userspace only */
+#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
+#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
+#define REG_USER_WI		(1 << 3) /* WI from userspace only */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -152,6 +153,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
 }
 
+static inline bool sysreg_hidden_user(const struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & (REG_HIDDEN | REG_HIDDEN_USER);
+}
+
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *r)
 {
-- 
2.34.1

