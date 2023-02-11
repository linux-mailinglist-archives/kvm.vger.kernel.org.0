Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA669316C
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 15:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBKOGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 09:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBKOGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 09:06:45 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EFA025B91
        for <kvm@vger.kernel.org>; Sat, 11 Feb 2023 06:06:42 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id B26417F00043;
        Sat, 11 Feb 2023 22:06:39 +0800 (CST)
From:   lirongqing@baidu.com
To:     pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] x86/kvm: Don't use PVspinlock when mwait is advertised
Date:   Sat, 11 Feb 2023 22:06:39 +0800
Message-Id: <1676124399-16542-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

MWAIT is advertised in host is not overcommitted scenario, however,
pvspinlock should be enabled in host overcommitted scenario. Let's
add the MWAIT checking when enabling pvspinlock

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..dfa1451 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1087,6 +1087,11 @@ void __init kvm_spinlock_init(void)
 		goto out;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_MWAIT)) {
+		pr_info("PV spinlocks disabled with mwait\n");
+		goto out;
+	}
+
 	if (num_possible_cpus() == 1) {
 		pr_info("PV spinlocks disabled, single CPU\n");
 		goto out;
-- 
2.9.4

