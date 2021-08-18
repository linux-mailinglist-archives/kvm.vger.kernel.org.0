Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6593EF68A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhHRAKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhHRAJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B667BC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso941072ybh.12
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=80llzo0Wp5v4miVUGI4wr2wLkX18AVNm2MXJI0AAcPY=;
        b=j4JGfWhMYrS/ZAGqastUFkKexVJkOkxkDWdBTYVCk3uRJ63J3lwY1yV6XeHT+uBbKb
         ikq7OsJRbD5iSUOqzY4PsMLddBhPl5BoYY+iiqDgPnYR2/XEO7j7xt1/AVUylVwllg9N
         W8habVykCu6lFhr2LwFpxFojyqd03FwAIvJ55A7XITnTyFy+C3gz4UKRGf/D+3fsq1li
         YQvNmULYUZ7JYRpKISimg9p/9NPUJrYQoD8swyIOAVL8Bw7Gt2fqMtTN7102kJL2DGdR
         qguIB6pO9/QVZm55aZUXqiiogKhx0wahCa65HPR97hKov8c7o657CH/HvqnX2hFymD/4
         qG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=80llzo0Wp5v4miVUGI4wr2wLkX18AVNm2MXJI0AAcPY=;
        b=ARcJWMBP8aD7Y94mPWTCNN92r9NHrjv1Y1BhXrecmxV+/6s/XAhOvRFU00uelz55dU
         47RPXIhex31Mg9Ndr0Mdb5pFlHY8R9Wu297SKcHPMZvafuKMBWTpSrMnOAztjnrCbEYv
         jWhd1rq3Uf7zRYqb1SDEI6Pw424xw7XqKa4naVDtmfYE/QS5yMRfRdibAXKEP0jVx9Dw
         EOrGzk9H6nPIlomGocRJBSxWWT3WcsodZkMYmL6E1n9Ynn78C1/QJSS+6PnCar/EKSMH
         Re2rcfPI7jTvCjDnVdNO0qacDia9/H1ytLsGmpsMciGVfu42ZcO+rOFHOr39v6opOsNG
         wdBw==
X-Gm-Message-State: AOAM5331QoRaDbl+8wg2M6y5uCD/RB7pySKNSmPgseJalw3le+hFG9cd
        KqaXOStCdvOmeOCGXrasNBqL0y386/bxvGAx5fG5LlZwMWrwAh4Vx2GwFfx6Y1/zzHZOtZFrGas
        knDvEpyQqsZdz1Dkgld9nLuBCOOGFwhp8ZUlA4iQOSDeYztMIhvRz3uQwkfAaqD3Xn1cf
X-Google-Smtp-Source: ABdhPJwqnwYWoFsduy2TDRSlO3gvtcUjyR4KIm0yKYcbnxDxbnty1QNSudFlq9FC4Hzfm91IgGv0J4F+1D6FDo0i
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a5b:7c4:: with SMTP id
 t4mr7861091ybq.509.1629245364896; Tue, 17 Aug 2021 17:09:24 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:55 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-7-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 06/16] x86 UEFI: Set up memory allocator
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM-Unit-Tests library implements a memory allocator which requires
two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
more details):
   1. A base (start) physical address
   2. Size of available memory for allocation

To get this memory info, we scan all the memory regions returned by
`LibMemoryMap()`, find out the largest free memory region and use it for
memory allocation.

After retrieving this memory info, we call `ExitBootServices` so that
KVM-Unit-Tests has full control of the machine, and UEFI will not touch
the memory after this point.

Starting from this commit, `x86/hypercall.c` test case can run in UEFI
and generates the same output as in Seabios.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/efi.c           | 18 ++++++++++-
 lib/x86/asm/setup.h | 20 +++++++++++-
 lib/x86/setup.c     | 79 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 018918a..a644913 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -30,10 +30,26 @@ EFI_STATUS efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab);
 EFI_STATUS efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
 {
 	int ret;
+	EFI_STATUS status;
+	UINTN mapkey = 0;
+	efi_bootinfo_t efi_bootinfo;
 
 	InitializeLib(image_handle, systab);
 
-	setup_efi();
+	setup_efi_bootinfo(&efi_bootinfo);
+	status = setup_efi_pre_boot(&mapkey, &efi_bootinfo);
+	if (EFI_ERROR(status)) {
+		printf("Failed to set up before ExitBootServices, exiting.\n");
+		return status;
+	}
+
+	status = uefi_call_wrapper(BS->ExitBootServices, 2, image_handle, mapkey);
+	if (EFI_ERROR(status)) {
+		printf("Failed to exit boot services\n");
+		return status;
+	}
+
+	setup_efi(&efi_bootinfo);
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the Guest VM */
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index eb1cf73..c22c999 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -5,7 +5,25 @@
 #include "x86/apic.h"
 #include "x86/smp.h"
 
-void setup_efi(void);
+#ifdef ALIGN
+#undef ALIGN
+#endif
+#include <efi.h>
+#include <efilib.h>
+
+/* efi_bootinfo_t: stores EFI-related machine info retrieved by
+ * setup_efi_pre_boot(), and is then used by setup_efi(). setup_efi() cannot
+ * retrieve this info as it is called after ExitBootServices and thus some EFI
+ * resources are not available.
+ */
+typedef struct {
+	phys_addr_t free_mem_start;
+	phys_addr_t free_mem_size;
+} efi_bootinfo_t;
+
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
+void setup_efi(efi_bootinfo_t *efi_bootinfo);
+EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 51be241..0f6e376 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -130,6 +130,81 @@ extern phys_addr_t ring0stacktop;
 extern gdt_entry_t gdt64[];
 extern size_t ring0stacksize;
 
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_bootinfo->free_mem_size = 0;
+	efi_bootinfo->free_mem_start = 0;
+}
+
+static EFI_STATUS setup_pre_boot_memory(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	UINTN total_entries, desc_size;
+	UINT32 desc_version;
+	char *buffer;
+	int i;
+	UINT64 free_mem_total_pages = 0;
+
+	/* Although buffer entries are later converted to EFI_MEMORY_DESCRIPTOR,
+	 * we cannot simply define buffer as 'EFI_MEMORY_DESCRIPTOR *buffer'.
+	 * Because the actual buffer entry size 'desc_size' is bigger than
+	 * 'sizeof(EFI_MEMORY_DESCRIPTOR)', i.e. there are padding data after
+	 * each EFI_MEMORY_DESCRIPTOR. So defining 'EFI_MEMORY_DESCRIPTOR
+	 * *buffer' leads to wrong buffer entries fetched.
+	 */
+	buffer = (char *)LibMemoryMap(&total_entries, mapkey, &desc_size, &desc_version);
+	if (desc_version != 1) {
+		return EFI_INCOMPATIBLE_VERSION;
+	}
+
+	/* The 'buffer' contains multiple descriptors that describe memory
+	 * regions maintained by UEFI. This code records the largest free
+	 * EfiConventionalMemory region which will be used to set up the memory
+	 * allocator, so that the memory allocator can work in the largest free
+	 * continuous memory region.
+	 */
+	for (i = 0; i < total_entries * desc_size; i += desc_size) {
+		EFI_MEMORY_DESCRIPTOR *d = (EFI_MEMORY_DESCRIPTOR *)&buffer[i];
+
+		if (d->Type == EfiConventionalMemory) {
+			if (free_mem_total_pages < d->NumberOfPages) {
+				free_mem_total_pages = d->NumberOfPages;
+				efi_bootinfo->free_mem_size = free_mem_total_pages * EFI_PAGE_SIZE;
+				efi_bootinfo->free_mem_start = d->PhysicalStart;
+			}
+		}
+	}
+
+	if (efi_bootinfo->free_mem_size == 0) {
+		return EFI_OUT_OF_RESOURCES;
+	}
+
+	return EFI_SUCCESS;
+}
+
+EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	EFI_STATUS status;
+
+	status = setup_pre_boot_memory(mapkey, efi_bootinfo);
+	if (EFI_ERROR(status)) {
+		printf("setup_pre_boot_memory() failed: ");
+		switch (status) {
+		case EFI_INCOMPATIBLE_VERSION:
+			printf("Unsupported descriptor version\n");
+			break;
+		case EFI_OUT_OF_RESOURCES:
+			printf("No free memory region\n");
+			break;
+		default:
+			printf("Unknown error\n");
+			break;
+		}
+		return status;
+	}
+
+	return EFI_SUCCESS;
+}
+
 static void setup_gdt_tss(void)
 {
 	gdt_entry_t *tss_lo, *tss_hi;
@@ -168,7 +243,7 @@ static void setup_gdt_tss(void)
 	load_gdt_tss(tss_offset);
 }
 
-void setup_efi(void)
+void setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	reset_apic();
 	setup_gdt_tss();
@@ -178,6 +253,8 @@ void setup_efi(void)
 	enable_apic();
 	enable_x2apic();
 	smp_init();
+	phys_alloc_init(efi_bootinfo->free_mem_start,
+			efi_bootinfo->free_mem_size);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

