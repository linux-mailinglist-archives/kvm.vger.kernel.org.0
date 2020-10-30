Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B252A0DE8
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgJ3SxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:22741 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgJ3SxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:53:07 -0400
IronPort-SDR: DeGUHHLoErfJBn7u+sbQ8DY7rppUlCbyUcQG+PicBrENuavDbpHXgA/YM3RyUsJfknAdLQ8VOw
 +LU38EyoiHgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="232829889"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="232829889"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:04 -0700
IronPort-SDR: eVYiPMA8Q+l8KImatJ+KalV+jgUqWTy47/v6sOZ/RYykVBZEPRcsNWg1iY0a9kErx8I2djCj9o
 l42+LTccZztw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="469608105"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:02 -0700
Subject: [PATCH v4 02/17] iommu/vt-d: Add DEV-MSI support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:51:01 -0700
Message-ID: <160408386122.912050.7027904087316715077.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@intel.com>

Add required support in the interrupt remapping driver for devices
which generate dev-msi interrupts and use the intel remapping
domain as the parent domain.

Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/iommu/intel/irq_remapping.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 0cfce1d3b7bb..0e8d106d34c0 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1260,6 +1260,16 @@ static struct irq_chip intel_ir_chip = {
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
 };
 
+static void irte_prepare_msg(struct msi_msg *msg, int index, int subhandle)
+{
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->data = subhandle;
+	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+			  MSI_ADDR_IR_SHV |
+			  MSI_ADDR_IR_INDEX1(index) |
+			  MSI_ADDR_IR_INDEX2(index);
+}
+
 static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 					     struct irq_cfg *irq_cfg,
 					     struct irq_alloc_info *info,
@@ -1301,19 +1311,18 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 		break;
 
 	case X86_IRQ_ALLOC_TYPE_HPET:
+		set_hpet_sid(irte, info->devid);
+		irte_prepare_msg(msg, index, sub_handle);
+		break;
+
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
-		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
-			set_hpet_sid(irte, info->devid);
-		else
-			set_msi_sid(irte, msi_desc_to_pci_dev(info->desc));
-
-		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->data = sub_handle;
-		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
-				  MSI_ADDR_IR_SHV |
-				  MSI_ADDR_IR_INDEX1(index) |
-				  MSI_ADDR_IR_INDEX2(index);
+		set_msi_sid(irte, msi_desc_to_pci_dev(info->desc));
+		irte_prepare_msg(msg, index, sub_handle);
+		break;
+
+	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
+		irte_prepare_msg(msg, index, sub_handle);
 		break;
 
 	default:
@@ -1358,7 +1367,8 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 	if (!info || !iommu)
 		return -EINVAL;
 	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_PCI_MSI &&
-	    info->type != X86_IRQ_ALLOC_TYPE_PCI_MSIX)
+	    info->type != X86_IRQ_ALLOC_TYPE_PCI_MSIX &&
+	    info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
 		return -EINVAL;
 
 	/*


