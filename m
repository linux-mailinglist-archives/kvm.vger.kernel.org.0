Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2199F62D67D
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbiKQJVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239910AbiKQJVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:21:36 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2BB697EB
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y15-20020aa7804f000000b0056c9b4a58d3so868145pfm.18
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VEdlDwaKej9719g4brVudMR9HPoFBvbAxw929QHX8no=;
        b=cD837Vu2JjLlcK+kRymosGyw7nergQs9YXFx6JnC5G9oHDGDQ1kjYVTB6f21DXeQTI
         DCg+q47lNIfw3NTOm0hw0m9OeuXz6apzL7tAp448/p9sHddb0OFMg/pB0N3bpU1DA0aP
         pokiJqEz+zczeJk8N3nH0XfwdA1BR7jI4KRGax2M6DUOc2j8FVbVF/5B1mGOb7KUpLBZ
         n8Cx3I78iXnIAe0DDiSYO4lDXq3UZ8LaJ/el13p1toMw08ecmpXVZ2+HI6w9xYml0EtE
         f6hXoTljXb4SEJhXCFzdHegSYTJdEjWrN8/t7/VtV6f4nRoejq6pjsAX1FiN5PifbyWR
         kXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEdlDwaKej9719g4brVudMR9HPoFBvbAxw929QHX8no=;
        b=ktUCH8Go3W6M9pH4NjrHH5rxE2SMSvVIeG5MiA3y1gzHClxeRrKahMtulWboLLEuah
         j5qTHe8Ael6Xz14NSWPwp6loGjOBVkXGlIurujRpz7r+ZjnBg7OPsOQJowvnTHZh3zcL
         1jK69rLfZivmVmMMOU8Fp9AK2JXiHB+p2QBjl3oUFf/lnAq77IvLiwPu1zcHsicPTOkT
         WNGZCMsZTL9fVMUb4an1k4t+xWb8BakvCdBCsFCJp4tJVSvfJXdRdvyPAVgmXkfKcpAF
         kMMN+UM7rz1hAHzT9zkzXzIOazVZ52c/xgGBYccpu2o6Xq97JKytJSXk1Z4TOyVOd0J1
         DEQQ==
X-Gm-Message-State: ANoB5pneM+wdwqHynSyRhv0U6oYDmccnRbCST4nrLhvPyFWvjTZVpeMA
        jiA30fdztqAr1GtfuZn9kk0i2dk2hJyuzQ==
X-Google-Smtp-Source: AA0mqf6xmfgpF+CZswMZEtaTneHzbNyYaVLczMQU6pUwGD6qrRvxQJyEwQEcoPaHBbX0Mzwv0/7vR7OKpddDLg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:90a:ca87:b0:20a:aa74:175f with SMTP
 id y7-20020a17090aca8700b0020aaa74175fmr7802422pjt.194.1668676890357; Thu, 17
 Nov 2022 01:21:30 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:37 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-20-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 19/34] x86/speculation: Change FILL_RETURN_BUFFER to work
 with objtool
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

From: Peter Zijlstra <peterz@infradead.org>

commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.

Change FILL_RETURN_BUFFER so that objtool groks it and can generate
correct ORC unwind information.

 - Since ORC is alternative invariant; that is, all alternatives
   should have the same ORC entries, the __FILL_RETURN_BUFFER body
   can not be part of an alternative.

   Therefore, move it out of the alternative and keep the alternative
   as a sort of jump_label around it.

 - Use the ANNOTATE_INTRA_FUNCTION_CALL annotation to white-list
   these 'funny' call instructions to nowhere.

 - Use UNWIND_HINT_EMPTY to 'fill' the speculation traps, otherwise
   objtool will consider them unreachable.

 - Move the RSP adjustment into the loop, such that the loop has a
   deterministic stack layout.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20200428191700.032079304@infradead.org
[cascardo: fixup because of backport of ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 ("x86/speculation: Add LFENCE to RSB fill sequence")]
[cascardo: no intra-function call validation support]
[cascardo: avoid UNWIND_HINT_EMPTY because of svm]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 9311f0f9c392..0f4cddf621b4 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -4,11 +4,13 @@
 #define _ASM_X86_NOSPEC_BRANCH_H_
 
 #include <linux/static_key.h>
+#include <linux/frame.h>
 
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
 
 /*
  * Fill the CPU return stack buffer.
@@ -51,9 +53,9 @@
 	lfence;					\
 	jmp	775b;				\
 774:						\
+	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
 	jnz	771b;				\
-	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
 #else
@@ -158,10 +160,8 @@
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
 #ifdef CONFIG_RETPOLINE
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_rsb_\@",				\
-		__stringify(__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP))	\
-		\ftr
+	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
+	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
 #endif
 .endm
-- 
2.38.1.431.g37b22c650d-goog

