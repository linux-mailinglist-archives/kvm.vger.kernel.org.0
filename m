Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0552302DC
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgG1G2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:28:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:53897 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgG1G2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:28:07 -0400
IronPort-SDR: 1ZbrBXqiZDtBzrBIXlCIwhOVFzKptFrZgjGC8s0eZZ9AEdqoBoAkqSIUL+IlvMw8R9eyMRMe+1
 2sjRUrdwiuIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="131222693"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="131222693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:51 -0700
IronPort-SDR: z4L3uqEFyG9U92RZpSFt6AZDvJJDXY3tw2Yh5YS6Eupxaam8lkeSajsHqK3wN+Q8NAvtuGsVcD
 Ev/NAn1Ts6DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394233003"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:49 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [RFC v9 17/25] intel_iommu: sync IOMMU nesting cap info for assigned devices
Date:   Mon, 27 Jul 2020 23:34:10 -0700
Message-Id: <1595918058-33392-18-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For assigned devices, Intel vIOMMU which wants to build DMA protection
based on physical IOMMU nesting paging should check the IOMMU nesting
support in host side. The host will return IOMMU nesting cap info to
user-space (e.g. VFIO returns IOMMU nesting cap info for nesting type
IOMMU). vIOMMU needs to check:
a) IOMMU model
b) 1st-level page table supports
c) address width
d) pasid support

This patch syncs the IOMMU nesting cap info when PCIe device (VFIO case)
sets HostIOMMUContext to vIOMMU. If the host IOMMU nesting support is not
compatible, vIOMMU should return failure to PCIe device.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 107 +++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  18 +++++++
 include/hw/i386/intel_iommu.h  |   4 ++
 3 files changed, 129 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 9b35092..3128374 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -4104,6 +4104,84 @@ static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
     return ret;
 }
 
+
+static bool vtd_check_nesting_info(IntelIOMMUState *s,
+                                   struct iommu_nesting_info *info,
+                                   struct iommu_nesting_info_vtd *vtd)
+{
+    return !((s->aw_bits != info->addr_width) ||
+             ((s->host_cap & VTD_CAP_MASK) !=
+              (vtd->cap_reg & VTD_CAP_MASK)) ||
+             ((s->host_ecap & VTD_ECAP_MASK) !=
+              (vtd->ecap_reg & VTD_ECAP_MASK)) ||
+             (VTD_GET_PSS(s->host_ecap) != (info->pasid_bits - 1)));
+}
+
+/* Caller should hold iommu lock. */
+static bool vtd_sync_nesting_info(IntelIOMMUState *s,
+                                  struct iommu_nesting_info *info)
+{
+    struct iommu_nesting_info_vtd *vtd;
+    uint64_t cap, ecap;
+
+    vtd =  (struct iommu_nesting_info_vtd *) &info->data;
+
+    if (s->cap_finalized) {
+        return vtd_check_nesting_info(s, info, vtd);
+    }
+
+    if (s->aw_bits > info->addr_width) {
+        error_report("User aw-bits: %u > host address width: %u",
+                      s->aw_bits, info->addr_width);
+        return false;
+    }
+
+    cap = s->host_cap & vtd->cap_reg & VTD_CAP_MASK;
+    s->host_cap &= ~VTD_CAP_MASK;
+    s->host_cap |= cap;
+
+    ecap = s->host_ecap & vtd->ecap_reg & VTD_ECAP_MASK;
+    s->host_ecap &= ~VTD_ECAP_MASK;
+    s->host_ecap |= ecap;
+
+    if ((VTD_ECAP_PASID & s->host_ecap) && info->pasid_bits &&
+        (VTD_GET_PSS(s->host_ecap) > (info->pasid_bits - 1))) {
+        s->host_ecap &= ~VTD_ECAP_PSS_MASK;
+        s->host_ecap |= VTD_ECAP_PSS(info->pasid_bits - 1);
+    }
+    return true;
+}
+
+/*
+ * virtual VT-d which wants nested needs to check the host IOMMU
+ * nesting cap info behind the assigned devices. Thus that vIOMMU
+ * could bind guest page table to host.
+ */
+static bool vtd_check_iommu_ctx(IntelIOMMUState *s,
+                                HostIOMMUContext *iommu_ctx)
+{
+    struct iommu_nesting_info *info = iommu_ctx->info;
+    uint32_t minsz, size;
+
+    if (IOMMU_PASID_FORMAT_INTEL_VTD != info->format) {
+        error_report("Format is not compatible for nesting!!!");
+        return false;
+    }
+
+    size = sizeof(struct iommu_nesting_info_vtd);
+    minsz = endof(struct iommu_nesting_info, flags);
+    if (size > (info->argsz - minsz)) {
+        /*
+         * QEMU may have been using new linux-headers/iommu.h than
+         * kernel supports, hence fail it.
+         */
+        error_report("IOMMU nesting cap is not compatible!!!");
+        return false;
+    }
+
+    return vtd_sync_nesting_info(s, info);
+}
+
 static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
                                      int devfn,
                                      HostIOMMUContext *iommu_ctx)
@@ -4118,6 +4196,11 @@ static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
 
     vtd_iommu_lock(s);
 
+    if (!vtd_check_iommu_ctx(s, iommu_ctx)) {
+        vtd_iommu_unlock(s);
+        return -ENOENT;
+    }
+
     vtd_dev_icx = vtd_bus->dev_icx[devfn];
 
     assert(!vtd_dev_icx);
@@ -4373,6 +4456,14 @@ static void vtd_init(IntelIOMMUState *s)
         s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
     }
 
+    if (!s->cap_finalized) {
+        s->host_cap = s->cap;
+        s->host_ecap = s->ecap;
+    } else {
+        s->cap = s->host_cap;
+        s->ecap = s->host_ecap;
+    }
+
     vtd_reset_caches(s);
 
     /* Define registers with default values and bit semantics */
@@ -4506,6 +4597,12 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
     return true;
 }
 
+static void vtd_refresh_capability_reg(IntelIOMMUState *s)
+{
+    vtd_set_quad(s, DMAR_CAP_REG, s->cap);
+    vtd_set_quad(s, DMAR_ECAP_REG, s->ecap);
+}
+
 static int vtd_machine_done_notify_one(Object *child, void *unused)
 {
     IntelIOMMUState *iommu = INTEL_IOMMU_DEVICE(x86_iommu_get_default());
@@ -4519,6 +4616,15 @@ static int vtd_machine_done_notify_one(Object *child, void *unused)
         vtd_panic_require_caching_mode();
     }
 
+    vtd_iommu_lock(iommu);
+    iommu->cap = iommu->host_cap & iommu->cap;
+    iommu->ecap = iommu->host_ecap & iommu->ecap;
+    if (!iommu->cap_finalized) {
+        iommu->cap_finalized = true;
+    }
+
+    vtd_refresh_capability_reg(iommu);
+    vtd_iommu_unlock(iommu);
     return 0;
 }
 
@@ -4550,6 +4656,7 @@ static void vtd_realize(DeviceState *dev, Error **errp)
     QLIST_INIT(&s->vtd_as_with_notifiers);
     QLIST_INIT(&s->vtd_dev_icx_list);
     qemu_mutex_init(&s->iommu_lock);
+    s->cap_finalized = false;
     memset(s->vtd_as_by_bus_num, 0, sizeof(s->vtd_as_by_bus_num));
     memory_region_init_io(&s->csrmem, OBJECT(s), &vtd_mem_ops, s,
                           "intel_iommu", DMAR_REG_SIZE);
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 1829f3a..a57ef3d 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -199,6 +199,24 @@
 #define VTD_ECAP_SMTS               (1ULL << 43)
 #define VTD_ECAP_SLTS               (1ULL << 46)
 
+/* 1st level related caps */
+#define VTD_CAP_FL1GP               (1ULL << 56)
+#define VTD_CAP_FL5LP               (1ULL << 60)
+#define VTD_ECAP_PRS                (1ULL << 29)
+#define VTD_ECAP_ERS                (1ULL << 30)
+#define VTD_ECAP_SRS                (1ULL << 31)
+#define VTD_ECAP_EAFS               (1ULL << 34)
+#define VTD_ECAP_PSS(val)           (((val) & 0x1fULL) << 35)
+#define VTD_ECAP_PASID              (1ULL << 40)
+
+#define VTD_GET_PSS(val)            (((val) >> 35) & 0x1f)
+#define VTD_ECAP_PSS_MASK           (0x1fULL << 35)
+
+#define VTD_CAP_MASK                (VTD_CAP_FL1GP | VTD_CAP_FL5LP)
+#define VTD_ECAP_MASK               (VTD_ECAP_PRS | VTD_ECAP_ERS | \
+                                    VTD_ECAP_SRS | VTD_ECAP_EAFS | \
+                                    VTD_ECAP_PASID)
+
 /* CAP_REG */
 /* (offset >> 4) << 24 */
 #define VTD_CAP_FRO                 (DMAR_FRCD_REG_OFFSET << 20)
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 626c1cd..1aab882 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -284,6 +284,9 @@ struct IntelIOMMUState {
     uint64_t cap;                   /* The value of capability reg */
     uint64_t ecap;                  /* The value of extended capability reg */
 
+    uint64_t host_cap;              /* The value of host capability reg */
+    uint64_t host_ecap;             /* The value of host ext-capability reg */
+
     uint32_t context_cache_gen;     /* Should be in [1,MAX] */
     GHashTable *iotlb;              /* IOTLB */
 
@@ -310,6 +313,7 @@ struct IntelIOMMUState {
     uint64_t vccap;                 /* The value of vcmd capability reg */
     uint64_t vcrsp;                 /* Current value of VCMD RSP REG */
 
+    bool cap_finalized;             /* Whether VTD capability finalized */
     /*
      * iommu_lock protects below:
      * - per-IOMMU IOTLB caches
-- 
2.7.4

