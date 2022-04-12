Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B355F4FE718
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358134AbiDLRf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358309AbiDLRfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:35:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283985BE54
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:32:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C8E8A215FF;
        Tue, 12 Apr 2022 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OinhSGityeOeLhFUHCEBqO4+4VkBx2Lm7bYMHLdQlrM=;
        b=FFC9cdyPj5tbNN+1EPyTqs5QZ55en2XPlmZQ8E5Kwxl+NsTH0iI1nHGGZlIytETTFoS1RM
        MFmCiJa6o4LsLHiVoL8oU8dFC6eJYNM3niBOwUlhhz9WNSJvI/376ulw8+4pO87/hASkyT
        GhHuVNi3hSXV8VNX9bDzwMiFViUEX0E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 421CB13780;
        Tue, 12 Apr 2022 17:32:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WG8bDq23VWJJewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:32:29 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [PATCH 10/10] x86: Move ap_start64 and save_id to setup.c
Date:   Tue, 12 Apr 2022 19:32:21 +0200
Message-Id: <20220412173221.13315-10-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173221.13315-1-varad.gautam@suse.com>
References: <20220412173221.13315-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Writing ap_start64() and save_id() in C allows sharing these
routines between EFI and non-EFI tests.

Move these to setup.c and use ap_start64 as the 64-bit entrypoint
in the EFI boot flow.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/asm/setup.h  |  3 +++
 lib/x86/setup.c      | 54 +++++++++++++++++++++++++++++++++-----------
 lib/x86/smp.c        |  1 +
 x86/cstart64.S       | 24 --------------------
 x86/efi/efistart64.S |  5 ----
 5 files changed, 45 insertions(+), 42 deletions(-)

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
index e2f7967..a0e0b0c 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -14,8 +14,12 @@
 #include "apic.h"
 #include "apic-defs.h"
 #include "asm/setup.h"
+#include "processor.h"
+#include "atomic.h"
 
 extern char edata;
+extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
+extern unsigned cpu_online_count;
 
 struct mbi_bootinfo {
 	u32 flags;
@@ -172,7 +176,22 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 /* From x86/efi/efistart64.S */
 extern void setup_segments64(u64 gs_base);
 extern u8 stacktop;
+#endif
+
+static void setup_gdt_tss(void)
+{
+	size_t tss_offset;
 
+	/* 64-bit setup_tss does not use the stacktop argument.  */
+	tss_offset = setup_tss(NULL);
+	load_gdt_tss(tss_offset);
+#ifdef CONFIG_EFI
+	u64 gs_base = (u64)(&stacktop) - (PAGE_SIZE * (pre_boot_apic_id() + 1));
+	setup_segments64(gs_base);
+#endif
+}
+
+#ifdef CONFIG_EFI
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
 	int i;
@@ -269,19 +288,6 @@ static void setup_page_table(void)
 	write_cr3((ulong)&ptl4);
 }
 
-static void setup_gdt_tss(void)
-{
-	size_t tss_offset;
-	u64 gs_base;
-
-	/* 64-bit setup_tss does not use the stacktop argument.  */
-	tss_offset = setup_tss(NULL);
-	load_gdt_tss(tss_offset);
-
-	gs_base = (u64)(&stacktop) - (PAGE_SIZE * (pre_boot_apic_id() + 1));
-	setup_segments64(gs_base);
-}
-
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
@@ -328,6 +334,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	mask_pic_interrupts();
 	setup_page_table();
 	enable_apic();
+	save_id();
 	ap_init();
 	enable_x2apic();
 	smp_init();
@@ -350,3 +357,24 @@ void setup_libcflat(void)
 			add_setup_arg("bootloader");
 	}
 }
+
+void save_id(void)
+{
+	u32 id = apic_id();
+
+	/* atomic_fetch_or() emits `lock or %dl, (%eax)` */
+	atomic_fetch_or(&online_cpus[id / 8], (1 << (id % 8)));
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
+	atomic_fetch_inc(&cpu_online_count);
+	asm volatile("1: hlt; jmp 1b");
+}
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index cee82ac..779d346 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -22,6 +22,7 @@ static atomic_t active_cpus;
 extern u8 sipi_entry;
 extern u8 sipi_end;
 volatile unsigned cpu_online_count = 1;
+unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 
 static __attribute__((used)) void ipi(void)
 {
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 6eb109d..6363293 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -123,27 +123,6 @@ gdt32_descr:
 sipi_end:
 
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
@@ -182,6 +161,3 @@ setup_5level_page_table:
 	lretq
 lvl5:
 	retq
-
-online_cpus:
-	.fill (max_cpus + 7) / 8, 1, 0
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 149e3f7..a5d7219 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -98,8 +98,3 @@ sipi_end:
 .code32
 
 #include "../start32.S"
-
-.code64:
-
-ap_start64:
-	jmp ap_start64
-- 
2.35.1

