Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC3268291F
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjAaJlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjAaJlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:41:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8124366B2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7C0B81AB2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C36C433D2;
        Tue, 31 Jan 2023 09:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158062;
        bh=uuVf166OaKEfm0pMgDt6BSPXE2oAhYfqL5lWMvrQvcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ+BiRr3M+1hoFoov0Qh9f0RlLRKLGXicsyYuRNkIP0Ew2GCEUk488MZyqk2S3jOZ
         wK/+IwAH6NRUuDkfSNjnCY1fGRyBzTVBFvZ9bD0UISjnRPcX+1YxLkg74LKfhN6YTo
         v0sgdwl3RLfUHyHfTBvd6LVNmK/Cta2fh6sCEAlIJuKuzntdbyG3EcNP8HBlzBou6i
         3Pqs+lNcpT+9GpuSWpOhd3HKT6sln4B2kL+qYIGQBOT4dp/OPmIVibk+niNHJg5fKD
         MLj0JjH5PQYUnC6Xs3YmGnVzin8Jl/tThyms20EgxwC41PHveqHeGkIvtDyaqCoz3h
         ifkC04lE1IZHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtS-0067U2-SG;
        Tue, 31 Jan 2023 09:25:34 +0000
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
Subject: [PATCH v8 19/69] KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
Date:   Tue, 31 Jan 2023 09:24:14 +0000
Message-Id: <20230131092504.2880505-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

When running in virtual EL2 mode, we actually run the hardware in EL1
and therefore have to use the EL1 registers to ensure correct operation.

By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
doesn't shoot itself in the foot when setting up what it believes to be
a different mode's system register state (for example when preparing to
switch to a VM).

We can leverage the existing sysregs infrastructure to support trapped
accesses to these registers.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  7 ++++++-
 arch/arm64/kvm/sys_regs.c               | 19 ++++++++++++++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..e0bcaf000251 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -118,10 +118,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c2cb46ca4fb6..efac8fbe0b20 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -40,7 +40,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index cd3f3117bf16..c8da8d350453 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -35,9 +35,14 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	u64 hcr = vcpu->arch.hcr_el2;
 	u64 val;
 
-	___activate_traps(vcpu);
+	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
+	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		hcr |= HCR_TVM | HCR_TRVM;
+
+	___activate_traps(vcpu, hcr);
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_ELx_TTA;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26d189f908a7..f83d8fe47573 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -391,8 +391,15 @@ static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
 
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
- * is set. If the guest enables the MMU, we stop trapping the VM
- * sys_regs and leave it in complete control of the caches.
+ * is set.
+ *
+ * This is set in two cases: either (1) we're running at vEL2, or (2)
+ * we're running at EL1 and the guest has its MMU off.
+ *
+ * (1) TVM/TRVM is set, as we need to virtualise some of the VM
+ * registers for the guest hypervisor
+ * (2) Once the guest enables the MMU, we stop trapping the VM sys_regs
+ * and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -401,7 +408,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	BUG_ON(!p->is_write);
+	/* We don't expect TRVM on the host */
+	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
+
+	if (!p->is_write) {
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+		return true;
+	}
 
 	get_access_mask(r, &mask, &shift);
 
-- 
2.34.1

