Return-Path: <kvm+bounces-4146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3DFB80E441
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83E36B21ADD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4172168B1;
	Tue, 12 Dec 2023 06:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3RO/5jr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7662C4
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 22:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702362467; x=1733898467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KPmGUAS7DyPbFFmy9RdDyGE70f5Rua/fmWk3Poz93a0=;
  b=Y3RO/5jrG4DUYZqG2BKWa2p8Cg57flwZQ/ZAw9x7xnhIaYn1ILDk4nhx
   hyr73ZfsDran2/hMeY5O6Ly1mK+6gp+iliytwMoQrTm1XBF/vTy4uUgyL
   YlUgSaqf5u1nNW3aV4ErZcfcSjBujuRnhVcrG98kaKf1shfrKnvQwKbyG
   s8i57d5TYRXNo8p9YeQHbwPsDKBkM2oHOwH6i8I5x2q3s+2LVpamvD8V8
   8bjqf3yER/oVkEDRB7qss4fLrvxkMnrWGGCGbB1l87z7KV+yy9RhzKl3k
   jz5NsOJZ2EKshS9PVw4Y/m4QyzNSgiMWrGr5mc7b8kIxotNLUVY6YhHCA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8128901"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="8128901"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 22:27:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="723109031"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="723109031"
Received: from spr-bkc-pc.jf.intel.com ([10.165.56.234])
  by orsmga003.jf.intel.com with ESMTP; 11 Dec 2023 22:27:47 -0800
From: Dan Wu <dan1.wu@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	dan1.wu@intel.com
Subject: [kvm-unit-tests PATCH v1 2/3] x86: Add async page fault int test
Date: Tue, 12 Dec 2023 14:27:07 +0800
Message-Id: <20231212062708.16509-3-dan1.wu@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231212062708.16509-1-dan1.wu@intel.com>
References: <20231212062708.16509-1-dan1.wu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM switched to use interrupt for 'page ready' APF event since Linux v5.10 and
the legacy mechanism using #PF was deprecated. Add a new test for interrupt
based 'page ready' APF event delivery.

Signed-off-by: Dan Wu <dan1.wu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
The test is based on asyncpf.c and simplifies implementation.
---
 ci/cirrus-ci-fedora.yml |   1 +
 lib/x86/processor.h     |   6 ++
 x86/Makefile.common     |   3 +-
 x86/asyncpf_int.c       | 127 ++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg       |   4 ++
 5 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 x86/asyncpf_int.c

diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index 918c9a36..52cb10c6 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -22,6 +22,7 @@ fedora_task:
     - ./run_tests.sh
         access
         asyncpf
+        asyncpf_int
         debug
         emulator
         ept
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..1a0f1243 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -263,6 +263,12 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 
+/*
+ * KVM defined leafs
+ */
+#define	KVM_FEATURE_ASYNC_PF		(CPUID(0x40000001, 0, EAX, 4))
+#define	KVM_FEATURE_ASYNC_PF_INT	(CPUID(0x40000001, 0, EAX, 14))
+
 /*
  * Extended Leafs, a.k.a. AMD defined
  */
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a557..c4b309e3 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -90,7 +90,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/emulator.$(exe) \
                $(TEST_DIR)/eventinj.$(exe) \
                $(TEST_DIR)/smap.$(exe) \
-               $(TEST_DIR)/umip.$(exe)
+               $(TEST_DIR)/umip.$(exe) \
+               $(TEST_DIR)/asyncpf_int.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
diff --git a/x86/asyncpf_int.c b/x86/asyncpf_int.c
new file mode 100644
index 00000000..84268f6b
--- /dev/null
+++ b/x86/asyncpf_int.c
@@ -0,0 +1,127 @@
+/*
+ * Async PF Int test. For the test to actually do anything it needs to be started
+ * in memory cgroup with 512M of memory and with more than 1G memory provided
+ * to the guest.
+ *
+ * To identify the cgroup version on Linux:
+ * stat -fc %T /sys/fs/cgroup/
+ *
+ * If the output is tmpfs, your system is using cgroup v1:
+ * To create cgroup do as root:
+ * mkdir /dev/cgroup
+ * mount -t cgroup none -omemory /dev/cgroup
+ * chmod a+rxw /dev/cgroup/
+ * From a shell you will start qemu from:
+ * mkdir /dev/cgroup/1
+ * echo $$ >  /dev/cgroup/1/tasks
+ * echo 512M > /dev/cgroup/1/memory.limit_in_bytes
+ *
+ * If the output is cgroup2fs, your system is using cgroup v2:
+ * mkdir /sys/fs/cgroup/cg1
+ * echo $$ >  /sys/fs/cgroup/cg1/cgroup.procs
+ * echo 512M > /sys/fs/cgroup/cg1/memory.max
+ *
+ */
+#include "x86/processor.h"
+#include "x86/apic.h"
+#include "x86/isr.h"
+#include "x86/vm.h"
+#include "alloc.h"
+#include "vmalloc.h"
+#include "asyncpf.h"
+
+struct kvm_vcpu_pv_apf_data apf_reason;
+
+char *buf;
+void* virt;
+volatile uint64_t  i;
+volatile uint64_t phys;
+volatile uint32_t saved_token;
+volatile uint32_t asyncpf_num;
+
+static inline uint32_t get_and_clear_apf_reason(void)
+{
+	uint32_t r = apf_reason.flags;
+	apf_reason.flags = 0;
+	return r;
+}
+
+static void handle_interrupt(isr_regs_t *regs)
+{
+	uint32_t apf_token = apf_reason.token;
+
+	apf_reason.token = 0;
+	wrmsr(MSR_KVM_ASYNC_PF_ACK, 1);
+
+	if (apf_token == 0xffffffff) {
+		report_pass("Wakeup all, got token 0x%x", apf_token);
+	} else if (apf_token == saved_token) {
+		asyncpf_num++;
+		install_pte(phys_to_virt(read_cr3()), 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
+		phys = 0;
+	} else {
+		report_fail("unexpected async pf int token 0x%x", apf_token);
+	}
+
+	eoi();
+}
+
+static void handle_pf(struct ex_regs *r)
+{
+	virt = (void*)((ulong)(buf+i) & ~(PAGE_SIZE-1));
+	uint32_t reason = get_and_clear_apf_reason();
+	switch (reason) {
+	case 0:
+		report_fail("unexpected #PF at %#lx", read_cr2());
+		exit(report_summary());
+	case KVM_PV_REASON_PAGE_NOT_PRESENT:
+		phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
+		install_pte(phys_to_virt(read_cr3()), 1, virt, phys, 0);
+		write_cr3(read_cr3());
+		saved_token = read_cr2();
+		while (phys) {
+			safe_halt(); /* enables irq */
+		}
+		break;
+	default:
+		report_fail("unexpected async pf with reason 0x%x", reason);
+		exit(report_summary());
+	}
+}
+
+#define MEM (1ull*1024*1024*1024)
+
+int main(int ac, char **av)
+{
+	if (!this_cpu_has(KVM_FEATURE_ASYNC_PF)) {
+		report_skip("KVM_FEATURE_ASYNC_PF is not supported\n");
+		return report_summary();
+	}
+
+	if (!this_cpu_has(KVM_FEATURE_ASYNC_PF_INT)) {
+		report_skip("KVM_FEATURE_ASYNC_PF_INT is not supported\n");
+		return report_summary();
+	}
+
+	setup_vm();
+
+	handle_exception(PF_VECTOR, handle_pf);
+	handle_irq(HYPERVISOR_CALLBACK_VECTOR, handle_interrupt);
+	memset(&apf_reason, 0, sizeof(apf_reason));
+
+	wrmsr(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
+	wrmsr(MSR_KVM_ASYNC_PF_EN, virt_to_phys((void*)&apf_reason) |
+		KVM_ASYNC_PF_SEND_ALWAYS | KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT);
+
+	buf = malloc(MEM);
+	sti();
+
+	/* access a lot of memory to make host swap it out */
+	for (i = 0; i < MEM; i += 4096)
+		buf[i] = 1;
+
+	cli();
+	report(asyncpf_num > 0, "get %d async pf events ('page not present' #PF event with matched "
+		"'page ready' interrupt event )", asyncpf_num);
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449..8735ba34 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -174,6 +174,10 @@ extra_params = -cpu max
 file = asyncpf.flat
 extra_params = -m 2048
 
+[asyncpf_int]
+file = asyncpf_int.flat
+extra_params = -cpu host -m 2048
+
 [emulator]
 file = emulator.flat
 
-- 
2.39.3


