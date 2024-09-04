Return-Path: <kvm+bounces-25846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA82996B944
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17CA71C22428
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36851CF7D4;
	Wed,  4 Sep 2024 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DfwOsMng"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2431D04B5
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 10:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725447037; cv=none; b=Ht746d6gQzy/AogneYEYkslZXtoI5ylPX1x2uWSZRQWupvJkJ820sDjl0Ik8KtUMj98l85WnpnjVM+qB/S/w7hi1mTpFeYxbCN8v0IlDPtN1Ihz46jk5/dCNCO2RrMrQaHM85kIM3DGG2kiPvtHKjcDjzz//C0zYbP3aWUWQu8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725447037; c=relaxed/simple;
	bh=Q3Ny5QYwiNVG6Fb/xjDCT3wOQ8fTEU42alD0HlNkoy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYld0NKxRiNgi9BdcowlaS66P/sWtQiVOEj419x6zKDZ1Gdqxcu3QLbYFcldACXGh3r3F/MTQKClqMdMp6uQRBBRCfxkAfDjQ/PF2dhWOCJz1hVXdWrcxh7xlAV5M4ah6HES6Rl5+NirgXnf4sC8wiVcTZvmPQqpARWCBSktF/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DfwOsMng; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725447033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNTcbcoGqC40B7+iBoWPEf68cZWl3EVbLygndY9kHOM=;
	b=DfwOsMngKluH7GcwpljWLkvl87ksYQ8YxID4gdUeq1JHuXHhquhhB8ZkS0lyS0SDeJM5r5
	Kx4zUoP/Mfrs3I0ob+gaRCdkORb+wS1zh0ygqm2KAu2Wp4xP89OKPsUT3u1SpsThTQeYqe
	H8Gh1/16xHhT8yEcunySMkEsqwIaYeA=
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
Subject: [kvm-unit-tests PATCH v2 3/4] configure: Support cross compiling with clang
Date: Wed,  4 Sep 2024 12:50:24 +0200
Message-ID: <20240904105020.1179006-9-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-6-andrew.jones@linux.dev>
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
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


