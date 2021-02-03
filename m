Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928D230DD7F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhBCPCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhBCPCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20ECC061797
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=9TWJ7Lvcpur4v5MGpd65YQExu+/eRFl/hisbDGZ44t8=; b=A/4QuFcuhOkE96SioPoFqMyLgl
        jE6KX/J9itGBHlkVvrMne0mvlHIiyCrKzKMMC6emTsFvpsjCnZ/SMw/4WW0USz/iVF9CHETbmfzxj
        u28ULJifJxC1o66hUwxqbd6+dLTXeJeomCyWabGaXVA1TYPoDTOQvgv7PbxQWCq3FzM1HkTJXHk50
        m86GaU9MwPAMun40Fn0ycMQa2YwPmD1WTo83GZZ3VDW9tgyVBScWTfDUAREH1ynt0AgTfoPsMjl0w
        7BGpLwGpzO9FDgk9HP7a6/ShKSnwMfn9vBctgLVYQ4STUnmmKjVptMpC/h1yVoFfUW544PhdmXMIG
        NHnGWXUg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015s-KD; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003rf0-H2; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 18/19] KVM: x86: declare Xen HVM shared info capability and add test case
Date:   Wed,  3 Feb 2021 15:01:13 +0000
Message-Id: <20210203150114.920335-19-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
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
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 197 ++++++++++++++++++
 4 files changed, 203 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdcc8abf2216..6dc0376beac5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3761,7 +3761,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index c828c94dbe8b..c61c49bbe0aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1150,6 +1150,7 @@ struct kvm_x86_mce {
 #ifdef KVM_CAP_XEN_HVM
 #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1602,6 +1603,7 @@ struct kvm_xen_hvm_attr {
 	} u;
 };
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
@@ -1619,6 +1621,7 @@ struct kvm_xen_vcpu_attr {
 	} u;
 };
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
 
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
index 000000000000..517dfad2b2a6
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -0,0 +1,197 @@
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
+	struct kvm_xen_hvm_config hvmc = {
+		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+		.msr = XEN_HYPERCALL_MSR,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
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
+	struct kvm_xen_vcpu_attr vi = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
+		.u.gpa = SHINFO_REGION_GPA + 40,
+	};
+	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &vi);
+
+	struct kvm_xen_vcpu_attr pvclock = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO,
+		.u.gpa = PVTIME_ADDR,
+	};
+	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &pvclock);
+
+	struct kvm_xen_vcpu_attr st = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE,
+		.u.gpa = RUNSTATE_ADDR,
+	};
+	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
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

