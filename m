Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB7667F58
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbjALTan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbjALT2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A993DBE9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C74AB82000
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B64FC433D2;
        Thu, 12 Jan 2023 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551326;
        bh=WMZJAZ1xSRVXn5EX9T/eLLCTSW75eAbHWU1vk49tfAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKaP2js/i7i2GIS88BZFhjps4rfilLTjK/citS1LsDFG62S1nZQSmWAEtaCVw424i
         5TbRAixfroYMWAmXGABNJIRlUQhNtSxntj+M3JRDIatjM/CbtcOdgeLLkxG/SULC5m
         yAvDvDL/VjmdyzHB0mSdHy5D/MWGYwrhpS2f20vhIlG7z4ZWWudjMKcG2ewgQsQqm/
         ngSZ3OzaCWxZfwXfY5Y65QUGM/8sYr2XtYeWx67ce6j4COZCVefzXArUKx5HOMzJfG
         VoGS4cla/Tp5CyBLKn21wSA+Aiazicw2Fp3zlrRQoFPGzvZOp+IA/+fN5UMppQVBEH
         o4LYN7uj23EKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG36y-001IWu-Fi;
        Thu, 12 Jan 2023 19:19:40 +0000
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
Subject: [PATCH v7 13/68] KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
Date:   Thu, 12 Jan 2023 19:18:32 +0000
Message-Id: <20230112191927.1814989-14-maz@kernel.org>
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

KVM internally uses accessor functions when reading or writing the
guest's system registers. This takes care of accessing either the stored
copy or using the "live" EL1 system registers when the host uses VHE.

With the introduction of virtual EL2 we add a bunch of EL2 system
registers, which now must also be taken care of:
- If the guest is running in vEL2, and we access an EL1 sysreg, we must
  revert to the stored version of that, and not use the CPU's copy.
- If the guest is running in vEL1, and we access an EL2 sysreg, we must
  also use the stored version, since the CPU carries the EL1 copy.
- Some EL2 system registers are supposed to affect the current execution
  of the system, so we need to put them into their respective EL1
  counterparts. For this we need to define a mapping between the two.
  This is done using the newly introduced struct el2_sysreg_map.
- Some EL2 system registers have a different format than their EL1
  counterpart, so we need to translate them before writing them to the
  CPU. This is done using an (optional) translate function in the map.
- There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
  which need some separate handling (SPSR_EL2 is being handled in a
  separate patch).

All of these cases are now wrapped into the existing accessor functions,
so KVM users wouldn't need to care whether they access EL2 or EL1
registers and also which state the guest is in.

This handles what was formerly known as the "shadow state" dynamically,
without requiring a separate copy for each vCPU EL.

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 141 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 137 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 654d43df3e95..eb3eea71f370 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -62,23 +62,156 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+#define PURE_EL2_SYSREG(el2)						\
+	case el2: {							\
+		*el1r = el2;						\
+		return true;						\
+	}
+
+#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
+	case el2: {							\
+		*xlate = fn;						\
+		*el1r = el1;						\
+		return true;						\
+	}
+
+static bool get_el2_to_el1_mapping(unsigned int reg,
+				   unsigned int *el1r, u64 (**xlate)(u64))
+{
+	switch (reg) {
+		PURE_EL2_SYSREG(  VPIDR_EL2	);
+		PURE_EL2_SYSREG(  VMPIDR_EL2	);
+		PURE_EL2_SYSREG(  ACTLR_EL2	);
+		PURE_EL2_SYSREG(  HCR_EL2	);
+		PURE_EL2_SYSREG(  MDCR_EL2	);
+		PURE_EL2_SYSREG(  HSTR_EL2	);
+		PURE_EL2_SYSREG(  HACR_EL2	);
+		PURE_EL2_SYSREG(  VTTBR_EL2	);
+		PURE_EL2_SYSREG(  VTCR_EL2	);
+		PURE_EL2_SYSREG(  RVBAR_EL2	);
+		PURE_EL2_SYSREG(  TPIDR_EL2	);
+		PURE_EL2_SYSREG(  HPFAR_EL2	);
+		PURE_EL2_SYSREG(  ELR_EL2	);
+		PURE_EL2_SYSREG(  SPSR_EL2	);
+		PURE_EL2_SYSREG(  CNTHCTL_EL2	);
+		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
+				  translate_sctlr_el2_to_sctlr_el1	     );
+		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
+				  translate_cptr_el2_to_cpacr_el1	     );
+		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
+				  translate_ttbr0_el2_to_ttbr0_el1	     );
+		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(TCR_EL2,     TCR_EL1,
+				  translate_tcr_el2_to_tcr_el1		     );
+		MAPPED_EL2_SYSREG(VBAR_EL2,    VBAR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AFSR0_EL2,   AFSR0_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(AFSR1_EL2,   AFSR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
+	default:
+		return false;
+	}
+}
+
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
 
-	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
-	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
+		goto memory_read;
+
+	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
+		if (!is_hyp_ctxt(vcpu))
+			goto memory_read;
+
+		/*
+		 * ELR_EL2 is special cased for now.
+		 */
+		switch (reg) {
+		case ELR_EL2:
+			return read_sysreg_el1(SYS_ELR);
+		}
+
+		/*
+		 * If this register does not have an EL1 counterpart,
+		 * then read the stored EL2 version.
+		 */
+		if (reg == el1r)
+			goto memory_read;
+
+		/*
+		 * If we have a non-VHE guest and that the sysreg
+		 * requires translation to be used at EL1, use the
+		 * in-memory copy instead.
+		 */
+		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
+			goto memory_read;
+
+		/* Get the current version of the EL1 counterpart. */
+		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
+		return val;
+	}
+
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_read;
+
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
+memory_read:
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
-	    __vcpu_write_sys_reg_to_cpu(val, reg))
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
+
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
+		goto memory_write;
+
+	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
+		if (!is_hyp_ctxt(vcpu))
+			goto memory_write;
+
+		/*
+		 * Always store a copy of the write to memory to avoid having
+		 * to reverse-translate virtual EL2 system registers for a
+		 * non-VHE guest hypervisor.
+		 */
+		__vcpu_sys_reg(vcpu, reg) = val;
+
+		switch (reg) {
+		case ELR_EL2:
+			write_sysreg_el1(val, SYS_ELR);
+			return;
+		}
+
+		/* No EL1 counterpart? We're done here.? */
+		if (reg == el1r)
+			return;
+
+		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
+			val = xlate(val);
+
+		/* Redirect this to the EL1 version of the register. */
+		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, el1r));
+		return;
+	}
+
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_write;
+
+	if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
+memory_write:
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-- 
2.34.1

