Return-Path: <kvm+bounces-32999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B93A9E378E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EECE016269F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018D31D1F56;
	Wed,  4 Dec 2024 10:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtLRBuAT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262DB1CDFAC;
	Wed,  4 Dec 2024 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308281; cv=none; b=RsNprfVswNoIvMWEQnVhWU86nV/ZeSi2q8aSCUjhPzKLVtp97c/jWyo//f+fUW5KJxVdso9aN/wQ1c4/ntIak+ypV1MlyiIZBLVC06yVE2CCCQxDHZVkxSU/u5e2nc5FcndNjMT5EI3cTHSdDr9kxm8V8i8UjuSmWrIxItR45Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308281; c=relaxed/simple;
	bh=WYwLVaDR/1Xo3DnnybNTxR1IF4M+tI476IKgEdIlNSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4pULgVCXqN1QhBjeh36zqUeyIWJH5o+dKcyM+hlK8+wUkVV0bp3DkrzLjdzVXJZJs/puDyhk22hdiKbwOKlK026B15lzTsl2J/ncPyN69iZeKoE2RekbYMgtigNxM9k7kW95rPgCsRuCOwAyaO1D/wqpsTWu80fvvTAo5tr5os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtLRBuAT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7055C4CED1;
	Wed,  4 Dec 2024 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308281;
	bh=WYwLVaDR/1Xo3DnnybNTxR1IF4M+tI476IKgEdIlNSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtLRBuATAK5ZHaEWhw0ekm+9H3UGrkyDuiCZdbJcXFBaidpUp7EuR7EoPtT0zUaKB
	 wGp/97rWtINWE80KRL6Dv1DzkAZGeOR13tJcN3DGnpa0VPLZ/tZvIQPCXgy1IsX1K3
	 6JTSy8iVJ5O6xB4gWD1w2BXHrXl0PK1nWqjVcoQS2oww4vebGvLGSB6KBhtj9+wbrl
	 clIQa348durVVcmDT2Ynk/nYmyBnXEwsR0tNhN58pzjvQTTfQa94k2i9UxXUIb0Uch
	 YxIcBlgA+Yp7RDuVc18H+lXyf9vjUYK0UcTPoR7sMeV+/JV4kshRNRK5mSxvFv2qDs
	 RzB3WpCdQUJYg==
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
Subject: [PATCH 05/11] x86: remove HIGHMEM64G support
Date: Wed,  4 Dec 2024 11:30:36 +0100
Message-Id: <20241204103042.1904639-6-arnd@kernel.org>
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

The HIGHMEM64G support was added in linux-2.3.25 to support (then)
high-end Pentium Pro and Pentium III Xeon servers with more than 4GB of
addressing, NUMA and PCI-X slots started appearing.

I have found no evidence of this ever being used in regular dual-socket
servers or consumer devices, all the users seem obsolete these days,
even by i386 standards:

 - Support for NUMA servers (NUMA-Q, IBM x440, unisys) was already
   removed ten years ago.

 - 4+ socket non-NUMA servers based on Intel 450GX/450NX, HP F8 and
   ServerWorks ServerSet/GrandChampion could theoretically still work
   with 8GB, but these were exceptionally rare even 20 years ago and
   would have usually been equipped with than the maximum amount of
   RAM.

 - Some SKUs of the Celeron D from 2004 had 64-bit mode fused off but
   could still work in a Socket 775 mainboard designed for the later
   Core 2 Duo and 8GB. Apparently most BIOSes at the time only allowed
   64-bit CPUs.

 - In the early days of x86-64 hardware, there was sometimes the need
   to run a 32-bit kernel to work around bugs in the hardware drivers,
   or in the syscall emulation for 32-bit userspace. This likely still
   works but there should never be a need for this any more.

Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
PAE mode is still required to get access to the 'NX' bit on Atom
'Pentium M' and 'Core Duo' CPUs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/admin-guide/kdump/kdump.rst     |  4 --
 Documentation/arch/x86/usb-legacy-support.rst | 11 +----
 arch/x86/Kconfig                              | 46 +++----------------
 arch/x86/configs/xen.config                   |  2 -
 arch/x86/include/asm/page_32_types.h          |  4 +-
 arch/x86/mm/init_32.c                         |  9 +---
 6 files changed, 11 insertions(+), 65 deletions(-)

diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
index 5376890adbeb..1f7f14c6e184 100644
--- a/Documentation/admin-guide/kdump/kdump.rst
+++ b/Documentation/admin-guide/kdump/kdump.rst
@@ -180,10 +180,6 @@ Dump-capture kernel config options (Arch Dependent, i386 and x86_64)
 1) On i386, enable high memory support under "Processor type and
    features"::
 
-	CONFIG_HIGHMEM64G=y
-
-   or::
-
 	CONFIG_HIGHMEM4G
 
 2) With CONFIG_SMP=y, usually nr_cpus=1 need specified on the kernel
diff --git a/Documentation/arch/x86/usb-legacy-support.rst b/Documentation/arch/x86/usb-legacy-support.rst
index e01c08b7c981..b17bf122270a 100644
--- a/Documentation/arch/x86/usb-legacy-support.rst
+++ b/Documentation/arch/x86/usb-legacy-support.rst
@@ -20,11 +20,7 @@ It has several drawbacks, though:
    features (wheel, extra buttons, touchpad mode) of the real PS/2 mouse may
    not be available.
 
-2) If CONFIG_HIGHMEM64G is enabled, the PS/2 mouse emulation can cause
-   system crashes, because the SMM BIOS is not expecting to be in PAE mode.
-   The Intel E7505 is a typical machine where this happens.
-
-3) If AMD64 64-bit mode is enabled, again system crashes often happen,
+2) If AMD64 64-bit mode is enabled, again system crashes often happen,
    because the SMM BIOS isn't expecting the CPU to be in 64-bit mode.  The
    BIOS manufacturers only test with Windows, and Windows doesn't do 64-bit
    yet.
@@ -38,11 +34,6 @@ Problem 1)
   compiled-in, too.
 
 Problem 2)
-  can currently only be solved by either disabling HIGHMEM64G
-  in the kernel config or USB Legacy support in the BIOS. A BIOS update
-  could help, but so far no such update exists.
-
-Problem 3)
   is usually fixed by a BIOS update. Check the board
   manufacturers web site. If an update is not available, disable USB
   Legacy support in the BIOS. If this alone doesn't help, try also adding
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 42494739344d..b373db8a8176 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1383,15 +1383,11 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-choice
-	prompt "High Memory Support"
-	default HIGHMEM4G
+config HIGHMEM4G
+	bool "High Memory Support"
 	depends on X86_32
-
-config NOHIGHMEM
-	bool "off"
 	help
-	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
+	  Linux can use up to 4 Gigabytes of physical memory on x86 systems.
 	  However, the address space of 32-bit x86 processors is only 4
 	  Gigabytes large. That means that, if you have a large amount of
 	  physical memory, not all of it can be "permanently mapped" by the
@@ -1407,38 +1403,9 @@ config NOHIGHMEM
 	  possible.
 
 	  If the machine has between 1 and 4 Gigabytes physical RAM, then
-	  answer "4GB" here.
+	  answer "Y" here.
 
-	  If more than 4 Gigabytes is used then answer "64GB" here. This
-	  selection turns Intel PAE (Physical Address Extension) mode on.
-	  PAE implements 3-level paging on IA32 processors. PAE is fully
-	  supported by Linux, PAE mode is implemented on all recent Intel
-	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
-	  then the kernel will not boot on CPUs that don't support PAE!
-
-	  The actual amount of total physical memory will either be
-	  auto detected or can be forced by using a kernel command line option
-	  such as "mem=256M". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
-	  If unsure, say "off".
-
-config HIGHMEM4G
-	bool "4GB"
-	help
-	  Select this if you have a 32-bit processor and between 1 and 4
-	  gigabytes of physical RAM.
-
-config HIGHMEM64G
-	bool "64GB"
-	depends on X86_HAVE_PAE
-	select X86_PAE
-	help
-	  Select this if you have a 32-bit processor and more than 4
-	  gigabytes of physical RAM.
-
-endchoice
+	  If unsure, say N.
 
 choice
 	prompt "Memory split" if EXPERT
@@ -1484,8 +1451,7 @@ config PAGE_OFFSET
 	depends on X86_32
 
 config HIGHMEM
-	def_bool y
-	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
+	def_bool HIGHMEM4G
 
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
index 581296255b39..d5d091e03bd3 100644
--- a/arch/x86/configs/xen.config
+++ b/arch/x86/configs/xen.config
@@ -1,6 +1,4 @@
 # global x86 required specific stuff
-# On 32-bit HIGHMEM4G is not allowed
-CONFIG_HIGHMEM64G=y
 CONFIG_64BIT=y
 
 # These enable us to allow some of the
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index faf9cc1c14bb..25c32652f404 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -11,8 +11,8 @@
  * a virtual address space of one gigabyte, which limits the
  * amount of physical memory you can use to about 950MB.
  *
- * If you want more physical memory than this then see the CONFIG_HIGHMEM4G
- * and CONFIG_HIGHMEM64G options in the kernel configuration.
+ * If you want more physical memory than this then see the CONFIG_VMSPLIT_2G
+ * and CONFIG_HIGHMEM4G options in the kernel configuration.
  */
 #define __PAGE_OFFSET_BASE	_AC(CONFIG_PAGE_OFFSET, UL)
 #define __PAGE_OFFSET		__PAGE_OFFSET_BASE
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ac41b1e0940d..f288aad8dc74 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -582,7 +582,7 @@ static void __init lowmem_pfn_init(void)
 	"only %luMB highmem pages available, ignoring highmem size of %luMB!\n"
 
 #define MSG_HIGHMEM_TRIMMED \
-	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled kernel!\n"
+	"Warning: only 4GB will be used. Support for for CONFIG_HIGHMEM64G was removed!\n"
 /*
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
@@ -606,18 +606,13 @@ static void __init highmem_pfn_init(void)
 #ifndef CONFIG_HIGHMEM
 	/* Maximum memory usable is what is directly addressable */
 	printk(KERN_WARNING "Warning only %ldMB will be used.\n", MAXMEM>>20);
-	if (max_pfn > MAX_NONPAE_PFN)
-		printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
-	else
-		printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
+	printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
 	max_pfn = MAXMEM_PFN;
 #else /* !CONFIG_HIGHMEM */
-#ifndef CONFIG_HIGHMEM64G
 	if (max_pfn > MAX_NONPAE_PFN) {
 		max_pfn = MAX_NONPAE_PFN;
 		printk(KERN_WARNING MSG_HIGHMEM_TRIMMED);
 	}
-#endif /* !CONFIG_HIGHMEM64G */
 #endif /* !CONFIG_HIGHMEM */
 }
 
-- 
2.39.5


