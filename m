Return-Path: <kvm+bounces-63565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E23C6AEAD
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 24D093A48F2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48CC33C194;
	Tue, 18 Nov 2025 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsfC5bHr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCE93AA1AF
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485890; cv=none; b=BdlOyj9A1BXS+O72PLNsBD2nw7AsYg7W24VfnzezJxESm/FneoZ505AWZCN5/S8MikC9XiL8WKw/S95oaAXY+6DAGxUubSK5oVGzjSpyzcu4x5Hj1Bjvuzvl8yWNh47DwTeU+oy6goKWUXKC34kcOWtJ8iSkxyybjsZUMW/r4Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485890; c=relaxed/simple;
	bh=qvVV1+lOsJ9XDAaWR0KsZyjPvFBsVj16xVloKj+rpks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpiHk+6VVHhYHIOFgkeM1jESb4z5yWZfjWF0DbU3S2VNfl8Ov5Wo99Sva7nw1hyxY5GYyHRMKzTrtztWwSMINQEPw1U8p265/Ifljy9HBxufMZMJIT6jXVBbXXRsVRXiZKdAop/haaNqVSKxB93L40Xtlx0zpCx+/v4ZwrkI8U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsfC5bHr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so37249355e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485886; x=1764090686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWJX5jCMFbHZLR5KOshFREEhHWutM4XlgAjgK/LAhnI=;
        b=HsfC5bHr19AKGWd4ZkDVz/+ASyYJWcGaBCTwzu4oYkf3mNRAAixlcigv+UkDtmo7Yb
         sBtxMKZ7wYMR37MHu2YeKflOBwejv/Q1RqTS0wGlwnMmo9ZAsTo8hnTFb78OleA+Qxl1
         3lw6uV6PIIsVEyNsNdLNljei225UveobrZjJH/ZREgX4LAj47rOWDLMhIx55IRvrYy3R
         xh/d86smohExPBSnZt2+c1344MtD9llTzaS2me8UWOTsVzb+QVhTqFVUrMLEFYA3kFWQ
         EqVtdDyJtdKmFQbDkyFxu659FWR5V9vT22cGTAvJYhyef52oxciZDIF9X/k+bIb2MicP
         A2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485886; x=1764090686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NWJX5jCMFbHZLR5KOshFREEhHWutM4XlgAjgK/LAhnI=;
        b=LDEKkdjWDz2vbrvmoGe3eCQWChJVcwAodRR8/ztqBZkIMDgyLZ7n2F0cory0UWeLSs
         EcjvTu0sDSCvp9gdCL+2n+ABjG0/m3JxLDdyzSMjOFCoacqBsXZV7cWZC7CHP9GNH9fn
         eK3ue1HYyuLOY0BlZzhyaHqe3oYojssflqzuoYdF9v3HL13WZKycPAGRG8D9u8WdRBNa
         IlsdEDhVGV5cx7u308DCUwR8QgPLcS7uSFHGuejvgjGQs+p1AMi5uXyQzyUTzXUBZAaz
         ht3wmXfcQXWUC33JONxlSIP2qsu8gvbWW1qP+QgASvraZgar/RLHjTBxicPXA6tooQxb
         BRTQ==
X-Gm-Message-State: AOJu0YyY4cGYJbG7gfJLl8bTSPMbJjTd43/OHwK41wlvc4YlPBLATFDX
	kNLZ/RExm8sFYRi7025CT/p6tCgmvjEMgf7/HP66AG2dZrMUA01A14q3XAsi69jGHtgAvg==
X-Gm-Gg: ASbGncu4G82nG1q2uCm/RzyctnS1TjysPNnKhI8BYkjsKjhDBOasYiS+ByPjzsUlxWa
	b/raqrdYaOlCB9pyJR1Ak2y5AoDa/reWBwK3DgRviz8o0ahPWXyXjQfnWHi2yDxc0wkTCJNOI02
	QAYrvUHoqyfi9q+YdImyfwbYUbXFH4MfbH7OPXuGdigXE9PyuqEthHngqDgzo4E1KPFfER9RONR
	RHvFd4lg9acczyFk6p/R4XCxOWHcyEfok5Wi9QcpIjotY4bFppAAXj8DSVFVxF3JBWHM4I+Uqpu
	NdlCgRhIcE5b5c/U43pNx2gZEGVT+FgaPQ/BrnFQNAQnA81y7IoNN+YVLh8cCygce3N4wPFvXIP
	ld90V5xeJ6GJG5nDvbFH6NL8DfXcplmIANDgr9VtzSXzwqKzS26yblbNn/Fx2s2ukRLWGKpE5C7
	K7AuctBCaJcr+jqkZEiIueCNkbH3eloqfMyoHNKgfsodxoKwflSyGOdB7H6BxYveGrCbnL8fr+r
	4kX/KvBi+Bhaw9VUOjXJV3aR5M5rQMPRVYOzHwHMf8=
X-Google-Smtp-Source: AGHT+IGmF0t8cC54RXYx3nElgOyPxC4rRjVPWBt0TidoyrxK0/RKdst+w8+w6ACVcdI86E4zXZtnFg==
X-Received: by 2002:a05:600c:3104:b0:477:7f4a:44b0 with SMTP id 5b1f17b1804b1-4778fe89527mr172091815e9.33.1763485886067;
        Tue, 18 Nov 2025 09:11:26 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:25 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 05/10] KVM: selftests: Add nested VMX APIC cache invalidation test
Date: Tue, 18 Nov 2025 17:11:08 +0000
Message-ID: <20251118171113.363528-6-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Introduce selftest to verify nested VMX APIC virtualization page cache
invalidation and refresh mechanisms for pfncache implementation.

The test exercises the nested VMX APIC cache invalidation path through:

- L2 guest setup: creates a nested environment where L2 accesses the
  APIC access page that is cached by KVM using pfncache.

- Cache invalidation triggers: a separate update thread periodically
  invalidates the cached pages using either:
   - madvise(MADV_DONTNEED) to trigger MMU notifications.
   - vm_mem_region_move() to trigger memslot changes.

The test validates that:
- L2 can successfully access APIC page before and after invalidation.
- KVM properly handles cache refresh without guest-visible errors.
- Both MMU notification and memslot change invalidation paths work
  correctly.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/vmx_apic_update_test.c  | 302 ++++++++++++++++++
 2 files changed, 303 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_update_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24b..3431568d837e 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -137,6 +137,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/vmx_apic_update_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_update_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_update_test.c
new file mode 100644
index 000000000000..1b5b69627a01
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_update_test.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmx_apic_update_test
+ *
+ * Copyright (C) 2025, Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Test L2 guest APIC access page writes with concurrent MMU
+ * notification and memslot move updates.
+ */
+#include <pthread.h>
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#define VAPIC_GPA	0xc0000000
+#define VAPIC_SLOT	1
+
+#define L2_GUEST_STACK_SIZE 64
+
+#define L2_DELAY	(100)
+
+static void l2_guest_code(void)
+{
+	uint32_t *vapic_addr = (uint32_t *) (VAPIC_GPA + 0x80);
+
+	/* Unroll the loop to avoid any compiler side effect */
+
+	WRITE_ONCE(*vapic_addr, 1 << 0);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 1);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 2);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 3);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 4);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 5);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 1 << 6);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	WRITE_ONCE(*vapic_addr, 0);
+	udelay(msecs_to_usecs(L2_DELAY));
+
+	/* Exit to L1 */
+	vmcall();
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control, exit_reason;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* Enable APIC access */
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	control |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
+	vmwrite(APIC_ACCESS_ADDR, VAPIC_GPA);
+
+	GUEST_SYNC1(0);
+	GUEST_ASSERT(!vmlaunch());
+again:
+	exit_reason = vmreadz(VM_EXIT_REASON);
+	if (exit_reason == EXIT_REASON_APIC_ACCESS) {
+		uint64_t guest_rip = vmreadz(GUEST_RIP);
+		uint64_t instr_len = vmreadz(VM_EXIT_INSTRUCTION_LEN);
+
+		vmwrite(GUEST_RIP, guest_rip + instr_len);
+		GUEST_ASSERT(!vmresume());
+		goto again;
+	}
+
+	GUEST_SYNC1(exit_reason);
+	GUEST_ASSERT(exit_reason == EXIT_REASON_VMCALL);
+	GUEST_DONE();
+}
+
+static const char *progname;
+static int update_period_ms = L2_DELAY / 4;
+
+struct update_control {
+	pthread_mutex_t mutex;
+	pthread_cond_t start_cond;
+	struct kvm_vm *vm;
+	bool running;
+	bool started;
+	int updates;
+};
+
+static void wait_for_start_signal(struct update_control *ctrl)
+{
+	pthread_mutex_lock(&ctrl->mutex);
+	while (!ctrl->started)
+		pthread_cond_wait(&ctrl->start_cond, &ctrl->mutex);
+
+	pthread_mutex_unlock(&ctrl->mutex);
+	printf("%s: starting update\n", progname);
+}
+
+static bool is_running(struct update_control *ctrl)
+{
+	return READ_ONCE(ctrl->running);
+}
+
+static void set_running(struct update_control *ctrl, bool running)
+{
+	WRITE_ONCE(ctrl->running, running);
+}
+
+static void signal_thread_start(struct update_control *ctrl)
+{
+	pthread_mutex_lock(&ctrl->mutex);
+	if (!ctrl->started) {
+		ctrl->started = true;
+		pthread_cond_signal(&ctrl->start_cond);
+	}
+	pthread_mutex_unlock(&ctrl->mutex);
+}
+
+static void *update_madvise(void *arg)
+{
+	struct update_control *ctrl = arg;
+	void *hva;
+
+	wait_for_start_signal(ctrl);
+
+	hva = addr_gpa2hva(ctrl->vm, VAPIC_GPA);
+	memset(hva, 0x45, ctrl->vm->page_size);
+
+	while (is_running(ctrl)) {
+		usleep(update_period_ms * 1000);
+		madvise(hva, ctrl->vm->page_size, MADV_DONTNEED);
+		ctrl->updates++;
+	}
+
+	return NULL;
+}
+
+static void *update_move_memslot(void *arg)
+{
+	struct update_control *ctrl = arg;
+	uint64_t gpa = VAPIC_GPA;
+
+	wait_for_start_signal(ctrl);
+
+	while (is_running(ctrl)) {
+		usleep(update_period_ms * 1000);
+		gpa += 0x10000;
+		vm_mem_region_move(ctrl->vm, VAPIC_SLOT, gpa);
+		ctrl->updates++;
+	}
+
+	return NULL;
+}
+
+static void run(void * (*update)(void *), const char *name)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct vmx_pages *vmx;
+	struct update_control ctrl;
+	struct ucall uc;
+	vm_vaddr_t vmx_pages_gva;
+	pthread_t update_thread;
+	bool done = false;
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+
+	/* Allocate VMX pages */
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+
+	/* Allocate memory and create VAPIC memslot */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, VAPIC_GPA,
+				    VAPIC_SLOT, 1, 0);
+
+	/* Allocate guest page table */
+	virt_map(vm, VAPIC_GPA, VAPIC_GPA, 1);
+
+	/* Set up nested EPT */
+	prepare_eptp(vmx, vm, 0);
+	nested_map_memslot(vmx, vm, 0);
+	nested_map_memslot(vmx, vm, VAPIC_SLOT);
+	nested_map(vmx, vm, VAPIC_GPA, VAPIC_GPA, vm->page_size);
+
+	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+
+	pthread_mutex_init(&ctrl.mutex, NULL);
+	pthread_cond_init(&ctrl.start_cond, NULL);
+	ctrl.vm = vm;
+	ctrl.running = true;
+	ctrl.started = false;
+	ctrl.updates = 0;
+
+	pthread_create(&update_thread, NULL, update, &ctrl);
+
+	printf("%s: running %s (tsc_khz %lu)\n", progname, name, guest_tsc_khz);
+
+	while (!done) {
+		vcpu_run(vcpu);
+
+		switch (vcpu->run->exit_reason) {
+		case KVM_EXIT_IO:
+			switch (get_ucall(vcpu, &uc)) {
+			case UCALL_SYNC:
+				printf("%s: sync(%ld)\n", progname, uc.args[0]);
+				if (uc.args[0] == 0)
+					signal_thread_start(&ctrl);
+				break;
+			case UCALL_ABORT:
+				REPORT_GUEST_ASSERT(uc);
+				/* NOT REACHED */
+			case UCALL_DONE:
+				done = true;
+				break;
+			default:
+				TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
+			}
+			break;
+		case KVM_EXIT_MMIO:
+			/* Handle APIC MMIO access after memslot move */
+			printf
+			    ("%s: APIC MMIO access at 0x%llx (memslot move effect)\n",
+			     progname, vcpu->run->mmio.phys_addr);
+			break;
+		default:
+			TEST_FAIL("%s: Unexpected exit reason: %d (flags 0x%x)",
+				  progname,
+				  vcpu->run->exit_reason, vcpu->run->flags);
+		}
+	}
+
+	set_running(&ctrl, false);
+	if (!ctrl.started)
+		signal_thread_start(&ctrl);
+	pthread_join(update_thread, NULL);
+	printf("%s: completed with %d updates\n", progname, ctrl.updates);
+
+	pthread_mutex_destroy(&ctrl.mutex);
+	pthread_cond_destroy(&ctrl.start_cond);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	int opt_madvise = 0;
+	int opt_memslot_move = 0;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has_ept());
+
+	if (argc == 1) {
+		opt_madvise = 1;
+		opt_memslot_move = 1;
+	} else {
+		int opt;
+
+		while ((opt = getopt(argc, argv, "amp:")) != -1) {
+			switch (opt) {
+			case 'a':
+				opt_madvise = 1;
+				break;
+			case 'm':
+				opt_memslot_move = 1;
+				break;
+			case 'p':
+				update_period_ms = atoi(optarg);
+				break;
+			default:
+				exit(1);
+			}
+		}
+	}
+
+	TEST_ASSERT(opt_madvise
+		    || opt_memslot_move, "No update test configured");
+
+	progname = argv[0];
+
+	if (opt_madvise)
+		run(update_madvise, "madvise");
+
+	if (opt_memslot_move)
+		run(update_move_memslot, "move memslot");
+
+	return 0;
+}
-- 
2.43.0


