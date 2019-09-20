Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98783B99AC
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404443AbfITW3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 18:29:53 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:42549 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404313AbfITW3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 18:29:53 -0400
Received: by mail-pg1-f202.google.com with SMTP id d3so1682198pgv.9
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Rfvw0H4sZZ/NA/WmbhGw8gTj4l0+sJQO6A3ng704cr0=;
        b=NmmnU+jjTUdwMaTp1VBl6zXFR0zzfffPUO6mDAxFwU6niaWLqDghl+x01J62yJN0c1
         DRJdHtfHp19+ix+SDUnjnf6t07zOeZvB8Vr56KXEXB2OAlKNXsnhUFfHtTyNgzuiZ2pO
         w0OpwLhyUZGatAz/6klc5Wv4Wg8VLa+ik/4NkwO7Sa31j19gWUvlobM/agSTNVIIpsm0
         ejufiD76qkBDGi3U0G8mGg1DjcUjeJyxlE9s9GwjWtWRVUxb0INJOrnmtHc8RSUFNps+
         o/Dudw5+leY949z8xnwcme+Rf3Ct/zUF2ubKsXWT+AzxLID+zIf8jlp96iPSHBaeeY1A
         PAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Rfvw0H4sZZ/NA/WmbhGw8gTj4l0+sJQO6A3ng704cr0=;
        b=FJywhJ3kXCseYT1qnMF5PCZRVX2rew+20rUZ/1Xr0j3lhGkERGM7v4vx9BYl56aTKa
         c+fsTxSbLSs9h/edcE64U+Tyjlt7cJIOO1F3yj502CSlPtyrYCGIn5M6mlvhpUH36nBV
         9jPA/K2JNSunfU91kKJVK/2t3k4EElrapBdbP0WQ1nwvvd59HhlX0Yaf6B9+f+9Davfn
         4WgdBLhZDYu7rAWCrcRP8mKT+dBRmX+II0i2Oi0FIv1vEkRRvY0xQM09/d1GUGQ4gu3Q
         pu3kCsVl66CiSa2NLgy9sKmLYHx9RhwsZH6IJ8U9dPKLTUUDegV35AkRdcmEIJlFyZjf
         zlyw==
X-Gm-Message-State: APjAAAX57fYpmAxv3XNmnB9+C7VIjLdbLs22L5Hm0QKPHngV56LDuNhu
        hmJLrp2P/gXLpVuzLSkAfQX7Kb4SGVLWJRCU4ldn75X51wuhX3f2ftSMa9Fg3dmN+mgFE2LKPf6
        8nADPOk55vBpu0xPXWzG/MzZ/oUGnPcMqhzUXEaWAoo+1ZSoby5uYBlNkM6yc
X-Google-Smtp-Source: APXvYqyrLnUApzQ5fQIVq/QQEfYKlCo5618UXOYaY3bDFEoEF3JW7juoTflRj3Da0tCyvXPlHzhitSdcDJ78
X-Received: by 2002:a63:4e44:: with SMTP id o4mr17559252pgl.103.1569018590714;
 Fri, 20 Sep 2019 15:29:50 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:29:45 -0700
In-Reply-To: <20190920222945.235480-1-marcorr@google.com>
Message-Id: <20190920222945.235480-2-marcorr@google.com>
Mime-Version: 1.0
References: <20190920222945.235480-1-marcorr@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [kvm-unit-tests PATCH v6 2/2] x86: nvmx: test max atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com,
        pbonzini@redhat.com, rkrcmar@redhat.com
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
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
v5 -> v6
* Replaced atomic_switch_msr_limit_test_guest() (which was supposed to
 vmcall() in v5!) w/ v2_null_test_guest() and updated exit handling
 logic accordingly.

 lib/alloc_page.c  |   5 ++
 lib/alloc_page.h  |   1 +
 x86/unittests.cfg |   2 +-
 x86/vmx_tests.c   | 123 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

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
index f035f24a771a..f8ee0f0f8f2b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8570,6 +8570,126 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
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
+	test_set_guest(v2_null_test_guest);
+
+	/* Setup atomic MSR switch lists. */
+	entry_msr_load = alloc_pages(msr_list_page_order);
+	exit_msr_load = alloc_pages(msr_list_page_order);
+	exit_msr_store = alloc_pages(msr_list_page_order);
+
+	vmcs_write(ENTER_MSR_LD_ADDR, (u64)entry_msr_load);
+	vmcs_write(EXIT_MSR_LD_ADDR, (u64)exit_msr_load);
+	vmcs_write(EXIT_MSR_ST_ADDR, (u64)exit_msr_store);
+
+	/*
+	 * VM-Enter should succeed up to the max number of MSRs per list, and
+	 * should not consume junk beyond the last entry.
+	 */
+	populate_msr_list(entry_msr_load, byte_capacity, count);
+	populate_msr_list(exit_msr_load, byte_capacity, exit_count);
+	populate_msr_list(exit_msr_store, byte_capacity, exit_count);
+
+	vmcs_write(ENT_MSR_LD_CNT, count);
+	vmcs_write(EXI_MSR_LD_CNT, exit_count);
+	vmcs_write(EXI_MSR_ST_CNT, exit_count);
+
+	if (count <= max_allowed) {
+		/*
+		 * enter_guest() verifies that VM-enter succeeds. After the
+		 * test completes, the test harness (see test_run() in vmx.c)
+		 * verifies that the VM-enter completes by reaching the end of
+		 * v2_null_test_guest().
+		 */
+		enter_guest();
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
+		/* Enter the guest (with valid counts) to set guest_finished. */
+		vmcs_write(ENT_MSR_LD_CNT, 0);
+		vmcs_write(EXI_MSR_LD_CNT, 0);
+		vmcs_write(EXI_MSR_ST_CNT, 0);
+		enter_guest();
+	}
+
+	free_pages_by_order(entry_msr_load, msr_list_page_order);
+	free_pages_by_order(exit_msr_load, msr_list_page_order);
+	free_pages_by_order(exit_msr_store, msr_list_page_order);
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
 
@@ -8660,5 +8780,8 @@ struct vmx_test vmx_tests[] = {
 	TEST(ept_access_test_paddr_read_execute_ad_enabled),
 	TEST(ept_access_test_paddr_not_present_page_fault),
 	TEST(ept_access_test_force_2m_page),
+	/* Atomic MSR switch tests. */
+	TEST(atomic_switch_max_msrs_test),
+	TEST(atomic_switch_overflow_msrs_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.23.0.351.gc4317032e6-goog

