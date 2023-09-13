Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AE79F881
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbjINCzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjINCzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 22:55:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809F310CC
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 19:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694660103; x=1726196103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m0wFrt0t+meothblTIbTCO5sXONVIbsraMmA+U5L/Tg=;
  b=d8GtzGIskEfqGgu1IPI4AIHWdVAHxUcNt3mnp2mDQ1A/uNrqGyT5eG7w
   ESInhyGDpfEQZQsxbDvBoYZVvEvglsTmA7+icyqY5uzRk738J4Q+66MyW
   mBRaI7qbvtIHCjEoEviexjvF81sGAPvjx/rZ6nfvaVYsgfGIgpnBYS2AH
   Jj8x6/A7/lw3a0TxYaE1FaXMpPVYwmvI48C7S05X3/1dpHlh+l96KtfCZ
   T6t8OWlOQf1wKdXmBwleacTwhIH3sWimZ7VxGsRdldbvVta3TbTXoIErr
   scQdyKkaHxHHXx3G9QByEw5qxBJyzir8tsXNxdYCpSy+L0fV3DHDan6bF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="442869336"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="442869336"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="694070841"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="694070841"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 2/3] x86: VMX: Rename union vmx_basic and related global variable
Date:   Wed, 13 Sep 2023 19:50:05 -0400
Message-Id: <20230913235006.74172-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230913235006.74172-1-weijiang.yang@intel.com>
References: <20230913235006.74172-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_basic is somewhat confusing with exit_reason.basic, rename the former
definition to vmx_basic_msr and the global variable to make them self-
descriptive.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx.c       | 44 ++++++++++++++++++++++----------------------
 x86/vmx.h       |  4 ++--
 x86/vmx_tests.c | 10 +++++-----
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 1c27850f..9f08c096 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -66,7 +66,7 @@ static int matched;
 static int guest_finished;
 static int in_guest;
 
-union vmx_basic basic;
+union vmx_basic_msr basic_msr;
 union vmx_ctrl_msr ctrl_pin_rev;
 union vmx_ctrl_msr ctrl_cpu_rev[2];
 union vmx_ctrl_msr ctrl_exit_rev;
@@ -369,7 +369,7 @@ static void test_vmwrite_vmread(void)
 	struct vmcs *vmcs = alloc_page();
 	u32 vmcs_enum_max, max_index = 0;
 
-	vmcs->hdr.revision_id = basic.revision;
+	vmcs->hdr.revision_id = basic_msr.revision;
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
 
@@ -430,7 +430,7 @@ static void test_vmread_vmwrite_pf(bool vmread)
 	void *vpage = alloc_vpage();
 
 	memset(vmcs, 0, PAGE_SIZE);
-	vmcs->hdr.revision_id = basic.revision;
+	vmcs->hdr.revision_id = basic_msr.revision;
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
 
@@ -456,7 +456,7 @@ static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
 
-	vmcs->hdr.revision_id = basic.revision;
+	vmcs->hdr.revision_id = basic_msr.revision;
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
 
@@ -482,7 +482,7 @@ static void test_vmcs_lifecycle(void)
 
 	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
 		vmcs[i] = alloc_page();
-		vmcs[i]->hdr.revision_id = basic.revision;
+		vmcs[i]->hdr.revision_id = basic_msr.revision;
 	}
 
 #define VMPTRLD(_i) do { \
@@ -731,13 +731,13 @@ static void test_vmclear_flushing(void)
 		vmcs[i] = alloc_page();
 	}
 
-	vmcs[0]->hdr.revision_id = basic.revision;
+	vmcs[0]->hdr.revision_id = basic_msr.revision;
 	assert(!vmcs_clear(vmcs[0]));
 	assert(!make_vmcs_current(vmcs[0]));
 	set_all_vmcs_fields(0x86);
 
 	assert(!vmcs_clear(vmcs[0]));
-	memcpy(vmcs[1], vmcs[0], basic.size);
+	memcpy(vmcs[1], vmcs[0], basic_msr.size);
 	assert(!make_vmcs_current(vmcs[1]));
 	report(check_all_vmcs_fields(0x86),
 	       "test vmclear flush (current VMCS)");
@@ -745,7 +745,7 @@ static void test_vmclear_flushing(void)
 	set_all_vmcs_fields(0x87);
 	assert(!make_vmcs_current(vmcs[0]));
 	assert(!vmcs_clear(vmcs[1]));
-	memcpy(vmcs[2], vmcs[1], basic.size);
+	memcpy(vmcs[2], vmcs[1], basic_msr.size);
 	assert(!make_vmcs_current(vmcs[2]));
 	report(check_all_vmcs_fields(0x87),
 	       "test vmclear flush (!current VMCS)");
@@ -1232,7 +1232,7 @@ static void init_vmcs_guest(void)
 int init_vmcs(struct vmcs **vmcs)
 {
 	*vmcs = alloc_page();
-	(*vmcs)->hdr.revision_id = basic.revision;
+	(*vmcs)->hdr.revision_id = basic_msr.revision;
 	/* vmclear first to init vmcs */
 	if (vmcs_clear(*vmcs)) {
 		printf("%s : vmcs_clear error\n", __func__);
@@ -1279,14 +1279,14 @@ void enable_vmx(void)
 
 static void init_vmx_caps(void)
 {
-	basic.val = rdmsr(MSR_IA32_VMX_BASIC);
-	ctrl_pin_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_PIN
+	basic_msr.val = rdmsr(MSR_IA32_VMX_BASIC);
+	ctrl_pin_rev.val = rdmsr(basic_msr.ctrl ? MSR_IA32_VMX_TRUE_PIN
 			: MSR_IA32_VMX_PINBASED_CTLS);
-	ctrl_exit_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_EXIT
+	ctrl_exit_rev.val = rdmsr(basic_msr.ctrl ? MSR_IA32_VMX_TRUE_EXIT
 			: MSR_IA32_VMX_EXIT_CTLS);
-	ctrl_enter_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_ENTRY
+	ctrl_enter_rev.val = rdmsr(basic_msr.ctrl ? MSR_IA32_VMX_TRUE_ENTRY
 			: MSR_IA32_VMX_ENTRY_CTLS);
-	ctrl_cpu_rev[0].val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_PROC
+	ctrl_cpu_rev[0].val = rdmsr(basic_msr.ctrl ? MSR_IA32_VMX_TRUE_PROC
 			: MSR_IA32_VMX_PROCBASED_CTLS);
 	if ((ctrl_cpu_rev[0].clr & CPU_SECONDARY) != 0)
 		ctrl_cpu_rev[1].val = rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2);
@@ -1311,7 +1311,7 @@ void init_vmx(u64 *vmxon_region)
 	write_cr0((read_cr0() & fix_cr0_clr) | fix_cr0_set);
 	write_cr4((read_cr4() & fix_cr4_clr) | fix_cr4_set | X86_CR4_VMXE);
 
-	*vmxon_region = basic.revision;
+	*vmxon_region = basic_msr.revision;
 }
 
 static void alloc_bsp_vmx_pages(void)
@@ -1515,7 +1515,7 @@ static int test_vmxon(void)
 	/* and finally a valid region, with valid-but-tweaked cr0/cr4 */
 	write_cr0(orig_cr0 ^ flexible_cr0);
 	write_cr4(orig_cr4 ^ flexible_cr4);
-	*bsp_vmxon_region = basic.revision;
+	*bsp_vmxon_region = basic_msr.revision;
 	ret = vmxon_safe();
 	report(!ret, "test vmxon with valid vmxon region");
 	write_cr0(orig_cr0);
@@ -1529,7 +1529,7 @@ static void test_vmptrld(void)
 	int width = cpuid_maxphyaddr();
 
 	vmcs = alloc_page();
-	vmcs->hdr.revision_id = basic.revision;
+	vmcs->hdr.revision_id = basic_msr.revision;
 
 	/* Unaligned page access */
 	tmp_root = (struct vmcs *)((intptr_t)vmcs + 1);
@@ -1592,10 +1592,10 @@ static void test_vmx_caps(void)
 
 	printf("\nTest suite: VMX capability reporting\n");
 
-	report((basic.revision & (1ul << 31)) == 0 &&
-	       basic.size > 0 && basic.size <= 4096 &&
-	       (basic.type == 0 || basic.type == 6) &&
-	       basic.reserved1 == 0 && basic.reserved2 == 0,
+	report((basic_msr.revision & (1ul << 31)) == 0 &&
+	       basic_msr.size > 0 && basic_msr.size <= 4096 &&
+	       (basic_msr.type == 0 || basic_msr.type == 6) &&
+	       basic_msr.reserved1 == 0 && basic_msr.reserved2 == 0,
 	       "MSR_IA32_VMX_BASIC");
 
 	val = rdmsr(MSR_IA32_VMX_MISC);
@@ -1609,7 +1609,7 @@ static void test_vmx_caps(void)
 		default1 = vmx_ctl_msr[n].default1;
 		ok = (ctrl.set & default1) == default1;
 		ok = ok && (ctrl.set & ~ctrl.clr) == 0;
-		if (ok && basic.ctrl) {
+		if (ok && basic_msr.ctrl) {
 			true_ctrl.val = rdmsr(vmx_ctl_msr[n].true_index);
 			ok = ctrl.clr == true_ctrl.clr;
 			ok = ok && ctrl.set == (true_ctrl.set | default1);
diff --git a/x86/vmx.h b/x86/vmx.h
index 604c78f6..d280f104 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -156,7 +156,7 @@ struct vmx_test {
 	void (*v2)(void);
 };
 
-union vmx_basic {
+union vmx_basic_msr {
 	u64 val;
 	struct {
 		u32 revision;
@@ -778,7 +778,7 @@ enum vm_entry_failure_code {
 
 extern struct regs regs;
 
-extern union vmx_basic basic;
+extern union vmx_basic_msr basic_msr;
 extern union vmx_ctrl_msr ctrl_pin_rev;
 extern union vmx_ctrl_msr ctrl_cpu_rev[2];
 extern union vmx_ctrl_msr ctrl_exit_rev;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7952ccb9..f598496e 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3427,7 +3427,7 @@ static void test_pin_based_ctls(void)
 {
 	unsigned bit;
 
-	printf("%s: %lx\n", basic.ctrl ? "MSR_IA32_VMX_TRUE_PIN" :
+	printf("%s: %lx\n", basic_msr.ctrl ? "MSR_IA32_VMX_TRUE_PIN" :
 	       "MSR_IA32_VMX_PINBASED_CTLS", ctrl_pin_rev.val);
 	for (bit = 0; bit < 32; bit++)
 		test_rsvd_ctl_bit("pin-based controls",
@@ -3444,7 +3444,7 @@ static void test_primary_processor_based_ctls(void)
 {
 	unsigned bit;
 
-	printf("\n%s: %lx\n", basic.ctrl ? "MSR_IA32_VMX_TRUE_PROC" :
+	printf("\n%s: %lx\n", basic_msr.ctrl ? "MSR_IA32_VMX_TRUE_PROC" :
 	       "MSR_IA32_VMX_PROCBASED_CTLS", ctrl_cpu_rev[0].val);
 	for (bit = 0; bit < 32; bit++)
 		test_rsvd_ctl_bit("primary processor-based controls",
@@ -5287,7 +5287,7 @@ static void test_entry_msr_load(void)
 		report_prefix_pop();
 	}
 
-	if (basic.val & (1ul << 48))
+	if (basic_msr.val & (1ul << 48))
 		addr_len = 32;
 
 	test_vmcs_addr_values("VM-entry-MSR-load address",
@@ -5415,7 +5415,7 @@ static void test_exit_msr_store(void)
 		report_prefix_pop();
 	}
 
-	if (basic.val & (1ul << 48))
+	if (basic_msr.val & (1ul << 48))
 		addr_len = 32;
 
 	test_vmcs_addr_values("VM-exit-MSR-store address",
@@ -10173,7 +10173,7 @@ static void vmx_vmcs_shadow_test(void)
 	vmcs_write(VMWRITE_BITMAP, virt_to_phys(bitmap[ACCESS_VMWRITE]));
 
 	shadow = alloc_page();
-	shadow->hdr.revision_id = basic.revision;
+	shadow->hdr.revision_id = basic_msr.revision;
 	shadow->hdr.shadow_vmcs = 1;
 	TEST_ASSERT(!vmcs_clear(shadow));
 
-- 
2.27.0

