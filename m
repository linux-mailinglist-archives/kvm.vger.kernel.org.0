Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FCB49682B
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiAUXTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiAUXTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:05 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17252C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u23-20020a170902a61700b0014a4dce9c91so2256168plq.9
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=S33Q5JP9sErEY0q4HgdQ1FvlcleQIA0X5MEcG9Bbjxw=;
        b=AJmF1uhUfVZgiD5gFxKpGmIOhzLlBG9ELMUgWD50S0wGHv4g++BSTnwkMQoYuDZofc
         rqoY4+FNQa/suNEnqg88MAHJk08Em/dx50LWebwbkb17g1kkWAXBk7aoqph2NBDYX+jR
         TPBvWDiYFpbYAlKmLK4HLSSxURwt7hnpajKvrvDYYlFsMa+J7PAAZLcduwOtp81tNoR5
         olMs35cS7JVXfYhduYl1DI+gf/W5msqsdr1lGoFXwfkEvr98JLynis5hJDqJy5BvWO8C
         fqMjW3ccJff7HWIgfksM5GRNXTJH5fy8LdRrtFDOTccuet0zYemqqQbBWNzZ18W0Qqis
         G6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=S33Q5JP9sErEY0q4HgdQ1FvlcleQIA0X5MEcG9Bbjxw=;
        b=psEbEl+Vtvv5NJJdJwKJmteq7JZrst9hZCSktbO7DztOiu/OzRmziUg1Y+yVx+DX3v
         p1NWAI8by40O0e4ZwwkG2CcxGrL6NZ8hs14nOnbzYQoImNxoz2hOjH4IcYV/kadUWQvg
         EXBeejpBIx+UjFx6dxPihIzGpFhKjtKtkGQdljj+VVrcWgtH1QA4gorhzm1vkbtqPBy6
         Sfz6QjaspP9BpzhbXYlmLPA+eU+YU5DdICbo5DxQ1nXJac4SH5jGXO32PrPcRACnlmnv
         4+ggWydjgP3CPUMK4/fT2NDXQHsG+ii3bzLuoOS4UXDua9IzaljTLYP/jRy2IVSegRZl
         sKJA==
X-Gm-Message-State: AOAM533kwFBViZDUmWRV/eriRROXVO7P3EIWTlDgfCFLgyVTt7Stj562
        sV+NH8zHeTe1PAXoRs0liN7CwpHinME=
X-Google-Smtp-Source: ABdhPJwK/ELwrD35IRwH2I1zIYzVky24E+he6LbfEMTlIftERbWZJDvjc46TbvA5RxWrE136MgaBfZfWfrE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:205:: with SMTP id 5mr4379277pgc.379.1642807144629;
 Fri, 21 Jan 2022 15:19:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:49 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 5/8] x86: Add proper helpers for per-cpu reads/writes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to read/write per-cpu data instead of open coding access
with gs: and magic numbers.  Keeping track of what offsets are used for
what and by whom is a nightmare.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 23 ++++++------------
 lib/x86/smp.c  |  7 ++----
 lib/x86/smp.h  | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 21 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 25c5ac55..22ff59e9 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "smp.h"
 #include <setjmp.h>
 #include "apic-defs.h"
 
@@ -155,11 +156,10 @@ void unhandled_exception(struct ex_regs *regs, bool cpu)
 static void check_exception_table(struct ex_regs *regs)
 {
 	struct ex_record *ex;
-	unsigned ex_val;
 
-	ex_val = regs->vector | (regs->error_code << 16) |
-		(((regs->rflags >> 16) & 1) << 8);
-	asm("mov %0, %%gs:4" : : "r"(ex_val));
+	this_cpu_write_exception_vector(regs->vector);
+	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
+	this_cpu_write_exception_error_code(regs->error_code);
 
 	for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
 		if (ex->rip == regs->rip) {
@@ -296,10 +296,7 @@ void setup_idt(void)
 
 unsigned exception_vector(void)
 {
-	unsigned char vector;
-
-	asm volatile("movb %%gs:4, %0" : "=q"(vector));
-	return vector;
+	return this_cpu_read_exception_vector();
 }
 
 int write_cr4_checking(unsigned long val)
@@ -312,18 +309,12 @@ int write_cr4_checking(unsigned long val)
 
 unsigned exception_error_code(void)
 {
-	unsigned short error_code;
-
-	asm volatile("mov %%gs:6, %0" : "=r"(error_code));
-	return error_code;
+	return this_cpu_read_exception_error_code();
 }
 
 bool exception_rflags_rf(void)
 {
-	unsigned char rf_flag;
-
-	asm volatile("movb %%gs:5, %b0" : "=q"(rf_flag));
-	return rf_flag & 1;
+	return this_cpu_read_exception_rflags_rf() & 1;
 }
 
 static char intr_alt_stack[4096];
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index b24675fd..683b25d1 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -54,15 +54,12 @@ int cpu_count(void)
 
 int smp_id(void)
 {
-	unsigned id;
-
-	asm ("mov %%gs:0, %0" : "=r"(id));
-	return id;
+	return this_cpu_read_smp_id();
 }
 
 static void setup_smp_id(void *data)
 {
-	asm ("mov %0, %%gs:0" : : "r"(apic_id()) : "memory");
+	this_cpu_write_smp_id(apic_id());
 }
 
 static void __on_cpu(int cpu, void (*function)(void *data), void *data, int wait)
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index f74845e6..eb037a46 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -1,7 +1,72 @@
 #ifndef _X86_SMP_H_
 #define _X86_SMP_H_
+
+#include <stddef.h>
 #include <asm/spinlock.h>
 
+/* Offsets into the per-cpu page. */
+struct percpu_data {
+	uint32_t  smp_id;
+	union {
+		struct {
+			uint8_t   exception_vector;
+			uint8_t   exception_rflags_rf;
+			uint16_t  exception_error_code;
+		};
+		uint32_t exception_data;
+	};
+};
+
+#define typeof_percpu(name) typeof(((struct percpu_data *)0)->name)
+#define offsetof_percpu(name) offsetof(struct percpu_data, name)
+
+#define BUILD_PERCPU_OP(name)								\
+static inline typeof_percpu(name) this_cpu_read_##name(void)				\
+{											\
+	typeof_percpu(name) val;							\
+											\
+	switch (sizeof(val)) {								\
+	case 1:										\
+		asm("movb %%gs:%c1, %0" : "=q" (val) : "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 2:										\
+		asm("movw %%gs:%c1, %0" : "=r" (val) : "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 4:										\
+		asm("movl %%gs:%c1, %0" : "=r" (val) : "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 8:										\
+		asm("movq %%gs:%c1, %0" : "=r" (val) : "i" (offsetof_percpu(name)));	\
+		break;									\
+	default:									\
+		asm volatile("ud2");							\
+	}										\
+	return val;									\
+}											\
+static inline void this_cpu_write_##name(typeof_percpu(name) val)			\
+{											\
+	switch (sizeof(val)) {								\
+	case 1:										\
+		asm("movb %0, %%gs:%c1" :: "q" (val), "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 2:										\
+		asm("movw %0, %%gs:%c1" :: "r" (val), "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 4:										\
+		asm("movl %0, %%gs:%c1" :: "r" (val), "i" (offsetof_percpu(name)));	\
+		break;									\
+	case 8:										\
+		asm("movq %0, %%gs:%c1" :: "r" (val), "i" (offsetof_percpu(name)));	\
+		break;									\
+	default:									\
+		asm volatile("ud2");							\
+	}										\
+}
+BUILD_PERCPU_OP(smp_id);
+BUILD_PERCPU_OP(exception_vector);
+BUILD_PERCPU_OP(exception_rflags_rf);
+BUILD_PERCPU_OP(exception_error_code);
+
 void smp_init(void);
 
 int cpu_count(void);
-- 
2.35.0.rc0.227.g00780c9af4-goog

