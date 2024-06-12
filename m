Return-Path: <kvm+bounces-19403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6488F904AD6
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6284B243D7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B461639FD4;
	Wed, 12 Jun 2024 05:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQcBGwsn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F938FA0;
	Wed, 12 Jun 2024 05:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169849; cv=none; b=Yaqey5vBDds4PV/2b0eH9LybCH8X1n5hsCjR7PjYy2LigJQROdL6Tweln0L6gTf0p5qApgC9qVh5SYZZYT4t/COX+3ceW+dLHzDDoUhAmd/izHpeOX11jSpOWID8AT5uer2CVtviYAFCUA4yClWThZfFi/7N+sAJ50kWVEDqDdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169849; c=relaxed/simple;
	bh=RymY7PnAv6b7tpTyJmoUZ0kfNOhoGlBV1AlNrgFlVCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K046YaYIAF9KCq7IG/0N4mh5SUQgUXE62iJ3nwfAHB4CNiYLM5NRMrab4rvOrjPdHuM55KhauVuCb20Rgmtswe5+3/9Q00dBfRV8xT16DYp726MhA6ti9i9SlrPsXqgWc5WZg4slSeYwA1mnUtJlFBmIzU4+v1xtB7xu8e/q+k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQcBGwsn; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f717608231so20668255ad.2;
        Tue, 11 Jun 2024 22:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169847; x=1718774647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQuI8YGQgLmsUNQvvWuFnLsfcid8kBB0k+CZ86TDvAk=;
        b=XQcBGwsnhOJqNLYHTSb6anx7s+7va6ZUZYYZGHEsPidBjhvozmPeJvinrxYzzNvu34
         8f3IaiYfkUCBs4s3Anc5HeV6MKlkDXlR+0hSjdxyaq2Ass3Fz+OSQoEHX4AVd58ByOyd
         RRx/wT3RW1PB28/5efNPJ9wYbneaQGb4jEDxPmpWzOTndMjyi8rYiE2WSaoyEOgHnHpH
         4YOZr/JCWjRAZtTiKfGZ14v7I/QU2EIH9q9MSXsT4nC9DFQzUSCBkBhkZVrmPNECgp4R
         IojzGCoYwBmhQfA1QsTh7X/w0r3uIQAFUKvlBhl/R+rgbj4r2uKTFkR7fSFFeUyMky49
         NhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169847; x=1718774647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQuI8YGQgLmsUNQvvWuFnLsfcid8kBB0k+CZ86TDvAk=;
        b=qSHYEfN/LUoTpKEktHBi3QzRFfBze6dd5wPSVoI+un8UWaH+CyzbAUeafRyu9D+i6n
         +FrLvV1l1SFVGmut8unkXHEFvSpLpPYIq1mciYijL5howjzefQWvt2ICN6Sm7js7oAT6
         uTte+J+194cnPZLIACmYRrLZJkMJPYNQJuJ8b3GOMTqVbSGNmD5JAHysMQuGwBOoY4JG
         RzNUtIvY1BQhXC9p1MM2+ijc3O951ahZFHcBOZjTQiuI/y1nTcPlYEMz6Dxih8zESf3i
         k0D6HQwLphjEl8l24c/9hpBS2Tug6zrtDnGnj7UTiNB6+ACn5ixo+2ycvoazyvpAlNoW
         AdEA==
X-Forwarded-Encrypted: i=1; AJvYcCVcEp1eYxG9XmD2Yf1VR9o6lnKxZpibp+85KkXJl9caminWoFURki02NfGXJCBOj5tpDym5wUO0kESgv7BYqNiLmqMWi4pBiF+A6ux2EhVvZt3N9QLmZ1+kXCFQbDPnVw==
X-Gm-Message-State: AOJu0Yyp/oTkuf2lgN9l3DArV7kdOAtLPLoVxVhxwqpV7YF2A8iNitmS
	cbGUXkdgy9W/XCNIcTYiQUMVeU2GyCcVfAwDicQhe/FNatpc2YYB
X-Google-Smtp-Source: AGHT+IGibBQ31aFbHM2KNIyG3WXGmC6uDThIWGe0iAzdMLifnbTThBiAhC+djmwgDB3YyNkgibzPkg==
X-Received: by 2002:a17:902:ceca:b0:1f7:969:7e87 with SMTP id d9443c01a7336-1f83b666b52mr10420065ad.35.1718169846856;
        Tue, 11 Jun 2024 22:24:06 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:06 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v10 09/15] configure: Make arch_libdir a first-class entity
Date: Wed, 12 Jun 2024 15:23:14 +1000
Message-ID: <20240612052322.218726-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
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
index db15e85d6..b93723142 100755
--- a/configure
+++ b/configure
@@ -217,7 +217,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -285,8 +284,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -335,6 +336,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -345,6 +347,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -354,6 +357,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -416,10 +423,11 @@ fi
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
2.45.1


