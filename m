Return-Path: <kvm+bounces-10272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6DB86B29E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7C9B288EAD
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9EC15CD7B;
	Wed, 28 Feb 2024 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jIaM/U3k"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E2C15CD6E
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132676; cv=none; b=TOzTCP+Z7VwbKzCEZzxd7zOOtPoXj7xZuqvcOTG9sOInXdYLxUbkIllV7t8tKETOhAPZoXIMPUXp1dCPg0rA0YRmfLewM8t+ZvfgxQDqCmFkydeb94xqwIQkuXAkEMitq6Ty4nCMneoL5QTvcHVwSUJf7WhQUAxoEJJfS6Ncyo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132676; c=relaxed/simple;
	bh=zV4+X266V/JuNuACFyKCNUvL7RQCGu1AtgltdLf8vvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=U7ewQpkmZH5NB/L8jVq+U82T1ED27/77sy/8ixIF3TMtVsdE5ApzDryzDCAfFnQlBWKGfAtzMGRmwKsSK1gA9shb9Zgn3f50KxJfVp2fSK/OnPgnlqhnSuRjIL22M+o6bekAk19gZNTmtatuN+Czbq5Js4igcv+R1jOKa8PVzD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jIaM/U3k; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A5w0UrDb88O9RJorQIIyDZcP2bQt2PRprTlXxIDoNBU=;
	b=jIaM/U3keRArYn8Xly5XqqUx4hLCCQqkps6f+OsZCDvsLiZVMWrQS9rF+HPyRxIrDKpsOR
	FLPRxaEBFutFpiGvDhaq0UikTaE0RYaUqizjal383PGUUOQjES9nX0VOhMT+v8ttZXskJF
	iQOnm/uioxrXh2IwZJgUa9idpYrAq74=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	lvivier@redhat.com,
	npiggin@gmail.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 03/13] treewide: lib/stack: Fix backtrace
Date: Wed, 28 Feb 2024 16:04:19 +0100
Message-ID: <20240228150416.248948-18-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We should never pass the result of __builtin_frame_address(0) to
another function since the compiler is within its rights to pop the
frame to which it points before making the function call, as may be
done for tail calls. Nobody has complained about backtrace(), so
likely all compilations have been inlining backtrace_frame(), not
dropping the frame on the tail call, or nobody is looking at traces.
However, for riscv, when built for EFI, it does drop the frame on the
tail call, and it was noticed. Preemptively fix backtrace() for all
architectures.

Fixes: 52266791750d ("lib: backtrace printing")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/stack.c   | 13 +++++--------
 lib/arm64/stack.c | 12 +++++-------
 lib/riscv/stack.c | 12 +++++-------
 lib/s390x/stack.c | 12 +++++-------
 lib/stack.h       | 24 +++++++++++++++++-------
 lib/x86/stack.c   | 12 +++++-------
 6 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/lib/arm/stack.c b/lib/arm/stack.c
index 7d081be7c6d0..66d18b47ea53 100644
--- a/lib/arm/stack.c
+++ b/lib/arm/stack.c
@@ -8,13 +8,16 @@
 #include <libcflat.h>
 #include <stack.h>
 
-int backtrace_frame(const void *frame, const void **return_addrs,
-		    int max_depth)
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
 {
 	static int walking;
 	int depth;
 	const unsigned long *fp = (unsigned long *)frame;
 
+	if (current_frame)
+		fp = __builtin_frame_address(0);
+
 	if (walking) {
 		printf("RECURSIVE STACK WALK!!!\n");
 		return 0;
@@ -33,9 +36,3 @@ int backtrace_frame(const void *frame, const void **return_addrs,
 	walking = 0;
 	return depth;
 }
-
-int backtrace(const void **return_addrs, int max_depth)
-{
-	return backtrace_frame(__builtin_frame_address(0),
-			       return_addrs, max_depth);
-}
diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
index 82611f4b1815..f5eb57fd8892 100644
--- a/lib/arm64/stack.c
+++ b/lib/arm64/stack.c
@@ -8,7 +8,8 @@
 
 extern char vector_stub_start, vector_stub_end;
 
-int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
 {
 	const void *fp = frame;
 	static bool walking;
@@ -17,6 +18,9 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	bool is_exception = false;
 	unsigned long addr;
 
+	if (current_frame)
+		fp = __builtin_frame_address(0);
+
 	if (walking) {
 		printf("RECURSIVE STACK WALK!!!\n");
 		return 0;
@@ -54,9 +58,3 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	walking = false;
 	return depth;
 }
-
-int backtrace(const void **return_addrs, int max_depth)
-{
-	return backtrace_frame(__builtin_frame_address(0),
-			       return_addrs, max_depth);
-}
diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
index 712a5478d547..d865594b9671 100644
--- a/lib/riscv/stack.c
+++ b/lib/riscv/stack.c
@@ -2,12 +2,16 @@
 #include <libcflat.h>
 #include <stack.h>
 
-int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
 {
 	static bool walking;
 	const unsigned long *fp = (unsigned long *)frame;
 	int depth;
 
+	if (current_frame)
+		fp = __builtin_frame_address(0);
+
 	if (walking) {
 		printf("RECURSIVE STACK WALK!!!\n");
 		return 0;
@@ -24,9 +28,3 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	walking = false;
 	return depth;
 }
-
-int backtrace(const void **return_addrs, int max_depth)
-{
-	return backtrace_frame(__builtin_frame_address(0),
-			       return_addrs, max_depth);
-}
diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index 9f234a12adf6..d194f654e94d 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -14,11 +14,15 @@
 #include <stack.h>
 #include <asm/arch_def.h>
 
-int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
 {
 	int depth = 0;
 	struct stack_frame *stack = (struct stack_frame *)frame;
 
+	if (current_frame)
+		stack = __builtin_frame_address(0);
+
 	for (depth = 0; stack && depth < max_depth; depth++) {
 		return_addrs[depth] = (void *)stack->grs[8];
 		stack = stack->back_chain;
@@ -28,9 +32,3 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 
 	return depth;
 }
-
-int backtrace(const void **return_addrs, int max_depth)
-{
-	return backtrace_frame(__builtin_frame_address(0),
-			       return_addrs, max_depth);
-}
diff --git a/lib/stack.h b/lib/stack.h
index 10fc2f793354..6edc84344b51 100644
--- a/lib/stack.h
+++ b/lib/stack.h
@@ -11,17 +11,27 @@
 #include <asm/stack.h>
 
 #ifdef HAVE_ARCH_BACKTRACE_FRAME
-extern int backtrace_frame(const void *frame, const void **return_addrs,
-			   int max_depth);
+extern int arch_backtrace_frame(const void *frame, const void **return_addrs,
+				int max_depth, bool current_frame);
+
+static inline int backtrace_frame(const void *frame, const void **return_addrs,
+				  int max_depth)
+{
+	return arch_backtrace_frame(frame, return_addrs, max_depth, false);
+}
+
+static inline int backtrace(const void **return_addrs, int max_depth)
+{
+	return arch_backtrace_frame(NULL, return_addrs, max_depth, true);
+}
 #else
-static inline int
-backtrace_frame(const void *frame __unused, const void **return_addrs __unused,
-		int max_depth __unused)
+extern int backtrace(const void **return_addrs, int max_depth);
+
+static inline int backtrace_frame(const void *frame, const void **return_addrs,
+				  int max_depth)
 {
 	return 0;
 }
 #endif
 
-extern int backtrace(const void **return_addrs, int max_depth);
-
 #endif
diff --git a/lib/x86/stack.c b/lib/x86/stack.c
index 5ecd97ce90b9..58ab6c4b293a 100644
--- a/lib/x86/stack.c
+++ b/lib/x86/stack.c
@@ -1,12 +1,16 @@
 #include <libcflat.h>
 #include <stack.h>
 
-int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
 {
 	static int walking;
 	int depth = 0;
 	const unsigned long *bp = (unsigned long *) frame;
 
+	if (current_frame)
+		bp = __builtin_frame_address(0);
+
 	if (walking) {
 		printf("RECURSIVE STACK WALK!!!\n");
 		return 0;
@@ -23,9 +27,3 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	walking = 0;
 	return depth;
 }
-
-int backtrace(const void **return_addrs, int max_depth)
-{
-	return backtrace_frame(__builtin_frame_address(0), return_addrs,
-			       max_depth);
-}
-- 
2.43.0


