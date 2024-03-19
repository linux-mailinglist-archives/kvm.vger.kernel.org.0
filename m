Return-Path: <kvm+bounces-12122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBFE87FC26
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 11:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DE8C287682
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBBF7CF03;
	Tue, 19 Mar 2024 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="TePPjuqL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95C7E56B
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710845374; cv=none; b=nGDpdVYh6Z2HLcDa23Jg9Txmjra4ljr02DOsP2lmiEiZ3Uo01vi7wIWvBfaVPkdlUHFOxdLa/XPbOgmx38i0d0PoLf9DRkgY1M+lGQmoT/RdSvHQUjOdLWT0otjKF5K6Kjbdaoheu14TWLzQrQoSMe8Bs8kG6P0GWYrXQ6BHxDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710845374; c=relaxed/simple;
	bh=Y7LFLz2yHd9yIyVMMmNOIi+K+sOwaMQ2yNDvGWc72JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvrggnhRZLUbfTH9Vtmdc8es7GdzjYLrKe+TYRJn6mLgqz1RSjGCAVuVsQc4NQI8Lk6hZiNngtZ94/tg3S5RLF2/F37SRoqRM+N+qgyT6trJZTcBHQGsr5Tx++g65DpNbBow1V39aoHKCNiIZHt3BePyXMDNxTxyAq43jbwFx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=TePPjuqL; arc=none smtp.client-ip=84.16.66.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TzT4P3th8zMZ7;
	Tue, 19 Mar 2024 11:49:25 +0100 (CET)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4TzT4N4spgzMpnPc;
	Tue, 19 Mar 2024 11:49:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710845365;
	bh=Y7LFLz2yHd9yIyVMMmNOIi+K+sOwaMQ2yNDvGWc72JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TePPjuqLC0xBIEbGy6Z1xt0ZB9ximrtLx/5QCewjGn/21CT19iJrOHPjeJJcGFBzk
	 eSXUz8nNDlsgAzA6EMU+PVtlrIO60Kp81l/DqdVb8z6QUxahUJeJ+p+LFoQpM+hMG0
	 b8C/ungtLOe4nlLJoXcf8eHZFHxSt0XXyNyiwYoE=
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
Subject: [PATCH v3 6/7] kunit: Print last test location on fault
Date: Tue, 19 Mar 2024 11:48:56 +0100
Message-ID: <20240319104857.70783-7-mic@digikod.net>
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

This helps identify the location of test faults with opportunistic calls
to _KUNIT_SAVE_LOC().  This can be useful while writing tests or
debugging them.  It is possible to call KUNIT_SUCCESS() to explicit save
last location.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240319104857.70783-7-mic@digikod.net
---

Changes since v2:
* Extend the commit message according to discussion with David.

Changes since v1:
* Add Kees's Reviewed-by.
---
 include/kunit/test.h  | 24 +++++++++++++++++++++---
 lib/kunit/try-catch.c | 10 +++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index fcb4a4940ace..f3aa66eb0087 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -301,6 +301,8 @@ struct kunit {
 	struct list_head resources; /* Protected by lock. */
 
 	char status_comment[KUNIT_STATUS_COMMENT_SIZE];
+	/* Saves the last seen test. Useful to help with faults. */
+	struct kunit_loc last_seen;
 };
 
 static inline void kunit_set_failure(struct kunit *test)
@@ -567,6 +569,15 @@ void __printf(2, 3) kunit_log_append(struct string_stream *log, const char *fmt,
 #define kunit_err(test, fmt, ...) \
 	kunit_printk(KERN_ERR, test, fmt, ##__VA_ARGS__)
 
+/*
+ * Must be called at the beginning of each KUNIT_*_ASSERTION().
+ * Cf. KUNIT_CURRENT_LOC.
+ */
+#define _KUNIT_SAVE_LOC(test) do {					       \
+	WRITE_ONCE(test->last_seen.file, __FILE__);			       \
+	WRITE_ONCE(test->last_seen.line, __LINE__);			       \
+} while (0)
+
 /**
  * KUNIT_SUCCEED() - A no-op expectation. Only exists for code clarity.
  * @test: The test context object.
@@ -575,7 +586,7 @@ void __printf(2, 3) kunit_log_append(struct string_stream *log, const char *fmt,
  * words, it does nothing and only exists for code clarity. See
  * KUNIT_EXPECT_TRUE() for more information.
  */
-#define KUNIT_SUCCEED(test) do {} while (0)
+#define KUNIT_SUCCEED(test) _KUNIT_SAVE_LOC(test)
 
 void __noreturn __kunit_abort(struct kunit *test);
 
@@ -601,14 +612,16 @@ void __kunit_do_failed_assertion(struct kunit *test,
 } while (0)
 
 
-#define KUNIT_FAIL_ASSERTION(test, assert_type, fmt, ...)		       \
+#define KUNIT_FAIL_ASSERTION(test, assert_type, fmt, ...) do {		       \
+	_KUNIT_SAVE_LOC(test);						       \
 	_KUNIT_FAILED(test,						       \
 		      assert_type,					       \
 		      kunit_fail_assert,				       \
 		      kunit_fail_assert_format,				       \
 		      {},						       \
 		      fmt,						       \
-		      ##__VA_ARGS__)
+		      ##__VA_ARGS__);					       \
+} while (0)
 
 /**
  * KUNIT_FAIL() - Always causes a test to fail when evaluated.
@@ -637,6 +650,7 @@ void __kunit_do_failed_assertion(struct kunit *test,
 			      fmt,					       \
 			      ...)					       \
 do {									       \
+	_KUNIT_SAVE_LOC(test);						       \
 	if (likely(!!(condition_) == !!expected_true_))			       \
 		break;							       \
 									       \
@@ -698,6 +712,7 @@ do {									       \
 		.right_text = #right,					       \
 	};								       \
 									       \
+	_KUNIT_SAVE_LOC(test);						       \
 	if (likely(__left op __right))					       \
 		break;							       \
 									       \
@@ -758,6 +773,7 @@ do {									       \
 		.right_text = #right,					       \
 	};								       \
 									       \
+	_KUNIT_SAVE_LOC(test);						       \
 	if (likely((__left) && (__right) && (strcmp(__left, __right) op 0)))   \
 		break;							       \
 									       \
@@ -791,6 +807,7 @@ do {									       \
 		.right_text = #right,					       \
 	};								       \
 									       \
+	_KUNIT_SAVE_LOC(test);						       \
 	if (likely(__left && __right))					       \
 		if (likely(memcmp(__left, __right, __size) op 0))	       \
 			break;						       \
@@ -815,6 +832,7 @@ do {									       \
 do {									       \
 	const typeof(ptr) __ptr = (ptr);				       \
 									       \
+	_KUNIT_SAVE_LOC(test);						       \
 	if (!IS_ERR_OR_NULL(__ptr))					       \
 		break;							       \
 									       \
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index 7a3910dd78a6..d36e78095fdc 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -96,9 +96,13 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 
 	if (exit_code == -EFAULT)
 		try_catch->try_result = 0;
-	else if (exit_code == -EINTR)
-		kunit_err(test, "try faulted\n");
-	else if (exit_code == -ETIMEDOUT)
+	else if (exit_code == -EINTR) {
+		if (test->last_seen.file)
+			kunit_err(test, "try faulted after %s:%d\n",
+				  test->last_seen.file, test->last_seen.line);
+		else
+			kunit_err(test, "try faulted before the first test\n");
+	} else if (exit_code == -ETIMEDOUT)
 		kunit_err(test, "try timed out\n");
 	else if (exit_code)
 		kunit_err(test, "Unknown error: %d\n", exit_code);
-- 
2.44.0


