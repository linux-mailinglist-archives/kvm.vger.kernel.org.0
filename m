Return-Path: <kvm+bounces-12126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 173B887FC5E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 11:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1520BB21F9F
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579C47E10C;
	Tue, 19 Mar 2024 10:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="a5FId7F9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C67E572;
	Tue, 19 Mar 2024 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710845739; cv=none; b=JdoNHQ7gbDFohROdJPJKuISANOCBsUGbTaKmZ24Nyg2F4oiChM7Mni3kYDehRQS7s3RZQZK9PyapKd1eSaYkBH6Wmg/FOKSkO1OL5S2q8b4hTxnIpOxaM8pou2qZuBQr+RNKafZoJ9wNk2BegJcwAicaPfH51LWtm9JVr8ZaXOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710845739; c=relaxed/simple;
	bh=wqMxCjGb6HQVq+PeRH1/HQhpoMzq4kllkrCAcm/eOKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUP+HOJvHwuGXK90zLoG1ub+kWVtSzSudU4VLm0wnRq5X7fGgUu1o0zfKOBOC1AX4LoOnhYpVfrsjc7Aicpg/XaVS8AtN5+qWWypcSyOun7zXmAtmi+4/MROzwgaIMzN6v4yk5FluYcQJj6DYt7QKTgLmwfI5l8yexGwxRH9wNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=a5FId7F9; arc=none smtp.client-ip=84.16.66.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TzT4M01KQzMKj;
	Tue, 19 Mar 2024 11:49:23 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4TzT4L2Dyczr5;
	Tue, 19 Mar 2024 11:49:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710845362;
	bh=wqMxCjGb6HQVq+PeRH1/HQhpoMzq4kllkrCAcm/eOKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5FId7F9PJQqeU2lxNP/NJ8BSyDg5RAkdHp951OjWW57cp80GYgOtqINt2bFG/VzA
	 pXFgs+JgeYRT7H72W1Z1HkYuBAD5SfOGUCvm4ZI51GalA6XHTHDKmO2noqYPKnau73
	 Tzed9bYlE++aR6s+jZZa55qRRLqdoukJfuWCrlJU=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org
Subject: [PATCH v3 4/7] kunit: Handle test faults
Date: Tue, 19 Mar 2024 11:48:54 +0100
Message-ID: <20240319104857.70783-5-mic@digikod.net>
In-Reply-To: <20240319104857.70783-1-mic@digikod.net>
References: <20240319104857.70783-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Previously, when a kernel test thread crashed (e.g. NULL pointer
dereference, general protection fault), the KUnit test hanged for 30
seconds and exited with a timeout error.

Fix this issue by waiting on task_struct->vfork_done instead of the
custom kunit_try_catch.try_completion, and track the execution state by
initially setting try_result with -EINTR and only setting it to 0 if
the test passed.

Fix kunit_generic_run_threadfn_adapter() signature by returning 0
instead of calling kthread_complete_and_exit().  Because thread's exit
code is never checked, always set it to 0 to make it clear.

Fix the -EINTR error message, which couldn't be reached until now.

This is tested with a following patch.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240319104857.70783-5-mic@digikod.net
---

Changes since v2:
* s/-EFAULT/-EINTR/ in commit message as spotted by Rae.
* Add a comment explaining vfork_done as suggested by David.
* Add David's Reviewed-by.
* Add Rae's Tested-by.

Changes since v1:
* Add Kees's Reviewed-by.
---
 include/kunit/try-catch.h |  3 ---
 lib/kunit/try-catch.c     | 19 ++++++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/kunit/try-catch.h b/include/kunit/try-catch.h
index c507dd43119d..7c966a1adbd3 100644
--- a/include/kunit/try-catch.h
+++ b/include/kunit/try-catch.h
@@ -14,13 +14,11 @@
 
 typedef void (*kunit_try_catch_func_t)(void *);
 
-struct completion;
 struct kunit;
 
 /**
  * struct kunit_try_catch - provides a generic way to run code which might fail.
  * @test: The test case that is currently being executed.
- * @try_completion: Completion that the control thread waits on while test runs.
  * @try_result: Contains any errno obtained while running test case.
  * @try: The function, the test case, to attempt to run.
  * @catch: The function called if @try bails out.
@@ -46,7 +44,6 @@ struct kunit;
 struct kunit_try_catch {
 	/* private: internal use only. */
 	struct kunit *test;
-	struct completion *try_completion;
 	int try_result;
 	kunit_try_catch_func_t try;
 	kunit_try_catch_func_t catch;
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index cab8b24b5d5a..7a3910dd78a6 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -18,7 +18,7 @@
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
 	try_catch->try_result = -EFAULT;
-	kthread_complete_and_exit(try_catch->try_completion, -EFAULT);
+	kthread_exit(0);
 }
 EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
 
@@ -26,9 +26,12 @@ static int kunit_generic_run_threadfn_adapter(void *data)
 {
 	struct kunit_try_catch *try_catch = data;
 
+	try_catch->try_result = -EINTR;
 	try_catch->try(try_catch->context);
+	if (try_catch->try_result == -EINTR)
+		try_catch->try_result = 0;
 
-	kthread_complete_and_exit(try_catch->try_completion, 0);
+	return 0;
 }
 
 static unsigned long kunit_test_timeout(void)
@@ -58,13 +61,11 @@ static unsigned long kunit_test_timeout(void)
 
 void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 {
-	DECLARE_COMPLETION_ONSTACK(try_completion);
 	struct kunit *test = try_catch->test;
 	struct task_struct *task_struct;
 	int exit_code, time_remaining;
 
 	try_catch->context = context;
-	try_catch->try_completion = &try_completion;
 	try_catch->try_result = 0;
 	task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
 				     try_catch, "kunit_try_catch_thread");
@@ -75,8 +76,12 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	}
 	get_task_struct(task_struct);
 	wake_up_process(task_struct);
-
-	time_remaining = wait_for_completion_timeout(&try_completion,
+	/*
+	 * As for a vfork(2), task_struct->vfork_done (pointing to the
+	 * underlying kthread->exited) can be used to wait for the end of a
+	 * kernel thread.
+	 */
+	time_remaining = wait_for_completion_timeout(task_struct->vfork_done,
 						     kunit_test_timeout());
 	if (time_remaining == 0) {
 		try_catch->try_result = -ETIMEDOUT;
@@ -92,7 +97,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	if (exit_code == -EFAULT)
 		try_catch->try_result = 0;
 	else if (exit_code == -EINTR)
-		kunit_err(test, "wake_up_process() was never called\n");
+		kunit_err(test, "try faulted\n");
 	else if (exit_code == -ETIMEDOUT)
 		kunit_err(test, "try timed out\n");
 	else if (exit_code)
-- 
2.44.0


