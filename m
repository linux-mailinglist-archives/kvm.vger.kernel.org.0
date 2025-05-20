Return-Path: <kvm+bounces-47110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08622ABD4FD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D5DE3A5C2B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927B526D4EB;
	Tue, 20 May 2025 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3yp81sZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAD125524F
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736978; cv=none; b=A44aQpo+yyjwmQKyo1HN1nb/+Qy7SXTe/Lb/+jIIUP7Te79KfhWCWvqqSk5GaFL7u1ndC/O2Z3CfMoxGEc6PWRuFwoxNsvcpYZrDzO80wWL6GdoQZy5B+q9T4XDG3M/vS4cvg2qCaiefRM7ZMzqiwFPUw6bhyPbIYW/zRYyA5HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736978; c=relaxed/simple;
	bh=c1N/BnhvtWYzXYP3VrcMDboLZ9zphs865jcPHhFi2sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp+OnZnYLaBD9+IqiKzrMh4kJmMYbrJqyg+tQ+KbxO85Duo5TESf4FKD0GshFwzsAVxSuhg9kwlCRKJteOfeA0reGjoTtKIu62ILwOC+XnXk4CG7z+ivtmiY0/LkYKN3N7F0UjYc6oy0GzG6FvvLklJn0mDy5KJe+vzZDV5iJ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3yp81sZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736978; x=1779272978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c1N/BnhvtWYzXYP3VrcMDboLZ9zphs865jcPHhFi2sw=;
  b=j3yp81sZtCNrJPpnxhOXMV4cm9zzvitcYB4a4h7fSMjC2ywXJmWwtQcK
   DfOJsMgO2dxrTs+Oisdtco3VfyXSn5SJcZpfFAkFoyg3/7PVMau2vfXiR
   v/Z3HaT1vuJKZC5JMFtqugHlmiWYJEtc8MhnXxWIHG6ie118VxxKKab/X
   qff4g8bDrlCoBIS99ZdFtib/CPdWkWDpol/R26y36eTTsQJDTwdKOX7v6
   fAEbwm65b4Ug2SgbYuZduQYPzBGN7hrUIzNYAnB8mq8lpi/fCq3bKW5MQ
   IeOIQjpSphd1mOAdTDY8ZdmdvluZaErEfmg5p+TFk/b9GpI1Omjj/N/M3
   Q==;
X-CSE-ConnectionGUID: KGjrdFVnTM+QlJUHAeCVEw==
X-CSE-MsgGUID: 2MOg8PphRRqpXcKkKot6nQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566689"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566689"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:37 -0700
X-CSE-ConnectionGUID: etzM7wjhSOe99UPkIIO2gw==
X-CSE-MsgGUID: /6/2X7WJQ7yE34EU3CQX6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905316"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:33 -0700
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
Subject: [PATCH v5 09/10] KVM: Introduce RamDiscardListener for attribute changes during memory conversions
Date: Tue, 20 May 2025 18:28:49 +0800
Message-ID: <20250520102856.132417-10-chenyi.qiang@intel.com>
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

With the introduction of the RamBlockAttribute object to manage
RAMBlocks with guest_memfd, it is more elegant to move KVM set attribute
into a RamDiscardListener.

The KVM attribute change RamDiscardListener is registered/unregistered
for each memory region section during kvm_region_add/del(). The listener
handler performs attribute change upon receiving notifications from
ram_block_attribute_state_change() calls. After this change, the
operations in kvm_convert_memory() can be removed.

Note that, errors can be returned in
ram_block_attribute_notify_to_discard() by KVM attribute changes,
although it is currently unlikely to happen. With in-place conversion
guest_memfd in the future, it would be more likely to encounter errors
and require error handling. For now, simply return the result, and
kvm_convert_memory() will cause QEMU to quit if any issue arises.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v5:
    - Revert to use RamDiscardListener

Changes in v4:
    - Newly added.
---
 accel/kvm/kvm-all.c                         | 72 ++++++++++++++++++---
 include/system/confidential-guest-support.h |  9 +++
 system/ram-block-attribute.c                | 16 +++--
 target/i386/kvm/tdx.c                       |  1 +
 target/i386/sev.c                           |  1 +
 5 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 2d7ecaeb6a..ca4ef8062b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -49,6 +49,7 @@
 #include "kvm-cpus.h"
 #include "system/dirtylimit.h"
 #include "qemu/range.h"
+#include "system/confidential-guest-support.h"
 
 #include "hw/boards.h"
 #include "system/stats.h"
@@ -1689,28 +1690,90 @@ static int kvm_dirty_ring_init(KVMState *s)
     return 0;
 }
 
+static int kvm_private_shared_notify(RamDiscardListener *rdl,
+                                     MemoryRegionSection *section,
+                                     bool to_private)
+{
+    hwaddr start = section->offset_within_address_space;
+    hwaddr size = section->size;
+
+    if (to_private) {
+        return kvm_set_memory_attributes_private(start, size);
+    } else {
+        return kvm_set_memory_attributes_shared(start, size);
+    }
+}
+
+static int kvm_ram_discard_notify_to_shared(RamDiscardListener *rdl,
+                                            MemoryRegionSection *section)
+{
+    return kvm_private_shared_notify(rdl, section, false);
+}
+
+static int kvm_ram_discard_notify_to_private(RamDiscardListener *rdl,
+                                             MemoryRegionSection *section)
+{
+    return kvm_private_shared_notify(rdl, section, true);
+}
+
 static void kvm_region_add(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
     KVMMemoryUpdate *update;
+    CGSRamDiscardListener *crdl;
+    RamDiscardListener *rdl;
+
 
     update = g_new0(KVMMemoryUpdate, 1);
     update->section = *section;
 
     QSIMPLEQ_INSERT_TAIL(&kml->transaction_add, update, next);
+
+    if (!memory_region_has_guest_memfd(section->mr) || !rdm) {
+        return;
+    }
+
+    crdl = g_new0(CGSRamDiscardListener, 1);
+    crdl->mr = section->mr;
+    crdl->offset_within_address_space = section->offset_within_address_space;
+    rdl = &crdl->listener;
+    QLIST_INSERT_HEAD(&cgs->cgs_rdl_list, crdl, next);
+    ram_discard_listener_init(rdl, kvm_ram_discard_notify_to_shared,
+                              kvm_ram_discard_notify_to_private, true);
+    ram_discard_manager_register_listener(rdm, rdl, section);
 }
 
 static void kvm_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
     KVMMemoryUpdate *update;
+    CGSRamDiscardListener *crdl;
+    RamDiscardListener *rdl;
 
     update = g_new0(KVMMemoryUpdate, 1);
     update->section = *section;
 
     QSIMPLEQ_INSERT_TAIL(&kml->transaction_del, update, next);
+    if (!memory_region_has_guest_memfd(section->mr) || !rdm) {
+        return;
+    }
+
+    QLIST_FOREACH(crdl, &cgs->cgs_rdl_list, next) {
+        if (crdl->mr == section->mr &&
+            crdl->offset_within_address_space == section->offset_within_address_space) {
+            rdl = &crdl->listener;
+            ram_discard_manager_unregister_listener(rdm, rdl);
+            QLIST_REMOVE(crdl, next);
+            g_free(crdl);
+            break;
+        }
+    }
 }
 
 static void kvm_region_commit(MemoryListener *listener)
@@ -3077,15 +3140,6 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         goto out_unref;
     }
 
-    if (to_private) {
-        ret = kvm_set_memory_attributes_private(start, size);
-    } else {
-        ret = kvm_set_memory_attributes_shared(start, size);
-    }
-    if (ret) {
-        goto out_unref;
-    }
-
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index ea46b50c56..974abdbf6b 100644
--- a/include/system/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -19,12 +19,19 @@
 #define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
 
 #include "qom/object.h"
+#include "system/memory.h"
 
 #define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
 OBJECT_DECLARE_TYPE(ConfidentialGuestSupport,
                     ConfidentialGuestSupportClass,
                     CONFIDENTIAL_GUEST_SUPPORT)
 
+typedef struct CGSRamDiscardListener {
+    MemoryRegion *mr;
+    hwaddr offset_within_address_space;
+    RamDiscardListener listener;
+    QLIST_ENTRY(CGSRamDiscardListener) next;
+} CGSRamDiscardListener;
 
 struct ConfidentialGuestSupport {
     Object parent;
@@ -34,6 +41,8 @@ struct ConfidentialGuestSupport {
      */
     bool require_guest_memfd;
 
+    QLIST_HEAD(, CGSRamDiscardListener) cgs_rdl_list;
+
     /*
      * ready: flag set by CGS initialization code once it's ready to
      *        start executing instructions in a potentially-secure
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 896c3d7543..387501b569 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -274,11 +274,12 @@ static bool ram_block_attribute_is_valid_range(RamBlockAttribute *attr,
     return true;
 }
 
-static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
-                                                  uint64_t offset,
-                                                  uint64_t size)
+static int ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
+                                                 uint64_t offset,
+                                                 uint64_t size)
 {
     RamDiscardListener *rdl;
+    int ret = 0;
 
     QLIST_FOREACH(rdl, &attr->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
@@ -286,8 +287,13 @@ static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        rdl->notify_discard(rdl, &tmp);
+        ret = rdl->notify_discard(rdl, &tmp);
+        if (ret) {
+            break;
+        }
     }
+
+    return ret;
 }
 
 static int
@@ -377,7 +383,7 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
 
     if (to_private) {
         bitmap_clear(attr->bitmap, first_bit, nbits);
-        ram_block_attribute_notify_to_discard(attr, offset, size);
+        ret = ram_block_attribute_notify_to_discard(attr, offset, size);
     } else {
         bitmap_set(attr->bitmap, first_bit, nbits);
         ret = ram_block_attribute_notify_to_populated(attr, offset, size);
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 7ef49690bd..17b360059c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1492,6 +1492,7 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     cgs->require_guest_memfd = true;
+    QLIST_INIT(&cgs->cgs_rdl_list);
     tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index adf787797e..f1b9c35fc3 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2430,6 +2430,7 @@ sev_snp_guest_instance_init(Object *obj)
     SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
 
     cgs->require_guest_memfd = true;
+    QLIST_INIT(&cgs->cgs_rdl_list);
 
     /* default init/start/finish params for kvm */
     sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
-- 
2.43.5


