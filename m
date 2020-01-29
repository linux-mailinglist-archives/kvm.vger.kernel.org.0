Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6C14CA81
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgA2MMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:12:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:15949 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgA2MLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071088"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:49 -0800
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
Subject: [RFC v3 14/25] intel_iommu: add virtual command capability support
Date:   Wed, 29 Jan 2020 04:16:45 -0800
Message-Id: <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds virtual command support to Intel vIOMMU per
Intel VT-d 3.1 spec. And adds two virtual commands: allocate
pasid and free pasid.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/i386/intel_iommu.c          | 163 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |  38 ++++++++++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |   6 +-
 4 files changed, 206 insertions(+), 2 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 33be40c..43a728f 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2649,6 +2649,142 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
     }
 }
 
+static int vtd_request_pasid_alloc(IntelIOMMUState *s, uint32_t *pasid)
+{
+    VTDBus *vtd_bus;
+    int bus_n, devfn, ret = -errno;
+    VTDIOMMUContext *vtd_icx;
+
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
+        if (!vtd_bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            vtd_icx = vtd_bus->dev_icx[devfn];
+            if (!vtd_icx) {
+                continue;
+            }
+
+            /*
+             * We'll return the first valid result we got. It's
+             * a bit hackish in that we don't have a good global
+             * interface yet to talk to modules like vfio to deliver
+             * this allocation request, so we're leveraging this
+             * per-device iommu object to do the same thing just
+             * to make sure the allocation happens only once.
+             */
+            ret = ds_iommu_pasid_alloc(vtd_icx->dsi_obj,
+                         VTD_MIN_HPASID, VTD_MAX_HPASID, pasid);
+            if (!ret) {
+                break;
+            }
+        }
+    }
+    return ret;
+}
+
+static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
+{
+    VTDBus *vtd_bus;
+    int bus_n, devfn, ret = -errno;
+    VTDIOMMUContext *vtd_icx;
+
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
+        if (!vtd_bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            vtd_icx = vtd_bus->dev_icx[devfn];
+            if (!vtd_icx) {
+                continue;
+            }
+            /*
+             * Similar with pasid allocation. We'll free the pasid
+             * on the first successful free operation. It's a bit
+             * hackish in that we don't have a good global interface
+             * yet to talk to modules like vfio to deliver this pasid
+             * free request, so we're leveraging this per-device iommu
+             * object to do the same thing just to make sure the
+             * free happens only once.
+             */
+            ret = ds_iommu_pasid_free(vtd_icx->dsi_obj, pasid);
+            if (!ret) {
+                break;
+            }
+        }
+    }
+    return ret;
+}
+
+/*
+ * If IP is not set, set it and return 0
+ * If IP is already set, return -1
+ */
+static void vtd_vcmd_set_ip(IntelIOMMUState *s)
+{
+    s->vcrsp = 1;
+    vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                     ((uint64_t) s->vcrsp));
+}
+
+static void vtd_vcmd_clear_ip(IntelIOMMUState *s)
+{
+    s->vcrsp &= (~((uint64_t)(0x1)));
+    vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                     ((uint64_t) s->vcrsp));
+}
+
+/* Handle write to Virtual Command Register */
+static int vtd_handle_vcmd_write(IntelIOMMUState *s, uint64_t val)
+{
+    uint32_t pasid;
+    int ret = -1;
+
+    trace_vtd_reg_write_vcmd(s->vcrsp, val);
+
+    if (!(s->vccap & VTD_VCCAP_PAS) ||
+         (s->vcrsp & 1)) {
+        return -1;
+    }
+
+    /*
+     * Since vCPU should be blocked when the guest VMCD
+     * write was trapped to here. Should be no other vCPUs
+     * try to access VCMD if guest software is well written.
+     * However, we still emulate the IP bit here in case of
+     * bad guest software. Also align with the spec.
+     */
+    vtd_vcmd_set_ip(s);
+
+    switch (val & VTD_VCMD_CMD_MASK) {
+    case VTD_VCMD_ALLOC_PASID:
+        ret = vtd_request_pasid_alloc(s, &pasid);
+        if (ret) {
+            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_NO_AVAILABLE_PASID);
+        } else {
+            s->vcrsp |= VTD_VCRSP_RSLT(pasid);
+        }
+        break;
+
+    case VTD_VCMD_FREE_PASID:
+        pasid = VTD_VCMD_PASID_VALUE(val);
+        ret = vtd_request_pasid_free(s, pasid);
+        if (ret < 0) {
+            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_FREE_INVALID_PASID);
+        }
+        break;
+
+    default:
+        s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_UNDEFINED_CMD);
+        error_report_once("Virtual Command: unsupported command!!!");
+        break;
+    }
+    vtd_vcmd_clear_ip(s);
+    return 0;
+}
+
 static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
 {
     IntelIOMMUState *s = opaque;
@@ -2938,6 +3074,23 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
         vtd_set_long(s, addr, val);
         break;
 
+    case DMAR_VCMD_REG:
+        if (!vtd_handle_vcmd_write(s, val)) {
+            if (size == 4) {
+                vtd_set_long(s, addr, val);
+            } else {
+                vtd_set_quad(s, addr, val);
+            }
+        }
+        break;
+
+    case DMAR_VCMD_REG_HI:
+        assert(size == 4);
+        if (!vtd_handle_vcmd_write(s, val)) {
+            vtd_set_long(s, addr, val);
+        }
+        break;
+
     default:
         if (size == 4) {
             vtd_set_long(s, addr, val);
@@ -3712,7 +3865,8 @@ static void vtd_init(IntelIOMMUState *s)
         s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
     } else if (s->scalable_mode && s->scalable_modern) {
         s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
-                   | VTD_ECAP_FLTS | VTD_ECAP_PSS;
+                   | VTD_ECAP_FLTS | VTD_ECAP_PSS | VTD_ECAP_VCS;
+        s->vccap |= VTD_VCCAP_PAS;
     }
 
     vtd_reset_caches(s);
@@ -3768,6 +3922,13 @@ static void vtd_init(IntelIOMMUState *s)
      * Interrupt remapping registers.
      */
     vtd_define_quad(s, DMAR_IRTA_REG, 0, 0xfffffffffffff80fULL, 0);
+
+    /*
+     * Virtual Command Definitions
+     */
+    vtd_define_quad(s, DMAR_VCCAP_REG, s->vccap, 0, 0);
+    vtd_define_quad(s, DMAR_VCMD_REG, 0, 0xffffffffffffffffULL, 0);
+    vtd_define_quad(s, DMAR_VCRSP_REG, 0, 0, 0);
 }
 
 /* Should not reset address_spaces when reset because devices will still use
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index c4dbb2c..fb5fdc2 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -85,6 +85,12 @@
 #define DMAR_MTRRCAP_REG_HI     0x104
 #define DMAR_MTRRDEF_REG        0x108 /* MTRR default type */
 #define DMAR_MTRRDEF_REG_HI     0x10c
+#define DMAR_VCCAP_REG          0xE00 /* Virtual Command Capability Register */
+#define DMAR_VCCAP_REG_HI       0xE04
+#define DMAR_VCMD_REG           0xE10 /* Virtual Command Register */
+#define DMAR_VCMD_REG_HI        0xE14
+#define DMAR_VCRSP_REG          0xE20 /* Virtual Command Reponse Register */
+#define DMAR_VCRSP_REG_HI       0xE24
 
 /* IOTLB registers */
 #define DMAR_IOTLB_REG_OFFSET   0xf0 /* Offset to the IOTLB registers */
@@ -193,6 +199,7 @@
 #define VTD_ECAP_PSS                (19ULL << 35)
 #define VTD_ECAP_PASID              (1ULL << 40)
 #define VTD_ECAP_SMTS               (1ULL << 43)
+#define VTD_ECAP_VCS                (1ULL << 44)
 #define VTD_ECAP_SLTS               (1ULL << 46)
 #define VTD_ECAP_FLTS               (1ULL << 47)
 
@@ -315,6 +322,37 @@ typedef enum VTDFaultReason {
 
 #define VTD_CONTEXT_CACHE_GEN_MAX       0xffffffffUL
 
+/* VCCAP_REG */
+#define VTD_VCCAP_PAS               (1UL << 0)
+
+/*
+ * The basic idea is to let hypervisor to set a range for available
+ * PASIDs for VMs. One of the reasons is PASID #0 is reserved by
+ * RID_PASID usage. We have no idea how many reserved PASIDs in future,
+ * so here just an evaluated value. Honestly, set it as "1" is enough
+ * at current stage.
+ */
+#define VTD_MIN_HPASID              1
+#define VTD_MAX_HPASID              0xFFFFF
+
+/* Virtual Command Register */
+enum {
+     VTD_VCMD_NULL_CMD = 0,
+     VTD_VCMD_ALLOC_PASID = 1,
+     VTD_VCMD_FREE_PASID = 2,
+     VTD_VCMD_CMD_NUM,
+};
+
+#define VTD_VCMD_CMD_MASK           0xffUL
+#define VTD_VCMD_PASID_VALUE(val)   (((val) >> 8) & 0xfffff)
+
+#define VTD_VCRSP_RSLT(val)         ((val) << 8)
+#define VTD_VCRSP_SC(val)           (((val) & 0x3) << 1)
+
+#define VTD_VCMD_UNDEFINED_CMD         1ULL
+#define VTD_VCMD_NO_AVAILABLE_PASID    2ULL
+#define VTD_VCMD_FREE_INVALID_PASID    2ULL
+
 /* Interrupt Entry Cache Invalidation Descriptor: VT-d 6.5.2.7. */
 struct VTDInvDescIEC {
     uint32_t type:4;            /* Should always be 0x4 */
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index e48bef2..71536a7 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -51,6 +51,7 @@ vtd_reg_write_gcmd(uint32_t status, uint32_t val) "status 0x%"PRIx32" value 0x%"
 vtd_reg_write_fectl(uint32_t value) "value 0x%"PRIx32
 vtd_reg_write_iectl(uint32_t value) "value 0x%"PRIx32
 vtd_reg_ics_clear_ip(void) ""
+vtd_reg_write_vcmd(uint32_t status, uint32_t val) "status 0x%"PRIx32" value 0x%"PRIx32
 vtd_dmar_translate(uint8_t bus, uint8_t slot, uint8_t func, uint64_t iova, uint64_t gpa, uint64_t mask) "dev %02x:%02x.%02x iova 0x%"PRIx64" -> gpa 0x%"PRIx64" mask 0x%"PRIx64
 vtd_dmar_enable(bool en) "enable %d"
 vtd_dmar_fault(uint16_t sid, int fault, uint64_t addr, bool is_write) "sid 0x%"PRIx16" fault %d addr 0x%"PRIx64" write %d"
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 1ef2917..4158116 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -46,7 +46,7 @@
 #define VTD_SID_TO_BUS(sid)         (((sid) >> 8) & 0xff)
 #define VTD_SID_TO_DEVFN(sid)       ((sid) & 0xff)
 
-#define DMAR_REG_SIZE               0x230
+#define DMAR_REG_SIZE               0xF00
 #define VTD_HOST_AW_39BIT           39
 #define VTD_HOST_AW_48BIT           48
 #define VTD_HOST_ADDRESS_WIDTH      VTD_HOST_AW_39BIT
@@ -285,6 +285,10 @@ struct IntelIOMMUState {
     uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
 
+    /* Virtual Command Register */
+    uint64_t vccap;                 /* The value of vcmd capability reg */
+    uint64_t vcrsp;                 /* Current value of VCMD RSP REG */
+
     /*
      * Protects IOMMU states in general.  Currently it protects the
      * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
-- 
2.7.4

