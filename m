Return-Path: <kvm+bounces-32997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 750719E378B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34E2528159F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14611C07F1;
	Wed,  4 Dec 2024 10:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rr6ux+Ga"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF521BD9E9;
	Wed,  4 Dec 2024 10:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308274; cv=none; b=JdpSw/Wu0/RtDVK7OQoABE8RZYSMOWU1OXjYBPxtbAUb2ngGXQtIUFhMXDJmys9/d1shtjbJltWPxavUuCWIiTR7d2Tpi2ozZRgYamj6AI09f4FURc7MeAwhiiEcpXJsEk6xab9GXquuIWvgbSzL+5gE243PJUCQ53llltJxs4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308274; c=relaxed/simple;
	bh=yrQ7t3rZqNJ65+QAWT55Rd4NKkK7kr7b7q+VRctnkIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O0RgP6IPP6uAsEDNWPN1GDxZyYwh4QzEfC1CP2e88Dy9tgGHl/zfMgVSMYPGMd8ocMPupvG3S0cZGTxhnJI+45/ulAZ9lf0iwmGB8hJjz8qp8E9esYS2r1TeEvEulXCmAzh1Una/NX1kBWkAiR1TxSNg9YrhNQgRZnQ23HvYB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rr6ux+Ga; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBA6C4CED1;
	Wed,  4 Dec 2024 10:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308273;
	bh=yrQ7t3rZqNJ65+QAWT55Rd4NKkK7kr7b7q+VRctnkIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr6ux+Ga7nWyXXsSJguYSMUBSEvdtgFRlpRS4HZ+H3fc1MHhbnS4EqyLExkd53ywz
	 j9IYUgvAklh5Cx2i5hswDAuYSD5AZ8z89SQuF9w98cnUIpIpnNcgiwOlD/djKS87mI
	 xwZzpxixisiiZ56Yk6Mfpdu7/8vnU4ziT+2+pxnQBmOc4gxeAv1PAr6aF1vodQPjVh
	 Z2ep/UdFMeIGVIDT0dvqTGuOB6lgF8gbeRKv4BkOJWPWZ21It3D1sbJb+f/XFIEMml
	 wYv7X05rpfDGboqMVHSf0YvI0JtN5aym1asJU12qaAt8+RxCz1uAM18nYi4+Vu4Xd+
	 0UrRDdRDgHLaA==
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
Subject: [PATCH 03/11] x86: Kconfig.cpu: split out 64-bit atom
Date: Wed,  4 Dec 2024 11:30:34 +0100
Message-Id: <20241204103042.1904639-4-arnd@kernel.org>
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

Both 32-bit and 64-bit builds allow optimizing using "-march=atom", but
this is somewhat suboptimal, as gcc and clang use this option to refer
to the original in-order "Bonnell" microarchitecture used in the early
"Diamondville" and "Silverthorne" processors that were mostly 32-bit only.

The later 22nm "Silvermont" architecture saw a significant redesign to
an out-of-order architecture that is reflected in the -mtune=silvermont
flag in the compilers, and all of these are 64-bit capable. Variations
of this microarchitecture were in CPUs launched from 2014 to 2021 and
are still common in 2024.

Split this up so that 32-bit targets keep building with -march=atom,
but 64-bit ones get the more useful silvermont optimization. On modern
"tremont" and newer CPUs, using -march=generic or -march=tremont
would be even better, but the silvermont optimization is still an
improvement.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig.cpu     | 28 ++++++++++++++++++++--------
 arch/x86/Makefile        |  4 ++--
 arch/x86/Makefile_32.cpu |  3 +--
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 42e6a40876ea..05a3f57ac20b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -155,6 +155,15 @@ config MPENTIUM4
 		-Paxville
 		-Dempsey
 
+config MATOM
+	bool "Intel Atom (Bonnell)"
+	help
+
+	  Select this for the Intel Atom platform. Intel Atom CPUs have an
+	  in-order pipelining architecture and thus can benefit from
+	  accordingly optimized code.
+	  This includes all the 32-bit-only Atom chips such as N2xx and
+	  Z5xx/Z6xx.
 
 config MK6
 	bool "K6/K6-II/K6-III"
@@ -278,14 +287,17 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
 
-config MATOM
-	bool "Intel Atom"
+config MSILVERMONT
+	bool "Intel Atom (Silvermont/Goldmont)"
+	depends on X86_64
 	help
-
-	  Select this for the Intel Atom platform. Intel Atom CPUs have an
-	  in-order pipelining architecture and thus can benefit from
-	  accordingly optimized code. Use a recent GCC with specific Atom
-	  support in order to fully benefit from selecting this option.
+	  Select this to optimize for the 64-bit Intel Atom platform
+	  of the 22nm Silvermont microarchitecture and its 14nm
+	  Goldmont shrink (e.g. Atom C2xxx, Atom Z3xxx, Celeron
+	  N2xxx/J1xxx, Pentium N3xxx/J2xxx).
+	  Kernels built with this option are incompatible with very
+	  early Atom CPUs based on the Bonnell microarchitecture,
+	  such as Atom 230/330, D4xx/D5xx, D2xxx, N2xxx or Z2xxx.
 
 config GENERIC_CPU
 	bool "Generic-x86-64"
@@ -318,7 +330,7 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MSILVERMONT || MVIAC7 || X86_GENERIC || GENERIC_CPU
 	default "4" if MELAN || M486SX || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5b773b34768d..05887ae282f5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -182,14 +182,14 @@ else
         cflags-$(CONFIG_MK8)		+= -march=k8
         cflags-$(CONFIG_MPSC)		+= -march=nocona
         cflags-$(CONFIG_MCORE2)		+= -march=core2
-        cflags-$(CONFIG_MATOM)		+= -march=atom
+        cflags-$(CONFIG_MSILVERMONT)	+= -march=silvermont
         cflags-$(CONFIG_GENERIC_CPU)	+= -mtune=generic
         KBUILD_CFLAGS += $(cflags-y)
 
         rustflags-$(CONFIG_MK8)		+= -Ctarget-cpu=k8
         rustflags-$(CONFIG_MPSC)	+= -Ctarget-cpu=nocona
         rustflags-$(CONFIG_MCORE2)	+= -Ctarget-cpu=core2
-        rustflags-$(CONFIG_MATOM)	+= -Ctarget-cpu=atom
+        rustflags-$(CONFIG_MSILVERMONT)	+= -Ctarget-cpu=silvermont
         rustflags-$(CONFIG_GENERIC_CPU)	+= -Ztune-cpu=generic
         KBUILD_RUSTFLAGS += $(rustflags-y)
 
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 94834c4b5e5e..0adc3a59520a 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -33,8 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)		+= -march=i686
 cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
-cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
-	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
+cflags-$(CONFIG_MATOM)		+= -march=atom
 
 # AMD Elan support
 cflags-$(CONFIG_MELAN)		+= -march=i486
-- 
2.39.5


