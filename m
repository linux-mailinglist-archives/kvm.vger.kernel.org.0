Return-Path: <kvm+bounces-23638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E9094C1A8
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B4F28579F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBAE18F2D6;
	Thu,  8 Aug 2024 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SEIUNKdH"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34718FC8C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131762; cv=none; b=HE/jbZuzif0xpJATZFViJmpXvsH2GzjTZ7rXOFKc+z8tnaSMs80tDj/qZcxucDyEGvMI2eeBI5jj5884y935IC5EKROXjbQDv52Q9Rysac1BPgy0SlKiuAtX6aE2bcR/jpk74W2Rz2ibWpuLiGLNHEQ3hzShY6cOGXTpw1tle6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131762; c=relaxed/simple;
	bh=uiXQyD9lmTCAF9P+n5F9n1i9EzOipXcBsoGpy1BJ1hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC/urqM/IzAbgPhDjLkCJj/fyOwBfUtRdepy7+ab/7oNreBmRozR2piTnGcex/egA0e6FpJVdozK45Lxw27J4BrtfX2sWtdmqO/9+QoaAN9F6YA7t5evWyVwZeoBWEMPY533jysHrgpxnszYtxXa4HTV91DFCNKn+vYvNvndavQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SEIUNKdH; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oA9KmlKZBLE/Aw+uRRLrNfgxq/FHBz/gMkuU++tzyD8=;
	b=SEIUNKdHpzxfruEtT/QF4MteMcfKQY/W9IUp4DyPoZ/LUXYxOLQtj0G2q+HOHS753P5i6R
	Wc2HzBgSEMLqwjtSPSQEfsOj5MeB2pKAz3YAy5aKYoALsPwTDnhcS2Pj5kOz/VsN0AHm/G
	VZiYMnVprZugKX5p/t8U+3P7LTj+5JQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 3/4] riscv: Fix out-of-tree builds
Date: Thu,  8 Aug 2024 17:42:27 +0200
Message-ID: <20240808154223.79686-9-andrew.jones@linux.dev>
In-Reply-To: <20240808154223.79686-6-andrew.jones@linux.dev>
References: <20240808154223.79686-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

My riscv compiler doesn't seem to want to create directories as other
compilers are apparently doing. There's only a few of them, so let's
just manually create them in configure. And riscv also needed
'-I lib' in CFLAGS.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure      | 8 ++++++--
 riscv/Makefile | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index db15e85d6ac7..27ae9cc89657 100755
--- a/configure
+++ b/configure
@@ -418,12 +418,16 @@ rm -f lib/asm
 asm="asm-generic"
 if [ -d "$srcdir/lib/$arch/asm" ]; then
 	asm="$srcdir/lib/$arch/asm"
+	mkdir -p "lib/$arch"
+elif [ -d "$srcdir/lib/$arch_libdir/asm" ]; then
+	asm="$srcdir/lib/$arch_libdir/asm"
+	mkdir -p "lib/$arch_libdir"
 elif [ -d "$srcdir/lib/$testdir/asm" ]; then
 	asm="$srcdir/lib/$testdir/asm"
+	mkdir -p "lib/$testdir"
 fi
-mkdir -p lib
 ln -sf "$asm" lib/asm
-
+mkdir -p lib/generated lib/libfdt
 
 # create the config
 cat <<EOF > config.mak
diff --git a/riscv/Makefile b/riscv/Makefile
index 7906cef7f199..179a373dbacf 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -80,7 +80,7 @@ CFLAGS += -mstrict-align
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt
+CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
-- 
2.45.2


