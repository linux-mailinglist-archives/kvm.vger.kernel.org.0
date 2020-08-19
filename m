Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1099B24A811
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 22:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHSU4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 16:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSU4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 16:56:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859AAC061757
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 13:56:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g127so27035662ybf.11
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=yZP3U83x8vAX3cajGXc7z0/Dm8SIVm4GFRQ0yFeq1A4=;
        b=iaKO6wj6RPrDOY3RYFZJse7CCdC728/2ZJKEGTHh6Ac4aGVqqx+1EuRgdn1YwQWfhh
         jkqp9VferUrXEFELcNsSaRlZnJDHxjE2zNQz3YoItWLUvXJKCxEh4Yiw6TFweSVP/Vl2
         Wr+bRoMA0CcB4/dAcSd++FKUBSLFUkjOQ8+cQqamZZ0rRniap0EwEXVIzNvDj2W3HdY4
         G6hU15Hzeo1xHZfKB86fVt5TLDQ9hTWI9OguoRk8FC2eN9CGJFBKixawP9A/9oCYvjY7
         CPZP9OKoPHFF8sf+tSRegNulo/BhcDErpNIkDD8xO8ICqT/wUBMH0ozPf6PXjVXb5Br6
         NiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=yZP3U83x8vAX3cajGXc7z0/Dm8SIVm4GFRQ0yFeq1A4=;
        b=Glb6XZverj9LdAAApxiAofCYB0OrYzRkEpgQjAtHy/+z5E5jzUH6602ywClpaaoFCZ
         dydjxQGShs8j27senX9RsKlieaDon2rWUm6zNTvdqJzpHelYUMmu245HyDEWgYEEu8d6
         0vDBObGyhLS6WLTQU4sfvwT+mBEHcrUETRLzZNPGnhkIFfMsVKEKGgHp557UIq2rVSNQ
         RBEf2kzTJteUZp3xGCVfs+r/qEBcEV3t0ukX3JQDiMGRlOHRbxYRRulJ66c0UjIHXNdM
         g5TQVEz2S4SeA1/3/BiiBHV5ifINiZYbGqeb5vrEFf2TzN+sWu69maI6B3lV8gVIOQ5A
         GeAg==
X-Gm-Message-State: AOAM530yhVmTnGAM2VwKK021SqFOjM6Cw/k/REiVpeBNGWeyAWdwxddC
        GAX+AvqMTqBCkQuWp372go8fI2p4PjEoFCjrQ4/AxZmT01Jx/y9eTZMX9PGLjI5QNvEGihfxQyr
        DeOls/yTRzm2cuKR1rB5q13hqewtnIS62NPNAQOAAOX4PfTMuDKYf/Hh4wg==
X-Google-Smtp-Source: ABdhPJw1smN9VGqmP6TL7p5/87iv2Rw4wgd8RyVx4KPOpCPohh2becu2eYVKVqwaiacI19sawRGBgMo6RvU=
X-Received: from pshier-linuxworkstation.sea.corp.google.com
 ([2620:15c:100:202:a28c:fdff:fee1:c360]) (user=pshier job=sendgmr) by
 2002:a25:cbc5:: with SMTP id b188mr398390ybg.268.1597870606758; Wed, 19 Aug
 2020 13:56:46 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:56:33 -0700
Message-Id: <20200819205633.1393378-1-pshier@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [kvm-unit-tests PATCH v2] x86: vmx: Add test for MTF on a guest
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
 x86/vmx_tests.c    | 173 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

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
index 32e3d4f47b33..22f0c7b975be 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5250,6 +5250,178 @@ static void vmx_mtf_test(void)
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
+	pte = get_pte_level(
+            (pgd_t *)phys_to_virt(guest_cr3 & ~X86_CR3_PCID_MASK), 0,
+            PDPT_LEVEL);
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
@@ -10112,6 +10284,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(atomic_switch_overflow_msrs_test),
 	TEST(rdtsc_vmexit_diff_test),
 	TEST(vmx_mtf_test),
+	TEST(vmx_mtf_pdpte_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 

