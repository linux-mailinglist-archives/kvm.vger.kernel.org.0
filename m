Return-Path: <kvm+bounces-15701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE068AF5A8
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F4F1C246F1
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF6A1428FC;
	Tue, 23 Apr 2024 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDQRfFUP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3DC1422C4;
	Tue, 23 Apr 2024 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893812; cv=none; b=EGUAVvBfzqBAUMiAHeQcqtNAO/HGLZr3zJZoeKGKCu+ogYPMYMWl9Z4fZjz11vvKlZu0DEYdA53TN7rblMcq7CE04PymDZAdApdI/A4nJrDv51y+NTBmQsL5aOu0mkDZXTwUQ3Vy012ckV9vU32L3E9V3Npb97wXug8mHFcyBWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893812; c=relaxed/simple;
	bh=0/U+YELiuj5g/GjoG92UbXxnUKLMjYMQutBYyDFxAhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bmhuXvhmxH/5N89q8cV0ueAttTl1Ew+K8PrfgHV5xmHuR02odAzTGM5DL3s7SQHPQA09Bo70XO4vL6UFPVmpzOOo+Ep81pdSfjS590lVYaF36ODIoJodeuOleRzruQuOsfoanj3KdBWKD/ix60ZYkI/th68ayWyd/WgS0nYi9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDQRfFUP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893811; x=1745429811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0/U+YELiuj5g/GjoG92UbXxnUKLMjYMQutBYyDFxAhY=;
  b=MDQRfFUP4+Ssqv6v2GYh3iBS2QbJfn5MRTnHDewD38IZRfkrt+0nN0ge
   45/Xgt8V1hS1MXVQFeVaXLl7i99/V9ZIZZR8U/qwaIzHRlgUkU51lLMNg
   E7s70y/HB0AY2tgd01Y7cHEhb+9gb/foU/fJjC9QMHGjiiJvgUlVuapnC
   x6ryPXdU+RSMK2q/fdLsrZO3tCHGIfDzD8/G7F15mCnm0QwLBNEMYmI/w
   pKUiflpDl2dwHVJAmgOk23Gtz+4w8JFwKd0IFNa3ColCQrVol0l0gUkio
   4hUYkf5eqbFNZOUhtsTprcGFwX40LMPSar/EP60NqhEHhU8NXs799y8Hl
   g==;
X-CSE-ConnectionGUID: iXhIyT5OQaaHP4zpFkYJ3Q==
X-CSE-MsgGUID: iEOgEvhwT2a3LgfmH966xg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712404"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712404"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:44 -0700
X-CSE-ConnectionGUID: lXFAGWmhRbKmIpvscpz2CA==
X-CSE-MsgGUID: PkCcphDSRou6pvokaPlNxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097423"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:42 -0700
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
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  06/12] x86/irq: Set up per host CPU posted interrupt descriptors
Date: Tue, 23 Apr 2024 10:41:08 -0700
Message-Id: <20240423174114.526704-7-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
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
v3: Rename per CPU PID for posted MSI from pi_desc to posted_msi_pi_desc

v2: Fix xAPIC destination ID assignment, Oliver Sang reported failture on
system with x2apic optout BIOS option.
---
 arch/x86/include/asm/hardirq.h     |  3 +++
 arch/x86/include/asm/posted_intr.h |  6 ++++++
 arch/x86/kernel/cpu/common.c       |  3 +++
 arch/x86/kernel/irq.c              | 23 +++++++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index fbc7722b87d1..e7ab594b3a7a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -48,6 +48,9 @@ typedef struct {
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
+#ifdef CONFIG_X86_POSTED_MSI
+DECLARE_PER_CPU_ALIGNED(struct pi_desc, posted_msi_pi_desc);
+#endif
 #define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index 20e31891de15..6f84f6739d99 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -91,4 +91,10 @@ static inline void __pi_clear_sn(struct pi_desc *pi_desc)
 	pi_desc->notifications &= ~BIT(POSTED_INTR_SN);
 }
 
+#ifdef CONFIG_X86_POSTED_MSI
+extern void intel_posted_msi_init(void);
+#else
+static inline void intel_posted_msi_init(void) {};
+#endif /* X86_POSTED_MSI */
+
 #endif /* _X86_POSTED_INTR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 605c26c009c8..25ef145586c6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -68,6 +68,7 @@
 #include <asm/traps.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/posted_intr.h>
 
 #include "cpu.h"
 
@@ -2227,6 +2228,8 @@ void cpu_init(void)
 		barrier();
 
 		x2apic_setup();
+
+		intel_posted_msi_init();
 	}
 
 	mmgrab(&init_mm);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 35fde0107901..dbb3a19b3004 100644
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
+DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_msi_pi_desc);
+
+void intel_posted_msi_init(void)
+{
+	u32 destination;
+	u32 apic_id;
+
+	this_cpu_write(posted_msi_pi_desc.nv, POSTED_MSI_NOTIFICATION_VECTOR);
+
+	/*
+	 * APIC destination ID is stored in bit 8:15 while in XAPIC mode.
+	 * VT-d spec. CH 9.11
+	 */
+	apic_id = this_cpu_read(x86_cpu_to_apicid);
+	destination = x2apic_enabled() ? apic_id : apic_id << 8;
+	this_cpu_write(posted_msi_pi_desc.ndst, destination);
+}
+#endif /* X86_POSTED_MSI */
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-- 
2.25.1


