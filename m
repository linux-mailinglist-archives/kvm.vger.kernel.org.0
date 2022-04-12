Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4942E4FE72A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358298AbiDLRgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358304AbiDLRg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A1D273C
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8D111212B7;
        Tue, 12 Apr 2022 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tahramd7G+EQwr9uYHdc0OJK7wLZdQbilnfXRc3q8dc=;
        b=QWCMtfuCpzAXz80GHaHjXFgx0aKJeqG6JrDY1Dl3SfJyZdliRzwwQ3XGY1okYudRc9g5zC
        SG+kw+YXT/9qVYZWYOXcn+QA3enwUiK5IF09sP5Z/czhttgVzwbVNyrP5Mu2CD3c3+6Qjy
        AFTEBd8U52htiw/7m4UMtSkkTH8liO8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D41913780;
        Tue, 12 Apr 2022 17:34:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uPY7AQ24VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:05 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Date:   Tue, 12 Apr 2022 19:33:58 +0200
Message-Id: <20220412173407.13637-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173407.13637-1-varad.gautam@suse.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
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
index 2d63a44..86ba6de 100644
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
index 683b25d..d7f5aba 100644
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
@@ -114,8 +117,6 @@ void smp_init(void)
 	int i;
 	void ipi_entry(void);
 
-	_cpu_count = fwcfg_get_nb_cpus();
-
 	setup_idt();
 	init_apic_map();
 	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
@@ -142,3 +143,26 @@ void smp_reset_apic(void)
 
 	atomic_inc(&active_cpus);
 }
+
+void ap_init(void)
+{
+	u8 *dst_addr = 0;
+	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
+
+	asm volatile("cld");
+
+	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
+	memcpy(dst_addr, &sipi_entry, sipi_sz);
+
+	/* INIT */
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
+
+	/* SIPI */
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
+
+	_cpu_count = fwcfg_get_nb_cpus();
+
+	while (_cpu_count != cpu_online_count) {
+		;
+	}
+}
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index bd303c2..9c92853 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -78,5 +78,6 @@ void on_cpu(int cpu, void (*function)(void *data), void *data);
 void on_cpu_async(int cpu, void (*function)(void *data), void *data);
 void on_cpus(void (*function)(void *data), void *data);
 void smp_reset_apic(void);
+void ap_init(void);
 
 #endif
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 7272452..f371d06 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -157,6 +157,7 @@ gdt32:
 gdt32_end:
 
 .code16
+.globl sipi_entry
 sipi_entry:
 	mov %cr0, %eax
 	or $1, %eax
@@ -168,6 +169,7 @@ gdt32_descr:
 	.word gdt32_end - gdt32 - 1
 	.long gdt32
 
+.globl sipi_end
 sipi_end:
 
 .code32
@@ -240,21 +242,3 @@ lvl5:
 
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

