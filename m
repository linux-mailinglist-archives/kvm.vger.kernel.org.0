Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E722D32A737
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839081AbhCBQF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:51835 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240785AbhCBMpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:45:01 -0500
IronPort-SDR: XV/PbdGPjDJJfXMKli/jYRtPFWmymlWMWQRNBq7yr0q8Z310bL9yP/6lXUN505mP1NPG73/xVd
 f2VddFi5vPfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841353"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841353"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:39 -0800
IronPort-SDR: O6wXUzhQlrXAXH4LJDAxQ03MeYn/fgXrDaex8JJdX3qOav0lwfTquG6+24W9T2udw/HsqB5DfX
 v3lYO6H6gQuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473011"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:40:34 -0800
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
Subject: [RFC v11 15/25] intel_iommu: add virtual command capability support
Date:   Wed,  3 Mar 2021 04:38:17 +0800
Message-Id: <20210302203827.437645-16-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
rfcv10 -> rfcv11:
*) use /dev/ioasid FD for pasid alloc/free, /dev/ioasid open is added in
   latter patch.
---
 hw/i386/intel_iommu.c          | 141 +++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  37 +++++++++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |  10 ++-
 4 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 203c898fa4..7786f97ed6 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -40,6 +40,11 @@
 #include "kvm/kvm_i386.h"
 #include "migration/vmstate.h"
 #include "trace.h"
+#include <linux/ioasid.h>
+#include <sys/ioctl.h>
+
+int ioasid_fd = -1;
+uint32_t ioasid_bits;
 
 /* context entry operations */
 #define VTD_CE_GET_RID2PASID(ce) \
@@ -2678,6 +2683,118 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
     }
 }
 
+static int vtd_request_pasid_alloc(IntelIOMMUState *s, uint32_t *pasid)
+{
+    struct ioasid_alloc_request req;
+    int ret;
+
+    req.argsz = sizeof(req);
+    req.flags = 0;
+    req.range.min = VTD_HPASID_MIN;
+    req.range.max = VTD_HPASID_MAX;
+
+    if (s->ioasid_fd < 0) {
+        error_report("%s: No available allocation interface", __func__);
+        return -1;
+    }
+
+    vtd_iommu_lock(s);
+    ret = ioctl(s->ioasid_fd, IOASID_REQUEST_ALLOC, &req);
+    if (ret < 0) {
+        error_report("%s: alloc failed %d", __func__, ret);
+    }
+    printf("%s, ret: %d\n", __func__, ret);
+    vtd_iommu_unlock(s);
+    *pasid = ret;
+    return (ret < 0) ? ret : 0;
+}
+
+static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
+{
+    int ret = -1;
+
+    if (s->ioasid_fd < 0) {
+        error_report("%s: No available allocation interface", __func__);
+        return -1;
+    }
+
+    vtd_iommu_lock(s);
+    ret = ioctl(s->ioasid_fd, IOASID_REQUEST_FREE, &pasid);
+    if (ret < 0) {
+        error_report("%s: free failed (%m)", __func__);
+    }
+    vtd_iommu_unlock(s);
+
+    return ret;
+}
+
+/*
+ * If IP is not set, set it then return.
+ * If IP is already set, return.
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
@@ -2966,6 +3083,23 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
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
@@ -3902,6 +4036,13 @@ static void vtd_init(IntelIOMMUState *s)
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
index af2c7bcd93..6abb4836a1 100644
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
@@ -331,6 +337,37 @@ typedef enum VTDFaultReason {
 
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
+#define VTD_HPASID_MIN              1
+#define VTD_HPASID_MAX              0xFFFFF
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
index e48bef2b0d..71536a7c20 100644
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
index d6a90f07f4..cca9c821fe 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -42,7 +42,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(IntelIOMMUState, INTEL_IOMMU_DEVICE)
 #define VTD_SID_TO_BUS(sid)         (((sid) >> 8) & 0xff)
 #define VTD_SID_TO_DEVFN(sid)       ((sid) & 0xff)
 
-#define DMAR_REG_SIZE               0x230
+#define DMAR_REG_SIZE               0xF00
 #define VTD_HOST_AW_39BIT           39
 #define VTD_HOST_AW_48BIT           48
 #define VTD_HOST_ADDRESS_WIDTH      VTD_HOST_AW_39BIT
@@ -281,6 +281,14 @@ struct IntelIOMMUState {
     uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
 
+    /* Virtual Command Register */
+    uint64_t vccap;                 /* The value of vcmd capability reg */
+    uint64_t vcrsp;                 /* Current value of VCMD RSP REG */
+    /* /dev/ioasid interface */
+    int ioasid_fd;                  /* /dev/ioasid FD */
+    uint32_t ioasid_bits;           /* IOASID width supported by
+                                       host (in bits) */
+
     bool cap_finalized;             /* Whether VTD capability finalized */
     /*
      * iommu_lock protects below:
-- 
2.25.1

