Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1C3569040
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiGFRF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiGFRF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB262A702
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1B161E7B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5615BC341D0;
        Wed,  6 Jul 2022 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127126;
        bh=/UBLTwcp0YJL6yqG+codpLdWuhaO9jZc0SDHe1TX7BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6POAsrfx3wPagDsrhG7KU98BsGo2m3NN11nv9n5jF5YVln1XCzTcg/C2n5rhc81d
         Q6k/SdJpK/qlNgTYVeEOH9+MbEPJ9NcutjqP5Obf870XVYx14pYxbApFW99qgAMWnY
         1pT7Lm/RGy5FmHeK40GvAupSy9ymVNAFBVWrLFiOKc0I7O7wIiVSAOtzrbXOjCEueZ
         RY+Xd8KZE22ql/z6uu3BpmXpje4cfr+9k5vMDqBNbEOWa5Hz2scYCpUnt0MF9V2YUT
         mBno5Ca30J68wc0BZ/cv7SYVxSiZmTzzFr5dTHtykr9BctaPLn3bZAOUm6FanJRedE
         aaYKWOEOoeGDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987M-005h9i-Pe;
        Wed, 06 Jul 2022 17:43:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 10/19] KVM: arm64: vgic-v3: Convert userspace accessors over to FIELD_GET/FIELD_PREP
Date:   Wed,  6 Jul 2022 17:42:55 +0100
Message-Id: <20220706164304.1582687-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv3 userspace accessors are all about dealing with conversion
between fields from architectural registers and internal representations.

However, and owing to the age of this code, the accessors use
a combination of shift/mask that is hard to read. It is nonetheless
easy to make it better by using the FIELD_{GET,PREP} macros that solely
rely on a mask.

This results in somewhat nicer looking code, and is probably easier
to maintain.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 60 ++++++++++++++------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 2ca172cdc5c4..8c4f5d08270b 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -23,30 +23,25 @@ static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 * Disallow restoring VM state if not supported by this
 	 * hardware.
 	 */
-	host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
-			 ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
+	host_pri_bits = FIELD_GET(ICC_CTLR_EL1_PRI_BITS_MASK, val) + 1;
 	if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
 		return -EINVAL;
 
 	vgic_v3_cpu->num_pri_bits = host_pri_bits;
 
-	host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
-		ICC_CTLR_EL1_ID_BITS_SHIFT;
+	host_id_bits = FIELD_GET(ICC_CTLR_EL1_ID_BITS_MASK, val);
 	if (host_id_bits > vgic_v3_cpu->num_id_bits)
 		return -EINVAL;
 
 	vgic_v3_cpu->num_id_bits = host_id_bits;
 
-	host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
-		      ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
-	seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
-		ICC_CTLR_EL1_SEIS_SHIFT;
+	host_seis = FIELD_GET(ICH_VTR_SEIS_MASK, kvm_vgic_global_state.ich_vtr_el2);
+	seis = FIELD_GET(ICC_CTLR_EL1_SEIS_MASK, val);
 	if (host_seis != seis)
 		return -EINVAL;
 
-	host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
-		     ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
-	a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
+	host_a3v = FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2);
+	a3v = FIELD_GET(ICC_CTLR_EL1_A3V_MASK, val);
 	if (host_a3v != a3v)
 		return -EINVAL;
 
@@ -54,8 +49,8 @@ static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
 	 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
 	 */
-	vmcr.cbpr = (val & ICC_CTLR_EL1_CBPR_MASK) >> ICC_CTLR_EL1_CBPR_SHIFT;
-	vmcr.eoim = (val & ICC_CTLR_EL1_EOImode_MASK) >> ICC_CTLR_EL1_EOImode_SHIFT;
+	vmcr.cbpr = FIELD_GET(ICC_CTLR_EL1_CBPR_MASK, val);
+	vmcr.eoim = FIELD_GET(ICC_CTLR_EL1_EOImode_MASK, val);
 	vgic_set_vmcr(vcpu, &vmcr);
 
 	return 0;
@@ -70,20 +65,19 @@ static int get_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 	vgic_get_vmcr(vcpu, &vmcr);
 	val = 0;
-	val |= (vgic_v3_cpu->num_pri_bits - 1) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
-	val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
-	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
-		 ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
-		ICC_CTLR_EL1_SEIS_SHIFT;
-	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
-		 ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
-		ICC_CTLR_EL1_A3V_SHIFT;
+	val |= FIELD_PREP(ICC_CTLR_EL1_PRI_BITS_MASK, vgic_v3_cpu->num_pri_bits - 1);
+	val |= FIELD_PREP(ICC_CTLR_EL1_ID_BITS_MASK, vgic_v3_cpu->num_id_bits);
+	val |= FIELD_PREP(ICC_CTLR_EL1_SEIS_MASK,
+			  FIELD_GET(ICH_VTR_SEIS_MASK,
+				    kvm_vgic_global_state.ich_vtr_el2));
+	val |= FIELD_PREP(ICC_CTLR_EL1_A3V_MASK,
+			  FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2));
 	/*
 	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
 	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
 	 */
-	val |= (vmcr.cbpr << ICC_CTLR_EL1_CBPR_SHIFT) & ICC_CTLR_EL1_CBPR_MASK;
-	val |= (vmcr.eoim << ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
+	val |= FIELD_PREP(ICC_CTLR_EL1_CBPR_MASK, vmcr.cbpr);
+	val |= FIELD_PREP(ICC_CTLR_EL1_EOImode_MASK, vmcr.eoim);
 
 	*valp = val;
 
@@ -96,7 +90,7 @@ static int set_gic_pmr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	vmcr.pmr = (val & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
+	vmcr.pmr = FIELD_GET(ICC_PMR_EL1_MASK, val);
 	vgic_set_vmcr(vcpu, &vmcr);
 
 	return 0;
@@ -108,7 +102,7 @@ static int get_gic_pmr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	*val = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
+	*val = FIELD_PREP(ICC_PMR_EL1_MASK, vmcr.pmr);
 
 	return 0;
 }
@@ -119,7 +113,7 @@ static int set_gic_bpr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	vmcr.bpr = (val & ICC_BPR0_EL1_MASK) >> ICC_BPR0_EL1_SHIFT;
+	vmcr.bpr = FIELD_GET(ICC_BPR0_EL1_MASK, val);
 	vgic_set_vmcr(vcpu, &vmcr);
 
 	return 0;
@@ -131,7 +125,7 @@ static int get_gic_bpr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	*val = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) & ICC_BPR0_EL1_MASK;
+	*val = FIELD_PREP(ICC_BPR0_EL1_MASK, vmcr.bpr);
 
 	return 0;
 }
@@ -143,7 +137,7 @@ static int set_gic_bpr1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 	vgic_get_vmcr(vcpu, &vmcr);
 	if (!vmcr.cbpr) {
-		vmcr.abpr = (val & ICC_BPR1_EL1_MASK) >> ICC_BPR1_EL1_SHIFT;
+		vmcr.abpr = FIELD_GET(ICC_BPR1_EL1_MASK, val);
 		vgic_set_vmcr(vcpu, &vmcr);
 	}
 
@@ -157,7 +151,7 @@ static int get_gic_bpr1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 	vgic_get_vmcr(vcpu, &vmcr);
 	if (!vmcr.cbpr)
-		*val = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) & ICC_BPR1_EL1_MASK;
+		*val = FIELD_PREP(ICC_BPR1_EL1_MASK, vmcr.abpr);
 	else
 		*val = min((vmcr.bpr + 1), 7U);
 
@@ -171,7 +165,7 @@ static int set_gic_grpen0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	vmcr.grpen0 = (val & ICC_IGRPEN0_EL1_MASK) >> ICC_IGRPEN0_EL1_SHIFT;
+	vmcr.grpen0 = FIELD_GET(ICC_IGRPEN0_EL1_MASK, val);
 	vgic_set_vmcr(vcpu, &vmcr);
 
 	return 0;
@@ -183,7 +177,7 @@ static int get_gic_grpen0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	*val = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) & ICC_IGRPEN0_EL1_MASK;
+	*val = FIELD_PREP(ICC_IGRPEN0_EL1_MASK, vmcr.grpen0);
 
 	return 0;
 }
@@ -194,7 +188,7 @@ static int set_gic_grpen1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	vmcr.grpen1 = (val & ICC_IGRPEN1_EL1_MASK) >> ICC_IGRPEN1_EL1_SHIFT;
+	vmcr.grpen1 = FIELD_GET(ICC_IGRPEN1_EL1_MASK, val);
 	vgic_set_vmcr(vcpu, &vmcr);
 
 	return 0;
@@ -206,7 +200,7 @@ static int get_gic_grpen1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	*val = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) & ICC_IGRPEN1_EL1_MASK;
+	*val = FIELD_GET(ICC_IGRPEN1_EL1_MASK, vmcr.grpen1);
 
 	return 0;
 }
-- 
2.34.1

