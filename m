Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFDF697B85
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 13:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbjBOMMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 07:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbjBOMMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 07:12:35 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0176137F05
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 04:12:32 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 44B947F0005E;
        Wed, 15 Feb 2023 20:12:31 +0800 (CST)
From:   lirongqing@baidu.com
To:     kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Date:   Wed, 15 Feb 2023 20:12:31 +0800
Message-Id: <20230215121231.43436-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

Check whether vcpu is preempted or not when HLT is trapped or there
is not realtime hint.
In other words, it is unnecessary to check preemption if HLT is not
intercepted and guest has realtime hint

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..1a2744d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -820,8 +820,10 @@ static void __init kvm_guest_init(void)
 		has_steal_clock = 1;
 		static_call_update(pv_steal_clock, kvm_steal_clock);
 
-		pv_ops.lock.vcpu_is_preempted =
-			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
+		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
+		     !kvm_para_has_hint(KVM_HINTS_REALTIME))
+			pv_ops.lock.vcpu_is_preempted =
+				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-- 
2.9.4

