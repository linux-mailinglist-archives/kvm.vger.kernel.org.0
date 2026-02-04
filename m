Return-Path: <kvm+bounces-70175-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJwiA7Mag2l/hwMAu9opvQ
	(envelope-from <kvm+bounces-70175-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:08:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5861DE4469
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 143D03045AB3
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 10:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407A236E472;
	Wed,  4 Feb 2026 10:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7OwnYgV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5D23D646B
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770199677; cv=none; b=JLnEdv7Ru6UNk/KXt+YNvb1+hs8ttT6fdLp/M5uplgdGaW4vlmFGYVrd0gn92zKzHjEnlStaStAV7CFPl0e/9nGPjdsIn9Jx5bHDCluYRMd9CrB6xoir+EDm6t4bLKx2JFKzLxeKfAHJWN1NkxuyTHNXgsSek1L0gRajQ5nN+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770199677; c=relaxed/simple;
	bh=x4r7Vz4Dnp2VC5Ph8w8Ed42zUCRV5nsfBCoeZbdqO6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nl2Mi6jCLARWb+Vkoy5XdcICInnUqZmrKAar9QDl8S1FuUs9ro/GmsV1/UMfwgAR/q8EbdFUGL41oFIHDGAox0GfCF8q/kBGMfBHzSyHohLGxqLB6bDZ0faTo7EiBuHtpWYHFR9A+ka+ByuKDonp8PSSpHslGwlRoc2z1F1Vjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7OwnYgV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770199676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1lH8AOUpmQNQYZiTsi4fpNFm8Ruxo3VLn/JWrOlFL8=;
	b=V7OwnYgVQV7p322RnUvaTVgfZiW6AJaQNNdDhPzqipauIlxt4BgxkWxjDSadrtUwb43C7a
	x4ci0PJKvrvWBs0EL/O8zoOlQk0rqmTBtjAdFdp5MY8wtCDhK0pCXOUFf62WDC3NOnbD/u
	U7vB8WQOeVnOdLEWAa+bEJ7Q0jU0/a0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-ihuF_kPpMoeL9lqR6BkLKQ-1; Wed,
 04 Feb 2026 05:07:52 -0500
X-MC-Unique: ihuF_kPpMoeL9lqR6BkLKQ-1
X-Mimecast-MFC-AGG-ID: ihuF_kPpMoeL9lqR6BkLKQ_1770199671
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 133C118005AD;
	Wed,  4 Feb 2026 10:07:51 +0000 (UTC)
Received: from localhost (unknown [10.45.242.6])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2616B18004AD;
	Wed,  4 Feb 2026 10:07:47 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Fabiano Rosas <farosas@suse.de>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 06/10] system/memory: split RamDiscardManager into source and manager
Date: Wed,  4 Feb 2026 14:07:02 +0400
Message-ID: <20260204100708.724800-7-marcandre.lureau@redhat.com>
In-Reply-To: <20260204100708.724800-1-marcandre.lureau@redhat.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
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
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70175-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5861DE4469
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Refactor the RamDiscardManager interface into two distinct components:
- RamDiscardSource: An interface that state providers (virtio-mem,
  RamBlockAttributes) implement to provide discard state information
  (granularity, populated/discarded ranges, replay callbacks).
- RamDiscardManager: A concrete QOM object that wraps a source, owns
  the listener list, and handles listener registration/unregistration
  and notifications.

This separation moves the listener management logic from individual
source implementations into the central RamDiscardManager, reducing
code duplication between virtio-mem and RamBlockAttributes.

The change prepares for future work where a RamDiscardManager could
aggregate multiple sources.

Note, the original virtio-mem code had conditions before discard:
  if (vmem->size) {
      rdl->notify_discard(rdl, rdl->section);
  }
however, the new code calls discard unconditionally. This is considered
safe, since the populate/discard of sections are already asymmetrical
(unplug & unregister all listener section unconditionally).

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/hw/virtio/virtio-mem.h |   3 -
 include/system/memory.h        | 195 ++++++++++++++++-------------
 include/system/ramblock.h      |   3 +-
 hw/virtio/virtio-mem.c         | 163 +++++-------------------
 system/memory.c                | 218 +++++++++++++++++++++++++++++----
 system/ram-block-attributes.c  | 171 ++++++++------------------
 6 files changed, 385 insertions(+), 368 deletions(-)

diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index 221cfd76bf9..5d1d19c6bec 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -118,9 +118,6 @@ struct VirtIOMEM {
     /* notifiers to notify when "size" changes */
     NotifierList size_change_notifiers;
 
-    /* listeners to notify on plug/unplug activity. */
-    QLIST_HEAD(, RamDiscardListener) rdl_list;
-
     /* Catch system resets -> qemu_devices_reset() only. */
     VirtioMemSystemReset *system_reset;
 };
diff --git a/include/system/memory.h b/include/system/memory.h
index a64b2826489..c6373585a22 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -54,6 +54,12 @@ typedef struct RamDiscardManager RamDiscardManager;
 DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
                      RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
 
+#define TYPE_RAM_DISCARD_SOURCE "ram-discard-source"
+typedef struct RamDiscardSourceClass RamDiscardSourceClass;
+typedef struct RamDiscardSource RamDiscardSource;
+DECLARE_OBJ_CHECKERS(RamDiscardSource, RamDiscardSourceClass,
+                     RAM_DISCARD_SOURCE, TYPE_RAM_DISCARD_SOURCE);
+
 #ifdef CONFIG_FUZZ
 void fuzz_dma_read_cb(size_t addr,
                       size_t len,
@@ -595,8 +601,8 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
 /**
  * typedef ReplayRamDiscardState:
  *
- * The callback handler for #RamDiscardManagerClass.replay_populated/
- * #RamDiscardManagerClass.replay_discarded to invoke on populated/discarded
+ * The callback handler for #RamDiscardSourceClass.replay_populated/
+ * #RamDiscardSourceClass.replay_discarded to invoke on populated/discarded
  * parts.
  *
  * @section: the #MemoryRegionSection of populated/discarded part
@@ -608,40 +614,17 @@ typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
                                      void *opaque);
 
 /*
- * RamDiscardManagerClass:
- *
- * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
- * regions are currently populated to be used/accessed by the VM, notifying
- * after parts were discarded (freeing up memory) and before parts will be
- * populated (consuming memory), to be used/accessed by the VM.
+ * RamDiscardSourceClass:
  *
- * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
- * #MemoryRegion isn't mapped into an address space yet (either directly
- * or via an alias); it cannot change while the #MemoryRegion is
- * mapped into an address space.
- *
- * The #RamDiscardManager is intended to be used by technologies that are
- * incompatible with discarding of RAM (e.g., VFIO, which may pin all
- * memory inside a #MemoryRegion), and require proper coordination to only
- * map the currently populated parts, to hinder parts that are expected to
- * remain discarded from silently getting populated and consuming memory.
- * Technologies that support discarding of RAM don't have to bother and can
- * simply map the whole #MemoryRegion.
- *
- * An example #RamDiscardManager is virtio-mem, which logically (un)plugs
- * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
- * Logically unplugging memory consists of discarding RAM. The VM agreed to not
- * access unplugged (discarded) memory - especially via DMA. virtio-mem will
- * properly coordinate with listeners before memory is plugged (populated),
- * and after memory is unplugged (discarded).
+ * A #RamDiscardSource provides information about which parts of a specific
+ * RAM #MemoryRegion are currently populated (accessible) vs discarded.
  *
- * Listeners are called in multiples of the minimum granularity (unless it
- * would exceed the registered range) and changes are aligned to the minimum
- * granularity within the #MemoryRegion. Listeners have to prepare for memory
- * becoming discarded in a different granularity than it was populated and the
- * other way around.
+ * This is an interface that state providers (like virtio-mem or
+ * RamBlockAttributes) implement to provide discard state information. A
+ * #RamDiscardManager wraps sources and manages listener registrations and
+ * notifications.
  */
-struct RamDiscardManagerClass {
+struct RamDiscardSourceClass {
     /* private */
     InterfaceClass parent_class;
 
@@ -651,47 +634,47 @@ struct RamDiscardManagerClass {
      * @get_min_granularity:
      *
      * Get the minimum granularity in which listeners will get notified
-     * about changes within the #MemoryRegion via the #RamDiscardManager.
+     * about changes within the #MemoryRegion via the #RamDiscardSource.
      *
-     * @rdm: the #RamDiscardManager
+     * @rds: the #RamDiscardSource
      * @mr: the #MemoryRegion
      *
      * Returns the minimum granularity.
      */
-    uint64_t (*get_min_granularity)(const RamDiscardManager *rdm,
+    uint64_t (*get_min_granularity)(const RamDiscardSource *rds,
                                     const MemoryRegion *mr);
 
     /**
      * @is_populated:
      *
      * Check whether the given #MemoryRegionSection is completely populated
-     * (i.e., no parts are currently discarded) via the #RamDiscardManager.
+     * (i.e., no parts are currently discarded) via the #RamDiscardSource.
      * There are no alignment requirements.
      *
-     * @rdm: the #RamDiscardManager
+     * @rds: the #RamDiscardSource
      * @section: the #MemoryRegionSection
      *
      * Returns whether the given range is completely populated.
      */
-    bool (*is_populated)(const RamDiscardManager *rdm,
+    bool (*is_populated)(const RamDiscardSource *rds,
                          const MemoryRegionSection *section);
 
     /**
      * @replay_populated:
      *
      * Call the #ReplayRamDiscardState callback for all populated parts within
-     * the #MemoryRegionSection via the #RamDiscardManager.
+     * the #MemoryRegionSection via the #RamDiscardSource.
      *
      * In case any call fails, no further calls are made.
      *
-     * @rdm: the #RamDiscardManager
+     * @rds: the #RamDiscardSource
      * @section: the #MemoryRegionSection
      * @replay_fn: the #ReplayRamDiscardState callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
-    int (*replay_populated)(const RamDiscardManager *rdm,
+    int (*replay_populated)(const RamDiscardSource *rds,
                             MemoryRegionSection *section,
                             ReplayRamDiscardState replay_fn, void *opaque);
 
@@ -699,50 +682,60 @@ struct RamDiscardManagerClass {
      * @replay_discarded:
      *
      * Call the #ReplayRamDiscardState callback for all discarded parts within
-     * the #MemoryRegionSection via the #RamDiscardManager.
+     * the #MemoryRegionSection via the #RamDiscardSource.
      *
-     * @rdm: the #RamDiscardManager
+     * @rds: the #RamDiscardSource
      * @section: the #MemoryRegionSection
      * @replay_fn: the #ReplayRamDiscardState callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
-    int (*replay_discarded)(const RamDiscardManager *rdm,
+    int (*replay_discarded)(const RamDiscardSource *rds,
                             MemoryRegionSection *section,
                             ReplayRamDiscardState replay_fn, void *opaque);
+};
 
-    /**
-     * @register_listener:
-     *
-     * Register a #RamDiscardListener for the given #MemoryRegionSection and
-     * immediately notify the #RamDiscardListener about all populated parts
-     * within the #MemoryRegionSection via the #RamDiscardManager.
-     *
-     * In case any notification fails, no further notifications are triggered
-     * and an error is logged.
-     *
-     * @rdm: the #RamDiscardManager
-     * @rdl: the #RamDiscardListener
-     * @section: the #MemoryRegionSection
-     */
-    void (*register_listener)(RamDiscardManager *rdm,
-                              RamDiscardListener *rdl,
-                              MemoryRegionSection *section);
+/**
+ * RamDiscardManager:
+ *
+ * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
+ * regions are currently populated to be used/accessed by the VM, notifying
+ * after parts were discarded (freeing up memory) and before parts will be
+ * populated (consuming memory), to be used/accessed by the VM.
+ *
+ * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
+ * #MemoryRegion isn't mapped into an address space yet (either directly
+ * or via an alias); it cannot change while the #MemoryRegion is
+ * mapped into an address space.
+ *
+ * The #RamDiscardManager is intended to be used by technologies that are
+ * incompatible with discarding of RAM (e.g., VFIO, which may pin all
+ * memory inside a #MemoryRegion), and require proper coordination to only
+ * map the currently populated parts, to hinder parts that are expected to
+ * remain discarded from silently getting populated and consuming memory.
+ * Technologies that support discarding of RAM don't have to bother and can
+ * simply map the whole #MemoryRegion.
+ *
+ * An example #RamDiscardSource is virtio-mem, which logically (un)plugs
+ * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
+ * Logically unplugging memory consists of discarding RAM. The VM agreed to not
+ * access unplugged (discarded) memory - especially via DMA. virtio-mem will
+ * properly coordinate with listeners before memory is plugged (populated),
+ * and after memory is unplugged (discarded).
+ *
+ * Listeners are called in multiples of the minimum granularity (unless it
+ * would exceed the registered range) and changes are aligned to the minimum
+ * granularity within the #MemoryRegion. Listeners have to prepare for memory
+ * becoming discarded in a different granularity than it was populated and the
+ * other way around.
+ */
+struct RamDiscardManager {
+    Object parent;
 
-    /**
-     * @unregister_listener:
-     *
-     * Unregister a previously registered #RamDiscardListener via the
-     * #RamDiscardManager after notifying the #RamDiscardListener about all
-     * populated parts becoming unpopulated within the registered
-     * #MemoryRegionSection.
-     *
-     * @rdm: the #RamDiscardManager
-     * @rdl: the #RamDiscardListener
-     */
-    void (*unregister_listener)(RamDiscardManager *rdm,
-                                RamDiscardListener *rdl);
+    RamDiscardSource *rds;
+    MemoryRegion *mr;
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
@@ -754,8 +747,8 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 /**
  * ram_discard_manager_replay_populated:
  *
- * A wrapper to call the #RamDiscardManagerClass.replay_populated callback
- * of the #RamDiscardManager.
+ * A wrapper to call the #RamDiscardSourceClass.replay_populated callback
+ * of the #RamDiscardSource sources.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
@@ -772,8 +765,8 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
 /**
  * ram_discard_manager_replay_discarded:
  *
- * A wrapper to call the #RamDiscardManagerClass.replay_discarded callback
- * of the #RamDiscardManager.
+ * A wrapper to call the #RamDiscardSourceClass.replay_discarded callback
+ * of the #RamDiscardSource sources.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
@@ -794,6 +787,34 @@ void ram_discard_manager_register_listener(RamDiscardManager *rdm,
 void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
                                              RamDiscardListener *rdl);
 
+/*
+ * Note: later refactoring should take the source into account and the manager
+ *       should be able to aggregate multiple sources.
+ */
+int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
+                                        uint64_t offset, uint64_t size);
+
+ /*
+  * Note: later refactoring should take the source into account and the manager
+  *       should be able to aggregate multiple sources.
+  */
+void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
+                                        uint64_t offset, uint64_t size);
+
+/*
+ * Note: later refactoring should take the source into account and the manager
+ *       should be able to aggregate multiple sources.
+ */
+void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm);
+
+/*
+ * Replay populated sections to all registered listeners.
+ *
+ * Note: later refactoring should take the source into account and the manager
+ *       should be able to aggregate multiple sources.
+ */
+int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm);
+
 /**
  * memory_translate_iotlb: Extract addresses from a TLB entry.
  *                         Called with rcu_read_lock held.
@@ -2535,18 +2556,22 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
 }
 
 /**
- * memory_region_set_ram_discard_manager: set the #RamDiscardManager for a
+ * memory_region_add_ram_discard_source: add a #RamDiscardSource for a
  * #MemoryRegion
  *
- * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
- * that does not cover RAM, or a #MemoryRegion that already has a
- * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
+ * @mr: the #MemoryRegion
+ * @rdm: #RamDiscardManager to set
+ */
+int memory_region_add_ram_discard_source(MemoryRegion *mr, RamDiscardSource *source);
+
+/**
+ * memory_region_del_ram_discard_source: remove a #RamDiscardSource for a
+ * #MemoryRegion
  *
  * @mr: the #MemoryRegion
  * @rdm: #RamDiscardManager to set
  */
-int memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                          RamDiscardManager *rdm);
+void memory_region_del_ram_discard_source(MemoryRegion *mr, RamDiscardSource *source);
 
 /**
  * memory_region_find: translate an address/size relative to a
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index e9f58ac0457..613beeb1e7d 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -99,11 +99,10 @@ struct RamBlockAttributes {
     /* 1-setting of the bitmap represents ram is populated (shared) */
     unsigned bitmap_size;
     unsigned long *bitmap;
-
-    QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
 /* @offset: the offset within the RAMBlock */
+
 int ram_block_discard_range(RAMBlock *rb, uint64_t offset, size_t length);
 /* @offset: the offset within the RAMBlock */
 int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index a4b71974a1c..be149ee9441 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -16,6 +16,7 @@
 #include "qemu/error-report.h"
 #include "qemu/units.h"
 #include "qemu/target-info-qapi.h"
+#include "system/memory.h"
 #include "system/numa.h"
 #include "system/system.h"
 #include "system/ramblock.h"
@@ -324,74 +325,31 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
     return ret;
 }
 
-static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
-{
-    RamDiscardListener *rdl = arg;
-
-    return rdl->notify_populate(rdl, s);
-}
-
 static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
                                      uint64_t size)
 {
-    RamDiscardListener *rdl;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
 
-    QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        rdl->notify_discard(rdl, &tmp);
-    }
+    ram_discard_manager_notify_discard(rdm, offset, size);
 }
 
 static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
                                   uint64_t size)
 {
-    RamDiscardListener *rdl, *rdl2;
-    int ret = 0;
-
-    QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
 
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        ret = rdl->notify_populate(rdl, &tmp);
-        if (ret) {
-            break;
-        }
-    }
-
-    if (ret) {
-        /* Notify all already-notified listeners. */
-        QLIST_FOREACH(rdl2, &vmem->rdl_list, next) {
-            MemoryRegionSection tmp = *rdl2->section;
-
-            if (rdl2 == rdl) {
-                break;
-            }
-            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-                continue;
-            }
-            rdl2->notify_discard(rdl2, &tmp);
-        }
-    }
-    return ret;
+    return ram_discard_manager_notify_populate(rdm, offset, size);
 }
 
 static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
 {
-    RamDiscardListener *rdl;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
 
     if (!vmem->size) {
         return;
     }
 
-    QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        rdl->notify_discard(rdl, rdl->section);
-    }
+    ram_discard_manager_notify_discard_all(rdm);
 }
 
 static bool virtio_mem_is_range_plugged(const VirtIOMEM *vmem,
@@ -1037,13 +995,9 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    /*
-     * Set ourselves as RamDiscardManager before the plug handler maps the
-     * memory region and exposes it via an address space.
-     */
-    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
-                                              RAM_DISCARD_MANAGER(vmem))) {
-        error_setg(errp, "Failed to set RamDiscardManager");
+    if (memory_region_add_ram_discard_source(&vmem->memdev->mr,
+                                             RAM_DISCARD_SOURCE(vmem))) {
+        error_setg(errp, "Failed to add RAM discard source");
         ram_block_coordinated_discard_require(false);
         return;
     }
@@ -1062,7 +1016,8 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
         if (ret) {
             error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
-            memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
+            memory_region_del_ram_discard_source(&vmem->memdev->mr,
+                                                 RAM_DISCARD_SOURCE(vmem));
             ram_block_coordinated_discard_require(false);
             return;
         }
@@ -1147,7 +1102,7 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
      * The unplug handler unmapped the memory region, it cannot be
      * found via an address space anymore. Unset ourselves.
      */
-    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
+    memory_region_del_ram_discard_source(&vmem->memdev->mr, RAM_DISCARD_SOURCE(vmem));
     ram_block_coordinated_discard_require(false);
 }
 
@@ -1175,9 +1130,7 @@ static int virtio_mem_activate_memslot_range_cb(VirtIOMEM *vmem, void *arg,
 
 static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
 {
-    RamDiscardListener *rdl;
-    int ret;
-
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(&vmem->memdev->mr);
     /*
      * We restored the bitmap and updated the requested size; activate all
      * memslots (so listeners register) before notifying about plugged blocks.
@@ -1195,14 +1148,7 @@ static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
      * We started out with all memory discarded and our memory region is mapped
      * into an address space. Replay, now that we updated the bitmap.
      */
-    QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
-                                                 virtio_mem_notify_populate_cb);
-        if (ret) {
-            return ret;
-        }
-    }
-    return 0;
+    return ram_discard_manager_replay_populated_to_listeners(rdm);
 }
 
 static int virtio_mem_post_load(void *opaque, int version_id)
@@ -1650,7 +1596,6 @@ static void virtio_mem_instance_init(Object *obj)
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
 
     notifier_list_init(&vmem->size_change_notifiers);
-    QLIST_INIT(&vmem->rdl_list);
 
     object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
                         NULL, NULL, NULL);
@@ -1694,19 +1639,19 @@ static const Property virtio_mem_legacy_guests_properties[] = {
                             unplugged_inaccessible, ON_OFF_AUTO_ON),
 };
 
-static uint64_t virtio_mem_rdm_get_min_granularity(const RamDiscardManager *rdm,
+static uint64_t virtio_mem_rds_get_min_granularity(const RamDiscardSource *rds,
                                                    const MemoryRegion *mr)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
 
     g_assert(mr == &vmem->memdev->mr);
     return vmem->block_size;
 }
 
-static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
+static bool virtio_mem_rds_is_populated(const RamDiscardSource *rds,
                                         const MemoryRegionSection *s)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
     uint64_t start_gpa = vmem->addr + s->offset_within_region;
     uint64_t end_gpa = start_gpa + int128_get64(s->size);
 
@@ -1727,19 +1672,19 @@ struct VirtIOMEMReplayData {
     void *opaque;
 };
 
-static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
+static int virtio_mem_rds_replay_cb(MemoryRegionSection *s, void *arg)
 {
     struct VirtIOMEMReplayData *data = arg;
 
     return data->fn(s, data->opaque);
 }
 
-static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
+static int virtio_mem_rds_replay_populated(const RamDiscardSource *rds,
                                            MemoryRegionSection *s,
                                            ReplayRamDiscardState replay_fn,
                                            void *opaque)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
     struct VirtIOMEMReplayData data = {
         .fn = replay_fn,
         .opaque = opaque,
@@ -1747,23 +1692,15 @@ static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
 
     g_assert(s->mr == &vmem->memdev->mr);
     return virtio_mem_for_each_plugged_section(vmem, s, &data,
-                                            virtio_mem_rdm_replay_populated_cb);
-}
-
-static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
-                                              void *arg)
-{
-    struct VirtIOMEMReplayData *data = arg;
-
-    return data->fn(s, data->opaque);
+                                            virtio_mem_rds_replay_cb);
 }
 
-static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
+static int virtio_mem_rds_replay_discarded(const RamDiscardSource *rds,
                                            MemoryRegionSection *s,
                                            ReplayRamDiscardState replay_fn,
                                            void *opaque)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
     struct VirtIOMEMReplayData data = {
         .fn = replay_fn,
         .opaque = opaque,
@@ -1771,41 +1708,7 @@ static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
 
     g_assert(s->mr == &vmem->memdev->mr);
     return virtio_mem_for_each_unplugged_section(vmem, s, &data,
-                                                 virtio_mem_rdm_replay_discarded_cb);
-}
-
-static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl,
-                                             MemoryRegionSection *s)
-{
-    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
-    int ret;
-
-    g_assert(s->mr == &vmem->memdev->mr);
-    rdl->section = memory_region_section_new_copy(s);
-
-    QLIST_INSERT_HEAD(&vmem->rdl_list, rdl, next);
-    ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
-                                              virtio_mem_notify_populate_cb);
-    if (ret) {
-        error_report("%s: Replaying plugged ranges failed: %s", __func__,
-                     strerror(-ret));
-    }
-}
-
-static void virtio_mem_rdm_unregister_listener(RamDiscardManager *rdm,
-                                               RamDiscardListener *rdl)
-{
-    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
-
-    g_assert(rdl->section->mr == &vmem->memdev->mr);
-    if (vmem->size) {
-        rdl->notify_discard(rdl, rdl->section);
-    }
-
-    memory_region_section_free_copy(rdl->section);
-    rdl->section = NULL;
-    QLIST_REMOVE(rdl, next);
+                                                 virtio_mem_rds_replay_cb);
 }
 
 static void virtio_mem_unplug_request_check(VirtIOMEM *vmem, Error **errp)
@@ -1837,7 +1740,7 @@ static void virtio_mem_class_init(ObjectClass *klass, const void *data)
     DeviceClass *dc = DEVICE_CLASS(klass);
     VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
     VirtIOMEMClass *vmc = VIRTIO_MEM_CLASS(klass);
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_CLASS(klass);
 
     device_class_set_props(dc, virtio_mem_properties);
     if (virtio_mem_has_legacy_guests()) {
@@ -1861,12 +1764,10 @@ static void virtio_mem_class_init(ObjectClass *klass, const void *data)
     vmc->remove_size_change_notifier = virtio_mem_remove_size_change_notifier;
     vmc->unplug_request_check = virtio_mem_unplug_request_check;
 
-    rdmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
-    rdmc->is_populated = virtio_mem_rdm_is_populated;
-    rdmc->replay_populated = virtio_mem_rdm_replay_populated;
-    rdmc->replay_discarded = virtio_mem_rdm_replay_discarded;
-    rdmc->register_listener = virtio_mem_rdm_register_listener;
-    rdmc->unregister_listener = virtio_mem_rdm_unregister_listener;
+    rdsc->get_min_granularity = virtio_mem_rds_get_min_granularity;
+    rdsc->is_populated = virtio_mem_rds_is_populated;
+    rdsc->replay_populated = virtio_mem_rds_replay_populated;
+    rdsc->replay_discarded = virtio_mem_rds_replay_discarded;
 }
 
 static const TypeInfo virtio_mem_info = {
@@ -1878,7 +1779,7 @@ static const TypeInfo virtio_mem_info = {
     .class_init = virtio_mem_class_init,
     .class_size = sizeof(VirtIOMEMClass),
     .interfaces = (const InterfaceInfo[]) {
-        { TYPE_RAM_DISCARD_MANAGER },
+        { TYPE_RAM_DISCARD_SOURCE },
         { }
     },
 };
diff --git a/system/memory.c b/system/memory.c
index c51d0798a84..3e7fd759692 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2105,34 +2105,88 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
     return mr->rdm;
 }
 
-int memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                          RamDiscardManager *rdm)
+static RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
+                                                  RamDiscardSource *rds)
+{
+    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(object_new(TYPE_RAM_DISCARD_MANAGER));
+
+    rdm->rds = rds;
+    rdm->mr = mr;
+    QLIST_INIT(&rdm->rdl_list);
+    return rdm;
+}
+
+int memory_region_add_ram_discard_source(MemoryRegion *mr,
+                                         RamDiscardSource *source)
 {
     g_assert(memory_region_is_ram(mr));
-    if (mr->rdm && rdm) {
+    if (mr->rdm) {
         return -EBUSY;
     }
 
-    mr->rdm = rdm;
+    mr->rdm = ram_discard_manager_new(mr, RAM_DISCARD_SOURCE(source));
     return 0;
 }
 
+void memory_region_del_ram_discard_source(MemoryRegion *mr,
+                                          RamDiscardSource *source)
+{
+    g_assert(mr->rdm->rds == source);
+
+    object_unref(mr->rdm);
+    mr->rdm = NULL;
+}
+
+static uint64_t ram_discard_source_get_min_granularity(const RamDiscardSource *rds,
+                                                       const MemoryRegion *mr)
+{
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+
+    g_assert(rdsc->get_min_granularity);
+    return rdsc->get_min_granularity(rds, mr);
+}
+
+static bool ram_discard_source_is_populated(const RamDiscardSource *rds,
+                                            const MemoryRegionSection *section)
+{
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+
+    g_assert(rdsc->is_populated);
+    return rdsc->is_populated(rds, section);
+}
+
+static int ram_discard_source_replay_populated(const RamDiscardSource *rds,
+                                               MemoryRegionSection *section,
+                                               ReplayRamDiscardState replay_fn,
+                                               void *opaque)
+{
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+
+    g_assert(rdsc->replay_populated);
+    return rdsc->replay_populated(rds, section, replay_fn, opaque);
+}
+
+static int ram_discard_source_replay_discarded(const RamDiscardSource *rds,
+                                               MemoryRegionSection *section,
+                                               ReplayRamDiscardState replay_fn,
+                                               void *opaque)
+{
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+
+    g_assert(rdsc->replay_discarded);
+    return rdsc->replay_discarded(rds, section, replay_fn, opaque);
+}
+
 uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
                                                  const MemoryRegion *mr)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
-
-    g_assert(rdmc->get_min_granularity);
-    return rdmc->get_min_granularity(rdm, mr);
+    return ram_discard_source_get_min_granularity(rdm->rds, mr);
 }
 
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
                                       const MemoryRegionSection *section)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
-
-    g_assert(rdmc->is_populated);
-    return rdmc->is_populated(rdm, section);
+    return ram_discard_source_is_populated(rdm->rds, section);
 }
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
@@ -2140,10 +2194,7 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
-
-    g_assert(rdmc->replay_populated);
-    return rdmc->replay_populated(rdm, section, replay_fn, opaque);
+    return ram_discard_source_replay_populated(rdm->rds, section, replay_fn, opaque);
 }
 
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
@@ -2151,29 +2202,133 @@ int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    return ram_discard_source_replay_discarded(rdm->rds, section, replay_fn, opaque);
+}
+
+static void ram_discard_manager_initfn(Object *obj)
+{
+    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
+
+    QLIST_INIT(&rdm->rdl_list);
+}
+
+static void ram_discard_manager_finalize(Object *obj)
+{
+    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
 
-    g_assert(rdmc->replay_discarded);
-    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
+    g_assert(QLIST_EMPTY(&rdm->rdl_list));
+}
+
+int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
+                                        uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        ret = rdl->notify_populate(rdl, &tmp);
+        if (ret) {
+            break;
+        }
+    }
+
+    if (ret) {
+        /* Notify all already-notified listeners about discard. */
+        QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
+            MemoryRegionSection tmp = *rdl2->section;
+
+            if (rdl2 == rdl) {
+                break;
+            }
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+            rdl2->notify_discard(rdl2, &tmp);
+        }
+    }
+    return ret;
+}
+
+void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
+                                        uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        rdl->notify_discard(rdl, &tmp);
+    }
+}
+
+void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        rdl->notify_discard(rdl, rdl->section);
+    }
+}
+
+static int rdm_populate_cb(MemoryRegionSection *section, void *opaque)
+{
+    RamDiscardListener *rdl = opaque;
+
+    return rdl->notify_populate(rdl, section);
 }
 
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
                                            MemoryRegionSection *section)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    int ret;
+
+    g_assert(section->mr == rdm->mr);
+
+    rdl->section = memory_region_section_new_copy(section);
+    QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
 
-    g_assert(rdmc->register_listener);
-    rdmc->register_listener(rdm, rdl, section);
+    ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
+                                              rdm_populate_cb, rdl);
+    if (ret) {
+        error_report("%s: Replaying populated ranges failed: %s", __func__,
+                     strerror(-ret));
+    }
 }
 
 void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
                                              RamDiscardListener *rdl)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    g_assert(rdl->section);
+    g_assert(rdl->section->mr == rdm->mr);
+
+    rdl->notify_discard(rdl, rdl->section);
+    memory_region_section_free_copy(rdl->section);
+    rdl->section = NULL;
+    QLIST_REMOVE(rdl, next);
+}
+
+int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm)
+{
+    RamDiscardListener *rdl;
+    int ret = 0;
 
-    g_assert(rdmc->unregister_listener);
-    rdmc->unregister_listener(rdm, rdl);
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
+                                                  rdm_populate_cb, rdl);
+        if (ret) {
+            break;
+        }
+    }
+    return ret;
 }
 
 /* Called with rcu_read_lock held.  */
@@ -3838,9 +3993,17 @@ static const TypeInfo iommu_memory_region_info = {
 };
 
 static const TypeInfo ram_discard_manager_info = {
-    .parent             = TYPE_INTERFACE,
+    .parent             = TYPE_OBJECT,
     .name               = TYPE_RAM_DISCARD_MANAGER,
-    .class_size         = sizeof(RamDiscardManagerClass),
+    .instance_size      = sizeof(RamDiscardManager),
+    .instance_init      = ram_discard_manager_initfn,
+    .instance_finalize  = ram_discard_manager_finalize,
+};
+
+static const TypeInfo ram_discard_source_info = {
+    .parent             = TYPE_INTERFACE,
+    .name               = TYPE_RAM_DISCARD_SOURCE,
+    .class_size         = sizeof(RamDiscardSourceClass),
 };
 
 static void memory_register_types(void)
@@ -3848,6 +4011,7 @@ static void memory_register_types(void)
     type_register_static(&memory_region_info);
     type_register_static(&iommu_memory_region_info);
     type_register_static(&ram_discard_manager_info);
+    type_register_static(&ram_discard_source_info);
 }
 
 type_init(memory_register_types)
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index 630b0fda126..ceb7066e6b9 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -18,7 +18,7 @@ OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
                                           ram_block_attributes,
                                           RAM_BLOCK_ATTRIBUTES,
                                           OBJECT,
-                                          { TYPE_RAM_DISCARD_MANAGER },
+                                          { TYPE_RAM_DISCARD_SOURCE },
                                           { })
 
 static size_t
@@ -32,35 +32,9 @@ ram_block_attributes_get_block_size(void)
     return qemu_real_host_page_size();
 }
 
-
-static bool
-ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section)
-{
-    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
-    const size_t block_size = ram_block_attributes_get_block_size();
-    const uint64_t first_bit = section->offset_within_region / block_size;
-    const uint64_t last_bit =
-        first_bit + int128_get64(section->size) / block_size - 1;
-    unsigned long first_discarded_bit;
-
-    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
-                                           first_bit);
-    return first_discarded_bit > last_bit;
-}
-
 typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
                                                void *arg);
 
-static int
-ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
-                                        void *arg)
-{
-    RamDiscardListener *rdl = arg;
-
-    return rdl->notify_populate(rdl, section);
-}
-
 static int
 ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
                                                 MemoryRegionSection *section,
@@ -144,93 +118,73 @@ ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
     return ret;
 }
 
-static uint64_t
-ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager *rdm,
-                                             const MemoryRegion *mr)
-{
-    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
 
-    g_assert(mr == attr->ram_block->mr);
-    return ram_block_attributes_get_block_size();
-}
+typedef struct RamBlockAttributesReplayData {
+    ReplayRamDiscardState fn;
+    void *opaque;
+} RamBlockAttributesReplayData;
 
-static void
-ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
-                                           RamDiscardListener *rdl,
-                                           MemoryRegionSection *section)
+static int ram_block_attributes_rds_replay_cb(MemoryRegionSection *section,
+                                              void *arg)
 {
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
-    int ret;
-
-    g_assert(section->mr == attr->ram_block->mr);
-    rdl->section = memory_region_section_new_copy(section);
-
-    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
+    RamBlockAttributesReplayData *data = arg;
 
-    ret = ram_block_attributes_for_each_populated_section(attr, section, rdl,
-                                    ram_block_attributes_notify_populate_cb);
-    if (ret) {
-        error_report("%s: Failed to register RAM discard listener: %s",
-                     __func__, strerror(-ret));
-        exit(1);
-    }
+    return data->fn(section, data->opaque);
 }
 
-static void
-ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl)
+/* RamDiscardSource interface implementation */
+static uint64_t
+ram_block_attributes_rds_get_min_granularity(const RamDiscardSource *rds,
+                                             const MemoryRegion *mr)
 {
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
 
-    g_assert(rdl->section);
-    g_assert(rdl->section->mr == attr->ram_block->mr);
-
-    rdl->notify_discard(rdl, rdl->section);
-
-    memory_region_section_free_copy(rdl->section);
-    rdl->section = NULL;
-    QLIST_REMOVE(rdl, next);
+    g_assert(mr == attr->ram_block->mr);
+    return ram_block_attributes_get_block_size();
 }
 
-typedef struct RamBlockAttributesReplayData {
-    ReplayRamDiscardState fn;
-    void *opaque;
-} RamBlockAttributesReplayData;
-
-static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection *section,
-                                              void *arg)
+static bool
+ram_block_attributes_rds_is_populated(const RamDiscardSource *rds,
+                                      const MemoryRegionSection *section)
 {
-    RamBlockAttributesReplayData *data = arg;
+    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
+    const size_t block_size = ram_block_attributes_get_block_size();
+    const uint64_t first_bit = section->offset_within_region / block_size;
+    const uint64_t last_bit =
+        first_bit + int128_get64(section->size) / block_size - 1;
+    unsigned long first_discarded_bit;
 
-    return data->fn(section, data->opaque);
+    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
+                                           first_bit);
+    return first_discarded_bit > last_bit;
 }
 
 static int
-ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
+ram_block_attributes_rds_replay_populated(const RamDiscardSource *rds,
                                           MemoryRegionSection *section,
                                           ReplayRamDiscardState replay_fn,
                                           void *opaque)
 {
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
     RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
 
     g_assert(section->mr == attr->ram_block->mr);
     return ram_block_attributes_for_each_populated_section(attr, section, &data,
-                                            ram_block_attributes_rdm_replay_cb);
+                                                           ram_block_attributes_rds_replay_cb);
 }
 
 static int
-ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
+ram_block_attributes_rds_replay_discarded(const RamDiscardSource *rds,
                                           MemoryRegionSection *section,
                                           ReplayRamDiscardState replay_fn,
                                           void *opaque)
 {
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
     RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
 
     g_assert(section->mr == attr->ram_block->mr);
     return ram_block_attributes_for_each_discarded_section(attr, section, &data,
-                                            ram_block_attributes_rdm_replay_cb);
+                                                           ram_block_attributes_rds_replay_cb);
 }
 
 static bool
@@ -257,42 +211,23 @@ ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
     return true;
 }
 
-static void ram_block_attributes_notify_discard(RamBlockAttributes *attr,
-                                                uint64_t offset,
-                                                uint64_t size)
+static void
+ram_block_attributes_notify_discard(RamBlockAttributes *attr,
+                                    uint64_t offset,
+                                    uint64_t size)
 {
-    RamDiscardListener *rdl;
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(attr->ram_block->mr);
 
-    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        rdl->notify_discard(rdl, &tmp);
-    }
+    ram_discard_manager_notify_discard(rdm, offset, size);
 }
 
 static int
 ram_block_attributes_notify_populate(RamBlockAttributes *attr,
                                      uint64_t offset, uint64_t size)
 {
-    RamDiscardListener *rdl;
-    int ret = 0;
-
-    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        ret = rdl->notify_populate(rdl, &tmp);
-        if (ret) {
-            break;
-        }
-    }
+    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(attr->ram_block->mr);
 
-    return ret;
+    return ram_discard_manager_notify_populate(rdm, offset, size);
 }
 
 int ram_block_attributes_state_change(RamBlockAttributes *attr,
@@ -376,7 +311,8 @@ RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
     attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
 
     attr->ram_block = ram_block;
-    if (memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr))) {
+
+    if (memory_region_add_ram_discard_source(mr, RAM_DISCARD_SOURCE(attr))) {
         object_unref(OBJECT(attr));
         return NULL;
     }
@@ -391,15 +327,12 @@ void ram_block_attributes_destroy(RamBlockAttributes *attr)
     g_assert(attr);
 
     g_free(attr->bitmap);
-    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
+    memory_region_del_ram_discard_source(attr->ram_block->mr, RAM_DISCARD_SOURCE(attr));
     object_unref(OBJECT(attr));
 }
 
 static void ram_block_attributes_init(Object *obj)
 {
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
-
-    QLIST_INIT(&attr->rdl_list);
 }
 
 static void ram_block_attributes_finalize(Object *obj)
@@ -409,12 +342,10 @@ static void ram_block_attributes_finalize(Object *obj)
 static void ram_block_attributes_class_init(ObjectClass *klass,
                                             const void *data)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
-
-    rdmc->get_min_granularity = ram_block_attributes_rdm_get_min_granularity;
-    rdmc->register_listener = ram_block_attributes_rdm_register_listener;
-    rdmc->unregister_listener = ram_block_attributes_rdm_unregister_listener;
-    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
-    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
-    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
+    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_CLASS(klass);
+
+    rdsc->get_min_granularity = ram_block_attributes_rds_get_min_granularity;
+    rdsc->is_populated = ram_block_attributes_rds_is_populated;
+    rdsc->replay_populated = ram_block_attributes_rds_replay_populated;
+    rdsc->replay_discarded = ram_block_attributes_rds_replay_discarded;
 }
-- 
2.52.0


