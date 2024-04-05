Return-Path: <kvm+bounces-13673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF3E899813
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548411F2345D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCD715FA94;
	Fri,  5 Apr 2024 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7ICoocC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351E1145340;
	Fri,  5 Apr 2024 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306289; cv=none; b=ukXIlaQhAgAFwWGeZQPfKInqRrUMLdtINjoW1uUipUQ9S1rKltZgjdS/W+diRcYiQRZjP+ofC53MUmxyUYBWstpai3pnIRov+OccwHbvWMAca3yh0NQXmDBXqA5y/jZVcfqKBZWHrPjTE4dqHYSXPpiIT1v4StegkrWm80mhwX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306289; c=relaxed/simple;
	bh=7yO6yPDHGesSmeOkN/fR8ci49hsn9kz43K4p5e/8WBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPyp+ab04/PLA2TuCdlxf5tfmbkHmYsytSzVlFrSaxgNbv1avFXRE5DPiOce7ETg9OonSymviWyxkMACrMldioKcbTy7TXDiDVPXKHrOS7CHBexJ2aWYlpDIJKuwrOU4MPLOHHxR/o7X/xRXUKU3gQGVo/2BLupRC00KtYqwBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7ICoocC; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-369f3082524so9070115ab.1;
        Fri, 05 Apr 2024 01:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306287; x=1712911087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGCyPgl3I2RhYB72u4qf5QL0i6/5w7xwNKgPUqw6zXE=;
        b=l7ICoocCNkIi2YZdv7IbL3mmqh6w8cOCWlqq9CYSEVQWhHLIWm6aQcNOfUqnwzKDLo
         hTkyQRL1pJ+zv1zo+53RKi8sxZQpwN47pcVc9pqsA1U/wuHh8SjJLPS82RRRuU1rns+Q
         LnMVMqEXXCS0+06Q3N+EnhdhNrvb8+E4MSjjhzasRXrx68CNtd1b+CMqh/nvYiRsMZBI
         BIpGRoUh94p0icBWPHYlQH5Fk1+iohDfQzruikS92Qan3XLoE7go2VipOCNffh1ePOYH
         L0V8otZziJPpRxZDVNW0EZdrLErsGUjxcAjgZhEgiUfi1430FNqusj+i1IoXmEuXIVL6
         ZDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306287; x=1712911087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGCyPgl3I2RhYB72u4qf5QL0i6/5w7xwNKgPUqw6zXE=;
        b=b4PGvOsgWRH62kz91MwIwTEOqfKO1e4apBSFluJOZBqZvG4ELSTLKkuhEg8ZSMmO0w
         ouxR5ObpvWXovSj35m6xyceZc7EzmLjYzwZRHyHQczslErC1h2Jd8RuHdmwNJeDLUgyS
         1VxGkYdtNXE/BVabhUd2BSvn9r5MX3ismE68/kgKy3aqwbGAF11ni5cKCdLEkPpg+Oes
         C1K2lkfNC0oI4QD5HO4yHB5FEZra3oVeQdB0NG4Ii0HI5C62BinKfbAJxiYVU+pemjI6
         /8AO3U5U815ZWH/BYNnqpGs4KGthBK5sXsCAPslc/bKdhCpvgSa/5I0L1j4pOCFcdX0J
         RSyw==
X-Forwarded-Encrypted: i=1; AJvYcCWLLA3gyDSPIuQtfU8uH9/3Wd6y7mWkCQoU0FJKeHKyTWZuPyCUzyNq2T4jroLnsfHmfRn1ZrjrtlWVxRoafvYWentuY1SF53PwaNJDnOOHO/rG5zOiOuNQubx+8FHRpw==
X-Gm-Message-State: AOJu0Yx4g1zo9jO+VLogpY96cLZYKVJKfiD42WS2qagOhUJP3cMwHery
	iHZNDi6NHKiQ7g3nXrlsbpVmQlT5SbcH9c35CgzfGuFDxTEXPlN/
X-Google-Smtp-Source: AGHT+IEXdRMMtpxkTXLY1QR9+bDc6JrDHOZHEaNaHrlHrdrhRUuA/h4JbDJfUfZ+VZMIfoOk2EDb4A==
X-Received: by 2002:a05:6e02:219b:b0:368:a856:aa20 with SMTP id j27-20020a056e02219b00b00368a856aa20mr661890ila.20.1712306287401;
        Fri, 05 Apr 2024 01:38:07 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:38:07 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: [kvm-unit-tests PATCH v8 33/35] configure: Make arch_libdir a first-class entity
Date: Fri,  5 Apr 2024 18:35:34 +1000
Message-ID: <20240405083539.374995-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
index e19ba6f0c..a1308db8e 100755
--- a/configure
+++ b/configure
@@ -216,7 +216,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -286,8 +285,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -336,6 +337,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -346,6 +348,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -355,6 +358,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -417,10 +424,11 @@ fi
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


