Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16A21452E
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGDLaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 07:30:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:61334 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgGDLaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 07:30:17 -0400
IronPort-SDR: O0q59udiBDRG35b4WE5UHJWxtNxl583qf9nb+T/HHnjmE+q8nwA6sFx/g0GsILEOVc80cY2gmm
 Tgv0Tsi8mBDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="144760859"
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="144760859"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2020 04:30:16 -0700
IronPort-SDR: KfyhITJieKBUkJKVUi6IK5pBB4TJlEyGXvpQ/B54+8iTwPS6xcEgPE/wJGvWXSm2rgRaV0UfIS
 Hnf/+XYOFbtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="266146779"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jul 2020 04:30:16 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        jasowang@redhat.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v7 05/25] intel_iommu: add get_iommu_attr() callback
Date:   Sat,  4 Jul 2020 04:36:29 -0700
Message-Id: <1593862609-36135-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593862609-36135-1-git-send-email-yi.l.liu@intel.com>
References: <1593862609-36135-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return vIOMMU attribute to caller. e.g. VFIO call via PCI layer.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index ca6dcad..2d6748f 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3441,6 +3441,28 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
     return vtd_dev_as;
 }
 
+static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
+                                   IOMMUAttr attr, void *data)
+{
+    int ret = 0;
+
+    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+
+    switch (attr) {
+    case IOMMU_WANT_NESTING:
+    {
+        bool *pdata = data;
+
+        /* return false until vSVA is ready */
+        *pdata = false;
+        break;
+    }
+    default:
+        ret = -ENOENT;
+    }
+    return ret;
+}
+
 static uint64_t get_naturally_aligned_size(uint64_t start,
                                            uint64_t size, int gaw)
 {
@@ -3736,6 +3758,7 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
+    .get_iommu_attr = vtd_dev_get_iommu_attr,
 };
 
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
-- 
2.7.4

