Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867ED2302D4
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgG1G1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:57961 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgG1G1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:54 -0400
IronPort-SDR: OXRFVTlsGxhGk3h4wiD4u6eKpKdEw7DMj+DZlqgC3eocOCFDyNDPafs9bqTG3FAsxXw4dZdmjH
 kcqVf6VRWHtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130720434"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="130720434"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:54 -0700
IronPort-SDR: cI+u6BoBiVXaD1ZHPOtGYUecQ1q4g30tRZxcHcHm4aDudZcHfvA8Ack9r2K6qx0ItpuoSIQrV4
 fhC02+72y6PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394233060"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:52 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v9 20/25] intel_iommu: do not pass down pasid bind for PASID #0
Date:   Mon, 27 Jul 2020 23:34:13 -0700
Message-Id: <1595918058-33392-21-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
guest IOVA page table to a proper PASID. e.g. PASID value in RID_PASID
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
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index efad0af..f0e1afa 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -1893,6 +1893,16 @@ static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
     HostIOMMUContext *iommu_ctx;
     int ret = -1;
 
+    if (pasid < VTD_HPASID_MIN) {
+        /*
+         * If pasid < VTD_HPASID_MIN, this pasid is not allocated
+         * from host. No need to pass down the changes on it to host.
+         * TODO: when IOVA over FLPT is ready, this switch should be
+         * refined.
+         */
+        return 0;
+    }
+
     vtd_dev_icx = vtd_bus->dev_icx[devfn];
     if (!vtd_dev_icx) {
         /* means no need to go further, e.g. for emulated devices */
-- 
2.7.4

