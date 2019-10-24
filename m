Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0788FE3353
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502284AbfJXNCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:02:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:5208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502301AbfJXNCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:02:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156326"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:02:01 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 18/22] intel_iommu: do not passdown pasid bind for PASID #0
Date:   Thu, 24 Oct 2019 08:34:39 -0400
Message-Id: <1571920483-3382-19-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
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
mappings, thus guest IOVA support will also be done via nested translation.
Then vIOMMU could passdown the pasid binding for PASID #0 to host with a
special PASID value to indicate host to bind the guest page table to a
proper PASID. e.g PASID value from RID_PASID field for PF/VF if ECAP_REG.RPS
is clear or default PASID for ADI (Assignable Device Interface in Scalable
IOV solution).

IOVA over FLPT support on Intel VT-d: https://lkml.org/lkml/2019/9/23/297

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 6bceb7f..d621455 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -1880,6 +1880,16 @@ static void vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
     IOMMUCTXPASIDBindData bind;
     struct iommu_gpasid_bind_data *g_bind_data;
 
+    if (pasid < VTD_MIN_HPASID) {
+        /*
+         * If pasid < VTD_HPASID_MIN, this pasid is not allocated
+         * from host. No need to passdown the changes on it to host.
+         * TODO: when IOVA over FLPT is ready, this switch should be
+         * refined.
+         */
+        return;
+    }
+
     vtd_ic = vtd_bus->dev_ic[devfn];
     if (!vtd_ic) {
         return;
-- 
2.7.4

