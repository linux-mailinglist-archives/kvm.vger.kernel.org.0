Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F87B2F203D
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 21:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391471AbhAKT7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391461AbhAKT7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:59:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC1FC06179F
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=UZxsZCJj+A96sO4NsFY+p0+ZZOwM+RCEN/D65QmcJVM=; b=CqGDh9+M+4hcOi0D9qStwz7OWD
        Y3+FDvpLRDO9lTFOrCcHSseR75fvhkk8YHc/y6odWuEqCs5HRHBUoPasuj+glDspVGQkFvtoErCUo
        BeXUEOWX9mI6ELesB1aIWL2eic1eO6Q+laQFgW04hz1HXSlrazQDf4eqzAflHxNHE+XOI0VXd4pN8
        dikV3WtHpj/5LmN0REcITAHruNA643dJJtG2MiDYAefW3riSXugM/kuFcINdLFArRiV+sAuCVd6QR
        2KyaWuWNPHQAaZG5syVuQ0PD7HDBghgyoN2m3xy68nksr32LLRsnFES3XsB28QGK7AfGqNb5ZqxY/
        6ClFrS2w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jg-003kSa-56; Mon, 11 Jan 2021 19:57:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001I1-OM; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 14/16] KVM: x86: declare Xen HVM shared info capability and add test case
Date:   Mon, 11 Jan 2021 19:57:23 +0000
Message-Id: <20210111195725.4601-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
References: <20210111195725.4601-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Instead of adding a plethora of new KVM_CAP_XEN_FOO capabilities, just
add bits to the return value of KVM_CAP_XEN_HVM.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c                            |   3 +-
 include/uapi/linux/kvm.h                      |   3 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 194 ++++++++++++++++++
 4 files changed, 200 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f3f07b0265fc..25ef3b7ad49d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3765,7 +3765,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_XEN_HVM:
 		r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
-		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
+		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
+		    KVM_XEN_HVM_CONFIG_SHARED_INFO;
 		break;
 	case KVM_CAP_SYNC_REGS:
 		r = KVM_SYNC_X86_VALID_FIELDS;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0571a7bbb13b..e468f923e7dd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1150,6 +1150,7 @@ struct kvm_x86_mce {
 #ifdef KVM_CAP_XEN_HVM
 #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1585,6 +1586,7 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
@@ -1604,6 +1606,7 @@ struct kvm_xen_hvm_attr {
 	} u;
 };
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 44a4128b4061..0fc29726f777 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
new file mode 100644
index 000000000000..c8c696a6d41c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_vmcall_test
+ *
+ * Copyright © 2020 Amazon.com, Inc. or its affiliates.
+ *
+ * Xen shared_info / pvclock testing
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#include <stdint.h>
+#include <time.h>
+
+#define VCPU_ID		5
+
+#define SHINFO_REGION_GPA	0xc0000000ULL
+#define SHINFO_REGION_SLOT	10
+#define PAGE_SIZE		4096
+
+#define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
+#define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
+
+static struct kvm_vm *vm;
+
+#define XEN_HYPERCALL_MSR	0x40000000
+
+struct pvclock_vcpu_time_info {
+        u32   version;
+        u32   pad0;
+        u64   tsc_timestamp;
+        u64   system_time;
+        u32   tsc_to_system_mul;
+        s8    tsc_shift;
+        u8    flags;
+        u8    pad[2];
+} __attribute__((__packed__)); /* 32 bytes */
+
+struct pvclock_wall_clock {
+        u32   version;
+        u32   sec;
+        u32   nsec;
+} __attribute__((__packed__));
+
+struct vcpu_runstate_info {
+    uint32_t state;
+    uint64_t state_entry_time;
+    uint64_t time[4];
+};
+
+static void guest_code(void)
+{
+	struct vcpu_runstate_info *rs = (void *)RUNSTATE_ADDR;
+
+	/* Scribble on the runstate, just to make sure that... */
+	rs->state = 0x5a;
+
+	GUEST_SYNC(1);
+
+	/* ... it is being set to RUNSTATE_running */
+	GUEST_ASSERT(rs->state == 0);
+	GUEST_DONE();
+}
+
+static int cmp_timespec(struct timespec *a, struct timespec *b)
+{
+	if (a->tv_sec > b->tv_sec)
+		return 1;
+	else if (a->tv_sec < b->tv_sec)
+		return -1;
+	else if (a->tv_nsec > b->tv_nsec)
+		return 1;
+	else if (a->tv_nsec < b->tv_nsec)
+		return -1;
+	else
+		return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct timespec min_ts, max_ts, vm_ts;
+
+	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
+	      KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
+		print_skip("KVM_XEN_HVM_CONFIG_SHARED_INFO not available");
+		exit(KSFT_SKIP);
+	}
+
+	clock_gettime(CLOCK_REALTIME, &min_ts);
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/* Map a region for the shared_info page */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+                                    SHINFO_REGION_GPA, SHINFO_REGION_SLOT,
+				    2 * getpagesize(), 0);
+	virt_map(vm, SHINFO_REGION_GPA, SHINFO_REGION_GPA, 2, 0);
+
+	struct kvm_xen_hvm_attr lm = {
+		.type = KVM_XEN_ATTR_TYPE_LONG_MODE,
+		.u.long_mode = 1,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &lm);
+
+	struct kvm_xen_hvm_attr ha = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
+		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);
+
+	struct kvm_xen_hvm_attr vi = {
+		.type = KVM_XEN_ATTR_TYPE_VCPU_INFO,
+		.u.vcpu_attr.vcpu_id = VCPU_ID,
+		.u.vcpu_attr.gpa = SHINFO_REGION_GPA + 40,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &vi);
+
+	struct kvm_xen_hvm_attr pvclock = {
+		.type = KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO,
+		.u.vcpu_attr.vcpu_id = VCPU_ID,
+		.u.vcpu_attr.gpa = PVTIME_ADDR,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &pvclock);
+
+	struct kvm_xen_hvm_attr st = {
+		.type = KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE,
+		.u.vcpu_attr.vcpu_id = VCPU_ID,
+		.u.vcpu_attr.gpa = RUNSTATE_ADDR,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &st);
+
+	for (;;) {
+		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		}
+	}
+
+ done:
+	clock_gettime(CLOCK_REALTIME, &max_ts);
+
+	/*
+	 * Just a *really* basic check that things are being put in the
+	 * right place. The actual calculations are much the same for
+	 * Xen as they are for the KVM variants, so no need to check.
+	 */
+	struct pvclock_wall_clock *wc;
+	struct pvclock_vcpu_time_info *ti, *ti2;
+	struct vcpu_runstate_info *rs;
+
+	wc = addr_gva2hva(vm, SHINFO_REGION_GPA + 0xc00);
+	ti = addr_gva2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
+	ti2 = addr_gva2hva(vm, PVTIME_ADDR);
+	rs = addr_gva2hva(vm, RUNSTATE_ADDR);
+
+	vm_ts.tv_sec = wc->sec;
+	vm_ts.tv_nsec = wc->nsec;
+        TEST_ASSERT(wc->version && !(wc->version & 1),
+		    "Bad wallclock version %x", wc->version);
+	TEST_ASSERT(cmp_timespec(&min_ts, &vm_ts) <= 0, "VM time too old");
+	TEST_ASSERT(cmp_timespec(&max_ts, &vm_ts) >= 0, "VM time too new");
+
+	TEST_ASSERT(ti->version && !(ti->version & 1),
+		    "Bad time_info version %x", ti->version);
+	TEST_ASSERT(ti2->version && !(ti2->version & 1),
+		    "Bad time_info version %x", ti->version);
+
+	/* Check for RUNSTATE_blocked */
+	TEST_ASSERT(rs->state == 2, "Not RUNSTATE_blocked");
+	TEST_ASSERT(rs->time[0], "No RUNSTATE_running time");
+	TEST_ASSERT(rs->time[2], "No RUNSTATE_blocked time");
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.29.2

