Return-Path: <kvm+bounces-72921-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDrkLn/EqWknEgEAu9opvQ
	(envelope-from <kvm+bounces-72921-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:59:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C0C216B0E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:59:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1946A308ECDD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F94547DD72;
	Thu,  5 Mar 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoJYSaZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC0047CC8B;
	Thu,  5 Mar 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732704; cv=none; b=ae7DW4GqZGguOJ0K6BUfEuGF18Y9JbBntYwVwrnrmlur3gYv4eO3WVuL0NFkQVEQ0Bpq1VACjhI7Ka7yxofzlVROInBN4+U7iyP+dcIS+DYt+mZ1AbnGvsn6NYHWdGXz65WQBENZhoj4oEoPit/7ByJlynLXHak2gPkRlvhg16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732704; c=relaxed/simple;
	bh=Uw3s4NmHni8ahTubZkhn9lWtC20CWHgztRwkKIZC7ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXqAHM8c3yUG8kSAs3qmyKGfHWii+jBEBAbh1ZCBIjpxzLg8ulhcu/E7oFmewEc0hI5ervQVk3fwHEBSKI4uv7SlnlRjvDyg74A7mqUtRvCIuxztbKYPNz+ICqMpg7lorX9uI7KKUm4T+a2rHC2kAGJ3AEtC0NvMeqP2BNx1yuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoJYSaZ+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732701; x=1804268701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uw3s4NmHni8ahTubZkhn9lWtC20CWHgztRwkKIZC7ZE=;
  b=NoJYSaZ+xO6DOE3I1VETYx8fIIBl/LCNLCWnHJTrztPe/VNQ4bkC4OPv
   yEmvhasTloAy2V0tbkM2AFtgvpNJLMaNLYQE2aDClozcJHTUKwpOGsg27
   a/1NArzT/ot8pKoQf923LXjREBxnn8QkhpuZnYVw6b48I0V2VkEke8AmC
   sQQKRA0OPOupYc7rPZ1KaYbBIE2j9kuWrl4jQp1q/UZDXQYd9kIEvR+ic
   VYBqzUTqKNMoEche7sXB/yQ7UtKsXprrKHbyqTVD4z/N9tyqUjJ27hhg2
   6Vjnn5xI7EIrfa4zIulkVPQ2rYYZs6UCzIBOuqFf3xk/8/p0ulUmJF1O2
   A==;
X-CSE-ConnectionGUID: MNxd6PQER0y3bo1qtjstRA==
X-CSE-MsgGUID: J62R6ropRZWz1XnlB2KMkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301971"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301971"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:51 -0800
X-CSE-ConnectionGUID: 2nn/WEPERHyLYL1VxhquRQ==
X-CSE-MsgGUID: tCP05uaPSquRgmPumXEFVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896543"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:51 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 30/36] KVM: selftests: Add VMCS access test to APIC timer virtualization
Date: Thu,  5 Mar 2026 09:44:10 -0800
Message-ID: <93961bad80c96dd4e71d3a632db07928e4bd9606.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9C0C216B0E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72921-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add test case for VMCS access of nVMX APIC timer virtualization.  It tests
nVMX emulation of a tertiary processor-based VM executing controls MSR,
tertiary processor-base VM execution controls, and related VMCS fields by
L1 vCPU and L2 vCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   1 +
 .../kvm/x86/vmx_apic_timer_virt_vmcs_test.c   | 464 ++++++++++++++++++
 3 files changed, 466 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 3c2a5470c2ca..f0023bab1cd7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -146,6 +146,7 @@ TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += x86/timer_latency
+TEST_GEN_PROGS_x86 += x86/vmx_apic_timer_virt_vmcs_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 5ca6bacbd70e..b47e905aa4e8 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -35,6 +35,7 @@
 #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
 #define		APIC_SPIV_APIC_ENABLED		(1 << 8)
 #define	APIC_ISR	0x100
+#define APIC_ISR_NR	0x8
 #define APIC_IRR	0x200
 #define	APIC_ICR	0x300
 #define	APIC_LVTCMCI	0x2f0
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c
new file mode 100644
index 000000000000..cd440b636585
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c
@@ -0,0 +1,464 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Tested vmread()/vmwrite() related to APIC timer virtualization in L1
+ * emulated by KVM.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#include <string.h>
+#include <sys/ioctl.h>
+#include <stdatomic.h>
+
+bool have_procbased_tertiary_ctls;
+bool have_apic_timer_virtualization;
+
+#define L2_GUEST_STACK_SIZE 256
+static unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+/* Any value [32, 255] for timer vector is okay. */
+#define TIMER_VECTOR   0xec
+
+static bool update_l2_tsc_deadline;
+static uint64_t l2_tsc_deadline;
+
+static void guest_timer_interrupt_handler(struct ex_regs *regs)
+{
+	x2apic_write_reg(APIC_EOI, 0);
+}
+
+static void l2_guest_code(void)
+{
+	cli();
+	x2apic_enable();
+	wrmsr(MSR_IA32_TSC_DEADLINE, 0);
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_TSCDEADLINE | TIMER_VECTOR);
+
+	vmcall();
+
+	while (true) {
+		/* reap pending timer interrupt. */
+		sti_nop_cli();
+
+		if (update_l2_tsc_deadline)
+			GUEST_ASSERT(!wrmsr_safe(MSR_IA32_TSC_DEADLINE, l2_tsc_deadline));
+
+		vmcall();
+	}
+
+	GUEST_FAIL("should not reached.");
+}
+
+static void setup_l2(struct vmx_pages *vmx_pages)
+{
+	uint64_t ctls, msr_val;
+	int r;
+
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
+				 &msr_val));
+	GUEST_ASSERT_EQ(have_procbased_tertiary_ctls,
+			!!((msr_val >> 32) & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS));
+
+	r = rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &msr_val);
+	GUEST_ASSERT(have_procbased_tertiary_ctls == !r);
+	if (r)
+		msr_val = 0;
+	GUEST_ASSERT_EQ(have_apic_timer_virtualization,
+			!!(msr_val & TERTIARY_EXEC_GUEST_APIC_TIMER));
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_ASSERT(!vmread(PIN_BASED_VM_EXEC_CONTROL, &ctls));
+	ctls |= PIN_BASED_EXT_INTR_MASK;
+	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL, ctls));
+
+	GUEST_ASSERT(!vmread(CPU_BASED_VM_EXEC_CONTROL, &ctls));
+	ctls |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_TPR_SHADOW |
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	if (have_procbased_tertiary_ctls)
+		ctls |= CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL, ctls));
+
+	GUEST_ASSERT(!vmread(SECONDARY_VM_EXEC_CONTROL, &ctls));
+	ctls |= SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+		SECONDARY_EXEC_APIC_REGISTER_VIRT |
+		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	GUEST_ASSERT(!vmwrite(SECONDARY_VM_EXEC_CONTROL, ctls));
+
+	if (have_procbased_tertiary_ctls) {
+		GUEST_ASSERT(!vmread(TERTIARY_VM_EXEC_CONTROL, &ctls));
+
+		ctls &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+		GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+	} else {
+		GUEST_ASSERT(vmread(TERTIARY_VM_EXEC_CONTROL, &ctls));
+		ctls = 0;
+	}
+
+	ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+	GUEST_ASSERT_EQ(have_procbased_tertiary_ctls,
+			!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+	if (have_procbased_tertiary_ctls && !have_apic_timer_virtualization) {
+		ctls &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+		GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+	}
+
+	GUEST_ASSERT_EQ(have_apic_timer_virtualization,
+			!vmwrite(GUEST_APIC_TIMER_VECTOR, TIMER_VECTOR));
+}
+
+static void skip_guest_instruction(void)
+{
+	uint64_t guest_rip, length;
+
+	GUEST_ASSERT(!vmread(GUEST_RIP, &guest_rip));
+	GUEST_ASSERT(!vmread(VM_EXIT_INSTRUCTION_LEN, &length));
+
+	GUEST_ASSERT(!vmwrite(GUEST_RIP, guest_rip + length));
+	GUEST_ASSERT(!vmwrite(VM_EXIT_INSTRUCTION_LEN, 0));
+}
+
+static void l2_load_vmlaunch(struct vmx_pages *vmx_pages)
+{
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	skip_guest_instruction();
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
+}
+
+struct vmcs_guest_deadline {
+	uint64_t vir;
+	uint64_t phy;
+};
+
+struct deadline_test {
+	struct vmcs_guest_deadline set;
+	struct vmcs_guest_deadline result;
+};
+
+static void test_vmclear_vmptrld(struct vmx_pages *vmx_pages)
+{
+	struct deadline_test tests[] = {
+		{
+			.set = {
+				.vir = ~0ull,
+				.phy = ~0ull,
+			},
+			.result = {
+				.vir = ~0ull,
+				.phy = ~0ull,
+			}
+		},
+		{
+			.set = {
+				.vir = ~0ull,
+				.phy = 0,
+			},
+			.result = {
+				.vir = ~0ull,
+				.phy = 0,
+			}
+		},
+		{
+			.set = {
+				.vir = ~0ull,
+				.phy = 1,
+			},
+			.result = {
+				.vir = 0,
+				.phy = 0,
+			}
+		},
+		{
+			.set = {
+				.vir = 0,
+				.phy = ~0ull,
+			},
+			.result = {
+				.vir = 0,
+				.phy = ~0ull,
+			}
+		},
+		{
+			.set = {
+				.vir = 1,
+				.phy = ~0ull,
+			},
+			.result = {
+				.vir = 1,
+				.phy = ~0ull,
+			}
+		},
+		{
+			.set = {
+				.vir = 1,
+				.phy = 1,
+			},
+			.result = {
+				.vir = 0,
+				.phy = 0,
+			}
+		},
+		{
+			.set = {
+				.vir = 1,
+				.phy = 0,
+			},
+			.result = {
+				.vir = 1,
+				.phy = 0,
+			}
+		},
+		{
+			.set = {
+				.vir = 0,
+				.phy = 1,
+			},
+			.result = {
+				.vir = 0,
+				.phy = 0,
+			}
+		},
+	};
+	int i;
+
+	if (!have_apic_timer_virtualization)
+		return;
+
+	update_l2_tsc_deadline = false;
+
+	/*
+	 * Test if KVM properly store/load TIMER_VECTOR, guest deadline of
+	 * vmcs area to/from memory.
+	 * Enforce KVM to store nested vmcs to memory and load it again.
+	 * load_vmcs() issues vmclear(), and then vmptrld()
+	 */
+	l2_load_vmlaunch(vmx_pages);
+	GUEST_ASSERT_EQ(vmreadz(GUEST_APIC_TIMER_VECTOR), TIMER_VECTOR);
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		struct deadline_test *test = &tests[i];
+		uint64_t vir, phy, val;
+
+		GUEST_ASSERT(!vmwrite(GUEST_DEADLINE_VIR, test->set.vir));
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_VIR, &val));
+		GUEST_ASSERT_EQ(test->set.vir, val);
+
+		GUEST_ASSERT(!vmwrite(GUEST_DEADLINE_PHY, test->set.phy));
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_PHY, &val));
+		GUEST_ASSERT_EQ(test->set.phy, val);
+
+		l2_load_vmlaunch(vmx_pages);
+
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_VIR, &vir));
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_PHY, &phy));
+
+		GUEST_ASSERT_EQ(vir, test->result.vir);
+		GUEST_ASSERT_EQ(!!phy, !!test->result.phy);
+	}
+}
+
+static void test_ctls(void)
+{
+	uint64_t ctls;
+
+	update_l2_tsc_deadline = false;
+
+	GUEST_ASSERT_EQ(!vmwrite(GUEST_APIC_TIMER_VECTOR, TIMER_VECTOR),
+			have_apic_timer_virtualization);
+	GUEST_ASSERT_EQ(!vmwrite(GUEST_DEADLINE_VIR, 0),
+			have_apic_timer_virtualization);
+	GUEST_ASSERT_EQ(!vmwrite(GUEST_DEADLINE_PHY, 0),
+			have_apic_timer_virtualization);
+
+	if (!have_procbased_tertiary_ctls) {
+		GUEST_ASSERT(!vmread(CPU_BASED_VM_EXEC_CONTROL, &ctls));
+		ctls |= CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+		GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL, ctls));
+
+		skip_guest_instruction();
+		GUEST_ASSERT(vmresume());
+
+		ctls &= ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+		GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL, ctls));
+	}
+
+	if (have_procbased_tertiary_ctls && !have_apic_timer_virtualization) {
+		GUEST_ASSERT(!vmread(TERTIARY_VM_EXEC_CONTROL, &ctls));
+		ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+		GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+
+		skip_guest_instruction();
+		GUEST_ASSERT(vmresume());
+
+		ctls &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+		GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+	}
+}
+
+static void test_l2_set_deadline(void)
+{
+	uint64_t deadlines[] = {
+		0,
+		1,
+		2,
+
+		rdtsc() / 2,
+		rdtsc(),
+		rdtsc() * 2,
+
+		~0ull / 2 - 1,
+		~0ull / 2,
+		~0ull / 2 + 1,
+
+		~0ull - 1,
+		~0ull - 2,
+		~0ull,
+	};
+	int i;
+
+	update_l2_tsc_deadline = true;
+
+	for (i = 0; i < ARRAY_SIZE(deadlines); i++) {
+		uint64_t phy, vir;
+
+		l2_tsc_deadline = deadlines[i];
+
+		skip_guest_instruction();
+		GUEST_ASSERT(!vmresume());
+		GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
+
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_VIR, &vir));
+		GUEST_ASSERT(!vmread(GUEST_DEADLINE_PHY, &phy));
+
+		GUEST_ASSERT(!vir || vir == l2_tsc_deadline);
+	}
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	setup_l2(vmx_pages);
+
+	GUEST_ASSERT_EQ(have_apic_timer_virtualization,
+			!vmwrite(GUEST_DEADLINE_VIR, ~0ull));
+	GUEST_ASSERT_EQ(have_apic_timer_virtualization,
+			!vmwrite(GUEST_DEADLINE_PHY, ~0ull));
+
+	test_vmclear_vmptrld(vmx_pages);
+
+	update_l2_tsc_deadline = false;
+	l2_load_vmlaunch(vmx_pages);
+	test_ctls();
+
+	if (have_apic_timer_virtualization) {
+		update_l2_tsc_deadline = false;
+		l2_load_vmlaunch(vmx_pages);
+
+		test_l2_set_deadline();
+	}
+
+	GUEST_DONE();
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+
+	while (!done) {
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static void test_apic_virtualization_vmcs(void)
+{
+	vm_vaddr_t vmx_pages_gva;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t ctls, ctls3;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_TSC_DEADLINE_TIMER);
+
+	ctls = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	if (have_procbased_tertiary_ctls) {
+		ctls |= (uint64_t)CPU_BASED_ACTIVATE_TERTIARY_CONTROLS << 32;
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, ctls);
+
+		ctls3 = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3);
+		if (have_apic_timer_virtualization)
+			ctls3 |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+		else
+			ctls3 &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+	} else {
+		ctls &= ~((uint64_t)CPU_BASED_ACTIVATE_TERTIARY_CONTROLS << 32);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, ctls);
+	}
+
+	/* For L2. */
+	vm_install_exception_handler(vm, TIMER_VECTOR,
+				     guest_timer_interrupt_handler);
+
+	sync_global_to_guest(vm, have_procbased_tertiary_ctls);
+	sync_global_to_guest(vm, have_apic_timer_virtualization);
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	have_procbased_tertiary_ctls =
+		(kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32) &
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	have_apic_timer_virtualization = have_procbased_tertiary_ctls &&
+		(kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3) &
+		 TERTIARY_EXEC_GUEST_APIC_TIMER);
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	test_apic_virtualization_vmcs();
+
+	if (have_apic_timer_virtualization) {
+		have_apic_timer_virtualization = false;
+		test_apic_virtualization_vmcs();
+	}
+
+	if (have_procbased_tertiary_ctls) {
+		have_procbased_tertiary_ctls = false;
+		test_apic_virtualization_vmcs();
+	}
+
+	return 0;
+}
-- 
2.45.2


