Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C70E42FC9D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 21:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhJOT5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 15:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbhJOT5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 15:57:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C21DC061765
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l12-20020a170903120c00b0013eb930584fso4055829plh.22
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nh3iOPVtTY5TDAEvbMbZ/BFdzz0S1YCESKT4iOqSd+Y=;
        b=eojiSZM3TE2rZIQXxCrm067BejbHPKN1nwzwYT5J5m9bcwG82uA38lo8uSHIAcJS3A
         e8avCleNOyYCbrB/+L3HT97fcWE3WrufCauGiNLJpWOpn4o9Oq2DYnWDVCzc+3Ru15Lo
         PyRSCm8Zte/xCQkNJW/+xFa9FS3poTTAzZV+Sr9VgS/vkZ3aSM6NuZhF1zd7YfvlCNlP
         D3ppRDuJmezTlLVzwqCnBUKHxR5lPWmtsWg3x6oxJybfl0tYSW6ZJXu0YTD8LiH3Xlee
         uMODFZYPXpFe9RSbA2nXeF7w8YSzYVA0aKkUOT7ftFLJ2YVSZoITdSrAqTzorB3TUO0U
         mLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nh3iOPVtTY5TDAEvbMbZ/BFdzz0S1YCESKT4iOqSd+Y=;
        b=AnEREQcx6VByuaiETu8kQf/Z9YzEqSudCsGxALZwExoDxk13EkwH5Ynnk7Biz8aL6K
         phrgCKLLfRID8/VhN0ROWj5mO3mpVrWZozgeS4hW/lViWank55Im6b4SWzI0Wuqpxz6L
         YTwfhW/7pesr4BXGSGtiwZQCrKEMsTFnV6Z/0ahROgYVcbr70EZQ4MPhyTgXF/Cpm2Jl
         cZDDSCyq9BJNXkeeMddJpKh0OzbbpMXWIQxIJAeLU84HfmRwbKBuLIPdUPlsSZaCeDY4
         LgaFQX+q/DHjZVJZUCMi1JsYlq+UwvnaJEYPH88l17byQ8lv/QT7ILl9+vE8yweImT6P
         yeNQ==
X-Gm-Message-State: AOAM5317ppB8JuZNv8M6uNFHjSQtdDX5rka3kfsCtFSi11QBJzOZ7b60
        RsaVdhrOxrxYOgvdVqrNO9BRep5J85VhxmMkO2w9B4ern0IbspJI5sve5t3MgkmC4SuwScFZsnQ
        XIJOYSMOEoqYhei3+h8MPVkOTXppPEuCLkEvwgNAaUlC2up3iY3O8Hf08s28SMTg=
X-Google-Smtp-Source: ABdhPJy66O3ya2NA4DA49ElmDwAuBQr8XNEMh3eMy+xJ2BcH8GYiXrl5JyEnblix7tTUR5mLEUG9kxzM/V2sLA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:ed8c:b0:13f:136f:efb1 with SMTP
 id e12-20020a170902ed8c00b0013f136fefb1mr12717613plj.56.1634327736462; Fri,
 15 Oct 2021 12:55:36 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:55:29 -0700
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
Message-Id: <20211015195530.301237-3-jmattson@google.com>
Mime-Version: 1.0
References: <20211015195530.301237-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH v2 2/3] x86: Make set_gdt_entry usable in
 64-bit mode
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The omission of a 64-bit implementation of set_gdt_entry was probably
just an oversight, since the declaration is in scope.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/desc.c | 41 +++++++++++++++++++++++++++++++----------
 lib/x86/desc.h |  3 ++-
 x86/cstart64.S |  1 +
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1d372a..87e2850f46c6 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -279,23 +279,39 @@ bool exception_rflags_rf(void)
 
 static char intr_alt_stack[4096];
 
-#ifndef __x86_64__
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
+static void __set_gdt_entry(int sel, uintptr_t base, u32 limit, u8 access,
+			    u8 gran, gdt_entry_t *gdt)
 {
 	int num = sel >> 3;
 
 	/* Setup the descriptor base address */
-	gdt32[num].base_low = (base & 0xFFFF);
-	gdt32[num].base_middle = (base >> 16) & 0xFF;
-	gdt32[num].base_high = (base >> 24) & 0xFF;
+	gdt[num].base_low = (base & 0xFFFF);
+	gdt[num].base_middle = (base >> 16) & 0xFF;
+	gdt[num].base_high = (base >> 24) & 0xFF;
 
 	/* Setup the descriptor limits */
-	gdt32[num].limit_low = (limit & 0xFFFF);
-	gdt32[num].granularity = ((limit >> 16) & 0x0F);
+	gdt[num].limit_low = (limit & 0xFFFF);
+	gdt[num].granularity = ((limit >> 16) & 0x0F);
+
+	/* Penultimately, set up the granularity and access flags */
+	gdt[num].granularity |= (gran & 0xF0);
+	gdt[num].access = access;
+
+#ifdef __x86_64__
+	/* 64-bit system descriptors take up two slots */
+	if (!(access & 0x10000)) {
+		u32 *p = (u32 *)&gdt[num + 1];
 
-	/* Finally, set up the granularity and access flags */
-	gdt32[num].granularity |= (gran & 0xF0);
-	gdt32[num].access = access;
+		p[0] = base >> 32;
+		p[1] = 0;
+	}
+#endif
+}
+
+#ifndef __x86_64__
+void set_gdt_entry(int sel, uintptr_t base, u32 limit, u8 access, u8 gran)
+{
+	__set_gdt_entry(sel, base, limit, access, gran, gdt32);
 }
 
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
@@ -366,6 +382,11 @@ void print_current_tss_info(void)
 		       tr, tr ? "interrupt" : "main", tss.prev, tss_intr.prev);
 }
 #else
+void set_gdt_entry(int sel, uintptr_t base, u32 limit, u8 access, u8 gran)
+{
+	__set_gdt_entry(sel, base, limit, access, gran, gdt64);
+}
+
 void set_intr_alt_stack(int e, void *addr)
 {
 	set_idt_entry(e, addr, 0);
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38c79a1..994f1d791130 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -208,6 +208,7 @@ void set_idt_task_gate(int vec, u16 sel);
 void set_intr_task_gate(int vec, void *fn);
 void setup_tss32(void);
 #else
+extern gdt_entry_t gdt64[];
 extern tss64_t tss;
 #endif
 
@@ -218,7 +219,7 @@ bool exception_rflags_rf(void);
 void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran);
+void set_gdt_entry(int sel, uintptr_t base,  u32 limit, u8 access, u8 gran);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38543cc..62ace3512bb0 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -62,6 +62,7 @@ gdt64_desc:
 	.word gdt64_end - gdt64 - 1
 	.quad gdt64
 
+.globl gdt64
 gdt64:
 	.quad 0
 	.quad 0x00af9b000000ffff // 64-bit code segment
-- 
2.33.0.1079.g6e70778dc9-goog

