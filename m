Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36ADB667F13
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbjALT1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbjALT03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:26:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FA16374
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:19:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76DED62177
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24AFC4339C;
        Thu, 12 Jan 2023 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551180;
        bh=VN8FgM11WrsDzj5DbshbSdhuf675FgKDTFEV5EVLWUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKNzHQMl73+uRfkgShN0dhO7dPVFJcBSNkFrwHvORyXO+1VZaLVrlrKKXwc8ms/HT
         nijNDt3mUb92gm6/651vN+PWS19nyG3JNK7Sc0RZhCjsqRvxwLG+d1bbftiWxgo9QR
         QUffaBY1FZexgRm48xvpJdeNwjrmdTZiYnD9kN7Qw+9OtmaYMmJBQMtDo5EZ0nyyDq
         t4opYLitkKg2NKPlcOpWC5T2zO0BEo9fsgse/3JepWtnOF0W1X6lMAgZ7hsdq+UODh
         NQTP5F/lMOwrYRq8d6IxMJU5Ue0DuTYa+nQ575O/I/JQaOubnKGg8c9otgGpqgoWoq
         Xn8OHwlOS2uvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG36x-001IWu-3A;
        Thu, 12 Jan 2023 19:19:39 +0000
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
Subject: [PATCH v7 08/68] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
Date:   Thu, 12 Jan 2023 19:18:27 +0000
Message-Id: <20230112191927.1814989-9-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@arm.com>

The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
let's be nice to a guest hypervisor behaving foolishly and reset these
to something reasonable anyway.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e1543fec51e..654d43df3e95 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -594,7 +594,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
 }
 
-static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 compute_reset_mpidr(struct kvm_vcpu *vcpu)
 {
 	u64 mpidr;
 
@@ -608,7 +608,24 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
+static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), MPIDR_EL1);
+}
+
+static void reset_vmpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), VMPIDR_EL2);
+}
+
+static void reset_vpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, read_cpuid_id(), VPIDR_EL2);
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -1963,8 +1980,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
-	EL2_REG(VPIDR_EL2, access_rw, reset_val, 0),
-	EL2_REG(VMPIDR_EL2, access_rw, reset_val, 0),
+	EL2_REG(VPIDR_EL2, access_rw, reset_vpidr, 0),
+	EL2_REG(VMPIDR_EL2, access_rw, reset_vmpidr, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
-- 
2.34.1

