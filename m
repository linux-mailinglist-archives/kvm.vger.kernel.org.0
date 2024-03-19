Return-Path: <kvm+bounces-12119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8529987FC1D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 11:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2CF5287014
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B76E4CE08;
	Tue, 19 Mar 2024 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="spEGFIwd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCC4F8A9
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 10:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710845367; cv=none; b=Ntc4VGzHsNmerE/9pw4COWAb5e16f+0KJ9zDQrKo4pVu+kft5ttWS8lt0kBgv/tkSosjrMyJXQ3fAIMSH08gPRt/4aToTPY5dfV5FKTzVaWLnXdoff0RQ0tb62QkllSiolurMNfzX1JwMyuxFo8uPaXmf4P/W9y6HAxSzURp7H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710845367; c=relaxed/simple;
	bh=cKJ21os4pRSqtvrUL/kk04kO+wQ5E5PRBKkuzOwE6dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fXymiChilEwqJkgRnoYyJrgyS0rBreJZw7ciyGrS+/vZGAwTIu7OAZtBNat2v69bFProo9lTkYyFMtvuuV+G0Yyd/qJ709o64BbH0RM3TKzDcD4bZnTys2ggYang8eJnlNRcQNMB0cIf1bw7Ut3S/A+Q7sv7tLEQ1mhBJ75xPhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=spEGFIwd; arc=none smtp.client-ip=185.125.25.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TzT4J40WGzM5V;
	Tue, 19 Mar 2024 11:49:20 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4TzT4H6GDBz3g;
	Tue, 19 Mar 2024 11:49:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710845360;
	bh=cKJ21os4pRSqtvrUL/kk04kO+wQ5E5PRBKkuzOwE6dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spEGFIwdpJZqa7BSkY0tEWGdJ6y+dr8xW4uOSjXPJfpYlV7oa60n5G2Tr9V+zXHUA
	 wQ4ynSk2F6bNw0s0cuyAzP1aHiagfKAJQwOM4Pc689bnx1sTeClC4WU3tQ3dmsSptW
	 LcWfKE2iVhbuBtnk8YilUaS6otG9+ivy/ZEJyrlE=
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
Subject: [PATCH v3 2/7] kunit: Fix kthread reference
Date: Tue, 19 Mar 2024 11:48:52 +0100
Message-ID: <20240319104857.70783-3-mic@digikod.net>
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

There is a race condition when a kthread finishes after the deadline and
before the call to kthread_stop(), which may lead to use after free.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: adf505457032 ("kunit: fix UAF when run kfence test case test_gfpzero")
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240319104857.70783-3-mic@digikod.net
---

Changes since v2:
* Add Fixes tag as suggested by David.
* Add David's and Rae's Reviewed-by.

Changes since v1:
* Add Kees's Reviewed-by.
---
 lib/kunit/try-catch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index a5cb2ef70a25..73f5007f20ea 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -11,6 +11,7 @@
 #include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/sched/task.h>
 
 #include "try-catch-impl.h"
 
@@ -65,14 +66,15 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	try_catch->context = context;
 	try_catch->try_completion = &try_completion;
 	try_catch->try_result = 0;
-	task_struct = kthread_run(kunit_generic_run_threadfn_adapter,
-				  try_catch,
-				  "kunit_try_catch_thread");
+	task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
+				     try_catch, "kunit_try_catch_thread");
 	if (IS_ERR(task_struct)) {
 		try_catch->try_result = PTR_ERR(task_struct);
 		try_catch->catch(try_catch->context);
 		return;
 	}
+	get_task_struct(task_struct);
+	wake_up_process(task_struct);
 
 	time_remaining = wait_for_completion_timeout(&try_completion,
 						     kunit_test_timeout());
@@ -82,6 +84,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 		kthread_stop(task_struct);
 	}
 
+	put_task_struct(task_struct);
 	exit_code = try_catch->try_result;
 
 	if (!exit_code)
-- 
2.44.0


