Return-Path: <kvm+bounces-40601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30465A58DEC
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CED4168A91
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF431DE4FA;
	Mon, 10 Mar 2025 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjzecmOu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA62236E1
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594824; cv=none; b=H9TyFV6tTM0IHFay5L/Kah+mmiu9S/LkKILtosY+SYec3Hw5M+5FdmplSd+30CK3tfpQkENB5ZnFPJq4Y5aU/meZ7cH5JlqV+xYvfKmYaf2ZLr/yS3T6VRWJzFcwKioWb9OjuLPzwnsewZZT+K7ltoO7vz11d2lmyJqWJDSULwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594824; c=relaxed/simple;
	bh=SdF5xZxwT1B/fJL7eNhWt5x8go9X0aH01ikKl69PbXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me9zA2PMy7uY+afxnFgwqGfWJ5O2aMhN3CQ0x5MnR838B3wkWP1eTvABykVr8Op5Gx7gQ9WZdGorZ36Z6utDh3S0y3rPHbxqtivITR3Vi/K0Cn8OMVweVedIH3VIJ1LqEgu78Ei1BtkSngOuuZIQy0zk5CGFmmb2T2z368spBT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AjzecmOu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741594823; x=1773130823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdF5xZxwT1B/fJL7eNhWt5x8go9X0aH01ikKl69PbXM=;
  b=AjzecmOuizNeTUYVfxUx55si20EomBt4n42ODJlvvfqCE/4nt0UGPUd/
   KZCT3ZyLz14b7GCW33hv6pO3WRHcYnW7HWeELhuzsAJRFyNodrm8j/Qkj
   S/pEGfUhEYSVXs+qEBst+M/agEq7Kh+LpjH2D4fOeFJ9LVGPVuK5SVLe9
   K8/Y37PELbAEvcG21GBLNpMvsJ7BjB8k7d/4m58/MxLlWEIrRUR1T+JSN
   KQU86FESsNcQUqeCLUGCmCG36gqKX0nlUA+VuH0y5On5EgBT94SoKRtFe
   k+wKN7V9GzpLD2RYQUtBASadXU0xxXYXXwc1OQcY4VIY7tXr8edl5I01a
   w==;
X-CSE-ConnectionGUID: Se6ECu6XSA6rhgolI7B5hw==
X-CSE-MsgGUID: hjvcZP9TSRGe8Wm617IpCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42688456"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42688456"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:23 -0700
X-CSE-ConnectionGUID: X70SiXx8S1iJooE6XqbCkw==
X-CSE-MsgGUID: DSf7WM4yQ4qv41AiUP25eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150862796"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:20 -0700
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
Subject: [PATCH v3 2/7] memory: Change memory_region_set_ram_discard_manager() to return the result
Date: Mon, 10 Mar 2025 16:18:30 +0800
Message-ID: <20250310081837.13123-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250310081837.13123-1-chenyi.qiang@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
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
Changes in v3:
    - Move set_ram_discard_manager() up to avoid a g_free()
    - Clean up set_ram_discard_manager() definition

Changes in v2:
    - newly added.
---
 hw/virtio/virtio-mem.c | 29 ++++++++++++++++-------------
 include/exec/memory.h  |  6 +++---
 system/memory.c        | 10 +++++++---
 3 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 21f16e4912..d0d3a0240f 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1049,6 +1049,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
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
@@ -1124,13 +1135,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
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
@@ -1138,12 +1142,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
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
 
@@ -1156,6 +1154,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
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
index b17b5538ff..62d6b410f0 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2115,12 +2115,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
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


