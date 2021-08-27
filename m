Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC73F92B5
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244135AbhH0DNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A4EC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d13-20020a056a0010cd00b003eb385150d1so7290pfu.10
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cEVYnZ9WXh+TM89zUGRqPhzSuIPcHo66mvZNyy63GPM=;
        b=v+30AWh9oYz8b6Jxri2eayuGHfVSk0NuoHCa1xhpZgm9UAx5uc/z66J1q5a34ZoDut
         ikmGApsoiMMwHDT67ZSZyurqUokd5830en/xY392j8VFxlWXsu3tLlqnfvrpqu4Qi1/w
         AV129cBq1gjB5+FFFzcE95nE1sth+/WmaVIomHyr1UFGaphwYHm93y5U6aG2dibtpw8z
         cDiBeLPcZGi/uJs944zwANwU354cAcTgP6IdGX/tB0ggFHg0icH0zaP3ciPET7IXuUpC
         cDNdzmbJpcaJdFB6zHoOImQGNoArsVk2CsmT0fTiWNyTkbczY+agoQY5LUZQ5uZ5yTOq
         hohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cEVYnZ9WXh+TM89zUGRqPhzSuIPcHo66mvZNyy63GPM=;
        b=YRVVJsG1CwuWubhOeuZMXrKimO75bjAKFQ5rmFeDXFS/7BYLI6yqZDi46q9BdILCez
         S3XKoBFpDGo9a3orkZHj33F67GTlTHpQ4zkOo0mllXZTYKaqYZtW2FjXU05IrcyKOsDf
         2um6OUZKW1+XNHYudcEOKOKPq4Y4s5e7rC8tyKQKy0uVll3MaHbRKTl7wlA0K8oQ5oyb
         oTzvJjMgHBbNer8tsogoRbXXNeMiQRXnrXZzS+StKSCUtX7+a/ulNvD5cZy/ucKXk1Yb
         +3Yn9txSclMCfitDx/9q2TRlu7qFu7o2e5PVyihlgqV/j+NMZyir3t7JLx27f4rcxwdc
         xkLg==
X-Gm-Message-State: AOAM532eIjxwhRag3I84d4P7liTghBbotz+pWAGm3YQhn6VuOfCkYeoH
        LrzVTkZWFmrytjbBPko+FkCq8/nCxJeEPn3ZK/n9UCRKEgdwRqgrs/OF0X9ZK4/stfATAz2aWDT
        yePdbEp4zBiOnmRUY8LOo+gGZfpz9nqTPGSAYrx3XWPxz46xaYEQoJp0h8btH81xM9Qfs
X-Google-Smtp-Source: ABdhPJxGmTH0Aw6rGbKSPai8bbX+mcmOR83a50sO0seLfL7BZG9yC6Zuj0MqzSUMD1dmIV7UPclrzY/JYaKQXfa2
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a17:902:ab98:b029:12b:acc0:e18c with
 SMTP id f24-20020a170902ab98b029012bacc0e18cmr6616698plr.10.1630033960925;
 Thu, 26 Aug 2021 20:12:40 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:14 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-10-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 09/17] x86 UEFI: Set up page tables
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
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
index 40fd963..16bad0f 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -4,7 +4,9 @@
 #ifdef TARGET_EFI
 #include "x86/acpi.h"
 #include "x86/apic.h"
+#include "x86/processor.h"
 #include "x86/smp.h"
+#include "asm/page.h"
 #include "efi.h"
 
 /*
@@ -22,6 +24,7 @@ typedef struct {
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
 void setup_efi(efi_bootinfo_t *efi_bootinfo);
 efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
+void setup_5level_page_table(void);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 1ddfb8c..03598fe 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -218,6 +218,62 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
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
 	smp_init();
 	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
 	setup_efi_rsdp(efi_bootinfo->rsdp);
+	setup_page_table();
 }
 
 #endif /* TARGET_EFI */
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index a14bd46..86c3760 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -22,6 +22,27 @@ ring0stacktop:
 
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
2.33.0.259.gc128427fd7-goog

