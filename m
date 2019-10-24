Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE3E3343
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502267AbfJXNBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:5182 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502258AbfJXNBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156167"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:15 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 03/22] intel_iommu: modify x-scalable-mode to be string option
Date:   Thu, 24 Oct 2019 08:34:24 -0400
Message-Id: <1571920483-3382-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d 3.0 introduces scalable mode, and it has a bunch of capabilities
related to scalable mode translation, thus there are multiple combinations.
While this vIOMMU implementation wants simplify it for user by providing
typical combinations. User could config it by "x-scalable-mode" option. The
usage is as below:

"-device intel-iommu,x-scalable-mode=["legacy"|"modern"]"

 - "legacy": gives support for SL page table
 - "modern": gives support for FL page table, pasid, virtual command
 -  if not configured, means no scalable mode support, if not proper
    configured, will throw error

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/i386/intel_iommu.c          | 15 +++++++++++++--
 hw/i386/intel_iommu_internal.h |  3 +++
 include/hw/i386/intel_iommu.h  |  2 +-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 771bed2..4a1a07a 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3019,7 +3019,7 @@ static Property vtd_properties[] = {
     DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
                       VTD_HOST_ADDRESS_WIDTH),
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
-    DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
+    DEFINE_PROP_STRING("x-scalable-mode", IntelIOMMUState, scalable_mode),
     DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
     DEFINE_PROP_END_OF_LIST(),
 };
@@ -3581,7 +3581,12 @@ static void vtd_init(IntelIOMMUState *s)
 
     /* TODO: read cap/ecap from host to decide which cap to be exposed. */
     if (s->scalable_mode) {
-        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+        if (!strcmp(s->scalable_mode, "legacy")) {
+            s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+        } else if (!strcmp(s->scalable_mode, "modern")) {
+            s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
+                       | VTD_ECAP_FLTS | VTD_ECAP_PSS;
+        }
     }
 
     vtd_reset_caches(s);
@@ -3700,6 +3705,12 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
         return false;
     }
 
+    if (s->scalable_mode &&
+        (strcmp(s->scalable_mode, "modern") &&
+         strcmp(s->scalable_mode, "legacy"))) {
+            error_setg(errp, "Invalid x-scalable-mode config");
+    }
+
     return true;
 }
 
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index c1235a7..be7b30a 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -190,8 +190,11 @@
 #define VTD_ECAP_PT                 (1ULL << 6)
 #define VTD_ECAP_MHMV               (15ULL << 20)
 #define VTD_ECAP_SRS                (1ULL << 31)
+#define VTD_ECAP_PSS                (19ULL << 35)
+#define VTD_ECAP_PASID              (1ULL << 40)
 #define VTD_ECAP_SMTS               (1ULL << 43)
 #define VTD_ECAP_SLTS               (1ULL << 46)
+#define VTD_ECAP_FLTS               (1ULL << 47)
 
 /* CAP_REG */
 /* (offset >> 4) << 24 */
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 66b931e..6062588 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -231,7 +231,7 @@ struct IntelIOMMUState {
     uint32_t version;
 
     bool caching_mode;              /* RO - is cap CM enabled? */
-    bool scalable_mode;             /* RO - is Scalable Mode supported? */
+    char *scalable_mode;            /* RO - Scalable Mode model */
 
     dma_addr_t root;                /* Current root table pointer */
     bool root_scalable;             /* Type of root table (scalable or not) */
-- 
2.7.4

