Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872106D8DB8
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbjDFCwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbjDFCwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:52:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA57290
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a22-20020a62d416000000b0062e2649a33cso3127254pfh.16
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LhuSJTdTS3WJC/krBqX0xLoMwPwrduVVFYKHNTNPgh8=;
        b=H1nDfrjST4MB/4Wggf4/3no4PKfOBxIZEarXZefoul1DdpKN/TSIrpYyF9r0GaY9CB
         y8OOPv8ugqUhFBf67Q5VvKW+jjHCqDjBDhEJujbIt6w8/usGS12uIZnoma5dMzbjWOCO
         pNBd+QwndUkidsBGTTE7GvhmSTh7wYsiXJbNb53InflKIzgaj8WSP2NCtyarq035UeuC
         2/34H32cXh7d0RpLLutusI35t/9cvC6jQULtPlyM9SI7crc2WxUfBJRzctj2tHmh1vdG
         Oe40KTMZ2XcxGoO3wApnQ1cGE002clMeAAcOyEG9iny3DsjgoT2WoIIIeBwRGAkPVHFX
         N55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhuSJTdTS3WJC/krBqX0xLoMwPwrduVVFYKHNTNPgh8=;
        b=OdZOO3POyT0ggubDVfJBMcye8/bv4n7QKjEiPcwhuYubK26IHM2+DjGBkPVkRjSNex
         4xalcIr90x+wc1xZiu/m/6lFI9GluXy+OE8csohdZ/cHQHfpIgpQZZBhCL/D182F9V9Q
         J3bBgfj5q7PURUPFgJG4AuXdoB1VvKNz1WegWzcAOXmL7mN13brICfjdUWY+/cMbd8d3
         X7oQDAkOGB9c3B9VfbCwUrpMrFIT9OEvLy8kyfItNuHK/stNcdcCaKaOsPLrE4sMJjbb
         jJhYpTqsldCOX6O0Ekh9e3ThjYWlvwU82XM6l/uYx9phUBvtZ02jYXCiYVm/zS/5tYDi
         CH+A==
X-Gm-Message-State: AAQBX9dIZG2rvHVe+uzCSxlT6yJ8hO5O5lEPc2NwxxqV2E/Frvk80Qbr
        P6NLyXD2hFUxmolTjrT8JgaL7BQzk4Y=
X-Google-Smtp-Source: AKy350aknpti9kC0OFx45bvxl3h/7/b8wXvvY7QgP3i7+ivnHkyfR4yMeZGjgAZIPr0z/Gk637oVA2Wn90k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4591:b0:234:acfd:c8da with SMTP id
 v17-20020a17090a459100b00234acfdc8damr3048420pjg.2.1680749483105; Wed, 05 Apr
 2023 19:51:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:14 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/5] x86: Convert inputs-only "safe"
 instruction helpers to asm_safe()
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

Convert processor.h's "safe" helpers that do not have outputs to use
asm_safe() instead of open coding the equivalent.  Leave instructions
without outputs for a separate, future change as handling outputs is a
bit more complex.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6555056e..e05b3fd0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -434,11 +434,7 @@ static inline int wrmsr_safe(u32 index, u64 val)
 {
 	u32 a = val, d = val >> 32;
 
-	asm volatile (ASM_TRY("1f")
-		      "wrmsr\n\t"
-		      "1:"
-		      : : "a"(a), "d"(d), "c"(index) : "memory");
-	return exception_vector();
+	return asm_safe("wrmsr", "a"(a), "d"(d), "c"(index));
 }
 
 static inline int rdpmc_safe(u32 index, uint64_t *val)
@@ -465,10 +461,7 @@ static inline uint64_t rdpmc(uint32_t index)
 
 static inline int write_cr0_safe(ulong val)
 {
-	asm volatile(ASM_TRY("1f")
-		     "mov %0,%%cr0\n\t"
-		     "1:": : "r" (val));
-	return exception_vector();
+	return asm_safe("mov %0,%%cr0", "r" (val));
 }
 
 static inline void write_cr0(ulong val)
@@ -500,10 +493,7 @@ static inline ulong read_cr2(void)
 
 static inline int write_cr3_safe(ulong val)
 {
-	asm volatile(ASM_TRY("1f")
-		     "mov %0,%%cr3\n\t"
-		     "1:": : "r" (val));
-	return exception_vector();
+	return asm_safe("mov %0,%%cr3", "r" (val));
 }
 
 static inline void write_cr3(ulong val)
@@ -528,10 +518,7 @@ static inline void update_cr3(void *cr3)
 
 static inline int write_cr4_safe(ulong val)
 {
-	asm volatile(ASM_TRY("1f")
-		     "mov %0,%%cr4\n\t"
-		     "1:": : "r" (val));
-	return exception_vector();
+	return asm_safe("mov %0,%%cr4", "r" (val));
 }
 
 static inline void write_cr4(ulong val)
-- 
2.40.0.348.gf938b09366-goog

