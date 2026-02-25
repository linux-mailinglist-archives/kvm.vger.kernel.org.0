Return-Path: <kvm+bounces-71833-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIzzCGrmnmkCXwQAu9opvQ
	(envelope-from <kvm+bounces-71833-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:09:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B54DE19706B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC0F431377AC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 12:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1963ACF12;
	Wed, 25 Feb 2026 12:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cD9MrAbi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815B1221F24
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772021139; cv=none; b=bmr0g1WAFOLh9j/Aeev5aEkCloZUFJW0jPOstm5iuK+zHv40chtzbew6SXlO3iaAYDoKyhNVv6Klw7sfnYJxwdiSjmctiGaka9lgZ9ymV5U5hlxiTrX1biT0uxDhx+vJpZOCmhObv+eCziBc1mXcvkm2semAs8S6UCcsUaFdvT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772021139; c=relaxed/simple;
	bh=ZydmJf7gSg1+CKHy9+PQsnUjWYPpCYDyvCVdnhwXJiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZIpdtmphqYpz5o/zqzmb1QFtauSXk86vsPSbw10uOs2tY95zpq9JZil6so3X/j1Wv7d0p2pPckC1JoeKdyiK1zBPbgd8d7pH2AJMwZtUbQl3H7gUdwJ/RS74+sQzKJB3JzBIvaAFA624uNGFaoMjKMRaqMGROictmgI/CW2F1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cD9MrAbi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772021136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhPrQpvBs8GKNq4C5LYoOh9SwlPDiZEjUUdS1fYmPtA=;
	b=cD9MrAbiG3hj0hgEbHr0ZoLazVa8woUkZH8uhAJupHXP8j2kgkoTYwThEhzY0ocFO/4Sn/
	LdleetM7Gy9qVyn9CbsbPvmEwp/YAJ6c4S8VN+mdhq3b4lCFsPg+LPv08H8nDqzFfjS702
	m4r3DncAw5b0/hU4GL6dlloyIUmSzWQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-CK9U24PdOsaiM_-QR8V8Kw-1; Wed,
 25 Feb 2026 07:05:32 -0500
X-MC-Unique: CK9U24PdOsaiM_-QR8V8Kw-1
X-Mimecast-MFC-AGG-ID: CK9U24PdOsaiM_-QR8V8Kw_1772021130
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD89A19560A6;
	Wed, 25 Feb 2026 12:05:30 +0000 (UTC)
Received: from localhost (unknown [10.48.1.67])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A2EF1800673;
	Wed, 25 Feb 2026 12:05:30 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	Fabiano Rosas <farosas@suse.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v2 12/14] system/memory: implement RamDiscardManager multi-source aggregation
Date: Wed, 25 Feb 2026 13:04:53 +0100
Message-ID: <20260225120456.3170057-13-marcandre.lureau@redhat.com>
In-Reply-To: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
References: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71833-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B54DE19706B
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Refactor RamDiscardManager to aggregate multiple RamDiscardSource
instances. This enables scenarios where multiple components (e.g.,
virtio-mem and RamBlockAttributes) can coordinate memory discard
state for the same memory region.

The aggregation uses:
- Populated: ALL sources populated
- Discarded: ANY source discarded

When a source is added with existing listeners, they are notified
about regions that become discarded. When a source is removed,
listeners are notified about regions that become populated.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/system/ram-discard-manager.h | 143 +++++++--
 hw/virtio/virtio-mem.c               |   8 +-
 system/memory.c                      |  15 +-
 system/ram-block-attributes.c        |   6 +-
 system/ram-discard-manager.c         | 427 ++++++++++++++++++++++++---
 5 files changed, 515 insertions(+), 84 deletions(-)

diff --git a/include/system/ram-discard-manager.h b/include/system/ram-discard-manager.h
index b5dbcb4a82d..9d650ee4d7b 100644
--- a/include/system/ram-discard-manager.h
+++ b/include/system/ram-discard-manager.h
@@ -170,30 +170,96 @@ struct RamDiscardSourceClass {
  * becoming discarded in a different granularity than it was populated and the
  * other way around.
  */
+
+typedef struct RamDiscardSourceEntry RamDiscardSourceEntry;
+
+struct RamDiscardSourceEntry {
+    RamDiscardSource *rds;
+    QLIST_ENTRY(RamDiscardSourceEntry) next;
+};
+
 struct RamDiscardManager {
     Object parent;
 
-    RamDiscardSource *rds;
-    MemoryRegion *mr;
+    struct MemoryRegion *mr;
+    QLIST_HEAD(, RamDiscardSourceEntry) source_list;
+    uint64_t min_granularity;
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
-RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
-                                           RamDiscardSource *rds);
+RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr);
+
+/**
+ * ram_discard_manager_add_source:
+ *
+ * Register a #RamDiscardSource with the #RamDiscardManager. The manager
+ * aggregates state from all registered sources using AND semantics: a region
+ * is considered populated only if ALL sources report it as populated.
+ *
+ * If listeners are already registered, they will be notified about any
+ * regions that become discarded due to adding this source. Specifically,
+ * for each region that the new source reports as discarded, if all other
+ * sources reported it as populated, listeners receive a discard notification.
+ *
+ * If any listener rejects the notification (returns an error), previously
+ * notified listeners are rolled back with populate notifications and the
+ * source is not added.
+ *
+ * @rdm: the #RamDiscardManager
+ * @source: the #RamDiscardSource to add
+ *
+ * Returns: 0 on success, -EBUSY if @source is already registered, or a
+ *          negative error code if a listener rejected the state change.
+ */
+int ram_discard_manager_add_source(RamDiscardManager *rdm,
+                                   RamDiscardSource *source);
+
+/**
+ * ram_discard_manager_del_source:
+ *
+ * Unregister a #RamDiscardSource from the #RamDiscardManager.
+ *
+ * If listeners are already registered, they will be notified about any
+ * regions that become populated due to removing this source. Specifically,
+ * for each region that the removed source reported as discarded, if all
+ * remaining sources report it as populated, listeners receive a populate
+ * notification.
+ *
+ * If any listener rejects the notification (returns an error), previously
+ * notified listeners are rolled back with discard notifications and the
+ * source is not removed.
+ *
+ * @rdm: the #RamDiscardManager
+ * @source: the #RamDiscardSource to remove
+ *
+ * Returns: 0 on success, -ENOENT if @source is not registered, or a
+ *          negative error code if a listener rejected the state change.
+ */
+int ram_discard_manager_del_source(RamDiscardManager *rdm,
+                                   RamDiscardSource *source);
+
 
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
                                                  const MemoryRegion *mr);
 
+/**
+ * ram_discard_manager_is_populated:
+ *
+ * Check if the given memory region section is populated.
+ * If the manager has no sources, it is considered populated.
+ *
+ * @rdm: the #RamDiscardManager
+ * @section: the #MemoryRegionSection to check
+ *
+ * Returns: true if the section is populated, false otherwise.
+ */
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
                                       const MemoryRegionSection *section);
 
 /**
  * ram_discard_manager_replay_populated:
  *
- * Iterate the given #MemoryRegionSection at minimum granularity, calling
- * #RamDiscardSourceClass.is_populated for each chunk, and invoke @replay_fn
- * for each contiguous populated range. In case any call fails, no further
- * calls are made.
+ * Call @replay_fn on regions that are populated in all sources.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
@@ -210,10 +276,7 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
 /**
  * ram_discard_manager_replay_discarded:
  *
- * Iterate the given #MemoryRegionSection at minimum granularity, calling
- * #RamDiscardSourceClass.is_populated for each chunk, and invoke @replay_fn
- * for each contiguous discarded range. In case any call fails, no further
- * calls are made.
+ * Call @replay_fn on regions that are discarded in any sources.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
@@ -234,31 +297,61 @@ void ram_discard_manager_register_listener(RamDiscardManager *rdm,
 void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
                                              RamDiscardListener *rdl);
 
-/*
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
+/**
+ * ram_discard_manager_notify_populate:
+ *
+ * Notify listeners that a region is about to be populated by a source.
+ * For multi-source aggregation, only notifies when all sources agree
+ * the region is populated (intersection).
+ *
+ * @rdm: the #RamDiscardManager
+ * @source: the #RamDiscardSource that is populating
+ * @offset: offset within the memory region
+ * @size: size of the region being populated
+ *
+ * Returns 0 on success, or a negative error if any listener rejects.
  */
 int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
+                                        RamDiscardSource *source,
                                         uint64_t offset, uint64_t size);
 
-/*
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
+/**
+ * ram_discard_manager_notify_discard:
+ *
+ * Notify listeners that a region has been discarded by a source.
+ * For multi-source aggregation, always notifies immediately
+ * (union semantics - any source discarding makes region discarded).
+ *
+ * @rdm: the #RamDiscardManager
+ * @source: the #RamDiscardSource that is discarding
+ * @offset: offset within the memory region
+ * @size: size of the region being discarded
  */
 void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
+                                        RamDiscardSource *source,
                                         uint64_t offset, uint64_t size);
 
-/*
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
+/**
+ * ram_discard_manager_notify_discard_all:
+ *
+ * Notify listeners that all regions have been discarded by a source.
+ *
+ * @rdm: the #RamDiscardManager
+ * @source: the #RamDiscardSource that is discarding
  */
-void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm);
+void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm,
+                                            RamDiscardSource *source);
 
-/*
+/**
+ * ram_discard_manager_replay_populated_to_listeners:
+ *
  * Replay populated sections to all registered listeners.
+ * For multi-source aggregation, only replays regions where all sources
+ * are populated (intersection).
  *
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
+ * @rdm: the #RamDiscardManager
+ *
+ * Returns 0 on success, or a negative error if any notification failed.
  */
 int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm);
 
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 2b67b2882d2..35e03ed7599 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -264,7 +264,8 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
 
-    ram_discard_manager_notify_discard(rdm, offset, size);
+    ram_discard_manager_notify_discard(rdm, RAM_DISCARD_SOURCE(vmem),
+                                       offset, size);
 }
 
 static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
@@ -272,7 +273,8 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
 
-    return ram_discard_manager_notify_populate(rdm, offset, size);
+    return ram_discard_manager_notify_populate(rdm, RAM_DISCARD_SOURCE(vmem),
+                                               offset, size);
 }
 
 static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
@@ -283,7 +285,7 @@ static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
         return;
     }
 
-    ram_discard_manager_notify_discard_all(rdm);
+    ram_discard_manager_notify_discard_all(rdm, RAM_DISCARD_SOURCE(vmem));
 }
 
 static bool virtio_mem_is_range_plugged(const VirtIOMEM *vmem,
diff --git a/system/memory.c b/system/memory.c
index 8b46cb87838..8a4cb7b59ac 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2109,21 +2109,22 @@ int memory_region_add_ram_discard_source(MemoryRegion *mr,
                                          RamDiscardSource *source)
 {
     g_assert(memory_region_is_ram(mr));
-    if (mr->rdm) {
-        return -EBUSY;
+
+    if (!mr->rdm) {
+        mr->rdm = ram_discard_manager_new(mr);
     }
 
-    mr->rdm = ram_discard_manager_new(mr, RAM_DISCARD_SOURCE(source));
-    return 0;
+    return ram_discard_manager_add_source(mr->rdm, source);
 }
 
 void memory_region_del_ram_discard_source(MemoryRegion *mr,
                                           RamDiscardSource *source)
 {
-    g_assert(mr->rdm->rds == source);
+    g_assert(mr->rdm);
+
+    ram_discard_manager_del_source(mr->rdm, source);
 
-    object_unref(mr->rdm);
-    mr->rdm = NULL;
+    /* if there is no source and no listener left, we could free rdm */
 }
 
 /* Called with rcu_read_lock held.  */
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index 718c7075cec..59ec7a28eb0 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -90,7 +90,8 @@ ram_block_attributes_notify_discard(RamBlockAttributes *attr,
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(attr->ram_block->mr);
 
-    ram_discard_manager_notify_discard(rdm, offset, size);
+    ram_discard_manager_notify_discard(rdm, RAM_DISCARD_SOURCE(attr),
+                                       offset, size);
 }
 
 static int
@@ -99,7 +100,8 @@ ram_block_attributes_notify_populate(RamBlockAttributes *attr,
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(attr->ram_block->mr);
 
-    return ram_discard_manager_notify_populate(rdm, offset, size);
+    return ram_discard_manager_notify_populate(rdm, RAM_DISCARD_SOURCE(attr),
+                                               offset, size);
 }
 
 int ram_block_attributes_state_change(RamBlockAttributes *attr,
diff --git a/system/ram-discard-manager.c b/system/ram-discard-manager.c
index 25beb052a1e..5592bfd3486 100644
--- a/system/ram-discard-manager.c
+++ b/system/ram-discard-manager.c
@@ -7,6 +7,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
+#include "qemu/queue.h"
 #include "system/memory.h"
 
 static uint64_t ram_discard_source_get_min_granularity(const RamDiscardSource *rds,
@@ -28,20 +29,21 @@ static bool ram_discard_source_is_populated(const RamDiscardSource *rds,
 }
 
 /*
- * Iterate the section at source granularity, aggregating consecutive chunks
- * with matching populated state, and call replay_fn for each run.
+ * Iterate a single source's populated or discarded regions and call
+ * replay_fn for each contiguous run.
  */
-static int replay_by_populated_state(const RamDiscardManager *rdm,
-                                     const MemoryRegionSection *section,
-                                     bool replay_populated,
-                                     ReplayRamDiscardState replay_fn,
-                                     void *opaque)
+static int replay_source_by_state(const RamDiscardSource *source,
+                                  const MemoryRegion *mr,
+                                  const MemoryRegionSection *section,
+                                  bool replay_populated,
+                                  ReplayRamDiscardState replay_fn,
+                                  void *opaque)
 {
     uint64_t granularity, offset, size, end, pos, run_start;
     bool in_run = false;
     int ret = 0;
 
-    granularity = ram_discard_source_get_min_granularity(rdm->rds, rdm->mr);
+    granularity = ram_discard_source_get_min_granularity(source, mr);
     offset = section->offset_within_region;
     size = int128_get64(section->size);
     end = offset + size;
@@ -55,7 +57,7 @@ static int replay_by_populated_state(const RamDiscardManager *rdm,
             .offset_within_region = pos,
             .size = int128_make64(granularity),
         };
-        bool populated = ram_discard_source_is_populated(rdm->rds, &chunk);
+        bool populated = ram_discard_source_is_populated(source, &chunk);
 
         if (populated == replay_populated) {
             if (!in_run) {
@@ -88,28 +90,338 @@ static int replay_by_populated_state(const RamDiscardManager *rdm,
     return ret;
 }
 
-RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
-                                           RamDiscardSource *rds)
+RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr)
 {
     RamDiscardManager *rdm;
 
     rdm = RAM_DISCARD_MANAGER(object_new(TYPE_RAM_DISCARD_MANAGER));
-    rdm->rds = rds;
     rdm->mr = mr;
-    QLIST_INIT(&rdm->rdl_list);
     return rdm;
 }
 
+static void ram_discard_manager_update_granularity(RamDiscardManager *rdm)
+{
+    RamDiscardSourceEntry *entry;
+    uint64_t granularity = 0;
+
+    QLIST_FOREACH(entry, &rdm->source_list, next) {
+        uint64_t src_granularity;
+
+        src_granularity =
+            ram_discard_source_get_min_granularity(entry->rds, rdm->mr);
+        g_assert(src_granularity != 0);
+        if (granularity == 0) {
+            granularity = src_granularity;
+        } else {
+            granularity = MIN(granularity, src_granularity);
+        }
+    }
+    rdm->min_granularity = granularity;
+}
+
+static RamDiscardSourceEntry *
+ram_discard_manager_find_source(RamDiscardManager *rdm, RamDiscardSource *rds)
+{
+    RamDiscardSourceEntry *entry;
+
+    QLIST_FOREACH(entry, &rdm->source_list, next) {
+        if (entry->rds == rds) {
+            return entry;
+        }
+    }
+    return NULL;
+}
+
+static int rdl_populate_cb(const MemoryRegionSection *section, void *opaque)
+{
+    RamDiscardListener *rdl = opaque;
+    MemoryRegionSection tmp = *rdl->section;
+
+    g_assert(section->mr == rdl->section->mr);
+
+    if (!memory_region_section_intersect_range(&tmp,
+                                               section->offset_within_region,
+                                               int128_get64(section->size))) {
+        return 0;
+    }
+
+    return rdl->notify_populate(rdl, &tmp);
+}
+
+static int rdl_discard_cb(const MemoryRegionSection *section, void *opaque)
+{
+    RamDiscardListener *rdl = opaque;
+    MemoryRegionSection tmp = *rdl->section;
+
+    g_assert(section->mr == rdl->section->mr);
+
+    if (!memory_region_section_intersect_range(&tmp,
+                                               section->offset_within_region,
+                                               int128_get64(section->size))) {
+        return 0;
+    }
+
+    rdl->notify_discard(rdl, &tmp);
+    return 0;
+}
+
+static bool rdm_is_all_populated_skip(const RamDiscardManager *rdm,
+                                      const MemoryRegionSection *section,
+                                      const RamDiscardSource *skip_source)
+{
+    RamDiscardSourceEntry *entry;
+
+    QLIST_FOREACH(entry, &rdm->source_list, next) {
+        if (skip_source && entry->rds == skip_source) {
+            continue;
+        }
+        if (!ram_discard_source_is_populated(entry->rds, section)) {
+            return false;
+        }
+    }
+    return true;
+}
+
+typedef struct SourceNotifyCtx {
+    RamDiscardManager *rdm;
+    RamDiscardListener *rdl;
+    RamDiscardSource *source; /* added or removed */
+} SourceNotifyCtx;
+
+/*
+ * Unified helper to replay regions based on populated state.
+ * If replay_populated is true: replay regions where ALL sources are populated.
+ * If replay_populated is false: replay regions where ANY source is discarded.
+ */
+static int replay_by_populated_state(const RamDiscardManager *rdm,
+                                     const MemoryRegionSection *section,
+                                     const RamDiscardSource *skip_source,
+                                     bool replay_populated,
+                                     ReplayRamDiscardState replay_fn,
+                                     void *user_opaque)
+{
+    uint64_t granularity = rdm->min_granularity;
+    uint64_t offset, end_offset;
+    uint64_t run_start = 0;
+    bool in_run = false;
+    int ret = 0;
+
+    if (QLIST_EMPTY(&rdm->source_list)) {
+        if (replay_populated) {
+            return replay_fn(section, user_opaque);
+        }
+        return 0;
+    }
+
+    g_assert(granularity != 0);
+
+    offset = section->offset_within_region;
+    end_offset = offset + int128_get64(section->size);
+
+    while (offset < end_offset) {
+        MemoryRegionSection subsection = {
+            .mr = section->mr,
+            .offset_within_region = offset,
+            .size = int128_make64(MIN(granularity, end_offset - offset)),
+        };
+        bool all_populated;
+        bool included;
+
+        all_populated = rdm_is_all_populated_skip(rdm, &subsection,
+                                                     skip_source);
+        included = replay_populated ? all_populated : !all_populated;
+
+        if (included) {
+            if (!in_run) {
+                run_start = offset;
+                in_run = true;
+            }
+        } else {
+            if (in_run) {
+                MemoryRegionSection run_section = {
+                    .mr = section->mr,
+                    .offset_within_region = run_start,
+                    .size = int128_make64(offset - run_start),
+                };
+                ret = replay_fn(&run_section, user_opaque);
+                if (ret) {
+                    return ret;
+                }
+                in_run = false;
+            }
+        }
+        if (granularity > end_offset - offset) {
+            break;
+        }
+        offset += granularity;
+    }
+
+    if (in_run) {
+        MemoryRegionSection run_section = {
+            .mr = section->mr,
+            .offset_within_region = run_start,
+            .size = int128_make64(end_offset - run_start),
+        };
+        ret = replay_fn(&run_section, user_opaque);
+    }
+
+    return ret;
+}
+
+static int add_source_check_discard_cb(const MemoryRegionSection *section,
+                                       void *opaque)
+{
+    SourceNotifyCtx *ctx = opaque;
+
+    return replay_by_populated_state(ctx->rdm, section, ctx->source, true,
+                                     rdl_discard_cb, ctx->rdl);
+}
+
+static int del_source_check_populate_cb(const MemoryRegionSection *section,
+                                        void *opaque)
+{
+    SourceNotifyCtx *ctx = opaque;
+
+    return replay_by_populated_state(ctx->rdm, section, ctx->source, true,
+                                     rdl_populate_cb, ctx->rdl);
+}
+
+int ram_discard_manager_add_source(RamDiscardManager *rdm,
+                                   RamDiscardSource *source)
+{
+    RamDiscardSourceEntry *entry;
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    if (ram_discard_manager_find_source(rdm, source)) {
+        return -EBUSY;
+    }
+
+    /*
+     * If there are existing listeners, notify them about regions that
+     * become discarded due to adding this source. Only notify for regions
+     * that were previously populated (all other sources agreed).
+     */
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        SourceNotifyCtx ctx = {
+            .rdm = rdm,
+            .rdl = rdl,
+            /* no need to set source */
+        };
+        ret = replay_source_by_state(source, rdm->mr, rdl->section,
+                                     false,
+                                     add_source_check_discard_cb, &ctx);
+        if (ret) {
+            break;
+        }
+    }
+    if (ret) {
+        QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
+            SourceNotifyCtx ctx = {
+                .rdm = rdm,
+                .rdl = rdl2,
+            };
+            replay_source_by_state(source, rdm->mr, rdl2->section,
+                                   false,
+                                   del_source_check_populate_cb,
+                                   &ctx);
+            if (rdl == rdl2) {
+                break;
+            }
+        }
+
+        return ret;
+    }
+
+    entry = g_new0(RamDiscardSourceEntry, 1);
+    entry->rds = source;
+    QLIST_INSERT_HEAD(&rdm->source_list, entry, next);
+
+    ram_discard_manager_update_granularity(rdm);
+
+    return ret;
+}
+
+int ram_discard_manager_del_source(RamDiscardManager *rdm,
+                                   RamDiscardSource *source)
+{
+    RamDiscardSourceEntry *entry;
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    entry = ram_discard_manager_find_source(rdm, source);
+    if (!entry) {
+        return -ENOENT;
+    }
+
+    /*
+     * If there are existing listeners, check if any regions become
+     * populated due to removing this source.
+     */
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        SourceNotifyCtx ctx = {
+            .rdm = rdm,
+            .rdl = rdl,
+            .source = source,
+        };
+        /*
+         * From the previously discarded regions, check if any
+         * regions become populated.
+         */
+        ret = replay_source_by_state(source, rdm->mr, rdl->section,
+                                     false,
+                                     del_source_check_populate_cb,
+                                     &ctx);
+        if (ret) {
+            break;
+        }
+    }
+    if (ret) {
+        QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
+            SourceNotifyCtx ctx = {
+                .rdm = rdm,
+                .rdl = rdl2,
+                .source = source,
+            };
+            replay_source_by_state(source, rdm->mr, rdl2->section,
+                                   false,
+                                   add_source_check_discard_cb,
+                                   &ctx);
+            if (rdl == rdl2) {
+                break;
+            }
+        }
+
+        return ret;
+    }
+
+    QLIST_REMOVE(entry, next);
+    g_free(entry);
+    ram_discard_manager_update_granularity(rdm);
+    return ret;
+}
+
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
                                                  const MemoryRegion *mr)
 {
-    return ram_discard_source_get_min_granularity(rdm->rds, mr);
+    g_assert(mr == rdm->mr);
+    return rdm->min_granularity;
 }
 
+/*
+ * Aggregated query: returns true only if ALL sources report populated (AND).
+ */
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
                                       const MemoryRegionSection *section)
 {
-    return ram_discard_source_is_populated(rdm->rds, section);
+    RamDiscardSourceEntry *entry;
+
+    QLIST_FOREACH(entry, &rdm->source_list, next) {
+        if (!ram_discard_source_is_populated(entry->rds, section)) {
+            return false;
+        }
+    }
+    return true;
 }
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
@@ -117,7 +429,8 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    return replay_by_populated_state(rdm, section, true, replay_fn, opaque);
+    return replay_by_populated_state(rdm, section, NULL, true,
+                                     replay_fn, opaque);
 }
 
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
@@ -125,14 +438,17 @@ int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    return replay_by_populated_state(rdm, section, false, replay_fn, opaque);
+    return replay_by_populated_state(rdm, section, NULL, false,
+                                     replay_fn, opaque);
 }
 
 static void ram_discard_manager_initfn(Object *obj)
 {
     RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
 
+    QLIST_INIT(&rdm->source_list);
     QLIST_INIT(&rdm->rdl_list);
+    rdm->min_granularity = 0;
 }
 
 static void ram_discard_manager_finalize(Object *obj)
@@ -140,74 +456,91 @@ static void ram_discard_manager_finalize(Object *obj)
     RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
 
     g_assert(QLIST_EMPTY(&rdm->rdl_list));
+    g_assert(QLIST_EMPTY(&rdm->source_list));
 }
 
 int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
+                                        RamDiscardSource *source,
                                         uint64_t offset, uint64_t size)
 {
     RamDiscardListener *rdl, *rdl2;
+    MemoryRegionSection section = {
+        .mr = rdm->mr,
+        .offset_within_region = offset,
+        .size = int128_make64(size),
+    };
     int ret = 0;
 
-    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
+    g_assert(ram_discard_manager_find_source(rdm, source));
 
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        ret = rdl->notify_populate(rdl, &tmp);
+    /*
+     * Only notify about regions that are populated in ALL sources.
+     * replay_by_populated_state checks all sources including the one that
+     * just populated.
+     */
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        ret = replay_by_populated_state(rdm, &section, NULL, true,
+                                        rdl_populate_cb, rdl);
         if (ret) {
             break;
         }
     }
 
     if (ret) {
-        /* Notify all already-notified listeners about discard. */
+        /*
+         * Rollback: notify discard for listeners we already notified,
+         * including the failing listener which may have been partially
+         * notified. Listeners must handle discard notifications for
+         * regions they didn't receive populate notifications for.
+         */
         QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
-            MemoryRegionSection tmp = *rdl2->section;
-
+            replay_by_populated_state(rdm, &section, NULL, true,
+                                      rdl_discard_cb, rdl2);
             if (rdl2 == rdl) {
                 break;
             }
-            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-                continue;
-            }
-            rdl2->notify_discard(rdl2, &tmp);
         }
     }
     return ret;
 }
 
 void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
+                                        RamDiscardSource *source,
                                         uint64_t offset, uint64_t size)
 {
     RamDiscardListener *rdl;
-
+    MemoryRegionSection section = {
+        .mr = rdm->mr,
+        .offset_within_region = offset,
+        .size = int128_make64(size),
+    };
+
+    g_assert(ram_discard_manager_find_source(rdm, source));
+
+    /*
+     * Only notify about ranges that were aggregately populated before this
+     * source's discard. Since the source has already updated its state,
+     * we use replay_by_populated_state with this source skipped - it will
+     * replay only the ranges where all OTHER sources are populated.
+     */
     QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        rdl->notify_discard(rdl, &tmp);
+        replay_by_populated_state(rdm, &section, source, true,
+                                  rdl_discard_cb, rdl);
     }
 }
 
-void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm)
+void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm,
+                                            RamDiscardSource *source)
 {
     RamDiscardListener *rdl;
 
+    g_assert(ram_discard_manager_find_source(rdm, source));
+
     QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
         rdl->notify_discard(rdl, rdl->section);
     }
 }
 
-static int rdm_populate_cb(const MemoryRegionSection *section, void *opaque)
-{
-    RamDiscardListener *rdl = opaque;
-
-    return rdl->notify_populate(rdl, section);
-}
-
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
                                            MemoryRegionSection *section)
@@ -220,7 +553,7 @@ void ram_discard_manager_register_listener(RamDiscardManager *rdm,
     QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
 
     ret = ram_discard_manager_replay_populated(rdm, rdl->section,
-                                               rdm_populate_cb, rdl);
+                                               rdl_populate_cb, rdl);
     if (ret) {
         error_report("%s: Replaying populated ranges failed: %s", __func__,
                      strerror(-ret));
@@ -246,7 +579,7 @@ int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm)
 
     QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
         ret = ram_discard_manager_replay_populated(rdm, rdl->section,
-                                                   rdm_populate_cb, rdl);
+                                                   rdl_populate_cb, rdl);
         if (ret) {
             break;
         }
-- 
2.53.0


