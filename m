Return-Path: <kvm+bounces-47103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3D4ABD4E8
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 752B71BA336E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070E326F465;
	Tue, 20 May 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIU1iz7u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6926E272E4C
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736954; cv=none; b=Kr1lM7q1RYTEQ/2T6Zz3aOrERPfMAbG52jwHKodN/ZE7eTBp4BGZUx/B0cfCLxyhDvSXVDNIO/tgcMutKYd7fojYiNDeOLTVl63CXJP+JB9sGpLNJmQeo1AJsEgBrGVwGaGLq180lJZtn4t7oQtD9PC6P056ntqLMzWfIY1Bzms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736954; c=relaxed/simple;
	bh=R5LFT5AsG3wsPZY3KRrUkPR61WLL1e67GZCvt4H8Tkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHaqbNbhKu3mujs/OC+Koirv72H04khoCIhy4p9b6pHCULPnlO+gEoHg8W5XarLxmbcmyutx1R2IrRWXjuOV9eUGugjTz4UROgykty7Myc26QjOspIhMHurVU/G2s3dv2soS3pzRdCaoCq+WrD936J0WHWssBILzTzawnqBmDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIU1iz7u; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736952; x=1779272952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5LFT5AsG3wsPZY3KRrUkPR61WLL1e67GZCvt4H8Tkk=;
  b=YIU1iz7uTooOZ3Ou9dU/sKL0s2RZAcW9YeNpF7aFYFltf87OZAXyEdw4
   WXqHBM1JFKrgNSatvfpou8FMFR46eBXThen/MlRiFnuU0S4k2YW5chBCI
   mEy0rbnCi/zoUbdcDG0W8bHjju/2+sG/T3yOvTaF7ZvZczeM4+F46m8zv
   EcyuiM7eoiDo2tTsJIL4EAVE5DG4MJmveCEgyNXlBYkcFvTOw9bBXqaJa
   EV0ByS33JXNvBaoWlFy1trmy6HeHYInoArgQ1KjlxZE4FcRDtI+SAE7qy
   luXc+m83NtZUb7TqPZdNTThdqiLKrM/aW3uthS2rDdC4nmOE52RqzsUWa
   g==;
X-CSE-ConnectionGUID: x0ztkztsTW6L+6UTkGEWNQ==
X-CSE-MsgGUID: kb6l9vcJTw+i0Lb1mxsOYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566637"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566637"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:12 -0700
X-CSE-ConnectionGUID: K0NXmz3yQGqZNd/LaV/iJA==
X-CSE-MsgGUID: YnzgoaVORCePeeTjE9lLsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905230"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:07 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 02/10] memory: Change memory_region_set_ram_discard_manager() to return the result
Date: Tue, 20 May 2025 18:28:42 +0800
Message-ID: <20250520102856.132417-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
RamDiscardManager is already set in the MemoryRegion. The caller must
handle this failure, such as having virtio-mem undo its actions and fail
the realize() process. Opportunistically move the call earlier to avoid
complex error handling.

This change is beneficial when introducing a new RamDiscardManager
instance besides virtio-mem. After
ram_block_coordinated_discard_require(true) unlocks all
RamDiscardManager instances, only one instance is allowed to be set for
one MemoryRegion at present.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v5:
    - Nit in commit message (return false -> -EBUSY)
    - Add set_ram_discard_manager(NULL) when ram_block_discard_range()
      fails.

Changes in v4:
    - No change.

Changes in v3:
    - Move set_ram_discard_manager() up to avoid a g_free()
    - Clean up set_ram_discard_manager() definition

Changes in v2:
    - newly added.
---
 hw/virtio/virtio-mem.c  | 30 +++++++++++++++++-------------
 include/system/memory.h |  6 +++---
 system/memory.c         | 10 +++++++---
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index b3c126ea1e..2e491e8c44 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1047,6 +1047,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    /*
+     * Set ourselves as RamDiscardManager before the plug handler maps the
+     * memory region and exposes it via an address space.
+     */
+    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
+                                              RAM_DISCARD_MANAGER(vmem))) {
+        error_setg(errp, "Failed to set RamDiscardManager");
+        ram_block_coordinated_discard_require(false);
+        return;
+    }
+
     /*
      * We don't know at this point whether shared RAM is migrated using
      * QEMU or migrated using the file content. "x-ignore-shared" will be
@@ -1061,6 +1072,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
         if (ret) {
             error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
+            memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
             ram_block_coordinated_discard_require(false);
             return;
         }
@@ -1122,13 +1134,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
     vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
     vmem->system_reset->vmem = vmem;
     qemu_register_resettable(obj);
-
-    /*
-     * Set ourselves as RamDiscardManager before the plug handler maps the
-     * memory region and exposes it via an address space.
-     */
-    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
-                                          RAM_DISCARD_MANAGER(vmem));
 }
 
 static void virtio_mem_device_unrealize(DeviceState *dev)
@@ -1136,12 +1141,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VirtIOMEM *vmem = VIRTIO_MEM(dev);
 
-    /*
-     * The unplug handler unmapped the memory region, it cannot be
-     * found via an address space anymore. Unset ourselves.
-     */
-    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
-
     qemu_unregister_resettable(OBJECT(vmem->system_reset));
     object_unref(OBJECT(vmem->system_reset));
 
@@ -1154,6 +1153,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
     g_free(vmem->bitmap);
+    /*
+     * The unplug handler unmapped the memory region, it cannot be
+     * found via an address space anymore. Unset ourselves.
+     */
+    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     ram_block_coordinated_discard_require(false);
 }
 
diff --git a/include/system/memory.h b/include/system/memory.h
index b961c4076a..896948deb1 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -2499,13 +2499,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
  *
  * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
  * that does not cover RAM, or a #MemoryRegion that already has a
- * #RamDiscardManager assigned.
+ * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
  *
  * @mr: the #MemoryRegion
  * @rdm: #RamDiscardManager to set
  */
-void memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                           RamDiscardManager *rdm);
+int memory_region_set_ram_discard_manager(MemoryRegion *mr,
+                                          RamDiscardManager *rdm);
 
 /**
  * memory_region_find: translate an address/size relative to a
diff --git a/system/memory.c b/system/memory.c
index 63b983efcd..b45b508dce 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2106,12 +2106,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
     return mr->rdm;
 }
 
-void memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                           RamDiscardManager *rdm)
+int memory_region_set_ram_discard_manager(MemoryRegion *mr,
+                                          RamDiscardManager *rdm)
 {
     g_assert(memory_region_is_ram(mr));
-    g_assert(!rdm || !mr->rdm);
+    if (mr->rdm && rdm) {
+        return -EBUSY;
+    }
+
     mr->rdm = rdm;
+    return 0;
 }
 
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-- 
2.43.5


