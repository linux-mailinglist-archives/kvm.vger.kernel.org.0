Return-Path: <kvm+bounces-11045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAAF487254C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1F41C22BD9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C7017C9E;
	Tue,  5 Mar 2024 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sAuFu6sg"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6370017BD6
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658555; cv=none; b=RwyNnuveOeMrZpNZ2W+9uIYa1UZT+wSMSquq9KdYKXaRx89iQKp45hLHyfiyrkEJBD0jzL8XAdp+ODJzRF4nrZ3cb82Cq2x6EiNlANgea9YBOohPDHLJzt0NYzE7tjv5WgGBQ75Y5q7fFY9lZOtnDGwH354mz6aCkEknTwpVJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658555; c=relaxed/simple;
	bh=Yezht1ipfLb/srwvqxcFhwwxMoSS7/K230lHPwZVNBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=VaR2zuYddAt9Bl6WvsI4WN3HpCSQ5d6b4+yY2utxTMuBAJfwh88rJaZbbKjHTpcGz2uu6TcS9rX0UWr5Q5U6xZ7QS+wOMSWhnbSVhVOahX3I/qojComglUNu+A6rarzbAFiO4VAG9oaYvjXpL+jRWzoXseo3r7TP0C7i76zQgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sAuFu6sg; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR1xifVAx5h6gUNmz5l3WRqOq1HXM3U0Lr7m5JCv4N8=;
	b=sAuFu6sgoeAkj8bCIj6azUlP+vi15hGtQwiI0ux5UOlpIBJ0/m79tFYa6ntMpG+N4AzIaA
	zhhfmCJW97FNE3tWBblBtp9W4oTtmMLKZxeLIIsKM3QlCUHu315Fb625ZpU85H5tf5GT4Z
	Nr76DmoInFpBOmkaZ+sUJxsyELj1Gp0=
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
Subject: [kvm-unit-tests PATCH v2 04/13] treewide: lib/stack: Make base_address arch specific
Date: Tue,  5 Mar 2024 18:09:03 +0100
Message-ID: <20240305170858.395836-19-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
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
ImageBase). Make this function weak, such that an architecture may
override it when necessary, to accommodate the image layout. Then,
immediately supply the riscv override.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/stack.c | 18 ++++++++++++++++++
 lib/stack.c       |  8 ++++----
 lib/stack.h       |  2 ++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
index d865594b9671..2cd7f012738b 100644
--- a/lib/riscv/stack.c
+++ b/lib/riscv/stack.c
@@ -2,6 +2,24 @@
 #include <libcflat.h>
 #include <stack.h>
 
+#ifdef CONFIG_RELOC
+extern char ImageBase, _text, _etext;
+
+bool arch_base_address(const void *rebased_addr, unsigned long *addr)
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
index dd6bfa8dac6e..086fec544a81 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_RELOC
 extern char _text, _etext;
 
-static bool base_address(const void *rebased_addr, unsigned long *addr)
+bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
 {
 	unsigned long ra = (unsigned long)rebased_addr;
 	unsigned long start = (unsigned long)&_text;
@@ -27,7 +27,7 @@ static bool base_address(const void *rebased_addr, unsigned long *addr)
 	return true;
 }
 #else
-static bool base_address(const void *rebased_addr, unsigned long *addr)
+bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr)
 {
 	*addr = (unsigned long)rebased_addr;
 	return true;
@@ -45,13 +45,13 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		if (base_address(return_addrs[0], &addr))
+		if (arch_base_address(return_addrs[0], &addr))
 			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		if (base_address(return_addrs[i], &addr))
+		if (arch_base_address(return_addrs[i], &addr))
 			printf(" %lx", addr);
 	}
 	printf("\n");
diff --git a/lib/stack.h b/lib/stack.h
index 6edc84344b51..df076d94bf8f 100644
--- a/lib/stack.h
+++ b/lib/stack.h
@@ -34,4 +34,6 @@ static inline int backtrace_frame(const void *frame, const void **return_addrs,
 }
 #endif
 
+bool __attribute__((weak)) arch_base_address(const void *rebased_addr, unsigned long *addr);
+
 #endif
-- 
2.44.0


