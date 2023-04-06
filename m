Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF8C6D907A
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbjDFHdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbjDFHdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:33:16 -0400
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7776210CE
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:33:15 -0700 (PDT)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 521E87F00053;
        Thu,  6 Apr 2023 15:33:13 +0800 (CST)
From:   lirongqing@baidu.com
To:     pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, seanjc@google.com, lirongqing@baidu.com
Subject: [PATCH][v2] x86/kvm: Don't check vCPU preempted if vCPU has dedicated pCPU and non-trap HLT
Date:   Thu,  6 Apr 2023 15:33:13 +0800
Message-Id: <1680766393-46220-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

Check whether vCPU is preempted or not only when HLT is trapped or
there is not realtime hint. In other words, it is unnecessary to check
preemption when vCPU has realtime hint (which means vCPU has dedicated
pCP) and has not PV_UNHALT (which means unintercepted HLT), because
vCPU should not to be marked as preempted in this setup.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: rewrite changelog and indentation

 arch/x86/kernel/kvm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..25398d2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -820,8 +820,10 @@ static void __init kvm_guest_init(void)
 		has_steal_clock = 1;
 		static_call_update(pv_steal_clock, kvm_steal_clock);
 
-		pv_ops.lock.vcpu_is_preempted =
-			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
+		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
+			!kvm_para_has_hint(KVM_HINTS_REALTIME))
+			pv_ops.lock.vcpu_is_preempted =
+				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-- 
2.9.4

