Return-Path: <kvm+bounces-1531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9DE7E8E38
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA223280D82
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9B7946C;
	Sun, 12 Nov 2023 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJilG8cj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842E2572
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899FB30F7;
	Sat, 11 Nov 2023 20:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762330; x=1731298330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XzHdLhX/vY4asS0xx/Bsw4Ay4NQKud3SHGFE5ORwta8=;
  b=KJilG8cj1ruuny36putjNWwuDeQLtiBTpPFn57V/proMK6KTHj/pyKOt
   sE5wRL83A5TIqmsOjvF4gxg3Iezw9KZfz1R+OCVGdC9CECIlEzxE/uFgE
   bdKU4TAgZAkthfQIP6kf3ktepxjSouD32Hq60L+iwP3/zW/3SUvxs8ay5
   fyrSfdUirWPBxBTrGGXoC5f0CA2C3s+ww/O+7Kw2aoxK4K6Mzj7h9AOBK
   mmTtUZs2ViLpbM6OIA+05DX6cSYPAYBuJmJkNqEJB6MZFS9vrwF0D6cga
   ZQPWuCuMBpM/hmSZezz5x6MCiaw/b3gPyyzARqLdP/OOKHUH9lw+2HisW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533891"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533891"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936751"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936751"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:08 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	peterz@infradead.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH RFC 05/13] x86/irq: Set up per host CPU posted interrupt descriptors
Date: Sat, 11 Nov 2023 20:16:35 -0800
Message-Id: <20231112041643.2868316-6-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

To support posted MSIs, create a posted interrupt descriptor (PID) for each
host CPU. Later on, when setting up IRQ CPU affinity, IOMMU's interrupt
remapping table entry (IRTE) will point to the physical address of the
matching CPU's PID.

Each PID is initialized with the owner CPU's physical APICID as the
destination.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/hardirq.h     |  3 +++
 arch/x86/include/asm/posted_intr.h |  7 +++++++
 arch/x86/kernel/cpu/common.c       |  3 +++
 arch/x86/kernel/irq.c              | 13 +++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 66837b8c67f1..72c6a084dba3 100644
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
index 9f2fa38fa57b..2cd9ac1af835 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -94,4 +94,11 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
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
index 4e5ffc8b0e46..08b2d1560f8b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -65,6 +65,7 @@
 #include <asm/set_memory.h>
 #include <asm/traps.h>
 #include <asm/sev.h>
+#include <asm/posted_intr.h>
 
 #include "cpu.h"
 
@@ -2266,6 +2267,8 @@ void cpu_init(void)
 		barrier();
 
 		x2apic_setup();
+
+		intel_posted_msi_init();
 	}
 
 	mmgrab(&init_mm);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 11761c124545..fd4d664d81bb 100644
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
@@ -334,6 +336,17 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
 }
 #endif
 
+#ifdef CONFIG_X86_POSTED_MSI
+
+/* Posted Interrupt Descriptors for coalesced MSIs to be posted */
+DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);
+
+void intel_posted_msi_init(void)
+{
+	this_cpu_write(posted_interrupt_desc.nv, POSTED_MSI_NOTIFICATION_VECTOR);
+	this_cpu_write(posted_interrupt_desc.ndst, this_cpu_read(x86_cpu_to_apicid));
+}
+#endif /* X86_POSTED_MSI */
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-- 
2.25.1


