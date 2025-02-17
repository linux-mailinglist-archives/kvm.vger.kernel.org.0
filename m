Return-Path: <kvm+bounces-38333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D540A37CF4
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64AE1718EE
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCE31A2381;
	Mon, 17 Feb 2025 08:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ncWC0xak"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072EB1A0731
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780336; cv=none; b=D81efQU3/Vryxkd/L/wwSMOuvEHMPQjGI/igwjI+v+blotPHlQA6D3kal+p8oysD+WyAAYYu+BrH/lIy2HfhwKn05x437mUqjC05uZYu9cTh+kDUNicPOEIEUWlOMfmBDHteeVLs7303WB20Lv+VkAoV0o2UhEQIOP9UTzi+gUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780336; c=relaxed/simple;
	bh=aCF+b4RwfnVnsui1hr69IimEOU4HkOAhxYc97Sd88Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyR64zqijjmW9pD/ZTNHrCsNJk8jOoVSCXUrxQXPmMEFEMdiQPV9mCI/3atPc2v3LcZSl58io30R3G72OsNP8fZb4Az8dZV81VDgVduLGOC0UjjR5HqYXp0JKJMyIET7tjtd002R2RH67fJJzuSsyT/KU1aGWvDpAj7GhL8/ZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ncWC0xak; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780335; x=1771316335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aCF+b4RwfnVnsui1hr69IimEOU4HkOAhxYc97Sd88Us=;
  b=ncWC0xakXRS1JMre0c16JiI5FpZKg6wSN/WnlJiaeKYNbF5djvrqO8Xz
   lb52mc5QtH2hA9wCzYqTabzlHPHEU2RSGvWYGlcZWmdPcKUjsxtckrtC2
   8qtw71RxecatqbRm9T9T6Kb82+OJxwBUMufsHtcXYFH1FKrnrDPyPENNo
   FIImYk15Fjvrkl00yAIa3L0YuW8oySm2SGHXMRw3FfWTeYdiGN+1zYfjV
   3OBklvdCTYuaTLg9oGw6zbFtrvvkHFPpacksUnnQTQrCUkT+8bVZLVgbm
   kds116TZEKQBq71ktAA6seF277C1y1MAjz8NxMykk4dv9425YF2xfnKGq
   g==;
X-CSE-ConnectionGUID: 6UHqtjCiQ0+NLJuXjLdwVA==
X-CSE-MsgGUID: IBauHFGMRiGk3cIefuLiNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50668973"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50668973"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:54 -0800
X-CSE-ConnectionGUID: bJsn2YPTQ6OurDEqgpOlMw==
X-CSE-MsgGUID: DYuhebGISKS+FiChk3Xkeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690184"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:52 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v2 2/6] memory: Change memory_region_set_ram_discard_manager() to return the result
Date: Mon, 17 Feb 2025 16:18:21 +0800
Message-ID: <20250217081833.21568-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217081833.21568-1-chenyi.qiang@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify memory_region_set_ram_discard_manager() to return false if a
RamDiscardManager is already set in the MemoryRegion. The caller must
handle this failure, such as having virtio-mem undo its actions and fail
the realize() process. Opportunistically move the call earlier to avoid
complex error handling.

This change is beneficial when introducing a new RamDiscardManager
instance besides virtio-mem. After
ram_block_coordinated_discard_require(true) unlocks all
RamDiscardManager instances, only one instance is allowed to be set for
a MemoryRegion at present.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v2:
    - newly added.
---
 hw/virtio/virtio-mem.c | 30 +++++++++++++++++-------------
 include/exec/memory.h  |  6 +++---
 system/memory.c        | 11 ++++++++---
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 21f16e4912..ef818a2cdf 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1074,6 +1074,18 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
                         vmem->block_size;
     vmem->bitmap = bitmap_new(vmem->bitmap_size);
 
+    /*
+     * Set ourselves as RamDiscardManager before the plug handler maps the
+     * memory region and exposes it via an address space.
+     */
+    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
+                                              RAM_DISCARD_MANAGER(vmem))) {
+        error_setg(errp, "Failed to set RamDiscardManager");
+        g_free(vmem->bitmap);
+        ram_block_coordinated_discard_require(false);
+        return;
+    }
+
     virtio_init(vdev, VIRTIO_ID_MEM, sizeof(struct virtio_mem_config));
     vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
 
@@ -1124,13 +1136,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
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
@@ -1138,12 +1143,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
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
 
@@ -1155,6 +1154,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     host_memory_backend_set_mapped(vmem->memdev, false);
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
+    /*
+     * The unplug handler unmapped the memory region, it cannot be
+     * found via an address space anymore. Unset ourselves.
+     */
+    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     g_free(vmem->bitmap);
     ram_block_coordinated_discard_require(false);
 }
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 3bebc43d59..390477b588 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2487,13 +2487,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
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
index b17b5538ff..297a3dbcd4 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2115,12 +2115,17 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
     return mr->rdm;
 }
 
-void memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                           RamDiscardManager *rdm)
+int memory_region_set_ram_discard_manager(MemoryRegion *mr,
+                                          RamDiscardManager *rdm)
 {
     g_assert(memory_region_is_ram(mr));
-    g_assert(!rdm || !mr->rdm);
+    if (mr->rdm && rdm != NULL) {
+        return -1;
+    }
+
+    /* !rdm || !mr->rdm */
     mr->rdm = rdm;
+    return 0;
 }
 
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-- 
2.43.5


