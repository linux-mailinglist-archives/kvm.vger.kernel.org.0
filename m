Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FD16E1463
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjDMSnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1CC83F5
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s12so6687800wrb.1
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411362; x=1684003362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1ne7VVT4agLFjOnm1Owk3nY9/vLSYqIcSHVXPl3cSM=;
        b=d3A7u3S8OrvxRtioAoHkP9p9cXs/jojcn5m5j9ntlB9U4GN7RTuTjR6bvyXCDzRT1q
         YanXVnOo9+UQfV6+FtwB1MgPSuBB3Mo+wKeQkNgaNBWVm7G05FB4/T78vzsqBZ8QJFmC
         zGj+vl7l4bpxiMuOUt2QJ4S/KzjlJhZPlwXniGyAs1R4jQpBBAH1Hw4gPePYDGpG050p
         iPh75xGqA0X9X3MRsr9QTUHPf8sygN/JzUcotFxfvqi+heU2nM+LicRlTRUfT/xJvMKf
         fU+9aXMG1vlIlZjRt99O7fS5R4QoL40iRDJfwJuZuYZBEJbaOLWGGBaTttQPAcFj+F3j
         au2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411362; x=1684003362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1ne7VVT4agLFjOnm1Owk3nY9/vLSYqIcSHVXPl3cSM=;
        b=Tn7BPG7VWcEO2xU0OG4vWoW8ubLDyH+pjkhgrzE02qMqMYydWlYcZIzSb3zTfXhUvg
         cWPzXj0Jo+LWBU6UCwJhdl2pTbE68m1R5GCKBnCzZe6UwVyys2hpbP2gCLcWEN56UyCY
         Qm9rIH/QRprsP/kBOrB2McrdiMtb0xA5ktMPNjCg4meHPcbGMulRUDRWM4JaGo2F1lII
         pM4Rb+P0Xlq6bfUTYIFtNViVsY1VcrhuNjoB7ONpHlawVh5RIQ0z6UPnrhaZGgrPsXs+
         mT2Ivv1gFn112OIGnxR8v9aNMZ7+ShhT6QCF4iktbjnOkHvZu1O/OYE2blTvhFAMvttj
         fcoQ==
X-Gm-Message-State: AAQBX9cE/3Yj4SweRLv6WltL0U/LqUGZ+1xLrYj5BgyVYxSwy7BivdlD
        asor/lUDm0xzDT6NY5vhOCYtgA==
X-Google-Smtp-Source: AKy350YGiq2e/11hdnVQ/NAURvYhzy/uQ31HZlUfoNCvse4DWwfAut9zaXr2t7+zSqRbCaTtb4XiSA==
X-Received: by 2002:adf:f388:0:b0:2d6:d05a:1fe0 with SMTP id m8-20020adff388000000b002d6d05a1fe0mr2325978wro.64.1681411362056;
        Thu, 13 Apr 2023 11:42:42 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 08/16] x86/run_in_user: Relax register constraints of inline asm
Date:   Thu, 13 Apr 2023 20:42:11 +0200
Message-Id: <20230413184219.36404-9-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code doesn't clobber all the registers it states it would. It
explicitly preserves the values of rcx, rdi and rsi. With a minor code
change rdx can be preserved as well. The code does, however, needlessly
save and restore rbx around the function call.

Change the code to not clobber rdx and drop all the register clobbers
from the asm constraints, as these registers are, in fact, preserved.
The function call either returns without throwing an exception (and
restoring all call clobbered registers itself) or via longjmp() (doing
the same, basically, but with special handling in the compiler as well).

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/usermode.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index 10fcea288a62..fd19551a7a2d 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -63,21 +63,20 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"pushq %[user_stack_top]\n\t"
 			"pushfq\n\t"
 			"pushq %[user_cs]\n\t"
-			"lea user_mode(%%rip), %%rdx\n\t"
-			"pushq %%rdx\n\t"
+			"lea user_mode(%%rip), %%rax\n\t"
+			"pushq %%rax\n\t"
 			"iretq\n"
 
 			"user_mode:\n\t"
-			/* Back up registers before invoking func */
-			"push %%rbx\n\t"
+			/* Back up volatile registers before invoking func */
 			"push %%rcx\n\t"
 			"push %%rdx\n\t"
+			"push %%rdi\n\t"
+			"push %%rsi\n\t"
 			"push %%r8\n\t"
 			"push %%r9\n\t"
 			"push %%r10\n\t"
 			"push %%r11\n\t"
-			"push %%rdi\n\t"
-			"push %%rsi\n\t"
 			/* Call user mode function */
 			"mov %[arg1], %%rdi\n\t"
 			"mov %[arg2], %%rsi\n\t"
@@ -85,15 +84,14 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"mov %[arg4], %%rcx\n\t"
 			"call *%[func]\n\t"
 			/* Restore registers */
-			"pop %%rsi\n\t"
-			"pop %%rdi\n\t"
 			"pop %%r11\n\t"
 			"pop %%r10\n\t"
 			"pop %%r9\n\t"
 			"pop %%r8\n\t"
+			"pop %%rsi\n\t"
+			"pop %%rdi\n\t"
 			"pop %%rdx\n\t"
 			"pop %%rcx\n\t"
-			"pop %%rbx\n\t"
 			/* Return to kernel via system call */
 			"int %[kernel_entry_vector]\n\t"
 			/* Kernel Mode */
@@ -112,9 +110,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack +
 					sizeof(user_stack)),
-			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ)
-			:
-			"rsi", "rdi", "rcx", "rdx");
+			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ));
 
 	handle_exception(fault_vector, old_ex);
 
-- 
2.39.2

