Return-Path: <kvm+bounces-10273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A54A86B2A0
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24CC5285365
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735A315B11C;
	Wed, 28 Feb 2024 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I9KQ1qvr"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3114AD28
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132681; cv=none; b=PY0hYJZkUmhBAHEvna3VZrmB0FdA4lpZrKFPtTwMI9SnNWaD3m/ieWmC8R3O0t8yVMm0T5EFVoXgJn1nZMUVw2HCX1aEL19/kZ7uxEIIviMJ6OZG08xUz/bt+jzPQFlr7A7uCVdeRz2Zp72H0dBjz6zILmjHln5A5Yp6ac+nJFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132681; c=relaxed/simple;
	bh=k2w9lGUiETvqTUHJzWKQ/tyXXe3SKQPW2xWXFX+896Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=CI3ULsGq3OZY9gx3AT9Kgdcs7OXvfOizyK9a6hqAHW74qZ5EOuYICC/dKSWzmIVtAJ3XUIy9Yn6RRnNlcVgh54vG3pEOYfwudUAiLoEqnA0Oqv0bbChVdOl9A5ykYi0+h0qQyLU08owPPjBK9wIfwWJqf9PiBFD9fmniPeAITmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I9KQ1qvr; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsxpfYpBZPIQGZFeeavdCAykha5uzA9p5hqzzpjOjmk=;
	b=I9KQ1qvrKDj7pHFgK7MCGSgnsUHbWq8jNpAV1xK92YuDifgAEhywTMwXQHhvT0IDoVDxCa
	2UbopFanDKNyLgiUk45LtDy6n/e1otex7TOQtwR7r3E3rt2WG3l3Z8S07ABtgQNed+e4yA
	O/XkDF1EgM7GBo0lDOeOFa0TfkWqPKE=
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
Subject: [kvm-unit-tests PATCH 04/13] treewide: lib/stack: Make base_address arch specific
Date: Wed, 28 Feb 2024 16:04:20 +0100
Message-ID: <20240228150416.248948-19-andrew.jones@linux.dev>
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

Calculating the offset of an address is image specific, which is
architecture specific. Until now, all architectures and architecture
configurations which select CONFIG_RELOC were able to subtract
_etext, but the EFI configuration of riscv cannot (it must subtract
ImageBase). Make this function architecture specific, since the
architecture's image layout already is.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm64/stack.c | 17 +++++++++++++++++
 lib/riscv/stack.c | 18 ++++++++++++++++++
 lib/stack.c       | 19 ++-----------------
 lib/stack.h       |  2 ++
 lib/x86/stack.c   | 17 +++++++++++++++++
 5 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
index f5eb57fd8892..3369031a74f7 100644
--- a/lib/arm64/stack.c
+++ b/lib/arm64/stack.c
@@ -6,6 +6,23 @@
 #include <stdbool.h>
 #include <stack.h>
 
+#ifdef CONFIG_RELOC
+extern char _text, _etext;
+
+bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#endif
+
 extern char vector_stub_start, vector_stub_end;
 
 int arch_backtrace_frame(const void *frame, const void **return_addrs,
diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
index d865594b9671..a143c22a570a 100644
--- a/lib/riscv/stack.c
+++ b/lib/riscv/stack.c
@@ -2,6 +2,24 @@
 #include <libcflat.h>
 #include <stack.h>
 
+#ifdef CONFIG_RELOC
+extern char ImageBase, _text, _etext;
+
+bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long base = (unsigned long)&ImageBase;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - base;
+	return true;
+}
+#endif
+
 int arch_backtrace_frame(const void *frame, const void **return_addrs,
 			 int max_depth, bool current_frame)
 {
diff --git a/lib/stack.c b/lib/stack.c
index dd6bfa8dac6e..e5099e207388 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -11,23 +11,8 @@
 
 #define MAX_DEPTH 20
 
-#ifdef CONFIG_RELOC
-extern char _text, _etext;
-
-static bool base_address(const void *rebased_addr, unsigned long *addr)
-{
-	unsigned long ra = (unsigned long)rebased_addr;
-	unsigned long start = (unsigned long)&_text;
-	unsigned long end = (unsigned long)&_etext;
-
-	if (ra < start || ra >= end)
-		return false;
-
-	*addr = ra - start;
-	return true;
-}
-#else
-static bool base_address(const void *rebased_addr, unsigned long *addr)
+#ifndef CONFIG_RELOC
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	*addr = (unsigned long)rebased_addr;
 	return true;
diff --git a/lib/stack.h b/lib/stack.h
index 6edc84344b51..f8def4ad4d49 100644
--- a/lib/stack.h
+++ b/lib/stack.h
@@ -10,6 +10,8 @@
 #include <libcflat.h>
 #include <asm/stack.h>
 
+bool base_address(const void *rebased_addr, unsigned long *addr);
+
 #ifdef HAVE_ARCH_BACKTRACE_FRAME
 extern int arch_backtrace_frame(const void *frame, const void **return_addrs,
 				int max_depth, bool current_frame);
diff --git a/lib/x86/stack.c b/lib/x86/stack.c
index 58ab6c4b293a..7ba73becbd69 100644
--- a/lib/x86/stack.c
+++ b/lib/x86/stack.c
@@ -1,6 +1,23 @@
 #include <libcflat.h>
 #include <stack.h>
 
+#ifdef CONFIG_RELOC
+extern char _text, _etext;
+
+bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#endif
+
 int arch_backtrace_frame(const void *frame, const void **return_addrs,
 			 int max_depth, bool current_frame)
 {
-- 
2.43.0


