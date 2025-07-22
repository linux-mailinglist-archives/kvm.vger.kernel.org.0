Return-Path: <kvm+bounces-53083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B14CB0D22C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F8A81AA1E52
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EEF28C5BD;
	Tue, 22 Jul 2025 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QcWXQKt3";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+WdnQ5RH"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3052A2D2389;
	Tue, 22 Jul 2025 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753167313; cv=none; b=hi2IY1tenjO4cnvYZecENxM74eX4JO2v5HkrLvaPB8pit+Xv/ZtCSpJH9xXzJMzmGqT3R4fuUQJ77SuqlSPsZ61vJ7rFjHVrwIkAhVux2L4YWoUSmBpwKgyadpPjS4Dap3AOSzl2MDS359yYYtqrlB01ckHRPTSGOxahb2cdAsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753167313; c=relaxed/simple;
	bh=Wi4Jxmpq9cANQHbso0xbmktejffaFQEgu9m2t1MRxM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIoc+9GvHlQUZ1WWcLFtgv+mHhv6nMQEjFDrew4MbpS77ewnotL7+Vh7jxXrngNMnVl7yR+8UV0JR5qRAyNRQo90Ri3ig9Q33UxnB3RnGbXp8K10gLI8ezAWUuvf8P5QdZvB5ToV9sh+DX6YW91+7c16vvv+o+FU9Kzav56V1IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QcWXQKt3; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+WdnQ5RH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753167308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3cNcEPW2ddSP7M2ewRfFQsZP/E0DY9yrPQ/boh/Rac8=;
	b=QcWXQKt3+ATBx0GGjuNTqIJM+35LpJUOwzl2/qbIFBWgLbRYqBwdHHnkXG1DkzrRgEnpOH
	7H6itvq+EUhr6b/9sxNEBPEYkcowEp/0bAp+97wsW7DhKXBuuZKyWj1naAcNbfhxNXXkAo
	v/0xme9+VsY1oog/74wn9Zvs75IXrklgOXRZhi6fI6ZqmikSH0xvPiop9U6ohd4NpvRErL
	p9CsmBxGk3v4e5RRoSIogE3n3mg0RsGjV2OJn6P+7qo+ZnnxWrlxE1o6to0DZRz907DFL8
	oryIpd8YF7AN4G11PfSGabYRSaEJ+nBWwM9QmCaJPaorUOXf4GaXBfBplUWc/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753167308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3cNcEPW2ddSP7M2ewRfFQsZP/E0DY9yrPQ/boh/Rac8=;
	b=+WdnQ5RHSme7cr8dDcrmIJpQ2BR0ZJB1eg0IG9ZVKUT9qpyP2nLDGIEo1fm7LOm8/rRSqi
	hZ+AALK1T8HqlTCg==
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
Subject: [PATCH v3 3/6] x86: Reorder headers alphabetically
Date: Tue, 22 Jul 2025 08:54:28 +0200
Message-ID: <20250722065448.413503-4-darwi@linutronix.de>
In-Reply-To: <20250722065448.413503-1-darwi@linutronix.de>
References: <20250722065448.413503-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multiple x86 source files use the cpuid_*() macros, but implicitly
include the main CPUID API header.

Sort their include lines so that <asm/cpuid/api.h> can be explicitly
included next.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/boot/startup/sme.c           |  8 +--
 arch/x86/coco/tdx/tdx.c               |  5 +-
 arch/x86/events/amd/uncore.c          | 14 +++---
 arch/x86/events/zhaoxin/core.c        | 11 ++---
 arch/x86/kernel/apic/apic.c           | 70 +++++++++++++--------------
 arch/x86/kernel/cpu/amd.c             | 25 +++++-----
 arch/x86/kernel/cpu/mce/core.c        | 62 ++++++++++++------------
 arch/x86/kernel/cpu/microcode/amd.c   | 12 ++---
 arch/x86/kernel/cpu/microcode/core.c  | 22 ++++-----
 arch/x86/kernel/cpu/microcode/intel.c | 11 +++--
 arch/x86/kernel/cpu/mshyperv.c        | 28 ++++++-----
 arch/x86/kernel/cpu/resctrl/core.c    |  5 +-
 arch/x86/kernel/cpu/scattered.c       |  2 +-
 arch/x86/kernel/cpu/topology_common.c |  2 +-
 arch/x86/kernel/cpu/vmware.c          | 13 ++---
 arch/x86/kernel/jailhouse.c           |  9 ++--
 arch/x86/kernel/kvm.c                 | 35 +++++++-------
 arch/x86/kernel/paravirt.c            | 28 +++++------
 arch/x86/kvm/mmu/mmu.c                | 56 ++++++++++-----------
 arch/x86/kvm/svm/sev.c                | 25 +++++-----
 arch/x86/kvm/svm/svm.c                | 50 +++++++++----------
 arch/x86/kvm/vmx/pmu_intel.c          |  6 ++-
 arch/x86/kvm/vmx/sgx.c                |  2 +-
 arch/x86/kvm/vmx/vmx.c                | 18 +++----
 arch/x86/mm/pti.c                     | 21 ++++----
 arch/x86/pci/xen.c                    | 22 ++++-----
 arch/x86/xen/enlighten_hvm.c          | 12 ++---
 arch/x86/xen/pmu.c                    | 12 +++--
 arch/x86/xen/time.c                   | 22 +++++----
 29 files changed, 312 insertions(+), 296 deletions(-)

diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index 70ea1748c0a7..922b236be02f 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -34,15 +34,15 @@
  */
 #define USE_EARLY_PGTABLE_L5
 
+#include <linux/cc_platform.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/mem_encrypt.h>
-#include <linux/cc_platform.h>
+#include <linux/mm.h>
 
+#include <asm/coco.h>
 #include <asm/init.h>
-#include <asm/setup.h>
 #include <asm/sections.h>
-#include <asm/coco.h>
+#include <asm/setup.h>
 #include <asm/sev.h>
 
 #define PGD_FLAGS		_KERNPG_TABLE_NOENC
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..7bc11836c46a 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -8,16 +8,17 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/kexec.h>
+
 #include <asm/coco.h>
-#include <asm/tdx.h>
-#include <asm/vmx.h>
 #include <asm/ia32.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/paravirt_types.h>
 #include <asm/pgtable.h>
 #include <asm/set_memory.h>
+#include <asm/tdx.h>
 #include <asm/traps.h>
+#include <asm/vmx.h>
 
 /* MMIO direction */
 #define EPT_READ	0
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index e8b6af199c73..c1483ef16c0b 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -5,18 +5,18 @@
  * Author: Jacob Shin <jacob.shin@amd.com>
  */
 
-#include <linux/perf_event.h>
-#include <linux/percpu.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/cpu.h>
-#include <linux/cpumask.h>
 #include <linux/cpufeature.h>
+#include <linux/cpumask.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
 #include <linux/smp.h>
+#include <linux/types.h>
 
-#include <asm/perf_event.h>
 #include <asm/msr.h>
+#include <asm/perf_event.h>
 
 #define NUM_COUNTERS_NB		4
 #define NUM_COUNTERS_L2		4
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 4bdfcf091200..d59992364880 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -5,16 +5,16 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/stddef.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
 
+#include <asm/apic.h>
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
-#include <asm/apic.h>
 #include <asm/msr.h>
 
 #include "../perf_event.h"
@@ -616,4 +616,3 @@ __init int zhaoxin_pmu_init(void)
 
 	return 0;
 }
-
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..f0e63842e2ef 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -15,57 +15,57 @@
  *	Mikael Pettersson	:	PM converted to driver model.
  */
 
-#include <linux/perf_event.h>
-#include <linux/kernel_stat.h>
-#include <linux/mc146818rtc.h>
 #include <linux/acpi_pmtmr.h>
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/memblock.h>
-#include <linux/ftrace.h>
-#include <linux/ioport.h>
-#include <linux/export.h>
-#include <linux/syscore_ops.h>
+#include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/timex.h>
-#include <linux/i8253.h>
 #include <linux/dmar.h>
-#include <linux/init.h>
-#include <linux/cpu.h>
 #include <linux/dmi.h>
-#include <linux/smp.h>
+#include <linux/export.h>
+#include <linux/ftrace.h>
+#include <linux/i8253.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/kernel_stat.h>
+#include <linux/mc146818rtc.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
+#include <linux/perf_event.h>
+#include <linux/smp.h>
+#include <linux/syscore_ops.h>
+#include <linux/timex.h>
 
 #include <xen/xen.h>
 
-#include <asm/trace/irq_vectors.h>
-#include <asm/irq_remapping.h>
-#include <asm/pc-conf-reg.h>
-#include <asm/perf_event.h>
-#include <asm/x86_init.h>
-#include <linux/atomic.h>
-#include <asm/barrier.h>
-#include <asm/mpspec.h>
-#include <asm/i8259.h>
-#include <asm/proto.h>
-#include <asm/traps.h>
-#include <asm/apic.h>
 #include <asm/acpi.h>
-#include <asm/io_apic.h>
+#include <asm/apic.h>
+#include <asm/barrier.h>
+#include <asm/cpu.h>
+#include <asm/cpu_device_id.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
-#include <asm/mtrr.h>
-#include <asm/time.h>
-#include <asm/smp.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-#include <asm/tsc.h>
 #include <asm/hypervisor.h>
-#include <asm/cpu_device_id.h>
+#include <asm/i8259.h>
 #include <asm/intel-family.h>
+#include <asm/io_apic.h>
 #include <asm/irq_regs.h>
-#include <asm/cpu.h>
+#include <asm/irq_remapping.h>
+#include <asm/mce.h>
+#include <asm/mpspec.h>
+#include <asm/msr.h>
+#include <asm/mtrr.h>
+#include <asm/pc-conf-reg.h>
+#include <asm/perf_event.h>
+#include <asm/proto.h>
+#include <asm/smp.h>
+#include <asm/time.h>
+#include <asm/trace/irq_vectors.h>
+#include <asm/traps.h>
+#include <asm/tsc.h>
+#include <asm/x86_init.h>
 
 #include "local.h"
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 329ee185d8cc..c98b0d952537 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,32 +1,33 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <linux/export.h>
+
 #include <linux/bitops.h>
 #include <linux/elf.h>
-#include <linux/mm.h>
-
+#include <linux/export.h>
 #include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/platform_data/x86/amd-fch.h>
+#include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
-#include <linux/random.h>
 #include <linux/topology.h>
-#include <linux/platform_data/x86/amd-fch.h>
-#include <asm/processor.h>
+
 #include <asm/apic.h>
 #include <asm/cacheinfo.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
-#include <asm/spec-ctrl.h>
-#include <asm/smp.h>
+#include <asm/debugreg.h>
+#include <asm/delay.h>
+#include <asm/msr.h>
 #include <asm/numa.h>
 #include <asm/pci-direct.h>
-#include <asm/delay.h>
-#include <asm/debugreg.h>
+#include <asm/processor.h>
 #include <asm/resctrl.h>
-#include <asm/msr.h>
 #include <asm/sev.h>
+#include <asm/smp.h>
+#include <asm/spec-ctrl.h>
 
 #ifdef CONFIG_X86_64
-# include <asm/mmconfig.h>
+#include <asm/mmconfig.h>
 #endif
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4da4eab56c81..5a11c522ea97 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -9,52 +9,52 @@
  * Author: Andi Kleen
  */
 
-#include <linux/thread_info.h>
 #include <linux/capability.h>
-#include <linux/miscdevice.h>
-#include <linux/ratelimit.h>
-#include <linux/rcupdate.h>
-#include <linux/kobject.h>
-#include <linux/uaccess.h>
-#include <linux/kdebug.h>
-#include <linux/kernel.h>
-#include <linux/percpu.h>
-#include <linux/string.h>
-#include <linux/device.h>
-#include <linux/syscore_ops.h>
-#include <linux/delay.h>
+#include <linux/cpu.h>
 #include <linux/ctype.h>
-#include <linux/sched.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
+#include <linux/irq_work.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
 #include <linux/kmod.h>
-#include <linux/poll.h>
+#include <linux/kobject.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
 #include <linux/nmi.h>
-#include <linux/cpu.h>
+#include <linux/percpu.h>
+#include <linux/poll.h>
 #include <linux/ras.h>
-#include <linux/smp.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/debugfs.h>
-#include <linux/irq_work.h>
-#include <linux/export.h>
+#include <linux/ratelimit.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
 #include <linux/set_memory.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/string.h>
 #include <linux/sync_core.h>
+#include <linux/syscore_ops.h>
+#include <linux/sysfs.h>
 #include <linux/task_work.h>
-#include <linux/hardirq.h>
-#include <linux/kexec.h>
+#include <linux/thread_info.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
 
-#include <asm/fred.h>
 #include <asm/cpu_device_id.h>
-#include <asm/processor.h>
-#include <asm/traps.h>
-#include <asm/tlbflush.h>
+#include <asm/fred.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
+#include <asm/processor.h>
 #include <asm/reboot.h>
 #include <asm/tdx.h>
+#include <asm/tlbflush.h>
+#include <asm/traps.h>
 
 #include "internal.h"
 
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 097e39327942..fc62ebf96f01 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -21,23 +21,23 @@
  */
 #define pr_fmt(fmt) "microcode: " fmt
 
+#include <linux/bsearch.h>
 #include <linux/earlycpio.h>
 #include <linux/firmware.h>
-#include <linux/bsearch.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
 #include <linux/initrd.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 
 #include <crypto/sha2.h>
 
-#include <asm/microcode.h>
-#include <asm/processor.h>
 #include <asm/cmdline.h>
-#include <asm/setup.h>
 #include <asm/cpu.h>
+#include <asm/microcode.h>
 #include <asm/msr.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
 #include <asm/tlb.h>
 
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index fe50eb5b7c4a..9243ed3ded85 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -17,27 +17,27 @@
 
 #define pr_fmt(fmt) "microcode: " fmt
 
-#include <linux/platform_device.h>
-#include <linux/stop_machine.h>
-#include <linux/syscore_ops.h>
-#include <linux/miscdevice.h>
 #include <linux/capability.h>
-#include <linux/firmware.h>
+#include <linux/cpu.h>
 #include <linux/cpumask.h>
-#include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/mutex.h>
-#include <linux/cpu.h>
-#include <linux/nmi.h>
+#include <linux/firmware.h>
 #include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/nmi.h>
+#include <linux/platform_device.h>
+#include <linux/stop_machine.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
+#include <asm/cmdline.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include <asm/perf_event.h>
 #include <asm/processor.h>
-#include <asm/cmdline.h>
-#include <asm/msr.h>
 #include <asm/setup.h>
 
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 371ca6eac00e..99fda8f7dba7 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -11,21 +11,22 @@
  *		      H Peter Anvin" <hpa@zytor.com>
  */
 #define pr_fmt(fmt) "microcode: " fmt
+
+#include <linux/cpu.h>
 #include <linux/earlycpio.h>
 #include <linux/firmware.h>
-#include <linux/uaccess.h>
 #include <linux/initrd.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/cpu.h>
+#include <linux/uaccess.h>
 #include <linux/uio.h>
-#include <linux/mm.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include <asm/processor.h>
-#include <asm/tlbflush.h>
 #include <asm/setup.h>
-#include <asm/msr.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c78f860419d6..d0491bba9e30 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -6,33 +6,35 @@
  * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
  */
 
-#include <linux/types.h>
-#include <linux/time.h>
 #include <linux/clocksource.h>
-#include <linux/init.h>
+#include <linux/efi.h>
 #include <linux/export.h>
 #include <linux/hardirq.h>
-#include <linux/efi.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/random.h>
-#include <asm/processor.h>
-#include <asm/hypervisor.h>
+#include <linux/time.h>
+#include <linux/types.h>
+
+#include <clocksource/hyperv_timer.h>
 #include <hyperv/hvhdk.h>
-#include <asm/mshyperv.h>
+
+#include <asm/apic.h>
 #include <asm/desc.h>
+#include <asm/hypervisor.h>
+#include <asm/i8259.h>
 #include <asm/idtentry.h>
 #include <asm/irq_regs.h>
-#include <asm/i8259.h>
-#include <asm/apic.h>
-#include <asm/timer.h>
-#include <asm/reboot.h>
-#include <asm/nmi.h>
-#include <clocksource/hyperv_timer.h>
+#include <asm/mshyperv.h>
 #include <asm/msr.h>
+#include <asm/nmi.h>
 #include <asm/numa.h>
+#include <asm/processor.h>
+#include <asm/reboot.h>
 #include <asm/svm.h>
+#include <asm/timer.h>
 
 /* Is Linux running on nested Microsoft Hypervisor */
 bool hv_nested;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 187d527ef73b..35285567beec 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -17,13 +17,14 @@
 #define pr_fmt(fmt)	"resctrl: " fmt
 
 #include <linux/cpu.h>
-#include <linux/slab.h>
-#include <linux/err.h>
 #include <linux/cpuhotplug.h>
+#include <linux/err.h>
+#include <linux/slab.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/msr.h>
 #include <asm/resctrl.h>
+
 #include "internal.h"
 
 /*
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..b52d00e8ad54 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -4,8 +4,8 @@
  */
 #include <linux/cpu.h>
 
-#include <asm/memtype.h>
 #include <asm/apic.h>
+#include <asm/memtype.h>
 #include <asm/processor.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/topology_common.c b/arch/x86/kernel/cpu/topology_common.c
index b5a5e1411469..48c47d02d8a9 100644
--- a/arch/x86/kernel/cpu/topology_common.c
+++ b/arch/x86/kernel/cpu/topology_common.c
@@ -3,8 +3,8 @@
 
 #include <xen/xen.h>
 
-#include <asm/intel-family.h>
 #include <asm/apic.h>
+#include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index cb3f900c46fc..f5e82d15d0b1 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -21,21 +21,22 @@
  *
  */
 
-#include <linux/dmi.h>
-#include <linux/init.h>
-#include <linux/export.h>
 #include <linux/clocksource.h>
 #include <linux/cpu.h>
+#include <linux/dmi.h>
 #include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/init.h>
 #include <linux/reboot.h>
 #include <linux/static_call.h>
+
+#include <asm/apic.h>
 #include <asm/div64.h>
-#include <asm/x86_init.h>
 #include <asm/hypervisor.h>
+#include <asm/svm.h>
 #include <asm/timer.h>
-#include <asm/apic.h>
 #include <asm/vmware.h>
-#include <asm/svm.h>
+#include <asm/x86_init.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"vmware: " fmt
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index 9e9a591a5fec..f38d4516f7e7 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -8,22 +8,23 @@
  *  Jan Kiszka <jan.kiszka@siemens.com>
  */
 
+#include <linux/acpi.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/kernel.h>
 #include <linux/reboot.h>
 #include <linux/serial_8250.h>
-#include <linux/acpi.h>
-#include <asm/apic.h>
-#include <asm/io_apic.h>
+
 #include <asm/acpi.h>
+#include <asm/apic.h>
 #include <asm/cpu.h>
 #include <asm/hypervisor.h>
 #include <asm/i8259.h>
+#include <asm/io_apic.h>
 #include <asm/irqdomain.h>
+#include <asm/jailhouse_para.h>
 #include <asm/pci_x86.h>
 #include <asm/reboot.h>
 #include <asm/setup.h>
-#include <asm/jailhouse_para.h>
 
 static struct jailhouse_setup_data setup_data;
 #define SETUP_DATA_V1_LEN	(sizeof(setup_data.hdr) + sizeof(setup_data.v1))
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc1..cd3520a6248b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -9,42 +9,43 @@
 
 #define pr_fmt(fmt) "kvm-guest: " fmt
 
+#include <linux/cc_platform.h>
 #include <linux/context_tracking.h>
+#include <linux/cpu.h>
+#include <linux/efi.h>
+#include <linux/hardirq.h>
+#include <linux/hash.h>
+#include <linux/highmem.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
+#include <linux/kprobes.h>
 #include <linux/kvm_para.h>
-#include <linux/cpu.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/hardirq.h>
+#include <linux/nmi.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-#include <linux/hash.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/kprobes.h>
-#include <linux/nmi.h>
 #include <linux/swait.h>
 #include <linux/syscore_ops.h>
-#include <linux/cc_platform.h>
-#include <linux/efi.h>
-#include <asm/timer.h>
-#include <asm/cpu.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
-#include <asm/tlbflush.h>
+
 #include <asm/apic.h>
 #include <asm/apicdef.h>
-#include <asm/hypervisor.h>
-#include <asm/mtrr.h>
-#include <asm/tlb.h>
+#include <asm/cpu.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/desc.h>
+#include <asm/e820/api.h>
+#include <asm/hypervisor.h>
 #include <asm/msr.h>
+#include <asm/mtrr.h>
 #include <asm/ptrace.h>
 #include <asm/reboot.h>
 #include <asm/svm.h>
-#include <asm/e820/api.h>
+#include <asm/timer.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+#include <asm/traps.h>
 
 DEFINE_STATIC_KEY_FALSE_RO(kvm_async_pf_enabled);
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..3d745cd25a43 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -6,34 +6,34 @@
     2007 - x86_64 support added by Glauber de Oliveira Costa, Red Hat Inc
 */
 
+#include <linux/bcd.h>
+#include <linux/efi.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/export.h>
-#include <linux/efi.h>
-#include <linux/bcd.h>
 #include <linux/highmem.h>
+#include <linux/init.h>
 #include <linux/kprobes.h>
 #include <linux/pgtable.h>
 #include <linux/static_call.h>
 
+#include <asm/apic.h>
 #include <asm/bug.h>
-#include <asm/paravirt.h>
 #include <asm/debugreg.h>
+#include <asm/delay.h>
 #include <asm/desc.h>
+#include <asm/fixmap.h>
+#include <asm/gsseg.h>
+#include <asm/io_bitmap.h>
+#include <asm/irq.h>
+#include <asm/msr.h>
+#include <asm/paravirt.h>
+#include <asm/pgalloc.h>
 #include <asm/setup.h>
+#include <asm/special_insns.h>
 #include <asm/time.h>
-#include <asm/pgalloc.h>
-#include <asm/irq.h>
-#include <asm/delay.h>
-#include <asm/fixmap.h>
-#include <asm/apic.h>
-#include <asm/tlbflush.h>
 #include <asm/timer.h>
-#include <asm/special_insns.h>
 #include <asm/tlb.h>
-#include <asm/io_bitmap.h>
-#include <asm/gsseg.h>
-#include <asm/msr.h>
+#include <asm/tlbflush.h>
 
 /* stub always returning 0. */
 DEFINE_ASM_FUNC(paravirt_ret0, "xor %eax,%eax", .entry.text);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..08bd094f2945 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -16,47 +16,47 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include "irq.h"
-#include "ioapic.h"
-#include "mmu.h"
-#include "mmu_internal.h"
-#include "tdp_mmu.h"
-#include "x86.h"
-#include "kvm_cache_regs.h"
-#include "smm.h"
-#include "kvm_emulate.h"
-#include "page_track.h"
-#include "cpuid.h"
-#include "spte.h"
-
-#include <linux/kvm_host.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/moduleparam.h>
-#include <linux/export.h>
-#include <linux/swap.h>
-#include <linux/hugetlb.h>
 #include <linux/compiler.h>
-#include <linux/srcu.h>
-#include <linux/slab.h>
-#include <linux/sched/signal.h>
-#include <linux/uaccess.h>
+#include <linux/export.h>
 #include <linux/hash.h>
+#include <linux/highmem.h>
+#include <linux/hugetlb.h>
 #include <linux/kern_levels.h>
 #include <linux/kstrtox.h>
 #include <linux/kthread.h>
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/string.h>
+#include <linux/swap.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
 #include <linux/wordpart.h>
 
-#include <asm/page.h>
-#include <asm/memtype.h>
 #include <asm/cmpxchg.h>
 #include <asm/io.h>
+#include <asm/memtype.h>
+#include <asm/page.h>
 #include <asm/set_memory.h>
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
 
+#include "cpuid.h"
+#include "ioapic.h"
+#include "irq.h"
+#include "kvm_cache_regs.h"
+#include "kvm_emulate.h"
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "page_track.h"
+#include "smm.h"
+#include "spte.h"
+#include "tdp_mmu.h"
+#include "x86.h"
+
 #include "trace.h"
 
 static bool nx_hugepage_mitigation_hard_disabled;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b201f77fcd49..d64392bc0228 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -8,33 +8,34 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kvm_types.h>
-#include <linux/kvm_host.h>
-#include <linux/kernel.h>
 #include <linux/highmem.h>
-#include <linux/psp.h>
-#include <linux/psp-sev.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
 #include <linux/misc_cgroup.h>
+#include <linux/pagemap.h>
 #include <linux/processor.h>
+#include <linux/psp-sev.h>
+#include <linux/psp.h>
+#include <linux/swap.h>
 #include <linux/trace_events.h>
+
 #include <uapi/linux/sev-guest.h>
 
-#include <asm/pkru.h>
-#include <asm/trapnr.h>
+#include <asm/debugreg.h>
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
-#include <asm/debugreg.h>
 #include <asm/msr.h>
+#include <asm/pkru.h>
 #include <asm/sev.h>
+#include <asm/trapnr.h>
 
+#include "cpuid.h"
 #include "mmu.h"
-#include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
-#include "cpuid.h"
 #include "trace.h"
+#include "x86.h"
 
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_DEFAULT	2ULL
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..d8504af36836 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2,48 +2,48 @@
 
 #include <linux/kvm_host.h>
 
+#include "cpuid.h"
 #include "irq.h"
-#include "mmu.h"
 #include "kvm_cache_regs.h"
-#include "x86.h"
-#include "smm.h"
-#include "cpuid.h"
+#include "mmu.h"
 #include "pmu.h"
+#include "smm.h"
+#include "x86.h"
 
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/kernel.h>
-#include <linux/vmalloc.h>
-#include <linux/highmem.h>
 #include <linux/amd-iommu.h>
-#include <linux/sched.h>
-#include <linux/trace_events.h>
-#include <linux/slab.h>
+#include <linux/cc_platform.h>
+#include <linux/file.h>
 #include <linux/hashtable.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/objtool.h>
-#include <linux/psp-sev.h>
-#include <linux/file.h>
 #include <linux/pagemap.h>
-#include <linux/swap.h>
+#include <linux/psp-sev.h>
 #include <linux/rwsem.h>
-#include <linux/cc_platform.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/string_choices.h>
-#include <linux/mutex.h>
+#include <linux/swap.h>
+#include <linux/trace_events.h>
+#include <linux/vmalloc.h>
 
 #include <asm/apic.h>
-#include <asm/msr.h>
-#include <asm/perf_event.h>
-#include <asm/tlbflush.h>
-#include <asm/desc.h>
+#include <asm/cpu_device_id.h>
 #include <asm/debugreg.h>
-#include <asm/kvm_para.h>
+#include <asm/desc.h>
+#include <asm/fpu/api.h>
 #include <asm/irq_remapping.h>
+#include <asm/kvm_para.h>
+#include <asm/msr.h>
+#include <asm/perf_event.h>
+#include <asm/reboot.h>
 #include <asm/spec-ctrl.h>
-#include <asm/cpu_device_id.h>
+#include <asm/tlbflush.h>
 #include <asm/traps.h>
-#include <asm/reboot.h>
-#include <asm/fpu/api.h>
 
 #include <trace/events/ipi.h>
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bbf4509f32d0..64208fe5aa96 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -10,17 +10,19 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/types.h>
+
 #include <asm/msr.h>
 #include <asm/perf_event.h>
-#include "x86.h"
+
 #include "cpuid.h"
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
 #include "tdx.h"
+#include "x86.h"
 
 /*
  * Perf's "BASE" is wildly misleading, architectural PMUs use bits 31:16 of ECX
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index df1d0cf76947..f70128063bd5 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -5,11 +5,11 @@
 #include <asm/msr.h>
 #include <asm/sgx.h>
 
-#include "x86.h"
 #include "kvm_cache_regs.h"
 #include "nested.h"
 #include "sgx.h"
 #include "vmx.h"
+#include "x86.h"
 
 bool __read_mostly enable_sgx = 1;
 module_param_named(sgx, enable_sgx, bool, 0444);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 191a9ed0da22..2bf9d4326a19 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -14,21 +14,21 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/entry-kvm.h>
 #include <linux/highmem.h>
 #include <linux/hrtimer.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mod_devicetable.h>
-#include <linux/mm.h>
 #include <linux/objtool.h>
 #include <linux/sched.h>
 #include <linux/sched/smt.h>
 #include <linux/slab.h>
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
-#include <linux/entry-kvm.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -42,12 +42,12 @@
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
-#include <asm/reboot.h>
-#include <asm/perf_event.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
 #include <asm/msr.h>
 #include <asm/mwait.h>
+#include <asm/perf_event.h>
+#include <asm/reboot.h>
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
 
@@ -57,23 +57,23 @@
 #include "common.h"
 #include "cpuid.h"
 #include "hyperv.h"
-#include "kvm_onhyperv.h"
 #include "irq.h"
 #include "kvm_cache_regs.h"
+#include "kvm_onhyperv.h"
 #include "lapic.h"
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
+#include "posted_intr.h"
 #include "sgx.h"
+#include "smm.h"
 #include "trace.h"
 #include "vmcs.h"
 #include "vmcs12.h"
 #include "vmx.h"
+#include "vmx_onhyperv.h"
 #include "x86.h"
 #include "x86_ops.h"
-#include "smm.h"
-#include "vmx_onhyperv.h"
-#include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_DESCRIPTION("KVM support for VMX (Intel VT-x) extensions");
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index c0c40b67524e..9d5d57a84a3c 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -18,26 +18,27 @@
  * Mostly rewritten by Thomas Gleixner <tglx@linutronix.de> and
  *		       Andy Lutomirsky <luto@amacapital.net>
  */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/types.h>
+
 #include <linux/bug.h>
+#include <linux/cpu.h>
+#include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/cpu.h>
 
+#include <asm/cmdline.h>
 #include <asm/cpufeature.h>
+#include <asm/desc.h>
 #include <asm/hypervisor.h>
-#include <asm/vsyscall.h>
-#include <asm/cmdline.h>
 #include <asm/pti.h>
-#include <asm/tlbflush.h>
-#include <asm/desc.h>
 #include <asm/sections.h>
 #include <asm/set_memory.h>
+#include <asm/tlbflush.h>
+#include <asm/vsyscall.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt)     "Kernel/User page tables isolation: " fmt
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index b8755cde2419..e23c7f730f07 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -10,25 +10,26 @@
  *           Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
  *           Stefano Stabellini <stefano.stabellini@eu.citrix.com>
  */
+
+#include <linux/acpi.h>
 #include <linux/export.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/pci.h>
-#include <linux/acpi.h>
 
-#include <linux/io.h>
+#include <xen/events.h>
+#include <xen/features.h>
+#include <xen/pci.h>
+
+#include <asm/acpi.h>
+#include <asm/apic.h>
+#include <asm/i8259.h>
 #include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
+#include <asm/xen/cpuid.h>
 #include <asm/xen/hypervisor.h>
-
-#include <xen/features.h>
-#include <xen/events.h>
-#include <xen/pci.h>
 #include <asm/xen/pci.h>
-#include <asm/xen/cpuid.h>
-#include <asm/apic.h>
-#include <asm/acpi.h>
-#include <asm/i8259.h>
 
 static int xen_pcifront_enable_irq(struct pci_dev *dev)
 {
@@ -583,4 +584,3 @@ int __init pci_xen_initial_domain(void)
 	return 0;
 }
 #endif
-
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index fe57ff85d004..6b736b18826b 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -6,22 +6,22 @@
 #include <linux/memblock.h>
 #include <linux/virtio_anchor.h>
 
-#include <xen/features.h>
 #include <xen/events.h>
+#include <xen/features.h>
 #include <xen/hvm.h>
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/memory.h>
 
 #include <asm/apic.h>
 #include <asm/cpu.h>
-#include <asm/smp.h>
+#include <asm/e820/api.h>
+#include <asm/early_ioremap.h>
+#include <asm/hypervisor.h>
+#include <asm/idtentry.h>
 #include <asm/io_apic.h>
 #include <asm/reboot.h>
 #include <asm/setup.h>
-#include <asm/idtentry.h>
-#include <asm/hypervisor.h>
-#include <asm/e820/api.h>
-#include <asm/early_ioremap.h>
+#include <asm/smp.h>
 
 #include <asm/xen/cpuid.h>
 #include <asm/xen/hypervisor.h>
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 8f89ce0b67e3..fae48c14ec45 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -1,14 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/types.h>
+
 #include <linux/interrupt.h>
+#include <linux/types.h>
 
-#include <asm/msr.h>
-#include <asm/xen/hypercall.h>
-#include <xen/xen.h>
-#include <xen/page.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/xenpmu.h>
+#include <xen/page.h>
+#include <xen/xen.h>
+
+#include <asm/msr.h>
+#include <asm/xen/hypercall.h>
 
 #include "xen-ops.h"
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 96521b1874ac..229f8161eeab 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -8,24 +8,26 @@
  *
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/clocksource.h>
+
 #include <linux/clockchips.h>
+#include <linux/clocksource.h>
 #include <linux/gfp.h>
-#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/slab.h>
 #include <linux/timekeeper_internal.h>
 
-#include <asm/pvclock.h>
-#include <asm/xen/hypervisor.h>
-#include <asm/xen/hypercall.h>
-#include <asm/xen/cpuid.h>
-
 #include <xen/events.h>
 #include <xen/features.h>
-#include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/xen.h>
+
+#include <asm/pvclock.h>
+
+#include <asm/xen/cpuid.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include "xen-ops.h"
 
-- 
2.50.1


