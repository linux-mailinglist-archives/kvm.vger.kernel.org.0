Return-Path: <kvm+bounces-12681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DEC88BE57
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53FE11C3A8D2
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B095C606;
	Tue, 26 Mar 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="bK1gxeww"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1774F215
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 09:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711446704; cv=none; b=tx1uxrOAxXfWRvPCtInCYMNcVuk+45ZrlzmW90nqeXuXaenYTSfuPOE1YQieWchxgvx9gStw3YxK/MXkH3IA5wAtzxf2kGs0tW0vPJ/FP7IlYc556FezILg7iqNGy/kpt+4fdygBEn3HsUdTv3P4URbPEO3b7VzK1baijrPkREU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711446704; c=relaxed/simple;
	bh=/U6ehYBQXcnrObcNkQuqkpo5gBGsRNrPqQ0nV96fJPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UqcdAZiXFKWMD13GgWAvO8T3crSgbQLg+f9Ry7T2vXcHWgjtVLW/1Z46SAJpxnPCivhVrvYUSL7dWOF53zhLLEa5w+NAos3ol4rLDdsRlYpuzLxAxtuMN/fK6fIbs9KmcXQTv5ISPFyjCoVItcfF75c9U5MqWK2nIt+71HnVnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=bK1gxeww; arc=none smtp.client-ip=84.16.66.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4V3lSV3Xh4zd0D;
	Tue, 26 Mar 2024 10:51:38 +0100 (CET)
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4V3lST4szDz2xp;
	Tue, 26 Mar 2024 10:51:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1711446698;
	bh=/U6ehYBQXcnrObcNkQuqkpo5gBGsRNrPqQ0nV96fJPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK1gxeww/uTEzVNw0ciXTKlhEtagIgU52+cHPMFu9FdI2oNTNKNkmoQEFnGk7Q4K+
	 r6+VEAFLwq5euuWGBE25RV0OYahm4ocVf//B9IbYwEzfiNU5U409AFdXxeevhCjTmf
	 UaEXjXohshVp1vqvsMZ5EEvQTKN9FUBxBesB20Xg=
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
Subject: [PATCH v4 3/7] kunit: Fix timeout message
Date: Tue, 26 Mar 2024 10:51:14 +0100
Message-ID: <20240326095118.126696-4-mic@digikod.net>
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

The exit code is always checked, so let's properly handle the -ETIMEDOUT
error code.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240326095118.126696-4-mic@digikod.net
---

Changes since v2:
* Add Rae's and David's Reviewed-by.

Changes since v1:
* Add Kees's Reviewed-by.
---
 lib/kunit/try-catch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index 73f5007f20ea..cab8b24b5d5a 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -79,7 +79,6 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	time_remaining = wait_for_completion_timeout(&try_completion,
 						     kunit_test_timeout());
 	if (time_remaining == 0) {
-		kunit_err(test, "try timed out\n");
 		try_catch->try_result = -ETIMEDOUT;
 		kthread_stop(task_struct);
 	}
@@ -94,6 +93,8 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 		try_catch->try_result = 0;
 	else if (exit_code == -EINTR)
 		kunit_err(test, "wake_up_process() was never called\n");
+	else if (exit_code == -ETIMEDOUT)
+		kunit_err(test, "try timed out\n");
 	else if (exit_code)
 		kunit_err(test, "Unknown error: %d\n", exit_code);
 
-- 
2.44.0


