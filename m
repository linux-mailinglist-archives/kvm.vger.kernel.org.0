Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88241682929
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjAaJlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjAaJln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:41:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0763D902
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FAC86147F
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5387C433EF;
        Tue, 31 Jan 2023 09:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158086;
        bh=ESIDo1L7SOPJ/b6U02mH7Qt5+IYpfRiML1qv/jzpvY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTqaVmHnovuLu8wF2D4pilipbNzLwFTQyQmhu0G5xU6MfMJrRaFFd5nb+Rhry0max
         skZpeKqbudYYYSpBnKBaEKET8ocWIZ9MuhN1l5N5DBfBdF7fINKa/zxMhJEOqB8WaT
         0gXeZOGm9Jx2FE+i0dDKWB+xNlmG9pOY9EX0o57Y2WJCwPGFZllonsNkqaR+pwjZf1
         9r/bi9wGWpxC/vmUKa8blvFiycMDLYeQr7O26kNtSy0GRCJ5lbiOpZQRHnGRZLjk3p
         qARdyXwQafB+qW7qctYuPXsqlsUcs1VHquyatSvEsfqio9wHR/YXD94fe5UPfHkKRC
         CuD110vOzTmtg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtU-0067U2-ET;
        Tue, 31 Jan 2023 09:25:36 +0000
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
Subject: [PATCH v8 25/69] KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
Date:   Tue, 31 Jan 2023 09:24:20 +0000
Message-Id: <20230131092504.2880505-26-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Forward traps due to HCR_EL2.NV bit to the virtual EL2 if they are not
coming from the virtual EL2 and the virtual HCR_EL2.NV bit is set.

In addition to EL2 register accesses, setting NV bit will also make EL12
register accesses trap to EL2. To emulate this for the virtual EL2,
forword traps due to EL12 register accessses to the virtual EL2 if the
virtual HCR_EL2.NV bit is set. Same thing is done for SMCs issued by
a guest and trapped by the virtual EL2.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[Moved code to emulate-nested.c]
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h    |  1 +
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c        |  7 +++++++
 arch/arm64/kvm/sys_regs.c           | 21 +++++++++++++++++++++
 5 files changed, 59 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index baef29fcbeee..e47faadbfde1 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -20,6 +20,7 @@
 #define HCR_AMVOFFEN	(UL(1) << 51)
 #define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index f7bb1f0d0954..befd2501d5ba 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -59,4 +59,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
+extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b96662029fb1..75cf6f15accc 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -14,6 +14,26 @@
 
 #include "trace.h"
 
+bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!vcpu_is_el2(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+bool forward_nv_traps(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_NV);
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
@@ -52,6 +72,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	u64 spsr, elr, mode;
 	bool direct_eret;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual
+	 * HCR_EL2.NV bit is set and this is coming from !EL2.
+	 */
+	if (forward_nv_traps(vcpu))
+		return;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 2aefe35409c9..cfc50d67a6bc 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -65,6 +65,13 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2 if
+	 * the guest has asked for it.
+	 */
+	if (forward_traps(vcpu, HCR_TSC))
+		return 1;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1cc68ca9eb20..58c0c0eed28b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -336,10 +336,19 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
 	return 0;
 }
 
+static bool el12_reg(struct sys_reg_params *p)
+{
+	/* All *_EL12 registers have Op1=5. */
+	return (p->Op1 == 5);
+}
+
 static bool access_rw(struct kvm_vcpu *vcpu,
 		      struct sys_reg_params *p,
 		      const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
 	else
@@ -408,6 +417,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	/* We don't expect TRVM on the host */
 	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
 
@@ -1869,6 +1881,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
 	else
@@ -1881,6 +1896,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
 	else
@@ -1893,6 +1911,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
 	else
-- 
2.34.1

