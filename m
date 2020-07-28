Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD622302D3
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgG1G1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:57961 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgG1G1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:53 -0400
IronPort-SDR: lGLhx+FUoGDFssRurSUCGmRK8xqMvtGslYTHXT5nYxhlKl32g/Z9NzThHKari6G7lHlS2/cjkj
 NioXBDfbx2Kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130720427"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="130720427"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:52 -0700
IronPort-SDR: XhTxn8LxVX3et9Fz8wd7atIDcnQzgkrRF6dFLg6gPp7EGqRXO/gQhR11pRXXqlmwz80WRe1y7q
 DNlR54B2hNPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394233039"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:51 -0700
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
Subject: [RFC v9 19/25] intel_iommu: replay pasid binds after context cache invalidation
Date:   Mon, 27 Jul 2020 23:34:12 -0700
Message-Id: <1595918058-33392-20-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch replays guest pasid bindings after context cache
invalidation. This is a behavior to ensure safety. Actually,
programmer should issue pasid cache invalidation with proper
granularity after issuing a context cache invalidation.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 50 ++++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  1 +
 hw/i386/trace-events           |  1 +
 3 files changed, 52 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3986e5f..efad0af 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -68,6 +68,10 @@ static void vtd_address_space_refresh_all(IntelIOMMUState *s);
 static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
 
 static void vtd_pasid_cache_reset(IntelIOMMUState *s);
+static void vtd_pasid_cache_sync(IntelIOMMUState *s,
+                                 VTDPASIDCacheInfo *pc_info);
+static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
+                                  VTDBus *vtd_bus, uint16_t devfn);
 
 static void vtd_panic_require_caching_mode(void)
 {
@@ -1853,7 +1857,10 @@ static void vtd_iommu_replay_all(IntelIOMMUState *s)
 
 static void vtd_context_global_invalidate(IntelIOMMUState *s)
 {
+    VTDPASIDCacheInfo pc_info;
+
     trace_vtd_inv_desc_cc_global();
+
     /* Protects context cache */
     vtd_iommu_lock(s);
     s->context_cache_gen++;
@@ -1870,6 +1877,9 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
      * VT-d emulation codes.
      */
     vtd_iommu_replay_all(s);
+
+    pc_info.type = VTD_PASID_CACHE_GLOBAL_INV;
+    vtd_pasid_cache_sync(s, &pc_info);
 }
 
 /**
@@ -2008,6 +2018,21 @@ static void vtd_context_device_invalidate(IntelIOMMUState *s,
                  * happened.
                  */
                 vtd_sync_shadow_page_table(vtd_as);
+                /*
+                 * Per spec, context flush should also followed with PASID
+                 * cache and iotlb flush. Regards to a device selective
+                 * context cache invalidation:
+                 * if (emaulted_device)
+                 *    invalidate pasid cahce and pasid-based iotlb
+                 * else if (assigned_device)
+                 *    check if the device has been bound to any pasid
+                 *    invoke pasid_unbind regards to each bound pasid
+                 * Here, we have vtd_pasid_cache_devsi() to invalidate pasid
+                 * caches, while for piotlb in QEMU, we don't have it yet, so
+                 * no handling. For assigned device, host iommu driver would
+                 * flush piotlb when a pasid unbind is pass down to it.
+                 */
+                 vtd_pasid_cache_devsi(s, vtd_bus, devfn_it);
             }
         }
     }
@@ -2622,6 +2647,12 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
         /* Fall through */
     case VTD_PASID_CACHE_GLOBAL_INV:
         break;
+    case VTD_PASID_CACHE_DEVSI:
+        if (pc_info->vtd_bus != vtd_bus ||
+            pc_info->devfn != devfn) {
+            return false;
+        }
+        break;
     default:
         error_report("invalid pc_info->type");
         abort();
@@ -2821,6 +2852,11 @@ static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
     case VTD_PASID_CACHE_GLOBAL_INV:
         /* loop all assigned devices */
         break;
+    case VTD_PASID_CACHE_DEVSI:
+        walk_info.vtd_bus = pc_info->vtd_bus;
+        walk_info.devfn = pc_info->devfn;
+        vtd_replay_pasid_bind_for_dev(s, start, end, &walk_info);
+        return;
     case VTD_PASID_CACHE_FORCE_RESET:
         /* For force reset, no need to go further replay */
         return;
@@ -2906,6 +2942,20 @@ static void vtd_pasid_cache_sync(IntelIOMMUState *s,
     vtd_iommu_unlock(s);
 }
 
+static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
+                                  VTDBus *vtd_bus, uint16_t devfn)
+{
+    VTDPASIDCacheInfo pc_info;
+
+    trace_vtd_pasid_cache_devsi(devfn);
+
+    pc_info.type = VTD_PASID_CACHE_DEVSI;
+    pc_info.vtd_bus = vtd_bus;
+    pc_info.devfn = devfn;
+
+    vtd_pasid_cache_sync(s, &pc_info);
+}
+
 /**
  * Caller of this function should hold iommu_lock
  */
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 51691d0..9805b84 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -548,6 +548,7 @@ typedef enum VTDPCInvType {
     VTD_PASID_CACHE_FORCE_RESET = 0,
     /* pasid cache invalidation rely on guest PASID entry */
     VTD_PASID_CACHE_GLOBAL_INV,
+    VTD_PASID_CACHE_DEVSI,
     VTD_PASID_CACHE_DOMSI,
     VTD_PASID_CACHE_PASIDSI,
 } VTDPCInvType;
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index 60d20c1..3853fa8 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -26,6 +26,7 @@ vtd_pasid_cache_gsi(void) ""
 vtd_pasid_cache_reset(void) ""
 vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
 vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
+vtd_pasid_cache_devsi(uint16_t devfn) "Dev selective PC invalidation dev: 0x%"PRIx16
 vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
 vtd_ce_not_present(uint8_t bus, uint8_t devfn) "Context entry bus %"PRIu8" devfn %"PRIu8" not present"
 vtd_iotlb_page_hit(uint16_t sid, uint64_t addr, uint64_t slpte, uint16_t domain) "IOTLB page hit sid 0x%"PRIx16" iova 0x%"PRIx64" slpte 0x%"PRIx64" domain 0x%"PRIx16
-- 
2.7.4

