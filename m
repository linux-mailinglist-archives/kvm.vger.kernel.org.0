Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC384F92FF
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiDHKdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiDHKdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:32 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8611DF654
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F1616215FE;
        Fri,  8 Apr 2022 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jPLp1oYrrUNuPYSXIvSFJ/Esqz6PVaPBJU4WBnBvRc=;
        b=ci9mggF1+KvU8G/+R+ZbeH7iIkk2N+LcdklSsccXz/FO8Iqs2ZgqswMKxu96v0YQykCnWs
        MGi6/LsgEUoAyFCYm8I+dM4LRNRXpFDjVtL9n+O1K4rpTqmjrlqwqFber5g1hmc/BbDWsa
        nbhbk14zMPO2P8k5B35sYXO91+QJnbc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 616F7132B9;
        Fri,  8 Apr 2022 10:31:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eC/ZFf0OUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:25 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 1/9] x86: Move ap_init() to smp.c
Date:   Fri,  8 Apr 2022 12:31:19 +0200
Message-Id: <20220408103127.19219-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408103127.19219-1-varad.gautam@suse.com>
References: <20220408103127.19219-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
 lib/x86/setup.c      |  1 +
 lib/x86/smp.c        | 28 ++++++++++++++++++++++++++--
 lib/x86/smp.h        |  1 +
 x86/cstart64.S       | 20 ++------------------
 x86/efi/efistart64.S |  9 +++++++++
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 0044b64..8be39cb 100644
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
index 2ac0ef7..1a68557 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -18,6 +18,9 @@ static volatile int ipi_done;
 static volatile bool ipi_wait;
 static int _cpu_count;
 static atomic_t active_cpus;
+extern u8 sipi_entry;
+extern u8 sipi_end;
+volatile unsigned cpu_online_count = 1;
 
 static __attribute__((used)) void ipi(void)
 {
@@ -118,8 +121,6 @@ void smp_init(void)
     int i;
     void ipi_entry(void);
 
-    _cpu_count = fwcfg_get_nb_cpus();
-
     setup_idt();
     init_apic_map();
     set_idt_entry(IPI_VECTOR, ipi_entry, 0);
@@ -146,3 +147,26 @@ void smp_reset_apic(void)
 
     atomic_inc(&active_cpus);
 }
+
+void ap_init(void)
+{
+    u8 *dst_addr = 0;
+    size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
+
+    asm volatile("cld");
+
+    /* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
+    memcpy(dst_addr, &sipi_entry, sipi_sz);
+
+    /* INIT */
+    apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
+
+    /* SIPI */
+    apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
+
+    _cpu_count = fwcfg_get_nb_cpus();
+
+    while (_cpu_count != cpu_online_count) {
+        ;
+    }
+}
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index f74845e..40255c3 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -11,5 +11,6 @@ void on_cpu(int cpu, void (*function)(void *data), void *data);
 void on_cpu_async(int cpu, void (*function)(void *data), void *data);
 void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
+void ap_init(void);
 
 #endif
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 238cebf..06daa7c 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -160,6 +160,7 @@ gdt32:
 gdt32_end:
 
 .code16
+.globl sipi_entry
 sipi_entry:
 	mov %cr0, %eax
 	or $1, %eax
@@ -171,6 +172,7 @@ gdt32_descr:
 	.word gdt32_end - gdt32 - 1
 	.long gdt32
 
+.globl sipi_end
 sipi_end:
 
 .code32
@@ -249,21 +251,3 @@ lvl5:
 
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
-
-ap_init:
-	cld
-	lea sipi_entry, %rsi
-	xor %rdi, %rdi
-	mov $(sipi_end - sipi_entry), %rcx
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
index 017abba..0425153 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -57,3 +57,12 @@ load_gdt_tss:
 	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
 	pushq %rdi
 	lretq
+
+.code16
+
+.globl sipi_entry
+sipi_entry:
+	jmp sipi_entry
+
+.globl sipi_end
+sipi_end:
-- 
2.32.0

