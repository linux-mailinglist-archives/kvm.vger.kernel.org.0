Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34542302D7
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgG1G2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:28:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:57971 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgG1G17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:59 -0400
IronPort-SDR: iIhcYm19cQ+DBAxhtG6T5RoS6l5u6KrMYAVOb2HU2dMIj2ujVsAMiRZo88pdcw7sj+pCZKj62W
 1+JnnWuaJ+cQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130720445"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="130720445"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:58 -0700
IronPort-SDR: ItyTHZyrbyHCTEMcllIu/IH+8BBhzzERjqbEmJM87CsJBxL+eO9UBEKMrr8jkUrwtmWAWB3FLa
 GHIWqyjmEXRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394233123"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:57 -0700
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
Subject: [RFC v9 25/25] intel_iommu: modify x-scalable-mode to be string option
Date:   Mon, 27 Jul 2020 23:34:18 -0700
Message-Id: <1595918058-33392-26-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d 3.0 introduces scalable mode, and it has a bunch of capabilities
related to scalable mode translation, thus there are multiple combinations.
While this vIOMMU implementation wants simplify it for user by providing
typical combinations. User could config it by "x-scalable-mode" option. The
usage is as below:

"-device intel-iommu,x-scalable-mode=["legacy"|"modern"|"off"]"

 - "legacy": gives support for SL page table
 - "modern": gives support for FL page table, pasid, virtual command
 - "off": no scalable mode support
 -  if not configured, means no scalable mode support, if not proper
    configured, will throw error

Note: this patch is supposed to be merged when the whole vSVA patch series
were merged.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
rfcv5 (v2) -> rfcv6:
*) reports want_nested to VFIO;
*) assert iommu_set/unset_iommu_context() if vIOMMU is not scalable modern.
---
 hw/i386/intel_iommu.c          | 39 +++++++++++++++++++++++++++++++++++----
 hw/i386/intel_iommu_internal.h |  3 +++
 include/hw/i386/intel_iommu.h  |  2 ++
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 11f815d..73a44b5 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -4050,7 +4050,7 @@ static Property vtd_properties[] = {
     DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
                       VTD_HOST_ADDRESS_WIDTH),
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
-    DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
+    DEFINE_PROP_STRING("x-scalable-mode", IntelIOMMUState, scalable_mode_str),
     DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
     DEFINE_PROP_END_OF_LIST(),
 };
@@ -4420,6 +4420,7 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
 static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
                                    IOMMUAttr attr, void *data)
 {
+    IntelIOMMUState *s = opaque;
     int ret = 0;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
@@ -4429,8 +4430,7 @@ static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
     {
         bool *pdata = data;
 
-        /* return false until vSVA is ready */
-        *pdata = false;
+        *pdata = s->scalable_modern ? true : false;
         break;
     }
     default:
@@ -4526,6 +4526,8 @@ static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
     VTDHostIOMMUContext *vtd_dev_icx;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+    /* only modern scalable supports set_ioimmu_context */
+    assert(s->scalable_modern);
 
     vtd_bus = vtd_find_add_bus(s, bus);
 
@@ -4560,6 +4562,8 @@ static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
     VTDHostIOMMUContext *vtd_dev_icx;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+    /* only modern scalable supports unset_ioimmu_context */
+    assert(s->scalable_modern);
 
     vtd_bus = vtd_find_add_bus(s, bus);
 
@@ -4787,8 +4791,13 @@ static void vtd_init(IntelIOMMUState *s)
     }
 
     /* TODO: read cap/ecap from host to decide which cap to be exposed. */
-    if (s->scalable_mode) {
+    if (s->scalable_mode && !s->scalable_modern) {
         s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+    } else if (s->scalable_mode && s->scalable_modern) {
+        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID |
+                   VTD_ECAP_FLTS | VTD_ECAP_PSS(VTD_PASID_SS) |
+                   VTD_ECAP_VCS;
+        s->vccap |= VTD_VCCAP_PAS;
     }
 
     if (!s->cap_finalized) {
@@ -4929,6 +4938,28 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
         return false;
     }
 
+    if (s->scalable_mode_str &&
+        (strcmp(s->scalable_mode_str, "off") &&
+         strcmp(s->scalable_mode_str, "modern") &&
+         strcmp(s->scalable_mode_str, "legacy"))) {
+        error_setg(errp, "Invalid x-scalable-mode config,"
+                         "Please use \"modern\", \"legacy\" or \"off\"");
+        return false;
+    }
+
+    if (s->scalable_mode_str &&
+        !strcmp(s->scalable_mode_str, "legacy")) {
+        s->scalable_mode = true;
+        s->scalable_modern = false;
+    } else if (s->scalable_mode_str &&
+        !strcmp(s->scalable_mode_str, "modern")) {
+        s->scalable_mode = true;
+        s->scalable_modern = true;
+    } else {
+        s->scalable_mode = false;
+        s->scalable_modern = false;
+    }
+
     return true;
 }
 
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 9b4fc67..afb4c6a 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -197,7 +197,9 @@
 #define VTD_ECAP_MHMV               (15ULL << 20)
 #define VTD_ECAP_SRS                (1ULL << 31)
 #define VTD_ECAP_SMTS               (1ULL << 43)
+#define VTD_ECAP_VCS                (1ULL << 44)
 #define VTD_ECAP_SLTS               (1ULL << 46)
+#define VTD_ECAP_FLTS               (1ULL << 47)
 
 /* 1st level related caps */
 #define VTD_CAP_FL1GP               (1ULL << 56)
@@ -209,6 +211,7 @@
 #define VTD_ECAP_PSS(val)           (((val) & 0x1fULL) << 35)
 #define VTD_ECAP_PASID              (1ULL << 40)
 
+#define VTD_PASID_SS                (19)
 #define VTD_GET_PSS(val)            (((val) >> 35) & 0x1f)
 #define VTD_ECAP_PSS_MASK           (0x1fULL << 35)
 
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 1aab882..fd64364 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -263,6 +263,8 @@ struct IntelIOMMUState {
 
     bool caching_mode;              /* RO - is cap CM enabled? */
     bool scalable_mode;             /* RO - is Scalable Mode supported? */
+    char *scalable_mode_str;        /* RO - admin's Scalable Mode config */
+    bool scalable_modern;           /* RO - is modern SM supported? */
 
     dma_addr_t root;                /* Current root table pointer */
     bool root_scalable;             /* Type of root table (scalable or not) */
-- 
2.7.4

