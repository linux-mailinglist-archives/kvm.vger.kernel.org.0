Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6B5751A6
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbiGNPUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240056AbiGNPUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:20:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2DD52DE9
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3976AB8271D
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC292C341CE;
        Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812030;
        bh=EZIbFZxkgQ+LV9Ht7OcrMwgab7G8/qq0lLC9OFEhEcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUXANxU1nm5F5RWgolaGSwq4rnuuzHIAZl/5q7q/QMnY5hvgGQowkcKIYNGUd3crI
         japnqsu//NrFQPx1Lpgk6URJZpwXt1n7AyJc3zjWaN0Het2u8VPcu0JGbPolaC5RZ9
         +DO3gr1sksBu5zMXzcv1PLNSKkYJsRd1rMCe28tJVgKVCBeGNrLxmSJdV9u3Hz3K2i
         kb4Xmu6j/pCm06KlDpg00nfBmP1qCBRTNpGDdttcTVeety+OooRVymp/AubXTpMbVI
         4IPAyVumiUzykcozP/pIgdkjfl7sfU5UfAtJoeRAX+3r+KCPI8X0z/wsK7iBsHDW1v
         G7ijw79HzzojA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dg-007UVL-Vg;
        Thu, 14 Jul 2022 16:20:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 06/20] KVM: arm64: Get rid of reg_from/to_user()
Date:   Thu, 14 Jul 2022 16:20:10 +0100
Message-Id: <20220714152024.1673368-7-maz@kernel.org>
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

These helpers are only used by the invariant stuff now, and while
they pretend to support non-64bit registers, this only serves as
a way to scare the casual reviewer...

Replace these helpers with our good friends get/put_user(), and
don't look back.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 526798524697..379478eecfaa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,8 +44,6 @@
  * 64bit interface.
  */
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -2657,21 +2655,7 @@ static struct sys_reg_desc invariant_sys_regs[] = {
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
 
@@ -2680,23 +2664,21 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 	if (!r)
 		return -ENOENT;
 
-	return reg_to_user(uaddr, &r->val, id);
+	return put_user(r->val, uaddr);
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

