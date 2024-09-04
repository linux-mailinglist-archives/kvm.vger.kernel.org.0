Return-Path: <kvm+bounces-25889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEDA96C13F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2802B2833A6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013DE1DC1BE;
	Wed,  4 Sep 2024 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A33P9XQf"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7026A1DA2FD
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461475; cv=none; b=IEM/35s4Bb27yhOAQTun5YhC7knfQxunYFArRut5eXhp4aSzZH0EFx54cXNKFoPLmEqyv+PiQHvzxQWWSZO+9mxwRXkopwGLoBZk1xTqSW+YU7hAJXfRZ+N+OuMMnBkTzKajviOvUO0ISuBTiCdzZAaJqFJ92+7GiIpXC4gTNQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461475; c=relaxed/simple;
	bh=7UACZvlejfHAU4xUqoSQ094xYSNwEVvvmivZT6sMxfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HNSEHRI3RiRClRNMcFcFFVZV3n+BR5O47CKVChe5LzuupVRpFPIR+XEegg97CZiqD/51+1aOGGxjyDyOk45QFjeds7U04bvr+XujMCpM4y6nSwmqcr3MORJM7qRBfRNdmjQLcIakzHyxYT9AxfExcaiU4hL0/kJBgu8CuJOnenc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A33P9XQf; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725461471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XyUhI83VuuMlngHi4STFb6b0zA1dwEOmFbQvLmVNA6Y=;
	b=A33P9XQfLSDKwnQfNRRiC7Dlg7e0CdQMTMkSvaaKrAMidOR8iyjHlTbpkMDpnOqclNgdLu
	JcdV+LurlVIFJ95rray7r69SGNce4b5U4wz8zDWOGYi7j4Gt32I6egqbXpCib5HJar4RsF
	nD2Juw5Cn6FQZ/S771t13CjNADQBMXw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	npiggin@gmail.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] lib/stack: Restrengthen base_address
Date: Wed,  4 Sep 2024 16:51:08 +0200
Message-ID: <20240904145107.2447876-2-andrew.jones@linux.dev>
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
 lib/riscv/asm/stack.h |  1 +
 lib/riscv/stack.c     |  2 +-
 lib/stack.c           | 10 ++++++----
 lib/stack.h           |  2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
index f003ca37c913..708fa4215007 100644
--- a/lib/riscv/asm/stack.h
+++ b/lib/riscv/asm/stack.h
@@ -8,5 +8,6 @@
 
 #define HAVE_ARCH_BACKTRACE_FRAME
 #define HAVE_ARCH_BACKTRACE
+#define HAVE_ARCH_BASE_ADDRESS
 
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
index 086fec544a81..e1c981085176 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -12,9 +12,10 @@
 #define MAX_DEPTH 20
 
 #ifdef CONFIG_RELOC
+#ifndef HAVE_ARCH_BASE_ADDRESS
 extern char _text, _etext;
 
-bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	unsigned long ra = (unsigned long)rebased_addr;
 	unsigned long start = (unsigned long)&_text;
@@ -26,8 +27,9 @@ bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned
 	*addr = ra - start;
 	return true;
 }
+#endif
 #else
-bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
+bool base_address(const void *rebased_addr, unsigned long *addr)
 {
 	*addr = (unsigned long)rebased_addr;
 	return true;
@@ -45,13 +47,13 @@ static void print_stack(const void **return_addrs, int depth,
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


