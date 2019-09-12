Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09DEB1447
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 20:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfILSJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 14:09:34 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52100 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfILSJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:33 -0400
Received: by mail-pf1-f201.google.com with SMTP id s137so4115914pfs.18
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 11:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rNlLuoXt847xgTY50/lD1HH4VbuMAi2bpwf2u9Y9kp4=;
        b=OAm4MKRjiy+QjqIJoQMW4ioVuY8A3qr8+5OZ8r++JZ1QaKXBRQNpL4JRD4Fz/fREXS
         hzSnH9edUGnOVQPCPHhaM06l70l/FXKlEQLEXPsBngQc+q+iXcdAWJUwSww2dQmtqAg7
         U0zxvfgTH5buPMEX6RfEUJg+sJDzlR2ygk6EXvmZ8iRmyAlcbcUo6FZJe/Ta+8uep4CQ
         WMDsKkvWF6D0l64WtrjzevAYmuF+ssy0fNpUJ5lJNlB+FJpOAkcWAdVN2XAOdK/+zKrv
         eWHUwymaesmcOkTQYerdP+USIlTEt/P+XG9EQwcePkgK8Z68m+WCkIekhKlVoTiEO1yV
         oBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rNlLuoXt847xgTY50/lD1HH4VbuMAi2bpwf2u9Y9kp4=;
        b=ixfbKjBr9H34Y7JXdfKTaWqWv05jzceD6d4a0CAtzhNzJL9Ahq1nc5VkyHUS/RrgcN
         LiAWv/3JdtBFlXyG3qECs0TpPmoZMK8UIPGK/17zjbYWr4tRTvEmuJ8fDseGaAXJfijj
         czsJMYTjJMyIzHs4c8N2SQMKB9zIyB23UJnjHolLUJh6ZlHjeEtMd89isUZLPwYCeLQ4
         Jg3Yt7N2xxw7+q0MxPgisylSv7MSIajVa8EHh1MasjyC+LXylsLvVKZG7Nf1b6wEKahC
         ThHqePdgT9dDm0asv2QTOXd1212Jv8A61ku2S+W2GsHGm2xbNc2oOcsJXshERaDuuLMY
         oHjw==
X-Gm-Message-State: APjAAAXuwzQCHnyAj5eyGq+kxsxcYGXwz/Ij/zkAG1mlL4qHWjQj0dA0
        BHyuwTBdZNICb2+caZulaqQJKEgfMb9aPhZn20HjWDsrA/gz0rLfmXOg3UHVseM6VDbQvDzRRTG
        hCJ7GadX5sMXRmjhWgDZS9k8s56G+FabDhILrPxsFoGgSrN/tqNpL83Gth/Tm
X-Google-Smtp-Source: APXvYqzvdawDQzUEnhgq2cknt6tQkqep9UAh99cabGlZ+VFfoOPOM/M3fY24RuaFI4vYifL1pMPQox8in0Ww
X-Received: by 2002:a63:546:: with SMTP id 67mr2894546pgf.429.1568311772187;
 Thu, 12 Sep 2019 11:09:32 -0700 (PDT)
Date:   Thu, 12 Sep 2019 11:09:28 -0700
Message-Id: <20190912180928.123660-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
 x86/vmx_tests.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24a771a..b3b4d5f7cc8f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2718,6 +2718,11 @@ static void ept_reserved_bit(int bit)
 #define PAGE_2M_ORDER 9
 #define PAGE_1G_ORDER 18
 
+static void *alloc_2m_page(void)
+{
+	return alloc_pages(PAGE_2M_ORDER);
+}
+
 static void *get_1g_page(void)
 {
 	static void *alloc;
@@ -8570,6 +8575,138 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
 	return VMX_TEST_VMEXIT;
 }
 
+enum atomic_switch_msr_scenario {
+	VM_ENTER_LOAD,
+	VM_EXIT_LOAD,
+	VM_EXIT_STORE,
+	ATOMIC_SWITCH_MSR_SCENARIO_END,
+};
+
+static void atomic_switch_msr_limit_test_guest(void)
+{
+	vmcall();
+}
+
+static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		msr_list[i].index = MSR_IA32_TSC;
+		msr_list[i].reserved = 0;
+		msr_list[i].value = 0x1234567890abcdef;
+	}
+}
+
+static void configure_atomic_switch_msr_limit_test(
+		struct vmx_msr_entry *test_msr_list, int count)
+{
+	struct vmx_msr_entry *msr_list;
+	const u32 two_mb = 1 << 21;
+	enum atomic_switch_msr_scenario s;
+	enum Encoding addr_field;
+	enum Encoding cnt_field;
+
+	for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {
+		switch (s) {
+		case VM_ENTER_LOAD:
+			addr_field = ENTER_MSR_LD_ADDR;
+			cnt_field = ENT_MSR_LD_CNT;
+			break;
+		case VM_EXIT_LOAD:
+			addr_field = EXIT_MSR_LD_ADDR;
+			cnt_field = EXI_MSR_LD_CNT;
+			break;
+		case VM_EXIT_STORE:
+			addr_field = EXIT_MSR_ST_ADDR;
+			cnt_field = EXI_MSR_ST_CNT;
+			break;
+		default:
+			TEST_ASSERT(false);
+		}
+
+		msr_list = (struct vmx_msr_entry *)vmcs_read(addr_field);
+		memset(msr_list, 0xff, two_mb);
+		if (msr_list == test_msr_list) {
+			populate_msr_list(msr_list, count);
+			vmcs_write(cnt_field, count);
+		} else {
+			vmcs_write(cnt_field, 0);
+		}
+	}
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
+static void atomic_switch_msr_limit_test(void)
+{
+	struct vmx_msr_entry *msr_list;
+	enum atomic_switch_msr_scenario s;
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
+	msr_list = alloc_2m_page();
+	vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(msr_list));
+	msr_list = alloc_2m_page();
+	vmcs_write(EXIT_MSR_LD_ADDR, virt_to_phys(msr_list));
+	msr_list = alloc_2m_page();
+	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(msr_list));
+
+	/* Execute each test case. */
+	for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {
+		struct vmx_msr_entry *msr_list;
+		int count = max_msr_list_size();
+
+		switch (s) {
+		case VM_ENTER_LOAD:
+			msr_list = (struct vmx_msr_entry *)vmcs_read(
+					ENTER_MSR_LD_ADDR);
+			break;
+		case VM_EXIT_LOAD:
+			msr_list = (struct vmx_msr_entry *)vmcs_read(
+					EXIT_MSR_LD_ADDR);
+			break;
+		case VM_EXIT_STORE:
+			msr_list = (struct vmx_msr_entry *)vmcs_read(
+					EXIT_MSR_ST_ADDR);
+			break;
+		default:
+			report("Bad test scenario, %d.", false, s);
+			continue;
+		}
+
+		configure_atomic_switch_msr_limit_test(msr_list, count);
+		enter_guest();
+		assert_exit_reason(VMX_VMCALL);
+	}
+
+	/* Reset the atomic MSR switch count to 0 for all three lists. */
+	configure_atomic_switch_msr_limit_test(0, 0);
+	/* Proceed past guest's single vmcall instruction. */
+	enter_guest();
+	skip_exit_vmcall();
+	/* Terminate the guest. */
+	enter_guest();
+	skip_exit_vmcall();
+}
+
 
 #define TEST(name) { #name, .v2 = name }
 
@@ -8660,5 +8797,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(ept_access_test_paddr_read_execute_ad_enabled),
 	TEST(ept_access_test_paddr_not_present_page_fault),
 	TEST(ept_access_test_force_2m_page),
+	/* Atomic MSR switch tests. */
+	TEST(atomic_switch_msr_limit_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.23.0.237.gc6a4ce50a0-goog

