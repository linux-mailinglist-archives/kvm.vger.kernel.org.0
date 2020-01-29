Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5A14CA7F
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgA2MML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:12:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:15958 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbgA2MLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071296"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:53 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v3 21/25] intel_iommu: do not pass down pasid bind for PASID #0
Date:   Wed, 29 Jan 2020 04:16:52 -0800
Message-Id: <1580300216-86172-22-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

RID_PASID field was introduced in VT-d 3.0 spec, it is used
for DMA requests w/o PASID in scalable mode VT-d. It is also
known as IOVA. And in VT-d 3.1 spec, there is definition on it:

"Implementations not supporting RID_PASID capability
(ECAP_REG.RPS is 0b), use a PASID value of 0 to perform
address translation for requests without PASID."

This patch adds a check against the PASIDs which are going to be
bound to device. For PASID #0, it is not necessary to pass down
pasid bind request for it since PASID #0 is used as RID_PASID for
DMA requests without pasid. Further reason is current Intel vIOMMU
supports gIOVA by shadowing guest 2nd level page table. However,
in future, if guest IOMMU driver uses 1st level page table to store
IOVA mappings, then guest IOVA support will also be done via nested
translation. When gIOVA is over FLPT, then vIOMMU should pass down
the pasid bind request for PASID #0 to host, host needs to bind the
guest IOVA page table to a proper PASID. e.g PASID value in RID_PASID
field for PF/VF if ECAP_REG.RPS is clear or default PASID for ADI
(Assignable Device Interface in Scalable IOV solution).

IOVA over FLPT support on Intel VT-d:
https://lkml.org/lkml/2019/9/23/297

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 6422add..a511289 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -1883,6 +1883,16 @@ static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
     struct iommu_gpasid_bind_data *g_bind_data;
     int ret = -1;
 
+    if (pasid < VTD_MIN_HPASID) {
+        /*
+         * If pasid < VTD_HPASID_MIN, this pasid is not allocated
+         * from host. No need to pass down the changes on it to host.
+         * TODO: when IOVA over FLPT is ready, this switch should be
+         * refined.
+         */
+        return 0;
+    }
+
     vtd_icx = vtd_bus->dev_icx[devfn];
     if (!vtd_icx) {
         return ret;
-- 
2.7.4

