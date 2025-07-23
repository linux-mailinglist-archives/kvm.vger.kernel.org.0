Return-Path: <kvm+bounces-53279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31912B0F976
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3C5C188865E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBCE24338F;
	Wed, 23 Jul 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CwVXR2sp";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IqfQ26c8"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D0724113D;
	Wed, 23 Jul 2025 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292224; cv=none; b=ZhWMtf8/1n5dqrCFg4B5++uj1VnVC+HhDjv+x6fBDSGXQHC97RGep/Huty+RlY/rFr4dXdhyJ+0dzGHYnzTlA5+DtrQgBhFtemrX+f16ZSqehZqbVtVWQiKNIJ7KlLWXWoM1q0DIkGfumz1A2aCUJR8OqfC9zvquBOWcDetzH4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292224; c=relaxed/simple;
	bh=hXQSg4Xs8I2LtM9nOvS9ZDET8DFR1hmXpWuPWP8kybM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siFBBslTzXRInmTe9VBAhopTR0eFLwO1dx+OVth7nPw41M6iJ53wmB5falotM2FQKtveXdtL8UDDg0dApikp3+GSqmh0cmNadZqnf5XIqgwsgWTuyTrO7iQtjmqSeWkPrZGq9GI5TuAl2HHxKZKMBxqzfEW1s9t558+kPb3eHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CwVXR2sp; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=IqfQ26c8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753292219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HvFPbng4Rn+ZcZAOeTwk1u57fq2Xl06GtrP4Xp0+B2w=;
	b=CwVXR2spmWILGYJWVYtJwPD/y/dQM9N740Fz9JhajUNs0/tc6RU0od+vQu/o2SaL5tI0aW
	ECVtYtouI25rBuCIlagXDq2+fLePfTJbU9mdCPMJyWNFKjlHtdXZPlzJCu6iaHV6mIQiJz
	cFEjlB1AFBRW6PeckCmEMhbT/BqMWEM3Z71yghQP/yImdb/Mjfm+axtBNStaLNXtHy5LjP
	2KxTHPJrvFMj8insciIup9s26xuQbo2xw8G73TE7R0Qtngm7siSkPb7hO2Ao/7Ko8bxrZH
	vcmWvvlbeT4agvT+O8cje5oiErc9aDFWqskOBIJNckpR326I9ItgMFhOlIA0Vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753292219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HvFPbng4Rn+ZcZAOeTwk1u57fq2Xl06GtrP4Xp0+B2w=;
	b=IqfQ26c8RpltQ8TcsE0Lexclz5k28uPfpSubNLgbc3OTQkhgYg4FrjuSHjIP2Xqjsnzx0A
	4h+ah/NpczpfZUBg==
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
Subject: [PATCH v4 3/4] treewide: Explicitly include the x86 CPUID headers
Date: Wed, 23 Jul 2025 19:36:42 +0200
Message-ID: <20250723173644.33568-4-darwi@linutronix.de>
In-Reply-To: <20250723173644.33568-1-darwi@linutronix.de>
References: <20250723173644.33568-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify all CPUID call sites which implicitly include any of the CPUID
headers to explicitly include them instead.

For arch/x86/kvm/reverse_cpuid.h, just include <asm/cpuid/types.h> since
it references the CPUID_EAX..EDX symbols without using any of the CPUID
APIs.

Note, adding explicit CPUID includes for all call sites allows removing
the <asm/cpuid/api.h> include from <asm/processor.h> next.  This way, the
CPUID API header can include <asm/procesor.h> at a later step without
introducing a circular dependency.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/boot/compressed/pgtable_64.c             | 1 +
 arch/x86/boot/startup/sme.c                       | 1 +
 arch/x86/coco/tdx/tdx.c                           | 1 +
 arch/x86/events/amd/core.c                        | 2 ++
 arch/x86/events/amd/ibs.c                         | 1 +
 arch/x86/events/amd/lbr.c                         | 2 ++
 arch/x86/events/amd/power.c                       | 3 +++
 arch/x86/events/amd/uncore.c                      | 1 +
 arch/x86/events/intel/core.c                      | 1 +
 arch/x86/events/intel/lbr.c                       | 1 +
 arch/x86/events/zhaoxin/core.c                    | 1 +
 arch/x86/include/asm/acrn.h                       | 2 ++
 arch/x86/include/asm/microcode.h                  | 1 +
 arch/x86/include/asm/xen/hypervisor.h             | 1 +
 arch/x86/kernel/apic/apic.c                       | 1 +
 arch/x86/kernel/cpu/amd.c                         | 1 +
 arch/x86/kernel/cpu/centaur.c                     | 1 +
 arch/x86/kernel/cpu/hygon.c                       | 1 +
 arch/x86/kernel/cpu/mce/core.c                    | 1 +
 arch/x86/kernel/cpu/mce/inject.c                  | 1 +
 arch/x86/kernel/cpu/microcode/amd.c               | 1 +
 arch/x86/kernel/cpu/microcode/core.c              | 1 +
 arch/x86/kernel/cpu/microcode/intel.c             | 1 +
 arch/x86/kernel/cpu/mshyperv.c                    | 1 +
 arch/x86/kernel/cpu/resctrl/core.c                | 1 +
 arch/x86/kernel/cpu/resctrl/monitor.c             | 1 +
 arch/x86/kernel/cpu/scattered.c                   | 1 +
 arch/x86/kernel/cpu/sgx/driver.c                  | 3 +++
 arch/x86/kernel/cpu/sgx/main.c                    | 3 +++
 arch/x86/kernel/cpu/topology_amd.c                | 1 +
 arch/x86/kernel/cpu/topology_common.c             | 1 +
 arch/x86/kernel/cpu/topology_ext.c                | 1 +
 arch/x86/kernel/cpu/transmeta.c                   | 3 +++
 arch/x86/kernel/cpu/vmware.c                      | 1 +
 arch/x86/kernel/cpu/zhaoxin.c                     | 1 +
 arch/x86/kernel/cpuid.c                           | 1 +
 arch/x86/kernel/jailhouse.c                       | 1 +
 arch/x86/kernel/kvm.c                             | 1 +
 arch/x86/kernel/paravirt.c                        | 1 +
 arch/x86/kvm/mmu/mmu.c                            | 1 +
 arch/x86/kvm/mmu/spte.c                           | 1 +
 arch/x86/kvm/reverse_cpuid.h                      | 2 ++
 arch/x86/kvm/svm/svm.c                            | 1 +
 arch/x86/kvm/vmx/pmu_intel.c                      | 1 +
 arch/x86/kvm/vmx/sgx.c                            | 1 +
 arch/x86/kvm/vmx/vmx.c                            | 1 +
 arch/x86/mm/pti.c                                 | 1 +
 arch/x86/pci/xen.c                                | 2 +-
 arch/x86/xen/enlighten_hvm.c                      | 1 +
 arch/x86/xen/pmu.c                                | 1 +
 arch/x86/xen/time.c                               | 1 +
 drivers/char/agp/efficeon-agp.c                   | 1 +
 drivers/cpufreq/longrun.c                         | 1 +
 drivers/cpufreq/powernow-k7.c                     | 2 +-
 drivers/cpufreq/powernow-k8.c                     | 1 +
 drivers/cpufreq/speedstep-lib.c                   | 1 +
 drivers/firmware/efi/libstub/x86-5lvl.c           | 1 +
 drivers/gpu/drm/gma500/mmu.c                      | 2 ++
 drivers/hwmon/fam15h_power.c                      | 1 +
 drivers/hwmon/k10temp.c                           | 2 ++
 drivers/hwmon/k8temp.c                            | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 drivers/ras/amd/fmpm.c                            | 1 +
 drivers/thermal/intel/intel_hfi.c                 | 1 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c      | 1 +
 drivers/virt/acrn/hsm.c                           | 1 +
 drivers/xen/events/events_base.c                  | 1 +
 drivers/xen/grant-table.c                         | 1 +
 drivers/xen/xenbus/xenbus_xs.c                    | 3 +++
 69 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index bdd26050dff7..d94d98595780 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -2,6 +2,7 @@
 #include "misc.h"
 #include <asm/bootparam.h>
 #include <asm/bootparam_utils.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/types.h>
 #include <asm/processor.h>
 #include "../string.h"
diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index 70ea1748c0a7..1b1bcb41bf23 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -42,6 +42,7 @@
 #include <asm/init.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
+#include <asm/cpuid/api.h>
 #include <asm/coco.h>
 #include <asm/sev.h>
 
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..168388be3a3e 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -14,6 +14,7 @@
 #include <asm/ia32.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/cpuid/api.h>
 #include <asm/paravirt_types.h>
 #include <asm/pgtable.h>
 #include <asm/set_memory.h>
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index b20661b8621d..d28d45ceb707 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -7,8 +7,10 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+
 #include <asm/apicdef.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
 
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..0c7848e6149e 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -15,6 +15,7 @@
 #include <linux/sched/clock.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "../perf_event.h"
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index d24da377df77..5b437dc8e4ce 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/perf_event.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
 
diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index dad42790cf7d..744dffa42dee 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -10,8 +10,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
+
 #include "../perf_event.h"
 
 /* Event code: LSB 8 bits, passed in attr->config any other bit is reserved. */
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index e8b6af199c73..c602542f3a36 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -16,6 +16,7 @@
 #include <linux/smp.h>
 
 #include <asm/perf_event.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #define NUM_COUNTERS_NB		4
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270e..ebbcdf82b494 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -17,6 +17,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/hardirq.h>
 #include <asm/intel-family.h>
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 7aa59966e7c3..0d1ec3651735 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -3,6 +3,7 @@
 #include <linux/types.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 4bdfcf091200..6ed644fe89aa 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -13,6 +13,7 @@
 #include <linux/nmi.h>
 
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 #include <asm/msr.h>
diff --git a/arch/x86/include/asm/acrn.h b/arch/x86/include/asm/acrn.h
index fab11192c60a..db42b477c41d 100644
--- a/arch/x86/include/asm/acrn.h
+++ b/arch/x86/include/asm/acrn.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_ACRN_H
 #define _ASM_X86_ACRN_H
 
+#include <asm/cpuid/api.h>
+
 /*
  * This CPUID returns feature bitmaps in EAX.
  * Guest VM uses this to detect the appropriate feature bit.
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 8b41f26f003b..645e65ac1586 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_MICROCODE_H
 
 #include <asm/msr.h>
+#include <asm/cpuid/api.h>
 
 struct cpu_signature {
 	unsigned int sig;
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index c2fc7869b996..7c596cebfb78 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,6 +37,7 @@ extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
 #include <asm/bug.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 #define XEN_SIGNATURE "XenVMMXenVMM"
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..42045b7200ac 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -63,6 +63,7 @@
 #include <asm/tsc.h>
 #include <asm/hypervisor.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/intel-family.h>
 #include <asm/irq_regs.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 329ee185d8cc..9f706a832ffb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -15,6 +15,7 @@
 #include <asm/cacheinfo.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/spec-ctrl.h>
 #include <asm/smp.h>
 #include <asm/numa.h>
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index a3b55db35c96..cc5a390dcd07 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -5,6 +5,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 2154f12766fb..75ad7eb1301a 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -10,6 +10,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/smp.h>
 #include <asm/numa.h>
 #include <asm/cacheinfo.h>
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4da4eab56c81..2b0da00b9d4b 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -48,6 +48,7 @@
 
 #include <asm/fred.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
 #include <asm/tlbflush.h>
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index d02c4f556cd0..42c82c14c48a 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -26,6 +26,7 @@
 
 #include <asm/amd/nb.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/irq_vectors.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 097e39327942..eddb665b2db2 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -34,6 +34,7 @@
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
+#include <asm/cpuid/api.h>
 #include <asm/cmdline.h>
 #include <asm/setup.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index fe50eb5b7c4a..ee0cf65c0f47 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -34,6 +34,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/perf_event.h>
 #include <asm/processor.h>
 #include <asm/cmdline.h>
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 371ca6eac00e..dacfbffe4cd2 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c78f860419d6..b397c1385ebd 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
+#include <asm/cpuid/api.h>
 #include <hyperv/hvhdk.h>
 #include <asm/mshyperv.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 187d527ef73b..c1dd1a3d4b38 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,6 +22,7 @@
 #include <linux/cpuhotplug.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/resctrl.h>
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c261558276cd..5dffb9453d77 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -21,6 +21,7 @@
 #include <linux/resctrl.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..54b98b326f33 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -6,6 +6,7 @@
 
 #include <asm/memtype.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..f0c0a001bce6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -6,7 +6,10 @@
 #include <linux/mman.h>
 #include <linux/security.h>
 #include <linux/suspend.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/traps.h>
+
 #include "driver.h"
 #include "encl.h"
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2de01b379aa3..00bf42f4c536 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,8 +14,11 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/sgx.h>
+
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 843b1655ab45..abc6f5a7a486 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/memtype.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/cpu/topology_common.c b/arch/x86/kernel/cpu/topology_common.c
index b5a5e1411469..b8c55f025b7e 100644
--- a/arch/x86/kernel/cpu/topology_common.c
+++ b/arch/x86/kernel/cpu/topology_common.c
@@ -6,6 +6,7 @@
 #include <asm/intel-family.h>
 #include <asm/apic.h>
 #include <asm/processor.h>
+#include <asm/cpuid/api.h>
 #include <asm/smp.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/topology_ext.c b/arch/x86/kernel/cpu/topology_ext.c
index 467b0326bf1a..eb915c73895f 100644
--- a/arch/x86/kernel/cpu/topology_ext.c
+++ b/arch/x86/kernel/cpu/topology_ext.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/memtype.h>
 #include <asm/processor.h>
 
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 42c939827621..1fdcd69c625c 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -3,8 +3,11 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/mm.h>
+
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
+
 #include "cpu.h"
 
 static void early_init_transmeta(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index cb3f900c46fc..fe181620f8f6 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -32,6 +32,7 @@
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
+#include <asm/cpuid/api.h>
 #include <asm/timer.h>
 #include <asm/apic.h>
 #include <asm/vmware.h>
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index 89b1c8a70fe8..cfcfb6221e3f 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -4,6 +4,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index dae436253de4..cbd04b677fd1 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -37,6 +37,7 @@
 #include <linux/gfp.h>
 #include <linux/completion.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index 9e9a591a5fec..f58ce9220e0f 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -17,6 +17,7 @@
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/hypervisor.h>
 #include <asm/i8259.h>
 #include <asm/irqdomain.h>
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc1..8a8e6a9c2de8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,7 @@
 #include <asm/hypervisor.h>
 #include <asm/mtrr.h>
 #include <asm/tlb.h>
+#include <asm/cpuid/api.h>
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/msr.h>
 #include <asm/ptrace.h>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..15f608f057ac 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -24,6 +24,7 @@
 #include <asm/time.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
+#include <asm/cpuid/api.h>
 #include <asm/delay.h>
 #include <asm/fixmap.h>
 #include <asm/apic.h>
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..25e36300e6ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -52,6 +52,7 @@
 #include <asm/page.h>
 #include <asm/memtype.h>
 #include <asm/cmpxchg.h>
+#include <asm/cpuid/api.h>
 #include <asm/io.h>
 #include <asm/set_memory.h>
 #include <asm/spec-ctrl.h>
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cfce03d8f123..e7b69275ae50 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -15,6 +15,7 @@
 #include "x86.h"
 #include "spte.h"
 
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/memtype.h>
 #include <asm/vmx.h>
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index c53b92379e6e..77bdc3fe3fc5 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -3,8 +3,10 @@
 #define ARCH_X86_KVM_REVERSE_CPUID_H
 
 #include <uapi/asm/kvm.h>
+
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
+#include <asm/cpuid/types.h>
 
 /*
  * Define a KVM-only feature flag.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..d7478ffad168 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -41,6 +41,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bbf4509f32d0..2711040d73af 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -15,6 +15,7 @@
 #include <linux/perf_event.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
+#include <asm/cpuid/api.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index df1d0cf76947..29a1f8e3be60 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -2,6 +2,7 @@
 /*  Copyright(c) 2021 Intel Corporation. */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/sgx.h>
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 191a9ed0da22..80ba1e2e7d06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -34,6 +34,7 @@
 #include <asm/asm.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index c0c40b67524e..fbf0ec1bb0dc 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -31,6 +31,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/hypervisor.h>
+#include <asm/cpuid/api.h>
 #include <asm/vsyscall.h>
 #include <asm/cmdline.h>
 #include <asm/pti.h>
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index b8755cde2419..6acfbdbaf4d5 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <asm/io_apic.h>
 #include <asm/pci_x86.h>
+#include <asm/cpuid/api.h>
 
 #include <asm/xen/hypervisor.h>
 
@@ -583,4 +584,3 @@ int __init pci_xen_initial_domain(void)
 	return 0;
 }
 #endif
-
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index fe57ff85d004..bd57259a02e6 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -20,6 +20,7 @@
 #include <asm/setup.h>
 #include <asm/idtentry.h>
 #include <asm/hypervisor.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/early_ioremap.h>
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 8f89ce0b67e3..5f50a3ee08f5 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -2,6 +2,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/xen/hypercall.h>
 #include <xen/xen.h>
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 96521b1874ac..d935cc1f2896 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -17,6 +17,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/timekeeper_internal.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 0d25bbdc7e6a..4d0b7d7c0aad 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -27,6 +27,7 @@
 #include <linux/gfp.h>
 #include <linux/page-flags.h>
 #include <linux/mm.h>
+#include <asm/cpuid/api.h>
 #include "agp.h"
 #include "intel-agp.h"
 
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 1caaec7c280b..f3aaca0496a4 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -14,6 +14,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 
 static struct cpufreq_driver	longrun_driver;
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 31039330a3ba..ee122aafa56a 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -29,6 +29,7 @@
 #include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 #include <linux/acpi.h>
@@ -691,4 +692,3 @@ MODULE_LICENSE("GPL");
 
 late_initcall(powernow_init);
 module_exit(powernow_exit);
-
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index f7512b4e923e..84d7a737203b 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -39,6 +39,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 
 #include <linux/acpi.h>
 #include <linux/mutex.h>
diff --git a/drivers/cpufreq/speedstep-lib.c b/drivers/cpufreq/speedstep-lib.c
index 0b66df4ed513..b3fe873103a8 100644
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/cpufreq.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/tsc.h>
 #include "speedstep-lib.h"
diff --git a/drivers/firmware/efi/libstub/x86-5lvl.c b/drivers/firmware/efi/libstub/x86-5lvl.c
index f1c5fb45d5f7..029ad80cf0b4 100644
--- a/drivers/firmware/efi/libstub/x86-5lvl.c
+++ b/drivers/firmware/efi/libstub/x86-5lvl.c
@@ -2,6 +2,7 @@
 #include <linux/efi.h>
 
 #include <asm/boot.h>
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/efi.h>
 
diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
index e6753282e70e..4d2aba31a78c 100644
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@ -7,6 +7,8 @@
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 
+#include <asm/cpuid/api.h>
+
 #include "mmu.h"
 #include "psb_drv.h"
 #include "psb_reg.h"
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 8ecebea53651..e200c7b7a698 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/topology.h>
 #include <asm/processor.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index babf2413d666..12115654689a 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -20,7 +20,9 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+
 #include <asm/amd/node.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 MODULE_DESCRIPTION("AMD Family 10h+ CPU core temperature monitor");
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 2b80ac410cd1..53241164570e 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <asm/processor.h>
+#include <asm/cpuid/api.h>
 
 #define TEMP_FROM_REG(val)	(((((val) >> 16) & 0xff) - 49) * 1000)
 #define REG_TEMP	0xe4
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index ea33ae39be6b..7612759c7267 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/dmi.h>
 #include <linux/platform_data/x86/intel_pmc_ipc.h>
+#include <asm/cpuid/api.h>
 #include "dwmac-intel.h"
 #include "dwmac4.h"
 #include "stmmac.h"
diff --git a/drivers/ras/amd/fmpm.c b/drivers/ras/amd/fmpm.c
index 8877c6ff64c4..416a14bbd714 100644
--- a/drivers/ras/amd/fmpm.c
+++ b/drivers/ras/amd/fmpm.c
@@ -52,6 +52,7 @@
 #include <acpi/apei.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/mce.h>
 
 #include "../debugfs.h"
diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index bd2fca7dc017..c910cc563d9d 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -41,6 +41,7 @@
 #include <linux/topology.h>
 #include <linux/workqueue.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "intel_hfi.h"
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 3fc679b6f11b..80f98e4ae61f 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -20,6 +20,7 @@
 #include <linux/debugfs.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "thermal_interrupt.h"
diff --git a/drivers/virt/acrn/hsm.c b/drivers/virt/acrn/hsm.c
index e4e196abdaac..67119f9da449 100644
--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #include <asm/acrn.h>
+#include <asm/cpuid/api.h>
 #include <asm/hypervisor.h>
 
 #include "acrn_drv.h"
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 41309d38f78c..4d847dcd6d76 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -40,6 +40,7 @@
 #include <linux/ktime.h>
 
 #ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/ptrace.h>
 #include <asm/idtentry.h>
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 04a6b470b15d..ae3e384c2d1b 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -59,6 +59,7 @@
 #include <xen/swiotlb-xen.h>
 #include <xen/balloon.h>
 #ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
 #include <asm/xen/cpuid.h>
 #endif
 #include <xen/mem-reservation.h>
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index dcf9182c8451..dff3752314e7 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -47,6 +47,9 @@
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
 #include <asm/xen/hypervisor.h>
+#ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
+#endif
 #include <xen/xenbus.h>
 #include <xen/xen.h>
 #include "xenbus.h"
-- 
2.50.1


