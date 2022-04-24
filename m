Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF750D026
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 09:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiDXHFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 03:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiDXHFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 03:05:15 -0400
Received: from out0-155.mail.aliyun.com (out0-155.mail.aliyun.com [140.205.0.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723AF165AC
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 00:02:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---.NWn1VzK_1650783730;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NWn1VzK_1650783730)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 24 Apr 2022 15:02:11 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <thuth@redhat.com>,
        <drjones@redhat.com>, "SU Hang" <darcy.sh@antgroup.com>
Subject: [PATCH 1/2] x86: replace `push` `pop` with callee-clobbered list
Date:   Sun, 24 Apr 2022 15:02:06 +0800
Message-Id: <20220424070207.123597-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stopping mess up asm callee-clobbered list with `push` `pop`,
clean up code to make it more readable.

Signed-off-by: SU Hang <darcy.sh@antgroup.com>
---
 lib/x86/usermode.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index e22fb8f..477cb9f 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -66,32 +66,12 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"iretq\n"
 
 			"user_mode:\n\t"
-			/* Back up registers before invoking func */
-			"push %%rbx\n\t"
-			"push %%rcx\n\t"
-			"push %%rdx\n\t"
-			"push %%r8\n\t"
-			"push %%r9\n\t"
-			"push %%r10\n\t"
-			"push %%r11\n\t"
-			"push %%rdi\n\t"
-			"push %%rsi\n\t"
 			/* Call user mode function */
 			"mov %[arg1], %%rdi\n\t"
 			"mov %[arg2], %%rsi\n\t"
 			"mov %[arg3], %%rdx\n\t"
 			"mov %[arg4], %%rcx\n\t"
 			"call *%[func]\n\t"
-			/* Restore registers */
-			"pop %%rsi\n\t"
-			"pop %%rdi\n\t"
-			"pop %%r11\n\t"
-			"pop %%r10\n\t"
-			"pop %%r9\n\t"
-			"pop %%r8\n\t"
-			"pop %%rdx\n\t"
-			"pop %%rcx\n\t"
-			"pop %%rbx\n\t"
 			/* Return to kernel via system call */
 			"int %[kernel_entry_vector]\n\t"
 			/* Kernel Mode */
@@ -112,7 +92,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 					sizeof(user_stack)),
 			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ)
 			:
-			"rsi", "rdi", "rcx", "rdx");
+			"rsi", "rdi", "rbx", "rcx", "rdx", "r8", "r9", "r10", "r11");
 
 	return rax;
 }
-- 
2.32.0.3.g01195cf9f

