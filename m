Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5C84218AB
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhJDUvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbhJDUvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:38 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB703C061749
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23so1565463pji.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8VvNjXnyjaiZ/2uDMcL9dog4rM3q7X5m0sWW0vporEg=;
        b=VaOwzDsm7+mXz+09yCl2e0OFqZ05j9/mrLUhE6iVMDOrpqfqCQPcEK8EI/OQ8uMMvx
         OzI4QtXYe6dRkAKQuhXF2//nMZl8d2vhC0jd39dTypVunQ7BuMD70XvYHgC+H1YJ5xIO
         YqvObVkKqD0gMfomM67Wx+Zyn8Sgl4yoS6klnXgH9FXEj/xB+WHEWZJZ4XqmgTwm3VX5
         5+WZJdGdtXFDIhlAgC46osW7OD+pSDFMUFZFqD7sZ1XcMvLhzr3Ia0VRBS8Q9WoyeAuq
         4HEvzgiCg2q7FoHq3907NzNtBZAbKo0x7Vy9G0yFO0SoRJob2dkRDrbZpqTeJSHAiofC
         /eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8VvNjXnyjaiZ/2uDMcL9dog4rM3q7X5m0sWW0vporEg=;
        b=kuCCp0jG+7sRzlTcfJNRIakjtlbEfrEgph4znLwWxSlNJECHHk3k6VT6SAeQjb2D9B
         dD4R4+0RS0EGVq9UTUXCNvZ9/acWwsE8X40is2RJ+LhWRdy+c+YjuuxfFT6RjtjwM1/u
         svIx5mHusmThBEdERbOoDNhkFViMOyihEjtnm4ADm1fVcWwesvpSWM7yIhzgurYPCpbj
         4F2YMyd0OXFBzURZ+HmiGYmzxAafWKsaTN/lpjVtnMk61K7qvw3ifDCQf5YTs49Sg/mN
         ntlvYRkUv7U+aUiwZfBoDWUooDvxjO38YQXC3x1FoG8TMtobKZlMkRdwPCbDj3W4ceEd
         kjug==
X-Gm-Message-State: AOAM533WxA4p1HJfhqQl8df7HX9CijIsJBZSw4knb8Ea8Y4oxAoNSeJb
        kZ10R40mssMyJmbczNZRpxXe6aqLvZuyCA==
X-Google-Smtp-Source: ABdhPJxleKEyHjIO6/izRgjPdC9l0ZeVnDRBxEx/+LaiB/K/DF+jR0M1azwDtjRgivMr8Ehtd4ILbQ==
X-Received: by 2002:a17:90a:312:: with SMTP id 18mr39253932pje.178.1633380588712;
        Mon, 04 Oct 2021 13:49:48 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:48 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 10/17] x86 UEFI: Set up page tables
Date:   Mon,  4 Oct 2021 13:49:24 -0700
Message-Id: <20211004204931.1537823-11-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

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
 lib/x86/setup.c      | 55 ++++++++++++++++++++++++++++++++++++++++++++
 x86/efi/efistart64.S | 23 ++++++++++++++++++
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
index ecfcd5c..9cc135a 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -8,7 +8,9 @@ unsigned long setup_tss(void);
 #ifdef TARGET_EFI
 #include "x86/acpi.h"
 #include "x86/apic.h"
+#include "x86/processor.h"
 #include "x86/smp.h"
+#include "asm/page.h"
 #include "efi.h"
 
 /*
@@ -26,6 +28,7 @@ typedef struct {
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
 void setup_efi(efi_bootinfo_t *efi_bootinfo);
 efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
+void setup_5level_page_table(void);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 6d81ab6..c1aa82a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -254,6 +254,60 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
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
+	/*
+	 * TODO: This function is a place holder for now. It is defined because
+	 * some test cases (e.g. x86/access.c) expect it to exist. If this
+	 * function is not defined, gcc may generate wrong position-independent
+	 * code, which leads to incorrect memory access: if compiling
+	 * x86/access.efi without this function defined, several data structures
+	 * (e.g. apic_ops) get compile time offset memory addresses, but they
+	 * should get runtime %rip based addresses.
+	 *
+	 * The reason this function does not contain any code: Setting up 5
+	 * level page table requires x86 to enter the real mode. But real mode
+	 * is currently not supported in kvm-unit-tests under UEFI.
+	 */
+}
+
 static void setup_gdt_tss(void)
 {
 	size_t tss_offset;
@@ -274,6 +328,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	smp_init();
 	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
 	setup_efi_rsdp(efi_bootinfo->rsdp);
+	setup_page_table();
 }
 
 #endif /* TARGET_EFI */
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 57299a5..adfff3a 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -17,6 +17,29 @@ ring0stacksize = PAGE_SIZE
 	.align 16
 ring0stacktop:
 
+.data
+
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
 .section .init
 .code64
 .text
-- 
2.33.0

