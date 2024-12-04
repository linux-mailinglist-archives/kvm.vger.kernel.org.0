Return-Path: <kvm+bounces-33004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6AE9E379B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25229164F2F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874F81F7074;
	Wed,  4 Dec 2024 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfAJYF95"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AA71B0F31;
	Wed,  4 Dec 2024 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308296; cv=none; b=QZlS+SdDPy6KcWvUR0AVgVOYum+bN1BtuLozn/Z55LFSU97i7MfSuixtijEq4u2ivOVoG/VD2WMNzDjTgHXJbMtk+W9RVI1mHKwpaFwPHMxQ/2hSpnRq8uYUQ5eHWmy6GgyHRf9e1c79Zw9m/IWKz2aqusm96ybGUkUYugidYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308296; c=relaxed/simple;
	bh=iGckYWv5WGX83KeO9Ck2fdKR0Uj22ymCh4eHvYJ7bb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IBnnG0sTxFijSht2dPINYxOUSawFsSLMX1Ur3BGWUC9gNOyhF2PAPHq5cEDAnWTAgOwFOIcIS6psSIZ8nSYLHL9InZUxYWwHqfIM5GGZZR/pOWYQkWqIDHphGDFGrclPZ+NsBczRPTT7W8sta6DhuNGTQDKjqsbyYdEanAc0qhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfAJYF95; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBC1C4CED1;
	Wed,  4 Dec 2024 10:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308295;
	bh=iGckYWv5WGX83KeO9Ck2fdKR0Uj22ymCh4eHvYJ7bb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfAJYF952HGq9vwXIGeoQg8YkWVGSm9zVJVLaVHrAD/hOjIaXrfZAMVRKKHFS2cMm
	 a+u4jnLDEfLKQbRMnCRk54jwPs0GVzjdYKL2CyMTkQN8rM3fWs2rMeE72FeAGKFRHG
	 CNV9Ig9rweHY9LmTlRkOcVhTvmxyr2G2hbvNazwzitEmbKKuTpiEiyNc4JMaxZzI9J
	 FVu0P8DiVIN+3dLoxWaUtXXCwGqFC1QdIQJ8WivPajpjn5Gjxk3rAeDP8P7ky1yUiE
	 WQeTnpRLO06EPAhmBkIyQfCm7ty+wKvkaLtOcz/Ga13eMrUT4k2B4mPwDiNpuFDRDT
	 N+IPAAPX8d0hw==
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
Subject: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Date: Wed,  4 Dec 2024 11:30:40 +0100
Message-Id: <20241204103042.1904639-10-arnd@kernel.org>
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

Building an x86-64 kernel with CONFIG_GENERIC_CPU is documented to
run on all CPUs, but the Makefile does not actually pass an -march=
argument, instead relying on the default that was used to configure
the toolchain.

In many cases, gcc will be configured to -march=x86-64 or -march=k8
for maximum compatibility, but in other cases a distribution default
may be either raised to a more recent ISA, or set to -march=native
to build for the CPU used for compilation. This still works in the
case of building a custom kernel for the local machine.

The point where it breaks down is building a kernel for another
machine that is older the the default target. Changing the default
to -march=x86-64 would make it work reliable, but possibly produce
worse code on distros that intentionally default to a newer ISA.

To allow reliably building a kernel for either the oldest x86-64
CPUs or a more recent level, add three separate options for
v1, v2 and v3 of the architecture as defined by gcc and clang
and make them all turn on CONFIG_GENERIC_CPU. Based on this it
should be possible to change runtime feature detection into
build-time detection for things like cmpxchg16b, or possibly
gate features that are only available on older architectures.

Link: https://lists.llvm.org/pipermail/llvm-dev/2020-July/143289.html
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig.cpu | 39 ++++++++++++++++++++++++++++++++++-----
 arch/x86/Makefile    |  6 ++++++
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 139db904e564..1461a739237b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -260,7 +260,7 @@ endchoice
 choice
 	prompt "x86-64 Processor family"
 	depends on X86_64
-	default GENERIC_CPU
+	default X86_64_V2
 	help
 	  This is the processor type of your CPU. This information is
 	  used for optimizing purposes. In order to compile a kernel
@@ -314,15 +314,44 @@ config MSILVERMONT
 	  early Atom CPUs based on the Bonnell microarchitecture,
 	  such as Atom 230/330, D4xx/D5xx, D2xxx, N2xxx or Z2xxx.
 
-config GENERIC_CPU
-	bool "Generic-x86-64"
+config X86_64_V1
+	bool "Generic x86-64"
 	depends on X86_64
 	help
-	  Generic x86-64 CPU.
-	  Run equally well on all x86-64 CPUs.
+	  Generic x86-64-v1 CPU.
+	  Run equally well on all x86-64 CPUs, including early Pentium-4
+	  variants lacking the sahf and cmpxchg16b instructions as well
+	  as the AMD K8 and Intel Core 2 lacking popcnt.
+
+config X86_64_V2
+	bool "Generic x86-64 v2"
+	depends on X86_64
+	help
+	  Generic x86-64-v2 CPU.
+	  Run equally well on all x86-64 CPUs that meet the x86-64-v2
+	  definition as well as those that only miss the optional
+	  SSE3/SSSE3/SSE4.1 portions.
+	  Examples of this include Intel Nehalem and Silvermont,
+	  AMD Bulldozer (K10) and Jaguar as well as VIA Nano that
+	  include popcnt, cmpxchg16b and sahf.
+
+config X86_64_V3
+	bool "Generic x86-64 v3"
+	depends on X86_64
+	help
+	  Generic x86-64-v3 CPU.
+	  Run equally well on all x86-64 CPUs that meet the x86-64-v3
+	  definition as well as those that only miss the optional
+	  AVX/AVX2 portions.
+	  Examples of this include the Intel Haswell and AMD Excavator
+	  microarchitectures that include the bmi1/bmi2, lzncnt, movbe
+	  and xsave instruction set extensions.
 
 endchoice
 
+config GENERIC_CPU
+	def_bool X86_64_V1 || X86_64_V2 || X86_64_V3
+
 config X86_GENERIC
 	bool "Generic x86 support"
 	depends on X86_32
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 05887ae282f5..1fdc3fc6a54e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -183,6 +183,9 @@ else
         cflags-$(CONFIG_MPSC)		+= -march=nocona
         cflags-$(CONFIG_MCORE2)		+= -march=core2
         cflags-$(CONFIG_MSILVERMONT)	+= -march=silvermont
+        cflags-$(CONFIG_MX86_64_V1)	+= -march=x86-64
+        cflags-$(CONFIG_MX86_64_V2)	+= $(call cc-option,-march=x86-64-v2,-march=x86-64)
+        cflags-$(CONFIG_MX86_64_V3)	+= $(call cc-option,-march=x86-64-v3,-march=x86-64)
         cflags-$(CONFIG_GENERIC_CPU)	+= -mtune=generic
         KBUILD_CFLAGS += $(cflags-y)
 
@@ -190,6 +193,9 @@ else
         rustflags-$(CONFIG_MPSC)	+= -Ctarget-cpu=nocona
         rustflags-$(CONFIG_MCORE2)	+= -Ctarget-cpu=core2
         rustflags-$(CONFIG_MSILVERMONT)	+= -Ctarget-cpu=silvermont
+        rustflags-$(CONFIG_MX86_64_V1)	+= -Ctarget-cpu=x86-64
+        rustflags-$(CONFIG_MX86_64_V2)	+= -Ctarget-cpu=x86-64-v2
+        rustflags-$(CONFIG_MX86_64_V3)	+= -Ctarget-cpu=x86-64-v3
         rustflags-$(CONFIG_GENERIC_CPU)	+= -Ztune-cpu=generic
         KBUILD_RUSTFLAGS += $(rustflags-y)
 
-- 
2.39.5


