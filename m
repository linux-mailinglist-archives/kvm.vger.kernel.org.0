Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0186688E1A
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 04:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBCDlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 22:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBCDlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 22:41:53 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BCABEF94
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 19:41:52 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 6A5407F00047;
        Fri,  3 Feb 2023 11:41:50 +0800 (CST)
From:   lirongqing@baidu.com
To:     kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86: Enable PIT shutdown quirk
Date:   Fri,  3 Feb 2023 11:41:50 +0800
Message-Id: <1675395710-37220-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

KVM emulation of the PIT has a quirk such that the normal PIT shutdown
path doesn't work, because clearing the counter register restarts the
timer.

Disable the counter clearing on PIT shutdown as in Hyper-V

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..14411b6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -43,6 +43,7 @@
 #include <asm/reboot.h>
 #include <asm/svm.h>
 #include <asm/e820/api.h>
+#include <linux/i8253.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -978,6 +979,9 @@ static void __init kvm_init_platform(void)
 			wrmsrl(MSR_KVM_MIGRATION_CONTROL,
 			       KVM_MIGRATION_READY);
 	}
+
+	i8253_clear_counter_on_shutdown = false;
+
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
-- 
2.9.4

