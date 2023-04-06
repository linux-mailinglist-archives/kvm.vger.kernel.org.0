Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE23D6D8DBA
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbjDFCwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbjDFCwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:52:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5549039
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o9-20020a170902d4c900b001a2bef29d53so6350608plg.7
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aY8/dkLh69YCva2xLoG8NNF7vwneIea26D9pttTDghs=;
        b=ArAxVAdr+xBBk7TAQyJ3raqZiLOQy4luQ2AwpzHp8JmSRSgYyGqMoy/uyLu4E4Hxui
         E1+a4vKtOnLW4A1ZTiaaFs5kCZPF5oSNn1JrFTXN23btc0vvuTy/69QmiYkcT5OucvCf
         1iYx07J5vKKJwoeaqNx3ImZQ0Rmur4lXF7V3k/u9dvdX/QWtgd8i+12VGVaKQTVM7tOk
         rrILNlmtReGWhR+aJy3mpkZ+XUeFjPVdIV7FV8c59UXE+vaW7g+Ugi6fu0ifkAUBuv/X
         na8a5oeUdrYGYBhnkQn6MNa7GZQP4GiDnOAgVLannNsbUPJ5hsODJbIZsgEYmXteGkuq
         Nobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aY8/dkLh69YCva2xLoG8NNF7vwneIea26D9pttTDghs=;
        b=XQ7jZ+CSPeLvAfOuTNzkk4DoSvqZqbHiU8VT4QdVFpJKxY1hAi7geWpHdg8gZIpt5f
         0emxTPrV9EAJJkL7zsb3MOAh+taJTp/csmg5mOhkSp/MMv3iWy5qEpaki0ckVD7K24m9
         xoJjrVSiwKOWmjC4QTK541EP8LiAolWqXdlU7Cc3NnHXKvx3pYzpBKfnFb8f4Uqgbllh
         1dHZijQ+NeoqF/3yZH7jqQji5jszdCf9uysCpWGbptTsNO3qPCdIYxpFo7B4xKBKMe+n
         rkwGwgSRRLwKPgD92qkYsw6DTstf3i0VzSJvqqp8u199mOFOlW/U+t2DSswG4QOaEIQy
         Awfw==
X-Gm-Message-State: AAQBX9cU3WjJZ6f5zapxleSmRe0T1h/vQvJsVaqc+CzTr8I4TOYHAA3D
        /WGVzjrNrAt56+mhSBBK89MHsrLns9g=
X-Google-Smtp-Source: AKy350ZMesUJh67c3rHT4npuaFOfWb1owKO9YT2OfzRqzL9aQhmDU5ywkDMHYnf+k9a8LTe4jOC+yPoV6Iw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dd45:b0:240:2ae6:5eb8 with SMTP id
 u5-20020a17090add4500b002402ae65eb8mr2930517pjv.9.1680749484857; Wed, 05 Apr
 2023 19:51:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:15 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/5] x86: Add macros to wrap ASM_TRY() for
 single instructions with output(s)
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

Add macros for "safe" execution of instructions with outputs.  Outputs
require dedicated macros as the variadic arguments shenanigans only work
for one type, i.e. can either be used for inputs or outputs, not both.

Opportunistically provide a common macro for RDMSR and RDPMC, the common
macro can also be used for xgetbv_safe().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h      | 22 ++++++++++++++++++++++
 lib/x86/processor.h | 34 ++++++++++++++++------------------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 8079d462..7778a0f8 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -283,6 +283,28 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 	exception_vector();						\
 })
 
+#define asm_safe_out1(insn, output, inputs...)				\
+({									\
+	asm volatile(ASM_TRY("1f")					\
+		     insn "\n\t"					\
+		     "1:\n\t"						\
+		     : output						\
+		     : inputs						\
+		     : "memory");					\
+	exception_vector();						\
+})
+
+#define asm_safe_out2(insn, output1, output2, inputs...)		\
+({									\
+	asm volatile(ASM_TRY("1f")					\
+		     insn "\n\t"					\
+		     "1:\n\t"						\
+		     : output1, output2					\
+		     : inputs						\
+		     : "memory");					\
+	exception_vector();						\
+})
+
 #define __asm_safe_report(want, insn, inputs...)			\
 do {									\
 	int vector = asm_safe(insn, inputs);				\
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e05b3fd0..b9f0436c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -416,18 +416,23 @@ static inline void wrmsr(u32 index, u64 val)
 	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
+#define rdreg64_safe(insn, index, val)					\
+({									\
+	uint32_t a, d;							\
+	int vector;							\
+									\
+	vector = asm_safe_out2(insn, "=a"(a), "=d"(d), "c"(index));	\
+									\
+	if (vector)							\
+		*(val) = 0;						\
+	else								\
+		*(val) = (uint64_t)a | ((uint64_t)d << 32);		\
+	vector;								\
+})
+
 static inline int rdmsr_safe(u32 index, uint64_t *val)
 {
-	uint32_t a, d;
-
-	asm volatile (ASM_TRY("1f")
-		      "rdmsr\n\t"
-		      "1:"
-		      : "=a"(a), "=d"(d)
-		      : "c"(index) : "memory");
-
-	*val = (uint64_t)a | ((uint64_t)d << 32);
-	return exception_vector();
+	return rdreg64_safe("rdmsr", index, val);
 }
 
 static inline int wrmsr_safe(u32 index, u64 val)
@@ -439,14 +444,7 @@ static inline int wrmsr_safe(u32 index, u64 val)
 
 static inline int rdpmc_safe(u32 index, uint64_t *val)
 {
-	uint32_t a, d;
-
-	asm volatile (ASM_TRY("1f")
-		      "rdpmc\n\t"
-		      "1:"
-		      : "=a"(a), "=d"(d) : "c"(index) : "memory");
-	*val = (uint64_t)a | ((uint64_t)d << 32);
-	return exception_vector();
+	return rdreg64_safe("rdpmc", index, val);
 }
 
 static inline uint64_t rdpmc(uint32_t index)
-- 
2.40.0.348.gf938b09366-goog

