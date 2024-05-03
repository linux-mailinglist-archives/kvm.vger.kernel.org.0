Return-Path: <kvm+bounces-16506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D53128BAD9D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62CD41F22C53
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C20F153BE3;
	Fri,  3 May 2024 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="KMEY6pkE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A26E155343;
	Fri,  3 May 2024 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714742370; cv=none; b=rh/g61wXJXQJ4zinirHsyABxbWs17wQCA4/cyAx65hrp8qCxRwaX8lFQ+nkHQztIXFmf3D84hD3cOPKYwD4oTCNvdEwB93X8BtaCCMchRtMTjkAMZNxNMa0cM3PLemYxWi0Jf3ScIdYwEoi+V6Us/I7DPKb+odAzszubOarrjeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714742370; c=relaxed/simple;
	bh=4ONNBgWSam9aJRjdro/4dfXdqBvgud7e8GDkEnOey/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CueLehDVkfwsGk7YgmNf+/Va3BwBpkDtWiHuM+PE55uQHSKYBlv2o38oWojo9wIy2EmE6J+cms2tzf/l+llpJwP/n235yXTw+IJVmd3rTURIaP6pJNLAcGeFaJ3bhng79wfdUi2W8/ze4AsnqPMZ0g2+lVzD4QS+wQBVEG+tS38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=KMEY6pkE; arc=none smtp.client-ip=84.16.66.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VWBGk08rZzRxX;
	Fri,  3 May 2024 15:19:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714742365;
	bh=4ONNBgWSam9aJRjdro/4dfXdqBvgud7e8GDkEnOey/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMEY6pkEAKgoExfEmKVQNyCUEruknH1ap7Ou5Y419jIaRi8bmkoHU2rC0/FMv7d7x
	 rFR+BO0giuToCc4a3wUUdcvtmQ+cooljaMVQXO/XQSIZria32QbPa/X8LojG8X9+C1
	 h838ru/DHL68SkgW/jHR0XIi48e+6J+Z2qvxBa4k=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4VWBGj1GSJzcWL;
	Fri,  3 May 2024 15:19:25 +0200 (CEST)
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
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Alexander Graf <graf@amazon.com>,
	Angelina Vu <angelinavu@linux.microsoft.com>,
	Anna Trikalinou <atrikalinou@microsoft.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
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
Subject: [RFC PATCH v3 5/5] virt: Add Heki KUnit tests
Date: Fri,  3 May 2024 15:19:10 +0200
Message-ID: <20240503131910.307630-6-mic@digikod.net>
In-Reply-To: <20240503131910.307630-1-mic@digikod.net>
References: <20240503131910.307630-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

The new CONFIG_HEKI_KUNIT_TEST option enables to run tests in a a kernel
module.  The minimal required configuration is listed in the
virt/heki-test/.kunitconfig file.

test_cr_disable_smep checks control-register pinning by trying to
disable SMEP.  This test should then failed on a non-protected kernel,
and only succeed with a kernel protected by Heki.

This test doesn't rely on native_write_cr4() because of the
cr4_pinned_mask hardening, which means that this *test* module loads a
valid kernel code to arbitrary change CR4.  This simulate an attack
scenario where an attaker would use ROP to directly jump to the related
cr4 instruction.

As for any KUnit test, the kernel is tainted with TAINT_TEST when the
test is executed.

It is interesting to create new KUnit tests instead of extending KVM's
Kselftests because Heki is design to be hypervisor-agnostic, it relies
on a set of hypercalls (for KVM or others), and we also want to test
kernel's configuration (actual pinned CR).  However, new KVM's
Kselftests would be useful to test KVM's interface with the host.

When using Qemu, we need to pass the following arguments: -cpu host
-enable-kvm

For now, it is not possible to run these tests as built-in but we are
working on that [1].  If tests are built-in anyway, they will just be
skipped because Heki would not be enabled.

Run Heki tests with:
  insmod heki-test.ko

  KTAP version 1
  1..1
      KTAP version 1
      # Subtest: heki_x86
      # module: heki_test
      1..1
      ok 1 test_cr_disable_smep
  ok 1 heki_x86

Link: https://lore.kernel.org/r/20240229170409.365386-2-mic@digikod.net [1]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240503131910.307630-6-mic@digikod.net
---

Changes since v2:
* Make tests standalone (e.g. don't depends on CONFIG_HEKI).
* Enable to create a test kernel module.
* Don't rely on private kernel symbols.
* Handle GP fault for CR-pinning test case.
* Rename option to CONFIG_HEKI_KUNIT_TEST.
* Add the list of required kernel options.
* Move tests to virt/heki-test/ [FIXME]
* Only keep CR pinning test.
* Restore previous state (with SMEP enabled).
* Add a Kconfig menu for Heki and update the description.
* Skip tests if Heki is not protecting the running kernel.

Changes since v1:
* Move all tests to virt/heki/tests.c
---
 include/linux/heki.h   |   1 +
 virt/heki/.kunitconfig |   9 ++++
 virt/heki/Kconfig      |  12 +++++
 virt/heki/Makefile     |   1 +
 virt/heki/heki-test.c  | 114 +++++++++++++++++++++++++++++++++++++++++
 virt/heki/main.c       |  10 ++++
 6 files changed, 147 insertions(+)
 create mode 100644 virt/heki/.kunitconfig
 create mode 100644 virt/heki/heki-test.c

diff --git a/include/linux/heki.h b/include/linux/heki.h
index 96ccb17657e5..3294c4d583e5 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -35,6 +35,7 @@ struct heki {
 
 extern struct heki heki;
 extern bool heki_enabled;
+extern bool heki_enforcing;
 
 void heki_early_init(void);
 void heki_late_init(void);
diff --git a/virt/heki/.kunitconfig b/virt/heki/.kunitconfig
new file mode 100644
index 000000000000..ad4454800579
--- /dev/null
+++ b/virt/heki/.kunitconfig
@@ -0,0 +1,9 @@
+CONFIG_HEKI=y
+CONFIG_HEKI_KUNIT_TEST=m
+CONFIG_HEKI_MENU=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_HYPERVISOR_GUEST=y
+CONFIG_KUNIT=y
+CONFIG_KVM=y
+CONFIG_KVM_GUEST=y
+CONFIG_PARAVIRT=y
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 0c764e342f48..18895a81a9af 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -28,4 +28,16 @@ config HEKI
 	  This feature is helpful in maintaining guest virtual machine security
 	  even after the guest kernel has been compromised.
 
+config HEKI_KUNIT_TEST
+	tristate "KUnit tests for Heki" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on X86
+	default KUNIT_ALL_TESTS
+	help
+	  Build KUnit tests for Landlock.
+
+	  See the KUnit documentation in Documentation/dev-tools/kunit
+
+	  If you are unsure how to answer this question, answer N.
+
 endif
diff --git a/virt/heki/Makefile b/virt/heki/Makefile
index 8b10e73a154b..7133545eb5ae 100644
--- a/virt/heki/Makefile
+++ b/virt/heki/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_HEKI) += main.o
+obj-$(CONFIG_HEKI_KUNIT_TEST) += heki-test.o
diff --git a/virt/heki/heki-test.c b/virt/heki/heki-test.c
new file mode 100644
index 000000000000..b4e11c21ac5d
--- /dev/null
+++ b/virt/heki/heki-test.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Tests
+ *
+ * Copyright © 2023-2024 Microsoft Corporation
+ */
+
+#include <asm/asm.h>
+#include <asm/processor.h>
+#include <asm/special_insns.h>
+#include <kunit/test.h>
+#include <linux/heki.h>
+
+/* Returns true on error (i.e. GP fault), false otherwise. */
+static __always_inline bool set_cr4(unsigned long value)
+{
+	int err = 0;
+
+	might_sleep();
+	/* clang-format off */
+	asm volatile("1: mov %[value],%%cr4 \n"
+		     "2: \n"
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_ONE_REG, %[err])
+		     : [value] "+r" (value), [err] "+r" (err)
+		     :);
+	/* clang-format on */
+	return err;
+}
+
+/* Control register pinning tests with SMEP check. */
+static void test_cr_disable_smep(struct kunit *const test)
+{
+	bool is_vme_set;
+
+	/* SMEP should be initially enabled. */
+	KUNIT_ASSERT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+
+	/*
+	 * Trying to disable SMEP, bypassing kernel self-protection by not
+	 * using cr4_clear_bits(X86_CR4_SMEP), and checking GP fault.
+	 */
+	KUNIT_EXPECT_TRUE(test, set_cr4(__read_cr4() & ~X86_CR4_SMEP));
+
+	/* SMEP should still be enabled. */
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+
+	/* Re-enabling SMEP doesn't throw a GP fault. */
+	KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() | X86_CR4_SMEP));
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+
+	/* We are allowed to set and unset VME. */
+	is_vme_set = __read_cr4() & X86_CR4_VME;
+	KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() | X86_CR4_VME));
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_VME);
+
+	KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() & ~X86_CR4_VME));
+	KUNIT_EXPECT_FALSE(test, __read_cr4() & X86_CR4_VME);
+
+	KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() | X86_CR4_VME));
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_VME);
+
+	/* SMEP and VME changes should be consistent when setting both. */
+	KUNIT_EXPECT_TRUE(test, set_cr4(__read_cr4() &
+					~(X86_CR4_SMEP | X86_CR4_VME)));
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_VME);
+
+	/* Unset VME. */
+	KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() & ~X86_CR4_VME));
+	KUNIT_EXPECT_FALSE(test, __read_cr4() & X86_CR4_VME);
+
+	/* SMEP and VME changes should be consistent when only setting SMEP. */
+	KUNIT_EXPECT_TRUE(test, set_cr4(__read_cr4() &
+					~(X86_CR4_SMEP | X86_CR4_VME)));
+	KUNIT_EXPECT_TRUE(test, __read_cr4() & X86_CR4_SMEP);
+	KUNIT_EXPECT_FALSE(test, __read_cr4() & X86_CR4_VME);
+
+	/* Restores VME. */
+	if (is_vme_set)
+		KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() | X86_CR4_VME));
+	else
+		KUNIT_EXPECT_FALSE(test, set_cr4(__read_cr4() & ~X86_CR4_VME));
+}
+
+/* clang-format off */
+static struct kunit_case test_cases_x86[] = {
+	KUNIT_CASE(test_cr_disable_smep),
+	{}
+};
+/* clang-format on */
+
+static int test_init(struct kunit *test)
+{
+#ifdef CONFIG_HEKI
+	if (heki_enforcing)
+		return 0;
+#else /* CONFIG_HEKI */
+	kunit_skip(test, "Heki is not enforced");
+#endif /* CONFIG_HEKI */
+
+	return 0;
+}
+
+static struct kunit_suite test_suite_x86 = {
+	.name = "heki_x86",
+	.init = test_init,
+	.test_cases = test_cases_x86,
+};
+
+kunit_test_suite(test_suite_x86);
+
+MODULE_IMPORT_NS(HEKI_KUNIT_TEST);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Tests for Hypervisor Enforced Kernel Integrity (Heki)");
diff --git a/virt/heki/main.c b/virt/heki/main.c
index ef0530a03e09..dcc89befaf66 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -11,6 +11,12 @@
 #include "common.h"
 
 bool heki_enabled __ro_after_init = true;
+
+#if IS_ENABLED(CONFIG_KUNIT)
+bool heki_enforcing = false;
+EXPORT_SYMBOL_NS_GPL(heki_enforcing, HEKI_KUNIT_TEST);
+#endif /* IS_ENABLED(CONFIG_KUNIT) */
+
 struct heki heki;
 
 /*
@@ -47,6 +53,10 @@ void heki_late_init(void)
 		return;
 
 	pr_warn("Control registers locked\n");
+
+#if IS_ENABLED(CONFIG_KUNIT)
+	heki_enforcing = true;
+#endif /* IS_ENABLED(CONFIG_KUNIT) */
 }
 
 static int __init heki_parse_config(char *str)
-- 
2.45.0


