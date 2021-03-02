Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5E32A754
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839298AbhCBQGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:51767 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444944AbhCBMxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:53:02 -0500
IronPort-SDR: +pc6Ls4RPHR3L5VciL5vXEy+s0GXs11osb5jR+33bmVZRKj4M03aVfubIz2prRwy0tKDN6xOAs
 1PPMPgy/CGmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841567"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841567"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:41:27 -0800
IronPort-SDR: lFKUWn0rSqPG/euKKza+izIe7XKhlv0wFHqvmsj3eGwcTpkMTEsRw00qzDMc5AIVcDxylYxx6I
 MebPpodK9JzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473197"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:41:23 -0800
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
Subject: [RFC v11 25/25] intel_iommu: modify x-scalable-mode to be string option
Date:   Wed,  3 Mar 2021 04:38:27 +0800
Message-Id: <20210302203827.437645-26-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
rfcv10 -> rfcv11:
*) this series uses /dev/ioasid for PASID allocation/free. In this patch,
   /dev/ioasid is opened it when deciding config.

rfcv5 (v2) -> rfcv6:
*) reports want_nested to VFIO;
*) assert iommu_set/unset_iommu_context() if vIOMMU is not scalable modern.
---
 hw/i386/intel_iommu.c          | 74 ++++++++++++++++++++++++++++++++--
 hw/i386/intel_iommu_internal.h |  3 ++
 include/hw/i386/intel_iommu.h  |  2 +
 3 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 932c235f37..c7322357d3 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -4085,7 +4085,7 @@ static Property vtd_properties[] = {
     DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
                       VTD_HOST_ADDRESS_WIDTH),
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
-    DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
+    DEFINE_PROP_STRING("x-scalable-mode", IntelIOMMUState, scalable_mode_str),
     DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
     DEFINE_PROP_END_OF_LIST(),
 };
@@ -4454,6 +4454,7 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
 static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
                                    IOMMUAttr attr, void *data)
 {
+    IntelIOMMUState *s = opaque;
     int ret = 0;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
@@ -4463,8 +4464,7 @@ static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
     {
         bool *pdata = data;
 
-        /* return false until vSVA is ready */
-        *pdata = false;
+        *pdata = s->scalable_modern ? true : false;
         break;
     }
     default:
@@ -4558,6 +4558,8 @@ static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
     VTDHostIOMMUContext *vtd_dev_icx;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+    /* only modern scalable supports unset_ioimmu_context */
+    assert(s->scalable_modern);
 
     vtd_bus = vtd_find_add_bus(s, bus);
 
@@ -4592,6 +4594,8 @@ static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
     VTDHostIOMMUContext *vtd_dev_icx;
 
     assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+    /* only modern scalable supports set_ioimmu_context */
+    assert(s->scalable_modern);
 
     vtd_bus = vtd_find_add_bus(s, bus);
 
@@ -4820,8 +4824,13 @@ static void vtd_init(IntelIOMMUState *s)
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
@@ -4962,6 +4971,63 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
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
+        if (ioasid_fd < 0) {
+            int fd, version;
+            struct ioasid_info info;
+
+            fd = qemu_open_old("/dev/ioasid", O_RDWR);
+            if (fd < 0) {
+                error_setg(errp, "Failed to open /dev/ioasid, %m");
+                return false;
+            }
+
+            version = ioctl(fd, IOASID_GET_API_VERSION);
+            if (version != IOASID_API_VERSION) {
+                error_setg(errp, "supported ioasid version: %d, "
+                           "reported version: %d", IOASID_API_VERSION, version);
+                return false;
+            }
+
+            memset(&info, 0x0, sizeof(info));
+            info.argsz = sizeof(info);
+            if (ioctl(fd, IOASID_GET_INFO, &info)) {
+                error_setg(errp, "Failed to get ioasid info, %m");
+                return false;
+            }
+
+            if ((VTD_PASID_SS + 1) > info.ioasid_bits) {
+                error_setg(errp, "supported pasid bits: %u, reported pasid "
+                           "bits: %u", VTD_PASID_SS + 1, info.ioasid_bits);
+                return false;
+            }
+
+            ioasid_fd = fd;
+            ioasid_bits = info.ioasid_bits;
+        }
+        s->ioasid_fd = ioasid_fd;
+        s->ioasid_bits = ioasid_bits;
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
index be29f3672b..3587137915 100644
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
index 10dabff6b5..4aac1fa912 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -262,6 +262,8 @@ struct IntelIOMMUState {
 
     bool caching_mode;              /* RO - is cap CM enabled? */
     bool scalable_mode;             /* RO - is Scalable Mode supported? */
+    char *scalable_mode_str;        /* RO - admin's Scalable Mode config */
+    bool scalable_modern;           /* RO - is modern SM supported? */
 
     dma_addr_t root;                /* Current root table pointer */
     bool root_scalable;             /* Type of root table (scalable or not) */
-- 
2.25.1

