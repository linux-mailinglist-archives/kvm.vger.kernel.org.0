Return-Path: <kvm+bounces-25773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD2F96A462
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B7A51C23E60
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A9C18C341;
	Tue,  3 Sep 2024 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QZSx9FlW"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBF518BC3B
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725381065; cv=none; b=TzjVZYlhr6DdgaTkZ++v5KrtJQgxQ2TMq0EQ/UAVzTV0r+X+x9aUG7V1ykERo80t7bQbstcWBm8UFDCzYdR3jBsYyVHakZcFStPtVLZu9mqQMpSRafhbbttKgwMXuEN3E3SFZXap57VR203g31r+8PqEWjTMFHiPI56Ggg1yTfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725381065; c=relaxed/simple;
	bh=JoVGmAznTB8rAuBFZfUmjldvgv18ZdbJysSiPzN86lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKHWuMmxl2KQj5hrfyJm2jXf+c2nXXrYSBaYqXdY7PR7wUHFRf5OB4O7tghRJp4nYQFFtpstDYv/3dYr3MvbrEsniLqi94lsJ2T5uphTkjkNYl9q9xLYdLPEAy3+rGVPVvCFNSkrYd0IunNcClpn5M4jQky/DpvvXspefnBKyJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QZSx9FlW; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725381059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9YGHRkZZZq6gSBTbmL0m4A7pOzURwmJyYm0zSj6RQgA=;
	b=QZSx9FlW5q/PKHaiVhKUcE209XR2Jv2S4PWXyQ+C2agSThKJDI3G35n7oWlu97ZlgiXY50
	NWkXNF5Pfg/x/RNjS/zCybHxNXq9ELm9dkqtnVKppPm1dm+hrrQOx7Ubqnb3lIfPcgqtJx
	psaZB3pKvx15c+peLES4B+uoKed0yPY=
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
Subject: [kvm-unit-tests PATCH 2/3] configure: Support cross compiling with clang
Date: Tue,  3 Sep 2024 18:30:49 +0200
Message-ID: <20240903163046.869262-7-andrew.jones@linux.dev>
In-Reply-To: <20240903163046.869262-5-andrew.jones@linux.dev>
References: <20240903163046.869262-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When a user specifies the compiler with --cc assume it's already
fully named, even if the user also specifies a cross-prefix. This
allows clang to be selected for the compiler, which doesn't use
prefixes, but also still provide a cross prefix for binutils. If
a user needs a prefix on the compiler that they specify with --cc,
then they'll just have to specify it with the prefix prepended.

Also ensure user provided cflags are used when testing the compiler,
since the flags may drastically change behavior, such as the --target
flag for clang.

With these changes it's possible to cross compile for riscv with
clang after configuring with

 ./configure --arch=riscv64 --cc=clang --cflags='--target=riscv64' \
             --cross-prefix=riscv64-linux-gnu-

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 27ae9cc89657..337af07374df 100755
--- a/configure
+++ b/configure
@@ -130,6 +130,7 @@ while [[ "$1" = -* ]]; do
 	    ;;
 	--cc)
 	    cc="$arg"
+	    cc_selected=yes
 	    ;;
 	--cflags)
 	    cflags="$arg"
@@ -200,6 +201,10 @@ while [[ "$1" = -* ]]; do
     esac
 done
 
+if [ -z "$cc_selected" ] && [ "$cross_prefix" ]; then
+    cc="$cross_prefix$cc"
+fi
+
 if [ -z "$efi" ] || [ "$efi" = "n" ]; then
     [ "$efi_direct" = "y" ] && efi_direct=
 fi
@@ -370,7 +375,7 @@ fi
 cat << EOF > lib-test.c
 __UINT32_TYPE__
 EOF
-u32_long=$("$cross_prefix$cc" -E lib-test.c | grep -v '^#' | grep -q long && echo yes)
+u32_long=$("$cc" $cflags -E lib-test.c | grep -v '^#' | grep -q long && echo yes)
 rm -f lib-test.c
 
 # check if slash can be used for division
@@ -379,7 +384,7 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
 foo:
     movl (8 / 2), %eax
 EOF
-  wa_divide=$("$cross_prefix$cc" -c lib-test.S >/dev/null 2>&1 || echo yes)
+  wa_divide=$("$cc" $cflags -c lib-test.S >/dev/null 2>&1 || echo yes)
   rm -f lib-test.{o,S}
 fi
 
@@ -442,7 +447,7 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
-CC=$cross_prefix$cc
+CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
 OBJCOPY=$cross_prefix$objcopy
-- 
2.46.0


