Return-Path: <kvm+bounces-9834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA01867107
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D1911F28F49
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721975FB84;
	Mon, 26 Feb 2024 10:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbwyWLm7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9C85F865;
	Mon, 26 Feb 2024 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942487; cv=none; b=Jm6nVV06L4zn6FQS7BYbYJotevdu6CjMU88ZHXq7m3lxol0Z71C5jBxXwL0NHuBrctKYCEOXfNkbIjPDYWvyAYIrYGsLzLeZdOC6THaSdwg1NM9I6GsinBEbf42908tYqalsYuqpbLzvvAzKwFIYZ7O+gA3J+UMEhf5vd++G2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942487; c=relaxed/simple;
	bh=8udX0cgp93MszWyZ03GEI7NLIrdSXlIepkA+ThFw9Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LIkv5lA+tB970rx8dUeLHmoLouM4vlH4SMEfggTPIzJN+yYI/rUBoswqM6meSQKgV/0Yk5XGQYHQva4KyJ1ePZC0W3TYwV4ME2AiWDDQarouFjQk+eLL0rUzAdYbmkJZAlfS52cYS/tMQmE7j8+5Urt6HyVyDAmmQXx6zOl/U7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbwyWLm7; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6de3141f041so1633534b3a.0;
        Mon, 26 Feb 2024 02:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942485; x=1709547285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A05If4ES6byzPc96w4d0O/4phtiePSkwA25rkb54AlQ=;
        b=UbwyWLm7lV/CNpOisW5kN/OplmbFJr2IWOdalHk9DGfTqHvntpwIQsa1dRKah5EPJ6
         rN1wrXme4gRQFMKXhAaVD7G/6o79llzU8fjBAtkxrFHRga+jlkaiowNRmwVbZ2rRfQHX
         fhNXY8z6bQBNLf1n5nxgM1pNwEe2gW4uUdKtep+7PZ3AD6AE75nSF4E13J3v4mQhWOK3
         VB+pwRMUFRwdFckJBV/+uYkOF6SlT3QXnVnqe38UHO52j8USB+ShdspA9Rg8kJhja1um
         nZInLYnc3GS0kY1a+oxOf2t+rVIS0VGRpRzvz59KHAq+cRnzYj1bMRCpII1PDljjtHfB
         nxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942485; x=1709547285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A05If4ES6byzPc96w4d0O/4phtiePSkwA25rkb54AlQ=;
        b=j5HoZFjK9Q9D0ACICyUJuB/eaLdmDxWfZ+G+3YVmC30waSh1OoLd6UqFYyZKCOzQ7l
         cE+Ibnmps2bFoy7MeddiufJMevrNYBAtFm4lUa+YOqesfWvUEDf34umSFAhjXkhc1jsn
         OPH7Uefzs7+f5rJDv6Nuk8ZiWKYibFAoUp0FnokAFjc7oepMxOpl4M2705NVZEVpklfh
         Uux+hZRzd3g1cdeMQ1o1TevufkIU6MuKtMzFjD7jrhl89pWPG+1Nfi6djq/vZ/P2YYu9
         nzCwfqd5T1Ac8wAc/wTRiqu1dedoIC77u3k2NpYAmrrBO6h1CjosQAXFQ0Una9RYd7jv
         wSIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuvUd20nfXZYck162/2Vmssrleo8q/cl3Xs7D7Z2sGcsGooK/X4TPotoPAddWcLZo3gddJsSKpsYGfGVAKmCTJ1m0YjGPHf/gTTuQk5vo3xuYxxPb1Jh8tcgW+Q90u8w==
X-Gm-Message-State: AOJu0Yyp3OyytYBkK91RjlUP6BHh8RZ4mKaO3mPf+1Qdzw05MGjC3okr
	uPfsqGIFd6bTRH47nyjkSZMrH5lrTW/B9PrZePJ6ThH0w4C3EgkB
X-Google-Smtp-Source: AGHT+IFkY1GIJLB6yWYGNglDakT3fA113fKaZeKyFRaTRQxO85354Z4DQShb9ESUASscSl7tU+qTAg==
X-Received: by 2002:a62:8497:0:b0:6e4:4a26:1cbd with SMTP id k145-20020a628497000000b006e44a261cbdmr6206179pfd.2.1708942485627;
        Mon, 26 Feb 2024 02:14:45 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:45 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH 30/32] configure: Make arch_libdir a first-class entity
Date: Mon, 26 Feb 2024 20:12:16 +1000
Message-ID: <20240226101218.1472843-31-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
Cc: Andrew Jones <andrew.jones@linux.dev>
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
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Makefile  |  2 +-
 configure | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 4f35fffc6..4e0f54543 100644
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
index ae522c556..8c0e3506f 100755
--- a/configure
+++ b/configure
@@ -199,7 +199,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -264,8 +263,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -314,6 +315,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -324,6 +326,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -333,6 +336,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -395,10 +402,11 @@ fi
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
2.42.0


