Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF796247B7D
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 02:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHRA0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 20:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgHRA0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 20:26:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC12C061389
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 17:26:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gf16so11316031pjb.7
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 17:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8e+ox54HeK88rWVSIgwtx//BruEjCGyJapM29hBKsLs=;
        b=Kh+APvoW+7VppqIfU0DKewAtfFxv/pb4x3K8GZBVNs3LprUDdDaDUhSrfaOdIjYLQv
         DMJfUL71DMo1EiUbmHR9VAWo6NYtD94AtenYyp4j34gHOo/jv8QlOrVc7jCfkcfOyG+C
         6lor/JoAOHm0G4Lw6pfzR58wadYJmcEvSgG0YbyOsuVMvTN3U6gRRICQKs+dNgInGwjC
         VgtPAzq2sW40wXNTkG3emGLTMVhBfI/sis1GJ8HCIhV3OPv8YvHLxyj+pbU3v27Kr+QN
         wL9Kimxd9W4Dgqm+coiP8YQMByZOLQly3rjkLHVp7hKlQBGmcXJ0KXlaFReRt6ZpNFGJ
         zevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8e+ox54HeK88rWVSIgwtx//BruEjCGyJapM29hBKsLs=;
        b=JCB9/wZCQ/o/fkeLFiFsl27A17jiRWAAtrHx0onH+TJO7kEMwRzACaqrekePMjSdHe
         MMCesvW4nBo9iCta+ZUpRRsyzWBzCYBqpGiKEvL/JLPKgJhywbqcZCGf3oTtJm9ZyWEt
         SmHm01fINC+ip/LsYpF3tEy/xN3sbio2/DZvgUoNZb3xjjoLgLF3HRJ2AfTX0WPloSkb
         ZcAFFVHfqhV3Z8zmQmiIjNFNraNrNQyvniiyEcMC1LZ9Vz4U0/EEBW+tpzvhLLmNA4bf
         oOYlELaL3qTlxY0fn2c/vXo2SdIb1Gxh8izgSISjksaIERxYYsF3BTu2PjAnMmf1tI60
         watg==
X-Gm-Message-State: AOAM5338KM+njCVxa4cdfX+dBjtzyUXM5Rgat7yEA5kHEBMubJTPefyP
        REF5Dr2EKf5iuqmXdJKdbZSCVKv5eQCoTfL2TpdFaNFVbOaiPYj07JMRKIh7Eh+ehNnrfN4208f
        U8RQ8K0EhvSRLmEbDKgdqskwGk3T+fHtBTgHQ9YuglWmLqs0PBbINITPHlQ==
X-Google-Smtp-Source: ABdhPJwqh6wVv3hpbQdwkFV2FcUx5H3CMt90SRBihCQuFvk5n/4I9GB8rDMIMxJ7TB+z9a7ekRGflmBGUdk=
X-Received: by 2002:a63:6a47:: with SMTP id f68mr11669331pgc.358.1597710360297;
 Mon, 17 Aug 2020 17:26:00 -0700 (PDT)
Date:   Mon, 17 Aug 2020 17:25:37 -0700
Message-Id: <20200818002537.207910-1-pshier@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [kvm-unit-tests PATCH] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
From:   Peter Shier <pshier@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that when L2 guest enables PAE paging and L0 intercept of L2
MOV to CR0 reflects MTF exit to L1, subsequent resume to L2 correctly
preserves PDPTE array specified by L2 CR3.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by:   Peter Shier <pshier@google.com>
Signed-off-by: Peter Shier <pshier@google.com>
---
 lib/x86/asm/page.h |   8 +++
 x86/vmx_tests.c    | 171 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 7e2a3dd4b90a..1359eb74cde4 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -36,10 +36,18 @@ typedef unsigned long pgd_t;
 #define PT64_NX_MASK		(1ull << 63)
 #define PT_ADDR_MASK		GENMASK_ULL(51, 12)
 
+#define PDPTE64_PAGE_SIZE_MASK	  (1ull << 7)
+#define PDPTE64_RSVD_MASK	  GENMASK_ULL(51, cpuid_maxphyaddr())
+
 #define PT_AD_MASK              (PT_ACCESSED_MASK | PT_DIRTY_MASK)
 
+#define PAE_PDPTE_RSVD_MASK     (GENMASK_ULL(63, cpuid_maxphyaddr()) |	\
+				 GENMASK_ULL(8, 5) | GENMASK_ULL(2, 1))
+
+
 #ifdef __x86_64__
 #define	PAGE_LEVEL	4
+#define	PDPT_LEVEL	3
 #define	PGDIR_WIDTH	9
 #define	PGDIR_MASK	511
 #else
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 32e3d4f47b33..372e5efb6b5f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5250,6 +5250,176 @@ static void vmx_mtf_test(void)
 	enter_guest();
 }
 
+extern char vmx_mtf_pdpte_guest_begin;
+extern char vmx_mtf_pdpte_guest_end;
+
+asm("vmx_mtf_pdpte_guest_begin:\n\t"
+    "mov %cr0, %rax\n\t"    /* save CR0 with PG=1                 */
+    "vmcall\n\t"            /* on return from this CR0.PG=0       */
+    "mov %rax, %cr0\n\t"    /* restore CR0.PG=1 to enter PAE mode */
+    "vmcall\n\t"
+    "retq\n\t"
+    "vmx_mtf_pdpte_guest_end:");
+
+static void vmx_mtf_pdpte_test(void)
+{
+	void *test_mtf_pdpte_guest;
+	pteval_t *pdpt;
+	u32 guest_ar_cs;
+	u64 guest_efer;
+	pteval_t *pte;
+	u64 guest_cr0;
+	u64 guest_cr3;
+	u64 guest_cr4;
+	u64 ent_ctls;
+	int i;
+
+	if (setup_ept(false))
+		return;
+
+	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
+		printf("CPU does not support 'monitor trap flag.'\n");
+		return;
+	}
+
+	if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
+		printf("CPU does not support 'unrestricted guest.'\n");
+		return;
+	}
+
+	vmcs_write(EXC_BITMAP, ~0);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
+
+	/*
+	 * Copy the guest code to an identity-mapped page.
+	 */
+	test_mtf_pdpte_guest = alloc_page();
+	memcpy(test_mtf_pdpte_guest, &vmx_mtf_pdpte_guest_begin,
+	       &vmx_mtf_pdpte_guest_end - &vmx_mtf_pdpte_guest_begin);
+
+	test_set_guest(test_mtf_pdpte_guest);
+
+	enter_guest();
+	skip_exit_vmcall();
+
+	/*
+	 * Put the guest in non-paged 32-bit protected mode, ready to enter
+	 * PAE mode when CR0.PG is set. CR4.PAE will already have been set
+	 * when the guest started out in long mode.
+	 */
+	ent_ctls = vmcs_read(ENT_CONTROLS);
+	vmcs_write(ENT_CONTROLS, ent_ctls & ~ENT_GUEST_64);
+
+	guest_efer = vmcs_read(GUEST_EFER);
+	vmcs_write(GUEST_EFER, guest_efer & ~(EFER_LMA | EFER_LME));
+
+	/*
+	 * Set CS access rights bits for 32-bit protected mode:
+	 * 3:0    B execute/read/accessed
+	 * 4      1 code or data
+	 * 6:5    0 descriptor privilege level
+	 * 7      1 present
+	 * 11:8   0 reserved
+	 * 12     0 available for use by system software
+	 * 13     0 64 bit mode not active
+	 * 14     1 default operation size 32-bit segment
+	 * 15     1 page granularity: segment limit in 4K units
+	 * 16     0 segment usable
+	 * 31:17  0 reserved
+	 */
+	guest_ar_cs = vmcs_read(GUEST_AR_CS);
+	vmcs_write(GUEST_AR_CS, 0xc09b);
+
+	guest_cr0 = vmcs_read(GUEST_CR0);
+	vmcs_write(GUEST_CR0, guest_cr0 & ~X86_CR0_PG);
+
+	guest_cr4 = vmcs_read(GUEST_CR4);
+	vmcs_write(GUEST_CR4, guest_cr4 & ~X86_CR4_PCIDE);
+
+	guest_cr3 = vmcs_read(GUEST_CR3);
+
+	/*
+	 * Turn the 4-level page table into a PAE page table by following the 0th
+	 * PML4 entry to a PDPT page, and grab the first four PDPTEs from that
+	 * page.
+	 *
+	 * Why does this work?
+	 *
+	 * PAE uses 32-bit addressing which implies:
+	 * Bits 11:0   page offset
+	 * Bits 20:12  entry into 512-entry page table
+	 * Bits 29:21  entry into a 512-entry directory table
+	 * Bits 31:30  entry into the page directory pointer table.
+	 * Bits 63:32  zero
+	 *
+	 * As only 2 bits are needed to select the PDPTEs for the entire
+	 * 32-bit address space, take the first 4 PDPTEs in the level 3 page
+	 * directory pointer table. It doesn't matter which of these PDPTEs
+	 * are present because they must cover the guest code given that it
+	 * has already run successfully.
+	 *
+	 * Get a pointer to PTE for GVA=0 in the page directory pointer table
+	 */
+	pte = get_pte_level((pgd_t *)(guest_cr3 & ~X86_CR3_PCID_MASK), 0, PDPT_LEVEL);
+
+	/*
+	 * Need some memory for the 4-entry PAE page directory pointer
+	 * table. Use the end of the identity-mapped page where the guest code
+	 * is stored. There is definitely space as the guest code is only a
+	 * few bytes.
+	 */
+	pdpt = test_mtf_pdpte_guest + PAGE_SIZE - 4 * sizeof(pteval_t);
+
+	/*
+	 * Copy the first four PDPTEs into the PAE page table with reserved
+	 * bits cleared. Note that permission bits from the PML4E and PDPTE
+	 * are not propagated.
+	 */
+	for (i = 0; i < 4; i++) {
+		TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_RSVD_MASK),
+				   "PDPTE has invalid reserved bits");
+		TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_PAGE_SIZE_MASK),
+				   "Cannot use 1GB super pages for PAE");
+		pdpt[i] = pte[i] & ~(PAE_PDPTE_RSVD_MASK);
+	}
+	vmcs_write(GUEST_CR3, virt_to_phys(pdpt));
+
+	enable_mtf();
+	enter_guest();
+	assert_exit_reason(VMX_MTF);
+	disable_mtf();
+
+	/*
+	 * The four PDPTEs should have been loaded into the VMCS when
+	 * the guest set CR0.PG to enter PAE mode.
+	 */
+	for (i = 0; i < 4; i++) {
+		u64 pdpte = vmcs_read(GUEST_PDPTE + 2 * i);
+
+		report(pdpte == pdpt[i], "PDPTE%d is 0x%lx (expected 0x%lx)",
+		       i, pdpte, pdpt[i]);
+	}
+
+	/*
+	 * Now, try to enter the guest in PAE mode. If the PDPTEs in the
+	 * vmcs are wrong, this will fail.
+	 */
+	enter_guest();
+	skip_exit_vmcall();
+
+	/*
+	 * Return guest to 64-bit mode and wrap up.
+	 */
+	vmcs_write(ENT_CONTROLS, ent_ctls);
+	vmcs_write(GUEST_EFER, guest_efer);
+	vmcs_write(GUEST_AR_CS, guest_ar_cs);
+	vmcs_write(GUEST_CR0, guest_cr0);
+	vmcs_write(GUEST_CR4, guest_cr4);
+	vmcs_write(GUEST_CR3, guest_cr3);
+
+	enter_guest();
+}
+
 /*
  * Tests for VM-execution control fields
  */
@@ -10112,5 +10282,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(atomic_switch_overflow_msrs_test),
 	TEST(rdtsc_vmexit_diff_test),
 	TEST(vmx_mtf_test),
+	TEST(vmx_mtf_pdpte_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.28.0.220.ged08abb693-goog

