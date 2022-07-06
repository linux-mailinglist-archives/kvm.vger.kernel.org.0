Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71418568F6F
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiGFQn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiGFQnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:43:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1B425E8B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21083B81E2F
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 16:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8838C341D0;
        Wed,  6 Jul 2022 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657125793;
        bh=HMb6ajlQxUTRun7Q6nGlrf2i9bo4p3LjMmMetu9dsjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFg4t11eQeEJZKAnDW1dBLFd9+LP17SdoR2wLx4QqK3TYiZD0wGhsBPNpwA1dprqn
         Kvm+8B5O7j6nK+KA/jSEHkNVV3Oh6ihlNMJTm/VJstGTt10ITzkQwsTEreJLVGFI6z
         GMKuJKrmZDMJUaUDJNE8OJf/W/6xyRzR7I4IoCwA8NBHKueJGvzydITn9Af3ZFsoT3
         CG/BFlpwmD5rqDpoaGfzj3hpvo6qBocxLZ6YdcTpUZqHdKJ2CaK8uMW7Rq/DD0nezF
         Mjh62XJxyOTY06nUQdSErxAs8lDel8c4ZSiiDYB/0h5Em4TI2u5jI5bMWtDQ5KnnRa
         JTua+NGyaMa7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987L-005h9i-Tm;
        Wed, 06 Jul 2022 17:43:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 06/19] KVM: arm64: Get rid of reg_from/to_user()
Date:   Wed,  6 Jul 2022 17:42:51 +0100
Message-Id: <20220706164304.1582687-7-maz@kernel.org>
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

These helpers are only used by the invariant stuff now, and while
they pretend to support non-64bit registers, this only serves as
a way to scare the casual reviewer...

Replace these helpers with our good friends get/put_user(), and
don't look back.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1ce439eed3d8..b66be9df7a02 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,8 +44,6 @@
  * 64bit interface.
  */
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -2661,21 +2659,7 @@ static struct sys_reg_desc invariant_sys_regs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
-{
-	if (copy_from_user(val, uaddr, KVM_REG_SIZE(id)) != 0)
-		return -EFAULT;
-	return 0;
-}
-
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
-{
-	if (copy_to_user(uaddr, val, KVM_REG_SIZE(id)) != 0)
-		return -EFAULT;
-	return 0;
-}
-
-static int get_invariant_sys_reg(u64 id, void __user *uaddr)
+static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
 {
 	const struct sys_reg_desc *r;
 
@@ -2684,23 +2668,24 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 	if (!r)
 		return -ENOENT;
 
-	return reg_to_user(uaddr, &r->val, id);
+	if (put_user(r->val, uaddr))
+		return -EFAULT;
+
+	return 0;
 }
 
-static int set_invariant_sys_reg(u64 id, void __user *uaddr)
+static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
 {
 	const struct sys_reg_desc *r;
-	int err;
-	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
+	u64 val;
 
 	r = get_reg_by_id(id, invariant_sys_regs,
 			  ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
+	if (get_user(val, uaddr))
+		return -EFAULT;
 
 	/* This is what we mean by invariant: you can't change it. */
 	if (r->val != val)
-- 
2.34.1

