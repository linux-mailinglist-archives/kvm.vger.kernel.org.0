Return-Path: <kvm+bounces-32996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 035FB9E37C7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0BAAB32042
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0111BCA1B;
	Wed,  4 Dec 2024 10:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pO9r1Pp5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8981A724C;
	Wed,  4 Dec 2024 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308270; cv=none; b=XZlYIUhv5jChoWgIj3QekM3+KtAvq71IMnEKqPLWVbm9sdhDDKBmoL7x2D1PizFgml4GLK4MBWex7MJUTPUsArOcQufO+WWgYOg9beMAsWFt66zpNZqz1fhsUQLMMOoO66CJAGqwCEgD+yS2XFJqUlNXoDfaI+kyMnn/7zJfaPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308270; c=relaxed/simple;
	bh=b1cZNxiVFqQ5SFPUxXzkmZBB1Y/QaruM9Xym7kFraA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P4TakcW6CTILrWKBC4rcjGYFcf8kwHMvNOInFt06gCpPeL18xK+ZM8V41bT5vAq19sVdkSSPAyOzdmq9z/8LSKeKtXYXtISLWJpFfD+yzFQGWI0OY48vCvfBXjM/SkECJoVEAnzwkscNOBQ2X+uE67cCqQGnqLzQH/Ap72oRqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pO9r1Pp5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D15C4CEE0;
	Wed,  4 Dec 2024 10:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308270;
	bh=b1cZNxiVFqQ5SFPUxXzkmZBB1Y/QaruM9Xym7kFraA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO9r1Pp5kOwCUX4q28lKEOrlJJ2rCucbW0YfI1Hd0DqgRcF2WiPqk+JhziOV1nMas
	 KLDKs5xHREAqkB8iVilsmljN0ejfd6REnCesZDbvGJzBZ1LrJ83LX/X+QI8UHKw8Jx
	 QRfyVgbO8szj9PjzyC6z0biGgTmYhLSUH+6oWtxZaSmGyJSe/8k2M3kb0pGp92Aoq4
	 Lhew+deLL3e/w0YETZRNAzPDXY8M5PatR3uqY+iryPXgMwgYqU7h55D+behwjVtmh7
	 tj5FZNRNkwS/9sfDtnOOf0s84ySMTru7Hh8m9qHDYKurGceCN3PSdm70AZPFOK+y+x
	 ko3ER1RfpGvqg==
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
Subject: [PATCH 02/11] x86: drop 32-bit "bigsmp" machine support
Date: Wed,  4 Dec 2024 11:30:33 +0100
Message-Id: <20241204103042.1904639-3-arnd@kernel.org>
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

The x86-32 kernel used to support multiple platforms with more than eight
logical CPUs, from the 1999-2003 timeframe: Sequent NUMA-Q, IBM Summit,
Unisys ES7000 and HP F8. Support for all except the latter was dropped
back in 2014, leaving only the F8 based DL740 and DL760 G2 machines in
this catery, with up to eight single-core Socket-603 Xeon-MP processors
with hyperthreading.

Like the already removed machines, the HP F8 servers at the cost upwards
of $100k in typical configurations, but were quickly obsoleted by
their 64-bit Socket-604 cousins and the AMD Opteron.

Earlier servers with up to 8 Pentium Pro or Xeon processors remain
fully supported as they had no hyperthreading. Similarly, the more
common 4-socket Xeon-MP machines with hyperthreading using Intel
or ServerWorks chipsets continue to work without this, and all the
multi-core Xeon processors also run 64-bit kernels.

While the "bigsmp" support can also be used to run on later 64-bit
machines (including VM guests), it seems best to discourage that
and get any remaining users to update their kernels to 64-bit builds
on these. As a side-effect of this, there is also no more need to
support NUMA configurations on 32-bit x86, as all true 32-bit
NUMA platforms are already gone.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../admin-guide/kernel-parameters.txt         |   4 -
 arch/x86/Kconfig                              |  20 +---
 arch/x86/kernel/apic/Makefile                 |   3 -
 arch/x86/kernel/apic/apic.c                   |   3 -
 arch/x86/kernel/apic/bigsmp_32.c              | 105 ------------------
 arch/x86/kernel/apic/local.h                  |  13 ---
 arch/x86/kernel/apic/probe_32.c               |  29 -----
 7 files changed, 4 insertions(+), 173 deletions(-)
 delete mode 100644 arch/x86/kernel/apic/bigsmp_32.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dc663c0ca670..eca370e99844 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -410,10 +410,6 @@
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
-			For X86-32, this can also be used to specify an APIC
-			driver name.
-			Format: apic=driver_name
-			Examples: apic=bigsmp
 
 	apic_extnmi=	[APIC,X86,EARLY] External NMI delivery setting
 			Format: { bsp (default) | all | none }
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9d7bd0ae48c4..42494739344d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -526,12 +526,6 @@ config X86_FRED
 	  ring transitions and exception/interrupt handling if the
 	  system supports it.
 
-config X86_BIGSMP
-	bool "Support for big SMP systems with more than 8 CPUs"
-	depends on SMP && X86_32
-	help
-	  This option is needed for the systems that have more than 8 CPUs.
-
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
 	default y
@@ -730,8 +724,8 @@ config X86_32_NON_STANDARD
 	depends on X86_32 && SMP
 	depends on X86_EXTENDED_PLATFORM
 	help
-	  This option compiles in the bigsmp and STA2X11 default
-	  subarchitectures.  It is intended for a generic binary
+	  This option compiles in the STA2X11 default
+	  subarchitecture.  It is intended for a generic binary
 	  kernel. If you select them all, kernel will probe it one by
 	  one and will fallback to default.
 
@@ -1008,8 +1002,7 @@ config NR_CPUS_RANGE_BEGIN
 config NR_CPUS_RANGE_END
 	int
 	depends on X86_32
-	default   64 if  SMP &&  X86_BIGSMP
-	default    8 if  SMP && !X86_BIGSMP
+	default    8 if  SMP
 	default    1 if !SMP
 
 config NR_CPUS_RANGE_END
@@ -1022,7 +1015,6 @@ config NR_CPUS_RANGE_END
 config NR_CPUS_DEFAULT
 	int
 	depends on X86_32
-	default   32 if  X86_BIGSMP
 	default    8 if  SMP
 	default    1 if !SMP
 
@@ -1568,8 +1560,7 @@ config AMD_MEM_ENCRYPT
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && X86_BIGSMP)
-	default y if X86_BIGSMP
+	depends on X86_64
 	select USE_PERCPU_NUMA_NODE_ID
 	select OF_NUMA if OF
 	help
@@ -1582,9 +1573,6 @@ config NUMA
 	  For 64-bit this is recommended if the system is Intel Core i7
 	  (or later), AMD Opteron, or EM64T NUMA.
 
-	  For 32-bit this is only needed if you boot a 32-bit
-	  kernel on a 64-bit NUMA platform.
-
 	  Otherwise, you should say N.
 
 config AMD_NUMA
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 3bf0487cf3b7..52d1808ee360 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -23,8 +23,5 @@ obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
 obj-y				+= apic_flat_64.o
 endif
 
-# APIC probe will depend on the listing order here
-obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
-
 # For 32bit, probe_32 need to be listed last
 obj-$(CONFIG_X86_LOCAL_APIC)	+= probe_$(BITS).o
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c5fb28e6451a..cb453bacf281 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1371,8 +1371,6 @@ void __init apic_intr_mode_init(void)
 
 	x86_64_probe_apic();
 
-	x86_32_install_bigsmp();
-
 	if (x86_platform.apic_post_init)
 		x86_platform.apic_post_init();
 
@@ -1674,7 +1672,6 @@ static __init void apic_read_boot_cpu_id(bool x2apic)
 		boot_cpu_apic_version = GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
 	topology_register_boot_apic(boot_cpu_physical_apicid);
-	x86_32_probe_bigsmp_early();
 }
 
 #ifdef CONFIG_X86_X2APIC
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
deleted file mode 100644
index 9285d500d5b4..000000000000
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ /dev/null
@@ -1,105 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * APIC driver for "bigsmp" xAPIC machines with more than 8 virtual CPUs.
- *
- * Drives the local APIC in "clustered mode".
- */
-#include <linux/cpumask.h>
-#include <linux/dmi.h>
-#include <linux/smp.h>
-
-#include <asm/apic.h>
-#include <asm/io_apic.h>
-
-#include "local.h"
-
-static u32 bigsmp_get_apic_id(u32 x)
-{
-	return (x >> 24) & 0xFF;
-}
-
-static void bigsmp_send_IPI_allbutself(int vector)
-{
-	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
-}
-
-static void bigsmp_send_IPI_all(int vector)
-{
-	default_send_IPI_mask_sequence_phys(cpu_online_mask, vector);
-}
-
-static int dmi_bigsmp; /* can be set by dmi scanners */
-
-static int hp_ht_bigsmp(const struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
-	dmi_bigsmp = 1;
-
-	return 0;
-}
-
-
-static const struct dmi_system_id bigsmp_dmi_table[] = {
-	{ hp_ht_bigsmp, "HP ProLiant DL760 G2",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
-			DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
-		}
-	},
-
-	{ hp_ht_bigsmp, "HP ProLiant DL740",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
-			DMI_MATCH(DMI_BIOS_VERSION, "P47-"),
-		}
-	},
-	{ } /* NULL entry stops DMI scanning */
-};
-
-static int probe_bigsmp(void)
-{
-	return dmi_check_system(bigsmp_dmi_table);
-}
-
-static struct apic apic_bigsmp __ro_after_init = {
-
-	.name				= "bigsmp",
-	.probe				= probe_bigsmp,
-
-	.dest_mode_logical		= false,
-
-	.disable_esr			= 1,
-
-	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-
-	.max_apic_id			= 0xFE,
-	.get_apic_id			= bigsmp_get_apic_id,
-
-	.calc_dest_apicid		= apic_default_calc_apicid,
-
-	.send_IPI			= default_send_IPI_single_phys,
-	.send_IPI_mask			= default_send_IPI_mask_sequence_phys,
-	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= bigsmp_send_IPI_allbutself,
-	.send_IPI_all			= bigsmp_send_IPI_all,
-	.send_IPI_self			= default_send_IPI_self,
-
-	.read				= native_apic_mem_read,
-	.write				= native_apic_mem_write,
-	.eoi				= native_apic_mem_eoi,
-	.icr_read			= native_apic_icr_read,
-	.icr_write			= native_apic_icr_write,
-	.wait_icr_idle			= apic_mem_wait_icr_idle,
-	.safe_wait_icr_idle		= apic_mem_wait_icr_idle_timeout,
-};
-
-bool __init apic_bigsmp_possible(bool cmdline_override)
-{
-	return apic == &apic_bigsmp || !cmdline_override;
-}
-
-void __init apic_bigsmp_force(void)
-{
-	if (apic != &apic_bigsmp)
-		apic_install_driver(&apic_bigsmp);
-}
-
-apic_driver(apic_bigsmp);
diff --git a/arch/x86/kernel/apic/local.h b/arch/x86/kernel/apic/local.h
index 842fe28496be..bdcf609eb283 100644
--- a/arch/x86/kernel/apic/local.h
+++ b/arch/x86/kernel/apic/local.h
@@ -65,17 +65,4 @@ void default_send_IPI_self(int vector);
 void default_send_IPI_mask_sequence_logical(const struct cpumask *mask, int vector);
 void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask, int vector);
 void default_send_IPI_mask_logical(const struct cpumask *mask, int vector);
-void x86_32_probe_bigsmp_early(void);
-void x86_32_install_bigsmp(void);
-#else
-static inline void x86_32_probe_bigsmp_early(void) { }
-static inline void x86_32_install_bigsmp(void) { }
-#endif
-
-#ifdef CONFIG_X86_BIGSMP
-bool apic_bigsmp_possible(bool cmdline_selected);
-void apic_bigsmp_force(void);
-#else
-static inline bool apic_bigsmp_possible(bool cmdline_selected) { return false; };
-static inline void apic_bigsmp_force(void) { }
 #endif
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index f75ee345c02d..87bc9e7ca5d6 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -93,35 +93,6 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
-void __init x86_32_probe_bigsmp_early(void)
-{
-	if (nr_cpu_ids <= 8 || xen_pv_domain())
-		return;
-
-	if (IS_ENABLED(CONFIG_X86_BIGSMP)) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(boot_cpu_apic_version))
-				break;
-			/* P4 and above */
-			fallthrough;
-		case X86_VENDOR_HYGON:
-		case X86_VENDOR_AMD:
-			if (apic_bigsmp_possible(cmdline_apic))
-				return;
-			break;
-		}
-	}
-	pr_info("Limiting to 8 possible CPUs\n");
-	set_nr_cpu_ids(8);
-}
-
-void __init x86_32_install_bigsmp(void)
-{
-	if (nr_cpu_ids > 8 && !xen_pv_domain())
-		apic_bigsmp_force();
-}
-
 void __init x86_32_probe_apic(void)
 {
 	if (!cmdline_apic) {
-- 
2.39.5


