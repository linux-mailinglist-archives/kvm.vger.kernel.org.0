Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6E461063
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfGFLTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfGFLTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355079"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:39 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 18/18] intel_iommu: do not passdown pasid bind for PASID #0
Date:   Fri,  5 Jul 2019 19:01:51 +0800
Message-Id: <1562324511-2910-19-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RID_PASID field was introduced in VT-d 3.0 spec, it is used for DMA
requests w/o PASID in scalable mode VT-d. It is also known as IOVA.
And in VT-d 3.1 spec, there is further definition on it:

"Implementations not supporting RID_PASID capability (ECAP_REG.RPS is
0b), use a PASID value of 0 to perform address translation for requests
without PASID."

This patch adds a check on the PASIDs which are going to be bound to
device. For PASID #0, no need to passdown pasid binding since PASID #0
is used as RID_PASID for requests without pasid. Reason is current Intel
vIOMMU supports guest IOVA by shadowing guest 2nd level page table.
However, in future, if guest OS uses 1st level page table to store IOVA
mappings, thus guest IOVA support will also be done via nested translation
in host side. Then vIOMMU could passdown the pasid binding for PASID #0
to host with a special PASID value. A special PASID value is to indicate
host to bind the guest page table to a proper PASID. e.g PASID value from
RID_PASID field for PF/VF or default PASID for ADI (Assignable Device
Interface in Scalable IOV solution).

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index e4286e5..ee55209 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -1853,6 +1853,14 @@ static void vtd_bind_guest_pasid(IntelIOMMUState *s, int bus_n,
 {
     PCIBus *bus;
     struct gpasid_bind_data *g_bind_data;
+
+    if (pasid < VTD_MIN_HPASID) {
+        /*
+         * If pasid < VTD_HPASID_MIN, this pasid is not allocated
+         * from host. No need to passdown the changes on it to host.
+         */
+        return;
+    }
     bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
     g_bind_data = g_malloc0(sizeof(*g_bind_data));
 
-- 
2.7.4

