Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AFE50650C
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349082AbiDSHAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349074AbiDSHAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:14 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F3031204
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f6-20020a170902ab8600b0015895212d23so9243445plr.6
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/yJ16Mt8opbnIyJryWZlW/i1DVrAZ8RKhaEoLi7HeB0=;
        b=Oe/2r91Emsx2E5PbEGyFON5CMQ7peKXfIkYXEf+Dvwk+h+u7bTcu0sBc4gLyoKxIqe
         XGSuzcD9KtYTafz5OTh3OFd/1t82KCEb84vU1lrEnz5sUBjGDEJiHlmIzgnkEjxLzbjf
         zTMQApVrXK3YKvRyA7Y8Yp0SQVzCjUw7DpQU+E5bKq2oBBkWW4nJZMxqQiusH6/3IuUB
         fsYEmmr90eKI3K02a2qWau+duznVKS49GPzwEeza6t4nlhGMnErtXr1QueZ4lYBhOPHl
         mtsPvHa3LrDGjLkYt68ESClCa+EAhZqkacUniOd41o4QKzbc7KqgesHgLcbM0lCZbMU9
         J/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/yJ16Mt8opbnIyJryWZlW/i1DVrAZ8RKhaEoLi7HeB0=;
        b=skTWd4Sqdj/VgrMK1C7dPbbZ/xVKCRU5TLAcxv+2R7R70nYkKs/zh4E7yznadXtX3U
         cXz4G5UfUsUy3yOAIk8jkf7A46xrxyroLvn6RTmVzQ3//Mroypr0tcu65kqcCAZkwb+x
         KjgiRJtivmNuAb6BJdlyPE82rd+gMw8OXFYRqlhgxlcVWeHyGa3Ul/JbtpCcAH1DFcmy
         iN3GeXCJxFCtccdnVUdXkdMJh5KmIxsEVXonAxefYQv+mxtvsKweYcBQ1xsh43+Gzys0
         VgFZdN6vLMqZ2ojPHNFf1sKslShfJ37ncsPyK51qawkBll1x5qVfsW+k+yUkEQ+6m8vz
         MaRg==
X-Gm-Message-State: AOAM532ACmEW213f/4DMxnQOR4FeS+TB9MHcwy9hMs8MdMssZ3dFJhcP
        o4Ul73h4wwutXBW9f6nAI4mkWoYSuT0=
X-Google-Smtp-Source: ABdhPJzpVHE/Hi3uFTH3s8KCL9eFCGTPtBsk8Cj93lThGw5OG+gm74bF/4mO6VJ4yjWrPGmPVAnQI23BLZ4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8a90:b0:1d2:a931:3a03 with SMTP id
 x16-20020a17090a8a9000b001d2a9313a03mr7597147pjn.69.1650351448687; Mon, 18
 Apr 2022 23:57:28 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:20 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 14/38] KVM: arm64: Emulate dbgwcr accesses
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the number of non-context aware breakpoints for the guest is
decreased by userspace, KVM will map vCPU's context-aware breakpoints
(from the guest point of view) to pCPU's context aware breakpoints.
Since dbgwcr.lbn holds a linked breakpoint number, emulate dbgwcr
accesses to do conversion of virtual/physical dbgwcr.lbn as needed.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 110 ++++++++++++++++++++++++++++++++------
 1 file changed, 95 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ee1e0b6c4ce..400fa7ff582f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -846,20 +846,28 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 
 #define AA64DFR0_BRPS(v)	\
 	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_BRPS_SHIFT))
+#define AA64DFR0_WRPS(v)	\
+	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_WRPS_SHIFT))
 #define AA64DFR0_CTX_CMPS(v)	\
 	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_CTX_CMPS_SHIFT))
 
 #define INVALID_BRPN	((u8)-1)
 
-static u8 get_bcr_lbn(u64 val)
+static u8 get_bwcr_lbn(u64 val)
 {
+	WARN_ON_ONCE(SYS_DBGBCR_EL1_LBN_SHIFT != SYS_DBGWCR_EL1_LBN_SHIFT);
+	WARN_ON_ONCE(SYS_DBGBCR_EL1_LBN_MASK != SYS_DBGWCR_EL1_LBN_MASK);
+
 	return ((val >> SYS_DBGBCR_EL1_LBN_SHIFT) & SYS_DBGBCR_EL1_LBN_MASK);
 }
 
-static u64 update_bcr_lbn(u64 val, u8 lbn)
+static u64 update_bwcr_lbn(u64 val, u8 lbn)
 {
 	u64 new;
 
+	WARN_ON_ONCE(SYS_DBGBCR_EL1_LBN_SHIFT != SYS_DBGWCR_EL1_LBN_SHIFT);
+	WARN_ON_ONCE(SYS_DBGBCR_EL1_LBN_MASK != SYS_DBGWCR_EL1_LBN_MASK);
+
 	new = val & ~(SYS_DBGBCR_EL1_LBN_MASK << SYS_DBGBCR_EL1_LBN_SHIFT);
 	new |= ((u64)lbn & SYS_DBGBCR_EL1_LBN_MASK) << SYS_DBGBCR_EL1_LBN_SHIFT;
 	return new;
@@ -1029,29 +1037,51 @@ static u8 get_unused_p_bpn(struct kvm_vcpu *vcpu)
  * context aware breakpoint. In such cases, KVM will return 0 to reads of
  * bcr.lbn, and have the breakpoint behaves as if it is disabled by
  * setting the lbn to unused (disabled) breakpoint.
+ *
+ * virt_to_phys_wcr()/phys_to_virt_wcr() does the same thing for wcr.
  */
-static u64 virt_to_phys_bcr(struct kvm_vcpu *vcpu, u64 v_bcr)
+static u64 virt_to_phys_bwcr(struct kvm_vcpu *vcpu, u64 v_bwcr)
 {
 	u8 v_lbn, p_lbn;
 
-	v_lbn = get_bcr_lbn(v_bcr);
+	v_lbn = get_bwcr_lbn(v_bwcr);
 	p_lbn = virt_to_phys_bpn(vcpu, v_lbn);
 	if (p_lbn == INVALID_BRPN)
 		p_lbn = get_unused_p_bpn(vcpu);
 
-	return update_bcr_lbn(v_bcr, p_lbn);
+	return update_bwcr_lbn(v_bwcr, p_lbn);
 }
 
-static u64 phys_to_virt_bcr(struct kvm_vcpu *vcpu, u64 p_bcr)
+static u64 phys_to_virt_bwcr(struct kvm_vcpu *vcpu, u64 p_bwcr)
 {
 	u8 v_lbn, p_lbn;
 
-	p_lbn = get_bcr_lbn(p_bcr);
+	p_lbn = get_bwcr_lbn(p_bwcr);
 	v_lbn = phys_to_virt_bpn(vcpu, p_lbn);
 	if (v_lbn == INVALID_BRPN)
 		v_lbn = 0;
 
-	return update_bcr_lbn(p_bcr, v_lbn);
+	return update_bwcr_lbn(p_bwcr, v_lbn);
+}
+
+static u64 virt_to_phys_bcr(struct kvm_vcpu *vcpu, u64 v_bcr)
+{
+	return virt_to_phys_bwcr(vcpu, v_bcr);
+}
+
+static u64 virt_to_phys_wcr(struct kvm_vcpu *vcpu, u64 v_wcr)
+{
+	return virt_to_phys_bwcr(vcpu, v_wcr);
+}
+
+static u64 phys_to_virt_bcr(struct kvm_vcpu *vcpu, u64 p_bcr)
+{
+	return phys_to_virt_bwcr(vcpu, p_bcr);
+}
+
+static u64 phys_to_virt_wcr(struct kvm_vcpu *vcpu, u64 p_wcr)
+{
+	return phys_to_virt_bwcr(vcpu, p_wcr);
 }
 
 /*
@@ -1116,6 +1146,12 @@ void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu)
 			dbg->dbg_bcr[v] = 0;
 			dbg->dbg_bvr[v] = 0;
 		}
+
+		/*
+		 * There is no distinction between physical and virtual
+		 * watchpoint numbers. So, the index stays the same.
+		 */
+		dbg->dbg_wcr[v] = virt_to_phys_wcr(vcpu, dbg->dbg_wcr[v]);
 	}
 }
 
@@ -1461,12 +1497,26 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
+	u8 wpn = rd->CRm;
+	u64 *dbg_reg;
+	u64 v_dfr0 = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
 
-	if (p->is_write)
+	if (wpn > AA64DFR0_WRPS(v_dfr0)) {
+		/* Invalid watchpoint number for the guest */
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[wpn];
+	if (p->is_write) {
+		/* Convert virtual wcr to physical wcr and update debug_reg */
+		p->regval = virt_to_phys_wcr(vcpu, p->regval);
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
-	else
+	} else {
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
+		/* Convert physical wcr to virtual wcr */
+		p->regval = phys_to_virt_wcr(vcpu, p->regval);
+	}
 
 	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
@@ -1476,19 +1526,49 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
+	u8 wpn = rd->CRm;
+	u64 v_wcr, p_wcr;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&v_wcr, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual wcr.
+	 * After that, vcpu_debug_state holds the physical wcr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/* Convert virtual wcr to physical wcr, and save it */
+		p_wcr = virt_to_phys_wcr(vcpu, v_wcr);
+		vcpu->arch.vcpu_debug_state.dbg_wcr[wpn] = p_wcr;
+	} else {
+		vcpu->arch.vcpu_debug_state.dbg_wcr[wpn] = v_wcr;
+		return 0;
+	}
+
 	return 0;
 }
 
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
+	u8 wpn = rd->CRm;
+	u64 p_wcr, v_wcr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual wcr.
+	 * After that, vcpu_debug_state holds the physical wcr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/* Get the physical wcr value */
+		p_wcr = vcpu->arch.vcpu_debug_state.dbg_wcr[wpn];
+
+		/* Convert physical wcr to virtual wcr */
+		v_wcr = phys_to_virt_wcr(vcpu, p_wcr);
+	} else {
+		v_wcr = vcpu->arch.vcpu_debug_state.dbg_wcr[wpn];
+	}
+
+	if (copy_to_user(uaddr, &v_wcr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

