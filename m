Return-Path: <kvm+bounces-53084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B2DB0D22E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883A93B2891
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D05A2D373A;
	Tue, 22 Jul 2025 06:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dzdyBAUQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Xl3Sv9/0"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10C2D321F;
	Tue, 22 Jul 2025 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753167316; cv=none; b=ZQFwzZ82SoQ11nl/Mwp3w73KNe/o+5NVuS+KB6hL/YSUc6wImIKBk8/hSUHpoYSDPTjJ+R8Q57YQAZ+3pitg7kduMa5m+MoDFg+7iZqHjtYNu3v5zGVjQhQrX12KBI1PcSHjUwakK1WUs0rDrcGdhJ53t3yKNGENC0CiskyJBk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753167316; c=relaxed/simple;
	bh=BxFrgAkGr32kE23m1k7QTpIqOXMTWKHzXvyYXZzZMds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7TWoI1GkTZPbUiKemXG4YPlvxmGGyxNaWAhXrsJkc4onCG4oHnU5W2uYAQ1shP/J008Yt+IqDcCdC3RgHeoGnQLZgl7gUMk5va+7301GAnJ0yiKf171M/de0+C7KNwfd6mF1W9yfWvPwZbbI0+XI5iAmvzcLs/FT+Nn6SgHvbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dzdyBAUQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Xl3Sv9/0; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753167312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrT7QBi1B84sF8mLQypcOtOj8UHfc5OrfpC24IRMRIw=;
	b=dzdyBAUQO29spGl88OZbpXgeRXB16Zs32gyjeSULd2Ta+t3AwOejzvhzeFUNC0M0y1HWhE
	GA5xMScLUwfOVBCDntbkHHZGd/qe/Ir3vfDSKFIuE0StyHCZSxDV/62/OwE3qtcxH9yozj
	7npJKeD1Ai8S3ZgzZE/jcrHqN27vKROl240PYAtI0wsa4HmH0sOn1S4WMT3rYjUorbbjQf
	f5BiuFjzIcpEeN73+L5RGmbU7GH1rcZA7H5DVey6weG+r54mkGv+dvHj9osPycnNeoIP4m
	7jJYNMzKoDbhfVammWMUSpSIy8TMx7yLWxBlxpkZaDdETObS5qCrfAiWQ7A+lw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753167312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrT7QBi1B84sF8mLQypcOtOj8UHfc5OrfpC24IRMRIw=;
	b=Xl3Sv9/04xx4nYF6YuH2a6yOgxgZxweOnyzOYLh1GE63v6la/OJm2YhddXlabUwgJlOSP2
	qcNHaCnWjSTVPBAA==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v3 4/6] drivers: Reorder headers alphabetically
Date: Tue, 22 Jul 2025 08:54:29 +0200
Message-ID: <20250722065448.413503-5-darwi@linutronix.de>
In-Reply-To: <20250722065448.413503-1-darwi@linutronix.de>
References: <20250722065448.413503-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multiple drivers use the cpuid_*() macros, but implicitly include the
main CPUID API header.

Sort their include lines so that <asm/cpuid/api.h> can be explicitly
included next.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 drivers/char/agp/efficeon-agp.c               |  9 ++++---
 drivers/cpufreq/longrun.c                     |  6 ++---
 drivers/cpufreq/powernow-k7.c                 | 13 +++++----
 drivers/cpufreq/powernow-k8.c                 | 16 +++++------
 drivers/cpufreq/speedstep-lib.c               |  5 ++--
 drivers/hwmon/fam15h_power.c                  | 13 ++++-----
 drivers/hwmon/k8temp.c                        | 11 ++++----
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  3 ++-
 drivers/ras/amd/fmpm.c                        |  2 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  | 14 +++++-----
 drivers/xen/events/events_base.c              | 27 ++++++++++---------
 drivers/xen/grant-table.c                     | 14 +++++-----
 drivers/xen/xenbus/xenbus_xs.c                | 20 +++++++-------
 13 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 0d25bbdc7e6a..79f956d7b17d 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -20,13 +20,14 @@
  *   - tested with c3/c4 enabled (with the mobility m9 card)
  */
 
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/agp_backend.h>
 #include <linux/gfp.h>
-#include <linux/page-flags.h>
+#include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/pci.h>
+
 #include "agp.h"
 #include "intel-agp.h"
 
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 1caaec7c280b..263c48b8f628 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -5,15 +5,15 @@
  *  BIG FAT DISCLAIMER: Work in progress code. Possibly *dangerous*
  */
 
+#include <linux/cpufreq.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
 #include <linux/timex.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
-#include <asm/cpu_device_id.h>
 
 static struct cpufreq_driver	longrun_driver;
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 31039330a3ba..0608040fcd1e 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -15,20 +15,20 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpufreq.h>
+#include <linux/dmi.h>
+#include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/dmi.h>
 #include <linux/timex.h>
-#include <linux/io.h>
 
-#include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
-#include <asm/msr.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
+#include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
 
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 #include <linux/acpi.h>
@@ -691,4 +691,3 @@ MODULE_LICENSE("GPL");
 
 late_initcall(powernow_init);
 module_exit(powernow_exit);
-
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index f7512b4e923e..2b5cdd8f1c0a 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -26,22 +26,22 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
+#include <linux/cpufreq.h>
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/smp.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
 #include <linux/string.h>
-#include <linux/cpumask.h>
-#include <linux/io.h>
-#include <linux/delay.h>
 
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
 
-#include <linux/acpi.h>
-#include <linux/mutex.h>
 #include <acpi/processor.h>
 
 #define VERSION "version 2.20.00"
diff --git a/drivers/cpufreq/speedstep-lib.c b/drivers/cpufreq/speedstep-lib.c
index 0b66df4ed513..f08817331aec 100644
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -9,14 +9,15 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpufreq.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/tsc.h>
+
 #include "speedstep-lib.h"
 
 #define PFX "speedstep-lib: "
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 8ecebea53651..5a5674e85f63 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -6,20 +6,21 @@
  * Author: Andreas Herrmann <herrmann.der.user@googlemail.com>
  */
 
+#include <linux/bitops.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
-#include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/hwmon.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/bitops.h>
-#include <linux/cpu.h>
-#include <linux/cpumask.h>
-#include <linux/time.h>
 #include <linux/sched.h>
+#include <linux/time.h>
 #include <linux/topology.h>
-#include <asm/processor.h>
+
 #include <asm/msr.h>
+#include <asm/processor.h>
 
 MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
 MODULE_AUTHOR("Andreas Herrmann <herrmann.der.user@googlemail.com>");
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 2b80ac410cd1..8c1efce9a04b 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -7,13 +7,14 @@
  * Inspired from the w83785 and amd756 drivers.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/hwmon.h>
 #include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
 #include <asm/processor.h>
 
 #define TEMP_FROM_REG(val)	(((((val) >> 16) & 0xff) - 49) * 1000)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index ea33ae39be6b..444ee53566c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -3,9 +3,10 @@
  */
 
 #include <linux/clk-provider.h>
-#include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/pci.h>
 #include <linux/platform_data/x86/intel_pmc_ipc.h>
+
 #include "dwmac-intel.h"
 #include "dwmac4.h"
 #include "stmmac.h"
diff --git a/drivers/ras/amd/fmpm.c b/drivers/ras/amd/fmpm.c
index 8877c6ff64c4..775c5231be57 100644
--- a/drivers/ras/amd/fmpm.c
+++ b/drivers/ras/amd/fmpm.c
@@ -46,8 +46,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cper.h>
-#include <linux/ras.h>
 #include <linux/cpu.h>
+#include <linux/ras.h>
 
 #include <acpi/apei.h>
 
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 3fc679b6f11b..c843cb5fc5c3 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -5,19 +5,19 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/module.h>
+#include <linux/cpu.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/intel_tcc.h>
-#include <linux/err.h>
+#include <linux/module.h>
 #include <linux/param.h>
-#include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/cpu.h>
-#include <linux/smp.h>
-#include <linux/slab.h>
 #include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
 #include <linux/thermal.h>
-#include <linux/debugfs.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/msr.h>
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 41309d38f78c..727a78bfdf02 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -24,40 +24,42 @@
 
 #define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
 
-#include <linux/linkage.h>
+#include <linux/atomic.h>
+#include <linux/cpuhotplug.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/moduleparam.h>
-#include <linux/string.h>
-#include <linux/memblock.h>
-#include <linux/slab.h>
 #include <linux/irqnr.h>
+#include <linux/ktime.h>
+#include <linux/linkage.h>
+#include <linux/memblock.h>
+#include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/rcupdate.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/cpuhotplug.h>
-#include <linux/atomic.h>
-#include <linux/ktime.h>
+#include <linux/string.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
-#include <asm/ptrace.h>
+#include <asm/i8259.h>
 #include <asm/idtentry.h>
-#include <asm/irq.h>
 #include <asm/io_apic.h>
-#include <asm/i8259.h>
+#include <asm/irq.h>
+#include <asm/ptrace.h>
 #include <asm/xen/cpuid.h>
 #include <asm/xen/pci.h>
 #endif
+
+#include <asm/hw_irq.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
-#include <xen/page.h>
 
 #include <xen/xen.h>
 #include <xen/hvm.h>
 #include <xen/xen-ops.h>
 #include <xen/events.h>
+#include <xen/page.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 #include <xen/interface/hvm/hvm_op.h>
@@ -66,7 +68,6 @@
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
 #include <xen/xenbus.h>
-#include <asm/hw_irq.h>
 
 #include "events_internal.h"
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 04a6b470b15d..a9ff69f08eb8 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -34,18 +34,18 @@
 #define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
 
 #include <linux/bitmap.h>
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <linux/io.h>
 #include <linux/memblock.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/ratelimit.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/uaccess.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/hardirq.h>
+#include <linux/vmalloc.h>
 #include <linux/workqueue.h>
-#include <linux/ratelimit.h>
-#include <linux/moduleparam.h>
 #ifdef CONFIG_XEN_GRANT_DMA_ALLOC
 #include <linux/dma-mapping.h>
 #endif
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index dcf9182c8451..589585b05f8a 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -33,22 +33,24 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/unistd.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/uio.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
 #include <linux/err.h>
-#include <linux/slab.h>
+#include <linux/errno.h>
 #include <linux/fcntl.h>
+#include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 #include <linux/reboot.h>
 #include <linux/rwsem.h>
-#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uio.h>
+#include <linux/unistd.h>
+
 #include <asm/xen/hypervisor.h>
-#include <xen/xenbus.h>
+
 #include <xen/xen.h>
+#include <xen/xenbus.h>
 #include "xenbus.h"
 
 /*
-- 
2.50.1


