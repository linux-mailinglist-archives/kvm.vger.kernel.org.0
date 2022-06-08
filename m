Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBED6544024
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiFHXvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiFHXu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:50:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EFA16B2F5
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:48 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z5-20020aa79f85000000b0051baa4e9fb8so11535540pfr.7
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HK/rm3wObpg6+TbjxiEJV0Hl9uX1BuwJxAb20dyTn5I=;
        b=rq1Rr+h0MH3PQ1yMOTAxfWX5eaDSIg1m7u1qsGzeqcaURDV73LizSVj8Ak/5sJBZ1d
         jU26N/65F1ppCXnj0Y0z0HPIXU/PILDyAK19kMHZ2NPJhc5ApSZu04FOjVxc0fPoMhmf
         E9ye2ADvxs5JQfrnU45dsG/K2G09G5LKvfLrnuwimxE9EeoB9/bJ6QGnaweQ/aDyOjoU
         OTyxWhwLsIAcHHvrgReWtKsr9YDF2xS8AmAx2GaVa0+Xz7xXwxb5qDY+bFbskuuJUosa
         6AZeqQiHbaiB6n4r/7xmgDkd2wo0ZiQZ2czsItUe/f+9g48CEBlASZADZg1qKqPGaZUv
         ugUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HK/rm3wObpg6+TbjxiEJV0Hl9uX1BuwJxAb20dyTn5I=;
        b=q4vYeKExvsGdxKBMTUrxSgCmNBZSNa9yt6fZQhRvCXxb+AKz+oPRuhyuFqG6S+1E5L
         E9QF7gs9bMA/CKld+bsnyG+JdQVV4ivwry0uXFIAa+ocCOGjMOIBp7/v7mxCHcPU0/Pf
         Y3F641EgrnWhfSYY+AbTVuGk1zArPDhOTaH1Yo2DhVFzs0Y2nGq+xeewKCFbMqHiJ0/U
         Pucg2cmmG39KS6Vnk5FEmztGSB/p+PQb4xmU8boIVffVvjJPB4js40iiyWbHMQjBuXZG
         JWhhocEbXSyALjQiUtKuP/agi4sr9HyP37fMFXGL+ZtxpX1qGQqc1xEysY0NAqJGZtZ7
         uwGw==
X-Gm-Message-State: AOAM532N4U6NIg4eNvhZITwyrL1S0UkJpwtTMZUzbHjpSG2HICAPGz03
        YeRL+O0CwY7cP+OsoYIdxUBXnHw63F0=
X-Google-Smtp-Source: ABdhPJwm+HD3/lWe5pgU+NhOFsZxK7HUZGNQLZdKbuecUPfL9+ePHlEIf+7SEJv+9l+S9PeVGLd3CW1pD+4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2286:b0:51c:48b7:a445 with SMTP id
 f6-20020a056a00228600b0051c48b7a445mr8498256pfe.62.1654732368464; Wed, 08 Jun
 2022 16:52:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:32 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 04/10] x86: Use "safe" helpers to implement
 unsafe CRs accessors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the "safe" helpers to read and write CR0, CR3, and CR4, so that an
unexpected fault results in a detailed message instead of an generic
"unexpected fault" explosion.

Do not give RDMSR/WRMSR the same treatment.  KUT's exception fixup uses
per-CPU data and thus needs a stable GS.base.  Various tests modify
MSR_GS_BASE and routing them through the safe variants will cause
fireworks when trying to clear/read the exception vector with a garbage
GS.base.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c      |  8 --------
 lib/x86/desc.h      |  1 -
 lib/x86/processor.h | 45 ++++++++++++++++++++++++++++++++++++++++++---
 x86/pcid.c          |  8 --------
 4 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index ff9bd6b7..7620dc81 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -299,14 +299,6 @@ unsigned exception_vector(void)
 	return this_cpu_read_exception_vector();
 }
 
-int write_cr4_safe(unsigned long val)
-{
-	asm volatile(ASM_TRY("1f")
-		"mov %0,%%cr4\n\t"
-		"1:": : "r" (val));
-	return exception_vector();
-}
-
 unsigned exception_error_code(void)
 {
 	return this_cpu_read_exception_error_code();
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 0bd44445..ac843c35 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -213,7 +213,6 @@ extern tss64_t tss[];
 extern gdt_entry_t gdt[];
 
 unsigned exception_vector(void);
-int write_cr4_safe(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
 void set_idt_entry(int vec, void *addr, int dpl);
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e169aac8..bc6c8d94 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -341,6 +341,12 @@ static inline void set_iopl(int iopl)
 	write_rflags(flags);
 }
 
+/*
+ * Don't use the safe variants for rdmsr() or wrmsr().  The exception fixup
+ * infrastructure uses per-CPU data and thus consumes GS.base.  Various tests
+ * temporarily modify MSR_GS_BASE and will explode when trying to determine
+ * whether or not RDMSR/WRMSR faulted.
+ */
 static inline u64 rdmsr(u32 index)
 {
 	u32 a, d;
@@ -381,9 +387,20 @@ static inline uint64_t rdpmc(uint32_t index)
 	return a | ((uint64_t)d << 32);
 }
 
+static inline int write_cr0_safe(ulong val)
+{
+	asm volatile(ASM_TRY("1f")
+		     "mov %0,%%cr0\n\t"
+		     "1:": : "r" (val));
+	return exception_vector();
+}
+
 static inline void write_cr0(ulong val)
 {
-	asm volatile ("mov %0, %%cr0" : : "r"(val) : "memory");
+	int vector = write_cr0_safe(val);
+
+	assert_msg(!vector, "Unexpected fault '%d' writing CR0 = %lx",
+		   vector, val);
 }
 
 static inline ulong read_cr0(void)
@@ -405,9 +422,20 @@ static inline ulong read_cr2(void)
 	return val;
 }
 
+static inline int write_cr3_safe(ulong val)
+{
+	asm volatile(ASM_TRY("1f")
+		     "mov %0,%%cr3\n\t"
+		     "1:": : "r" (val));
+	return exception_vector();
+}
+
 static inline void write_cr3(ulong val)
 {
-	asm volatile ("mov %0, %%cr3" : : "r"(val) : "memory");
+	int vector = write_cr3_safe(val);
+
+	assert_msg(!vector, "Unexpected fault '%d' writing CR3 = %lx",
+		   vector, val);
 }
 
 static inline ulong read_cr3(void)
@@ -422,9 +450,20 @@ static inline void update_cr3(void *cr3)
 	write_cr3((ulong)cr3);
 }
 
+static inline int write_cr4_safe(ulong val)
+{
+	asm volatile(ASM_TRY("1f")
+		     "mov %0,%%cr4\n\t"
+		     "1:": : "r" (val));
+	return exception_vector();
+}
+
 static inline void write_cr4(ulong val)
 {
-	asm volatile ("mov %0, %%cr4" : : "r"(val) : "memory");
+	int vector = write_cr4_safe(val);
+
+	assert_msg(!vector, "Unexpected fault '%d' writing CR4 = %lx",
+		   vector, val);
 }
 
 static inline ulong read_cr4(void)
diff --git a/x86/pcid.c b/x86/pcid.c
index 5e08f576..4dfc6fd0 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -10,14 +10,6 @@ struct invpcid_desc {
     u64 addr : 64;
 };
 
-static int write_cr0_safe(unsigned long val)
-{
-    asm volatile(ASM_TRY("1f")
-                 "mov %0, %%cr0\n\t"
-                 "1:": : "r" (val));
-    return exception_vector();
-}
-
 static int invpcid_safe(unsigned long type, void *desc)
 {
     asm volatile (ASM_TRY("1f")
-- 
2.36.1.255.ge46751e96f-goog

