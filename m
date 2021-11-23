Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D8245ADC2
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhKWVEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhKWVE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:28 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A99C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:19 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id l5-20020a056e021aa500b00297fbfb0647so189899ilv.22
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wUzCexKaXqQ03XsQOxjv7f8NBY5L7dr1LK/AA5KCKVI=;
        b=N4kxRBI3igPLyUbZrW9s5rSGAXFsVGDjEkCFd9S+Fu240fBqY/L3uIz5prx5b2504I
         xoIsnrDsGp07KyyGNprN/lfLAM14jDxOLpHRqjHROeX8RRsjRPQrJewYTylZFWxCrMbI
         a/f93jbLyjLGyhg+sUlFDys1hfrLng401WPE/5RD8mC1vAfB9mncSxkWOX6xCz2hlea/
         7hRGO8HmnqyNq0Qp6E0zu+DCDXoFiZZ4shk2+BOX8y3uKGs9cZuNbxGOTR4p1ZkSzpTc
         mUEcs0RIG85ola8ud0G50BxCF2gQnO1c8XAo8q0OvDlf8PPzxGGtYTrnYrgVv54AKos4
         xNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wUzCexKaXqQ03XsQOxjv7f8NBY5L7dr1LK/AA5KCKVI=;
        b=e3oGfA9IwQhv+ED1urxAsmJyMRMbUFdYbszwQ9G+BFN6mQ/SC3sqh4nu7xfEX8Ty4t
         jtHjLnu9/pZwpd+q8chEyqcdJmK2N7W+5JjtyBHdtR1QIE5m6BirYSOo86Vua8WAMa32
         hwSPnnEChOWsHMVQbbVS1hOrLiVe3TgHfZ86bzKI3ihRgql+P0hkYElFcouNdkOCSaT4
         4TbU8i7xs+EKlcuATmSMQYPd3OSWxIPU7XvleztcTtwkHazEXaGokDGczgSNVWzI3C1T
         Y52twQ30Mz0Vrop/apyLdvbZ8NQmpPkFU/n/Rsfg09Q5A3v5f6zW8AWXFySpjgs0vzO0
         O3xA==
X-Gm-Message-State: AOAM530yuL61WHWJJelVqdiSVmWVYKenyDVvFglz4o2k18s9FvF2fLFn
        XtjhzhCpYr4fR719lhfw2n1oexrCHcY=
X-Google-Smtp-Source: ABdhPJxZ6Ef2pIjtj2QD9UsUAaVMm2FHgIlxHqaMG62gt2+RpOlDZ5Kr4E2rZUU8AHbYJ32aB6DYa499PJ4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:224d:: with SMTP id
 m13mr9947094jas.86.1637701279128; Tue, 23 Nov 2021 13:01:19 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:06 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-4-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 3/6] KVM: arm64: Allow guest to set the OSLK bit
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
 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 33 ++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16b3f1a1d468..9fad61a82047 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -129,7 +129,13 @@
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
+#define SYS_OSLAR_OSLK			BIT(0)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+
+#define SYS_OSLSR_OSLK			BIT(1)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7bf350b3d9cd..5dbdb45d6d44 100644
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
@@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if (err)
 		return err;
 
-	if (val != rd->val)
+	if ((val & ~SYS_OSLSR_OSLK) != rd->val)
 		return -EINVAL;
 
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
 	return 0;
 }
 
@@ -1180,10 +1203,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
-static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1463,7 +1482,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
 	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
 		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
@@ -1937,7 +1956,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.34.0.rc2.393.gf8c9666880-goog

