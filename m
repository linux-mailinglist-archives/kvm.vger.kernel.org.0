Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28DD52D4BF
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiESNqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiESNpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492C1CEB9B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B8B617A3
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71080C34115;
        Thu, 19 May 2022 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967907;
        bh=2ZalBIGM7JSYFfLvIQUaX1p+ssc3QooHu98yjwP1v/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGFCCpT73KiD1pU7luVlg8x4AqHTP91+nIGFA6vsbv9NGUUUkM6+f+16s8HUDZHQV
         vib3XAT8a4KbKUo33Yk91wedCtFnD/jD+3kh4ArixrZMFbdJXggZi+fZTGobPhkxym
         HxB1fEHL+zBjjCeyswDIfjCcpZGRmcKRFq0Bg80PiA641hQBs94trYcE6W57o/mq4F
         yhgRvpnCL0gKXvKNxnsivpUBST6YKzv0AnQeKtQONM+ZFb0XmMS4hzSjLpQI/FRcfi
         YDP0BB2dBA2HFPlxYsK4f7ktQWBjEHFwSUjMbazeNcb+ekbd5pYJDAU4B+9AzBMWbm
         J1opVDsMFUTBA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 41/89] KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
Date:   Thu, 19 May 2022 14:41:16 +0100
Message-Id: <20220519134204.5379-42-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Allow vcpu_{read,write}_sys_reg() to be called from EL2 so that nVHE hyp
code can reuse existing helper functions for operations such as
resetting the vCPU state.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 30 +++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c         | 20 --------------------
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9252841850e4..c55aadfdfd63 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -553,9 +553,6 @@ struct kvm_vcpu_arch {
 
 #define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
-
 static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
 	/*
@@ -647,6 +644,33 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	return true;
 }
 
+static inline u64 vcpu_arch_read_sys_reg(const struct kvm_vcpu_arch *vcpu_arch,
+					 int reg)
+{
+	u64 val = 0x8badf00d8badf00d;
+
+	/* sysregs_loaded_on_cpu is only used in VHE */
+	if (!is_nvhe_hyp_code() && vcpu_arch->sysregs_loaded_on_cpu &&
+	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
+
+	return ctxt_sys_reg(&vcpu_arch->ctxt, reg);
+}
+
+static inline void vcpu_arch_write_sys_reg(struct kvm_vcpu_arch *vcpu_arch,
+					   u64 val, int reg)
+{
+	/* sysregs_loaded_on_cpu is only used in VHE */
+	if (!is_nvhe_hyp_code() && vcpu_arch->sysregs_loaded_on_cpu &&
+	    __vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
+	 ctxt_sys_reg(&vcpu_arch->ctxt, reg) = val;
+}
+
+#define vcpu_read_sys_reg(vcpu, reg) vcpu_arch_read_sys_reg(&((vcpu)->arch), reg)
+#define vcpu_write_sys_reg(vcpu, val, reg) vcpu_arch_write_sys_reg(&((vcpu)->arch), val, reg)
+
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..7886989443b9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -68,26 +68,6 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
-{
-	u64 val = 0x8badf00d8badf00d;
-
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_read_sys_reg_from_cpu(reg, &val))
-		return val;
-
-	return __vcpu_sys_reg(vcpu, reg);
-}
-
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_write_sys_reg_to_cpu(val, reg))
-		return;
-
-	 __vcpu_sys_reg(vcpu, reg) = val;
-}
-
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
-- 
2.36.1.124.g0e6072fb45-goog

