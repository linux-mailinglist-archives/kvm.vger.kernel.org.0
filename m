Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FA16C80C7
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjCXPLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjCXPK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01FC132F7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F8C62B54
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC22DC433EF;
        Fri, 24 Mar 2023 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679670657;
        bh=d5w/0sfkh44NdYDUsZ4zlkAagu8vzvh1sveYsdMQVFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xm2DHCfZtNt2Ff7ELEUqe0qnDjJg/7lYkzJUk2/8dY3w3SdocDsW7X5Z7cywP54yl
         h+Bq8J/XyEUGSFWdXGyjBvQtUXUDjzKAjogMuiw0URBfKseQPaHL547LujDhr1me3e
         sYhLf31KiVTZYQF7XoCd0oj/LDQcTXkspsAU9vMYFxvnjDqdgqxuw25X9EHnO3gsGO
         OSfXKXZcmInUri/BIgKkL0SCeRTTMfiwgf5B5MfaNEfNi1M1dEBe8VoQ/gFqi6/U5z
         zAhjDxBydP2HLSLPl+FQHu6VZqhntirS2zbTZ3p2nQA/vCImDPAFuKNErwSXvqc23U
         NV/G/aA90OlmQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihM-002qBP-Am;
        Fri, 24 Mar 2023 14:47:20 +0000
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
Subject: [PATCH v3 14/18] KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
Date:   Fri, 24 Mar 2023 14:47:00 +0000
Message-Id: <20230324144704.4193635-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
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
 arch/arm64/kvm/arch_timer.c  | 13 ++++++++++---
 include/kvm/arm_arch_timer.h |  5 +++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 11047b3dfb5b..9666e0d0423e 100644
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

