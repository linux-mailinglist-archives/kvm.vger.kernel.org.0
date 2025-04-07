Return-Path: <kvm+bounces-42804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FB4A7D6E9
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36F8E3B9D96
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A5822756A;
	Mon,  7 Apr 2025 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfBKDCmJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B3E225A38
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012208; cv=none; b=rwq9bl6s1ZZi92uqiLxnLM4atwKbaquuWFLvkH+G9S34c1b0KSGDhsh3f8Nab8uY4gIL8BrpHrLSz6Vm2DnLowrXQWL804GWVebwuA3YZ+nmQ2r1fwRMScarcwCQyEp5HU75B5z2kfcy6Fakxi8ac3wsZj7kjZ9//7zAzgM2O+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012208; c=relaxed/simple;
	bh=4/NxRHGIa82bpN+zenGnUIFub5qv8ngu3vJ4kD8YLHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuntGgHdMWUOy3+wX/z0tsuDTAXGPgoEIuEPRMRK3kc3pa+aDBpeWzLjpGjzM0BrdnWlZxOU2aqJOW7LHCbX0mRl8XqdEcdxCW11gp7/XICa+5ogQ5D5ZlWX1ur9aOnGiPYUoT81WrpRzP2mBX2YQwwoU85kU5tQY05/adeCh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfBKDCmJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012207; x=1775548207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4/NxRHGIa82bpN+zenGnUIFub5qv8ngu3vJ4kD8YLHE=;
  b=IfBKDCmJQL25GVMZY0y37N3IU5Eu9JdR2PTotuuUaNBtA+wFvErQLS3b
   nl6s/UUZvuLOtxeqODfvcN4WR6aaba8lKIBfC+qInfoPluu+R0ZsIFz+d
   jY+Td5KFQAWWQX/CA2QYLeuwTGdqtu4hfCpVN4qxXR32Wej5kQWmhy5Ap
   ycV3qUtfWM03tNiHCfUWWONh5la0uKrLrBrYZtVVFwqMCGGeKZW69D7/H
   gjwNPW7XL4COlWAJrDi4zxWiK5+h+VH6rgQFpaxdkkXn15bz6AW/8Mf0C
   WfEP7ppK7r5F2tIKswDCegvXYP4OoAa+YmNWYVwnYlgDUZed8sbV0UvRS
   g==;
X-CSE-ConnectionGUID: ywY6/oaJRDWFCaQz5Zrzjw==
X-CSE-MsgGUID: n/rH48m8ReqrjQ1ZrFgC3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857543"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857543"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:07 -0700
X-CSE-ConnectionGUID: yBqCn659QIiBIBvFTDzYEQ==
X-CSE-MsgGUID: dQEPRNaGTPGDAItE1bRttw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405591"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:03 -0700
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
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface as child of GenericStateManager
Date: Mon,  7 Apr 2025 15:49:25 +0800
Message-ID: <20250407074939.18657-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To manage the private and shared RAM states in confidential VMs,
introduce a new class of PrivateShareManager as a child of
GenericStateManager, which inherits the six interface callbacks. With a
different interface type, it can be distinguished from the
RamDiscardManager object and provide the flexibility for addressing
specific requirements of confidential VMs in the future.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Newly added.
---
 include/exec/memory.h | 44 +++++++++++++++++++++++++++++++++++++++++--
 system/memory.c       | 17 +++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 30e5838d02..08f25e5e84 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -55,6 +55,12 @@ typedef struct RamDiscardManager RamDiscardManager;
 DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
                      RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
 
+#define TYPE_PRIVATE_SHARED_MANAGER "private-shared-manager"
+typedef struct PrivateSharedManagerClass PrivateSharedManagerClass;
+typedef struct PrivateSharedManager PrivateSharedManager;
+DECLARE_OBJ_CHECKERS(PrivateSharedManager, PrivateSharedManagerClass,
+                     PRIVATE_SHARED_MANAGER, TYPE_PRIVATE_SHARED_MANAGER)
+
 #ifdef CONFIG_FUZZ
 void fuzz_dma_read_cb(size_t addr,
                       size_t len,
@@ -692,6 +698,14 @@ void generic_state_manager_register_listener(GenericStateManager *gsm,
 void generic_state_manager_unregister_listener(GenericStateManager *gsm,
                                                StateChangeListener *scl);
 
+static inline void state_change_listener_init(StateChangeListener *scl,
+                                              NotifyStateSet state_set_fn,
+                                              NotifyStateClear state_clear_fn)
+{
+    scl->notify_to_state_set = state_set_fn;
+    scl->notify_to_state_clear = state_clear_fn;
+}
+
 typedef struct RamDiscardListener RamDiscardListener;
 
 struct RamDiscardListener {
@@ -713,8 +727,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
                                              NotifyStateClear discard_fn,
                                              bool double_discard_supported)
 {
-    rdl->scl.notify_to_state_set = populate_fn;
-    rdl->scl.notify_to_state_clear = discard_fn;
+    state_change_listener_init(&rdl->scl, populate_fn, discard_fn);
     rdl->double_discard_supported = double_discard_supported;
 }
 
@@ -757,6 +770,25 @@ struct RamDiscardManagerClass {
     GenericStateManagerClass parent_class;
 };
 
+typedef struct PrivateSharedListener PrivateSharedListener;
+struct PrivateSharedListener {
+    struct StateChangeListener scl;
+
+    QLIST_ENTRY(PrivateSharedListener) next;
+};
+
+struct PrivateSharedManagerClass {
+    /* private */
+    GenericStateManagerClass parent_class;
+};
+
+static inline void private_shared_listener_init(PrivateSharedListener *psl,
+                                                NotifyStateSet populate_fn,
+                                                NotifyStateClear discard_fn)
+{
+    state_change_listener_init(&psl->scl, populate_fn, discard_fn);
+}
+
 /**
  * memory_get_xlat_addr: Extract addresses from a TLB entry
  *
@@ -2521,6 +2553,14 @@ int memory_region_set_generic_state_manager(MemoryRegion *mr,
  */
 bool memory_region_has_ram_discard_manager(MemoryRegion *mr);
 
+/**
+ * memory_region_has_private_shared_manager: check whether a #MemoryRegion has a
+ * #PrivateSharedManager assigned
+ *
+ * @mr: the #MemoryRegion
+ */
+bool memory_region_has_private_shared_manager(MemoryRegion *mr);
+
 /**
  * memory_region_find: translate an address/size relative to a
  * MemoryRegion into a #MemoryRegionSection.
diff --git a/system/memory.c b/system/memory.c
index 7b921c66a6..e6e944d9c0 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2137,6 +2137,16 @@ bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
     return true;
 }
 
+bool memory_region_has_private_shared_manager(MemoryRegion *mr)
+{
+    if (!memory_region_is_ram(mr) ||
+        !object_dynamic_cast(OBJECT(mr->gsm), TYPE_PRIVATE_SHARED_MANAGER)) {
+        return false;
+    }
+
+    return true;
+}
+
 uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
                                                    const MemoryRegion *mr)
 {
@@ -3837,12 +3847,19 @@ static const TypeInfo ram_discard_manager_info = {
     .class_size         = sizeof(RamDiscardManagerClass),
 };
 
+static const TypeInfo private_shared_manager_info = {
+    .parent             = TYPE_GENERIC_STATE_MANAGER,
+    .name               = TYPE_PRIVATE_SHARED_MANAGER,
+    .class_size         = sizeof(PrivateSharedManagerClass),
+};
+
 static void memory_register_types(void)
 {
     type_register_static(&memory_region_info);
     type_register_static(&iommu_memory_region_info);
     type_register_static(&generic_state_manager_info);
     type_register_static(&ram_discard_manager_info);
+    type_register_static(&private_shared_manager_info);
 }
 
 type_init(memory_register_types)
-- 
2.43.5


