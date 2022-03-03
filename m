Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955504CB7C4
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiCCH2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiCCH2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3774CF541B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292476; x=1677828476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HfcpUSTpN38O0ixGMjonhMYPbsbTHLCcDC6lTkSGn9I=;
  b=Sbk7mxOWaffXtVMYQ2hSaYt5ZQa6OtAiYDvP8WMVM2vHLSb6/4AzXDQ1
   cvw9z++8Eo4QcTsDkITucWWtkcF+Ys590Mj/AW5ycxTbVDhgnrRwMzrr8
   6G1NY0tJcKPRoIp1gxqU1l9ImcmEXbNh+fm4yeYdzQ+PcvbaIPFncPglC
   +YrL7RSaKw4REx7MdTturKdNSgFnpF4/IpKhrDiDqGaUM0TZvjArAVy4+
   zUlSwLPFy7WoxhgKw2qlvDnYIUcDKYPsJshS2uo05nizVAnoHYJ5Hd6mJ
   eaMXQelUNQ+lRE0YdUy3po1iOCr9pc6KTHIVywTWjXjMfZfwdi4gPEZzK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177032"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177032"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:56 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631812"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:53 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 14/17] x86 TDX: Add TDX specific test case
Date:   Thu,  3 Mar 2022 15:19:04 +0800
Message-Id: <20220303071907.650203-15-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sub-test1:
Test APIC self IPI with vector < 16 trigger #VE.

sub-test2:
Test single step on simulation instructions work well with single step
emulation in #VE handler, we choose cpuid(0xb) and wrmsr(0x1a0) to test.
Please note not all cpuid trigger #VE, e.x. cpuid(0) will not.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 x86/Makefile.x86_64 |  1 +
 x86/intel_tdx.c     | 94 +++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  4 ++
 3 files changed, 99 insertions(+)
 create mode 100644 x86/intel_tdx.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index a3cb75ae5868..de79212951a3 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -31,6 +31,7 @@ tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
+tests += $(TEST_DIR)/intel_tdx.$(exe)
 
 ifeq ($(TARGET_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/intel_tdx.c b/x86/intel_tdx.c
new file mode 100644
index 000000000000..e7e65fb32b89
--- /dev/null
+++ b/x86/intel_tdx.c
@@ -0,0 +1,94 @@
+#include "libcflat.h"
+#include "x86/processor.h"
+#include "x86/apic-defs.h"
+#include "x86/tdx.h"
+#include "msr.h"
+
+static volatile unsigned long db_addr[10], dr6[10];
+static volatile unsigned int n;
+
+static void test_selfipi_msr(void)
+{
+	unsigned char vector;
+	u64 i;
+
+	printf("start APIC_SELF_IPI MSR write test.\n");
+
+	for (i = 0; i < 16; i++) {
+		vector = wrmsr_checking(APIC_SELF_IPI, i);
+		report(vector == VE_VECTOR,
+		       "Expected #VE on WRSMR(%s, 0x%lx), got vector %d",
+		       "APIC_SELF_IPI", i, vector);
+	}
+
+	printf("end APIC_SELF_IPI MSR write test.\n");
+}
+
+static void handle_db(struct ex_regs *regs)
+{
+	db_addr[n] = regs->rip;
+	dr6[n] = read_dr6();
+
+	if (dr6[n] & 0x1)
+		regs->rflags |= (1 << 16);
+
+	if (++n >= 10) {
+		regs->rflags &= ~(1 << 8);
+		write_dr7(0x00000400);
+	}
+}
+
+static void test_single_step(void)
+{
+	unsigned long start;
+
+	handle_exception(DB_VECTOR, handle_db);
+
+	/*
+	 * cpuid(0xb) and wrmsr(0x1a0) trigger #VE and are then emulated.
+	 * Test #DB on these instructions as there is single step
+	 * simulation in #VE handler. This is complement to x86/debug.c
+	 * which test cpuid(0) and in(0x3fd) instruction. In fact,
+	 * cpuid(0) is emulated by seam module.
+	 */
+	n = 0;
+	write_dr6(0);
+	asm volatile(
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"lea (%%rip),%0\n\t"
+		"popf\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"mov $0xb,%%rax\n\t"
+		"cpuid\n\t"
+		"movl $0x1a0,%%ecx\n\t"
+		"rdmsr\n\t"
+		"wrmsr\n\t"
+		"popf\n\t"
+		: "=r" (start) : : "rax", "ebx", "ecx", "edx");
+	report(n == 8 &&
+	       db_addr[0] == start + 1 + 6 && dr6[0] == 0xffff4ff0 &&
+	       db_addr[1] == start + 1 + 6 + 1 && dr6[1] == 0xffff4ff0 &&
+	       db_addr[2] == start + 1 + 6 + 1 + 7 && dr6[2] == 0xffff4ff0 &&
+	       db_addr[3] == start + 1 + 6 + 1 + 7 + 2 && dr6[3] == 0xffff4ff0 &&
+	       db_addr[4] == start + 1 + 6 + 1 + 7 + 2 + 5 && dr6[4] == 0xffff4ff0 &&
+	       db_addr[5] == start + 1 + 6 + 1 + 7 + 2 + 5 + 2 && dr6[5] == 0xffff4ff0 &&
+	       db_addr[6] == start + 1 + 6 + 1 + 7 + 2 + 5 + 2 + 2 && dr6[6] == 0xffff4ff0 &&
+	       db_addr[7] == start + 1 + 6 + 1 + 7 + 2 + 5 + 2 + 2 + 1 && dr6[6] == 0xffff4ff0,
+	       "single step emulated instructions");
+}
+
+int main(void)
+{
+	if (!is_tdx_guest()) {
+		printf("Not TDX environment!\n");
+		return report_summary();
+	}
+
+	test_selfipi_msr();
+	test_single_step();
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9a70ba3b4f2e..840e2054d54d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -437,3 +437,7 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[intel_tdx]
+file = intel_tdx.flat
+arch = x86_64
-- 
2.25.1

