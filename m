Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FDD427303
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 23:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243456AbhJHV0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 17:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243448AbhJHV0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 17:26:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B5CC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 14:24:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id bj9-20020a170902850900b0013da209f0f3so5585395plb.6
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 14:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kHU2fv9R5YWPeUggZVPlAVwzcV4PQG5cWPQF9i4wEA4=;
        b=f1BGYg+VTqSt5n3ciJcoy7++b9aHVB0R9MlpEmrA2zPwIR4B1tHqZG4GYZsstvXyaV
         Pjn1DPZalbfq1QTS7alnR4HANTE3NlE2kiWsO/fu4DupzLo3ke5c+XHLZ4dZVGMRnMma
         CuHWN953fBW1M2n/1EtHZuRO8ec9sTGYrqih7i6nZlz9ufTpcShcJZibr/CN7y4lGvmM
         QYD2m0mVz0jwSWIegGBjdEHppKPNJ4kkAWowKf8KH+0/eA8zadTdaOT99l2aIw0LaWpN
         iBdrn7Q4owLoF4qhjo5B3CjoBFo4gbi7aZa4pbQkRNjpVzyJM8+tJxhRryAujsouRkBw
         1S7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kHU2fv9R5YWPeUggZVPlAVwzcV4PQG5cWPQF9i4wEA4=;
        b=w/nFc1qIUwqyF4m0qlJjnTtV84oUFWh3DYDDZo2W+35S3ggmyShB2tsO94CalMmwsY
         UjFvlNJ2Q6AKYbiwYigZlV8yrwssJaa9f2yPgpxujOO4jHKk9BfNg/rq2czWFX52MUms
         lmImX5uMFS1qp9GW3tBFmUMH3fOoXbUx8p97y53ZrJ+xaodJdvOHNspBHZj4f3kcuW1H
         9rCsCsKoGw+i8rdFq3+7d82HtD10+v4HcnLb9A/MAR0eiMXcTP60NsVuT1gEYzMnTqch
         0Kq+xTIFCXcNUfnUVuFX0p78O5UQWCpOWZMTST10Fz+OK0wfdey7XSY5j8GXbakIixI6
         rEBw==
X-Gm-Message-State: AOAM531HqO/SXc4/S7FBHGm42GQiOXczbWGFe+jNCTQjBQ2BdXV/7vVT
        9bIBvjkRnEHw1pdkakgFhhy1Kc//BeJ8bRJ73X/vQ2tCxiuMVY6OrRRf8Qz70xT8WERLFOpCECC
        sBsv2cZ7ZTI0RyKvPPOrrJYpUHrA2YErsCtlMJTElHDxnrvdljmjoMGYvLl2cFCs=
X-Google-Smtp-Source: ABdhPJxB2jY2FCkeAp4gCPgxMiZu0xB3j1zf0h0I/NrOxsy/fnnZMy2imhiybNQv73wnbun1IMsfCTil2Cl59A==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4c8d:: with SMTP id
 my13mr14179253pjb.101.1633728298942; Fri, 08 Oct 2021 14:24:58 -0700 (PDT)
Date:   Fri,  8 Oct 2021 14:24:46 -0700
In-Reply-To: <20211008212447.2055660-1-jmattson@google.com>
Message-Id: <20211008212447.2055660-3-jmattson@google.com>
Mime-Version: 1.0
References: <20211008212447.2055660-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH 2/3] x86: Make set_gdt_entry usable in 64-bit mode
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
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
2.33.0.882.g93a45727a2-goog

