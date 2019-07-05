Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC4961057
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfGFLTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfGFLTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354999"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:05 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 06/18] intel_iommu: support virtual command emulation and pasid request
Date:   Fri,  5 Jul 2019 19:01:39 +0800
Message-Id: <1562324511-2910-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds virtual command support to Intel vIOMMU per Intel VT-d 3.1
spec. This patch adds two virtual commands: alloc_pasid and free_pasid.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/i386/intel_iommu.c          | 139 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |  30 +++++++++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |   6 +-
 4 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3160a05..3cf250d 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -932,11 +932,19 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
                 s->vtd_as_by_bus_num[bus_num] = vtd_bus;
                 return vtd_bus;
             }
+            vtd_bus = NULL;
         }
     }
     return vtd_bus;
 }
 
+static PCIBus *vtd_find_pci_bus_from_bus_num(IntelIOMMUState *s,
+                                             uint8_t bus_num)
+{
+    VTDBus *vtd_bus = vtd_find_as_from_bus_num(s, bus_num);
+    return vtd_bus ? vtd_bus->bus : NULL;
+}
+
 /* Given the @iova, get relevant @slptep. @slpte_level will be the last level
  * of the translation, can be used for deciding the size of large page.
  */
@@ -2579,6 +2587,103 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
     }
 }
 
+static int vtd_request_pasid_alloc(IntelIOMMUState *s)
+{
+    PCIBus *bus;
+    int bus_n, devfn;
+
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
+        if (!bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            if (pci_device_is_ops_set(bus, devfn)) {
+                return pci_device_request_pasid_alloc(bus, devfn,
+                                                      VTD_MIN_HPASID,
+                                                      VTD_MAX_HPASID);
+            }
+        }
+    }
+    return -1;
+}
+
+static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
+{
+    PCIBus *bus;
+    int bus_n, devfn;
+
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
+        if (!bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            if (pci_device_is_ops_set(bus, devfn)) {
+                return pci_device_request_pasid_free(bus, devfn, pasid);
+            }
+        }
+    }
+    return -1;
+}
+
+/* Handle write to Virtual Command Register */
+static void vtd_handle_vcmd_write(IntelIOMMUState *s)
+{
+    uint32_t status = vtd_get_long_raw(s, DMAR_VCRSP_REG);
+    uint32_t val = vtd_get_long_raw(s, DMAR_VCMD_REG);
+    uint32_t pasid;
+    int ret = -1;
+
+    trace_vtd_reg_write_vcmd(status, val);
+
+    switch (val & VTD_VCMD_CMD_MASK) {
+    case VTD_VCMD_ALLOC_PASID:
+        if (!(s->vccap & VTD_VCCAP_PAS) ||
+             (s->vcrsp & 1)) {
+            break;
+        }
+        s->vcrsp = 1;
+        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                         ((uint64_t) s->vcrsp));
+        ret = vtd_request_pasid_alloc(s);
+        if (ret < 0) {
+            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_NO_AVAILABLE_PASID);
+        } else {
+            s->vcrsp |= VTD_VCRSP_RSLT(ret);
+        }
+        s->vcrsp &= (~((uint64_t)(0x1)));
+        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                         ((uint64_t) s->vcrsp));
+        break;
+
+    case VTD_VCMD_FREE_PASID:
+        if (!(s->vccap & VTD_VCCAP_PAS) ||
+             (s->vcrsp & 1)) {
+            break;
+        }
+        s->vcrsp &= 1;
+        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                         ((uint64_t) s->vcrsp));
+        pasid = VTD_VCMD_PASID_VALUE(val);
+        ret = vtd_request_pasid_free(s, pasid);
+        if (ret < 0) {
+            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_FREE_INVALID_PASID);
+        }
+        s->vcrsp &= (~((uint64_t)(0x1)));
+        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                         ((uint64_t) s->vcrsp));
+        break;
+
+    default:
+        s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_UNDEFINED_CMD);
+        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
+                         ((uint64_t) s->vcrsp));
+        printf("Virtual Command: unsupported command!!!\n");
+        break;
+    }
+}
+
 static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
 {
     IntelIOMMUState *s = opaque;
@@ -2620,6 +2725,15 @@ static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
         val = s->iq >> 32;
         break;
 
+    case DMAR_VCRSP_REG:
+        val = s->vcrsp;
+        break;
+
+    case DMAR_VCRSP_REG_HI:
+        assert(size == 4);
+        val = s->vcrsp >> 32;
+        break;
+
     default:
         if (size == 4) {
             val = vtd_get_long(s, addr);
@@ -2868,6 +2982,21 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
         vtd_set_long(s, addr, val);
         break;
 
+    case DMAR_VCMD_REG:
+        if (size == 4) {
+            vtd_set_long(s, addr, val);
+        } else {
+            vtd_set_quad(s, addr, val);
+        }
+        vtd_handle_vcmd_write(s);
+        break;
+
+    case DMAR_VCMD_REG_HI:
+        assert(size == 4);
+        vtd_set_long(s, addr, val);
+        vtd_handle_vcmd_write(s);
+        break;
+
     default:
         if (size == 4) {
             vtd_set_long(s, addr, val);
@@ -3579,7 +3708,8 @@ static void vtd_init(IntelIOMMUState *s)
             s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
         } else if (!strcmp(s->sm_model, "scalable")) {
             s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
-                       | VTD_ECAP_FLTS;
+                       | VTD_ECAP_FLTS | VTD_ECAP_VCS;
+            s->vccap |= VTD_VCCAP_PAS;
         } else {
             printf("\n!!!!! Invalid sm_model config !!!!!\n"
                 "Please config sm_model=[\"legacy\"|\"scalable\"]\n"
@@ -3641,6 +3771,13 @@ static void vtd_init(IntelIOMMUState *s)
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
index adae198..f5a2f0d 100644
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
@@ -192,6 +198,7 @@
 #define VTD_ECAP_SRS                (1ULL << 31)
 #define VTD_ECAP_PASID              (1ULL << 40)
 #define VTD_ECAP_SMTS               (1ULL << 43)
+#define VTD_ECAP_VCS                (1ULL << 44)
 #define VTD_ECAP_SLTS               (1ULL << 46)
 #define VTD_ECAP_FLTS               (1ULL << 47)
 
@@ -314,6 +321,29 @@ typedef enum VTDFaultReason {
 
 #define VTD_CONTEXT_CACHE_GEN_MAX       0xffffffffUL
 
+/* VCCAP_REG */
+#define VTD_VCCAP_PAS               (1UL << 0)
+#define VTD_MIN_HPASID              200
+#define VTD_MAX_HPASID              0xFFFFF
+
+/* Virtual Command Register */
+enum {
+     VTD_VCMD_NULL_CMD = 0,
+     VTD_VCMD_ALLOC_PASID,
+     VTD_VCMD_FREE_PASID,
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
index b51cc9f..4b74f3d 100644
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
@@ -272,6 +272,10 @@ struct IntelIOMMUState {
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
     char *sm_model;          /* identify actual scalable mode iommu model*/
 
+    /* Virtual Command Register */
+    uint64_t vccap;                 /* The value of vcmd capability reg */
+    uint64_t vcrsp;                 /* Current value of VCMD RSP REG */
+
     /*
      * Protects IOMMU states in general.  Currently it protects the
      * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
-- 
2.7.4

