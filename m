Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C166D0D39
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjC3R4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjC3R4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:56:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB241DBE6
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84ADEB829B8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3838BC433D2;
        Thu, 30 Mar 2023 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198970;
        bh=QSNuoE4WKIinc81Nl2DkN9WxEvvW5FD/DblmdsUhTX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8nSrACO3lW4lUQPNnLaEX6V4U4H/piSXmPklFb0G443t0Pc+dykYWaiC0i5ezuXs
         zQbfveP89YmGH5Pezs5xFrjcxkzH8Dr9Cq7dyDNvmxB/NCuyu9OLBn5fSOydDAckLn
         o3BPJJfmAjyckPDVmGEfOEbjT3qUtvcgctWuei4MHBvryB4rRbHTFfkl2RGMIumWwG
         RI/9NPLP5H6rQni1VzPgbukvAnQfPdWKL+obsKIKoCLWfU2fE+DbVRCeyJLsdAX1AZ
         +diU0b7B9iLAlxXvPzpl0FnQeAqvCN6+BQIKncn4Ak1aLHkze7IhnRBQV4XSynzgd+
         AUz6RVckvi3wQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNb-004Rpa-V9;
        Thu, 30 Mar 2023 18:48:08 +0100
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
Subject: [PATCH v4 16/20] KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
Date:   Thu, 30 Mar 2023 18:47:56 +0100
Message-Id: <20230330174800.2677007-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Being able to set a global offset isn't enough.

With NV, we also need to a per-vcpu, per-timer offset (for example,
CNTVCT_EL0 being offset by CNTVOFF_EL2).

Use a similar method as the VM-wide offset to have a timer point
to the shadow register that contains the offset value.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c             | 13 ++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 ++
 include/kvm/arm_arch_timer.h            |  5 +++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d3a7902269c1..b87bf182af33 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -89,10 +89,17 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	if (ctxt && ctxt->offset.vm_offset)
-		return *ctxt->offset.vm_offset;
+	u64 offset = 0;
 
-	return 0;
+	if (!ctxt)
+		return 0;
+
+	if (ctxt->offset.vm_offset)
+		offset += *ctxt->offset.vm_offset;
+	if (ctxt->offset.vcpu_offset)
+		offset += *ctxt->offset.vcpu_offset;
+
+	return offset;
 }
 
 static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9954368f639d..d07cbc313889 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -353,6 +353,8 @@ static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 
 	if (ctxt->offset.vm_offset)
 		val -= *kern_hyp_va(ctxt->offset.vm_offset);
+	if (ctxt->offset.vcpu_offset)
+		val -= *kern_hyp_va(ctxt->offset.vcpu_offset);
 
 	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
 	__kvm_skip_instr(vcpu);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f093ea9f540d..209da0c2ac9f 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -29,6 +29,11 @@ struct arch_timer_offset {
 	 * structure. If NULL, assume a zero offset.
 	 */
 	u64	*vm_offset;
+	/*
+	 * If set, pointer to one of the offsets in the vcpu's sysreg
+	 * array. If NULL, assume a zero offset.
+	 */
+	u64	*vcpu_offset;
 };
 
 struct arch_timer_vm_data {
-- 
2.34.1

