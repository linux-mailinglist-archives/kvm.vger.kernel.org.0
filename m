Return-Path: <kvm+bounces-26489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5841B974ED6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF5728C1E1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D23185B7A;
	Wed, 11 Sep 2024 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AaD3VHre"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5454917B51B
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047555; cv=none; b=IH/q+h9g3bebS1JGWDKNSrNiF1C3VwoWpl9HhV3Cp2WIIaACCdXufnjntn8dNi5+8zWuDHBfSez4Hq6qRysvvyNnnir6G7rIyPNL4d3hHNCSPFeIjylVBOFKMyv6M9w/G1oFpAQriBAHhanRZq9ZlN5Erp+xwP9jJplehnuc7Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047555; c=relaxed/simple;
	bh=v+SJ9S9+ENtV68LcwakIPn2ItID5XnVo3RVpfvwmIc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uo20V2GqJp58gCVk/HkMCQUMEh9jXdV1tgAyl5Z5hVEYBqR5sU6KhR3qt00+VNGVOdjgexO+NuUAhXKyLDrXq8RYLLKmse9rQPKcJnIAltyx21eB1ddLPtYTWrx5OWXxP53eWBas1U6N9MjxMAwq/LxqAAnbFOZpPpC2zYiWo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AaD3VHre; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726047551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8wR2Pk4yNZTknFQ4i4hiIGto/+UC5b82Kz7yZd88h2Y=;
	b=AaD3VHreJl3vAtHYJmc53KOTAJOb+al8Z7u4z3n3UyiM5nQ9n36D5SLsAnTuqhw9PZcmDZ
	Bvcg9k8wAhuRUdZTyY3dpgRJNR4nnNL7trO6hsREb87Ui08L2U51v73SZX6cFS7mnmWw34
	1pxmlrTZzb4XAHv0XJ9evOJjzfrNgLc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	npiggin@gmail.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2] lib/stack: Restrengthen base_address
Date: Wed, 11 Sep 2024 11:39:09 +0200
Message-ID: <20240911093908.142619-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

commit a1f2b0e1efd5 ("treewide: lib/stack: Make base_address arch
specific") made base_address() a weak function in order to allow
architectures to override it. Linking for EFI doesn't seem to figure
out the right one to use though [anymore?]. It must have worked at
one point because the commit calls outs EFI as the motivation.
Anyway, just drop the weakness in favor of another HAVE_ define.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
v2:
 - Allow an arch to override base_address without CONFIG_RELOC [Nick]

 lib/riscv/asm/stack.h |  3 +++
 lib/riscv/stack.c     |  2 +-
 lib/stack.c           | 12 ++++++------
 lib/stack.h           |  2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
index f003ca37c913..89dea3d2bea8 100644
--- a/lib/riscv/asm/stack.h
+++ b/lib/riscv/asm/stack.h
@@ -8,5 +8,8 @@
 
 #define HAVE_ARCH_BACKTRACE_FRAME
 #define HAVE_ARCH_BACKTRACE
+#ifdef CONFIG_RELOC
+#define HAVE_ARCH_BASE_ADDRESS
+#endif
 
 #endif
diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
index 2cd7f012738b..a143c22a570a 100644
--- a/lib/riscv/stack.c
+++ b/lib/riscv/stack.c
@@ -5,7 +5,7 @@
 #ifdef CONFIG_RELOC
 extern char ImageBase, _text, _etext;
 
-bool arch_base_address(const void *rebased_addr, unsigned long *addr)
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	unsigned long ra = (unsigned long)rebased_addr;
 	unsigned long base = (unsigned long)&ImageBase;
diff --git a/lib/stack.c b/lib/stack.c
index 086fec544a81..cab0d416ea12 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -11,10 +11,10 @@
 
 #define MAX_DEPTH 20
 
-#ifdef CONFIG_RELOC
+#if defined(CONFIG_RELOC) && !defined(HAVE_ARCH_BASE_ADDRESS)
 extern char _text, _etext;
 
-bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	unsigned long ra = (unsigned long)rebased_addr;
 	unsigned long start = (unsigned long)&_text;
@@ -26,8 +26,8 @@ bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned
 	*addr = ra - start;
 	return true;
 }
-#else
-bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
+#elif !defined(CONFIG_RELOC) && !defined(HAVE_ARCH_BASE_ADDRESS)
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	*addr = (unsigned long)rebased_addr;
 	return true;
@@ -45,13 +45,13 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		if (arch_base_address(return_addrs[0], &addr))
+		if (base_address(return_addrs[0], &addr))
 			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		if (arch_base_address(return_addrs[i], &addr))
+		if (base_address(return_addrs[i], &addr))
 			printf(" %lx", addr);
 	}
 	printf("\n");
diff --git a/lib/stack.h b/lib/stack.h
index df076d94bf8f..c92112c1744d 100644
--- a/lib/stack.h
+++ b/lib/stack.h
@@ -34,6 +34,6 @@ static inline int backtrace_frame(const void *frame, const void **return_addrs,
 }
 #endif
 
-bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr);
+bool base_address(const void *rebased_addr, unsigned long *addr);
 
 #endif
-- 
2.46.0


