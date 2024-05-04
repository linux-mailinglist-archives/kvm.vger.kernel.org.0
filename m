Return-Path: <kvm+bounces-16591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0168BBB56
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6ECF1C21419
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9703AC0C;
	Sat,  4 May 2024 12:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQLcFLMx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519562901;
	Sat,  4 May 2024 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825844; cv=none; b=Yi06TPyC6PaoZ5oHN0Y0syIl5IkClyUzJktDFBcmOGWSkaKraDjapY2o7Cbr8/8lqkaqUsH7IfIUSLrmOetFxrIFz+JK2ldqzvyOL/RCqOzQRmaJnGqocWd4aczB4iFlXoITcD2Gmy+sat07cMjhosZifQwLgS5eHsH4sHpZO0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825844; c=relaxed/simple;
	bh=jsNTji5NnHKuzmZV80n+3e06Y8Wp0HEd+qIk+38OFKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Evc7+AgXFgovN0Yun9kiBTIOm2u6YHDrzvvhA+6tFChFVLXRlsSmIdQGsKPpGEWukHcEe5Ns4LcJh0LRS1qLvKZbUvCwa1OLHN8eeYqChd4JetMExY7c5U7ghVHmyjt0qOJoRMb8BuIAxmUNdNRl1b7i2kuSqPwY9WGUHC01ExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQLcFLMx; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f4603237e0so114013b3a.0;
        Sat, 04 May 2024 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825843; x=1715430643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e7S6CmFvKeffkGPyTCOL8jP7a0oCwEqBFa0CpbZAAo=;
        b=NQLcFLMxiknUonuBgR9QHqhGJd49wXflLdRHmKpOkKQNDufntu1zMh1dn6Vzy45W4d
         WtWY3vxrWXJ7EuQQaE7SekZvfQcGkVzs9fq0IluMkrfB2deBSL4bsXsEq/856ugHRZ7r
         ikIM1fVM/TnNE1OqZJLJIPDiGH7GWQUdxAQCmRHNjVKanIANHRl+30U2Ay23fAbwwzA7
         nNvv1tTOSTCKRz6S4az13lLM/Hc6BjUxK9r+jjM403W79QIQg2Mqqgx461/NAXcIlj/y
         jqM05VizrXXboMKdgLys2I5G7Aq8S14sYMlLoXvKv+ynO/NTUukCHQQkP+gK6qa6u4wi
         PNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825843; x=1715430643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5e7S6CmFvKeffkGPyTCOL8jP7a0oCwEqBFa0CpbZAAo=;
        b=V+O46Xro60vR+O+EDzsxxlHumsU38uuk7tONZeWs0J6PRmbnanOJnelfhGVEFCO186
         ql3VbF+uXCt7YatgHD4SBaS8eTeFDLYcwUVJKUZ7IOXG0ssIFKkIvuGpF4AlidAb7i7/
         culZhQ/KcynB5WFFRwgTJ39X321uNyUeNC71JJ3+ALcr8dGmjxl1nXMSj3cbfqGEJsfY
         k4yNCkWhkyA6cN0HAwtHuTtM0kqIoMQs7IGTI01yskFIrO4hvkAFd0Ui2gRdAjzZTqSu
         cgFU22pkGSEI0WXwBjCXRrA7hYkmauldszVw0XkWzzlsU7upW4Av8nKHKbn0kdB9OxIq
         LdKA==
X-Forwarded-Encrypted: i=1; AJvYcCWlrZba7WodxTXb7hsjLl7lIUUUtQtLvKgC93umgGQKb5zixLiWDV9yd0F/se27hEFZNOurqieAFjfroyr700IKGLYNx397RM0BduxMok/50kVflj6K43uXzX+7KR/BuA==
X-Gm-Message-State: AOJu0Yymbecq+OWVNhJkTeN8QH47RMDv4N10yBrSHsaixgoHjDBv5pSH
	5q2wpU2EkLnDKAbP1B9gYQgwNqI34tnFpvMD/0OhKa4vq8YWwUGx
X-Google-Smtp-Source: AGHT+IFPZkfPU8Egb2mh6EBzGgW9QChyXJexPKHvEKB5uBRSLxU0nzgY3U6aLmK8CozI1eiDyMOazA==
X-Received: by 2002:a05:6a20:8420:b0:1a3:b187:f261 with SMTP id c32-20020a056a20842000b001a3b187f261mr12634372pzd.29.1714825842756;
        Sat, 04 May 2024 05:30:42 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v9 28/31] configure: Make arch_libdir a first-class entity
Date: Sat,  4 May 2024 22:28:34 +1000
Message-ID: <20240504122841.1177683-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

arch_libdir was brought in to improve the heuristic determination of
the lib/ directory based on arch and testdir names, but it did not
entirely clean that mess up.

Remove the arch_libdir->arch->testdir heuristic and just require
everybody sets arch_libdir correctly. Fail if the lib/arch or
lib/arch/asm directories can not be found.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: kvm-riscv@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Makefile  |  2 +-
 configure | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 5b7998b79..7fe93dfd8 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ include config.mak
 VPATH = $(SRCDIR)
 
 libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
-ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
+ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR))
 OBJDIRS := $(ARCH_LIBDIRS)
 
 DESTDIR := $(PREFIX)/share/kvm-unit-tests/
diff --git a/configure b/configure
index d744ec4dc..2b788d0c8 100755
--- a/configure
+++ b/configure
@@ -216,7 +216,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -284,8 +283,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -334,6 +335,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -344,6 +346,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -353,6 +356,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -415,10 +422,11 @@ fi
 # link lib/asm for the architecture
 rm -f lib/asm
 asm="asm-generic"
-if [ -d "$srcdir/lib/$arch/asm" ]; then
-	asm="$srcdir/lib/$arch/asm"
-elif [ -d "$srcdir/lib/$testdir/asm" ]; then
-	asm="$srcdir/lib/$testdir/asm"
+if [ -d "$srcdir/lib/$arch_libdir/asm" ]; then
+    asm="$srcdir/lib/$arch_libdir/asm"
+else
+    echo "$srcdir/lib/$arch_libdir/asm does not exist"
+    exit 1
 fi
 mkdir -p lib
 ln -sf "$asm" lib/asm
-- 
2.43.0


