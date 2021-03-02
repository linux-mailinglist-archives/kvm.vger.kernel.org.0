Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE30032A749
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839221AbhCBQGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:30343 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350777AbhCBMue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:34 -0500
IronPort-SDR: /j3Z/MkapQVf/O8Vpr30lqr5pKiwerCv/Bb+n6JmCt18Dg7LKwRi9wTLesXgz7lgqtoC2tS0PU
 Nxeox31WS8og==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184363181"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184363181"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:39:54 -0800
IronPort-SDR: 7FTvWOJkC8bPt30nBvexOxahXLmfFnZEm9hZcL04uKbYV83qoJTsfdV7ZZvgE4kntC/dZHZNmF
 nKAVOEi9m6SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472732"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:39:49 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v11 06/25] intel_iommu: add get_iommu_attr() callback
Date:   Wed,  3 Mar 2021 04:38:08 +0800
Message-Id: <20210302203827.437645-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index dd11248b6b..d89d6d7dd5 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3462,6 +3462,28 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
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
@@ -3758,6 +3780,7 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
+    .get_iommu_attr = vtd_dev_get_iommu_attr,
 };
 
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
-- 
2.25.1

