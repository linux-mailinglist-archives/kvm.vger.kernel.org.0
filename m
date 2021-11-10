Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA044CB3B
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhKJVXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbhKJVXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:03 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5AC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:15 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z19-20020a630a53000000b002dc2f4542faso2114698pgk.13
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4WL50j77vhTJcNq8Hhp1UeI24PY+rOpBsAN0R3dl3H8=;
        b=K0utdhqnxVfIvhE1I9FjHBBwjaI1k2+90+K7hswXLzJ48bBUAaYMuxv7PlfJA8nm40
         aakikuLBQnuwgnTfBzuSUizNsyuSY6obxvIW++gtJVBa6W5IXcG2Qruq6dEeWU1twcOF
         ZHW98hEe81swK+aly6Pbs99M3QeEMCpX3O/E2cSzCra+q8Ie77y281anSdKQ+MFh+HyY
         08Vb77ZeDwmfjk+dWwiv/1imE0IgwXHtqZ08isfc4qyoaYjioxS4aJhidHrCRITZdio7
         DqVz5d2CGH2HPFzC5hbBfDzLYmvTT660B7LotY6E6e9YUzb5AiXtEooI7BLzB//yw192
         Uw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4WL50j77vhTJcNq8Hhp1UeI24PY+rOpBsAN0R3dl3H8=;
        b=igaNloZB/JfDPA6KCpRP5HF8+Z9wJwxVvCy7KrjnYYfHQN0ytl85nkF8/diJYe0C5k
         tjRRgaEheEtQp1rbEMHKRoaBTseJe57/L5jxQFE7d4ED9oOgeC5nocohJ3Ryr9vWZFcF
         w1RyC0ynz07lEx6H+FsyhCyktm4Gkmmiy33QWdReISr2iQqpnLWDboLaLwZck81uXl/K
         oziAsFWtsy397KTXBISXAAfxwlc26f5AIGGNHGOzL23JtOe7xBrIJ4E7lQfOi2r7dGYB
         X0h24R0ffOoDIouammwCvDXrdHErtCwqo9hmGqu2Ak9FLuHdveTxBfr9VNeKkxX6UkgU
         t3yA==
X-Gm-Message-State: AOAM532LqvOtKpQBAs88EpgAzPDdGJ0j6zdWSvyzUQZ1PPgO0irnya57
        2zVFeg9Uj2tC4UjtvkrGvTkZuRmcsAl5BkscBd1ygepw3KO+WqGAAi8aujVtppSdO8eZJPFicfq
        SjNDPmwxC6omYJx9h1GR8jAqqu3jRi/I+JTm6ShVczAI4Ivbr9W90NGY/LIOKqmPCMqiy
X-Google-Smtp-Source: ABdhPJy6928G5xjqPGl5P0SA8KromyLw2a6w1r2xgYqrMm5PjdGGuPkxZPkwZMmdegckHCGW+xIA1XTGSCPwt4jL
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:3748:: with SMTP id
 g8mr1289916pgn.102.1636579215281; Wed, 10 Nov 2021 13:20:15 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:51 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 04/14] replace tss_descr global with a function
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tss_descr is declared as a struct descriptor_table_ptr but it is actualy
pointing to an _entry_ in the GDT.  Also it is different per CPU, but
tss_descr does not recognize that.  Fix both by reusing the code
(already present e.g. in the vmware_backdoors test) that extracts
the base from the GDT entry; and also provide a helper to retrieve
the limit, which is needed in vmx.c.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c         | 32 ++++++++++++++++++++++++++++++++
 lib/x86/desc.h         | 25 ++++++-------------------
 x86/cstart64.S         |  1 -
 x86/svm_tests.c        | 15 +++------------
 x86/taskswitch.c       |  2 +-
 x86/vmware_backdoors.c | 22 ++++++----------------
 x86/vmx.c              |  9 +++++----
 7 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index ba0db65..94f0ddb 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -409,3 +409,35 @@ void __set_exception_jmpbuf(jmp_buf *addr)
 {
 	exception_jmpbuf = addr;
 }
+
+gdt_entry_t *get_tss_descr(void)
+{
+	struct descriptor_table_ptr gdt_ptr;
+	gdt_entry_t *gdt;
+
+	sgdt(&gdt_ptr);
+	gdt = (gdt_entry_t *)gdt_ptr.base;
+	return &gdt[str() / 8];
+}
+
+unsigned long get_gdt_entry_base(gdt_entry_t *entry)
+{
+	unsigned long base;
+	base = entry->base1 | ((u32)entry->base2 << 16) | ((u32)entry->base3 << 24);
+#ifdef __x86_64__
+	if (!entry->s) {
+		base |= (u64)((struct system_desc64 *)entry)->base4 << 32;
+	}
+#endif
+	return base;
+}
+
+unsigned long get_gdt_entry_limit(gdt_entry_t *entry)
+{
+	unsigned long limit;
+	limit = entry->limit1 | ((u32)entry->limit2 << 16);
+	if (entry->g) {
+		limit = (limit << 12) | 0xFFF;
+	}
+	return limit;
+}
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index c339e0e..51148d1 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -186,30 +186,13 @@ typedef struct {
 
 #ifdef __x86_64__
 struct system_desc64 {
-	uint16_t limit1;
-	uint16_t base1;
-	uint8_t  base2;
-	union {
-		uint16_t  type_limit_flags;      /* Type and limit flags */
-		struct {
-			uint16_t type:4;
-			uint16_t s:1;
-			uint16_t dpl:2;
-			uint16_t p:1;
-			uint16_t limit2:4;
-			uint16_t avl:1;
-			uint16_t l:1;
-			uint16_t db:1;
-			uint16_t g:1;
-		} __attribute__((__packed__));
-	} __attribute__((__packed__));
-	uint8_t  base3;
+	gdt_entry_t common;
 	uint32_t base4;
 	uint32_t zero;
 } __attribute__((__packed__));
 #endif
 
-#define DESC_BUSY ((uint64_t) 1 << 41)
+#define DESC_BUSY 2
 
 extern idt_entry_t boot_idt[256];
 
@@ -253,4 +236,8 @@ static inline void *get_idt_addr(idt_entry_t *entry)
 	return (void *)addr;
 }
 
+extern gdt_entry_t *get_tss_descr(void);
+extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
+extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
+
 #endif
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..cf38bae 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -4,7 +4,6 @@
 .globl boot_idt
 
 .globl idt_descr
-.globl tss_descr
 .globl gdt64_desc
 .globl online_cpus
 .globl cpu_online_count
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2fdb0dc..8ad6122 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1875,23 +1875,14 @@ static bool reg_corruption_check(struct svm_test *test)
 
 static void get_tss_entry(void *data)
 {
-    struct descriptor_table_ptr gdt;
-    gdt_entry_t *gdt_table;
-    struct system_desc64 *tss_entry;
-    u16 tr = 0;
-
-    sgdt(&gdt);
-    tr = str();
-    gdt_table = (gdt_entry_t *) gdt.base;
-    tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
-    *((struct system_desc64 **)data) = tss_entry;
+    *((gdt_entry_t **)data) = get_tss_descr();
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    struct system_desc64 *tss_entry;
+    gdt_entry_t *tss_entry;
     int i;
 
     on_cpu(1, get_tss_entry, &tss_entry);
@@ -1905,7 +1896,7 @@ static void init_startup_prepare(struct svm_test *test)
 
     --cpu_online_count;
 
-    *(uint64_t *)tss_entry &= ~DESC_BUSY;
+    tss_entry->type &= ~DESC_BUSY;
 
     apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
 
diff --git a/x86/taskswitch.c b/x86/taskswitch.c
index b6b3451..0fa818d 100644
--- a/x86/taskswitch.c
+++ b/x86/taskswitch.c
@@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
 
 	tss.eip += 2;
 
-	gdt32[TSS_MAIN / 8].type &= ~2;
+	gdt32[TSS_MAIN / 8].type &= ~DESC_BUSY;
 
 	set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
 }
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index b1433cd..bc10020 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -132,23 +132,13 @@ struct fault_test vmware_backdoor_tests[] = {
  */
 static void set_tss_ioperm(void)
 {
-	struct descriptor_table_ptr gdt;
-	gdt_entry_t *gdt_table;
-	struct system_desc64 *tss_entry;
-	u16 tr = 0;
+	gdt_entry_t *tss_entry;
 	tss64_t *tss;
 	unsigned char *ioperm_bitmap;
-	uint64_t tss_base;
-
-	sgdt(&gdt);
-	tr = str();
-	gdt_table = (gdt_entry_t *) gdt.base;
-	tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
-	tss_base = ((uint64_t) tss_entry->base1 |
-			((uint64_t) tss_entry->base2 << 16) |
-			((uint64_t) tss_entry->base3 << 24) |
-			((uint64_t) tss_entry->base4 << 32));
-	tss = (tss64_t *)tss_base;
+	u16 tr = str();
+
+	tss_entry = get_tss_descr();
+	tss = (tss64_t *)get_gdt_entry_base(tss_entry);
 	tss->iomap_base = sizeof(*tss);
 	ioperm_bitmap = ((unsigned char *)tss+tss->iomap_base);
 
@@ -157,7 +147,7 @@ static void set_tss_ioperm(void)
 		1 << (RANDOM_IO_PORT % 8);
 	ioperm_bitmap[VMWARE_BACKDOOR_PORT / 8] |=
 		1 << (VMWARE_BACKDOOR_PORT % 8);
-	*(uint64_t *)tss_entry &= ~DESC_BUSY;
+	tss_entry->type &= ~DESC_BUSY;
 
 	/* Update TSS */
 	ltr(tr);
diff --git a/x86/vmx.c b/x86/vmx.c
index 20dc677..d45c6de 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -75,7 +75,6 @@ union vmx_ept_vpid  ept_vpid;
 
 extern struct descriptor_table_ptr gdt64_desc;
 extern struct descriptor_table_ptr idt_descr;
-extern struct descriptor_table_ptr tss_descr;
 extern void *vmx_return;
 extern void *entry_sysenter;
 extern void *guest_entry;
@@ -1275,7 +1274,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_SEL_FS, KERNEL_DS);
 	vmcs_write(HOST_SEL_GS, KERNEL_DS);
 	vmcs_write(HOST_SEL_TR, TSS_MAIN);
-	vmcs_write(HOST_BASE_TR, tss_descr.base);
+	vmcs_write(HOST_BASE_TR, get_gdt_entry_base(get_tss_descr()));
 	vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
@@ -1291,6 +1290,8 @@ static void init_vmcs_host(void)
 
 static void init_vmcs_guest(void)
 {
+	gdt_entry_t *tss_descr = get_tss_descr();
+
 	/* 26.3 CHECKING AND LOADING GUEST STATE */
 	ulong guest_cr0, guest_cr4, guest_cr3;
 	/* 26.3.1.1 */
@@ -1331,7 +1332,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_BASE_DS, 0);
 	vmcs_write(GUEST_BASE_FS, 0);
 	vmcs_write(GUEST_BASE_GS, 0);
-	vmcs_write(GUEST_BASE_TR, tss_descr.base);
+	vmcs_write(GUEST_BASE_TR, get_gdt_entry_base(tss_descr));
 	vmcs_write(GUEST_BASE_LDTR, 0);
 
 	vmcs_write(GUEST_LIMIT_CS, 0xFFFFFFFF);
@@ -1341,7 +1342,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_LIMIT_FS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_GS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_LDTR, 0xffff);
-	vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
+	vmcs_write(GUEST_LIMIT_TR, get_gdt_entry_limit(tss_descr));
 
 	vmcs_write(GUEST_AR_CS, 0xa09b);
 	vmcs_write(GUEST_AR_DS, 0xc093);
-- 
2.34.0.rc1.387.gb447b232ab-goog

