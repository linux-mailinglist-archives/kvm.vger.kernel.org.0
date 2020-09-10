Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99FA264494
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgIJKtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:49:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:21893 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgIJKqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:46:53 -0400
IronPort-SDR: XJt6iHu1mKw0Q1TQF8Xc65b4eCQ9hW6Qa1Tt2dRYTRqVetnlSeiMRCv1PliUWRH7gaIivlRceR
 M8svYdIQ913g==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066293"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: 8hUgp4Evj/ZrvmZva5fLAVk62BQgEfT5LCfHHGRlnrglQZ/c950uDT0bV2hipkAnW2ypGx1mvp
 9i68g1mug5Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137217"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 13/16] vfio/pci: Expose PCIe PASID capability to guest
Date:   Thu, 10 Sep 2020 03:45:30 -0700
Message-Id: <1599734733-6431-14-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposes PCIe PASID capability to guest for assigned devices.
Existing vfio_pci driver hides it from guest by setting the capability
length as 0 in pci_ext_cap_length[].

And this patch only exposes PASID capability for devices which has PCIe
PASID extended struture in its configuration space. VFs will not expose
the PASID capability as they do not implement the PASID extended structure
in their config space. It is a TODO in future. Related discussion can be
found in below link:

https://lore.kernel.org/kvm/20200407095801.648b1371@w520.home/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
v5 -> v6:
*) add review-by from Eric Auger.

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

