Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FBD688E49
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 04:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBCD4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 22:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjBCD4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 22:56:52 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1ADC2A150
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 19:56:50 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 5CF427F00053;
        Fri,  3 Feb 2023 11:56:48 +0800 (CST)
From:   lirongqing@baidu.com
To:     kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86: PIT: fix PIT shutdown
Date:   Fri,  3 Feb 2023 11:56:48 +0800
Message-Id: <1675396608-24164-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

pit_shutdown() in drivers/clocksource/i8253.c doesn't work because
setting the counter register to zero causes the PIT to start running
again, negating the shutdown.

fix it by stopping pit timer and zeroing channel count

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/i8254.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index e0a7a0e..c8a51f5 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -358,13 +358,15 @@ static void create_pit_timer(struct kvm_pit *pit, u32 val, int is_period)
 		}
 	}
 
-	hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
+	if (interval)
+		hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
 		      HRTIMER_MODE_ABS);
 }
 
 static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
 {
 	struct kvm_kpit_state *ps = &pit->pit_state;
+	u32 org = val;
 
 	pr_debug("load_count val is %u, channel is %d\n", val, channel);
 
@@ -386,6 +388,9 @@ static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
 	 * mode 1 is one shot, mode 2 is period, otherwise del timer */
 	switch (ps->channels[0].mode) {
 	case 0:
+		val = org;
+		ps->channels[channel].count = val;
+		fallthrough;
 	case 1:
         /* FIXME: enhance mode 4 precision */
 	case 4:
-- 
2.9.4

