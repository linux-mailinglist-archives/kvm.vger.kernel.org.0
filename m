Return-Path: <kvm+bounces-1543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA5F7E94A4
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CA9280B97
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A936883A;
	Mon, 13 Nov 2023 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="HbDL//+3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863D6846B;
	Mon, 13 Nov 2023 02:25:16 +0000 (UTC)
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F049DF;
	Sun, 12 Nov 2023 18:25:08 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCv440z4zMq2H7;
	Mon, 13 Nov 2023 02:25:04 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCv31cKszMppt7;
	Mon, 13 Nov 2023 03:25:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842304;
	bh=qU7rpwZb8Bl+xuVDwtq6MKJ75S7Uo4UAc0PUDjw5xlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbDL//+3ATCwPmW6FeNdrIH7tZIwaMnw+QS1qdZf+B2mnT/MKQm4aP+mx66UUcjaD
	 hsK1zTShrWzEU7FyzuuXAFeXbZ2X6WXdUpzO09fScu+mFKm7CXVRlh5HLUvFpTFOab
	 J5+cWZjh90MaulzQheCaiQUYvIq2/sNhJR0yOd08=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 19/19] virt: Add Heki KUnit tests
Date: Sun, 12 Nov 2023 21:23:26 -0500
Message-ID: <20231113022326.24388-20-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

This adds a new CONFIG_HEKI_TEST option to run tests at boot. Because we
use some symbols not exported to modules (e.g., kernel_set_to_readonly)
this could not work as modules.

To run these tests, we need to boot the kernel with the heki_test=N boot
argument with N selecting a specific test:
1. heki_test_cr_disable_smep: Check CR pinning and try to disable SMEP.
2. heki_test_write_to_const: Check .rodata (const) protection.
3. heki_test_write_to_ro_after_init: Check __ro_after_init protection.
4. heki_test_exec: Check non-executable kernel memory.

This way to select tests should not be required when the kernel will
properly handle the triggered synthetic page faults.  For now, these
page faults make the kernel loop.

All these tests temporarily disable the related kernel self-protections
and should then failed if Heki doesn't protect the kernel.  They are
verbose to make it easier to understand what is going on.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---

Changes since v1:
* Move all tests to virt/heki/tests.c
---
 include/linux/heki.h |   1 +
 virt/heki/Kconfig    |  12 +++
 virt/heki/Makefile   |   1 +
 virt/heki/main.c     |   6 +-
 virt/heki/tests.c    | 207 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 virt/heki/tests.c

diff --git a/include/linux/heki.h b/include/linux/heki.h
index 306bcec7ae92..9e2cf0051ab0 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -149,6 +149,7 @@ void heki_protect(unsigned long va, unsigned long end);
 void heki_add_pa(struct heki_args *args, phys_addr_t pa,
 		 unsigned long permissions);
 void heki_apply_permissions(struct heki_args *args);
+void heki_run_test(void);
 
 /* Arch-specific functions. */
 void heki_arch_early_init(void);
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 9bde84cd759e..fa814a921bb0 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -28,3 +28,15 @@ config HYPERVISOR_SUPPORTS_HEKI
 	  A hypervisor should select this when it can successfully build
 	  and run with CONFIG_HEKI. That is, it should provide all of the
 	  hypervisor support required for the Heki feature.
+
+config HEKI_TEST
+	bool "Tests for Heki" if !KUNIT_ALL_TESTS
+	depends on HEKI && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Run Heki tests at runtime according to the heki_test=N boot
+	  parameter, with N identifying the test to run (between 1 and 4).
+
+	  Before launching the init process, the system might not respond
+	  because of unhandled kernel page fault.  This will be fixed in a
+	  next patch series.
diff --git a/virt/heki/Makefile b/virt/heki/Makefile
index 564f92faa9d8..a66cd0ba140b 100644
--- a/virt/heki/Makefile
+++ b/virt/heki/Makefile
@@ -3,3 +3,4 @@
 obj-y += main.o
 obj-y += walk.o
 obj-y += counters.o
+obj-y += tests.o
diff --git a/virt/heki/main.c b/virt/heki/main.c
index 5629334112e7..ce9984231996 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -51,8 +51,10 @@ void heki_late_init(void)
 {
 	struct heki_hypervisor *hypervisor = heki.hypervisor;
 
-	if (!heki.counters)
+	if (!heki.counters) {
+		heki_run_test();
 		return;
+	}
 
 	/* Locks control registers so a compromised guest cannot change them. */
 	if (WARN_ON(hypervisor->lock_crs()))
@@ -61,6 +63,8 @@ void heki_late_init(void)
 	pr_warn("Control registers locked\n");
 
 	heki_arch_late_init();
+
+	heki_run_test();
 }
 
 /*
diff --git a/virt/heki/tests.c b/virt/heki/tests.c
new file mode 100644
index 000000000000..6e6542b257f1
--- /dev/null
+++ b/virt/heki/tests.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Common code
+ *
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#include <linux/kvm_host.h>
+#include <kunit/test.h>
+#include <linux/cache.h>
+#include <linux/heki.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
+#include <linux/set_memory.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include "common.h"
+
+#ifdef CONFIG_HEKI_TEST
+
+/* Heki test data */
+
+/* Takes two pages to not change permission of other read-only pages. */
+const char heki_test_const_buf[PAGE_SIZE * 2] = {};
+char heki_test_ro_after_init_buf[PAGE_SIZE * 2] __ro_after_init = {};
+
+long heki_test_exec_data(long);
+void _test_exec_data_end(void);
+
+/* Used to test ROP execution against the .rodata section. */
+/* clang-format off */
+asm(
+".pushsection .rodata;" // NOT .text section
+".global heki_test_exec_data;"
+".type heki_test_exec_data, @function;"
+"heki_test_exec_data:"
+ASM_ENDBR
+"movq %rdi, %rax;"
+"inc %rax;"
+ASM_RET
+".size heki_test_exec_data, .-heki_test_exec_data;"
+"_test_exec_data_end:"
+".popsection");
+/* clang-format on */
+
+static void heki_test_cr_disable_smep(struct kunit *test)
+{
+	unsigned long cr4;
+
+	/* SMEP should be initially enabled. */
+	KUNIT_ASSERT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+
+	kunit_warn(test,
+		   "Starting control register pinning tests with SMEP check\n");
+
+	/*
+	 * Trying to disable SMEP, bypassing kernel self-protection by not
+	 * using cr4_clear_bits(X86_CR4_SMEP).
+	 */
+	cr4 = __read_cr4() & ~X86_CR4_SMEP;
+	asm volatile("mov %0,%%cr4" : "+r"(cr4) : : "memory");
+
+	/* SMEP should still be enabled. */
+	KUNIT_ASSERT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+}
+
+static inline void print_addr(struct kunit *test, const char *const buf_name,
+			      void *const buf)
+{
+	const pte_t pte = *virt_to_kpte((unsigned long)buf);
+	const phys_addr_t paddr = slow_virt_to_phys(buf);
+	bool present = pte_flags(pte) & (_PAGE_PRESENT);
+	bool accessible = pte_accessible(&init_mm, pte);
+
+	kunit_warn(
+		test,
+		"%s vaddr:%llx paddr:%llx exec:%d write:%d present:%d accessible:%d\n",
+		buf_name, (unsigned long long)buf, paddr, !!pte_exec(pte),
+		!!pte_write(pte), present, accessible);
+}
+
+extern int kernel_set_to_readonly;
+
+static void heki_test_write_to_rodata(struct kunit *test,
+				      const char *const buf_name,
+				      char *const ro_buf)
+{
+	print_addr(test, buf_name, (void *)ro_buf);
+	KUNIT_EXPECT_EQ(test, 0, *ro_buf);
+
+	kunit_warn(
+		test,
+		"Bypassing kernel self-protection: mark memory as writable\n");
+	kernel_set_to_readonly = 0;
+	/*
+	 * Removes execute permission that might be set by bugdoor-exec,
+	 * because change_page_attr_clear() is not use by set_memory_rw().
+	 * This is required since commit 652c5bf380ad ("x86/mm: Refuse W^X
+	 * violations").
+	 */
+	KUNIT_ASSERT_FALSE(test, set_memory_nx((unsigned long)PTR_ALIGN_DOWN(
+						       ro_buf, PAGE_SIZE),
+					       1));
+	KUNIT_ASSERT_FALSE(test, set_memory_rw((unsigned long)PTR_ALIGN_DOWN(
+						       ro_buf, PAGE_SIZE),
+					       1));
+	kernel_set_to_readonly = 1;
+
+	kunit_warn(test, "Trying memory write\n");
+	*ro_buf = 0x11;
+	KUNIT_EXPECT_EQ(test, 0, *ro_buf);
+	kunit_warn(test, "New content: 0x%02x\n", *ro_buf);
+}
+
+static void heki_test_write_to_const(struct kunit *test)
+{
+	heki_test_write_to_rodata(test, "const_buf",
+				  (void *)heki_test_const_buf);
+}
+
+static void heki_test_write_to_ro_after_init(struct kunit *test)
+{
+	heki_test_write_to_rodata(test, "ro_after_init_buf",
+				  (void *)heki_test_ro_after_init_buf);
+}
+
+typedef long test_exec_t(long);
+
+static void heki_test_exec(struct kunit *test)
+{
+	const size_t exec_size = 7;
+	unsigned long nx_page_start = (unsigned long)PTR_ALIGN_DOWN(
+		(const void *const)heki_test_exec_data, PAGE_SIZE);
+	unsigned long nx_page_end = (unsigned long)PTR_ALIGN(
+		(const void *const)heki_test_exec_data + exec_size, PAGE_SIZE);
+	test_exec_t *exec = (test_exec_t *)heki_test_exec_data;
+	long ret;
+
+	/* Starting non-executable memory tests. */
+	print_addr(test, "test_exec_data", heki_test_exec_data);
+
+	kunit_warn(
+		test,
+		"Bypassing kernel-self protection: mark memory as executable\n");
+	kernel_set_to_readonly = 0;
+	KUNIT_ASSERT_FALSE(test,
+			   set_memory_rox(nx_page_start,
+					  PFN_UP(nx_page_end - nx_page_start)));
+	kernel_set_to_readonly = 1;
+
+	kunit_warn(
+		test,
+		"Trying to execute data (ROP) in (initially) non-executable memory\n");
+	ret = exec(3);
+
+	/* This should not be reached because of the uncaught page fault. */
+	KUNIT_EXPECT_EQ(test, 3, ret);
+	kunit_warn(test, "Result of execution: 3 + 1 = %ld\n", ret);
+}
+
+const struct kunit_case heki_test_cases[] = {
+	KUNIT_CASE(heki_test_cr_disable_smep),
+	KUNIT_CASE(heki_test_write_to_const),
+	KUNIT_CASE(heki_test_write_to_ro_after_init),
+	KUNIT_CASE(heki_test_exec),
+	{}
+};
+
+static unsigned long heki_test __ro_after_init;
+
+static int __init parse_heki_test_config(char *str)
+{
+	if (kstrtoul(str, 10, &heki_test) ||
+	    heki_test > (ARRAY_SIZE(heki_test_cases) - 1))
+		pr_warn("Invalid option string for heki_test: '%s'\n", str);
+	return 1;
+}
+
+__setup("heki_test=", parse_heki_test_config);
+
+void heki_run_test(void)
+{
+	struct kunit_case heki_test_case[2] = {};
+	struct kunit_suite heki_test_suite = {
+		.name = "heki",
+		.test_cases = heki_test_case,
+	};
+	struct kunit_suite *const test_suite = &heki_test_suite;
+
+	if (!kunit_enabled() || heki_test == 0 ||
+	    heki_test >= ARRAY_SIZE(heki_test_cases))
+		return;
+
+	pr_warn("Running test #%lu\n", heki_test);
+	heki_test_case[0] = heki_test_cases[heki_test - 1];
+	__kunit_test_suites_init(&test_suite, 1);
+}
+
+#else /* CONFIG_HEKI_TEST */
+
+void heki_run_test(void)
+{
+}
+
+#endif /* CONFIG_HEKI_TEST */
-- 
2.42.1


