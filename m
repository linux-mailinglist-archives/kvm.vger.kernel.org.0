Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948F06D0D21
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjC3Rs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbjC3RsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:48:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4702DEC73
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1671EB829BB
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA547C4339E;
        Thu, 30 Mar 2023 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198487;
        bh=F41qBULujmWLiGNaRxVAWAXUjdWyWI4MtIGX+yVW8OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9EOhLc/ntwzM/AOorEbMCrNR+m7lDIbENsrgKoV6SePFPOY09vvxJU67I0QxKflw
         Cbk4zmc1iuGwReG9WIQP0wdqan0q3lsT4mX+/7dyDliXuPI4t7PG64iS1RcOEuOiIM
         SBIQFzT3pcEWmVx1FBnox36g6lQy7qMtq07xtCOSZQlku4dZ21uX+JaBEJtw8jHKff
         ghrqaB8Agmx+a3XsO+wvjoj5M4XyiJOyi+t+2CqYTX4SKlNRQ5m97aPGCNXi7W5Y0y
         6bhcLHnS6e2r+3xRZUANAw9D6E+J0EVSnRtnma42ELPlxZ5+CAZPP2LoA2BzN2I4Ur
         M2yqjXIdWiEjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNZ-004Rpa-P1;
        Thu, 30 Mar 2023 18:48:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v4 08/20] KVM: arm64: timers: Allow save/restoring of the physical timer
Date:   Thu, 30 Mar 2023 18:47:48 +0100
Message-Id: <20230330174800.2677007-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing like being 10 year late to a party!

Now that userspace can set counter offsets, we can save/restore
the physical timer as well!

Nobody really cared so far, but you're welcome anyway.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
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

