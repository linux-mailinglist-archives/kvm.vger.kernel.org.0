Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9082A89FD
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 23:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbgKEWib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 17:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732035AbgKEWib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 17:38:31 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72945C0613CF
        for <kvm@vger.kernel.org>; Thu,  5 Nov 2020 14:38:31 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id t10so2413448pfh.19
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 14:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=U8vK9QwD3Ttl2tmRLvzoELiGV+TYBcdGNosbACJ1xgA=;
        b=N76gIeYgwIEE/qGX/4iFlhYnvZmoYDmvfhegBwJJC+TJcuaZ1UK8hjsmI4ctLXxu1h
         +abyKqc7m/hDJcddSS7rjgqsC69WAPOEYsWBNQTG0kXSRnQJffm28qFeJ/TnBZqmmrTZ
         lVD6Ipag1kqvcKBhIcAQqKyYX7fkWnhIEsI9u9016oZxdzG3/crdS3ij4CK3oJbEVNrP
         p0F/HxiwDoyDZLf0lj2AU9gCo/qXRkWdrGp/hML45BLX7QkuF7WEsdLYH62TxP4Rgs9U
         wtw76yFPhkHhho0zpX+6TwOrl8PV94Emod6mMxYq6ZXfPM+tSmMcSbnYQQzECOXBcojp
         ylBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=U8vK9QwD3Ttl2tmRLvzoELiGV+TYBcdGNosbACJ1xgA=;
        b=VmDtNQ6r6CopLopKEl2A3aj2/1aeQfTMxrh2zoFbWM0C1ZyRgWfKp3W6WsQ8aH2CX0
         oUEHZ5RiMdYk50w70asViNkCheX3X2d0aGjL4GZHES6vJnwrOJ1aNasTxJnwDuylWzwh
         HYRs2lXJ9lTMtXZDuJXqav+TgZVWl8W/2GpH6ewctuhJ7297lOixcTbEIIWYVsy7cC77
         uXop0vtRa3O3DhBIVfXohCThTxry3BjZLPApJa8c5NFYyjt2jwJwXg81p+ITWPIKpx2p
         a7GWVzD11i87NBGtdl9GXvXtbhAgAN3hS2dr35r25yiyPXQiqLUHP8P867W8o0G+f9ZZ
         tbEA==
X-Gm-Message-State: AOAM530ISTgsr6+Ub+Mu2n+W1XDaUM27HUd3CxVvZEEjhwz7loekiRMC
        dwHsmYs5BaTtlPVzkF/HrrqkeW5xaYIOqHHgvDsdePP0YlE7490tWJHl24xZsmuBpwXAcsmLq/T
        IJfv6G/blLRfT3ApcSemE8XQhhHRdNCg0mcFm16N9xCZFGDZiF8QbC4qYOw==
X-Google-Smtp-Source: ABdhPJzXzevLebD+PpO4cI5hp7/vpEFFbXMn8TllH3A+inRPhW1Iq1ImPN7xWa10iEItQ6XiKcTObMlJ1ZE=
Sender: "pshier via sendgmr" 
        <pshier@pshier-linuxworkstation.sea.corp.google.com>
X-Received: from pshier-linuxworkstation.sea.corp.google.com
 ([2620:15c:100:202:a28c:fdff:fee1:c360]) (user=pshier job=sendgmr) by
 2002:a17:90a:b63:: with SMTP id 90mr4760925pjq.154.1604615910926; Thu, 05 Nov
 2020 14:38:30 -0800 (PST)
Date:   Thu,  5 Nov 2020 14:38:23 -0800
Message-Id: <20201105223823.850068-1-pshier@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] KVM: selftests: Test IPI to halted vCPU in xAPIC while
 backing page moves
From:   Peter Shier <pshier@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest is using xAPIC KVM allocates a backing page for the required
EPT entry for the APIC access address set in the VMCS. If mm decides to
move that page the KVM mmu notifier will update the VMCS with the new
HPA. This test induces a page move to test that APIC access continues to
work correctly. It is a directed test for
commit e649b3f0188f "KVM: x86: Fix APIC page invalidation race".

Tested: ran for 1 hour on a skylake, migrating backing page every 1ms

Depends on patch "selftests: kvm: Add exception handling to selftests"
from aaronlewis@google.com that has not yet been queued.

Signed-off-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/include/numaif.h  |  55 ++
 .../selftests/kvm/include/x86_64/processor.h  |  20 +
 .../selftests/kvm/x86_64/xapic_ipi_test.c     | 544 ++++++++++++++++++
 5 files changed, 621 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/numaif.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 307ceaadbbb9..56f8367e2ace 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -19,6 +19,7 @@
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
+/x86_64/xapic_ipi_test
 /x86_64/xss_msr_test
 /clear_dirty_log_test
 /demand_paging_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index aaaf992faf87..19283554ef5e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -53,6 +53,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
new file mode 100644
index 000000000000..b020547403fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/numaif.h
+ *
+ * Copyright (C) 2020, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Header file that provides access to NUMA API functions not explicitly
+ * exported to user space.
+ */
+
+#ifndef SELFTEST_KVM_NUMAIF_H
+#define SELFTEST_KVM_NUMAIF_H
+
+#define __NR_get_mempolicy 239
+#define __NR_migrate_pages 256
+
+/* System calls */
+long get_mempolicy(int *policy, const unsigned long *nmask,
+		   unsigned long maxnode, void *addr, int flags)
+{
+	return syscall(__NR_get_mempolicy, policy, nmask,
+		       maxnode, addr, flags);
+}
+
+long migrate_pages(int pid, unsigned long maxnode,
+		   const unsigned long *frommask,
+		   const unsigned long *tomask)
+{
+	return syscall(__NR_migrate_pages, pid, maxnode, frommask, tomask);
+}
+
+/* Policies */
+#define MPOL_DEFAULT	 0
+#define MPOL_PREFERRED	 1
+#define MPOL_BIND	 2
+#define MPOL_INTERLEAVE	 3
+
+#define MPOL_MAX MPOL_INTERLEAVE
+
+/* Flags for get_mem_policy */
+#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
+				    /* Warning: MPOL_F_NODE is unsupported and
+				     * subject to change. Don't use.
+				     */
+#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
+#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
+
+/* Flags for mbind */
+#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
+#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
+#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
+
+#endif /* SELFTEST_KVM_NUMAIF_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 02530dc6339b..313ec00b1f7c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -377,8 +377,27 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
+#define APIC_DEFAULT_GPA		0xfee00000ULL
+
+/* APIC base address MSR and fields */
+#define MSR_IA32_APICBASE		0x0000001b
+#define MSR_IA32_APICBASE_BSP		(1<<8)
+#define MSR_IA32_APICBASE_EXTD		(1<<10)
+#define MSR_IA32_APICBASE_ENABLE	(1<<11)
+#define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
+#define		GET_APIC_BASE(x)	(((x) >> 12) << 12)
+
 #define APIC_BASE_MSR	0x800
 #define X2APIC_ENABLE	(1UL << 10)
+#define	APIC_ID		0x20
+#define	APIC_LVR	0x30
+#define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
+#define	APIC_TASKPRI	0x80
+#define	APIC_PROCPRI	0xA0
+#define	APIC_EOI	0xB0
+#define	APIC_SPIV	0xF0
+#define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
+#define		APIC_SPIV_APIC_ENABLED		(1 << 8)
 #define	APIC_ICR	0x300
 #define		APIC_DEST_SELF		0x40000
 #define		APIC_DEST_ALLINC	0x80000
@@ -403,6 +422,7 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
 #define		APIC_DM_EXTINT		0x00700
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
+#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
 
 /* VMX_EPT_VPID_CAP bits */
 #define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
new file mode 100644
index 000000000000..47c0ec975330
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * xapic_ipi_test
+ *
+ * Copyright (C) 2020, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Test that when the APIC is in xAPIC mode, a vCPU can send an IPI to wake
+ * another vCPU that is halted when KVM's backing page for the APIC access
+ * address has been moved by mm.
+ *
+ * The test starts two vCPUs: one that sends IPIs and one that continually
+ * executes HLT. The sender checks that the halter has woken from the HLT and
+ * has reentered HLT before sending the next IPI. While the vCPUs are running,
+ * the host continually calls migrate_pages to move all of the process' pages
+ * amongst the available numa nodes on the machine.
+ *
+ * Migration is a command line option. When used on non-numa machines will 
+ * exit with error. Test is still usefull on non-numa for testing IPIs.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <getopt.h>
+#include <pthread.h>
+#include <inttypes.h>
+#include <string.h>
+#include <time.h>
+
+#include "kvm_util.h"
+#include "numaif.h"
+#include "processor.h"
+#include "test_util.h"
+#include "vmx.h"
+
+/* Default running time for the test */
+#define DEFAULT_RUN_SECS 3
+
+/* Default delay between migrate_pages calls (microseconds) */
+#define DEFAULT_DELAY_USECS 500000
+
+#define HALTER_VCPU_ID 0
+#define SENDER_VCPU_ID 1
+
+volatile uint32_t *apic_base = (volatile uint32_t *)APIC_DEFAULT_GPA;
+
+/*
+ * Vector for IPI from sender vCPU to halting vCPU.
+ * Value is arbitrary and was chosen for the alternating bit pattern. Any
+ * value should work.
+ */
+#define IPI_VECTOR	 0xa5
+
+/*
+ * Incremented in the IPI handler. Provides evidence to the sender that the IPI
+ * arrived at the destination
+ */
+static volatile uint64_t ipis_rcvd;
+
+/* Data struct shared between host main thread and vCPUs */
+struct test_data_page {
+	uint32_t halter_apic_id;
+	volatile uint64_t hlt_count;
+	volatile uint64_t wake_count;
+	uint64_t ipis_sent;
+	uint64_t migrations_attempted;
+	uint64_t migrations_completed;
+	uint32_t icr;
+	uint32_t icr2;
+	uint32_t halter_tpr;
+	uint32_t halter_ppr;
+
+	/*
+	 *  Record local version register as a cross-check that APIC access
+	 *  worked. Value should match what KVM reports (APIC_VERSION in
+	 *  arch/x86/kvm/lapic.c). If test is failing, check that values match
+	 *  to determine whether APIC access exits are working.
+	 */
+	uint32_t halter_lvr;
+};
+
+struct thread_params {
+	struct test_data_page *data;
+	struct kvm_vm *vm;
+	uint32_t vcpu_id;
+	uint64_t *pipis_rcvd; /* host address of ipis_rcvd global */
+};
+
+uint32_t read_apic_reg(uint reg)
+{
+	return apic_base[reg >> 2];
+}
+
+void write_apic_reg(uint reg, uint32_t val)
+{
+	apic_base[reg >> 2] = val;
+}
+
+void disable_apic(void)
+{
+	wrmsr(MSR_IA32_APICBASE,
+	      rdmsr(MSR_IA32_APICBASE) &
+		~(MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD));
+}
+
+void enable_xapic(void)
+{
+	uint64_t val = rdmsr(MSR_IA32_APICBASE);
+
+	/* Per SDM: to enable xAPIC when in x2APIC must first disable APIC */
+	if (val & MSR_IA32_APICBASE_EXTD) {
+		disable_apic();
+		wrmsr(MSR_IA32_APICBASE,
+		      rdmsr(MSR_IA32_APICBASE) | MSR_IA32_APICBASE_ENABLE);
+	} else if (!(val & MSR_IA32_APICBASE_ENABLE)) {
+		wrmsr(MSR_IA32_APICBASE, val | MSR_IA32_APICBASE_ENABLE);
+	}
+
+	/*
+	 * Per SDM: reset value of spurious interrupt vector register has the
+	 * APIC software enabled bit=0. It must be enabled in addition to the
+	 * enable bit in the MSR.
+	 */
+	val = read_apic_reg(APIC_SPIV) | APIC_SPIV_APIC_ENABLED;
+	write_apic_reg(APIC_SPIV, val);
+}
+
+void verify_apic_base_addr(void)
+{
+	uint64_t msr = rdmsr(MSR_IA32_APICBASE);
+	uint64_t base = GET_APIC_BASE(msr);
+
+	GUEST_ASSERT(base == APIC_DEFAULT_GPA);
+}
+
+static void halter_guest_code(struct test_data_page *data)
+{
+	verify_apic_base_addr();
+	enable_xapic();
+
+	data->halter_apic_id = GET_APIC_ID_FIELD(read_apic_reg(APIC_ID));
+	data->halter_lvr = read_apic_reg(APIC_LVR);
+
+	/*
+	 * Loop forever HLTing and recording halts & wakes. Disable interrupts
+	 * each time around to minimize window between signaling the pending
+	 * halt to the sender vCPU and executing the halt. No need to disable on
+	 * first run as this vCPU executes first and the host waits for it to
+	 * signal going into first halt before starting the sender vCPU. Record
+	 * TPR and PPR for diagnostic purposes in case the test fails.
+	 */
+	for (;;) {
+		data->halter_tpr = read_apic_reg(APIC_TASKPRI);
+		data->halter_ppr = read_apic_reg(APIC_PROCPRI);
+		data->hlt_count++;
+		asm volatile("sti; hlt; cli");
+		data->wake_count++;
+	}
+}
+
+/*
+ * Runs on halter vCPU when IPI arrives. Write an arbitrary non-zero value to
+ * enable diagnosing errant writes to the APIC access address backing page in
+ * case of test failure.
+ */
+static void guest_ipi_handler(struct ex_regs *regs)
+{
+	ipis_rcvd++;
+	write_apic_reg(APIC_EOI, 77);
+}
+
+static void sender_guest_code(struct test_data_page *data)
+{
+	uint64_t last_wake_count;
+	uint64_t last_hlt_count;
+	uint64_t last_ipis_rcvd_count;
+	uint32_t icr_val;
+	uint32_t icr2_val;
+	uint64_t tsc_start;
+
+	verify_apic_base_addr();
+	enable_xapic();
+
+	/*
+	 * Init interrupt command register for sending IPIs
+	 *
+	 * Delivery mode=fixed, per SDM:
+	 *   "Delivers the interrupt specified in the vector field to the target
+	 *    processor."
+	 *
+	 * Destination mode=physical i.e. specify target by its local APIC
+	 * ID. This vCPU assumes that the halter vCPU has already started and
+	 * set data->halter_apic_id.
+	 */
+	icr_val = (APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR);
+	icr2_val = SET_APIC_DEST_FIELD(data->halter_apic_id);
+	data->icr = icr_val;
+	data->icr2 = icr2_val;
+
+	last_wake_count = data->wake_count;
+	last_hlt_count = data->hlt_count;
+	last_ipis_rcvd_count = ipis_rcvd;
+	for (;;) {
+		/*
+		 * Send IPI to halter vCPU.
+		 * First IPI can be sent unconditionally because halter vCPU
+		 * starts earlier.
+		 */
+		write_apic_reg(APIC_ICR2, icr2_val);
+		write_apic_reg(APIC_ICR, icr_val);
+		data->ipis_sent++;
+
+		/*
+		 * Wait up to ~1 sec for halter to indicate that it has:
+		 * 1. Received the IPI
+		 * 2. Woken up from the halt
+		 * 3. Gone back into halt
+		 * Current CPUs typically run at 2.x Ghz which is ~2
+		 * billion ticks per second.
+		 */
+		tsc_start = rdtsc();
+		while (rdtsc() - tsc_start < 2000000000) {
+			if ((ipis_rcvd != last_ipis_rcvd_count) &&
+			    (data->wake_count != last_wake_count) &&
+			    (data->hlt_count != last_hlt_count))
+				break;
+		}
+
+		GUEST_ASSERT((ipis_rcvd != last_ipis_rcvd_count) &&
+			     (data->wake_count != last_wake_count) &&
+			     (data->hlt_count != last_hlt_count));
+
+		last_wake_count = data->wake_count;
+		last_hlt_count = data->hlt_count;
+		last_ipis_rcvd_count = ipis_rcvd;
+	}
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct thread_params *params = (struct thread_params *)arg;
+	struct ucall uc;
+	int old;
+	int r;
+	unsigned int exit_reason;
+
+	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
+	TEST_ASSERT(r == 0,
+		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
+		    params->vcpu_id, r);
+
+	fprintf(stderr, "vCPU thread running vCPU %u\n", params->vcpu_id);
+	vcpu_run(params->vm, params->vcpu_id);
+	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+
+	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
+		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
+		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+
+	if (get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_ABORT) {
+		TEST_ASSERT(false,
+			    "vCPU %u exited with error: %s.\n"
+			    "Sending vCPU sent %lu IPIs to halting vCPU\n"
+			    "Halting vCPU halted %lu times, woke %lu times, received %lu IPIs.\n"
+			    "Halter TPR=%#x PPR=%#x LVR=%#x\n"
+			    "Migrations attempted: %lu\n"
+			    "Migrations completed: %lu\n",
+			    params->vcpu_id, (const char *)uc.args[0],
+			    params->data->ipis_sent, params->data->hlt_count,
+			    params->data->wake_count,
+			    *params->pipis_rcvd, params->data->halter_tpr,
+			    params->data->halter_ppr, params->data->halter_lvr,
+			    params->data->migrations_attempted,
+			    params->data->migrations_completed);
+	}
+
+	return NULL;
+}
+
+static void cancel_join_vcpu_thread(pthread_t thread, uint32_t vcpu_id)
+{
+	void *retval;
+	int r;
+
+	r = pthread_cancel(thread);
+	TEST_ASSERT(r == 0,
+		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
+		    vcpu_id, r);
+
+	r = pthread_join(thread, &retval);
+	TEST_ASSERT(r == 0,
+		    "pthread_join on vcpu_id=%d failed with errno=%d",
+		    vcpu_id, r);
+	TEST_ASSERT(retval == PTHREAD_CANCELED,
+		    "expected retval=%p, got %p", PTHREAD_CANCELED,
+		    retval);
+}
+
+void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
+		   uint64_t *pipis_rcvd)
+{
+	long pages_not_moved;
+	unsigned long nodemask = 0;
+	unsigned long nodemasks[sizeof(nodemask) * 8];
+	int nodes = 0;
+	time_t start_time, last_update, now;
+	time_t interval_secs = 1;
+	int i, r;
+	int from, to;
+	unsigned long bit;
+	uint64_t hlt_count;
+	uint64_t wake_count;
+	uint64_t ipis_sent;
+
+	fprintf(stderr, "Calling migrate_pages every %d microseconds\n",
+		delay_usecs);
+
+	/* Get set of first 64 numa nodes available */
+	r = get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
+			  0, MPOL_F_MEMS_ALLOWED);
+	TEST_ASSERT(r == 0, "get_mempolicy failed errno=%d", errno);
+
+	fprintf(stderr, "Numa nodes found amongst first %lu possible nodes "
+		"(each 1-bit indicates node is present): %#lx\n",
+		sizeof(nodemask) * 8, nodemask);
+
+	/* Init array of masks containing a single-bit in each, one for each
+	 * available node. migrate_pages called below requires specifying nodes
+	 * as bit masks.
+	 */
+	for (i = 0, bit = 1; i < sizeof(nodemask) * 8; i++, bit <<= 1) {
+		if (nodemask & bit) {
+			nodemasks[nodes] = nodemask & bit;
+			nodes++;
+		}
+	}
+
+	TEST_ASSERT(nodes > 1,
+		    "Did not find at least 2 numa nodes. Can't do migration\n");
+
+	fprintf(stderr, "Migrating amongst %d nodes found\n", nodes);
+
+	from = 0;
+	to = 1;
+	start_time = time(NULL);
+	last_update = start_time;
+
+	ipis_sent = data->ipis_sent;
+	hlt_count = data->hlt_count;
+	wake_count = data->wake_count;
+
+	while ((int)(time(NULL) - start_time) < run_secs) {
+		data->migrations_attempted++;
+
+		/*
+		 * migrate_pages with PID=0 will migrate all pages of this
+		 * process between the nodes specified as bitmasks. The page
+		 * backing the APIC access address belongs to this process
+		 * because it is allocated by KVM in the context of the
+		 * KVM_CREATE_VCPU ioctl. If that assumption ever changes this
+		 * test may break or give a false positive signal.
+		 */
+		pages_not_moved = migrate_pages(0, sizeof(nodemasks[from]),
+						&nodemasks[from],
+						&nodemasks[to]);
+		if (pages_not_moved < 0)
+			fprintf(stderr,
+				"migrate_pages failed, errno=%d\n", errno);
+		else if (pages_not_moved > 0)
+			fprintf(stderr,
+				"migrate_pages could not move %ld pages\n",
+				pages_not_moved);
+		else
+			data->migrations_completed++;
+
+		from = to;
+		to++;
+		if (to == nodes)
+			to = 0;
+
+		now = time(NULL);
+		if (((now - start_time) % interval_secs == 0) &&
+		    (now != last_update)) {
+			last_update = now;
+			fprintf(stderr,
+				"%lu seconds: Migrations attempted=%lu completed=%lu, "
+				"IPIs sent=%lu received=%lu, HLTs=%lu wakes=%lu\n",
+				now - start_time, data->migrations_attempted,
+				data->migrations_completed,
+				data->ipis_sent, *pipis_rcvd,
+				data->hlt_count, data->wake_count);
+
+			TEST_ASSERT(ipis_sent != data->ipis_sent &&
+				    hlt_count != data->hlt_count &&
+				    wake_count != data->wake_count,
+				    "IPI, HLT and wake count have not increased "
+				    "in the last %lu seconds. "
+				    "HLTer is likely hung.\n", interval_secs);
+
+			ipis_sent = data->ipis_sent;
+			hlt_count = data->hlt_count;
+			wake_count = data->wake_count;
+		}
+		usleep(delay_usecs);
+	}
+}
+
+void get_cmdline_args(int argc, char *argv[], int *run_secs,
+		      bool *migrate, int *delay_usecs)
+{
+	for (;;) {
+		int opt = getopt(argc, argv, "s:d:m");
+
+		if (opt == -1)
+			break;
+		switch (opt) {
+		case 's':
+			*run_secs = parse_size(optarg);
+			break;
+		case 'm':
+			*migrate = true;
+			break;
+		case 'd':
+			*delay_usecs = parse_size(optarg);
+			break;
+		default:
+			TEST_ASSERT(false,
+				    "Usage: -s <runtime seconds>. Default is %d seconds.\n"
+				    "-m adds calls to migrate_pages while vCPUs are running."
+				    " Default is no migrations.\n"
+				    "-d <delay microseconds> - delay between migrate_pages() calls."
+				    " Default is %d microseconds.\n",
+				    DEFAULT_RUN_SECS, DEFAULT_DELAY_USECS);
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int r;
+	int wait_secs;
+	const int max_halter_wait = 10;
+	int run_secs = 0;
+	int delay_usecs = 0;
+	struct test_data_page *data;
+	vm_vaddr_t test_data_page_vaddr;
+	bool migrate = false;
+	pthread_t threads[2];
+	struct thread_params params[2];
+	struct kvm_vm *vm;
+	uint64_t *pipis_rcvd;
+
+	get_cmdline_args(argc, argv, &run_secs, &migrate, &delay_usecs);
+	if (run_secs <= 0)
+		run_secs = DEFAULT_RUN_SECS;
+	if (delay_usecs <= 0)
+		delay_usecs = DEFAULT_DELAY_USECS;
+
+	vm = vm_create_default(HALTER_VCPU_ID, 0, halter_guest_code);
+	params[0].vm = vm;
+	params[1].vm = vm;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
+	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
+
+	vm_vcpu_add_default(vm, SENDER_VCPU_ID, sender_guest_code);
+
+	test_data_page_vaddr = vm_vaddr_alloc(vm, 0x1000, 0x1000, 0, 0);
+	data =
+	   (struct test_data_page *)addr_gva2hva(vm, test_data_page_vaddr);
+	memset(data, 0, sizeof(*data));
+	params[0].data = data;
+	params[1].data = data;
+
+	vcpu_args_set(vm, HALTER_VCPU_ID, 1, test_data_page_vaddr);
+	vcpu_args_set(vm, SENDER_VCPU_ID, 1, test_data_page_vaddr);
+
+	pipis_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ipis_rcvd);
+	params[0].pipis_rcvd = pipis_rcvd;
+	params[1].pipis_rcvd = pipis_rcvd;
+
+	/* Start halter vCPU thread and wait for it to execute first HLT. */
+	params[0].vcpu_id = HALTER_VCPU_ID;
+	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread started\n");
+
+	wait_secs = 0;
+	while ((wait_secs < max_halter_wait) && !data->hlt_count) {
+		sleep(1);
+		wait_secs++;
+	}
+
+	TEST_ASSERT(data->hlt_count,
+		    "Halter vCPU did not execute first HLT within %d seconds",
+		    max_halter_wait);
+
+	fprintf(stderr,
+		"Halter vCPU thread reported its APIC ID: %u after %d seconds.\n",
+		data->halter_apic_id, wait_secs);
+
+	params[1].vcpu_id = SENDER_VCPU_ID;
+	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
+	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
+
+	fprintf(stderr,
+		"IPI sender vCPU thread started. Letting vCPUs run for %d seconds.\n",
+		run_secs);
+
+	if (!migrate)
+		sleep(run_secs);
+	else
+		do_migrations(data, run_secs, delay_usecs, pipis_rcvd);
+
+	/*
+	 * Cancel threads and wait for them to stop.
+	 */
+	cancel_join_vcpu_thread(threads[0], HALTER_VCPU_ID);
+	cancel_join_vcpu_thread(threads[1], SENDER_VCPU_ID);
+
+	fprintf(stderr,
+		"Test successful after running for %d seconds.\n"
+		"Sending vCPU sent %lu IPIs to halting vCPU\n"
+		"Halting vCPU halted %lu times, woke %lu times, received %lu IPIs.\n"
+		"Halter APIC ID=%#x\n"
+		"Sender ICR value=%#x ICR2 value=%#x\n"
+		"Halter TPR=%#x PPR=%#x LVR=%#x\n"
+		"Migrations attempted: %lu\n"
+		"Migrations completed: %lu\n",
+		run_secs, data->ipis_sent,
+		data->hlt_count, data->wake_count, *pipis_rcvd,
+		data->halter_apic_id,
+		data->icr, data->icr2,
+		data->halter_tpr, data->halter_ppr, data->halter_lvr,
+		data->migrations_attempted, data->migrations_completed);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 


