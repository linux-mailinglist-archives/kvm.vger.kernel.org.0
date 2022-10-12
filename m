Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E606C5FC5E2
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJLNFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 09:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJLNFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 09:05:23 -0400
X-Greylist: delayed 621 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 06:05:20 PDT
Received: from bddwd-sys-mailin04.bddwd.baidu.com (mx408.baidu.com [124.64.200.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4441A5209F
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 06:05:19 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin04.bddwd.baidu.com (Postfix) with ESMTP id D9FE413D8002E
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 20:54:28 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id CE838D9932
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 20:54:28 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org
Subject: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer is in one shot mode
Date:   Wed, 12 Oct 2022 20:54:28 +0800
Message-Id: <1665579268-7336-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In one-shot mode, the APIC timer stops counting when the timer
reaches zero, so don't reset deadline to period for one shot mode

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989..bf39027 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1840,8 +1840,12 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
 		if (unlikely(count_reg != APIC_TMICT)) {
 			deadline = tmict_to_ns(apic,
 				     kvm_lapic_get_reg(apic, count_reg));
-			if (unlikely(deadline <= 0))
-				deadline = apic->lapic_timer.period;
+			if (unlikely(deadline <= 0)) {
+				if (apic_lvtt_period(apic))
+					deadline = apic->lapic_timer.period;
+				else
+					deadline = 0;
+			}
 			else if (unlikely(deadline > apic->lapic_timer.period)) {
 				pr_info_ratelimited(
 				    "kvm: vcpu %i: requested lapic timer restore with "
-- 
2.9.4

