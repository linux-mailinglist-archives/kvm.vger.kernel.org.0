Return-Path: <kvm+bounces-13759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 579F789A72D
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF87F1F2357E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E4B179215;
	Fri,  5 Apr 2024 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j36vr0q8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C994C17798A;
	Fri,  5 Apr 2024 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356012; cv=none; b=rgqPFEaOdXVt12GrWrumzf/edA05bF7xwPMZO7S0REfOjl9ZN/vwCEgjzTk0oMsbtCfZCevONsFVZ/La0mTE1BHqGeLw6F+j/fL3EBXoV5wlFTQzVFmEs0GKHlSO8wShFhgBcpducesyrbkIt5U9TYUu+SS9HUYHoCURsT9iQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356012; c=relaxed/simple;
	bh=SZUjCrw1LUAiGX4RfPDzIUAm4sRy4Tpnthwda+0PrNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g5zAaGcrd66wBILX+LUa4Kni0MJrKP79ZDtuO2U351mJqYu2dJyki3vz0gyEaZKxNoSprb8HraIg/VoxHl1T/nOJW6bHvHADwUKgP3hq9ooeyHMJSSts+PuR0mzc/4JWd+pQC9ZkVWDUgbjVK1OWl1pvydbpoY2NfzheFLrh4AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j36vr0q8; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356011; x=1743892011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SZUjCrw1LUAiGX4RfPDzIUAm4sRy4Tpnthwda+0PrNE=;
  b=j36vr0q8zFUCTvwNm6J8ebuvCz4P0fungbfdjziywe9hesKnHFBzH0wV
   +zysY0hkaCCxsXIJbI0r0TRxkIkvRJPTt6RWqmg+K25ggBFssFOWt6P28
   tyDHPuSRjxvplrKT+Hulxdq37unA+2DN0Lrtym8/feuKJH0cG5p1+ogrC
   nXbqRgd19P3CzTHl5IAkpIk7BhIXK5gpbgtdj5rel+U5/LfSRmlNWkNKv
   pNa6V3cubOXwzHfiafUhk3l/2LQ/wGUG73bf5jyDH4U9DK3V4N8dH29JD
   KwiTz2O2FOqyIi7bb1t6IiR5gCg7w1rtBFucG+3PBJRKaC7zt6neUnj6/
   Q==;
X-CSE-ConnectionGUID: Uf7U6SoAQh2pdlSs1KeB4g==
X-CSE-MsgGUID: +k9FiiP/SNm0mjrHenEQZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062748"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062748"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:49 -0700
X-CSE-ConnectionGUID: c7lY9DQnQJahb0u+aMx9BA==
X-CSE-MsgGUID: kqbc0R3dTH+A67aTYnJJeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928323"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:48 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 06/13] x86/irq: Set up per host CPU posted interrupt descriptors
Date: Fri,  5 Apr 2024 15:31:03 -0700
Message-Id: <20240405223110.1609888-7-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support posted MSIs, create a posted interrupt descriptor (PID) for each
host CPU. Later on, when setting up IRQ CPU affinity, IOMMU's interrupt
remapping table entry (IRTE) will point to the physical address of the
matching CPU's PID.

Each PID is initialized with the owner CPU's physical APICID as the
destination.

Originally-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2: Fix xAPIC destination ID assignment, Oliver Sang reported failture on
system with x2apic optout BIOS option.
---
 arch/x86/include/asm/hardirq.h     |  3 +++
 arch/x86/include/asm/posted_intr.h |  7 +++++++
 arch/x86/kernel/cpu/common.c       |  3 +++
 arch/x86/kernel/irq.c              | 23 +++++++++++++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index fbc7722b87d1..01ea52859462 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -48,6 +48,9 @@ typedef struct {
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
+#ifdef CONFIG_X86_POSTED_MSI
+DECLARE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);
+#endif
 #define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index c682c41d4e44..4e5eea2d20e0 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -80,4 +80,11 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
 }
 
+#ifdef CONFIG_X86_POSTED_MSI
+extern void intel_posted_msi_init(void);
+
+#else
+static inline void intel_posted_msi_init(void) {};
+
+#endif /* X86_POSTED_MSI */
 #endif /* _X86_POSTED_INTR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5c1e6d6be267..1a5fb657e1b6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -68,6 +68,7 @@
 #include <asm/traps.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/posted_intr.h>
 
 #include "cpu.h"
 
@@ -2219,6 +2220,8 @@ void cpu_init(void)
 		barrier();
 
 		x2apic_setup();
+
+		intel_posted_msi_init();
 	}
 
 	mmgrab(&init_mm);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 35fde0107901..f39f6147104c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -22,6 +22,8 @@
 #include <asm/desc.h>
 #include <asm/traps.h>
 #include <asm/thermal.h>
+#include <asm/posted_intr.h>
+#include <asm/irq_remapping.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -334,6 +336,27 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
 }
 #endif
 
+#ifdef CONFIG_X86_POSTED_MSI
+
+/* Posted Interrupt Descriptors for coalesced MSIs to be posted */
+DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);
+
+void intel_posted_msi_init(void)
+{
+	u32 destination;
+	u32 apic_id;
+
+	this_cpu_write(posted_interrupt_desc.nv, POSTED_MSI_NOTIFICATION_VECTOR);
+
+	/*
+	 * APIC destination ID is stored in bit 8:15 while in XAPIC mode.
+	 * VT-d spec. CH 9.11
+	 */
+	apic_id = this_cpu_read(x86_cpu_to_apicid);
+	destination = x2apic_enabled() ? apic_id : apic_id << 8;
+	this_cpu_write(posted_interrupt_desc.ndst, destination);
+}
+#endif /* X86_POSTED_MSI */
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-- 
2.25.1


