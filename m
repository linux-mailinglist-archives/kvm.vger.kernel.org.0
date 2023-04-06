Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9446D8DB9
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbjDFCwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjDFCwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:52:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A4910F6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o14-20020a62f90e000000b0062d87d997eeso13703474pfh.18
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HNgRHsest+3Q8dYbGPFFByrTYklzgq7EZMxYGJPgvBE=;
        b=IuIFF7eX43X1zmw4gUj+WvxDX0wZV/bgDGOyaDI1/zNy03SAY/fz8NVhkAqS8Yfu09
         rvkL1sRepfxAV/DOorZrtbciBptILL/no0nrb2SSETEb+9vEpMC6vvc7TV5Z4BK+ckji
         FQ5cVEnfNEH8OxU2t7H2lhPaUTjUSkEVAC4TADY20xiQkqYyCleFhS/cRJGmvM+hc3tK
         5ABeq4Zu3CVF2kD0wQV8AIXpZy2a1Anss0CFvqCnNtrPzfkug8RBhCulWHwDoPLZ5zkV
         2Uc9ydHn6cDGwAKNKuMLshSAQYidRO6J3YE7Yg2su0kYBICKnqHmaRzEWG+AEEXrAKho
         UM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HNgRHsest+3Q8dYbGPFFByrTYklzgq7EZMxYGJPgvBE=;
        b=ahUqF06q0h3oAXba6IHSOcx2Ueoi+WWgLupQ8pdsmbSHKmF+nv57rbPdGt5j1etqKF
         eXOS2B/skpwoZw5WcxE4KKWWDwVrVIlrKJC3XlR80DVbMqViMNPNq7ZMCBOungL7raE+
         0JaAN1IC6Iq/lUbL3HUGZ7Xa+XD3a1uoAKQ/eI1FxKfEaCfPJN93RZHDJNfq7ERFIDB1
         UoKCeJiJsaDuXs1yBEqFR4cv3O83vj9Vr+rfICtk7vG+cb9Qte4bsGa8wMc7uLWeNnFY
         VAYve69JfIOBMWYQ8Sbpb2r0APW8FIp/fn2MfNIcj62ze1Q60zmjSR0sOwtjLAQE/s7k
         dTRg==
X-Gm-Message-State: AAQBX9fYuKfymgFSieLNFj+9Aent1oA52blqS1I/TZ523/6opHJCiR5D
        IkmlRIhiw1HKtyCImaC60auOPFYcFiw=
X-Google-Smtp-Source: AKy350ZUf2oW+9HZgmjqoiK3h2Z77YQts6GhRAVX+MEdJxSM4hOlneLC5vWq22ZhB1IZ2VJFhKg2hYLwLz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7308:b0:23f:1caa:233a with SMTP id
 m8-20020a17090a730800b0023f1caa233amr1947112pjk.1.1680749486620; Wed, 05 Apr
 2023 19:51:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:16 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/5] x86: Move invpcid_safe() to processor.h
 and convert to asm_safe()
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

Move invpcid_safe() to processor.h so that it can be used by other tests,
and convert it to use asm_safe() instead of open coding ASM_TRY() usage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 7 +++++++
 x86/pcid.c          | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b9f0436c..243eacde 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -737,6 +737,13 @@ static inline void invlpg(volatile void *va)
 	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
 }
 
+
+static inline int invpcid_safe(unsigned long type, void *desc)
+{
+	/* invpcid (%rax), %rbx */
+	return asm_safe(".byte 0x66,0x0f,0x38,0x82,0x18", "a" (desc), "b" (type));
+}
+
 static inline void safe_halt(void)
 {
 	asm volatile("sti; hlt");
diff --git a/x86/pcid.c b/x86/pcid.c
index 4dfc6fd0..c503efb8 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -10,14 +10,6 @@ struct invpcid_desc {
     u64 addr : 64;
 };
 
-static int invpcid_safe(unsigned long type, void *desc)
-{
-    asm volatile (ASM_TRY("1f")
-                  ".byte 0x66,0x0f,0x38,0x82,0x18 \n\t" /* invpcid (%rax), %rbx */
-                  "1:" : : "a" (desc), "b" (type));
-    return exception_vector();
-}
-
 static void test_pcid_enabled(void)
 {
     int passed = 0;
-- 
2.40.0.348.gf938b09366-goog

