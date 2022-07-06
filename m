Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF47568F6D
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiGFQnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiGFQnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89425E8B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE2961DB1
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 16:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D4FC341CA;
        Wed,  6 Jul 2022 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657125793;
        bh=GdLG/XaB8d/eJSmonaDoVgKiTzmews1UlhysHlpleWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtmRlShZrNJd9Uyu8c5JDwdMopnIlC74b9cZS/+llHywevclgDV7ZfLcJa21pxlEP
         ukGGzbiyeNozQDbNEDUitfGKGdHwft/xZhox1jiPnsbGHP1TAttJn+LhO5JsuRLH7V
         a/fWRwiu+tcDJyLFz4Kfgz8SA10RvcbdGc1kZXl3kxH39mgeC40GFTsp0c19o9UhUl
         z2AbxDB34STm6JQJA5nSYnO+L2CIdlh23Y76FwVOWSNVYkf5fXVoKds2uHxyp72wBO
         87zEXr8VI5BIRE65+2q/BFMmnn0fWRPZbGjNjzu2tC0DRkNr0m4CkzlmHD56GMMmCQ
         HrXUfZepXns/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987L-005h9i-Fi;
        Wed, 06 Jul 2022 17:43:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 04/19] KVM: arm64: Push checks for 64bit registers into the low-level accessors
Date:   Wed,  6 Jul 2022 17:42:49 +0100
Message-Id: <20220706164304.1582687-5-maz@kernel.org>
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

Make sure the check occurs on every paths where we can pick
a sysreg from userspace, including the GICv3 paths.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0fbdb21a3600..89e7eddea937 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2656,6 +2656,10 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
 {
 	struct sys_reg_params params;
 
+	/* 64 bit is the only way */
+	if (KVM_REG_SIZE(id) != sizeof(__u64))
+		return NULL;
+
 	if (!index_to_params(id, &params))
 		return NULL;
 
@@ -2871,9 +2875,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
-		return -ENOENT;
-
 	err = get_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
 		return err;
@@ -2906,9 +2907,6 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(reg->id, uaddr);
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
-		return -ENOENT;
-
 	err = set_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
 		return err;
-- 
2.34.1

