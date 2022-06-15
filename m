Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981DF54D55A
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345675AbiFOXaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348823AbiFOXaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323B13F0A
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p143-20020a25d895000000b006648c7235a6so10818856ybg.1
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2UiHUBJdG3kBglVhF7Bs3cpAVQykvhGl3NHfWFs8dP8=;
        b=mptUci4Eg1Oo63FZN6eH/CwizTI3FQNMj8e8KOZ384D+wv/17t7Uoh+NbZosgXI4AV
         V9J9jAr7XA8KEkS6adJroq/9CAINEuRf+AE+e0A2JYWGPh219kmrWTFkJjfC1kc7XrM9
         20VZgskhKA2rWPb/ploCBlevMxDtD2vKyrcXiz1bKdxXnOKlMZRfEz/EpSsbM8PvKsLw
         hl6JMuyLstw2qU5Ln87X/ayZanRX++Pnrej5tU7xXv4s1uZCzebAb4aua/sNLuhn6n0W
         cggaSwwXSzqxTCa65sPLVeHVAkpp1PLlendod65rfdyN6CMzklgcU9K59o7LZFK2CXS5
         zfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2UiHUBJdG3kBglVhF7Bs3cpAVQykvhGl3NHfWFs8dP8=;
        b=2LoPfhD2Slvyl8xYh0wFu3nGishMhaORDLRzbES1ycCbdklLMlrvpuh46wXUrDBi+Y
         Kn8Auo78fSTujSvDBpHJ5btXKiHI4h3g7DBSLX/crpRbjvLHbAnVxity7D4Qxk7TCHeY
         7SnV14tr7KqrkoCGhmM/arYf3KKs+6W7IYvpnRmEUNpsaCYKvi5jdWKxF5UPMZQOfAtD
         Jrroj/fmWS5x1gN5Xz7993w8zOKKGgdoHaC92IvC+gmRYVrckmUkac5N5kxpTKrhghvl
         6JIFDAppa8/j1P8/6QU2bJbOjMNMPUivZpSBYtEynIapb+JO7dFsriAon7xYeul/Ihb3
         Mw7w==
X-Gm-Message-State: AJIora+Bm2K+VVr0Zd6TvmH+4RzANV/lN2pN6uQNQf6avYkmtLZb4l11
        Vw7kZmnK+JN74tG9vEUosFDBbJ8HR1U=
X-Google-Smtp-Source: AGRyM1toPeRNszifjLjvljD6TsA7B45GwqlIc+EH9cIYBDJZ0ACekfu0UVzwVN48hOb/McfXYgyUqk/2DAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:c7c2:0:b0:310:1042:839e with SMTP id
 j185-20020a0dc7c2000000b003101042839emr2613960ywd.4.1655335803701; Wed, 15
 Jun 2022 16:30:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:38 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 08/13] x86: efi: Provide percpu storage
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/setup.c |  7 ++++++-
 lib/x86/smp.c   | 14 --------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 9724465..c7c0983 100644
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
index 81dacef..2f554ce 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -184,25 +184,11 @@ void ap_init(void)
 
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
2.36.1.476.g0c4daa206d-goog

