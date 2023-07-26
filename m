Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10AE76423C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 00:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjGZWlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 18:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjGZWlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 18:41:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586B9213E
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 15:41:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d0d27cd9db9so455676276.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 15:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690411302; x=1691016102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=syXwvCxQ3Ao1US81SCFisNz2DEkn5+V6JwljbPRk1oQ=;
        b=6q+uuRPX3rXf1jdUAgSqJcSDHSvfHBpxQHJN/K5KPhw4thXTbTrrRWvI0WjquMekue
         bRpxgLrckn82mYjuJzrXXQmkYZkGI5CexYDVX44r1f3k+eT1JJFsvBpkzGVkG8ulho7a
         q9tqWH6QmoUCbzbXZ0mVaQkRqc3Sxx9LFzdGFpnjtnEd74VK+5jnymcG6HyqN2NxcF5J
         pim01ZEGh0cq1qHLDKERqZyNlpwDGfnSDYSUCACDkMeQHUWrpMVM8IfrBwdQTbpzEI1D
         6Fwg3iz7ZvSEJRX4/9LBEVtY0m8u5h9LtDPT7vEe4gS51op6mk90Rd2xHwJEOtcjDcL4
         Cubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690411302; x=1691016102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syXwvCxQ3Ao1US81SCFisNz2DEkn5+V6JwljbPRk1oQ=;
        b=IBKWukFqFfw3WZPYwFgWARj7VIO7QmlqMm5sH8K7NhVqTK+W3GmMq38S4KvcEL4CpE
         or10aVKJ9/CH4Z5MyAnclf0kFE4NVyyP0Mm3ReX8KdMNS+t6449gITI4xyy1uiamjUiF
         BK8dgoY2WooydV8mKcAnkni+vByTt/UVUkN4lXb2oIj41BoQc2NG0/zOtavS+1JDi6cP
         5FTPUKeD2EGwkFQyxJpN0EDgyT1khaMpLgPZefVTU19Zz0P/qjLGhGwHCintk1pXZd3P
         r1+dByRhR6Pi+iTVzIxVuzmlf8ghzguhWnEQ70WDhgtF6ST9PxedjisEQaVB/CgAM2jL
         PU6Q==
X-Gm-Message-State: ABy/qLZd/pD5fpOvFv+eEJoYRaQtb7rJHju5YCBpQsiQs/cDhp9RmdgH
        76376uesbep1GwvFAAmSAgTC0NX0o9U=
X-Google-Smtp-Source: APBJJlFqBCJ1m+mQl63bGaQEEEcKGHAOL+VR6wpnqTB6RCLlNzLGy1aycdQ+o13R5iLf/hTZxJBjjt3LXxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d247:0:b0:d0c:44d5:4530 with SMTP id
 j68-20020a25d247000000b00d0c44d54530mr10587ybg.3.1690411302629; Wed, 26 Jul
 2023 15:41:42 -0700 (PDT)
Date:   Wed, 26 Jul 2023 15:41:40 -0700
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
Message-ID: <ZMGhJAMqtFa6sTkl@google.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Aaron Lewis wrote:
> Extend the ucall framework to offer GUEST_PRINTF() and GUEST_ASSERT_FMT()
> in selftests.  This will allow for better and easier guest debugging.

This. Is.  Awesome.  Seriously, this is amazing!

I have one or two nits, but theyre so minor I already forgot what they were.

The one thing I think we should change is the final output of the assert.  Rather
than report the host TEST_FAIL as the assert:

  # ./svm_nested_soft_inject_test
  Running soft int test
  ==== Test Assertion Failure ====
    x86_64/svm_nested_soft_inject_test.c:191: false
    pid=169827 tid=169827 errno=4 - Interrupted system call
       1	0x0000000000401b52: run_test at svm_nested_soft_inject_test.c:191
       2	0x00000000004017d2: main at svm_nested_soft_inject_test.c:212
       3	0x00000000004159d3: __libc_start_call_main at libc-start.o:?
       4	0x000000000041701f: __libc_start_main_impl at ??:?
       5	0x0000000000401660: _start at ??:?
    Failed guest assert: regs->rip != (unsigned long)l2_guest_code_int at x86_64/svm_nested_soft_inject_test.c:39
    Expected IRQ at RIP 0x401e80, received IRQ at 0x401e80

show the guest assert as the primary assert.

  Running soft int test
  ==== Test Assertion Failure ====
    x86_64/svm_nested_soft_inject_test.c:39: regs->rip != (unsigned long)l2_guest_code_int
    pid=214104 tid=214104 errno=4 - Interrupted system call
       1	0x0000000000401b35: run_test at svm_nested_soft_inject_test.c:191
       2	0x00000000004017d2: main at svm_nested_soft_inject_test.c:212
       3	0x0000000000415b03: __libc_start_call_main at libc-start.o:?
       4	0x000000000041714f: __libc_start_main_impl at ??:?
       5	0x0000000000401660: _start at ??:?
    Expected IRQ at RIP 0x401e50, received IRQ at 0x401e50

That way users don't have to manually find the "real" assert.  Ditto for any kind
of automated reporting.  The site of the test_fail() invocation in the host is
still captured in the stack trace (though that too could be something to fix over
time), so unless I'm missing something, there's no information lost.

The easiest thing I can think of is to add a second buffer to hold the exp+file+line.
Then, test_assert() just needs to skip that particular line of formatting.

If you don't object, I'll post a v4 with the below folded in somewhere (after
more testing), and put this on the fast track for 6.6.

Side topic, if anyone lurking out there wants an easy (but tedious and boring)
starter project, we should convert all tests to the newfangled formatting and
drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_ASSERT_FMT()
and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.

---
 .../selftests/kvm/include/ucall_common.h      | 19 ++++++++---------
 tools/testing/selftests/kvm/lib/assert.c      | 13 +++++++-----
 .../testing/selftests/kvm/lib/ucall_common.c  | 21 +++++++++++++++++++
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index b4f4c88e8d84..3bc4e62bec1b 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -25,6 +25,7 @@ struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
 	char buffer[UCALL_BUFFER_LEN];
+	char aux_buffer[UCALL_BUFFER_LEN];
 
 	/* Host virtual address of this struct. */
 	struct ucall *hva;
@@ -36,6 +37,8 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
 void ucall_fmt(uint64_t cmd, const char *fmt, ...);
+void ucall_assert(uint64_t cmd, const char *exp, const char *file,
+		  unsigned int line, const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -63,15 +66,10 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
-#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)			\
-do {										\
-	char fmt[UCALL_BUFFER_LEN];						\
-										\
-	if (!(_condition)) {							\
-		guest_snprintf(fmt, sizeof(fmt), "%s\n  %s",			\
-			     "Failed guest assert: " _str " at %s:%ld", _fmt);	\
-		ucall_fmt(UCALL_ABORT, fmt, __FILE__, __LINE__, ##_args);	\
-	}									\
+#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)				\
+do {											\
+	if (!(_condition)) 								\
+		ucall_assert(UCALL_ABORT, _str, __FILE__, __LINE__, _fmt, ##_args);	\
 } while (0)
 
 #define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
@@ -102,7 +100,8 @@ do {									\
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
-#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
+#define REPORT_GUEST_ASSERT_FMT(ucall)					\
+	test_assert(false, (ucall).aux_buffer, NULL, 0, "%s", (ucall).buffer);
 
 #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
 	TEST_FAIL("%s at %s:%ld\n" fmt,					\
diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index 2bd25b191d15..74d94a34cf1a 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -75,11 +75,14 @@ test_assert(bool exp, const char *exp_str,
 	if (!(exp)) {
 		va_start(ap, fmt);
 
-		fprintf(stderr, "==== Test Assertion Failure ====\n"
-			"  %s:%u: %s\n"
-			"  pid=%d tid=%d errno=%d - %s\n",
-			file, line, exp_str, getpid(), _gettid(),
-			errno, strerror(errno));
+		fprintf(stderr, "==== Test Assertion Failure ====\n");
+		/* If @file is NULL, @exp_str contains a preformatted string. */
+		if (file)
+			fprintf(stderr, "  %s:%u: %s\n", file, line, exp_str);
+		else
+			fprintf(stderr, "  %s\n", exp_str);
+		fprintf(stderr, "  pid=%d tid=%d errno=%d - %s\n",
+			getpid(), _gettid(), errno, strerror(errno));
 		test_dump_stack();
 		if (fmt) {
 			fputs("  ", stderr);
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index b507db91139b..e7741aadf2ce 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -75,6 +75,27 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_assert(uint64_t cmd, const char *exp, const char *file,
+		  unsigned int line, const char *fmt, ...)
+{
+	struct ucall *uc;
+	va_list va;
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	guest_snprintf(uc->aux_buffer, sizeof(uc->aux_buffer),
+		       "%s:%u: %s", file, line, exp);
+
+	va_start(va, fmt);
+	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
+}
+
 void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 {
 	struct ucall *uc;

base-commit: 8dc29dfc010293957c5ca24271748a3c8f047a76
-- 

