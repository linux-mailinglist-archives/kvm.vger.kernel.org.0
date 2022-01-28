Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5216A49F94E
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbiA1MUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348505AbiA1MUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1347DB8256F
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C637DC340E0;
        Fri, 28 Jan 2022 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372430;
        bh=Ghi3+lsqeB3FSKHbl6iqhHSKRKD/45c83KMMh1kJ/yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNiHJhlX+xHX13Dh8S3m5K/YEpQ12iEKE2iEVi12umSi6eHO5IAozOA+6Effm94oD
         dEd7kJQbH57OPkeQa1ScDrDBsuEgBp+ysbeO4SfVyRjKL/S5Lvr+yoUrdOjfrQ0SVl
         hkHTZcTJlHxOLI78Z3HtHhZfapXj1Py3cn2jrUpqEnxm7QBmUQPHLP1GEUQ/wREvaF
         d+Kfz3202PLeqVoSopcVAcNxAUmRkslvV4sj1gG8/8aySJfBMAsEHhLboRXoPQ3Dd2
         kmg0lj5gtPzOn0LX/q3PZNvskyDsNVtOd73dw5cwIQXbHOLkM7n1OsoSLGbstkWRvI
         cNqm97JaSZVtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE9-003njR-PT; Fri, 28 Jan 2022 12:19:42 +0000
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
Subject: [PATCH v6 29/64] KVM: arm64: nv: Forward debug traps to the nested guest
Date:   Fri, 28 Jan 2022 12:18:37 +0000
Message-Id: <20220128121912.509006-30-maz@kernel.org>
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

On handling a debug trap, check whether we need to forward it to the
guest before handling it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 ++
 arch/arm64/kvm/emulate-nested.c     | 9 +++++++--
 arch/arm64/kvm/sys_regs.c           | 3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 82fc8b6c990b..047ca700163b 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -66,6 +66,8 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
 }
 
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
+extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
+			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 0109dfd664dd..1f6cf8fe9fe3 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -13,14 +13,14 @@
 
 #include "trace.h"
 
-bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
 	bool control_bit_set;
 
 	if (!vcpu_has_nv(vcpu))
 		return false;
 
-	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
 	if (!vcpu_is_el2(vcpu) && control_bit_set) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
@@ -28,6 +28,11 @@ bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
 	return false;
 }
 
+bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, HCR_EL2, control_bit);
+}
+
 bool forward_nv_traps(struct kvm_vcpu *vcpu)
 {
 	return forward_traps(vcpu, HCR_NV);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 697bf0bca550..3e1f37c507a8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -566,6 +566,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
+	if (__forward_traps(vcpu, MDCR_EL2, MDCR_EL2_TDA | MDCR_EL2_TDE))
+		return false;
+
 	access_rw(vcpu, p, r);
 	if (p->is_write)
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-- 
2.30.2

