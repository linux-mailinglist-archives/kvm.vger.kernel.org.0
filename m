Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A5B50FC24
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349641AbiDZLrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349626AbiDZLr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C23C496
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5BD7A1F380;
        Tue, 26 Apr 2022 11:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJQgNh9GthCV0wSEm8gXR2v4laa9k0hS7k5GcmH5hzo=;
        b=JMFIdAWc0Of+MsNgi4LbEZHOFF8jVPL97xkfQuVCdfwxmak6CVIIrrTUXZI+OtIy1wmVKR
        2vtOXfys2J1Ep0RdivljlUUt/wZZcoamvwOk+mkU+WO7RJ7SlWmaRsUC3yCcNYHm8S2jOH
        mCKQcWzfyUQeOavbRGpvpQ0K3S8S848=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A6D1B13223;
        Tue, 26 Apr 2022 11:44:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sFg6JhHbZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:17 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 11/11] x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI
Date:   Tue, 26 Apr 2022 13:43:52 +0200
Message-Id: <20220426114352.1262-12-varad.gautam@suse.com>
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

ap_start64() currently serves as the 64-bit entrypoint for non-EFI
tests.

Having ap_start64() and save_id() written in asm prevents sharing these
routines between EFI and non-EFI tests.

Rewrite them in C and use ap_start64 as the 64-bit entrypoint in the EFI
boot flow.

With this, EFI tests support -smp > 1. smptest.efi now passes.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/apic.c       |  2 --
 lib/x86/asm/setup.h  |  3 +++
 lib/x86/setup.c      | 52 ++++++++++++++++++++++++++++++++++----------
 lib/x86/smp.c        |  1 +
 lib/x86/smp.h        |  2 ++
 x86/cstart.S         |  3 ---
 x86/cstart64.S       | 26 ----------------------
 x86/efi/efistart64.S |  5 -----
 8 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 5d4c776..6fa857c 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -243,8 +243,6 @@ void mask_pic_interrupts(void)
 	outb(0xff, 0xa1);
 }
 
-extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
-
 void init_apic_map(void)
 {
 	unsigned int i, j = 0;
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 24d4fa9..8502e7d 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -16,4 +16,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
 #endif /* CONFIG_EFI */
 
+void save_id(void);
+void ap_start64(void);
+
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7ca0fab..0066e67 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -14,6 +14,9 @@
 #include "apic.h"
 #include "apic-defs.h"
 #include "asm/setup.h"
+#include "atomic.h"
+#include "processor.h"
+#include "smp.h"
 
 extern char edata;
 
@@ -195,7 +198,22 @@ static void setup_segments64(void)
 		"1:"
 		:: "r" ((u64)KERNEL_DS), "i" (KERNEL_CS));
 }
+#endif
+
+static void setup_gdt_tss(void)
+{
+	size_t tss_offset;
 
+	/* 64-bit setup_tss does not use the stacktop argument.  */
+	tss_offset = setup_tss(NULL);
+	load_gdt_tss(tss_offset);
+
+#ifdef CONFIG_EFI
+	setup_segments64();
+#endif
+}
+
+#ifdef CONFIG_EFI
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
 	int i;
@@ -292,17 +310,6 @@ static void setup_page_table(void)
 	write_cr3((ulong)&ptl4);
 }
 
-static void setup_gdt_tss(void)
-{
-	size_t tss_offset;
-
-	/* 64-bit setup_tss does not use the stacktop argument.  */
-	tss_offset = setup_tss(NULL);
-	load_gdt_tss(tss_offset);
-
-	setup_segments64();
-}
-
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
@@ -349,6 +356,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	mask_pic_interrupts();
 	setup_page_table();
 	enable_apic();
+	save_id();
 	ap_init();
 	enable_x2apic();
 	smp_init();
@@ -371,3 +379,25 @@ void setup_libcflat(void)
 			add_setup_arg("bootloader");
 	}
 }
+
+void save_id(void)
+{
+	set_bit(apic_id(), online_cpus);
+}
+
+void ap_start64(void)
+{
+	setup_gdt_tss();
+	reset_apic();
+	load_idt();
+	save_id();
+	enable_apic();
+	enable_x2apic();
+	sti();
+	asm volatile ("nop");
+	printf("setup: AP %d online\n", apic_id());
+	atomic_inc(&cpu_online_count);
+	while (1) {
+		;
+	}
+}
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 8e5c6e8..17a5ade 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -31,6 +31,7 @@ extern u32 smp_stacktop;
 extern u8 stacktop;
 #endif
 atomic_t cpu_online_count = { .counter = 1 };
+unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 
 static __attribute__((used)) void ipi(void)
 {
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index b805be5..3a5ad1b 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -5,6 +5,7 @@
 #include <asm/spinlock.h>
 #include "libcflat.h"
 #include "atomic.h"
+#include "apic-defs.h"
 
 /* Address where to store the address of realmode GDT descriptor. */
 #define REALMODE_GDT_LOWMEM (PAGE_SIZE - 2)
@@ -86,5 +87,6 @@ void smp_reset_apic(void);
 void ap_init(void);
 
 extern atomic_t cpu_online_count;
+extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 
 #endif
diff --git a/x86/cstart.S b/x86/cstart.S
index 65782be..ed18184 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -124,7 +124,4 @@ start32:
 	push %eax
 	call exit
 
-online_cpus:
-	.fill (max_cpus + 7) / 8, 1, 0
-
 #include "start16.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 3c8d78f..53db843 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,8 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl online_cpus
-
 ipi_vector = 0x20
 
 max_cpus = MAX_TEST_CPUS
@@ -108,27 +106,6 @@ gdt32_end:
 #include "start16.S"
 
 .code64
-save_id:
-	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-	movl (%rax), %eax
-	shrl $24, %eax
-	lock btsl %eax, online_cpus
-	retq
-
-ap_start64:
-	call reset_apic
-	call load_idt
-	load_tss
-	call enable_apic
-	call save_id
-	call enable_x2apic
-	sti
-	nop
-	lock incw cpu_online_count
-
-1:	hlt
-	jmp 1b
-
 start64:
 	call reset_apic
 	call load_idt
@@ -167,6 +144,3 @@ setup_5level_page_table:
 	lretq
 lvl5:
 	retq
-
-online_cpus:
-	.fill (max_cpus + 7) / 8, 1, 0
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index d82e3fc..5635204 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -76,8 +76,3 @@ rm_trampoline_end:
 .code32
 
 #include "../start32.S"
-
-.code64:
-
-ap_start64:
-	jmp ap_start64
-- 
2.32.0

