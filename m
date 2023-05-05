Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5626F85C0
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjEEPaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjEEP3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:41 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FF9A5F4
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:33 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZDH0FZXzMqc7P;
        Fri,  5 May 2023 17:22:07 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZDG2bp6zMpxBc;
        Fri,  5 May 2023 17:22:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300126;
        bh=6hEUXV1Yu+QqE06q6YV92ksgcTE4SSVMGFp/YRlUSqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCom6GYQLGlk2nCbcclR8AZKUkW0AJpZFC6wR92gff0rbAnNjJlFfzBd5J+3y++84
         WAx+LLa8CAjewu98goOyt+2vh84ogydmCURfKSQ02P+jr2VYlfAmiT9Knsjn08r/LT
         Tng2aFdb73PL8bp/dTy6vPMFTznPlq63+NzYf8sI=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v1 9/9] virt: Add Heki KUnit tests
Date:   Fri,  5 May 2023 17:20:46 +0200
Message-Id: <20230505152046.6575-10-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a new CONFIG_HEKI_TEST option to run tests at boot.  Indeed,
because this patch series forbids the loading of kernel modules after
the boot, we need to make built-in tests.  Furthermore, because we use
some symbols not exported to modules (e.g., kernel_set_to_readonly) this
could not work as modules.

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
Link: https://lore.kernel.org/r/20230505152046.6575-10-mic@digikod.net
---
 virt/heki/Kconfig |  12 +++
 virt/heki/heki.c  | 194 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 205 insertions(+), 1 deletion(-)

diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 96f18ce03013..806981f2b22d 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -27,3 +27,15 @@ config HYPERVISOR_SUPPORTS_HEKI
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
diff --git a/virt/heki/heki.c b/virt/heki/heki.c
index 142b5dc98a2f..361e7734e950 100644
--- a/virt/heki/heki.c
+++ b/virt/heki/heki.c
@@ -5,11 +5,13 @@
  * Copyright © 2023 Microsoft Corporation
  */
 
+#include <kunit/test.h>
 #include <linux/cache.h>
 #include <linux/heki.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
+#include <linux/set_memory.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
@@ -78,13 +80,201 @@ void __init heki_early_init(void)
 	heki_arch_init();
 }
 
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
+static void heki_run_test(void)
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
+static inline void heki_run_test(void)
+{
+}
+
+#endif /* CONFIG_HEKI_TEST */
+
 void heki_late_init(void)
 {
 	struct heki_hypervisor *hypervisor = heki.hypervisor;
 	int ret;
 
 	if (!heki_enabled)
-		return;
+		return heki_run_test();
 
 	if (!heki.static_ranges) {
 		pr_warn("Architecture did not initialize static ranges\n");
@@ -113,6 +303,8 @@ void heki_late_init(void)
 		goto out;
 	pr_warn("Control registers locked\n");
 
+	heki_run_test();
+
 out:
 	heki_free_pa_ranges(heki.static_ranges, heki.num_static_ranges);
 	heki.static_ranges = NULL;
-- 
2.40.1

