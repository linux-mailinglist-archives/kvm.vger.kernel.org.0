Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F88A326862
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhBZUPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:15:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:35678 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZUNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:13:19 -0500
IronPort-SDR: x8phXo4Zhz8bKLUEUCIjEIAzbDj4jvWAlr60vNPya8dCBFlbdhWLK3/Fkh04epDqHFxmw32Uvr
 s2VqNMxsmCwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846905"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846905"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:14 -0800
IronPort-SDR: 6eRWXMxbkZk4WWg4nf7WXCqgFHHUePNl/a+OsdoHo0lhY7FNfjLnXXfa+jiMWeI1DTvbAaSBUE
 8iojhtQHcn6Q==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109447"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:13 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 09/13] iommu/vt-d: Add DEV-MSI support
Date:   Fri, 26 Feb 2021 12:11:13 -0800
Message-Id: <1614370277-23235-10-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add required support in the interrupt remapping driver for devices
which generate dev-msi interrupts and use the intel remapping
domain as the parent domain. Set the source-id of all dev-msi
interrupt requests to the parent PCI device associated with it.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/iommu/intel/irq_remapping.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 611ef52..2a55e54 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1282,6 +1282,9 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
 		set_msi_sid(irte, msi_desc_to_pci_dev(info->desc));
 		break;
+	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
+		set_msi_sid(irte, to_pci_dev(info->desc->dev->parent));
+		break;
 	default:
 		BUG_ON(1);
 		break;
@@ -1325,7 +1328,8 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 	if (!info || !iommu)
 		return -EINVAL;
 	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_PCI_MSI &&
-	    info->type != X86_IRQ_ALLOC_TYPE_PCI_MSIX)
+	    info->type != X86_IRQ_ALLOC_TYPE_PCI_MSIX &&
+	    info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
 		return -EINVAL;
 
 	/*
-- 
2.7.4

