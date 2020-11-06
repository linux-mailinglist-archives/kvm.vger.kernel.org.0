Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237442A99BD
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKFQom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 11:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbgKFQol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 11:44:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C35A122228;
        Fri,  6 Nov 2020 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681079;
        bh=3PNboigeuxEWqj4XsXBqu5wkriCMZ/S88iSRF0K0OKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMTtMC9bm/9D6zaTmuOWl47fGtFfkfgBD2s0+FxKvHUpmsJPV7ffMlTdk0SJkZ5AR
         TaU4H9LVZyWuaZWn3xhAkPat/mYS7ifJX1GFkyv7+QST1dcboG5ogKis9gqvf3YR9b
         lORMLqOJCNqmuoQJSIeABXV0pZRuT/jxJJ4+UZks=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kb4qs-008FYW-0a; Fri, 06 Nov 2020 16:44:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
        dave.martin@arm.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/5] KVM: arm64: Check RAZ visibility in ID register accessors
Date:   Fri,  6 Nov 2020 16:44:15 +0000
Message-Id: <20201106164416.326787-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com, dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

The instruction encodings of ID registers are preallocated. Until an
encoding is assigned a purpose the register is RAZ. KVM's general ID
register accessor functions already support both paths, RAZ or not.
If for each ID register we can determine if it's RAZ or not, then all
ID registers can build on the general functions. The register visibility
function allows us to check whether a register should be completely
hidden or not, extending it to also report when the register should
be RAZ or not allows us to use it for ID registers as well.

Check for RAZ visibility in the ID register accessor functions,
allowing the RAZ case to be handled in a generic way for all system
registers.

The new REG_RAZ flag will be used in a later patch. This patch has
no intended functional change.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201105091022.15373-4-drjones@redhat.com
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++---
 arch/arm64/kvm/sys_regs.h | 10 ++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26a285127620..4ee098abd87c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1151,6 +1151,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	return 0;
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool __access_id_reg(struct kvm_vcpu *vcpu,
@@ -1169,7 +1175,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	return __access_id_reg(vcpu, p, r, false);
+	bool raz = sysreg_visible_as_raz(vcpu, r);
+
+	return __access_id_reg(vcpu, p, r, raz);
 }
 
 static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
@@ -1281,13 +1289,17 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_visible_as_raz(vcpu, rd);
+
+	return __get_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_visible_as_raz(vcpu, rd);
+
+	return __set_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1372,6 +1384,7 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	.access	= access_id_reg,		\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
 }
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 2641b2ee6a91..0f95964339b1 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -60,6 +60,7 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
+#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -119,6 +120,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r) & REG_HIDDEN;
 }
 
+static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_RAZ;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.28.0

