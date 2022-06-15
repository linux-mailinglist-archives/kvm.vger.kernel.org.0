Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8D654D538
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbiFOX36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347839AbiFOX35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:29:57 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532AC13E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:56 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g129-20020a636b87000000b00401b8392ac8so7179026pgc.4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=khUKmCI1huwExugVfBYA8RrP0sx4icvZitR+db2ggPQ=;
        b=mfTaG7McFvdBiENyvqM5EhLjmr4W4I9Yggu/pADJRl/nqYdchq/vlWgsOC86wWfDyf
         7iLOBNnM+gjAcn8FeQo+fQJIC7GUSEAx/nEGurT9UBPD6lxHbwK33AhoPcxW1/cJcds1
         5Cds0q6qc1dCeXDCBHnrXixLjcsuihd415IM2eGPclPG/0kmuoOhFkME9otv0oJVVdV9
         IwSaIglmySbpPrPge9lyLXQUofQ/Ji+eF7HIS8zkH++9oVWXfj7uibAjgecoLCDI9vzq
         eSRTio6reN8gaO7fuKMnYwFoVFNbmqlVxIVIrWTOd+7sAM5DlvT5TVRTJfpnwJVviam5
         Q/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=khUKmCI1huwExugVfBYA8RrP0sx4icvZitR+db2ggPQ=;
        b=KWcopti4BMf0GP2SH0eRqJigTYczHCdF5lgODK3PbluPI0T1g7ANyLRzlJ3Q5i6F5l
         HTDPtfAdOrEhhn22NDTe4PXZs9t8wTTi7+br+UbW9GYUON33ED4j/zwdx4Uki5NQCL1I
         3HZB0TMwHnPIHfE9csadXib1YTngmB1pj1DoXtlolVyZTUV6pF80iGlwhv9qaizrf/5b
         hCOcmt9kCO3fKCpvnNzmtAxeSXauAz3mQxrSIUSKeKnn3mziafZwA9DkVYO002mrT/bc
         CL7ZCgZtxPeXdMUCkzUu0de2ePlNY+CJz/XzfhCGeayomEkaZ97zR/+C3WdV9Rcd3AoH
         qtgw==
X-Gm-Message-State: AJIora9CF90fozbgeuywaansAzhYAMzwoHv08LC36IXTK3SQS7A5DHgU
        EXuTXbC3Q2p65tmrNNRvLq5rNHVMb3o=
X-Google-Smtp-Source: AGRyM1u0I3B+0MIoujUolGW/eLKKiJef+rebG5Pfl4azMlBT1x/zX1wBVy7q2hvN+Q+ELo87JL4IHamjvhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:35c8:b0:1ea:4cec:62d4 with SMTP id
 nb8-20020a17090b35c800b001ea4cec62d4mr1904118pjb.156.1655335795811; Wed, 15
 Jun 2022 16:29:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:33 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 03/13] x86: Move ap_init() to smp.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
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

From: Varad Gautam <varad.gautam@suse.com>

ap_init() copies the SIPI vector to lowmem, sends INIT/SIPI to APs
and waits on the APs to come up.

Port this routine to C from asm and move it to smp.c to allow sharing
this functionality between the EFI (-fPIC) and non-EFI builds.

Call ap_init() from the EFI setup path to reset the APs to a known
location.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/alloc_page.h     |  3 ++
 lib/x86/setup.c      |  1 +
 lib/x86/smp.c        | 72 ++++++++++++++++++++++++++++++++++++++++++--
 lib/x86/smp.h        |  5 +++
 x86/cstart.S         | 19 ------------
 x86/cstart64.S       | 19 ------------
 x86/efi/efistart64.S | 15 +++++++++
 x86/svm_tests.c      | 10 +++---
 8 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index eed2ba0..060e041 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -13,6 +13,9 @@
 
 #define AREA_ANY_NUMBER	0xff
 
+/* The realmode trampoline gets relocated here during bootup. */
+#define RM_TRAMPOLINE_ADDR 0
+
 #define AREA_ANY	0x00000
 #define AREA_MASK	0x0ffff
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 8a4fa3c..2004e7f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -323,6 +323,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	load_idt();
 	mask_pic_interrupts();
 	enable_apic();
+	ap_init();
 	enable_x2apic();
 	smp_init();
 	setup_page_table();
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 683b25d..81dacef 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -1,11 +1,16 @@
 
 #include <libcflat.h>
+
+#include <asm/barrier.h>
+
 #include "processor.h"
 #include "atomic.h"
 #include "smp.h"
 #include "apic.h"
 #include "fwcfg.h"
 #include "desc.h"
+#include "alloc_page.h"
+#include "asm/page.h"
 
 #define IPI_VECTOR 0x20
 
@@ -18,6 +23,13 @@ static volatile int ipi_done;
 static volatile bool ipi_wait;
 static int _cpu_count;
 static atomic_t active_cpus;
+extern u8 rm_trampoline, rm_trampoline_end;
+#ifdef __i386__
+extern u8 ap_rm_gdt_descr;
+#endif
+
+/* The BSP is online from time zero. */
+atomic_t cpu_online_count = { .counter = 1 };
 
 static __attribute__((used)) void ipi(void)
 {
@@ -114,8 +126,6 @@ void smp_init(void)
 	int i;
 	void ipi_entry(void);
 
-	_cpu_count = fwcfg_get_nb_cpus();
-
 	setup_idt();
 	init_apic_map();
 	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
@@ -142,3 +152,61 @@ void smp_reset_apic(void)
 
 	atomic_inc(&active_cpus);
 }
+
+static void setup_rm_gdt(void)
+{
+#ifdef __i386__
+	struct descriptor_table_ptr *rm_gdt =
+		(struct descriptor_table_ptr *) (&ap_rm_gdt_descr - &rm_trampoline);
+	/*
+	 * On i386, place the gdt descriptor to be loaded from SIPI vector right after
+	 * the vector code.
+	 */
+	sgdt(rm_gdt);
+#endif
+}
+
+void ap_init(void)
+{
+	void *rm_trampoline_dst = RM_TRAMPOLINE_ADDR;
+	size_t rm_trampoline_size = (&rm_trampoline_end - &rm_trampoline) + 1;
+	assert(rm_trampoline_size < PAGE_SIZE);
+
+	asm volatile("cld");
+
+	/*
+	 * Fill the trampoline page with with INT3 (0xcc) so that any AP
+	 * that goes astray within the first page gets a fault.
+	 */
+	memset(rm_trampoline_dst, 0xcc /* INT3 */, PAGE_SIZE);
+
+	memcpy(rm_trampoline_dst, &rm_trampoline, rm_trampoline_size);
+
+	setup_rm_gdt();
+
+#ifdef CONFIG_EFI
+	/*
+	 * apic_icr_write() is unusable on CONFIG_EFI until percpu area gets set up.
+	 * Use raw writes to APIC_ICR to send IPIs for time being.
+	 */
+	volatile u32 *apic_icr = (volatile u32 *) (APIC_DEFAULT_PHYS_BASE + APIC_ICR);
+
+	/* INIT */
+	*apic_icr = APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT;
+
+	/* SIPI */
+	*apic_icr = APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP;
+#else
+	/* INIT */
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
+
+	/* SIPI */
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
+#endif
+
+	_cpu_count = fwcfg_get_nb_cpus();
+
+	printf("smp: waiting for %d APs\n", _cpu_count - 1);
+	while (_cpu_count != atomic_read(&cpu_online_count))
+		cpu_relax();
+}
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index bd303c2..77f8a19 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -3,6 +3,8 @@
 
 #include <stddef.h>
 #include <asm/spinlock.h>
+#include "libcflat.h"
+#include "atomic.h"
 
 /* Offsets into the per-cpu page. */
 struct percpu_data {
@@ -78,5 +80,8 @@ void on_cpu(int cpu, void (*function)(void *data), void *data);
 void on_cpu_async(int cpu, void (*function)(void *data), void *data);
 void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
+void ap_init(void);
+
+extern atomic_t cpu_online_count;
 
 #endif
diff --git a/x86/cstart.S b/x86/cstart.S
index 8aa29ee..88d25fc 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -124,26 +124,7 @@ start32:
 	push %eax
 	call exit
 
-ap_init:
-	cld
-	sgdtl ap_rm_gdt_descr // must be close to rm_trampoline for real mode access to work
-	lea rm_trampoline, %esi
-	xor %edi, %edi
-	mov $(rm_trampoline_end - rm_trampoline), %ecx
-	rep movsb
-	mov $APIC_DEFAULT_PHYS_BASE, %eax
-	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%eax)
-	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%eax)
-	call fwcfg_get_nb_cpus
-1:	pause
-	cmpw %ax, cpu_online_count
-	jne 1b
-	ret
-
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
-.align 2
-cpu_online_count:	.word 1
-
 #include "trampolines.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 129ef0b..f0d12fb 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -2,7 +2,6 @@
 #include "apic-defs.h"
 
 .globl online_cpus
-.globl cpu_online_count
 
 ipi_vector = 0x20
 
@@ -227,21 +226,3 @@ lvl5:
 
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
-
-ap_init:
-	cld
-	lea rm_trampoline, %rsi
-	xor %rdi, %rdi
-	mov $(rm_trampoline_end - rm_trampoline), %rcx
-	rep movsb
-	mov $APIC_DEFAULT_PHYS_BASE, %eax
-	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%rax)
-	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%rax)
-	call fwcfg_get_nb_cpus
-1:	pause
-	cmpw %ax, cpu_online_count
-	jne 1b
-	ret
-
-.align 2
-cpu_online_count:	.word 1
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 017abba..7d50f96 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -57,3 +57,18 @@ load_gdt_tss:
 	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
 	pushq %rdi
 	lretq
+
+.code16
+
+.globl rm_trampoline
+rm_trampoline:
+
+.globl sipi_entry
+sipi_entry:
+	jmp sipi_entry
+
+.globl sipi_end
+sipi_end:
+
+.globl rm_trampoline_end
+rm_trampoline_end:
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1bd4d3b..f8c0589 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -17,8 +17,6 @@ static void *scratch_page;
 
 #define LATENCY_RUNS 1000000
 
-extern u16 cpu_online_count;
-
 u64 tsc_start;
 u64 tsc_end;
 
@@ -1955,20 +1953,20 @@ static void init_startup_prepare(struct svm_test *test)
 
     on_cpu(1, get_tss_entry, &tss_entry);
 
-    orig_cpu_count = cpu_online_count;
+    orig_cpu_count = atomic_read(&cpu_online_count);
 
     apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
                    id_map[1]);
 
     delay(100000000ULL);
 
-    --cpu_online_count;
+    atomic_dec(&cpu_online_count);
 
     tss_entry->type &= ~DESC_BUSY;
 
     apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
 
-    for (i = 0; i < 5 && cpu_online_count < orig_cpu_count; i++)
+    for (i = 0; i < 5 && atomic_read(&cpu_online_count) < orig_cpu_count; i++)
        delay(100000000ULL);
 }
 
@@ -1979,7 +1977,7 @@ static bool init_startup_finished(struct svm_test *test)
 
 static bool init_startup_check(struct svm_test *test)
 {
-    return cpu_online_count == orig_cpu_count;
+    return atomic_read(&cpu_online_count) == orig_cpu_count;
 }
 
 static volatile bool init_intercept;
-- 
2.36.1.476.g0c4daa206d-goog

