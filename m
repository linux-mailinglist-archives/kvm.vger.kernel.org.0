Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C41575199
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiGNPUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiGNPUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DAB5C37A
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054D961F29
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF0DC341C8;
        Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812030;
        bh=AwfmzeeBLDFpkpiMy+JT9JpojGra6eCY8Mz6ZVZbALo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOJVpLdoWJc6/FS5BwMlKRFZxkEkRHnk4eQpNcwCV1hEHXu8ocaiI+NRvsx2g5hDv
         qgekRp3I76r2SAUAsbriWlVudC+zes5Cx8W6BbQ2DDHGwr8nq1g+eKUjtCwa/ZKj3z
         bAJIsZ+aFjgUGMF9s6SR02mycyIsztbRCoqv0ZbXmzAjeibqGEaaSnU58FJBj8iNgT
         dvyt6S0kN9F2NkKxlJZPh2VW0q8+Gk5PUGFf9NBdMXjpsEUzOfxNM7WSk3TODhU6bR
         GoRGB4Dw9x/6JKQnG7B0RiFgwlY9K8vFPzUK54jyiOieiJ8JGTZ0Lkbsrq6iT9mqdF
         7js9ft3nfamSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dg-007UVL-GK;
        Thu, 14 Jul 2022 16:20:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 04/20] KVM: arm64: Rely on index_to_param() for size checks on userspace access
Date:   Thu, 14 Jul 2022 16:20:08 +0100
Message-Id: <20220714152024.1673368-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

index_to_param() already checks that we use 64bit accesses for all
registers accessed from userspace.

However, we have extra checks in other places, which is pretty
confusing. Get rid on these checks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0fbdb21a3600..5dbe0f4b8167 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2871,9 +2871,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
-		return -ENOENT;
-
 	err = get_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
 		return err;
@@ -2906,9 +2903,6 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
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

