Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A84A8A5C
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352995AbiBCRmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352983AbiBCRmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:06 -0500
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AC8C061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:06 -0800 (PST)
Received: by mail-oo1-xc49.google.com with SMTP id e14-20020a056820060e00b002edda9f237bso1994462oow.22
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4r0SOCWPt5wKx9CF8jZGU5LRHrjPyjKnyg/twxUQ99U=;
        b=WGfV40wvKZIU47t0pOoO5Ect/ooh/k+M7Cw6D4v4PpUlSOKP2FwOHEGVYONx6nGhFu
         mDHr/OM6Rdc09lcwS2cWOiwbvKPWoiF9BSba/1uh3PQsRUM5nqWX3LDzBHUaCCjDuWQ1
         YNAAigy48uvL8v1HAa9CT/S0GHAyWUMgmlOORwpinqt4djULKhls70VGihjrC8KkFRkQ
         UFAlTt0N368uTzsFGbVHTfwtLm0EZ8H4nyC1zZa9eKBQlQQnBFxdaih58yPTHd60dMj2
         RfIhwE0I/CnkSytY9p6WYOmRVlI27AbhdjTyNO/zP9PXDu7iigNQo7IsNzAZQudlGRur
         OMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4r0SOCWPt5wKx9CF8jZGU5LRHrjPyjKnyg/twxUQ99U=;
        b=8LQD0Y3DYnFo3wnyVPJruZpi2RsRJbUmfI1JBbBK4DeSRvfGNB0/GjaKdilNU2ZC5r
         7gG00OgI/RKe+QIJBS9URgMMyc72t4oQccYLZrht9m7Ac+YKMZvigQLf9qgSjL8ZDlm1
         26Zcv/eSV3IxfcbMUYoJR1Hy7rKOa9XpK90AutUeYFKiMjv6lPRoqHw+zlmUKT7Lk8IE
         wAv+dwkOv2nYfrT9Zz/0oVIomdWRiE9Hr6rIMV7QFiHwi2q4Oobe8Y4QjspeURfAEZUP
         C2WuJ9IDJ73TKskFM3hV7GgmWdrnJVAzLH7znNv8or289VhUlxDjAzgRyzL9Pntz9Kla
         vqbg==
X-Gm-Message-State: AOAM533HwrncDJ8m4Jy/PjevG6J2E/VdaC6qGHnJ3CAiNAGyLsStriiL
        gX92m5KB7ERDG5Rw7ab5Tbxeytc/fx4=
X-Google-Smtp-Source: ABdhPJxrLATr32R3AP4ZJY+RhNzt4B+T3nXZBmmd/mTtPyPFp/J8N73If4L4WfmS23RqXFjtJKk7h1BtLA0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:57c6:: with SMTP id q6mr19955651oti.328.1643910126087;
 Thu, 03 Feb 2022 09:42:06 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:56 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-4-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 3/6] KVM: arm64: Allow guest to set the OSLK bit
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow writes to OSLAR and forward the OSLK bit to OSLSR. Do nothing with
the value for now.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/sys_regs.c       | 37 ++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index abc85eaa453d..906a3550fc50 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -128,12 +128,15 @@
 #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
+
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+#define SYS_OSLAR_OSLK			BIT(0)
 
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
 #define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
 #define SYS_OSLSR_OSLM_NI		0
 #define SYS_OSLSR_OSLM_IMPLEMENTED	BIT(3)
+#define SYS_OSLSR_OSLK			BIT(1)
 
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b8286c31e01c..b0d7240ef49f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,6 +44,10 @@
  * 64bit interface.
  */
 
+static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
+static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
+static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
+
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 	return trap_raz_wi(vcpu, p, r);
 }
 
+static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 oslsr;
+
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p, r);
+
+	/* Forward the OSLK bit to OSLSR */
+	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
+	if (p->regval & SYS_OSLAR_OSLK)
+		oslsr |= SYS_OSLSR_OSLK;
+
+	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
+	return true;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -309,9 +331,14 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if (err)
 		return err;
 
-	if (val != rd->val)
+	/*
+	 * The only modifiable bit is the OSLK bit. Refuse the write if
+	 * userspace attempts to change any other bit in the register.
+	 */
+	if ((val ^ rd->val) & ~SYS_OSLSR_OSLK)
 		return -EINVAL;
 
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
 	return 0;
 }
 
@@ -1180,10 +1207,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
-static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1463,7 +1486,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
 	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1,
 		SYS_OSLSR_OSLM_IMPLEMENTED, .set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
@@ -1937,7 +1960,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.35.0.263.gb82422642f-goog

