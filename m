Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD4A49F938
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348453AbiA1MUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55668 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348437AbiA1MUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70B8EB82572
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F5CC340E0;
        Fri, 28 Jan 2022 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372408;
        bh=+MtgXcNVbDZI+bNgWIG3TBTyMXnbtoWmNZ2cY3VVFQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFyCFTAukS/fbkV0Hyl1Dj1iQs8l9rNO7AfYHqm8rGd/jSq8JdEq+eWMiLMezPrPG
         vUTCorsrnhKFnbhD4E4V8Jx4uTJIVe38sv8p/qogsUSL2/0tBeLv0P8tN6yymDGuEs
         gBM+hPNypFE8vAQKTB5058WrxseKC4W1TCT/xESdkbXfv4zRYxGgOzIbwXrUP93wm/
         R9Ls5TYc9Cjufg9cIwJAkzFc2pembsG57E6wFlY8ibz9OzjH8ZK/+PFHti60AxY5me
         d3nhS5Qqegj4mAXrDrmS4CBusU/7bAKw0KQUvBO48KDQ/vn/n29SF5r8nz6ckin26b
         iQxi9D93U5Q4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE6-003njR-88; Fri, 28 Jan 2022 12:19:39 +0000
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
Subject: [PATCH v6 27/64] KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
Date:   Fri, 28 Jan 2022 12:18:35 +0000
Message-Id: <20220128121912.509006-28-maz@kernel.org>
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

So far, we never needed to distinguish between registers hidden
from userspace and being hidden from a guest (they are always
either visible to both, or hidden from both).

With NV, we have the ugly case of the EL{0,1}2 registers, which
are only a view on the EL{0,1} registers. It makes absolutely no
sense to expose them to userspace, since it already has the
canonical view.

Add a new visibility flag (REG_HIDDEN_USER) and a new helper that
checks for it and REG_HIDDEN when checking whether to expose
a sysreg to userspace. Subsequent patches will make use of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c |  6 +++---
 arch/arm64/kvm/sys_regs.h | 12 +++++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 31d739d59f67..0c9bbe5eee5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3031,7 +3031,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -3056,7 +3056,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
@@ -3127,7 +3127,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden(vcpu, rd))
+	if (sysreg_hidden_user(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc0cc95a0280..850629f083a3 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -78,7 +78,8 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
+#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
+#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -138,6 +139,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r) & REG_HIDDEN;
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
2.30.2

