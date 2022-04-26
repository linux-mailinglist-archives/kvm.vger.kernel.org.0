Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3004F50FC2B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349633AbiDZLrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349618AbiDZLrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008A3C497
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6847D1F38D;
        Tue, 26 Apr 2022 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0EZbKPI4tGlMbhjIyOpWmpTpXTFvDqKnmVxldhcuDqs=;
        b=tXprW4oOk2juNMwKCErh9xHqTcjN6cRl8wYcZtYzCk1OfQmEKZYnw1iCElCnSJDTGWixwt
        wq1iQHr6746R2I/sFTFOH+rFUQ2lF59+IRhTDrEhKOdtmqI9pSY5m0pmRbpinI8u0+x9cG
        +Bc+nY+rOvT7pKTjoH7OYVOvv7lKtt0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C3EE913223;
        Tue, 26 Apr 2022 11:44:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8LtYLQ7bZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:14 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 07/11] x86: efi: Provide percpu storage
Date:   Tue, 26 Apr 2022 13:43:48 +0200
Message-Id: <20220426114352.1262-8-varad.gautam@suse.com>
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

UEFI tests do not update MSR_GS_BASE during bringup, and continue
using the GS_BASE set up by the UEFI implementation for percpu
storage.

Update this MSR during setup_segments64() to allow storing percpu
data at a sane location reserved by the testcase, and ensure that
this happens before any operation that ends up storing to the percpu
space.

Since apic_ops (touched by reset_apic()) is percpu, move reset_apic()
to happen after setup_gdt_tss(). With this, ap_init() can now use
percpu apic_ops via apic_icr_write().

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/setup.c |  7 ++++++-
 lib/x86/smp.c   | 14 --------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 367c13f..c34a8bb 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -169,6 +169,8 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 #ifdef CONFIG_EFI
 
+static struct percpu_data __percpu_data[MAX_TEST_CPUS];
+
 static void setup_segments64(void)
 {
 	/* Update data segments */
@@ -178,6 +180,9 @@ static void setup_segments64(void)
 	write_gs(KERNEL_DS);
 	write_ss(KERNEL_DS);
 
+	/* Setup percpu base */
+	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
+
 	/*
 	 * Update the code segment by putting it on the stack before the return
 	 * address, then doing a far return: this will use the new code segment
@@ -337,8 +342,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
-	reset_apic();
 	setup_gdt_tss();
+	reset_apic();
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2c28fb4..90f6210 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -179,25 +179,11 @@ void ap_init(void)
 
 	setup_rm_gdt();
 
-#ifdef CONFIG_EFI
-	/*
-	 * apic_icr_write() is unusable on CONFIG_EFI until percpu area gets set up.
-	 * Use raw writes to APIC_ICR to send IPIs for time being.
-	 */
-	volatile u32 *apic_icr = (volatile u32 *) (APIC_DEFAULT_PHYS_BASE + APIC_ICR);
-
-	/* INIT */
-	*apic_icr = APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT;
-
-	/* SIPI */
-	*apic_icr = APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP;
-#else
 	/* INIT */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
 
 	/* SIPI */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
-#endif
 
 	_cpu_count = fwcfg_get_nb_cpus();
 
-- 
2.32.0

