Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E496D0D36
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjC3R4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjC3R4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:56:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EDCCA2E
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF278B829B6
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4E1C433EF;
        Thu, 30 Mar 2023 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198965;
        bh=xWMRX51ZrqQJn0BxEAz0XFMVhNIxXA2JTvPLfqNyj18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icXAXYK7HxS38+LEWIcun78UbaKjkXnk5n3rq+9pjnlUZ9XmPRlGfgh/QkqyfxFGH
         MIQt9H1Zwt+ruOimKg1HqgOPsWUaeoOaQqefLGazMMGp6wY1U1AZwX2fLKHiQTcJjz
         ecIxTIFhwOJ+lRVAXTklHWyoOgaM6szBkP+drLOwqVlQNGYk6oSKsnvnzXiqXj3YG7
         z4msKDQW7Hhg46JVpq3SkJ8ol07vqNyoKXl+L1OFdWqaVB2VtRJUXi7Qz++WuZGOTm
         xjuQH8bS/g4Lcd/2ZOIxw9SYVnFfAcIjDxx83GZDEutpCtdw873Ki3CXFtYbbGsIWl
         m9SHI6zkmujnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNb-004Rpa-F1;
        Thu, 30 Mar 2023 18:48:07 +0100
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
Subject: [PATCH v4 14/20] KVM: arm64: timers: Abstract the number of valid timers per vcpu
Date:   Thu, 30 Mar 2023 18:47:54 +0100
Message-Id: <20230330174800.2677007-15-maz@kernel.org>
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

We so far have a pretty fixed number of timers to take care of.
This is about to change as NV brings another two into the
picture, and we must be careful not to try and emulate non-valid
timers in a given VM.

For this, abstract the number of timers for a given vcpu behind
an accessor, which helpfully returns a constant for now.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 1d811735e05f..d3a7902269c1 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -52,6 +52,11 @@ static bool has_cntpoff(void)
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
 }
 
+static int nr_timers(struct kvm_vcpu *vcpu)
+{
+	return NR_KVM_TIMERS;
+}
+
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
@@ -255,7 +260,7 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 	u64 min_delta = ULLONG_MAX;
 	int i;
 
-	for (i = 0; i < NR_KVM_TIMERS; i++) {
+	for (i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx = &vcpu->arch.timer_cpu.timers[i];
 
 		WARN(ctx->loaded, "timer %d loaded\n", i);
@@ -815,12 +820,12 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	for (int i = 0; i < NR_KVM_TIMERS; i++)
+	for (int i = 0; i < nr_timers(vcpu); i++)
 		timer_set_ctl(vcpu_get_timer(vcpu, i), 0);
 
 
 	if (timer->enabled) {
-		for (int i = 0; i < NR_KVM_TIMERS; i++)
+		for (int i = 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
 					     vcpu_get_timer(vcpu, i));
 
@@ -1303,7 +1308,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->kvm->arch.timer_data.lock);
 
-	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+	for (int i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx;
 		int irq;
 
@@ -1319,7 +1324,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 		ppis |= BIT(irq);
 	}
 
-	valid = hweight32(ppis) == NR_KVM_TIMERS;
+	valid = hweight32(ppis) == nr_timers(vcpu);
 
 	if (valid)
 		set_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE, &vcpu->kvm->arch.flags);
@@ -1336,7 +1341,7 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	if (WARN(!vcpu, "No vcpu context!\n"))
 		return false;
 
-	for (int i = 0; i < NR_KVM_TIMERS; i++) {
+	for (int i = 0; i < nr_timers(vcpu); i++) {
 		struct arch_timer_context *ctx;
 
 		ctx = vcpu_get_timer(vcpu, i);
-- 
2.34.1

