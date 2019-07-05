Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB67661055
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfGFLTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfGFLTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354982"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:18:59 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 04/18] intel_iommu: add "sm_model" option
Date:   Fri,  5 Jul 2019 19:01:37 +0800
Message-Id: <1562324511-2910-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d 3.0 introduces scalable mode, and it has a bunch of
capabilities related to scalable mode translation, thus there
are multiple combinations. While this vIOMMU implementation
wants simplify it for user by providing typical combinations.
User could config it by "sm_model" option. The usage is as
below:

"-device intel-iommu,x-scalable-mode=on,sm_model=["legacy"|"scalable"]"

 - "legacy": gives support for SL page table
 - "scalable": gives support for FL page table, pasid, virtual command
 - default to be "legacy" if "x-scalable-mode=on while no sm_model is
   configured

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/i386/intel_iommu.c          | 28 +++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |  2 ++
 include/hw/i386/intel_iommu.h  |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 44b1231..3160a05 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3014,6 +3014,7 @@ static Property vtd_properties[] = {
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
     DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
     DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
+    DEFINE_PROP_STRING("sm_model", IntelIOMMUState, sm_model),
     DEFINE_PROP_END_OF_LIST(),
 };
 
@@ -3489,6 +3490,14 @@ static void vtd_iommu_replay(IOMMUMemoryRegion *iommu_mr, IOMMUNotifier *n)
     return;
 }
 
+const char sm_model_manual[] =
+        "\"-device intel-iommu,x-scalable-mode=on,"
+        "sm_model=[\"legacy\"|\"scalable\"]\"\n"
+        " - \"legacy\" gives support for SL page table based IOVA\n"
+        " - \"scalable\" gives support for FL page table based IOVA and SVA\n"
+        " - default to be \"legacy\" if \"x-scalable-mode=on\""
+        " while no sm_model is configured\n";
+
 /* Do the initialization. It will also be called when reset, so pay
  * attention when adding new initialization stuff.
  */
@@ -3557,9 +3566,26 @@ static void vtd_init(IntelIOMMUState *s)
         s->cap |= VTD_CAP_CM;
     }
 
+    if (s->sm_model && !s->scalable_mode) {
+        printf("\n\"sm_model\" depends on \"x-scalable-mode\"\n"
+               "please check if \"x-scalable-mode\" is expected\n"
+               "\"sm_model\" manual:\n%s", sm_model_manual);
+        exit(1);
+    }
+
     /* TODO: read cap/ecap from host to decide which cap to be exposed. */
     if (s->scalable_mode) {
-        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+        if (!s->sm_model || !strcmp(s->sm_model, "legacy")) {
+            s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+        } else if (!strcmp(s->sm_model, "scalable")) {
+            s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
+                       | VTD_ECAP_FLTS;
+        } else {
+            printf("\n!!!!! Invalid sm_model config !!!!!\n"
+                "Please config sm_model=[\"legacy\"|\"scalable\"]\n"
+                "\"sm_model\" manual:\n%s", sm_model_manual);
+            exit(1);
+        }
     }
 
     vtd_reset_caches(s);
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index c1235a7..adae198 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -190,8 +190,10 @@
 #define VTD_ECAP_PT                 (1ULL << 6)
 #define VTD_ECAP_MHMV               (15ULL << 20)
 #define VTD_ECAP_SRS                (1ULL << 31)
+#define VTD_ECAP_PASID              (1ULL << 40)
 #define VTD_ECAP_SMTS               (1ULL << 43)
 #define VTD_ECAP_SLTS               (1ULL << 46)
+#define VTD_ECAP_FLTS               (1ULL << 47)
 
 /* CAP_REG */
 /* (offset >> 4) << 24 */
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 12f3d26..b51cc9f 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -270,6 +270,7 @@ struct IntelIOMMUState {
     bool buggy_eim;                 /* Force buggy EIM unless eim=off */
     uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
+    char *sm_model;          /* identify actual scalable mode iommu model*/
 
     /*
      * Protects IOMMU states in general.  Currently it protects the
-- 
2.7.4

