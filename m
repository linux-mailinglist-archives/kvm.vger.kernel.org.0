Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0571959E3AE
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiHWM1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 08:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbiHWMYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 08:24:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1548CF2D4B
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 02:43:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 30EA621007;
        Tue, 23 Aug 2022 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661247811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HsDJKQg5E37eVzTrWlAr8k1Jv/m49ZRSyYNac9yv/Y8=;
        b=2WXO9Jj/rDxtPiV897lD4xg8sdZCiLL4QsP8opsrpQhN+nabt/jXYKJg3tqP4+YIEzcp27
        7amMrw2OlZNtZbJF85A7h29fjJtBF5zbyueetrY690tImXLNPoSGNazVFel/j167xFp6Oh
        v8V3LY38lMgtXRD0i7gEAAevhXKKQcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661247811;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HsDJKQg5E37eVzTrWlAr8k1Jv/m49ZRSyYNac9yv/Y8=;
        b=YW2llvTN96cFQWTU4OJF83f4qXbphU+dfSkFLDGM/ee9cI2FD9xT7M6dEzd42vltHd8OZ4
        Esw3uSsNd/P6MBBQ==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id C65622C142;
        Tue, 23 Aug 2022 09:43:30 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, Thomas.Lendacky@amd.com, bp@alien8.de,
        erdemaktas@google.com, jroedel@suse.de, marcorr@google.com,
        pbonzini@redhat.com, rientjes@google.com, varad.gautam@suse.com,
        zxwang42@gmail.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v1] x86: efi: set up the IDT before accessing MSRs.
Date:   Tue, 23 Aug 2022 11:43:28 +0200
Message-Id: <20220823094328.8458-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reading or writing MSR_IA32_APICBASE is typically an intercepted
operation and causes #VC exception when the test is launched as
an SEV-ES guest.

So calling pre_boot_apic_id() and reset_apic() before the IDT is
set up in setup_idt() and load_idt() might cause problems.

Hence move percpu data setup and reset_apic() call after
setup_idt() and load_idt().

Fixes: 3c50214c97f173f5e0f82c7f248a7c62707d8748 (x86: efi: Provide percpu storage)
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/setup.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7df0256..712e292 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -192,8 +192,6 @@ static void setup_segments64(void)
 	write_gs(KERNEL_DS);
 	write_ss(KERNEL_DS);

-	/* Setup percpu base */
-	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);

 	/*
 	 * Update the code segment by putting it on the stack before the return
@@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		}
 		return status;
 	}
-
+
 	status = setup_rsdp(efi_bootinfo);
 	if (status != EFI_SUCCESS) {
 		printf("Cannot find RSDP in EFI system table\n");
@@ -344,14 +342,20 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	}

 	setup_gdt_tss();
-	/*
-	 * GS.base, which points at the per-vCPU data, must be configured prior
-	 * to resetting the APIC, which sets the per-vCPU APIC ops.
-	 */
 	setup_segments64();
-	reset_apic();
 	setup_idt();
 	load_idt();
+	/*
+	 * Load GS.base with the per-vCPU data.  This must be done after
+	 * loading the IDT as reading the APIC ID may #VC when running
+	 * as an SEV-ES guest
+	 */
+	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
+	/*
+	 * Resetting the APIC sets the per-vCPU APIC ops and so must be
+	 * done after loading GS.base with the per-vCPU data.
+	 */
+	reset_apic();
 	mask_pic_interrupts();
 	setup_page_table();
 	enable_apic();
--
2.34.1

