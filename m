Return-Path: <kvm+bounces-26487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2B7974E54
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C73C0B282FF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89A1185B73;
	Wed, 11 Sep 2024 09:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kvJKJTyz"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E6185924
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726046075; cv=none; b=rcrqhlHW0YUwLAp0Z0CUyv+nhiMG0qwmzXBZdwygOvyddkfcS+lFnwe1TLp58ZnOhgtaydIQVetRWnKBJWUHCZjag6i4djftjTMAh5hp5FmvIs09PaDTX4k7YTGpsSwT6AtYbt0YzN5rA9bGdHMvd1Yt3AqLyv6NSTbJht6pv3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726046075; c=relaxed/simple;
	bh=1bu+FQXJvPiVQ1WN8UQ38mFrRZaCw6Ha52LpkdRKPu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPv6LVvLivVmqGf+0xigQx9YwhWjaZBvP6dI2K69YwjRR87tELrkXQBqsIzp7r9DHvH6LjsF2/OLZknb670yVzcpTmuZCuQQlvsK2H33MOXAHIbkYOwp6zocmzh8+1ia99I1z+hGekKtDsvN0DBrfYtqFicWVauhu3ZLY+zeoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kvJKJTyz; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726046071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtkZ2ndqa6RRIHxpRtEfZPe4ynCm7zVypuZ3bs/mIVA=;
	b=kvJKJTyzy6/oa6wrDUhUrfV6A9jOvecWoWd0cPy5Q/L7HBUALkRDu7Y55grHtuQnoCclCJ
	QNbmDnB+s+iinrVd0DEJ5iBSfY/mZOVza7kFm7RZGobq2AV4wJnAzdF8QlX43/DrOB6g4K
	kKDmoefNcZGmug1DHpbtXxxEjb0EQxw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v3 5/5] README: Add cross and clang recipes
Date: Wed, 11 Sep 2024 11:14:12 +0200
Message-ID: <20240911091406.134240-12-andrew.jones@linux.dev>
In-Reply-To: <20240911091406.134240-7-andrew.jones@linux.dev>
References: <20240911091406.134240-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add configure command line examples for cross-compiling, for
compiling with clang, and for cross-compiling with clang.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 README.md | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/README.md b/README.md
index 2d6f7db5605c..be07dc28a094 100644
--- a/README.md
+++ b/README.md
@@ -17,6 +17,28 @@ in this directory.  Test images are created in ./ARCH/\*.flat
 
 NOTE: GCC cross-compiler is required for [build on macOS](README.macOS.md).
 
+## Cross-compiling
+
+A cross compiler may be configured by specifying a cross prefix. For example,
+for arm64
+
+    ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu-
+    make
+
+## clang
+
+clang may be used as an alternative to gcc.
+
+    ./configure --cc=clang
+    make
+
+clang may also be used with cross binutils when cross-compiling. For example,
+for riscv64
+
+    ./configure --arch=riscv64 --cc=clang --cflags='--target=riscv64' \
+                --cross-prefix=riscv64-linux-gnu-
+    make
+
 ## Standalone tests
 
 The tests can be built as standalone.  To create and use standalone tests do:
-- 
2.46.0


