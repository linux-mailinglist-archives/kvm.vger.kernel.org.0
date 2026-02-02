Return-Path: <kvm+bounces-69948-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFirDaUogWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69948-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:43:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1764AD260F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0B072302B36B
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5084399020;
	Mon,  2 Feb 2026 22:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/8u26Ob"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E436396D32
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071479; cv=none; b=qxbs6mnslj5Bi59ho0Sig0Vn896UhTdLZy8gsTSQIfyUu63IW6gtyAlUX+inU1Vdv7eVHdM/IrDpVppWyN7fbgx7XJorNyx1GStjh6sYfkviZxdzssFr5qisMfeTWph5apsY3MRyI/fWGyd4k7gJmjDY9w872uZW/FTlGGHC0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071479; c=relaxed/simple;
	bh=paRY902jSAmTETjDD1hZGcuiwxsRB/2HetR0hPmkoIc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWeL00upPkARL1vgOqdWqlR738ZETeho6L5DQ4ET99R/Il+BP9+gQgSSqWMHkmopU6l0ZYRcFrF8kMgf3JGkm7nMDzzO6ak21kGEIh0qqYUJw4APUVv1dW9zcmhRW7/tZfJdvjSzRoMvVLDEkz78JDZL9hGk1SUIWv0GZflLTb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/8u26Ob; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so3220615a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071477; x=1770676277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CIRzZ36BxJeE+zHVaNnE1NZJiOjcnY3uuksWluhV1Js=;
        b=i/8u26Obt3thqHR5UIIXPJ6NEM+DuiFT/Mzr59PiwIw9xOi2XgX7o8jIZr3U+0D3Tn
         sXS8OhZvwkuKXpgXA8qWUQfNKgTe1a53YB3hN1oK99xSuHp646R8Z5uBkjOAZiLilDyq
         9JlJQhUi5JKA3eHGx9y/b022CMKdRDQUD3AZeXbIopXNa9+mN1RLm9ZImCL6Z71Oqhll
         +pG7PEquqNcBgauQUk7S8KJUN3U8sdD62yhb6//vKoUrjmeR80Qhl6MUL3pxSmKF2ICr
         Pfprytaizau2vcj2yCx9CwW7ANZWw38Zbdbg0A1+U2XypMNLJ1ZzxWv1e2ro7dxCAFoQ
         i7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071477; x=1770676277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIRzZ36BxJeE+zHVaNnE1NZJiOjcnY3uuksWluhV1Js=;
        b=UN6Oj7oBLzYuPRgLm6aDnzsqkNIXBXbodAWIqL+s+YiLu7ilhspPtB/GBYoQPhZIii
         mjnHDvk4ajPNy2czJQMk+3w20c1YgdW4w3RLEHlbpVuwya+OjCNMjTaiBmxzN11Ct9wS
         RATEZhVMXwDH75d0eKFBVC7TuCY3xHamXXbQwFICFfwNn84/6ODB9GxbRUxFpwbmx3mQ
         9iii5su/ubYS2srpNE51bhgdUGGw2csn+zJi3UOhhqHeE2WK4fFASH8H49xRWrtRQfeg
         jEhdkG6owPcUzD19/JLNBKp5QSf1VqeZvbqJrWOrL6WMfYwBpu6Ru1q4CJWR8gDp0Xul
         16iA==
X-Gm-Message-State: AOJu0YwVyTY5EuIk23iUAze5jv5vz2gmLdif0qILDVH8XHdVFdHiKTg1
	dfSE4gw3XYCQ0EeJMobtoNyfKu+CYrq2llJ4exUH3yCbKPBvioeOeDtg2T+xFDoyKodsrzP/Xa4
	GPyG7SyXeqgoV67LNvgwYIR0DelRfHSnlrYYKIo7hIHraAGm3j6I8bB3y4hGeTzcKkUEX1dpQdh
	S5N6m+4s27qvNgPvA/pAiFbUhA8O2KUBiKxBxqd2Lhu5Tg0dvMobW29plgqFA=
X-Received: from pgbca8.prod.google.com ([2002:a05:6a02:688:b0:c66:bca:633a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2d21:b0:350:55e0:5522 with SMTP id adf61e73a8af0-392e011a856mr12193174637.37.1770071476213;
 Mon, 02 Feb 2026 14:31:16 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:11 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <995398ca18fcb192444799a520cab5ea8e43df7b.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 33/37] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69948-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1764AD260F
X-Rspamd-Action: no action

The TEST_EXPECT_SIGBUS macro is not thread-safe as it uses a global
sigjmp_buf and installs a global SIGBUS signal handler. If multiple threads
execute the macro concurrently, they will race on installing the signal
handler and stomp on other threads' jump buffers, leading to incorrect test
behavior.

Make TEST_EXPECT_SIGBUS thread-safe with the following changes:

Share the KVM tests' global signal handler. sigaction() applies to all
threads; without sharing a global signal handler, one thread may have
removed the signal handler that another thread added, hence leading to
unexpected signals.

The alternative of layering signal handlers was considered, but calling
sigaction() within TEST_EXPECT_SIGBUS() necessarily creates a race. To
avoid adding new setup and teardown routines to do sigaction() and keep
usage of TEST_EXPECT_SIGBUS() simple, share the KVM tests' global signal
handler.

Opportunistically rename report_unexpected_signal to
catchall_signal_handler.

To continue to only expect SIGBUS within specific regions of code, use a
thread-specific variable, expecting_sigbus, to replace installing and
removing signal handlers.

Make the execution environment for the thread, sigjmp_buf, a
thread-specific variable.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/include/test_util.h | 29 +++++++++----------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 ++++++++----
 tools/testing/selftests/kvm/lib/test_util.c   |  7 -----
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 2871a4292847..0e4e6f7dab8f 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -80,22 +80,19 @@ do {									\
 	__builtin_unreachable(); \
 } while (0)
 
-extern sigjmp_buf expect_sigbus_jmpbuf;
-void expect_sigbus_handler(int signum);
-
-#define TEST_EXPECT_SIGBUS(action)						\
-do {										\
-	struct sigaction sa_old, sa_new = {					\
-		.sa_handler = expect_sigbus_handler,				\
-	};									\
-										\
-	sigaction(SIGBUS, &sa_new, &sa_old);					\
-	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
-		action;								\
-		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
-	}									\
-	sigaction(SIGBUS, &sa_old, NULL);					\
-} while (0)
+extern __thread sigjmp_buf expect_sigbus_jmpbuf;
+extern __thread bool expecting_sigbus;
+
+#define TEST_EXPECT_SIGBUS(action)                                     \
+	do {                                                           \
+		expecting_sigbus = true;			       \
+		if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {         \
+			action;                                        \
+			TEST_FAIL("'%s' should have triggered SIGBUS", \
+				  #action);                            \
+		}                                                      \
+		expecting_sigbus = false;			       \
+	} while (0)
 
 size_t parse_size(const char *size);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index aec7b24418ab..18ced8bdde36 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2314,13 +2314,20 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
-static void report_unexpected_signal(int signum)
+__thread sigjmp_buf expect_sigbus_jmpbuf;
+__thread bool expecting_sigbus;
+
+static void catchall_signal_handler(int signum)
 {
+	switch (signum) {
+	case SIGBUS: {
+		if (expecting_sigbus)
+			siglongjmp(expect_sigbus_jmpbuf, 1);
+
+		TEST_FAIL("Unexpected SIGBUS (%d)\n", signum);
+	}
 #define KVM_CASE_SIGNUM(sig)					\
 	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
-
-	switch (signum) {
-	KVM_CASE_SIGNUM(SIGBUS);
 	KVM_CASE_SIGNUM(SIGSEGV);
 	KVM_CASE_SIGNUM(SIGILL);
 	KVM_CASE_SIGNUM(SIGFPE);
@@ -2332,12 +2339,13 @@ static void report_unexpected_signal(int signum)
 void __attribute((constructor)) kvm_selftest_init(void)
 {
 	struct sigaction sig_sa = {
-		.sa_handler = report_unexpected_signal,
+		.sa_handler = catchall_signal_handler,
 	};
 
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	expecting_sigbus = false;
 	sigaction(SIGBUS, &sig_sa, NULL);
 	sigaction(SIGSEGV, &sig_sa, NULL);
 	sigaction(SIGILL, &sig_sa, NULL);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8a1848586a85..03eb99af9b8d 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -18,13 +18,6 @@
 
 #include "test_util.h"
 
-sigjmp_buf expect_sigbus_jmpbuf;
-
-void __attribute__((used)) expect_sigbus_handler(int signum)
-{
-	siglongjmp(expect_sigbus_jmpbuf, 1);
-}
-
 /*
  * Random number generator that is usable from guest code. This is the
  * Park-Miller LCG using standard constants.
-- 
2.53.0.rc1.225.gd81095ad13-goog


