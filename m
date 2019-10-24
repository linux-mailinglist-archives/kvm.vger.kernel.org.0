Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8951E3349
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502295AbfJXNBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:5203 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502287AbfJXNBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156260"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:36 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 10/22] intel_iommu: add virtual command capability support
Date:   Thu, 24 Oct 2019 08:34:31 -0400
Message-Id: <1571920483-3382-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds virtual command support to Intel vIOMMU per
Intel VT-d 3.1 spec. And adds two virtual commands: alloc_pasid
and free_pasid.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/i386/intel_iommu.c          | 162 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |  38 ++++++++++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |   6 +-
 4 files changed, 205 insertions(+), 2 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index e9f8692..88b843f 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -944,6 +944,7 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
                 return vtd_bus;
             }
         }
+        vtd_bus = NULL;
     }
     return vtd_bus;
 }
@@ -2590,6 +2591,140 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
     }
 }
 
+static int vtd_request_pasid_alloc(IntelIOMMUState *s)
+{
+    VTDBus *vtd_bus;
+    int bus_n, devfn;
+    IOMMUCTXEventData event_data;
+    IOMMUCTXPASIDReqDesc req;
+    VTDIOMMUContext *vtd_ic;
+
+    event_data.event = IOMMU_CTX_EVENT_PASID_ALLOC;
+    event_data.data = &req;
+    req.min_pasid = VTD_MIN_HPASID;
+    req.max_pasid = VTD_MAX_HPASID;
+    req.alloc_result = 0;
+    event_data.length = sizeof(req);
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
+        if (!vtd_bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            vtd_ic = vtd_bus->dev_ic[devfn];
+            if (!vtd_ic) {
+                continue;
+            }
+            iommu_ctx_event_notify(&vtd_ic->iommu_context, &event_data);
+            if (req.alloc_result > 0) {
+                return req.alloc_result;
+            }
+        }
+    }
+    return -1;
+}
+
+static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
+{
+    VTDBus *vtd_bus;
+    int bus_n, devfn;
+    IOMMUCTXEventData event_data;
+    IOMMUCTXPASIDReqDesc req;
+    VTDIOMMUContext *vtd_ic;
+
+    event_data.event = IOMMU_CTX_EVENT_PASID_FREE;
+    event_data.data = &req;
+    req.pasid = pasid;
+    req.free_result = 0;
+    event_data.length = sizeof(req);
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
+        if (!vtd_bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            vtd_ic = vtd_bus->dev_ic[devfn];
+            if (!vtd_ic) {
+                continue;
+            }
+            iommu_ctx_event_notify(&vtd_ic->iommu_context, &event_data);
+            if (req.free_result == 0) {
+                return 0;
+            }
+        }
+    }
+    return -1;
+}
+
+/*
+ * If IP is not set, set it and return 0
+ * If IP is already set, return -1
+ */
+static int vtd_vcmd_rsp_ip_check(IntelIOMMUState *s)
+{
+    if (!(s->vccap & VTD_VCCAP_PAS) ||
+         (s->vcrsp & 1)) {
+        return -1;
+    }
+    s->vcrsp = 1;
+    vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                     ((uint64_t) s->vcrsp));
+    return 0;
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
+    /*
+     * Since vCPU should be blocked when the guest VMCD
+     * write was trapped to here. Should be no other vCPUs
+     * try to access VCMD if guest software is well written.
+     * However, we still emulate the IP bit here in case of
+     * bad guest software. Also align with the spec.
+     */
+    ret = vtd_vcmd_rsp_ip_check(s);
+    if (ret) {
+        return ret;
+    }
+    switch (val & VTD_VCMD_CMD_MASK) {
+    case VTD_VCMD_ALLOC_PASID:
+        ret = vtd_request_pasid_alloc(s);
+        if (ret < 0) {
+            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_NO_AVAILABLE_PASID);
+        } else {
+            s->vcrsp |= VTD_VCRSP_RSLT(ret);
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
+        printf("Virtual Command: unsupported command!!!\n");
+        break;
+    }
+    vtd_vcmd_clear_ip(s);
+    return 0;
+}
+
 static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
 {
     IntelIOMMUState *s = opaque;
@@ -2879,6 +3014,23 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
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
@@ -3617,7 +3769,8 @@ static void vtd_init(IntelIOMMUState *s)
             s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
         } else if (!strcmp(s->scalable_mode, "modern")) {
             s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
-                       | VTD_ECAP_FLTS | VTD_ECAP_PSS;
+                       | VTD_ECAP_FLTS | VTD_ECAP_PSS | VTD_ECAP_VCS;
+            s->vccap |= VTD_VCCAP_PAS;
         }
     }
 
@@ -3674,6 +3827,13 @@ static void vtd_init(IntelIOMMUState *s)
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
index be7b30a..8668771 100644
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
index c8bc464..43c0314 100644
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
index 1c580c1..0d49480 100644
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
@@ -282,6 +282,10 @@ struct IntelIOMMUState {
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

