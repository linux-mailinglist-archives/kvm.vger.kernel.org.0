Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E776D8DB7
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbjDFCwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbjDFCv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:51:59 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A515F974F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 126-20020a630284000000b005135edbb985so9784378pgc.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Pg/t5eKKcauYZOGS2LFUsmCQ+1p6GjxyESTrzGnm0pI=;
        b=W42cmTp/7CQXc8fkvRG+L+uZ6JR+Xkouct1f3c3JtRxLrGDA1G05BjNsS/HR17TDgV
         bRoYkj7BAxyh2zKh8bI+EJZyISo/bIxvsJw7vOxNnU9eKKijz/MvP1h33vNXWm1NSMr1
         KFyjaJ8/U7qnUfTkxGDluizXHCL2vgR8N2CWLnhSolxgebBkf179PwlTsomxNNPHQAsn
         T2QzQpxTuJjUsiYgeYYZBmK/RvALW/+umzijwe0lXl74XMZQO6ZrSt23Na3tGyvJbA85
         0IGT8MkPleZ81/KFYEwUB4+SlZbyzP41FPErTGt1NMw05eSiLYkMOh3r4+chkn+CFlS0
         ic8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pg/t5eKKcauYZOGS2LFUsmCQ+1p6GjxyESTrzGnm0pI=;
        b=ChmQrejLHkAHPewJm+LzWqSaKYnzEzOuS7YU1GTUcp9RXHsG0nGMOagS9xLqbhrpWL
         l7bWULf4fYbAEuteGN54Y37viIVt+wjW3+zDfvGAgXSfPXcJM4Tg9vTme2OoQ6F7vPvD
         zIUJC48hXIWs77aSxgN1RrrzaHvkmi1FEqqNTXrkOGPOT5WQqEAHHVReeQLqGYob7Szz
         otiukGG7zwqWOF7TAleRipP6QRHplmxBVtGsQnCkUGMz9zCQCW1aQf+nl0UB3Vgybsfx
         7Z9RkTGjioMD4jC/22skyvfQFWnm0NyegjaHJzIWtK5Csdf9VqRPs4+Es5PUdBa3uwiG
         iKLA==
X-Gm-Message-State: AAQBX9cEyz4pTbATVJB5MCEyz1dVbN+UKc3dF5/URQNg93BWsQdrBkF4
        RrEf7r9fNk5KsDdkLyGOaHhwRoIT7xE=
X-Google-Smtp-Source: AKy350YwsE4pKtAXhOTX0faSUeo8exEJu25iKGG5OdmnvpdXzr0A0tpy31tuJsY3HdYs/ED4yf5NaET7jEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c7:b0:1a2:185a:cd6 with SMTP id
 e7-20020a17090301c700b001a2185a0cd6mr3616513plh.4.1680749481167; Wed, 05 Apr
 2023 19:51:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:13 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/5] x86: Add macros to wrap ASM_TRY() for
 single instructions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add asm_safe(), asm_safe_report(), and asm_safe_report_ex() macros to
reduce the boilerplate needed for using ASM_TRY() with a single
instruction.

Convert the memory test to the report variants to showcase the usage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h | 26 ++++++++++++++++++++++
 x86/memory.c   | 60 ++++++++++++--------------------------------------
 2 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index c023b932..8079d462 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -272,4 +272,30 @@ extern gdt_entry_t *get_tss_descr(void);
 extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
 extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 
+#define asm_safe(insn, inputs...)					\
+({									\
+	asm volatile(ASM_TRY("1f")					\
+		     insn "\n\t"					\
+		     "1:\n\t"						\
+		     :							\
+		     : inputs						\
+		     : "memory");					\
+	exception_vector();						\
+})
+
+#define __asm_safe_report(want, insn, inputs...)			\
+do {									\
+	int vector = asm_safe(insn, inputs);				\
+									\
+	report(vector == want, "Expected %s on '%s', got %s",		\
+	       want ? exception_mnemonic(want) : "SUCCESS",		\
+	       insn,							\
+	       vector ? exception_mnemonic(vector) : "SUCCESS");	\
+} while (0)
+
+#define asm_safe_report(insn, inputs...)				\
+	__asm_safe_report(0, insn, inputs)
+
+#define asm_safe_report_ex __asm_safe_report
+
 #endif
diff --git a/x86/memory.c b/x86/memory.c
index 58ef835e..ebfeceae 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -14,76 +14,44 @@
 #include "processor.h"
 
 static long target;
-static volatile int ud;
-static volatile int isize;
-
-static void handle_ud(struct ex_regs *regs)
-{
-	ud = 1;
-	regs->rip += isize;
-}
 
 int main(int ac, char **av)
 {
-	handle_exception(UD_VECTOR, handle_ud);
-
-	/* 3-byte instructions: */
-	isize = 3;
-
-	if (this_cpu_has(X86_FEATURE_CLFLUSH)) { /* CLFLUSH */
-		ud = 0;
-		asm volatile("clflush (%0)" : : "b" (&target));
-		report(!ud, "clflush");
-	} else {
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		asm_safe_report("clflush (%0)", "b" (&target));
+	else
 		report_skip("clflush");
-	}
 
-	if (this_cpu_has(X86_FEATURE_XMM)) { /* SSE */
-		ud = 0;
-		asm volatile("sfence");
-		report(!ud, "sfence");
-	} else {
+	if (this_cpu_has(X86_FEATURE_XMM))
+		asm_safe_report("sfence");
+	else
 		report_skip("sfence");
-	}
 
-	if (this_cpu_has(X86_FEATURE_XMM2)) { /* SSE2 */
-		ud = 0;
-		asm volatile("lfence");
-		report(!ud, "lfence");
-		ud = 0;
-		asm volatile("mfence");
-		report(!ud, "mfence");
+	if (this_cpu_has(X86_FEATURE_XMM2)) {
+		asm_safe_report("lfence");
+		asm_safe_report("mfence");
 	} else {
 		report_skip("lfence");
 		report_skip("mfence");
 	}
 
-	/* 4-byte instructions: */
-	isize = 4;
-
-	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT)) { /* CLFLUSHOPT */
-		ud = 0;
+	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT)) {
 		/* clflushopt (%rbx): */
-		asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
-		report(!ud, "clflushopt");
+		asm_safe_report(".byte 0x66, 0x0f, 0xae, 0x3b", "b" (&target));
 	} else {
 		report_skip("clflushopt");
 	}
 
-	if (this_cpu_has(X86_FEATURE_CLWB)) { /* CLWB */
-		ud = 0;
+	if (this_cpu_has(X86_FEATURE_CLWB)) {
 		/* clwb (%rbx): */
-		asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
-		report(!ud, "clwb");
+		asm_safe_report(".byte 0x66, 0x0f, 0xae, 0x33", "b" (&target));
 	} else {
 		report_skip("clwb");
 	}
 
 	if (this_cpu_has(X86_FEATURE_PCOMMIT)) { /* PCOMMIT */
-		ud = 0;
 		/* pcommit: */
-		asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
-		report(!ud, "pcommit");
+		asm_safe_report(".byte 0x66, 0x0f, 0xae, 0xf8");
 	} else {
 		report_skip("pcommit");
 	}
-- 
2.40.0.348.gf938b09366-goog

