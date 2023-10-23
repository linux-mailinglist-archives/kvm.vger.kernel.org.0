Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D757D2F15
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjJWJzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjJWJzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:55:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02F210C2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:54:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEFAC43391;
        Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698054894;
        bh=ztnTZPp6BGevp1hHbXy/2bLRjBS2ZIKkl3Np65vEbmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOOCLIcjVBGAKUhaELCLfGXapIQ3n+kkQj+bEqBpV9M8Onc1AcbBdUGit2ASW9ipw
         Kgh920559E/rhh25XTSwxy/gVPLYZkxgPUtyEP3Mps6DOV5ghShr7aTAcciiV2zIKm
         Tv0v9NrpN+ivXRifENdHRfFJcOIzwipe6VVqzVavFjIdOYMWiU10YC9T7NcewtDfp1
         NimpoiGjfCGHDTI/gvpdZW264kDhxbGK3HNTC7G0nESiSkmQZHRlHMiURnuLJaXAWV
         jPUgPyQY6e1DZxLC9wrkPgSRNYOd1ZgqxpL7Y8AAU5KNt+mkzALO+1LuuKuATiautq
         WhpNdd4QTjsUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qure7-006nPT-Ng;
        Mon, 23 Oct 2023 10:54:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as RAZ/WI
Date:   Mon, 23 Oct 2023 10:54:44 +0100
Message-Id: <20231023095444.1587322-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When trapping accesses from a NV guest that tries to access
SPSR_{irq,abt,und,fiq}, make sure we handle them as RAZ/WI,
as if AArch32 wasn't implemented.

This involves a bit of repainting to make the visibility
handler more generic.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  4 ++++
 arch/arm64/kvm/sys_regs.c       | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4a20a7dc5bc4..5e65f51c10d2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -505,6 +505,10 @@
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
 #define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
+#define SYS_SPSR_irq			sys_reg(3, 4, 4, 3, 0)
+#define SYS_SPSR_abt			sys_reg(3, 4, 4, 3, 1)
+#define SYS_SPSR_und			sys_reg(3, 4, 4, 3, 2)
+#define SYS_SPSR_fiq			sys_reg(3, 4, 4, 3, 3)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
 #define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
 #define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0071ccccaf00..be1ebd2c5ba0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1791,8 +1791,8 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
  * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
  * handling traps. Given that, they are always hidden from userspace.
  */
-static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
-				    const struct sys_reg_desc *rd)
+static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
 {
 	return REG_HIDDEN_USER;
 }
@@ -1803,7 +1803,7 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.reset = rst,				\
 	.reg = name##_EL1,			\
 	.val = v,				\
-	.visibility = elx2_visibility,		\
+	.visibility = hidden_user_visibility,	\
 }
 
 /*
@@ -2387,6 +2387,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
+	/* AArch32 SPSR_* are RES0 if trapped from a NV guest */
+	{ SYS_DESC(SYS_SPSR_irq), .access = trap_raz_wi,
+	  .visibility = hidden_user_visibility },
+	{ SYS_DESC(SYS_SPSR_abt), .access = trap_raz_wi,
+	  .visibility = hidden_user_visibility },
+	{ SYS_DESC(SYS_SPSR_und), .access = trap_raz_wi,
+	  .visibility = hidden_user_visibility },
+	{ SYS_DESC(SYS_SPSR_fiq), .access = trap_raz_wi,
+	  .visibility = hidden_user_visibility },
+
 	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
-- 
2.39.2

