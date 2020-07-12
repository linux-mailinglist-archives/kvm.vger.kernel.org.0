Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8021C8D6
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgGLLPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:15:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:45844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728850AbgGLLOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:40 -0400
IronPort-SDR: 9oMXTo0dD1t1Y6JxQPz3ORNpRZzO+ayGufIjg01v804AkcfF1Zv8DhVRIQ6nGCfSdldm30Jhqd
 kiz4RXSWV2cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952703"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="149952703"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:30 -0700
IronPort-SDR: YmJF8CTH8rnWK0AEUWvBEnYh/2eJ1HYKPr1BnTrOPzwgtj+OI/t2zQ9ZAsraudOf/vKjOLaW2C
 YHYRYgURAVMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="315788588"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:30 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 13/15] vfio/pci: Expose PCIe PASID capability to guest
Date:   Sun, 12 Jul 2020 04:21:08 -0700
Message-Id: <1594552870-55687-14-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposes PCIe PASID capability to guest for assigned devices.
Existing vfio_pci driver hides it from guest by setting the capability
length as 0 in pci_ext_cap_length[].

And this patch only exposes PASID capability for devices which has PCIe
PASID extended struture in its configuration space. So VFs, will will
not see PASID capability on VFs as VF doesn't implement PASID extended
structure in its configuration space. For VF, it is a TODO in future.
Related discussion can be found in below link:

https://lkml.org/lkml/2020/4/7/693

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
v1 -> v2:
*) added in v2, but it was sent in a separate patchseries before
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843f..07ff2e6 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -95,7 +95,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
 	[PCI_EXT_CAP_ID_LTR]	=	PCI_EXT_CAP_LTR_SIZEOF,
 	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
 	[PCI_EXT_CAP_ID_PMUX]	=	0,	/* not yet */
-	[PCI_EXT_CAP_ID_PASID]	=	0,	/* not yet */
+	[PCI_EXT_CAP_ID_PASID]	=	PCI_EXT_CAP_PASID_SIZEOF,
 };
 
 /*
-- 
2.7.4

