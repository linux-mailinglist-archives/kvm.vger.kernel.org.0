Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44674C3C9B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 04:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiBYDpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 22:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbiBYDpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 22:45:38 -0500
X-Greylist: delayed 63621 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 19:45:06 PST
Received: from bddwd-sys-mailin02.bddwd.baidu.com (mx408.baidu.com [124.64.200.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 374E056419
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 19:45:05 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin02.bddwd.baidu.com (Postfix) with ESMTP id E1147F9000C8;
        Fri, 25 Feb 2022 11:44:24 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id DC47CD9932;
        Fri, 25 Feb 2022 11:44:24 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, lirongqing@baidu.com
Subject: [PATCH][resend] KVM: x86: Yield to IPI target vCPU only if it is busy
Date:   Fri, 25 Feb 2022 11:44:24 +0800
Message-Id: <1645760664-26028-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When sending a call-function IPI-many to vCPUs, yield to the
IPI target vCPU which is marked as preempted.

but when emulating HLT, an idling vCPU will be voluntarily
scheduled out and mark as preempted from the guest kernel
perspective. yielding to idle vCPU is pointless and increase
unnecessary vmexit, maybe miss the true preempted vCPU

so yield to IPI target vCPU only if vCPU is busy and preempted

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 355fe8b..58749f2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -619,7 +619,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 
 	/* Make sure other vCPUs get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
-		if (vcpu_is_preempted(cpu)) {
+		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
 			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
 			break;
 		}
-- 
2.9.4

