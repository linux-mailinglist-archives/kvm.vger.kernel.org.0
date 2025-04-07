Return-Path: <kvm+bounces-42811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA571A7D6D1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E3AC16E94A
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D365227EA7;
	Mon,  7 Apr 2025 07:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNcMIuzd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8309A227E9B
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012235; cv=none; b=aZ19LCY7KtU+8Xb2J4P6Ke+MfwsKs99S3rkQQ5bLHunW0oIx5fbG850QF6lGgPxF3u9DqOtu4pRn+OF4MVFWQriRnFchIbB1YuLPZG2A4PZwApdHVFuJ+RsJhUD2R5bsEwy6jdyYflXaIG5oGSP9yXt1O3pcPmYit503Qx+XeBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012235; c=relaxed/simple;
	bh=NXIbQZGPX/IetC+2ATda7+FulTolZHjLHw2CKq3GgXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOzWUrzy8a63HCjcvFAfXhEDkZibG2hFIsncuD/9OwLXfgXJOOQfLHDmeeOcnMPBomwrmccu234ZLH6T6CjT5Z4F/Depl2APEo1pegEnvXzf1zWQneLq99nLGMLqWpBpXi84pMPS+SsiHO/xVKE8TUzAYL5AmnVVrN7zAYTtIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNcMIuzd; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012234; x=1775548234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NXIbQZGPX/IetC+2ATda7+FulTolZHjLHw2CKq3GgXI=;
  b=BNcMIuzd+yRJxjeLkEjz/vO0Rn+N9wtxdDw3N/z2YXaD1PviepbgRrL0
   S1FEoz+hW3UXxU7IPAEKawAmISGf4iBrzI9FNgD+KW9jwduzvZeoAyKhf
   Z4C3DV9bYY2xNNdoj3Cf5w/+7BS3TG1WLaRobLcBKfoZNFPS8LuzntnOD
   H5stAF0qLzWbSlHLcJB5aqIGnMSWyfSg5JPtG9o+mWHMjeI6kkOJKlQnA
   E6MiibRX/W7s+vuzzm8c9/Nn6rl1tWn/pJAiGd9CJlZDDWVF2+9HMItVD
   y1ON2FuxYhTz3lIFIloxJWuiW3X5zPReHUMpWxyGhcnwhofWpZDqQrXsZ
   w==;
X-CSE-ConnectionGUID: qPYgPExpQ9WxO9SkqCnxYQ==
X-CSE-MsgGUID: Ca8H9lCZS4uL/5Ig5te6fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857610"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857610"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:34 -0700
X-CSE-ConnectionGUID: 7njJYSf+TOOQowEGtCZrXg==
X-CSE-MsgGUID: Hvft6m07QiGM8/baoKcQdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405702"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:30 -0700
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
Subject: [PATCH v4 12/13] ram-block-attribute: Add priority listener support for PrivateSharedListener
Date: Mon,  7 Apr 2025 15:49:32 +0800
Message-ID: <20250407074939.18657-13-chenyi.qiang@intel.com>
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

In-place page conversion requires operations to follow a specific
sequence: unmap-before-conversion-to-private and
map-after-conversion-to-shared. Currently, both attribute changes and
VFIO DMA map/unmap operations are handled by PrivateSharedListeners,
they need to be invoked in a specific order.

For private to shared conversion:
- Change attribute to shared.
- VFIO populates the shared mappings into the IOMMU.
- Restore attribute if the operation fails.

For shared to private conversion:
- VFIO discards shared mapping from the IOMMU.
- Change attribute to private.

To faciliate this sequence, priority support is added to
PrivateSharedListener so that listeners are stored in a determined
order based on priority. A tail queue is used to store listeners,
allowing traversal in either direction.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Newly added.
---
 accel/kvm/kvm-all.c          |  3 ++-
 hw/vfio/common.c             |  3 ++-
 include/exec/memory.h        | 19 +++++++++++++++++--
 include/exec/ramblock.h      |  2 +-
 system/ram-block-attribute.c | 23 +++++++++++++++++------
 5 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index aec64d559b..879c61b391 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1745,7 +1745,8 @@ static void kvm_region_add(MemoryListener *listener,
     psl = &cpsl->listener;
     QLIST_INSERT_HEAD(&cgs->cvm_private_shared_list, cpsl, next);
     private_shared_listener_init(psl, kvm_private_shared_notify_to_shared,
-                                 kvm_private_shared_notify_to_private);
+                                 kvm_private_shared_notify_to_private,
+                                 PRIVATE_SHARED_LISTENER_PRIORITY_MIN);
     generic_state_manager_register_listener(gsm, &psl->scl, section);
 }
 
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 6e49ae597d..a8aacae26c 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -515,7 +515,8 @@ static void vfio_register_private_shared_listener(VFIOContainerBase *bcontainer,
 
     psl = &vpsl->listener;
     private_shared_listener_init(psl, vfio_private_shared_notify_to_shared,
-                                 vfio_private_shared_notify_to_private);
+                                 vfio_private_shared_notify_to_private,
+                                 PRIVATE_SHARED_LISTENER_PRIORITY_COMMON);
     generic_state_manager_register_listener(gsm, &psl->scl, section);
     QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
 }
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 9472d9e9b4..3d06cc04a0 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -770,11 +770,24 @@ struct RamDiscardManagerClass {
     GenericStateManagerClass parent_class;
 };
 
+#define PRIVATE_SHARED_LISTENER_PRIORITY_MIN       0
+#define PRIVATE_SHARED_LISTENER_PRIORITY_COMMON    10
+
 typedef struct PrivateSharedListener PrivateSharedListener;
 struct PrivateSharedListener {
     struct StateChangeListener scl;
 
-    QLIST_ENTRY(PrivateSharedListener) next;
+    /*
+     * @priority:
+     *
+     * Govern the order in which ram discard listeners are invoked. Lower priorities
+     * are invoked earlier.
+     * The listener priority can help to undo the effects of previous listeners in
+     * a reverse order in case of a failure callback.
+     */
+    int priority;
+
+    QTAILQ_ENTRY(PrivateSharedListener) next;
 };
 
 struct PrivateSharedManagerClass {
@@ -787,9 +800,11 @@ struct PrivateSharedManagerClass {
 
 static inline void private_shared_listener_init(PrivateSharedListener *psl,
                                                 NotifyStateSet populate_fn,
-                                                NotifyStateClear discard_fn)
+                                                NotifyStateClear discard_fn,
+                                                int priority)
 {
     state_change_listener_init(&psl->scl, populate_fn, discard_fn);
+    psl->priority = priority;
 }
 
 int private_shared_manager_state_change(PrivateSharedManager *mgr,
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 78eb031819..7a3dd709bb 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -105,7 +105,7 @@ struct RamBlockAttribute {
     unsigned shared_bitmap_size;
     unsigned long *shared_bitmap;
 
-    QLIST_HEAD(, PrivateSharedListener) psl_list;
+    QTAILQ_HEAD(, PrivateSharedListener) psl_list;
 };
 
 struct RamBlockAttributeClass {
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 15c9aebd09..fd041148c7 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -158,12 +158,23 @@ static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
 {
     RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
     PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
+    PrivateSharedListener *other = NULL;
     int ret;
 
     g_assert(section->mr == attr->mr);
     scl->section = memory_region_section_new_copy(section);
 
-    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
+    if (QTAILQ_EMPTY(&attr->psl_list) ||
+        psl->priority >= QTAILQ_LAST(&attr->psl_list)->priority) {
+        QTAILQ_INSERT_TAIL(&attr->psl_list, psl, next);
+    } else {
+        QTAILQ_FOREACH(other, &attr->psl_list, next) {
+            if (psl->priority < other->priority) {
+                break;
+            }
+        }
+        QTAILQ_INSERT_BEFORE(other, psl, next);
+    }
 
     ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
                                                       ram_block_attribute_notify_shared_cb);
@@ -192,7 +203,7 @@ static void ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm
 
     memory_region_section_free_copy(scl->section);
     scl->section = NULL;
-    QLIST_REMOVE(psl, next);
+    QTAILQ_REMOVE(&attr->psl_list, psl, next);
 }
 
 typedef struct RamBlockAttributeReplayData {
@@ -261,7 +272,7 @@ static void ram_block_attribute_notify_to_private(RamBlockAttribute *attr,
     PrivateSharedListener *psl;
     int ret;
 
-    QLIST_FOREACH(psl, &attr->psl_list, next) {
+    QTAILQ_FOREACH_REVERSE(psl, &attr->psl_list, next) {
         StateChangeListener *scl = &psl->scl;
         MemoryRegionSection tmp = *scl->section;
 
@@ -283,7 +294,7 @@ static int ram_block_attribute_notify_to_shared(RamBlockAttribute *attr,
     PrivateSharedListener *psl, *psl2;
     int ret = 0, ret2 = 0;
 
-    QLIST_FOREACH(psl, &attr->psl_list, next) {
+    QTAILQ_FOREACH(psl, &attr->psl_list, next) {
         StateChangeListener *scl = &psl->scl;
         MemoryRegionSection tmp = *scl->section;
 
@@ -298,7 +309,7 @@ static int ram_block_attribute_notify_to_shared(RamBlockAttribute *attr,
 
     if (ret) {
         /* Notify all already-notified listeners. */
-        QLIST_FOREACH(psl2, &attr->psl_list, next) {
+        QTAILQ_FOREACH(psl2, &attr->psl_list, next) {
             StateChangeListener *scl2 = &psl2->scl;
             MemoryRegionSection tmp = *scl2->section;
 
@@ -462,7 +473,7 @@ static void ram_block_attribute_init(Object *obj)
 {
     RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(obj);
 
-    QLIST_INIT(&attr->psl_list);
+    QTAILQ_INIT(&attr->psl_list);
 }
 
 static void ram_block_attribute_finalize(Object *obj)
-- 
2.43.5


