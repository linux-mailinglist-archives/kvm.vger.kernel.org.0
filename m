Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654AE62D670
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiKQJVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiKQJU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:20:57 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9E697DA
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:56 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id cj8-20020a056a00298800b0056cee8a0cf8so869409pfb.9
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WTdnnyRvlnkJV4eIL3qxiMZf7NF2h7/lVHLg8cs+jzQ=;
        b=EYX8QZ745yKg1k5O2oODe3JpEti6r+pD7PDiNIxKRXIgj8tm7Jti87H5gmuvOKEK0c
         3SKA4e9c3TRTtuVnA/pftWLI23zr16k87aswKEnb3m/9dzDHOoNKJvpbMbkTiBItBdD+
         /JrS339SlbyKVxHTKQZN2VWZvFOQxjxy2KvRc4t5zMYk0Uq+Obe8Zwfk0I30p2vnv1+c
         4yRHZ0nqcw4P9oww+BptIDDtghLE+qRNv+gDmovKH3pv/WY+0EHkMVFOKxTY0/0/vuqd
         q1O8/lALGdFTBD5dg6/Zw5sdWL6G3zx1vZMhLut089T4WyrH5TDjngR1CCWi7zoM/uvk
         NQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTdnnyRvlnkJV4eIL3qxiMZf7NF2h7/lVHLg8cs+jzQ=;
        b=sPhTZsQ2IOZWxqntH/QH+KTdCtb8IJ5pvII1tbypIWM+FssYtp0h8Q0bptGwM5E1Ni
         qBer94LskZ/YOkGokPMc6Si+lRtCemfecKEUKobpEIWWfgGB34uM0wDBGu+50UcxIDJP
         YOfqQikOWvLFFGJgcz2b+0NneRhxkVGYHWXOCcwPtuaJZtu90AIVcLYJ/I7PqPgxOjZW
         hlLUQECvuHQmRIhVctnuc/PATn3oQFUuK2ZNAoU2YOBXiNBxWNgtxsFEKp8Ii8Km4bWv
         QuEMdR9cLsBxN2m19XzqnvfZSicJgcHkKrFG3uaQ/jfz60yaUN9cLuK/0gzhHbE7Aiov
         wXsQ==
X-Gm-Message-State: ANoB5pln2i6zLYLzG08n0S3sWcoya45LzWLshdoreUjxnLzZebYk1Gsq
        Hoe7o9D3FhJO1NNRCQ0/VdjfdvSStyD1aQ==
X-Google-Smtp-Source: AA0mqf5cOr9fEb4egYQDaVkVxFRTr+blLdnfhT1MMI+Vy4E29a2YJGhBCbczwFOhRS1nnH/YEbBlJzNXfNOdXQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a62:6d02:0:b0:562:3411:cb3a with SMTP id
 i2-20020a626d02000000b005623411cb3amr2100280pfc.60.1668676856064; Thu, 17 Nov
 2022 01:20:56 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:30 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-13-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 12/34] x86/entry: Remove skip_r11rcx
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

commit 1b331eeea7b8676fc5dbdf80d0a07e41be226177 upstream.

Yes, r11 and rcx have been restored previously, but since they're being
popped anyway (into rsi) might as well pop them into their own regs --
setting them to the value they already are.

Less magical code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220506121631.365070674@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/entry/calling.h  | 10 +---------
 arch/x86/entry/entry_64.S |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 993dd06c8923..90a1297550d3 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -146,27 +146,19 @@ For 32-bit we have the following conventions - kernel is built with
 
 .endm
 
-.macro POP_REGS pop_rdi=1 skip_r11rcx=0
+.macro POP_REGS pop_rdi=1
 	popq %r15
 	popq %r14
 	popq %r13
 	popq %r12
 	popq %rbp
 	popq %rbx
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %r11
-	.endif
 	popq %r10
 	popq %r9
 	popq %r8
 	popq %rax
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %rcx
-	.endif
 	popq %rdx
 	popq %rsi
 	.if \pop_rdi
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index dfe26f3cfffc..35bdbd9d50c6 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -311,8 +311,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
-	/* rcx and r11 are already restored (see code above) */
-	POP_REGS pop_rdi=0 skip_r11rcx=1
+	POP_REGS pop_rdi=0
 
 	/*
 	 * Now all regs are restored except RSP and RDI.
-- 
2.38.1.431.g37b22c650d-goog

