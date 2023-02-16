Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E722699726
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBPOWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjBPOWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:22:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28194C6F3
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51896B82849
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A3C433A8;
        Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557311;
        bh=rCEjLLVsTGonFud3H7BkWOpBovbyq0wpTVXBpO5J6GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coJ+WuougGjW/dNobIz865CknMyLAE5fjJdQEW+mGMmcDgUKxiNHIqyVTptljtaII
         +pfCAabezbp2pdA3AZ4kwkyiRywf5XBay8G0ME4nVO72pe/aXzmZrvZ4jTP6xQpifJ
         /88LDImUQHNa5qWxel2mdKlCpZrqpXSI9rUjPvUnCR4AYhpHS91ZN5KFylCAPm4hPA
         RIKzZxDjGsoC2LAzFuC9/PThvp3WEWmWEwNpueId0agGBM75Hp5nRL8KyzKsLz04Dq
         YY8Z68IPRuJtLJIrYfLc5uCFJGJZ2Yk4h88Puw62P9VbJ4D0maz2R2G/0yAj3HWKKp
         jh5Es3YIASw8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8v-00AuwB-93;
        Thu, 16 Feb 2023 14:21:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 09/16] KVM: arm64: timers: Allow save/restoring of the physical timer
Date:   Thu, 16 Feb 2023 14:21:16 +0000
Message-Id: <20230216142123.2638675-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing like being 10 year late to a party!

Now that userspace can set counter offsets, we can save/restore
the physical timer as well!

Nobody really cared so far, but you're welcome anyway.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 07444fa22888..46e910819de6 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -590,11 +590,16 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 	return copy_core_reg_indices(vcpu, NULL);
 }
 
-/**
- * ARM64 versions of the TIMER registers, always available on arm64
- */
+static const u64 timer_reg_list[] = {
+	KVM_REG_ARM_TIMER_CTL,
+	KVM_REG_ARM_TIMER_CNT,
+	KVM_REG_ARM_TIMER_CVAL,
+	KVM_REG_ARM_PTIMER_CTL,
+	KVM_REG_ARM_PTIMER_CNT,
+	KVM_REG_ARM_PTIMER_CVAL,
+};
 
-#define NUM_TIMER_REGS 3
+#define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
 
 static bool is_timer_reg(u64 index)
 {
@@ -602,6 +607,9 @@ static bool is_timer_reg(u64 index)
 	case KVM_REG_ARM_TIMER_CTL:
 	case KVM_REG_ARM_TIMER_CNT:
 	case KVM_REG_ARM_TIMER_CVAL:
+	case KVM_REG_ARM_PTIMER_CTL:
+	case KVM_REG_ARM_PTIMER_CNT:
+	case KVM_REG_ARM_PTIMER_CVAL:
 		return true;
 	}
 	return false;
@@ -609,14 +617,11 @@ static bool is_timer_reg(u64 index)
 
 static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	if (put_user(KVM_REG_ARM_TIMER_CTL, uindices))
-		return -EFAULT;
-	uindices++;
-	if (put_user(KVM_REG_ARM_TIMER_CNT, uindices))
-		return -EFAULT;
-	uindices++;
-	if (put_user(KVM_REG_ARM_TIMER_CVAL, uindices))
-		return -EFAULT;
+	for (int i = 0; i < NUM_TIMER_REGS; i++) {
+		if (put_user(timer_reg_list[i], uindices))
+			return -EFAULT;
+		uindices++;
+	}
 
 	return 0;
 }
-- 
2.34.1

