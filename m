Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A25B6F55
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfIRWYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 18:24:04 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:38417 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfIRWYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 18:24:03 -0400
Received: by mail-vs1-f73.google.com with SMTP id s123so68759vss.5
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 15:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i0CdEVR1B/ucmQiX35UhtXxkknV1POgqLp+MzZQxejA=;
        b=mzCHugoENdOdqqiez+/cE1C6rkQgKchowSINBVxuK/x1TDX9rwqp7XLdScxqkHA9AX
         oAmqyGO0XkhXXbpCooqLUxsuIotKT4/6J102ypJIQxQnukj+DiH4HP3I43rx2pR4s+kQ
         77R6XJYlqrPXyt+6U/Al2tUr2dICiGD/T0GEgUDinrYp78EOJ3U9zscWbanOG/hL7c97
         +yJNWsrOMMFjLiUfFEz2mWaUfpY2NTwLwk5gkSU/DrVg5PCKthNTYZW1I3POSIasT0yc
         WsCLjyBAdGhKeRB80fljLzWynbNEFG5ZMJ9QP3xQpasl+DtS4E0hlTywCv3AW/l4ZEDN
         5osQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i0CdEVR1B/ucmQiX35UhtXxkknV1POgqLp+MzZQxejA=;
        b=g+k408OqJ9j/8EK84dZx2yz0/bYa7KrOiDH5DUfGWKuaPW1tB+7b5rqCi43SsrCjui
         JVMdDuffTnXw5YXqrFXNT0zEwnYgxGKAk4pPaWAhxi28LoAA7Iv7EBYIdD+mJzEqF9s/
         JJloZt9IoL7M6YAXxeeVxhqUu8qrn3Sa/ZXvhNlg9YWuk8ZHmTTESPsra3yVI6S8qhXP
         wjp+W7bgVxs2HJyictmS53wnfCbT62PZMjwDBFqSg0Kti7lb5TdeAbTp8POLDFnqx3Rj
         66S1p/ccb2sqgv3HqduXRFcGv4CaiRh449Bb7PqqfzyRbYWqaMMZSTRE0Y9z/VrZQtrt
         9B2w==
X-Gm-Message-State: APjAAAXIKw8O6ZIYxhNWWB7GbK5JgHXUcZq2OAOPG9+xpa3J4jzXd8JG
        aPd4T/n+igeM/e1y5KJxm73HSN492xTcCn2MM+ce51ZXz5s/jv+1KXfAvT/nMqUI7oPVVueVksz
        tvY4uR0msXoi0r7LEz881nbQ9dDQu+pfbRlenIhTybfa+msAxI8OH0i1u55jo
X-Google-Smtp-Source: APXvYqxG0wtAhk3dJ3ZLtG4jMNpwCndtHAZt1l1VdD20Oa/tST37DDx7/Wge+VGsrk/ptdoyEAxEDZJo2/gD
X-Received: by 2002:a67:d304:: with SMTP id a4mr3822920vsj.156.1568845442496;
 Wed, 18 Sep 2019 15:24:02 -0700 (PDT)
Date:   Wed, 18 Sep 2019 15:23:54 -0700
In-Reply-To: <20190918222354.184162-1-marcorr@google.com>
Message-Id: <20190918222354.184162-2-marcorr@google.com>
Mime-Version: 1.0
References: <20190918222354.184162-1-marcorr@google.com>
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v5 2/2] x86: nvmx: test max atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
list) at the maximum number of MSRs supported, as described in the SDM,
in the appendix chapter titled "MISCELLANEOUS DATA".

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
v4 -> v5
* Replaced local pointer declarations for MSR lists with existing global
  declarations.
* Replaced atomic_switch_msr_limit_test_guest() with existing vmcall()
  funciton.
* Removed redundant assert_exit_reason(VMX_VMCALL).

 lib/alloc_page.c  |   5 ++
 lib/alloc_page.h  |   1 +
 x86/unittests.cfg |   2 +-
 x86/vmx_tests.c   | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 97d13395ff08..ed236389537e 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -53,6 +53,11 @@ void free_pages(void *mem, unsigned long size)
 	spin_unlock(&lock);
 }
 
+void free_pages_by_order(void *mem, unsigned long order)
+{
+	free_pages(mem, 1ul << (order + PAGE_SHIFT));
+}
+
 void *alloc_page()
 {
 	void *p;
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 5cdfec57a0a8..739a91def979 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -14,5 +14,6 @@ void *alloc_page(void);
 void *alloc_pages(unsigned long order);
 void free_page(void *page);
 void free_pages(void *mem, unsigned long size);
+void free_pages_by_order(void *mem, unsigned long order);
 
 #endif
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d42f3a..05122cf91ea1 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
+extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
 arch = x86_64
 groups = vmx
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24a771a..cc33ea7b5114 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8570,6 +8570,137 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
 	return VMX_TEST_VMEXIT;
 }
 
+/*
+ * The max number of MSRs in an atomic switch MSR list is:
+ * (111B + 1) * 512 = 4096
+ *
+ * Each list entry consumes:
+ * 4-byte MSR index + 4 bytes reserved + 8-byte data = 16 bytes
+ *
+ * Allocate 128 kB to cover max_msr_list_size (i.e., 64 kB) and then some.
+ */
+static const u32 msr_list_page_order = 5;
+
+static void atomic_switch_msr_limit_test_guest(void)
+{
+	vmcall();
+}
+
+static void populate_msr_list(struct vmx_msr_entry *msr_list,
+			      size_t byte_capacity, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		msr_list[i].index = MSR_IA32_TSC;
+		msr_list[i].reserved = 0;
+		msr_list[i].value = 0x1234567890abcdef;
+	}
+
+	memset(msr_list + count, 0xff,
+	       byte_capacity - count * sizeof(*msr_list));
+}
+
+static int max_msr_list_size(void)
+{
+	u32 vmx_misc = rdmsr(MSR_IA32_VMX_MISC);
+	u32 factor = ((vmx_misc & GENMASK(27, 25)) >> 25) + 1;
+
+	return factor * 512;
+}
+
+static void atomic_switch_msrs_test(int count)
+{
+	struct vmx_msr_entry *vm_enter_load;
+	struct vmx_msr_entry *vm_exit_load;
+	struct vmx_msr_entry *vm_exit_store;
+	int max_allowed = max_msr_list_size();
+	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
+	/* KVM signals VM-Abort if an exit MSR list exceeds the max size. */
+	int exit_count = MIN(count, max_allowed);
+
+	/*
+	 * Check for the IA32_TSC MSR,
+	 * available with the "TSC flag" and used to populate the MSR lists.
+	 */
+	if (!(cpuid(1).d & (1 << 4))) {
+		report_skip(__func__);
+		return;
+	}
+
+	/* Set L2 guest. */
+	test_set_guest(atomic_switch_msr_limit_test_guest);
+
+	/* Setup atomic MSR switch lists. */
+	vm_enter_load = alloc_pages(msr_list_page_order);
+	vm_exit_load = alloc_pages(msr_list_page_order);
+	vm_exit_store = alloc_pages(msr_list_page_order);
+
+	vmcs_write(ENTER_MSR_LD_ADDR, (u64)vm_enter_load);
+	vmcs_write(EXIT_MSR_LD_ADDR, (u64)vm_exit_load);
+	vmcs_write(EXIT_MSR_ST_ADDR, (u64)vm_exit_store);
+
+	/*
+	 * VM-Enter should succeed up to the max number of MSRs per list, and
+	 * should not consume junk beyond the last entry.
+	 */
+	populate_msr_list(vm_enter_load, byte_capacity, count);
+	populate_msr_list(vm_exit_load, byte_capacity, exit_count);
+	populate_msr_list(vm_exit_store, byte_capacity, exit_count);
+
+	vmcs_write(ENT_MSR_LD_CNT, count);
+	vmcs_write(EXI_MSR_LD_CNT, exit_count);
+	vmcs_write(EXI_MSR_ST_CNT, exit_count);
+
+	if (count <= max_allowed) {
+		enter_guest();
+		assert_exit_reason(VMX_VMCALL);
+		skip_exit_vmcall();
+	} else {
+		u32 exit_reason;
+		u32 exit_reason_want;
+		u32 exit_qual;
+
+		enter_guest_with_invalid_guest_state();
+
+		exit_reason = vmcs_read(EXI_REASON);
+		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
+		report("exit_reason, %u, is %u.",
+		       exit_reason == exit_reason_want, exit_reason,
+		       exit_reason_want);
+
+		exit_qual = vmcs_read(EXI_QUALIFICATION);
+		report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
+		       exit_qual, max_allowed + 1);
+
+		/*
+		 * Re-enter the guest with valid counts
+		 * and proceed past the single vmcall instruction.
+		 */
+		vmcs_write(ENT_MSR_LD_CNT, 0);
+		vmcs_write(EXI_MSR_LD_CNT, 0);
+		vmcs_write(EXI_MSR_ST_CNT, 0);
+		enter_guest();
+		skip_exit_vmcall();
+	}
+
+	/* Cleanup. */
+	enter_guest();
+	skip_exit_vmcall();
+	free_pages_by_order(vm_enter_load, msr_list_page_order);
+	free_pages_by_order(vm_exit_load, msr_list_page_order);
+	free_pages_by_order(vm_exit_store, msr_list_page_order);
+}
+
+static void atomic_switch_max_msrs_test(void)
+{
+	atomic_switch_msrs_test(max_msr_list_size());
+}
+
+static void atomic_switch_overflow_msrs_test(void)
+{
+	atomic_switch_msrs_test(max_msr_list_size() + 1);
+}
 
 #define TEST(name) { #name, .v2 = name }
 
@@ -8660,5 +8791,8 @@ struct vmx_test vmx_tests[] = {
 	TEST(ept_access_test_paddr_read_execute_ad_enabled),
 	TEST(ept_access_test_paddr_not_present_page_fault),
 	TEST(ept_access_test_force_2m_page),
+	/* Atomic MSR switch tests. */
+	TEST(atomic_switch_max_msrs_test),
+	TEST(atomic_switch_overflow_msrs_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.23.0.237.gc6a4ce50a0-goog

