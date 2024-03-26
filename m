Return-Path: <kvm+bounces-12686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECD388BE6B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D09341C3A319
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAB174418;
	Tue, 26 Mar 2024 09:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="WMzokmcs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C0B5D480
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711446709; cv=none; b=tNmhlKYi9ZzyxPej3CVx1Ll9StYor8QfgtCO3Zh81oFgsxo/Tj9HUDublUuCizMMwYfFZqbe//L2FLoOiGQEZW25a1UYBeoyExRsf82X7QXxnDtZQdzQsUOOV+Ob4T2FypOZX9fRH8VZT8J+qDcMPR3L1g9UJ0JTlfFQqGle/Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711446709; c=relaxed/simple;
	bh=VwZxvUQPVph+NebLcCZQeB0+ANm/1LnxkgU/PHwfhyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKZxIyY8wjqDQbipkBrSB4C6tbNpZAs7tQQy4wyDW9LOfbvf7DZBeCD8L13LfrXeCsSO7paHU8aFfOmeZclOs6gLqRAgN1fxY6V69N25kZDVN7B84sfFN6e3zOAmlCm7CRQVNM9WCV7CtRfEsnDIc88D1aWvcESW1aPyW3BAIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=WMzokmcs; arc=none smtp.client-ip=45.157.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4V3lSZ71BPzbYZ;
	Tue, 26 Mar 2024 10:51:42 +0100 (CET)
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4V3lSZ2K2bzKQ0;
	Tue, 26 Mar 2024 10:51:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1711446702;
	bh=VwZxvUQPVph+NebLcCZQeB0+ANm/1LnxkgU/PHwfhyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMzokmcsGZ79WBn7AEb+orlII6XtoyVNZGG1dsY3l5PPHCyfs7cglkNI3nQ7/gLOi
	 I4O5Qyp03FyEMp62eEFw3qMfkIxK6zH0ddlgJdYIB+0XY3mdrqhPAETKBNRtNgHcVx
	 MDVtIaxPUX0WwGBf/Gd4HHn/ioXPHROZVrIlpJmw=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org
Subject: [PATCH v4 7/7] kunit: Add tests for fault
Date: Tue, 26 Mar 2024 10:51:18 +0100
Message-ID: <20240326095118.126696-8-mic@digikod.net>
In-Reply-To: <20240326095118.126696-1-mic@digikod.net>
References: <20240326095118.126696-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Add a test case to check NULL pointer dereference and make sure it would
result as a failed test.

The full kunit_fault test suite is marked as skipped when run on UML
because it would result to a kernel panic.

Tested with:
./tools/testing/kunit/kunit.py run --arch x86_64 kunit_fault
./tools/testing/kunit/kunit.py run --arch arm64 \
  --cross_compile=aarch64-linux-gnu- kunit_fault

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240326095118.126696-8-mic@digikod.net
---

Changes since v2:
* Add David's Reviewed-by.

Changes since v1:
* Remove the rodata and const test cases for now.
* Replace CONFIG_X86 check with !CONFIG_UML, and remove the "_x86"
  references.
---
 lib/kunit/kunit-test.c | 45 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
index f7980ef236a3..0fdca5fffaec 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -109,6 +109,48 @@ static struct kunit_suite kunit_try_catch_test_suite = {
 	.test_cases = kunit_try_catch_test_cases,
 };
 
+#ifndef CONFIG_UML
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
+#endif /* !CONFIG_UML */
+
+static struct kunit_case kunit_fault_test_cases[] = {
+#ifndef CONFIG_UML
+	KUNIT_CASE(kunit_test_fault_null_dereference),
+#endif /* !CONFIG_UML */
+	{}
+};
+
+static struct kunit_suite kunit_fault_test_suite = {
+	.name = "kunit_fault",
+	.init = kunit_try_catch_test_init,
+	.test_cases = kunit_fault_test_cases,
+};
+
 /*
  * Context for testing test managed resources
  * is_resource_initialized is used to test arbitrary resources
@@ -826,6 +868,7 @@ static struct kunit_suite kunit_current_test_suite = {
 
 kunit_test_suites(&kunit_try_catch_test_suite, &kunit_resource_test_suite,
 		  &kunit_log_test_suite, &kunit_status_test_suite,
-		  &kunit_current_test_suite, &kunit_device_test_suite);
+		  &kunit_current_test_suite, &kunit_device_test_suite,
+		  &kunit_fault_test_suite);
 
 MODULE_LICENSE("GPL v2");
-- 
2.44.0


