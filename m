Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74916703A71
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244950AbjEORvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244897AbjEORuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCB1B0A9
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADEE62F22
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B0C4339B;
        Mon, 15 May 2023 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172924;
        bh=BRXV6rAWpc0/CXcNW2cHbdZA6l0F6lbjVb8xQjdp5Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYjFl97meDkL1eceD6SR+QLYXUmcoWrIaDlaJreoHRsw6JdaoWD/t+48dh+MLaFFj
         Lga+3JB31n37HRzvon7tnRB2qbEBq3Nchblw9Yn52dxlfiis0cik3fu+p6NCwBKCpu
         CiGrCFzJKqz2wsJlphMbiXZ9HgFx0NtZlSfaxtrbzvTStH3Cc/rT6Id+VfLwCcJMEq
         +lK219MaJ+GPuaFQ0Zcg7FA2sj8ufVO91AP5nyoyK0FCxaB28X0FEUsjYK9xOdKRQb
         3PLH0NVy+ahONDxSKEYMEllRyKFWtu+ui4MlpsvSEqFERV3NwHoOfmC0gIRGfwj05f
         16u6f1ACPt10w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc3A-00FJAF-16;
        Mon, 15 May 2023 18:31:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 52/59] KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
Date:   Mon, 15 May 2023 18:30:56 +0100
Message-Id: <20230515173103.1017669-53-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Popular HW that is able to use NV also has a broken vgic implementation
that requires trapping.

On such HW, propagate the host trap bits into the guest's shadow
ICH_HCR_EL2 register, making sure we don't allow an L2 guest to bring
the system down.

This involves a bit of tweaking so that the emulation code correctly
poicks up the shadow state as needed, and to only partially sync
ICH_HCR_EL2 back with the guest state to capture EOIcount.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 75152c1ce646..aaaea35099e5 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -484,7 +484,7 @@ static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
 					 u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = kern_hyp_va(vcpu->arch.vgic_cpu.current_cpu_if)->used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
 	int i, lr = -1;
 
@@ -523,7 +523,7 @@ static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
 static int __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu, int intid,
 				    u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = kern_hyp_va(vcpu->arch.vgic_cpu.current_cpu_if)->used_lrs;
 	int i;
 
 	for (i = 0; i < used_lrs; i++) {
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 12937bc86e1c..51f97bd4489d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -149,9 +149,20 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 val = 0;
 	int i;
 
-	cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	/*
+	 * If we're on a system with a broken vgic that requires
+	 * trapping, propagate the trapping requirements.
+	 *
+	 * Ah, the smell of rotten fruits...
+	 */
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		val = host_if->vgic_hcr & (ICH_HCR_TALL0 | ICH_HCR_TALL1 |
+					   ICH_HCR_TC | ICH_HCR_TDIR);
+	cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
 	cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 
 	for (i = 0; i < 4; i++) {
@@ -181,6 +192,7 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	u64 val;
 	int i;
 
 	__vgic_v3_save_state(s_cpu_if);
@@ -189,7 +201,10 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
 	 */
-	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	val &= ~ICH_HCR_EOIcount_MASK;
+	val |= (s_cpu_if->vgic_hcr & ICH_HCR_EOIcount_MASK);
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = val;
 	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
 
 	for (i = 0; i < 4; i++) {
@@ -198,7 +213,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 
 		val &= ~ICH_LR_STATE;
 		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
-- 
2.34.1

