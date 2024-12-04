Return-Path: <kvm+bounces-32998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A554F9E378D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:34:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7487D163BA7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DCD1CBEB9;
	Wed,  4 Dec 2024 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYjdsJwr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EA1C174E;
	Wed,  4 Dec 2024 10:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308277; cv=none; b=uG4U0WYPKCY6ORclHeaJLoWqcSDvc5jQNnfCDY9IojAzDzvzHlFNpQywz+kbz/6IgDNeB+MeXKPasGmjNya95XrOzMIlUz481pJjSUYxKR1aTo7ic9LYEqSCCY+auN7stYh2KII/y21z9+fHUg7QQV+kajxynzSmQkUQcUB9kTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308277; c=relaxed/simple;
	bh=BrncdUk4tcsZV7oh9NVKSV9Nr6KI2/oZvaNX5IoFP4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LayV54/N80zmGmFIM0bE7z91P9gnbd3Ophs/H6f6bx9bUMNVYquqf1c3vQZZsrgFfPPdT5hhjhpFC92Zm3hKBtQbcerYXjVewNnBq8b+R90/ryIu3eEOroluABVT5x8F9tTDcmdqKtqlbFSWz2woVvXglWdoETPVCo5ZNmFBAhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYjdsJwr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436E9C4CEE1;
	Wed,  4 Dec 2024 10:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308277;
	bh=BrncdUk4tcsZV7oh9NVKSV9Nr6KI2/oZvaNX5IoFP4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYjdsJwr5hR5KVED3YNOsB7+u6o5nEkCGpuSJnfgsAhHibkLrFxCdfkL+8LiPrZ07
	 XbKLQLrV8zbWWWTDAboNSz0fwhMggPt2hd3pkALFsp+toecdPa2S/fy7ObnQ2T79C/
	 qH9D6HrG066Oj4wiZifhCmQ9+Phm3TYMm/XFjj+utiA6BQ607d4h7GKC5BBvugolOp
	 hTrWB8rxM72iNx7o055EXMz90vfUx+RLeWyj+1SYWVxE9EKkRk2oEUHqRrSewT4x/Z
	 4G3rkCXdbrMZ6b09QH5Rw3AclYtS+e4Mu1Nm5w/SQrj4Eyd/bWfS+lEdW5mPrNtua8
	 +rNgeCE9GuHNg==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 04/11] x86: split CPU selection into 32-bit and 64-bit
Date: Wed,  4 Dec 2024 11:30:35 +0100
Message-Id: <20241204103042.1904639-5-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The x86 CPU selection menu is confusing for a number of reasons.
One of them is how it's possible to build a 32-bit kernel for
a small number of early 64-bit microarchitectures (K8, Core2)
but not the regular generic 64-bit target that is the normal
default.

There is no longer a reason to run 32-bit kernels on production
64-bit systems, so simplify the configuration menu by completely
splitting the two into 32-bit-only and 64-bit-only machines.

Testing generic 32-bit kernels on 64-bit hardware remains
possible, just not building a 32-bit kernel that requires
a 64-bit CPU.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig.cpu            | 65 ++++++++++++++++++++-------------
 arch/x86/include/asm/vermagic.h |  4 --
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 05a3f57ac20b..139db904e564 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Put here option for CPU selection and depending optimization
 choice
-	prompt "Processor family"
-	default M686 if X86_32
-	default GENERIC_CPU if X86_64
+	prompt "x86-32 Processor family"
+	depends on X86_32
+	default M686
 	help
 	  This is the processor type of your CPU. This information is
 	  used for optimizing purposes. In order to compile a kernel
@@ -31,7 +31,6 @@ choice
 	  - "Pentium-4" for the Intel Pentium 4 or P4-based Celeron.
 	  - "K6" for the AMD K6, K6-II and K6-III (aka K6-3D).
 	  - "Athlon" for the AMD K7 family (Athlon/Duron/Thunderbird).
-	  - "Opteron/Athlon64/Hammer/K8" for all K8 and newer AMD CPUs.
 	  - "Crusoe" for the Transmeta Crusoe series.
 	  - "Efficeon" for the Transmeta Efficeon series.
 	  - "Winchip-C6" for original IDT Winchip.
@@ -42,13 +41,10 @@ choice
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
 	  - "VIA C7" for VIA C7.
-	  - "Intel P4" for the Pentium 4/Netburst microarchitecture.
-	  - "Core 2/newer Xeon" for all core2 and newer Intel CPUs.
 	  - "Intel Atom" for the Atom-microarchitecture CPUs.
-	  - "Generic-x86-64" for a kernel which runs on any x86-64 CPU.
 
 	  See each option's help text for additional details. If you don't know
-	  what to do, choose "486".
+	  what to do, choose "Pentium-Pro".
 
 config M486SX
 	bool "486SX"
@@ -114,11 +110,11 @@ config MPENTIUMIII
 	  extensions.
 
 config MPENTIUMM
-	bool "Pentium M"
+	bool "Pentium M/Pentium Dual Core/Core Solo/Core Duo"
 	depends on X86_32
 	help
 	  Select this for Intel Pentium M (not Pentium-4 M)
-	  notebook chips.
+	  "Merom" Core Solo/Duo notebook chips
 
 config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
@@ -181,13 +177,6 @@ config MK7
 	  some extended instructions, and passes appropriate optimization
 	  flags to GCC.
 
-config MK8
-	bool "Opteron/Athlon64/Hammer/K8"
-	help
-	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.
-	  Enables use of some extended instructions, and passes appropriate
-	  optimization flags to GCC.
-
 config MCRUSOE
 	bool "Crusoe"
 	depends on X86_32
@@ -266,10 +255,37 @@ config MVIAC7
 	help
 	  Select this for a VIA C7.  Selecting this uses the correct cache
 	  shift and tells gcc to treat the CPU as a 686.
+endchoice
+
+choice
+	prompt "x86-64 Processor family"
+	depends on X86_64
+	default GENERIC_CPU
+	help
+	  This is the processor type of your CPU. This information is
+	  used for optimizing purposes. In order to compile a kernel
+	  that can run on all supported x86 CPU types (albeit not
+	  optimally fast), you can specify "Generic-x86-64" here.
+
+	  Here are the settings recommended for greatest speed:
+	  - "Opteron/Athlon64/Hammer/K8" for all K8 and newer AMD CPUs.
+	  - "Intel P4" for the Pentium 4/Netburst microarchitecture.
+	  - "Core 2/newer Xeon" for all core2 and newer Intel CPUs.
+	  - "Intel Atom" for the Atom-microarchitecture CPUs.
+	  - "Generic-x86-64" for a kernel which runs on any x86-64 CPU.
+
+	  See each option's help text for additional details. If you don't know
+	  what to do, choose "Generic-x86-64".
+
+config MK8
+	bool "Opteron/Athlon64/Hammer/K8"
+	help
+	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.
+	  Enables use of some extended instructions, and passes appropriate
+	  optimization flags to GCC.
 
 config MPSC
 	bool "Intel P4 / older Netburst based Xeon"
-	depends on X86_64
 	help
 	  Optimize for Intel Pentium 4, Pentium D and older Nocona/Dempsey
 	  Xeon CPUs with Intel 64bit which is compatible with x86-64.
@@ -281,7 +297,6 @@ config MPSC
 config MCORE2
 	bool "Core 2/newer Xeon"
 	help
-
 	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
 	  53xx) CPUs. You can distinguish newer from older Xeons by the CPU
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
@@ -348,11 +363,11 @@ config X86_ALIGNMENT_16
 
 config X86_INTEL_USERCOPY
 	def_bool y
-	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK7 || MEFFICEON
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MATOM
 
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
@@ -372,11 +387,11 @@ config X86_P6_NOP
 
 config X86_TSC
 	def_bool y
-	depends on (MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) || X86_64
+	depends on (MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MATOM) || X86_64
 
 config X86_HAVE_PAE
 	def_bool y
-	depends on MCRUSOE || MEFFICEON || MCYRIXIII || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC7 || MCORE2 || MATOM || X86_64
+	depends on MCRUSOE || MEFFICEON || MCYRIXIII || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC7 || MATOM || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -386,12 +401,12 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
+	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || MATOM || MGEODE_LX || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
-	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MCORE2 || MK7 || MK8)
+	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MK7)
 	default "5" if X86_32 && X86_CMPXCHG64
 	default "4"
 
diff --git a/arch/x86/include/asm/vermagic.h b/arch/x86/include/asm/vermagic.h
index 75884d2cdec3..5d471253c755 100644
--- a/arch/x86/include/asm/vermagic.h
+++ b/arch/x86/include/asm/vermagic.h
@@ -15,8 +15,6 @@
 #define MODULE_PROC_FAMILY "586TSC "
 #elif defined CONFIG_M586MMX
 #define MODULE_PROC_FAMILY "586MMX "
-#elif defined CONFIG_MCORE2
-#define MODULE_PROC_FAMILY "CORE2 "
 #elif defined CONFIG_MATOM
 #define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
@@ -33,8 +31,6 @@
 #define MODULE_PROC_FAMILY "K6 "
 #elif defined CONFIG_MK7
 #define MODULE_PROC_FAMILY "K7 "
-#elif defined CONFIG_MK8
-#define MODULE_PROC_FAMILY "K8 "
 #elif defined CONFIG_MELAN
 #define MODULE_PROC_FAMILY "ELAN "
 #elif defined CONFIG_MCRUSOE
-- 
2.39.5


