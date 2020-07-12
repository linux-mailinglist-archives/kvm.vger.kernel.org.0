Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99421C8EF
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgGLLUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:20:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:51223 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbgGLLT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:19:56 -0400
IronPort-SDR: ykRSgdPo1MvuJWkpFEI4xkt5BDmLmac8ac2Z1KZI9G54N0hQF4F/BwLnkII81XtM9qeY97sI88
 /9hhQzkMLSgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="148490191"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="148490191"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:19:52 -0700
IronPort-SDR: 8oAFlTJ8KEOyHCfVutOe34LWJ31wX6/F4T4UHSuQvAGNiJ3khGvv9xUAjugLHE+6unBC8eBhoF
 X58yMKW7zJkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="307121470"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jul 2020 04:19:52 -0700
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
Subject: [RFC v8 20/25] intel_iommu: do not pass down pasid bind for PASID #0
Date:   Sun, 12 Jul 2020 04:26:16 -0700
Message-Id: <1594553181-55810-21-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594553181-55810-1-git-send-email-yi.l.liu@intel.com>
References: <1594553181-55810-1-git-send-email-yi.l.liu@intel.com>
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
index de2ba0e..47af7b1 100644
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

