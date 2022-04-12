Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68994FE715
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbiDLRfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358290AbiDLRfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:35:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF3F62133
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:32:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4BFD61F85B;
        Tue, 12 Apr 2022 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMgbODgQd4DT4BH60EetBQO7SAUNkwNAdYwqbBoEWQI=;
        b=rMP3sb2U0+p4uoDxDixhSXqpgHRO1eDHHhya8psoClubruRCgBIUt9K8pGpWjhvQyd6ctk
        errfBEzaSqE94X+VBv94F3OfklUchGCVMgw/g5P7QC8odow6ndk57CyMbwKLN/G8PJRTh9
        tG73U4vbjxyWYLZyITtEP9ENEns23tA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B34DE13780;
        Tue, 12 Apr 2022 17:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AIl/Kaq3VWJJewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:32:26 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [PATCH 06/10] x86: efi: Stop using UEFI-provided %gs for percpu storage
Date:   Tue, 12 Apr 2022 19:32:17 +0200
Message-Id: <20220412173221.13315-6-varad.gautam@suse.com>
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

UEFI tests do not update MSR_GS_BASE during bringup, and continue
using the GS_BASE set up by the UEFI implementation for percpu
storage.

Update this MSR during setup_segments64() to allow storing percpu
data at a sane location reserved by the testcase, and ensure that
this happens before any operation that ends up storing to the percpu
space.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/setup.c      | 9 ++++++---
 x86/efi/efistart64.S | 7 +++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7dd6677..5d32d3f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,8 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void setup_segments64(void);
+extern void setup_segments64(u64 gs_base);
+extern u8 stacktop;
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
@@ -271,12 +272,14 @@ static void setup_page_table(void)
 static void setup_gdt_tss(void)
 {
 	size_t tss_offset;
+	u64 gs_base;
 
 	/* 64-bit setup_tss does not use the stacktop argument.  */
 	tss_offset = setup_tss(NULL);
 	load_gdt_tss(tss_offset);
 
-	setup_segments64();
+	gs_base = (u64)(&stacktop) - (PAGE_SIZE * (pre_boot_apic_id() + 1));
+	setup_segments64(gs_base);
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
@@ -318,8 +321,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
-	reset_apic();
 	setup_gdt_tss();
+	reset_apic();
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index cb08230..1c38355 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -44,6 +44,13 @@ setup_segments64:
 	mov %ax, %gs
 	mov %ax, %ss
 
+	/* Setup percpu base */
+	MSR_GS_BASE = 0xc0000101
+	mov %rdi, %rax
+	mov $0, %edx
+	mov $MSR_GS_BASE, %ecx
+	wrmsr
+
 	/*
 	 * Update the code segment by putting it on the stack before the return
 	 * address, then doing a far return: this will use the new code segment
-- 
2.35.1

