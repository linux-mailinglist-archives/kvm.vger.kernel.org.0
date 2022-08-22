Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5B59C2A9
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiHVPZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 11:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiHVPYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 11:24:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224339FC3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:21:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D038034818;
        Mon, 22 Aug 2022 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661181694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBoi86THM9qPj5mrwQMgbIIxpyxVQj7rA0y6fRm2D14=;
        b=sSkPUOHpP5xBtFKel8lMMXkK51aSTJGNEDPgrfScvxtLwrqV9TFnBSpA4YEf6ttx6yrgJu
        +DZhn0+sdguW2PGbiu9bwz096/+BktEkhQiIGF+/ebMSbsheOVrVK1y+Nj43vd3h+6YYcE
        trUB2HIhTXOR5Vnwa2yaTpSDTpRIPMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661181694;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBoi86THM9qPj5mrwQMgbIIxpyxVQj7rA0y6fRm2D14=;
        b=SeXoOkKZRioDyqj/0TxtIMHUmREpfyrAsp1PXFGGNYppZMvqRsl2C30wJeMZY2CMvG7Bsv
        /EZP+hSUcUeF2+DA==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 794D52C141;
        Mon, 22 Aug 2022 15:21:34 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     seanjc@google.com
Cc:     Thomas.Lendacky@amd.com, bp@alien8.de, drjones@redhat.com,
        erdemaktas@google.com, jroedel@suse.de, kvm@vger.kernel.org,
        marcorr@google.com, pbonzini@redhat.com, rientjes@google.com,
        zxwang42@gmail.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: Re: [kvm-unit-tests PATCH v4 08/13] x86: efi: Provide percpu storage
Date:   Mon, 22 Aug 2022 17:21:23 +0200
Message-Id: <20220822152123.18983-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615232943.1465490-9-seanjc@google.com>
References: <20220615232943.1465490-9-seanjc@google.com>
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

Writing to MSR_IA32_APICBASE in reset_apic() is an
intercepted operation and causes #VC exception when the test is launched as
an SEV-ES guest.

So calling reset_apic() before IDT is set up in setup_idt() and
load_idt() might cause problems. Similarly if accessing _percpu_data
array element in setup_segments64() results in a page fault,
this will lead to a double fault.

Hence move reset_apic() call and percpu data setup after
setup_idt() and load_idt().
---
 lib/x86/setup.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7df0256..b14e692 100644
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
@@ -344,14 +342,15 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	}

 	setup_gdt_tss();
+	setup_segments64();
+	setup_idt();
+	load_idt();
 	/*
 	 * GS.base, which points at the per-vCPU data, must be configured prior
 	 * to resetting the APIC, which sets the per-vCPU APIC ops.
 	 */
-	setup_segments64();
+	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
 	reset_apic();
-	setup_idt();
-	load_idt();
 	mask_pic_interrupts();
 	setup_page_table();
 	enable_apic();
--
2.34.1

