Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EA43EF68C
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhHRAKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhHRAKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2070EC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so958110yba.9
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gq+z6grPiM8Bpp7zLCRJwpCsdutqoD4UjnEbmJiL6NA=;
        b=kqXgG1XZdIU3HpLEmSJpGSKl2oZ3npyVzYqbbTVbH4yYr1Pf4WeFxOK961vSEM2nu0
         gfJyyLmKIFC8qrCYASgAd2+vwJAIGlRCYNWMyXDzoSSMPgB9A1dkcu3J5oo6K9Tp6sAY
         mT3EB6h9sI+xQUYGEm1bxtFSlXMykEC/QD6HJMxunGreCwzeuQUqsnt/Wxmq2mzMJ3cn
         ZqtR1sO6Q5hgFcqQzo9ewdIgNR59ISYqukhBwvpNcL3LTp+MYqgUqey7Q15AEQVaeibQ
         MEt3e2ybGdmh7s+9W/XgWoSW8o9dHeDQ+d0jaM5tKFim2arxstz8IGLMib7QsHm7p2dB
         85rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gq+z6grPiM8Bpp7zLCRJwpCsdutqoD4UjnEbmJiL6NA=;
        b=sZhPSzFr4qJeDNFTlUuPfUvLvXG+6uXo2tE/64CIKP7tcy6LFIWvoHXNEMqx1BkR7j
         uJnZhLhSw/hwQPsjHQluZg4Bn996HI+ufF3m+nmze4Tezm/Y5txnxrRPdZtZedSnBUZI
         D4hzwCJuTKyS5H4S0AJ0PTcRRXRZ96WbgfsDA+OCepVCmH9IKLYhWYQa35B+9xhPuiCQ
         /LZ41W7Zor7T7dlDf5Xv+Y48QfHQ127tJ1yo0xZ4B61fWQKruioXqrh+LfHruzkf1kuE
         OF/bduQHhhIb0qbuL55kvvafzQae4Ey0K1jt1VVBxZJuFs8R+/X00Jbn1CCavaIuaiT5
         /fSA==
X-Gm-Message-State: AOAM533zJ428yJ3RW/2BZ1LmfXO2EeBfQ3HX6X2IeVWLSvYg7yaP76OD
        n0ZMAIz3K1rZd9y/h2d1asJkxNexEO5TOnEDgRYZZwSqvbU8ux4C0wezjp2sjBbyvSCBT9NBBnm
        XToRS13yQScLIYwbY9lx+dPJD+fckXlCAz6SEXa2fMzqMAGTRNDR3ZZYplMCj3QaTEbir
X-Google-Smtp-Source: ABdhPJyeJDna0GZVSILfrz2p8E7rZnockMypKmYclgL417G/Kl0HNMvwJ3gECaJ+yYM9q8aO2NljMTx1Owvkh1T+
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:3717:: with SMTP id
 e23mr1708144yba.66.1629245368348; Tue, 17 Aug 2021 17:09:28 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:57 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-9-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 08/16] x86 UEFI: Set up page tables
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

UEFI sets up page tables before executing EFI application binaries.
These page tables do not allow user space code to access kernel space
memory. But `x86/syscall.c` test case places a user space function
`syscall_tf_user32` inside kernel space memory. When using UEFI page
tables, fetching this kernel memory from user space triggers a #PF
fault, which is not expected by this test case.

KVM-Unit-Tests defines page tables that allow such behavior. So the
solution to this problem is to load KVM-Unit-Tests' page tables:

   1. Copy the page table definition from `x86/cstart64.S`
   2. Update page table entries with runtime memory addresses
   3. Update CR3 register with the new page table root address

Since this commit, `x86/syscall.c` can run in UEFI and generate same
output as in Seabios, using the following command:

   ./x86/efi/run ./x86/syscall.efi --cpu Opteron_G1,vendor=AuthenticAMD

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/asm/page.h   |  1 +
 lib/x86/asm/setup.h  |  3 +++
 lib/x86/setup.c      | 57 ++++++++++++++++++++++++++++++++++++++++++++
 x86/efi/efistart64.S | 21 ++++++++++++++++
 4 files changed, 82 insertions(+)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index fc14160..f6f740b 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -31,6 +31,7 @@ typedef unsigned long pgd_t;
 #define PT_ACCESSED_MASK	(1ull << 5)
 #define PT_DIRTY_MASK		(1ull << 6)
 #define PT_PAGE_SIZE_MASK	(1ull << 7)
+#define PT_GLOBAL_MASK		(1ull << 8)
 #define PT64_NX_MASK		(1ull << 63)
 #define PT_ADDR_MASK		GENMASK_ULL(51, 12)
 
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 2115a75..c32168e 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -4,7 +4,9 @@
 #ifdef TARGET_EFI
 #include "x86/acpi.h"
 #include "x86/apic.h"
+#include "x86/processor.h"
 #include "x86/smp.h"
+#include "asm/page.h"
 
 #ifdef ALIGN
 #undef ALIGN
@@ -26,6 +28,7 @@ typedef struct {
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
 void setup_efi(efi_bootinfo_t *efi_bootinfo);
 EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo);
+void setup_5level_page_table(void);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 3695c4a..0b0dbea 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -217,6 +217,62 @@ EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
 	return EFI_SUCCESS;
 }
 
+/* Defined in cstart64.S or efistart64.S */
+extern phys_addr_t ptl5;
+extern phys_addr_t ptl4;
+extern phys_addr_t ptl3;
+extern phys_addr_t ptl2;
+
+static void setup_page_table(void)
+{
+	pgd_t *curr_pt;
+	phys_addr_t flags;
+	int i;
+
+	/* Set default flags */
+	flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+
+	/* Level 5 */
+	curr_pt = (pgd_t *)&ptl5;
+	curr_pt[0] = ((phys_addr_t)&ptl4) | flags;
+	/* Level 4 */
+	curr_pt = (pgd_t *)&ptl4;
+	curr_pt[0] = ((phys_addr_t)&ptl3) | flags;
+	/* Level 3 */
+	curr_pt = (pgd_t *)&ptl3;
+	for (i = 0; i < 4; i++) {
+		curr_pt[i] = (((phys_addr_t)&ptl2) + i * PAGE_SIZE) | flags;
+	}
+	/* Level 2 */
+	curr_pt = (pgd_t *)&ptl2;
+	flags |= PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_PAGE_SIZE_MASK | PT_GLOBAL_MASK;
+	for (i = 0; i < 4 * 512; i++)	{
+		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
+	}
+
+	/* Load 4-level page table */
+	write_cr3((ulong)&ptl4);
+}
+
+void setup_5level_page_table(void)
+{
+	/*  Check if 5-level page table is already enabled */
+	if (read_cr4() & X86_CR4_LA57) {
+		return;
+	}
+
+	/* Disable CR4.PCIDE */
+	write_cr4(read_cr4() & ~(X86_CR4_PCIDE));
+	/* Disable CR0.PG */
+	write_cr0(read_cr0() & ~(X86_CR0_PG));
+
+	/* Load new page table */
+	write_cr3((ulong)&ptl5);
+
+	/* Enable CR4.LA57 */
+	write_cr4(read_cr4() | X86_CR4_LA57);
+}
+
 static void setup_gdt_tss(void)
 {
 	gdt_entry_t *tss_lo, *tss_hi;
@@ -268,6 +324,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	phys_alloc_init(efi_bootinfo->free_mem_start,
 			efi_bootinfo->free_mem_size);
 	setup_efi_rsdp(efi_bootinfo->rsdp);
+	setup_page_table();
 }
 
 #endif /* TARGET_EFI */
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index cc993e5..315f8d3 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -21,6 +21,27 @@ ring0stacktop:
 
 .data
 
+.align PAGE_SIZE
+.globl ptl2
+ptl2:
+	. = . + 4 * PAGE_SIZE
+.align PAGE_SIZE
+
+.globl ptl3
+ptl3:
+	. = . + PAGE_SIZE
+.align PAGE_SIZE
+
+.globl ptl4
+ptl4:
+	. = . + PAGE_SIZE
+.align PAGE_SIZE
+
+.globl ptl5
+ptl5:
+	. = . + PAGE_SIZE
+.align PAGE_SIZE
+
 boot_idt:
 	.rept 256
 	.quad 0
-- 
2.33.0.rc1.237.g0d66db33f3-goog

