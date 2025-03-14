Return-Path: <kvm+bounces-41118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E77AAA62079
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30F19421300
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F626200136;
	Fri, 14 Mar 2025 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TnV8vjkZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6631C860B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991673; cv=none; b=CY9hKNc0qAYj7XBSk5nNWUcllGkcpPDNMg49S3W7F915aHZvVfFqNMmhgrjPtMfMfhz6KlbFlk/ewxys29NAGwQyMEUCgCTh16qjuY3QKVQ4U+BomqVhYHDUcJHIyKuLpFJCCBRs/jjb/aLjpVZRYoVMUCnBX8pAH8QoZPnzmh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991673; c=relaxed/simple;
	bh=9DZX/1Jxjv6UN2bS4xJGHTcIILC/ktRxAbfNiXsSjE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rTA8cZYKzpC2bVyW3dCz0KCzrNBZqFp3wIwZL90jVN42qMpK6HFP2ci4UG0vrffsuYw6Tocn1G6VqH40cEsHVb8hAPKVZAGOmwtLSN1NEJ1tVy1HOZTrZ/6aap96qBqAV+eI76Blu9Nbkg7DD047Z3ecNpgzxNtx5vbaJqgMV/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TnV8vjkZ; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5EVH0/NArVzVFUXtnQSuZf+lcpdY8MXX8DKAvo4emc=;
	b=TnV8vjkZcoIaQvxXZkoTBoZ5Ut7Xw3eCzVZHnDZlBxdIUua3ioGN+2SuctOxcnGDHh9scY
	S8gAFmYvSX4ni8BH/kTruUhyDwR6rA9DiQ0u/3SfnCsZIuUJ8HhH8CuSemtu+inP43Rz5b
	hKpakBDfI1d9S3zRQ2482NfhlzY21Fk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 1/9] Drop support for 32-bit arm
Date: Fri, 14 Mar 2025 15:25:08 -0700
Message-Id: <20250314222516.1302429-2-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Linux dropped support for KVM in 32-bit arm kernels almost 5 years ago
in the 5.7 kernel release. In addition to that KVM/arm64 never had
32-bit compat support, so it is a safe assumption that usage of 32-bit
kvmtool is pretty much dead at this point.

Do not despair -- 32-bit guests are still supported with a 64-bit
userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 INSTALL                                   |   9 +-
 Makefile                                  |  31 +--
 arm/aarch32/arm-cpu.c                     |  50 ----
 arm/aarch32/include/asm/kernel.h          |   8 -
 arm/aarch32/include/asm/kvm.h             | 311 ----------------------
 arm/aarch32/include/kvm/barrier.h         |  10 -
 arm/aarch32/include/kvm/fdt-arch.h        |   6 -
 arm/aarch32/include/kvm/kvm-arch.h        |  18 --
 arm/aarch32/include/kvm/kvm-config-arch.h |   8 -
 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  24 --
 arm/aarch32/kvm-cpu.c                     | 132 ---------
 arm/aarch32/kvm.c                         |  14 -
 12 files changed, 14 insertions(+), 607 deletions(-)
 delete mode 100644 arm/aarch32/arm-cpu.c
 delete mode 100644 arm/aarch32/include/asm/kernel.h
 delete mode 100644 arm/aarch32/include/asm/kvm.h
 delete mode 100644 arm/aarch32/include/kvm/barrier.h
 delete mode 100644 arm/aarch32/include/kvm/fdt-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-config-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-cpu-arch.h
 delete mode 100644 arm/aarch32/kvm-cpu.c
 delete mode 100644 arm/aarch32/kvm.c

diff --git a/INSTALL b/INSTALL
index 2a65735..0e1e63e 100644
--- a/INSTALL
+++ b/INSTALL
@@ -26,7 +26,7 @@ For Fedora based systems:
 For OpenSUSE based systems:
 	# zypper install glibc-devel-static
 
-Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
+Architectures which require device tree (PowerPC, ARM64, RISC-V) also
 require libfdt.
 	deb: $ sudo apt-get install libfdt-dev
 	Fedora: # yum install libfdt-devel
@@ -61,16 +61,15 @@ to the Linux name of the architecture. Architectures supported:
 - i386
 - x86_64
 - powerpc
-- arm
 - arm64
 - mips
 - riscv
 If ARCH is not provided, the target architecture will be automatically
 determined by running "uname -m" on your host, resulting in a native build.
 
-To cross-compile to ARM for instance, install a cross-compiler, put the
+To cross-compile to arm64 for instance, install a cross-compiler, put the
 required libraries in the cross-compiler's SYSROOT and type:
-$ make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm
+$ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
 
 Missing libraries when cross-compiling
 ---------------------------------------
@@ -82,7 +81,7 @@ On multiarch system you should be able to install those be appending
 the architecture name after the package (example for ARM64):
 $ sudo apt-get install libfdt-dev:arm64
 
-PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
+PowerPC, ARM64 and RISC-V require libfdt to be installed. If you cannot use
 precompiled mulitarch packages, you could either copy the required header and
 library files from an installed target system into the SYSROOT (you will need
 /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
diff --git a/Makefile b/Makefile
index d84dc8e..462659b 100644
--- a/Makefile
+++ b/Makefile
@@ -166,35 +166,24 @@ ifeq ($(ARCH), powerpc)
 	ARCH_WANT_LIBFDT := y
 endif
 
-# ARM
-OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
-			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   hw/serial.o
-HDRS_ARM_COMMON		:= arm/include
-ifeq ($(ARCH), arm)
-	DEFINES		+= -DCONFIG_ARM
-	OBJS		+= $(OBJS_ARM_COMMON)
-	OBJS		+= arm/aarch32/arm-cpu.o
-	OBJS		+= arm/aarch32/kvm-cpu.o
-	OBJS		+= arm/aarch32/kvm.o
-	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
-	ARCH_INCLUDE	+= -Iarm/aarch32/include
-	CFLAGS		+= -march=armv7-a
-
-	ARCH_WANT_LIBFDT := y
-	ARCH_HAS_FLASH_MEM := y
-endif
-
 # ARM64
 ifeq ($(ARCH), arm64)
 	DEFINES		+= -DCONFIG_ARM64
-	OBJS		+= $(OBJS_ARM_COMMON)
+	OBJS		+= arm/fdt.o
+	OBJS		+= arm/gic.o
+	OBJS		+= arm/gicv2m.o
+	OBJS		+= arm/ioport.o
+	OBJS		+= arm/kvm.o
+	OBJS		+= arm/kvm-cpu.o
+	OBJS		+= arm/pci.o
+	OBJS		+= arm/timer.o
+	OBJS		+= hw/serial.o
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
 	OBJS		+= arm/aarch64/pvtime.o
 	OBJS		+= arm/aarch64/pmu.o
-	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
+	ARCH_INCLUDE	:= arm/include
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
deleted file mode 100644
index 16bba55..0000000
diff --git a/arm/aarch32/include/asm/kernel.h b/arm/aarch32/include/asm/kernel.h
deleted file mode 100644
index 6129609..0000000
diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
deleted file mode 100644
index a4217c1..0000000
diff --git a/arm/aarch32/include/kvm/barrier.h b/arm/aarch32/include/kvm/barrier.h
deleted file mode 100644
index 94913a9..0000000
diff --git a/arm/aarch32/include/kvm/fdt-arch.h b/arm/aarch32/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
deleted file mode 100644
index 0333cf4..0000000
diff --git a/arm/aarch32/include/kvm/kvm-config-arch.h b/arm/aarch32/include/kvm/kvm-config-arch.h
deleted file mode 100644
index acf0d23..0000000
diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
deleted file mode 100644
index fd0b387..0000000
diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
deleted file mode 100644
index 95fb1da..0000000
diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
deleted file mode 100644
index 768a56b..0000000
-- 
2.39.5


