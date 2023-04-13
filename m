Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43156E1467
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDMSnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMSnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8619D6A42
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j15so1423606wrb.11
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411363; x=1684003363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPrhWpKAB9HV29BJuUCmLvNKDCRzAddjdDbvTlL8W/w=;
        b=AwHkue3ft9b/chF3ZaSXmcU+Xeak+GQiOpeZbDOx8Vn9N/DEPP0WkLgSNkUtkGStvQ
         VwI0iF76jrHNxqr3xycTFXHvfiPEdSPpTcPxEffGQga95EmYoyeoJOhninXjziSqphIR
         eZG4+etGwP3P17hdXFTJKXL05e04G2qoc9qewqmU4rAC6REJMbJfDWZfb3Mb825gAM4M
         XW0L5Ew73J5OqxXR1ezrn5e6nOgtJ52pKCFLREHrg0IsVb2R+F1LNPR7WTers7KRUu59
         UUYfZJfVZKqQJGyqf7ZBeLKMYKJFjC4fScs0X/Eq6gCWTH0DEzIkAY8aa5orSoi7F4zZ
         B6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411363; x=1684003363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UPrhWpKAB9HV29BJuUCmLvNKDCRzAddjdDbvTlL8W/w=;
        b=EoVxajPefs7dUzUDNwrn37tWvvdi6JWd9BvT2nNkVy1ZrlVmFovAye0GUf5/2CIIDA
         jbYk+04AlrDV085RdITu981P8bj5ZtX4t8N478n9foubjMGIBioXdGViP7nvCxcOjLR1
         3xxZ18rgvqghmqw5c3mEg17CWNCOpoZzJA+WSB96DR2ehYH/NEY1XdXhx5p/PFDHswaC
         dzOO8IowR7mgyeThGyAsSH4EffVNQkk4+uZmndobaumVHa2z1Wm0CI/q63So1bD8+BqW
         A48L3TEKxYicIGapX7YEfcKXJTiZcc3l1HGs43Cr0al0xPy8lsBYfjgVYNH/t/W1NKlM
         ZELA==
X-Gm-Message-State: AAQBX9daV8/JXKSKJMxHJXs0TE0GbjTgOurLNBv7wGam8LOAbHG0kE5j
        Yt3D+JgBPYvXIBIryld1Dy+npw==
X-Google-Smtp-Source: AKy350arK2lqIg8I1KREMe15AdttWzD1if8zeVvJlCwPtFdORiYypSKHHhOWT9lSw5hO0M/nYxSNbg==
X-Received: by 2002:a5d:40c7:0:b0:2ef:a7d:54fd with SMTP id b7-20020a5d40c7000000b002ef0a7d54fdmr5472052wrq.32.1681411363003;
        Thu, 13 Apr 2023 11:42:43 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:42 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 09/16] x86/run_in_user: Reload SS after successful return
Date:   Thu, 13 Apr 2023 20:42:12 +0200
Message-Id: <20230413184219.36404-10-minipli@grsecurity.net>
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

Complement commit 663f9e447b98 ("x86: Fix a #GP from occurring in
usermode library's exception handlers") and restore SS on a regular
return as well.

The INT-based "syscall" will make it get loaded with the NULL selector
(see SDM Vol. 1, Interrupt and Exception Behavior in 64-Bit Mode: "The
new SS is set to NULL if there is a change in CPL.") which makes the
"mov null, %%ss" test of emulator64.c dubious, as SS is already loaded
with the NULL selector.

Fix this by loading SS with KERNEL_DS after a successful userland
function call as well, as we already do in case of exceptions.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/usermode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index fd19551a7a2d..9ae4cb17fd63 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -97,6 +97,13 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			/* Kernel Mode */
 			"ret_to_kernel:\n\t"
 			"mov %[rsp0], %%rsp\n\t"
+#ifdef __x86_64__
+			/* Restore SS, as it forcibly gets loaded with NULL */
+			"push %%rax\n\t"
+			"mov %[kernel_ds], %%ax\n\t"
+			"mov %%ax, %%ss\n\t"
+			"pop %%rax\n\t"
+#endif
 			:
 			"+a"(rax),
 			[rsp0]"=m"(tss[0].rsp0)
@@ -108,6 +115,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			[func]"m"(func),
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
+			[kernel_ds]"i"(KERNEL_DS),
 			[user_stack_top]"r"(user_stack +
 					sizeof(user_stack)),
 			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ));
-- 
2.39.2

