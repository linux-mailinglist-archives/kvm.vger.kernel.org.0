Return-Path: <kvm+bounces-1535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A81D17E8E3D
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A26CBB209F0
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C885125A8;
	Sun, 12 Nov 2023 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnbxXBWw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72BB5386
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:15 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0F930C2;
	Sat, 11 Nov 2023 20:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762333; x=1731298333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T0ai5rnWeiXxamAohbdsJLJK4HQfw4C6pjUvQ0qQo0M=;
  b=bnbxXBWw6rVmDlnod9bO8+vGfiRs12EfeBvpU1pJtLku1b1+35YDYswS
   DM17jK6CyMz1AAYlF67ce127p/nOVt4HV5uQKZ8SxuBXkaODhtkqjHidY
   OH58RctALytMceKV3xPPPtZPVwiWjiieW3UhMhaok9Mj4FvhhEKXELL8p
   NLcArukXn7KBUPgXSvku2JLkybV73lRpAMizWuCWwhThTZXjdB7RrZtZv
   w3Y2rxLHLBYYD5BZU8K8+dgh7NQt4dy9fRPs8BEwd1b1D5Bw2Hv4My9Sp
   grsFXxu+UCmFy1PMaYPiyTCcDIRC3rvH1PDk2EtETrtbtegUM5ksC2Pb+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533975"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533975"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936776"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936776"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:10 -0800
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
Subject: [PATCH RFC 13/13] iommu/vt-d: Enable posted mode for device MSIs
Date: Sat, 11 Nov 2023 20:16:43 -0800
Message-Id: <20231112041643.2868316-14-jacob.jun.pan@linux.intel.com>
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

With posted MSI feature is enabled on the CPU side, iommu IRTEs for
device MSIs can be allocated, activated, and programed in posted mode.
This means that IRTEs are linked with their respective PIDs of the
target CPU.

Excluding the following:
- legacy devices IOAPIC, HPET (may be needed for booting, not a source
of high MSIs)
- VT-d's own IRQs (not remappable).

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h  |  1 +
 drivers/iommu/intel/irq_remapping.c | 55 ++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index 12a4fa3ff60e..c6d245f53225 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _X86_POSTED_INTR_H
 #define _X86_POSTED_INTR_H
+#include <asm/irq_vectors.h>
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 971e6c37002f..1b88846d5338 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -19,6 +19,7 @@
 #include <asm/cpu.h>
 #include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
+#include <asm/posted_intr.h>
 
 #include "iommu.h"
 #include "../irq_remapping.h"
@@ -49,6 +50,7 @@ struct irq_2_iommu {
 	u16 sub_handle;
 	u8  irte_mask;
 	enum irq_mode mode;
+	bool posted_msi;
 };
 
 struct intel_ir_data {
@@ -1118,6 +1120,14 @@ static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
 	irte->redir_hint = 1;
 }
 
+static void prepare_irte_posted(struct irte *irte)
+{
+	memset(irte, 0, sizeof(*irte));
+
+	irte->present = 1;
+	irte->p_pst = 1;
+}
+
 struct irq_remap_ops intel_irq_remap_ops = {
 	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
@@ -1125,6 +1135,7 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 };
+
 #ifdef CONFIG_X86_POSTED_MSI
 
 static u64 get_pi_desc_addr(struct irq_data *irqd)
@@ -1133,6 +1144,29 @@ static u64 get_pi_desc_addr(struct irq_data *irqd)
 
 	return __pa(per_cpu_ptr(&posted_interrupt_desc, cpu));
 }
+
+static void intel_ir_reconfigure_irte_posted(struct irq_data *irqd)
+{
+	struct intel_ir_data *ir_data = irqd->chip_data;
+	struct irte *irte = &ir_data->irte_entry;
+	struct irte irte_pi;
+	u64 pid_addr;
+
+	pid_addr = get_pi_desc_addr(irqd);
+
+	memset(&irte_pi, 0, sizeof(irte_pi));
+
+	/* The shared IRTE already be set up as posted during alloc_irte */
+	dmar_copy_shared_irte(&irte_pi, irte);
+
+	irte_pi.pda_l = (pid_addr >> (32 - PDA_LOW_BIT)) & ~(-1UL << PDA_LOW_BIT);
+	irte_pi.pda_h = (pid_addr >> 32) & ~(-1UL << PDA_HIGH_BIT);
+
+	modify_irte(&ir_data->irq_2_iommu, &irte_pi);
+}
+
+#else
+static inline void intel_ir_reconfigure_irte_posted(struct irq_data *irqd) {}
 #endif
 
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
@@ -1148,8 +1182,9 @@ static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
 	irte->vector = cfg->vector;
 	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
 
-	/* Update the hardware only if the interrupt is in remapped mode. */
-	if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
+	if (ir_data->irq_2_iommu.posted_msi)
+		intel_ir_reconfigure_irte_posted(irqd);
+	else if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
 		modify_irte(&ir_data->irq_2_iommu, irte);
 }
 
@@ -1203,7 +1238,7 @@ static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 	struct intel_ir_data *ir_data = data->chip_data;
 	struct vcpu_data *vcpu_pi_info = info;
 
-	/* stop posting interrupts, back to remapping mode */
+	/* stop posting interrupts, back to the default mode */
 	if (!vcpu_pi_info) {
 		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
 	} else {
@@ -1300,10 +1335,14 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 {
 	struct irte *irte = &data->irte_entry;
 
-	prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
+	if (data->irq_2_iommu.mode == IRQ_POSTING)
+		prepare_irte_posted(irte);
+	else
+		prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
 
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC:
+		prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(irte, info->devid);
 		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: Set IRTE entry (P:%d FPD:%d Dst_Mode:%d Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X Avail:%X Vector:%02X Dest:%08X SID:%04X SQ:%X SVT:%X)\n",
@@ -1315,10 +1354,18 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 		sub_handle = info->ioapic.pin;
 		break;
 	case X86_IRQ_ALLOC_TYPE_HPET:
+		prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
 		set_hpet_sid(irte, info->devid);
 		break;
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
+		if (posted_msi_supported()) {
+			prepare_irte_posted(irte);
+			data->irq_2_iommu.posted_msi = 1;
+		} else {
+			prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
+		}
+
 		set_msi_sid(irte,
 			    pci_real_dma_dev(msi_desc_to_pci_dev(info->desc)));
 		break;
-- 
2.25.1


