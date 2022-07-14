Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2B957519A
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbiGNPUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiGNPUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395DA5B06C
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0E461F20
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29728C341C6;
        Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812030;
        bh=TOS4K//cGp6VnKD99TfdRSJHWQhgh40bPzwH9f3DAro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDC9ETXklTvY/I1hHjyQfwUmqngXDa1trido3q/Zk0bqPUY3X/xHEAEe4PY8wydMM
         vmI08zd1sXw4gA4jgvr/emhNy/GnrWGKYaeg+/xWxiJYRD3KnQt7UkDqGy2cIAtAfq
         UAKHvTbakLytpYjSlPiJjqEPGeCmqE73BIO6a6CTwCeOUhjBeyAoLEMm7YRr2ZcKm/
         p+LDu2Xj5jD5pMmTw1AubbgDL0NzP4S1d0xuDl/k4Qt3SBijY5BVmb0hAUPH7y4C8k
         1gOx+25/nqBScGcxtzYjaSJ1Mi1m4TJnhkBb/euFVYODDwgfGuzoS3f3IL22JxmWRN
         wiBmx+KJQxTZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dg-007UVL-28;
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
Subject: [PATCH v2 02/20] KVM: arm64: Reorder handling of invariant sysregs from userspace
Date:   Thu, 14 Jul 2022 16:20:06 +0100
Message-Id: <20220714152024.1673368-3-maz@kernel.org>
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

In order to allow some further refactor of the sysreg helpers,
move the handling of invariant sysreg to occur before we handle
all the other ones.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1f410283c592..9291cb94c2e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2849,6 +2849,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
@@ -2856,12 +2857,14 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
 		return -ENOENT;
 
+	err = get_invariant_sys_reg(reg->id, uaddr);
+	if (err != -ENOENT)
+		return err;
+
 	r = index_to_sys_reg_desc(vcpu, reg->id);
-	if (!r)
-		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -2874,6 +2877,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(reg->id, uaddr);
@@ -2881,12 +2885,14 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
 		return -ENOENT;
 
+	err = set_invariant_sys_reg(reg->id, uaddr);
+	if (err != -ENOENT)
+		return err;
+
 	r = index_to_sys_reg_desc(vcpu, reg->id);
-	if (!r)
-		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
-- 
2.34.1

