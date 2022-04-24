Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBDF50D02C
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 09:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiDXHM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 03:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbiDXHM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 03:12:57 -0400
Received: from out0-155.mail.aliyun.com (out0-155.mail.aliyun.com [140.205.0.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8931118356
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 00:09:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047207;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---.NWmtL54_1650784193;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NWmtL54_1650784193)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 24 Apr 2022 15:09:54 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <thuth@redhat.com>,
        <drjones@redhat.com>, "SU Hang" <darcy.sh@antgroup.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: replace `int 0x20` with `syscall`
Date:   Sun, 24 Apr 2022 15:09:51 +0800
Message-Id: <20220424070951.106990-2-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20220424070951.106990-1-darcy.sh@antgroup.com>
References: <20220424070951.106990-1-darcy.sh@antgroup.com>
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

Signed-off-by: SU Hang <darcy.sh@antgroup.com>
---
 lib/x86/usermode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index 477cb9f..e4cb899 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -12,7 +12,6 @@
 #include <stdint.h>
 
 #define USERMODE_STACK_SIZE	0x2000
-#define RET_TO_KERNEL_IRQ	0x20
 
 static jmp_buf jmpbuf;
 
@@ -40,9 +39,11 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 	static unsigned char user_stack[USERMODE_STACK_SIZE];
 
 	*raised_vector = 0;
-	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
 	handle_exception(fault_vector,
 			restore_exec_to_jmpbuf_exception_handler);
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SCE);
+	wrmsr(MSR_STAR, ((u64)(USER_CS32 << 16) | KERNEL_CS) << 32);
+	wrmsr(MSR_LSTAR, (u64)&ret_to_kernel);
 
 	if (setjmp(jmpbuf) != 0) {
 		*raised_vector = 1;
@@ -73,7 +74,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"mov %[arg4], %%rcx\n\t"
 			"call *%[func]\n\t"
 			/* Return to kernel via system call */
-			"int %[kernel_entry_vector]\n\t"
+			"syscall\n\t"
 			/* Kernel Mode */
 			"ret_to_kernel:\n\t"
 			"mov %[rsp0], %%rsp\n\t"
@@ -89,8 +90,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack +
-					sizeof(user_stack)),
-			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ)
+					sizeof(user_stack))
 			:
 			"rsi", "rdi", "rbx", "rcx", "rdx", "r8", "r9", "r10", "r11");
 
-- 
2.32.0.3.g01195cf9f

