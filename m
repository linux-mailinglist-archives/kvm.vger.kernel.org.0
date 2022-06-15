Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0209F54D556
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346026AbiFOXaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348302AbiFOXaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E3E13EBF
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p9-20020a17090a0e4900b001eaa92b5b95so53074pja.4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HtAykVdkxj7RmJcfMNvowUc/nIOJ600006hs63A8ais=;
        b=TJHHtaMeenwI/+gRDQIq8bB57SzbCyvh773SHNuyJt2SsxwDeddCdvK++XMfnBS75z
         eUhAgjQcg5LFbFpJD04xCJ9Mqwz/2f8EFXmfuS0p2m4y4yOJ4SSfS2iMIJU4BZEmVSOG
         cIBDeOlzN2NxxZQsTW78X7iO7Rku/E4KlS+trx7lgCpjusR96WCUtdY2kF6x1oJ52aYu
         eJXLAXNOyBXBC+hlpMD6vNEEoCj/hBxX9Wu+WwvJoGNv4BQpOpM50Tn+AIKHeR719wJu
         y18WBRkfDNCv+QYSVDRS6vemVSKI2h/Bm9SquVCz4iykFI6TJc06D4s96JUuPseszJHw
         woBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HtAykVdkxj7RmJcfMNvowUc/nIOJ600006hs63A8ais=;
        b=IMhwnRPq9erD/BjrLMwn6GwIVUDSFIXF9Objs1ZZIOMXnjfuuk6uwbVAA0j5NrKk8Y
         Xczr8faGNV5MepZdDRnhAa1sp664iP4Aqi/OXZi8x0UQ2awLlzOy70NbpC6VO6elZpgK
         Jh/CSFv4A1iPFZO2yz7kLYydm4ieuvISF9ZmvOloZS3XPqW7W9oD6t80YpjOw4sTHC5+
         y8yOsMfeIVpUhrFfBCjb6KKH2gkr6NsTyiU6of+ALsb0JRrfw3EOgHsJfJxIW7ro37Ht
         8mbEScSk1i1VMsT/Ii+NgFsDmon1kGpidA/ANOq1VjJewF88K8sT7FSACKBtplt0qM7U
         hNzg==
X-Gm-Message-State: AJIora/QTwI+lgA4Y5I3oxGfPUSARatFxOR2qnHUE2KQ2r3Pr0hPZ+8u
        hqx8O4p3utI4CLPLx2P0OSZ7ytT7Suk=
X-Google-Smtp-Source: AGRyM1siH8B9Z3Qrvzh5NXkjjCckWL0g2liOuShYyZfFNTvvgX0JoOZwdFyiXq+zbXKEmwkC9GtZtYOyFmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d904:b0:163:dd91:87 with SMTP id
 c4-20020a170902d90400b00163dd910087mr1902586plz.34.1655335808146; Wed, 15 Jun
 2022 16:30:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:41 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 11/13] x86: Provide a common 64-bit AP
 entrypoint for EFI and non-EFI
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

ap_start64() currently serves as the 64-bit entrypoint for non-EFI
tests.

Having ap_start64() and save_id() written in asm prevents sharing these
routines between EFI and non-EFI tests.

Rewrite them in C and use ap_start64 as the 64-bit entrypoint in the EFI
boot flow.

With this, EFI tests support -smp > 1. smptest.efi now passes.

Cc: Andrew Jones <drjones@redhat.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Zixuan Wang <zxwang42@gmail.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas.Lendacky@amd.com
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
[sean: halt in AP wait loop, add comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.c       |  2 --
 lib/x86/asm/setup.h  |  3 +++
 lib/x86/setup.c      | 53 +++++++++++++++++++++++++++++++++++---------
 lib/x86/smp.c        |  1 +
 lib/x86/smp.h        |  2 ++
 x86/cstart.S         |  3 ---
 x86/cstart64.S       | 26 ----------------------
 x86/efi/efistart64.S |  5 -----
 8 files changed, 48 insertions(+), 47 deletions(-)

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
index 2d199b4..2f60a58 100644
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
 
+static void setup_gdt_tss(void)
+{
+	size_t tss_offset;
+
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
@@ -371,3 +379,26 @@ void setup_libcflat(void)
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
+
+	/* Only the BSP runs the test's main(), APs are given work via IPIs. */
+	for (;;)
+		asm volatile("hlt");
+}
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 022d627..e056181 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -37,6 +37,7 @@ extern u8 stacktop;
 
 /* The BSP is online from time zero. */
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
index 20fcb64..0707985 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -124,7 +124,4 @@ start32:
 	push %eax
 	call exit
 
-online_cpus:
-	.fill (max_cpus + 7) / 8, 1, 0
-
 #include "trampolines.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 0a561ce..e44d46c 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,8 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl online_cpus
-
 ipi_vector = 0x20
 
 max_cpus = MAX_TEST_CPUS
@@ -105,27 +103,6 @@ gdt32:
 gdt32_end:
 
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
@@ -164,6 +141,3 @@ setup_5level_page_table:
 	lretq
 lvl5:
 	retq
-
-online_cpus:
-	.fill (max_cpus + 7) / 8, 1, 0
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index a514612..3fc1601 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -74,8 +74,3 @@ sipi_end:
 rm_trampoline_end:
 
 #include "../trampolines.S"
-
-.code64:
-
-ap_start64:
-	jmp ap_start64
-- 
2.36.1.476.g0c4daa206d-goog

