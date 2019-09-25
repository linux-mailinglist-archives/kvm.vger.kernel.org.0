Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAA2BD60B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 03:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391871AbfIYBSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 21:18:30 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:53653 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390869AbfIYBS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 21:18:29 -0400
Received: by mail-vk1-f202.google.com with SMTP id q5so419564vkg.20
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 18:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=neAs2RXmfcVfa6nr42Du+ZHWXWZlL485FADmRb2v6vI=;
        b=fBI+N4TreUizYt2oXRmfMoz4Kk1LnWoCi5g2qvnUCqR1VCEuF1OqCsUnBPjKh9FR5M
         vSg2iJbKiqLkRiNYxrVzDlpcLiW0cAeDcLhi4bLhlaV/kUHy1qGLbpNkrUH79EDU1P91
         dDDBKWnjmwO8X+/GCsvrNe50UtMplYpLQODiTRXEx+gQ4guX7xE8KQZW7BOI0rGbM+qn
         QTzo51Cup+03Uo4Pxe62gZMOu6qWWusr7ARdyV1n9GXh9IbskWLwBp+PFGsfqKC3mbzW
         S6Lwh+TfvY4Ukm0lsPzRnOIXx726pqWimeQ7QtjXk2IF/NEaEBvB9o529KajsX6WcN9M
         nrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=neAs2RXmfcVfa6nr42Du+ZHWXWZlL485FADmRb2v6vI=;
        b=Vk3UxE/DHhKok8SQvBgBFJxugbqtlAmldjkgj8oNndhFUtkJo3T1uKoVA7gqoi1x5w
         Sj31Qa0ZOCOY66ccHJ14vkIPoIokqxJxzaBX/3b29C8Nr/4x6VQ7NjPOuqVn6xIFJwpe
         WaixNwbCkGFIrUXbqsSaQjPJadcW4G/C5EVXdWhhmV89WrAtdXzMpE1Sj3AAYOvRb1Wk
         awVPEOUyPkH+TBm9wjNRB3oGCJ00sm/1ZiaRe2NUif0nfriW/ZrGbnn63d0JztGAdJwa
         V9UQzER/czfxgeuXzeui+Sm54NeZpBv7itWYkl8LnxO6QG9/1NRiAvVnNlx+eX0OYi4h
         NpnA==
X-Gm-Message-State: APjAAAW2kYjDB0nsVcB59LrA3Qs102CjeE3ccHd7bBSYBSdp2BY5SpRn
        T42z5e/Ny3O2OS3O5KHw87n7gwrWszIU9EZxwPgW0YZv2tM3Whi12eOsSUbhbFG81SoQAiT9pzG
        ut8Ou5fkZSLM16+4xZD/act/1RVHdnQ/YKQa8gw1FVQKT8OOgJGigjJ8cR/Qx
X-Google-Smtp-Source: APXvYqzNUeJSq6aOnPd1cHt1kECs57fPbi2XdD/YX34Q+w+L1WtFXCo1AbAPuc6oMJ37NXciVHQSu37WHNrO
X-Received: by 2002:ab0:e10:: with SMTP id g16mr3206296uak.42.1569374308084;
 Tue, 24 Sep 2019 18:18:28 -0700 (PDT)
Date:   Tue, 24 Sep 2019 18:18:21 -0700
In-Reply-To: <20190925011821.24523-1-marcorr@google.com>
Message-Id: <20190925011821.24523-2-marcorr@google.com>
Mime-Version: 1.0
References: <20190925011821.24523-1-marcorr@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com,
        pbonzini@redhat.com, rkrcmar@redhat.com, dinechin@redhat.com
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excercise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
list) at the maximum number of MSRs supported, as described in the SDM,
in the appendix chapter titled "MISCELLANEOUS DATA".

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
 lib/alloc_page.c  |   5 ++
 lib/alloc_page.h  |   1 +
 x86/unittests.cfg |   2 +-
 x86/vmx_tests.c   | 124 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 131 insertions(+), 1 deletion(-)

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
index f035f24a771a..6eb18d8fd3e4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8570,6 +8570,127 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
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
+		report("exit_reason %u, expected %u.",
+		       exit_reason == exit_reason_want, exit_reason,
+		       exit_reason_want);
+
+		exit_qual = vmcs_read(EXI_QUALIFICATION);
+		report("exit_qual %u, expected %u.",
+		       exit_qual == max_allowed + 1, exit_qual,
+		       max_allowed + 1);
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
 
@@ -8660,5 +8781,8 @@ struct vmx_test vmx_tests[] = {
 	TEST(ept_access_test_paddr_read_execute_ad_enabled),
 	TEST(ept_access_test_paddr_not_present_page_fault),
 	TEST(ept_access_test_force_2m_page),
+	/* Atomic MSR switch tests. */
+	TEST(atomic_switch_max_msrs_test),
+	TEST(atomic_switch_overflow_msrs_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.23.0.444.g18eeb5a265-goog

