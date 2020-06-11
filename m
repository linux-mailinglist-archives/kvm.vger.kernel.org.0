Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E671F6825
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgFKMsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:48:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:58113 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgFKMsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:48:02 -0400
IronPort-SDR: 5PplijUSQxicFnIg+Px0XpTvOrCkTOtnZQH3lgbsmMSizF1Cek7UnoXQwTjNCSuXPC/Ul7dwvD
 e6w91Oy/2u4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:47:59 -0700
IronPort-SDR: NmizZxckybESKM/pRfJgYsq2U6d4dWu5PVyKa357+KHV/cycb7a246ZLGa8OfFNhXAetBHDtgq
 NBjOMmYujN1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="447911228"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 05:47:59 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v6 05/25] intel_iommu: add get_iommu_attr() callback
Date:   Thu, 11 Jun 2020 05:54:04 -0700
Message-Id: <1591880064-30638-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
References: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
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
index 4b22910..a8b7627 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3436,6 +3436,28 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
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
@@ -3731,6 +3753,7 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
+    .get_iommu_attr = vtd_dev_get_iommu_attr,
 };
 
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
-- 
2.7.4

