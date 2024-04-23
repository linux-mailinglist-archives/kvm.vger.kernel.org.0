Return-Path: <kvm+bounces-15707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78AA38AF5B4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648881C24278
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94681448C7;
	Tue, 23 Apr 2024 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTwSIjHj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602E6143C79;
	Tue, 23 Apr 2024 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893826; cv=none; b=mHFG7TsZlERPgsxVzOGIU5/YoO+HDGYpl698vjY/3f8/48KvIoQ1REFWNIATQfBNyyvynQjsCDHafwAdEOxaPuAC6jU4NBdgPYiYQJ2w9GaS+Tt5uKT3iBWCPEik2sdwLQMJd7ySjh5beI64dmnlYyc5DBv8SWqiFVw5GxTXzuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893826; c=relaxed/simple;
	bh=22oAW6ImjlKqtEMZUPmJThUzi0S1ajqYx29NS6IpSpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X9HKpAHezA+KxsF4oSU0wORozrVOsK5/J3PDzBwrIBbqMDnvoTLQFqhDneArTFhs1fMEMzFMJFs+EW2Xgy7p13eFT6oGVzkRD5OLdwaJkbd6ky3Y6QOdHuUrNkIdMMSNabTlBh9fI1nlXOk1EmaARd4/m103OqrEOnSQb1lvyUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTwSIjHj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893825; x=1745429825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=22oAW6ImjlKqtEMZUPmJThUzi0S1ajqYx29NS6IpSpY=;
  b=LTwSIjHjXaHzUDBIWPhLa6+8sFii6BE2u1M8XhteUSB4+vv4hZM7oAbx
   lmGBu5DKlsNiRJTmUCAP4WsiW+dyILruG+LkpyzVH3Qjt40ypQshs6XAp
   niWVALLLnVjfPtYLwnVkM3s2KNhFmLyr2wdMamZ6RyCyrsH3rPKxcFJK6
   zRLfibR81upViJ9vXR21HwwNNdItm204QoPZ/BtqoD5MKV6z4SB7cZVOo
   IOtxiMfqDDLbqRLEC4IM5rxOsgmR9Y2L9yk+61ap0KaiJZsZGXRO2/viZ
   pp0hsWmgTKsBmn1yRW9AClYrs1mAjeH7f1gtOmEZUt+5WxcS5VtwnHJvn
   Q==;
X-CSE-ConnectionGUID: GFZGfYrZSxG9UuT8Px0Unw==
X-CSE-MsgGUID: kD2t2PUjTbaaqKDIPjzxrg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712537"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712537"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:48 -0700
X-CSE-ConnectionGUID: Fx5As6osTP6TS/dKV9Kktg==
X-CSE-MsgGUID: EK1AXk9KRCymUTSm5yX2bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097481"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:47 -0700
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
Subject: [PATCH v3  12/12] iommu/vt-d: Enable posted mode for device MSIs
Date: Tue, 23 Apr 2024 10:41:14 -0700
Message-Id: <20240423174114.526704-13-jacob.jun.pan@linux.intel.com>
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

With posted MSI feature enabled on the CPU side, iommu interrupt
remapping table entries (IRTEs) for device MSI/x can be allocated,
activated, and programed in posted mode. This means that IRTEs are
linked with their respective PIDs of the target CPU.

Handlers for the posted MSI notification vector will de-multiplex
device MSI handlers. CPU notifications are coalesced if interrupts
arrive at a high frequency.

Excluding the following:
- legacy devices IOAPIC, HPET (may be needed for booting, not a source
of high MSIs)

A new irq_chip for posted MSIs is introduced, the key difference is in
irq_ack where EOI is performed by the notification handler.

When posted MSI is enabled, MSI domain/chip hierarchy will look like
this example:

domain:  IR-PCI-MSIX-0000:50:00.0-12
 hwirq:   0x29
 chip:    IR-PCI-MSIX-0000:50:00.0
  flags:   0x430
             IRQCHIP_SKIP_SET_WAKE
             IRQCHIP_ONESHOT_SAFE
 parent:
    domain:  INTEL-IR-10-13
     hwirq:   0x2d0000
     chip:    INTEL-IR-POST
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x77
         chip:    APIC

 VT-d's own IRQs (not remappable).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v3: - Remove extra irq_enter() in comments
    - Fold in the introduction of posted MSI IRQ chip patch
v2: Fold in helper function for retrieving PID address
v1: Added a warning if the effective affinity mask is not set up
---
 drivers/iommu/intel/irq_remapping.c | 113 +++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 566297bc87dd..1b77189b4ad0 100644
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
@@ -1126,6 +1136,47 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.enable_faulting	= enable_drhd_fault_handling,
 };
 
+#ifdef CONFIG_X86_POSTED_MSI
+
+static phys_addr_t get_pi_desc_addr(struct irq_data *irqd)
+{
+	int cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));
+
+	if (WARN_ON(cpu >= nr_cpu_ids))
+		return 0;
+
+	return __pa(per_cpu_ptr(&posted_msi_pi_desc, cpu));
+}
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
+	if (!pid_addr) {
+		pr_warn("Failed to setup IRQ %d for posted mode", irqd->irq);
+		return;
+	}
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
+#endif
+
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
 {
 	struct intel_ir_data *ir_data = irqd->chip_data;
@@ -1139,8 +1190,9 @@ static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
 	irte->vector = cfg->vector;
 	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
 
-	/* Update the hardware only if the interrupt is in remapped mode. */
-	if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
+	if (ir_data->irq_2_iommu.posted_msi)
+		intel_ir_reconfigure_irte_posted(irqd);
+	else if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
 		modify_irte(&ir_data->irq_2_iommu, irte);
 }
 
@@ -1194,7 +1246,7 @@ static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 	struct intel_ir_data *ir_data = data->chip_data;
 	struct vcpu_data *vcpu_pi_info = info;
 
-	/* stop posting interrupts, back to remapping mode */
+	/* stop posting interrupts, back to the default mode */
 	if (!vcpu_pi_info) {
 		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
 	} else {
@@ -1233,6 +1285,50 @@ static struct irq_chip intel_ir_chip = {
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
 };
 
+static void dummy(struct irq_data *d)
+{
+}
+
+/*
+ * With posted MSIs, all vectors are multiplexed into a single notification
+ * vector. Devices MSIs are then dispatched in a demux loop where
+ * EOIs can be coalesced as well.
+ *
+ * "INTEL-IR-POST" IRQ chip does not do EOI on ACK, thus the dummy irq_ack()
+ * function. Instead EOI is performed by the posted interrupt notification
+ * handler.
+ *
+ * For the example below, 3 MSIs are coalesced into one CPU notification. Only
+ * one apic_eoi() is needed.
+ *
+ * __sysvec_posted_msi_notification()
+ *	irq_enter();
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *	apic_eoi()
+ *	irq_exit()
+ */
+static struct irq_chip intel_ir_chip_post_msi = {
+	.name			= "INTEL-IR-POST",
+	.irq_ack		= dummy,
+	.irq_set_affinity	= intel_ir_set_affinity,
+	.irq_compose_msi_msg	= intel_ir_compose_msi_msg,
+	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
+};
+
 static void fill_msi_msg(struct msi_msg *msg, u32 index, u32 subhandle)
 {
 	memset(msg, 0, sizeof(*msg));
@@ -1274,6 +1370,11 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 		break;
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
+		if (posted_msi_supported()) {
+			prepare_irte_posted(irte);
+			data->irq_2_iommu.posted_msi = 1;
+		}
+
 		set_msi_sid(irte,
 			    pci_real_dma_dev(msi_desc_to_pci_dev(info->desc)));
 		break;
@@ -1361,7 +1462,11 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 
 		irq_data->hwirq = (index << 16) + i;
 		irq_data->chip_data = ird;
-		irq_data->chip = &intel_ir_chip;
+		if (posted_msi_supported() &&
+			((info->type == X86_IRQ_ALLOC_TYPE_PCI_MSI) || (info->type == X86_IRQ_ALLOC_TYPE_PCI_MSIX)))
+			irq_data->chip = &intel_ir_chip_post_msi;
+		else
+			irq_data->chip = &intel_ir_chip;
 		intel_irq_remapping_prepare_irte(ird, irq_cfg, info, index, i);
 		irq_set_status_flags(virq + i, IRQ_MOVE_PCNTXT);
 	}
-- 
2.25.1


