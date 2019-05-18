Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E379C2258C
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfERX1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:27:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34749 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729362AbfERX1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:27:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id j187so11672211wma.1
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t1g+Rus102tV8ksFiBg/sjLIZsLgyLKAhkEqsMuHVvA=;
        b=HpVtSCrXt4GCZl2/hD+fzvTKc4MMkoSXHG2zq+/9ElkCGCz5H+8DQ7mwNSNuoushb8
         NLIPo8ybhIAJZgsbZOek7osONuj6+wRGPECTooqLlLccqKdGSBhn09BC6Kks5Y2zhlQv
         ruuetRlkr44Q5zekSudupHZrs59B9ZHy/Nwo2HWlAnO4XBFbdJDlYVOB+tnfjfF9GqVO
         +dcnGW+jTBekOM60cqUsiMWIfuLinw4ZSwF7WIYzu0KgJ6FYf+yHD7OqVF1nKSqWuXF4
         B5hC33pWPCZx6kksI/qwy2fL+SRrx2W+0Cl50HUZlCgMDbOd4G4QnMDkHa+zJ0I/i8Aq
         0b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t1g+Rus102tV8ksFiBg/sjLIZsLgyLKAhkEqsMuHVvA=;
        b=JD4g5vRSeU6zNbd/17CSjylNbd1IHQdI86gM/I5jjw8hCjFl5jrrZsg6imQzG1fKGZ
         6MvCaYxdoR0+c8/QrSuZnugsp/DZlQKdPJqI8We08cEgYQ8QPU4jky2VdVN/NrwmT+FM
         9PO1DBR34gN+Kn8kqfFihTmHZXmdSKy/ybncKWDtEhEQ39RWMuSHyV03AU4ifXWyv8NB
         ajNlVofCJUMVnMmZvBuQ4cQhVyaRScxHdA8srKqbALhOqladIARPYFRqRqacg5GrBzBZ
         EtKgcjex2GzgDl95t293GTsRFEDL4ZwiFlBdHbdKtaff0gFNrOlJNx1R2MFmFJc2xn9K
         0EQQ==
X-Gm-Message-State: APjAAAV9VcFilrq5wYf8vsE78sGtbKsXSfCWb7UyyQBqNTABqGNLZ3vJ
        waPh1j6254in7gz7sSGrp6w=
X-Google-Smtp-Source: APXvYqydKQMsdzBG4PhodknySX0BrKs4AAHVRvYU6SEv8tlcGUqcb2V2YgHPdT+Uu+zVTy+o+4jbWg==
X-Received: by 2002:a1c:be19:: with SMTP id o25mr6577797wmf.138.1558222062553;
        Sat, 18 May 2019 16:27:42 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h15sm13418636wru.52.2019.05.18.16.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:27:41 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: APIC IDs might not be consecutive
Date:   Sat, 18 May 2019 09:07:41 -0700
Message-Id: <20190518160741.4911-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APIC IDs do not have to be consecutive. Crease a map between logical CPU
identifiers and the physical APIC IDs for this matter and add a level of
indirection.

During boot, save in a bitmap the APIC IDs of the enabled CPU and use it
later when sending IPIs.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/apic-defs.h |  7 +++++++
 lib/x86/apic.c      | 13 +++++++++++++
 lib/x86/apic.h      |  3 +++
 lib/x86/smp.c       | 10 +++++++---
 x86/apic.c          | 10 +++++-----
 x86/cstart64.S      | 16 +++++++++++++++-
 6 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index e7c3e92..7107f0f 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -1,6 +1,13 @@
 #ifndef _ASM_X86_APICDEF_H
 #define _ASM_X86_APICDEF_H
 
+/*
+ * Abuse this header file to hold the number of max-cpus, making it available
+ * both in C and ASM
+ */
+
+#define MAX_TEST_CPUS (64)
+
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
  *
diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index d4528bd..bc2706e 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -5,6 +5,7 @@
 
 void *g_apic = (void *)0xfee00000;
 void *g_ioapic = (void *)0xfec00000;
+u8 id_map[MAX_TEST_CPUS];
 
 struct apic_ops {
     u32 (*reg_read)(unsigned reg);
@@ -228,3 +229,15 @@ void mask_pic_interrupts(void)
     outb(0xff, 0x21);
     outb(0xff, 0xa1);
 }
+
+extern unsigned char online_cpus[256 / 8];
+
+void init_apic_map(void)
+{
+	unsigned int i, j = 0;
+
+	for (i = 0; i < sizeof(online_cpus) * 8; i++) {
+		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
+			id_map[j++] = i;
+	}
+}
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 651124d..537fdfb 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -4,6 +4,8 @@
 #include <stdint.h>
 #include "apic-defs.h"
 
+extern u8 id_map[MAX_TEST_CPUS];
+
 extern void *g_apic;
 extern void *g_ioapic;
 
@@ -55,6 +57,7 @@ uint32_t apic_id(void);
 int enable_x2apic(void);
 void disable_apic(void);
 void reset_apic(void);
+void init_apic_map(void);
 
 /* Converts byte-addressable APIC register offset to 4-byte offset. */
 static inline u32 apic_reg_index(u32 reg)
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2e98de8..30bd1a0 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -68,8 +68,10 @@ static void setup_smp_id(void *data)
 static void __on_cpu(int cpu, void (*function)(void *data), void *data,
                      int wait)
 {
+    unsigned int target = id_map[cpu];
+
     spin_lock(&ipi_lock);
-    if (cpu == smp_id())
+    if (target == smp_id())
 	function(data);
     else {
 	atomic_inc(&active_cpus);
@@ -78,8 +80,7 @@ static void __on_cpu(int cpu, void (*function)(void *data), void *data,
 	ipi_data = data;
 	ipi_wait = wait;
 	apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_FIXED
-                       | IPI_VECTOR,
-                       cpu);
+                       | IPI_VECTOR, target);
 	while (!ipi_done)
 	    ;
     }
@@ -112,6 +113,8 @@ int cpus_active(void)
     return atomic_read(&active_cpus);
 }
 
+extern unsigned long long online_cpus;
+
 void smp_init(void)
 {
     int i;
@@ -120,6 +123,7 @@ void smp_init(void)
     _cpu_count = fwcfg_get_nb_cpus();
 
     setup_idt();
+    init_apic_map();
     set_idt_entry(IPI_VECTOR, ipi_entry, 0);
 
     setup_smp_id(0);
diff --git a/x86/apic.c b/x86/apic.c
index 7ef4a27..83cae0c 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -272,7 +272,7 @@ static void test_self_ipi(void)
     handle_irq(vec, self_ipi_isr);
     irq_enable();
     apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | vec,
-                   0);
+                   id_map[0]);
 
     do {
         pause();
@@ -336,7 +336,7 @@ static void test_sti_nmi(void)
     on_cpu_async(1, sti_loop, 0);
     while (nmi_counter < 30000) {
 	old_counter = nmi_counter;
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 1);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[1]);
 	while (nmi_counter == old_counter) {
 	    ;
 	}
@@ -365,10 +365,10 @@ static void kick_me_nmi(void *blah)
 	if (nmi_done) {
 	    return;
 	}
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 	/* make sure the NMI has arrived by sending an IPI after it */
 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT
-		       | 0x44, 0);
+		       | 0x44, id_map[0]);
 	++cpu1_nmi_ctr2;
 	while (cpu1_nmi_ctr2 != cpu0_nmi_ctr2 && !nmi_done) {
 	    pause();
@@ -402,7 +402,7 @@ static void test_multiple_nmi(void)
 	while (cpu1_nmi_ctr1 != cpu0_nmi_ctr1) {
 	    pause();
 	}
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 	while (!nmi_flushed) {
 	    pause();
 	}
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 31e41cc..a4b55c5 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -7,10 +7,11 @@ boot_idt = 0
 .globl idt_descr
 .globl tss_descr
 .globl gdt64_desc
+.globl online_cpus
 
 ipi_vector = 0x20
 
-max_cpus = 64
+max_cpus = MAX_TEST_CPUS
 
 .bss
 
@@ -208,9 +209,18 @@ ap_start32:
 	ljmpl $8, $ap_start64
 
 .code64
+save_id:
+	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
+	mov (%rax), %eax
+	shr $24, %eax
+	movzx %ax, %rax
+	lock btsq %rax, online_cpus
+	retq
+
 ap_start64:
 	call load_tss
 	call enable_apic
+	call save_id
 	call enable_x2apic
 	sti
 	nop
@@ -223,6 +233,7 @@ start64:
 	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
+	call save_id
 	call smp_init
 	call enable_x2apic
 	mov mb_boot_info(%rip), %rbx
@@ -256,6 +267,9 @@ idt_descr:
 	.word 16 * 256 - 1
 	.quad boot_idt
 
+online_cpus:
+	.quad 0
+
 load_tss:
 	lidtq idt_descr
 	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-- 
2.17.1

