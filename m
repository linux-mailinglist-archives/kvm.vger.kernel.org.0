Return-Path: <kvm+bounces-10529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9BF86D013
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF1F42898FC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC627827A;
	Thu, 29 Feb 2024 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="O7SkJiHr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD134AEE6
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226278; cv=none; b=iSq6VJMppQ0hh+u+1IJshf8Jgae9wq5+5pqI7zp2w9R+MzHO1lcFo7iSmLus0PhVW6i2En9weNv/P8yXDGo4I7jm0iV0emYs7z0Aj6LHwkMAChx1HKNTC4wi9duL1AtjCjNiO6HaSh1INGZGZhd9OSlxoENvU7bRutcv/CrWJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226278; c=relaxed/simple;
	bh=jgxgVIds0Uq+q7sp2eMMdlRM5SUWajSTadOwGNRm2Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2cwOfeqPAV1EZ33w6cZqOiky+Tt8nsG4H5hJzdzGEKuTkZv4Ck1g0yAMxfTK4VN/G75RIBy3EMGcCVtoDjKEIJtXEnSghPGl0aLbuTJKKRwsqDfOltBil1ZNlpZW1PqmADsJj2vYc5v/4Rw1oNfSbSyWptw1OGYRpJGWvypkkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=O7SkJiHr; arc=none smtp.client-ip=84.16.66.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TlyJ06NtNz23G;
	Thu, 29 Feb 2024 18:04:32 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4TlyJ01KS6z3c;
	Thu, 29 Feb 2024 18:04:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709226272;
	bh=jgxgVIds0Uq+q7sp2eMMdlRM5SUWajSTadOwGNRm2Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7SkJiHrACJveUBYih6KHS2MoK6Y4pu39o0bmrh+/H6EdBfY1u3VZX8uGsKFJXi+a
	 WByMKyxBUC+h89F9ItJ41Svn8x0gBISiaYBOEAxH4PZonYP3aTFWiPtMTboZgZYUP1
	 9KoOsvsJogUIH9wR1oxyIDnWxnLfeIr+w9ncsLKQ=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <keescook@chromium.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org
Subject: [PATCH v1 8/8] kunit: Add tests for faults
Date: Thu, 29 Feb 2024 18:04:09 +0100
Message-ID: <20240229170409.365386-9-mic@digikod.net>
In-Reply-To: <20240229170409.365386-1-mic@digikod.net>
References: <20240229170409.365386-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

The first test checks NULL pointer dereference and make sure it would
result as a failed test.

The second and third tests check that read-only data is indeed read-only
and trying to modify it would result as a failed test.

This kunit_x86_fault test suite is marked as skipped when run on a
non-x86 native architecture.  It is then skipped on UML because such
test would result to a kernel panic.

Tested with:
./tools/testing/kunit/kunit.py run --arch x86_64 kunit_x86_fault

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 lib/kunit/kunit-test.c | 115 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
index f7980ef236a3..57d8eff00c66 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -10,6 +10,7 @@
 #include <kunit/test-bug.h>
 
 #include <linux/device.h>
+#include <linux/init.h>
 #include <kunit/device.h>
 
 #include "string-stream.h"
@@ -109,6 +110,117 @@ static struct kunit_suite kunit_try_catch_test_suite = {
 	.test_cases = kunit_try_catch_test_cases,
 };
 
+#ifdef CONFIG_X86
+
+static void kunit_test_null_dereference(void *data)
+{
+	struct kunit *test = data;
+	int *null = NULL;
+
+	*null = 0;
+
+	KUNIT_FAIL(test, "This line should never be reached\n");
+}
+
+static void kunit_test_fault_null_dereference(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	kunit_try_catch_init(try_catch,
+			     test,
+			     kunit_test_null_dereference,
+			     kunit_test_catch);
+	kunit_try_catch_run(try_catch, test);
+
+	KUNIT_EXPECT_EQ(test, try_catch->try_result, -EINTR);
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+#if defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX)
+
+const int test_const = 1;
+
+static void kunit_test_const(void *data)
+{
+	struct kunit *test = data;
+	/* Bypasses compiler check. */
+	int *ptr = (int *)&test_const;
+
+	KUNIT_EXPECT_EQ(test, test_const, 1);
+	*ptr = 2;
+
+	KUNIT_FAIL(test, "This line should never be reached\n");
+}
+
+static void kunit_test_fault_const(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	kunit_try_catch_init(try_catch, test, kunit_test_const,
+			     kunit_test_catch);
+	kunit_try_catch_run(try_catch, test);
+
+	KUNIT_EXPECT_EQ(test, test_const, 1);
+	KUNIT_EXPECT_EQ(test, try_catch->try_result, -EINTR);
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+static int test_rodata __ro_after_init = 1;
+
+static void kunit_test_rodata(void *data)
+{
+	struct kunit *test = data;
+
+	KUNIT_EXPECT_EQ(test, test_rodata, 1);
+	test_rodata = 2;
+
+	KUNIT_FAIL(test, "This line should never be reached\n");
+}
+
+static void kunit_test_fault_rodata(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	if (!rodata_enabled)
+		kunit_skip(test, "Strict RWX is not enabled");
+
+	kunit_try_catch_init(try_catch, test, kunit_test_rodata,
+			     kunit_test_catch);
+	kunit_try_catch_run(try_catch, test);
+
+	KUNIT_EXPECT_EQ(test, test_rodata, 1);
+	KUNIT_EXPECT_EQ(test, try_catch->try_result, -EINTR);
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+#else /* defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX) */
+
+static void kunit_test_fault_rodata(struct kunit *test)
+{
+	kunit_skip(test, "Strict RWX is not supported");
+}
+
+#endif /* defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX) */
+#endif /* CONFIG_X86 */
+
+static struct kunit_case kunit_x86_fault_test_cases[] = {
+#ifdef CONFIG_X86
+	KUNIT_CASE(kunit_test_fault_null_dereference),
+	KUNIT_CASE(kunit_test_fault_const),
+	KUNIT_CASE(kunit_test_fault_rodata),
+#endif /* CONFIG_X86 */
+	{}
+};
+
+static struct kunit_suite kunit_x86_fault_test_suite = {
+	.name = "kunit_x86_fault",
+	.init = kunit_try_catch_test_init,
+	.test_cases = kunit_x86_fault_test_cases,
+};
+
 /*
  * Context for testing test managed resources
  * is_resource_initialized is used to test arbitrary resources
@@ -826,6 +938,7 @@ static struct kunit_suite kunit_current_test_suite = {
 
 kunit_test_suites(&kunit_try_catch_test_suite, &kunit_resource_test_suite,
 		  &kunit_log_test_suite, &kunit_status_test_suite,
-		  &kunit_current_test_suite, &kunit_device_test_suite);
+		  &kunit_current_test_suite, &kunit_device_test_suite,
+		  &kunit_x86_fault_test_suite);
 
 MODULE_LICENSE("GPL v2");
-- 
2.44.0


