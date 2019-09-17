Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B4DB56C4
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfIQUQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 16:16:09 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38954 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfIQUQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 16:16:09 -0400
Received: by mail-pf1-f201.google.com with SMTP id n186so3234722pfn.6
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WeRNsVteHySVHFS9Ve2jBQaaZRzReGq1sWPixyQp6y8=;
        b=LPVCNlhzEVT3UuUGOlVUx9YZJJnQKpu3HQRoyR+SceDQ/gmMPiqyvTMRGGLR1aHcaB
         72PS/9dFB/6kfUKErlnRFWTPrdmawlcc1ppclxLKSMcCC/SAkvdHGvm2i0D3h5J0Rpx1
         uJI+Ef+AwnUhDRfIfeDCx1JD4KMNjrCOIl1j/xVaoCrt26r4bBrmxx24En79zj9hM9yk
         kvIqkVYuuLDiX5z7TXBTVLXT22uNdIWkAsvDGrcy+yLLUxyb38raBL+377NdOA3QamKK
         qjFquZG8XytWKxB0MmYw1uJoeRsYbOkMFjKBrE9QOLIMc7yQjLA8fP8tu7GWMQ9MNW46
         QYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WeRNsVteHySVHFS9Ve2jBQaaZRzReGq1sWPixyQp6y8=;
        b=Cby45uGKQDSEB7KOdqDnnTwxItEE3xy8HetywaecT1B8i2kbXgZNwaVZn8C5L50SMm
         GwgxkS4SIcDj1zlzW4BW1qH7f+XaAddNwifM3CHmeTXYIsjRZDwqXwOrwQe4qA8Kd8ld
         WMDI66VIBnZUqeY/32biuHBVbx6fosWGtvQeM0yWE7O+ItzOVnmJ+ag6iTkzFlikLUb/
         J7Z9jCgN/E9DkzGBvmi829dUgRo9/5Rf2fpgR/zIW4D41DW1ecCz9euIAiZVEveYSU/9
         jFpJsivPZVaLlALIx1W5wYk3z9h4VDHkKOs+8DBjQnnl14qTv2zQAU795+r+eOwbc0+m
         vMzg==
X-Gm-Message-State: APjAAAUHNDx3W4C+wGB/jZjz4ScCnDHjBHp/rl2f5Kt56CKm/RufPsbN
        eI4Ogbjs7Jhm9ebKA6hUxySP7ITdbJ//rt+7zuXY5Ff2sLM+4MF3jo1e3olltFLkmeHJCPGWXvn
        aFK9rXhPRQhHMMMNQK5PF2Y5lsb9Wwf+yPwH1jut9I082NquXh7RXxT1TwKEW
X-Google-Smtp-Source: APXvYqw9aMnel0hg5O/6Rw/eZkWNREH5bz6wmKLdfKvlXVrMyw0FbfkxOwAqung/PMmNduozC1kaJn4cBv4b
X-Received: by 2002:a63:6803:: with SMTP id d3mr588998pgc.183.1568751368116;
 Tue, 17 Sep 2019 13:16:08 -0700 (PDT)
Date:   Tue, 17 Sep 2019 13:16:02 -0700
In-Reply-To: <20190917201602.113133-1-marcorr@google.com>
Message-Id: <20190917201602.113133-2-marcorr@google.com>
Mime-Version: 1.0
References: <20190917201602.113133-1-marcorr@google.com>
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v4 2/2] x86: nvmx: test max atomic switch MSRs
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
v3 -> v4
* Replace spaces w/ tabs.
* Replace comment as suggested by Sean.
* Make use of MIN().
* Refactor cleanup code so that only failure code path reenters guest an
  extra time.

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

