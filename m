Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2BE32A756
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839310AbhCBQGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:38901 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347661AbhCBMyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:54:19 -0500
IronPort-SDR: u9hhNJi8Uyna4yzfJk9+sSMCFhls2m8XUPCVZIAN7fvWqdl7myt2+9cuND7k7ILKPN70UM3dT5
 y9ijIko8ZpGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431250"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431250"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:25 -0800
IronPort-SDR: SiVWC1hBDnXOmK0yf7bdE8OvzswRGXxFNQeTNq1QeScTJPrcHDSXsbsvgXASTpVesl11kamvEL
 olmx3W8ar+bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472166"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:21 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 08/10] vfio/pci: Expose PCIe PASID capability to userspace
Date:   Wed,  3 Mar 2021 04:35:43 +0800
Message-Id: <20210302203545.436623-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposes PCIe PASID capability to userspace and where to
emulate this capability if wants to further expose it to VM.

And this patch only exposes PASID capability for devices which has PCIe
PASID extended struture in its configuration space. While for VFs, user
space still unable to see this capability as SR-IOV spec forbides VF to
implement PASID capability extended structure. It is a TODO in future.
Related discussion can be found in below link:

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
v7 -> v8:
*) refine the commit message and the subject.

v5 -> v6:
*) add review-by from Eric Auger.

v1 -> v2:
*) added in v2, but it was sent in a separate patchseries before
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a402adee8a21..95b5478f51ac 100644
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
2.25.1

