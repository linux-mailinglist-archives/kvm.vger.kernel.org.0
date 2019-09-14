Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0287EB292F
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 02:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390867AbfINAt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 20:49:29 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:47994 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388932AbfINAt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 20:49:29 -0400
Received: by mail-pl1-f201.google.com with SMTP id m8so11934984plt.14
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 17:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oJhIsB4KlXnuRIGDe2avywLhhe8p8rV5iQ5s3ifo640=;
        b=lD694PfqTOQEfoAneKzH8zu9d68FENGeZ8+sdZx8gSxgejqdIYxHNNuk36TBKXHQUk
         3s1j/gYDNQqqhsESbkaIoftWlGl0sX009Kb0f4eUlOg1Olu9n9XOgFkQgqquNDSaf7lN
         aW2yhvedmc9PLflAse8AzsIsvYu7VQEFarwAQMHCEVvJ8+2Lthp3dGAoxW4IXf8y3OJj
         wLxAXzlR2glxG20Tl5aod+W1eQtCFfWlfRwPf6EtAGXxVilxtJNLlD3mfLnr2PT69Kb+
         4hRQVH88yMMP1SYq/hMuzj55tw5ATvcoH+N+CXRof9KJTFhq3+lZTZfTDP1IhqaWPMxZ
         h8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oJhIsB4KlXnuRIGDe2avywLhhe8p8rV5iQ5s3ifo640=;
        b=bhQSwzeckouXdzL8D1pZgHojboVGq00rvehZ82xt1ywZNb2AmBVb12j4kXc/lWeqV8
         N2QltEqXsvqX7aE6yUlO/+xJgs0qQCyAYxBGznPrpFyzb8x+kv23MsbdYMfnvHnTjiKV
         SPB1ywsZqCIwCei6WCRO4TZGv5kFtGbKAdMJ4fjHJcU6LvHoXFuY0axQika/UIgdbgRu
         QvvmGMhclS86g8+bq1FZPadnWKa++UD0Rd3UDdRnp+TQYGEuVVaL6x3P15eI+ntPHAjA
         auLgPGGD5+ZmMxLXH/iK/d8F5t9yF2zi0PSrHriV9z02UltDxmnMOXNZ9isSVEIipWRk
         eD4A==
X-Gm-Message-State: APjAAAVy4vRLfYQ5kee9lm1byRHicN2vegHKgysR3zjUFJ/w9tA3kXxz
        R8PZGsH1kqsXfUJHu5wyQWLfZ8jH1J/B73H2kC8ZEp/FOIsSkIC1SpgJAKzSqZ7k0M3KNUaPJkv
        8JV9lEtw3dHS46ByCGd+8gwTY3mwLgC+SgQH4FhFqhbMAoMLo9dApiKYh/uPJ
X-Google-Smtp-Source: APXvYqxLjoHn+3yeyUjOSE4ozPPJUJg3KcTk8BdcvxUI7LLAuBdTC/1VMAljjsz/uZL9f8aIVcAjky9fCy3w
X-Received: by 2002:a63:3585:: with SMTP id c127mr9924375pga.93.1568422166463;
 Fri, 13 Sep 2019 17:49:26 -0700 (PDT)
Date:   Fri, 13 Sep 2019 17:49:19 -0700
Message-Id: <20190914004919.256530-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v2] x86: nvmx: test max atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
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
v1 -> v2
* Replaced 2M page allocations with 128 kB allocations.
* Broadly, updated test to follow Sean's draft:
  * Got rid of loop + individual test cases. Instead combined all test cases.
  * Got rid of configure_atomic_switch_msr_limit_test().
* Updated cleanup code to free memory. I added a new helper,
  free_pages_by_order() to help here.
* Changed virt_to_phys() to explicit u64 cast.
* Renamed original test case from atomic_switch_msr_limit_test() to
  atomic_switch_max_msrs_test(). Added opt-in
  atomic_switch_overflow_msrs_test() test case to test failure code path
  during VM-entry.
* Fixed a bug in transitioning VMX launched state when the first
  VM-entry fails.

 lib/alloc_page.c  |   5 ++
 lib/alloc_page.h  |   1 +
 x86/unittests.cfg |   2 +-
 x86/vmx.c         |   2 +-
 x86/vmx_tests.c   | 131 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+), 2 deletions(-)

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
 
diff --git a/x86/vmx.c b/x86/vmx.c
index 6079420db33a..7313c78f15c2 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1820,7 +1820,7 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 		abort();
 	}
 
-	if (!failure->early) {
+	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
 		launched = 1;
 		check_for_guest_termination();
 	}
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24a771a..fb665f38b1e5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8570,6 +8570,134 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
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
+        struct vmx_msr_entry *vm_exit_load;
+        struct vmx_msr_entry *vm_exit_store;
+	int max_allowed = max_msr_list_size();
+	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
+	/* Exceeding the max MSR list size at exit trigers KVM to abort. */
+	int exit_count = count > max_allowed ? max_allowed : count;
+	int cleanup_count = count > max_allowed ? 2 : 1;
+	int i;
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
+	}
+
+	/* Cleanup. */
+	vmcs_write(ENT_MSR_LD_CNT, 0);
+	vmcs_write(EXI_MSR_LD_CNT, 0);
+	vmcs_write(EXI_MSR_ST_CNT, 0);
+	for (i = 0; i < cleanup_count; i++) {
+		enter_guest();
+		skip_exit_vmcall();
+	}
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
 
@@ -8660,5 +8788,8 @@ struct vmx_test vmx_tests[] = {
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

