Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6626262D67F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiKQJVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiKQJVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:21:41 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96C5AF0AE
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:36 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-370624ca2e8so13821947b3.16
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=enyhkTrmG/faoR4D5x/rqcK/lRFOCXWHV83l/oLzMzA=;
        b=BHwbZvfaaesU94eBOlfv384l2kHY3e8Pn6cC3XTVjCwbEOQPrZv0YueEN76M2iQkoy
         tQW2nWerSjGcWTaBjQ6i9QdHstRkZs1ZXIEBFRj1YfCoP2XJeGljVNWdh4nTi1oIXndg
         3jV2zCKzMraHNDgUl7x7cXX9/uOMFckyA2qSlLKpJv/h51snMJIjyr65Qw3P9ubk3cs5
         GH7ykx+6d3MVtXCYJ0L9hlruSXZYvzL1RqnBw1letkCspYRF2myA4B3VgTZddoezh4rM
         6ljgPpyANTEPfKMAzAGEMqHKZVG6vlD7GGeZfpkgoXb5exhpPi6t6ko2G2dtc7b4nK38
         uU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=enyhkTrmG/faoR4D5x/rqcK/lRFOCXWHV83l/oLzMzA=;
        b=kZ5sZp2eorpayezRMvwEp+oiZZUL3l1RxdcCl2VkocMIh1WdJrEmHlsiMIqlRqSIup
         PqQFJvMvwo/wjrKIsUupcK+xJ6mFX0VcKkS3+BJuly8Dizp3Tilp281O8NdYWa7IkOPm
         quUfWRJis2fFGmksQAf9V8xM7Lq1E+7iVjeySy9gWanSC+i2lcWDhFaUwDoAgKda91SG
         lqVGnfqA3pOe0u6QcfsMS+ckyAN3l0tuwTtyWvJ9UUDbpF2c4UKmXwhqWAuQkiwU8rG4
         aTmxgPdraXrKIii7FdBqUxVVrKtR34OXj67O0xDVCZxNT/BlgfjFkIZmp/vhEZxphwtv
         vX4A==
X-Gm-Message-State: ANoB5pn8SF5OSNU8PzEWChsToCtyhhKs9qSZ4S4HhDteJTiIjpYDvWnm
        1AsuNcD2qecIGYNqKLFsuPFSIvdyWieBlw==
X-Google-Smtp-Source: AA0mqf6O2vWoSDB6BALwLeZ9mt3BxluD95VLugApiRwvm0iXPePElRStrAMwtyK+u5fwGWUEN3KZ8ex6gPjUtw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a0d:e807:0:b0:391:a199:fc13 with SMTP id
 r7-20020a0de807000000b00391a199fc13mr576293ywe.62.1668676895065; Thu, 17 Nov
 2022 01:21:35 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:38 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-21-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 20/34] x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit b2620facef4889fefcbf2e87284f34dcd4189bce upstream.

If a kernel is built with CONFIG_RETPOLINE=n, but the user still wants
to mitigate Spectre v2 using IBRS or eIBRS, the RSB filling will be
silently disabled.

There's nothing retpoline-specific about RSB buffer filling.  Remove the
CONFIG_RETPOLINE guards around it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/entry/entry_32.S            | 2 --
 arch/x86/entry/entry_64.S            | 2 --
 arch/x86/include/asm/nospec-branch.h | 2 --
 3 files changed, 6 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 37d9016d4768..78b308f2f2ea 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -643,7 +643,6 @@ ENTRY(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -652,7 +651,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfl
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 55b61b34c462..3f418aedef8d 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -367,7 +367,6 @@ ENTRY(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(irq_stack_union)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -376,7 +375,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfq
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 0f4cddf621b4..ca6e421a3467 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -159,11 +159,9 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
-#endif
 .endm
 
 #else /* __ASSEMBLY__ */
-- 
2.38.1.431.g37b22c650d-goog

