Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E950FC28
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349616AbiDZLrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348851AbiDZLrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7939B3C483
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EB977210F3;
        Tue, 26 Apr 2022 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ks75h2OP26xIHmb05JzNLg1YjyI6EqGQd0PLUiejmX0=;
        b=M5usNI3nqIYsHGg8OFOX4R25arTpGP0pS0PJKMW2GHGkU7VeJ6QK+JjoOFEghz3Ig3YCDo
        7vfHYk0mLWPeDZZMpX/YTTyyGrG5i4fAY48HzqI0uDk1tb8DZfwp2Nhwe38IoDslMdgXxm
        EDMWEEd4IIn9blQrxQjWu7uuRIAfHLA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 515D713AE0;
        Tue, 26 Apr 2022 11:44:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QEp4EQvbZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:11 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 02/11] x86: Move ap_init() to smp.c
Date:   Tue, 26 Apr 2022 13:43:43 +0200
Message-Id: <20220426114352.1262-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426114352.1262-1-varad.gautam@suse.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ap_init() copies the SIPI vector to lowmem, sends INIT/SIPI to APs
and waits on the APs to come up.

Port this routine to C from asm and move it to smp.c to allow sharing
this functionality between the EFI (-fPIC) and non-EFI builds.

Call ap_init() from the EFI setup path to reset the APs to a known
location.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/alloc_page.h     |  3 ++
 lib/x86/setup.c      |  1 +
 lib/x86/smp.c        | 68 ++++++++++++++++++++++++++++++++++++++++++--
 lib/x86/smp.h        |  5 ++++
 x86/cstart.S         | 19 -------------
 x86/cstart64.S       | 19 -------------
 x86/efi/efistart64.S | 15 ++++++++++
 x86/svm_tests.c      | 10 +++----
 8 files changed, 94 insertions(+), 46 deletions(-)

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
index 683b25d..2c28fb4 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -6,6 +6,8 @@
 #include "apic.h"
 #include "fwcfg.h"
 #include "desc.h"
+#include "alloc_page.h"
+#include "asm/page.h"
 
 #define IPI_VECTOR 0x20
 
@@ -18,6 +20,11 @@ static volatile int ipi_done;
 static volatile bool ipi_wait;
 static int _cpu_count;
 static atomic_t active_cpus;
+extern u8 rm_trampoline, rm_trampoline_end;
+#ifdef __i386__
+extern u8 ap_rm_gdt_descr;
+#endif
+atomic_t cpu_online_count = { .counter = 1 };
 
 static __attribute__((used)) void ipi(void)
 {
@@ -114,8 +121,6 @@ void smp_init(void)
 	int i;
 	void ipi_entry(void);
 
-	_cpu_count = fwcfg_get_nb_cpus();
-
 	setup_idt();
 	init_apic_map();
 	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
@@ -142,3 +147,62 @@ void smp_reset_apic(void)
 
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
+	while (_cpu_count != atomic_read(&cpu_online_count)) {
+		;
+	}
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
index 06b5be6..b5a3a0f 100644
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
 #include "start16.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index cae6f51..26c3039 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -2,7 +2,6 @@
 #include "apic-defs.h"
 
 .globl online_cpus
-.globl cpu_online_count
 
 ipi_vector = 0x20
 
@@ -228,21 +227,3 @@ lvl5:
 
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
index 6a9b03b..c8f52cd 100644
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
2.32.0

