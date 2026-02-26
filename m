Return-Path: <kvm+bounces-71989-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FA/LIpVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71989-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDA51A751A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E39B5312A0BE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34EE3AE6FB;
	Thu, 26 Feb 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OyJSa/hE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9C37417B
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114450; cv=none; b=iwH2vm5xgoPA/eBKIWiClkDvSB4NmG9abbgaDUYJ1EwIH/bFeMLscJyo07PZJiCyOLU+L4IMhlHTtnIcEPaoXI/RkViluL2uSbLrtxYoXiQb78agkoiqdXDdHiJMI+DmtDidvDC7x3e4AaxEo1p7XlWMCYjSwBorI3Rhvrrn0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114450; c=relaxed/simple;
	bh=Jtp5Ct81ooBKKbvc2Q08liAfRq8kqs6ukWnZbQvnu2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LX99hApqd2SrLyM1lSTzuUwLTZJFEmWP3FcJN51PvD5w94U9HcyXMUU8mrL0Y4sGDlt/I7E71YUmGT9Lodu05ki4GdB5AnshaEc+vYYtZh4Lo4QCrDAt6UdAkJUATJaBHlueR4MvBtFpIQ11EebNHp+zA4WsLLn39j6YFrxVAJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OyJSa/hE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gpikEJy3RABIScqn8IgScPg5JclxedEK06kswTF6OGM=;
	b=OyJSa/hEzcxtjlkpTCTPO0vI5piwzc+p9ZKPtXq1wOauXOOrVCy4iedliEYUJ09dfqeY0P
	LrYXYhFEkHNDTdjgpOguj2bNRYHQZjfgaQEzUcwOjANheqq01/cYcMv46RbADQKR4bYtYi
	1i/LGCvUSjgzh83IebtA25A/98Uza5Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-fpJa0IxNOtGg5bubQY5XNQ-1; Thu,
 26 Feb 2026 09:00:31 -0500
X-MC-Unique: fpJa0IxNOtGg5bubQY5XNQ-1
X-Mimecast-MFC-AGG-ID: fpJa0IxNOtGg5bubQY5XNQ_1772114429
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3188180025B;
	Thu, 26 Feb 2026 14:00:29 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E556A1956053;
	Thu, 26 Feb 2026 14:00:27 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v3 07/15] system/memory: move RamDiscardManager to separate compilation unit
Date: Thu, 26 Feb 2026 14:59:52 +0100
Message-ID: <20260226140001.3622334-8-marcandre.lureau@redhat.com>
In-Reply-To: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71989-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CDA51A751A
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Extract RamDiscardManager and RamDiscardSource from system/memory.c into
dedicated a unit.

This reduces coupling and allows code that only needs the
RamDiscardManager interface to avoid pulling in all of memory.h
dependencies.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/system/memory.h              | 280 +------------------------
 include/system/ram-discard-manager.h | 297 +++++++++++++++++++++++++++
 system/memory.c                      | 221 --------------------
 system/ram-discard-manager.c         | 240 ++++++++++++++++++++++
 system/meson.build                   |   1 +
 5 files changed, 539 insertions(+), 500 deletions(-)
 create mode 100644 include/system/ram-discard-manager.h
 create mode 100644 system/ram-discard-manager.c

diff --git a/include/system/memory.h b/include/system/memory.h
index c7d161f9441..69105c13695 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -16,6 +16,7 @@
 
 #include "exec/hwaddr.h"
 #include "system/ram_addr.h"
+#include "system/ram-discard-manager.h"
 #include "exec/memattrs.h"
 #include "exec/memop.h"
 #include "qemu/bswap.h"
@@ -48,18 +49,6 @@ typedef struct IOMMUMemoryRegionClass IOMMUMemoryRegionClass;
 DECLARE_OBJ_CHECKERS(IOMMUMemoryRegion, IOMMUMemoryRegionClass,
                      IOMMU_MEMORY_REGION, TYPE_IOMMU_MEMORY_REGION)
 
-#define TYPE_RAM_DISCARD_MANAGER "ram-discard-manager"
-typedef struct RamDiscardManagerClass RamDiscardManagerClass;
-typedef struct RamDiscardManager RamDiscardManager;
-DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
-                     RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
-
-#define TYPE_RAM_DISCARD_SOURCE "ram-discard-source"
-typedef struct RamDiscardSourceClass RamDiscardSourceClass;
-typedef struct RamDiscardSource RamDiscardSource;
-DECLARE_OBJ_CHECKERS(RamDiscardSource, RamDiscardSourceClass,
-                     RAM_DISCARD_SOURCE, TYPE_RAM_DISCARD_SOURCE);
-
 #ifdef CONFIG_FUZZ
 void fuzz_dma_read_cb(size_t addr,
                       size_t len,
@@ -548,273 +537,6 @@ struct IOMMUMemoryRegionClass {
     int (*num_indexes)(IOMMUMemoryRegion *iommu);
 };
 
-typedef struct RamDiscardListener RamDiscardListener;
-typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
-typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
-
-struct RamDiscardListener {
-    /*
-     * @notify_populate:
-     *
-     * Notification that previously discarded memory is about to get populated.
-     * Listeners are able to object. If any listener objects, already
-     * successfully notified listeners are notified about a discard again.
-     *
-     * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get populated. The section
-     *           is aligned within the memory region to the minimum granularity
-     *           unless it would exceed the registered section.
-     *
-     * Returns 0 on success. If the notification is rejected by the listener,
-     * an error is returned.
-     */
-    NotifyRamPopulate notify_populate;
-
-    /*
-     * @notify_discard:
-     *
-     * Notification that previously populated memory was discarded successfully
-     * and listeners should drop all references to such memory and prevent
-     * new population (e.g., unmap).
-     *
-     * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get discarded. The section
-     *           is aligned within the memory region to the minimum granularity
-     *           unless it would exceed the registered section.
-     */
-    NotifyRamDiscard notify_discard;
-
-    MemoryRegionSection *section;
-    QLIST_ENTRY(RamDiscardListener) next;
-};
-
-static inline void ram_discard_listener_init(RamDiscardListener *rdl,
-                                             NotifyRamPopulate populate_fn,
-                                             NotifyRamDiscard discard_fn)
-{
-    rdl->notify_populate = populate_fn;
-    rdl->notify_discard = discard_fn;
-}
-
-/**
- * typedef ReplayRamDiscardState:
- *
- * The callback handler for #RamDiscardSourceClass.replay_populated/
- * #RamDiscardSourceClass.replay_discarded to invoke on populated/discarded
- * parts.
- *
- * @section: the #MemoryRegionSection of populated/discarded part
- * @opaque: pointer to forward to the callback
- *
- * Returns 0 on success, or a negative error if failed.
- */
-typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
-                                     void *opaque);
-
-/*
- * RamDiscardSourceClass:
- *
- * A #RamDiscardSource provides information about which parts of a specific
- * RAM #MemoryRegion are currently populated (accessible) vs discarded.
- *
- * This is an interface that state providers (like virtio-mem or
- * RamBlockAttributes) implement to provide discard state information. A
- * #RamDiscardManager wraps sources and manages listener registrations and
- * notifications.
- */
-struct RamDiscardSourceClass {
-    /* private */
-    InterfaceClass parent_class;
-
-    /* public */
-
-    /**
-     * @get_min_granularity:
-     *
-     * Get the minimum granularity in which listeners will get notified
-     * about changes within the #MemoryRegion via the #RamDiscardSource.
-     *
-     * @rds: the #RamDiscardSource
-     * @mr: the #MemoryRegion
-     *
-     * Returns the minimum granularity.
-     */
-    uint64_t (*get_min_granularity)(const RamDiscardSource *rds,
-                                    const MemoryRegion *mr);
-
-    /**
-     * @is_populated:
-     *
-     * Check whether the given #MemoryRegionSection is completely populated
-     * (i.e., no parts are currently discarded) via the #RamDiscardSource.
-     * There are no alignment requirements.
-     *
-     * @rds: the #RamDiscardSource
-     * @section: the #MemoryRegionSection
-     *
-     * Returns whether the given range is completely populated.
-     */
-    bool (*is_populated)(const RamDiscardSource *rds,
-                         const MemoryRegionSection *section);
-
-    /**
-     * @replay_populated:
-     *
-     * Call the #ReplayRamDiscardState callback for all populated parts within
-     * the #MemoryRegionSection via the #RamDiscardSource.
-     *
-     * In case any call fails, no further calls are made.
-     *
-     * @rds: the #RamDiscardSource
-     * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamDiscardState callback
-     * @opaque: pointer to forward to the callback
-     *
-     * Returns 0 on success, or a negative error if any notification failed.
-     */
-    int (*replay_populated)(const RamDiscardSource *rds,
-                            MemoryRegionSection *section,
-                            ReplayRamDiscardState replay_fn, void *opaque);
-
-    /**
-     * @replay_discarded:
-     *
-     * Call the #ReplayRamDiscardState callback for all discarded parts within
-     * the #MemoryRegionSection via the #RamDiscardSource.
-     *
-     * @rds: the #RamDiscardSource
-     * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamDiscardState callback
-     * @opaque: pointer to forward to the callback
-     *
-     * Returns 0 on success, or a negative error if any notification failed.
-     */
-    int (*replay_discarded)(const RamDiscardSource *rds,
-                            MemoryRegionSection *section,
-                            ReplayRamDiscardState replay_fn, void *opaque);
-};
-
-/**
- * RamDiscardManager:
- *
- * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
- * regions are currently populated to be used/accessed by the VM, notifying
- * after parts were discarded (freeing up memory) and before parts will be
- * populated (consuming memory), to be used/accessed by the VM.
- *
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
- * An example #RamDiscardSource is virtio-mem, which logically (un)plugs
- * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
- * Logically unplugging memory consists of discarding RAM. The VM agreed to not
- * access unplugged (discarded) memory - especially via DMA. virtio-mem will
- * properly coordinate with listeners before memory is plugged (populated),
- * and after memory is unplugged (discarded).
- *
- * Listeners are called in multiples of the minimum granularity (unless it
- * would exceed the registered range) and changes are aligned to the minimum
- * granularity within the #MemoryRegion. Listeners have to prepare for memory
- * becoming discarded in a different granularity than it was populated and the
- * other way around.
- */
-struct RamDiscardManager {
-    Object parent;
-
-    RamDiscardSource *rds;
-    MemoryRegion *mr;
-    QLIST_HEAD(, RamDiscardListener) rdl_list;
-};
-
-uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-                                                 const MemoryRegion *mr);
-
-bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section);
-
-/**
- * ram_discard_manager_replay_populated:
- *
- * A wrapper to call the #RamDiscardSourceClass.replay_populated callback
- * of the #RamDiscardSource sources.
- *
- * @rdm: the #RamDiscardManager
- * @section: the #MemoryRegionSection
- * @replay_fn: the #ReplayRamDiscardState callback
- * @opaque: pointer to forward to the callback
- *
- * Returns 0 on success, or a negative error if any notification failed.
- */
-int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayRamDiscardState replay_fn,
-                                         void *opaque);
-
-/**
- * ram_discard_manager_replay_discarded:
- *
- * A wrapper to call the #RamDiscardSourceClass.replay_discarded callback
- * of the #RamDiscardSource sources.
- *
- * @rdm: the #RamDiscardManager
- * @section: the #MemoryRegionSection
- * @replay_fn: the #ReplayRamDiscardState callback
- * @opaque: pointer to forward to the callback
- *
- * Returns 0 on success, or a negative error if any notification failed.
- */
-int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayRamDiscardState replay_fn,
-                                         void *opaque);
-
-void ram_discard_manager_register_listener(RamDiscardManager *rdm,
-                                           RamDiscardListener *rdl,
-                                           MemoryRegionSection *section);
-
-void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl);
-
-/*
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
- */
-int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
-                                        uint64_t offset, uint64_t size);
-
- /*
-  * Note: later refactoring should take the source into account and the manager
-  *       should be able to aggregate multiple sources.
-  */
-void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
-                                        uint64_t offset, uint64_t size);
-
-/*
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
- */
-void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm);
-
-/*
- * Replay populated sections to all registered listeners.
- *
- * Note: later refactoring should take the source into account and the manager
- *       should be able to aggregate multiple sources.
- */
-int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm);
-
 /**
  * memory_translate_iotlb: Extract addresses from a TLB entry.
  *                         Called with rcu_read_lock held.
diff --git a/include/system/ram-discard-manager.h b/include/system/ram-discard-manager.h
new file mode 100644
index 00000000000..da55658169f
--- /dev/null
+++ b/include/system/ram-discard-manager.h
@@ -0,0 +1,297 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * RAM Discard Manager
+ *
+ * Copyright Red Hat, Inc. 2026
+ */
+
+#ifndef RAM_DISCARD_MANAGER_H
+#define RAM_DISCARD_MANAGER_H
+
+#include "qemu/typedefs.h"
+#include "qom/object.h"
+#include "qemu/queue.h"
+
+#define TYPE_RAM_DISCARD_MANAGER "ram-discard-manager"
+typedef struct RamDiscardManagerClass RamDiscardManagerClass;
+typedef struct RamDiscardManager RamDiscardManager;
+DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
+                     RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
+
+#define TYPE_RAM_DISCARD_SOURCE "ram-discard-source"
+typedef struct RamDiscardSourceClass RamDiscardSourceClass;
+typedef struct RamDiscardSource RamDiscardSource;
+DECLARE_OBJ_CHECKERS(RamDiscardSource, RamDiscardSourceClass,
+                     RAM_DISCARD_SOURCE, TYPE_RAM_DISCARD_SOURCE);
+
+typedef struct RamDiscardListener RamDiscardListener;
+typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
+                                 MemoryRegionSection *section);
+typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
+                                 MemoryRegionSection *section);
+
+struct RamDiscardListener {
+    /*
+     * @notify_populate:
+     *
+     * Notification that previously discarded memory is about to get populated.
+     * Listeners are able to object. If any listener objects, already
+     * successfully notified listeners are notified about a discard again.
+     *
+     * @rdl: the #RamDiscardListener getting notified
+     * @section: the #MemoryRegionSection to get populated. The section
+     *           is aligned within the memory region to the minimum granularity
+     *           unless it would exceed the registered section.
+     *
+     * Returns 0 on success. If the notification is rejected by the listener,
+     * an error is returned.
+     */
+    NotifyRamPopulate notify_populate;
+
+    /*
+     * @notify_discard:
+     *
+     * Notification that previously populated memory was discarded successfully
+     * and listeners should drop all references to such memory and prevent
+     * new population (e.g., unmap).
+     *
+     * @rdl: the #RamDiscardListener getting notified
+     * @section: the #MemoryRegionSection to get discarded. The section
+     *           is aligned within the memory region to the minimum granularity
+     *           unless it would exceed the registered section.
+     */
+    NotifyRamDiscard notify_discard;
+
+    MemoryRegionSection *section;
+    QLIST_ENTRY(RamDiscardListener) next;
+};
+
+static inline void ram_discard_listener_init(RamDiscardListener *rdl,
+                                             NotifyRamPopulate populate_fn,
+                                             NotifyRamDiscard discard_fn)
+{
+    rdl->notify_populate = populate_fn;
+    rdl->notify_discard = discard_fn;
+}
+
+/**
+ * typedef ReplayRamDiscardState:
+ *
+ * The callback handler for #RamDiscardSourceClass.replay_populated/
+ * #RamDiscardSourceClass.replay_discarded to invoke on populated/discarded
+ * parts.
+ *
+ * @section: the #MemoryRegionSection of populated/discarded part
+ * @opaque: pointer to forward to the callback
+ *
+ * Returns 0 on success, or a negative error if failed.
+ */
+typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
+                                     void *opaque);
+
+/*
+ * RamDiscardSourceClass:
+ *
+ * A #RamDiscardSource provides information about which parts of a specific
+ * RAM #MemoryRegion are currently populated (accessible) vs discarded.
+ *
+ * This is an interface that state providers (like virtio-mem or
+ * RamBlockAttributes) implement to provide discard state information. A
+ * #RamDiscardManager wraps sources and manages listener registrations and
+ * notifications.
+ */
+struct RamDiscardSourceClass {
+    /* private */
+    InterfaceClass parent_class;
+
+    /* public */
+
+    /**
+     * @get_min_granularity:
+     *
+     * Get the minimum granularity in which listeners will get notified
+     * about changes within the #MemoryRegion via the #RamDiscardSource.
+     *
+     * @rds: the #RamDiscardSource
+     * @mr: the #MemoryRegion
+     *
+     * Returns the minimum granularity.
+     */
+    uint64_t (*get_min_granularity)(const RamDiscardSource *rds,
+                                    const MemoryRegion *mr);
+
+    /**
+     * @is_populated:
+     *
+     * Check whether the given #MemoryRegionSection is completely populated
+     * (i.e., no parts are currently discarded) via the #RamDiscardSource.
+     * There are no alignment requirements.
+     *
+     * @rds: the #RamDiscardSource
+     * @section: the #MemoryRegionSection
+     *
+     * Returns whether the given range is completely populated.
+     */
+    bool (*is_populated)(const RamDiscardSource *rds,
+                         const MemoryRegionSection *section);
+
+    /**
+     * @replay_populated:
+     *
+     * Call the #ReplayRamDiscardState callback for all populated parts within
+     * the #MemoryRegionSection via the #RamDiscardSource.
+     *
+     * In case any call fails, no further calls are made.
+     *
+     * @rds: the #RamDiscardSource
+     * @section: the #MemoryRegionSection
+     * @replay_fn: the #ReplayRamDiscardState callback
+     * @opaque: pointer to forward to the callback
+     *
+     * Returns 0 on success, or a negative error if any notification failed.
+     */
+    int (*replay_populated)(const RamDiscardSource *rds,
+                            MemoryRegionSection *section,
+                            ReplayRamDiscardState replay_fn, void *opaque);
+
+    /**
+     * @replay_discarded:
+     *
+     * Call the #ReplayRamDiscardState callback for all discarded parts within
+     * the #MemoryRegionSection via the #RamDiscardSource.
+     *
+     * @rds: the #RamDiscardSource
+     * @section: the #MemoryRegionSection
+     * @replay_fn: the #ReplayRamDiscardState callback
+     * @opaque: pointer to forward to the callback
+     *
+     * Returns 0 on success, or a negative error if any notification failed.
+     */
+    int (*replay_discarded)(const RamDiscardSource *rds,
+                            MemoryRegionSection *section,
+                            ReplayRamDiscardState replay_fn, void *opaque);
+};
+
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
+
+    RamDiscardSource *rds;
+    MemoryRegion *mr;
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
+};
+
+RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
+                                           RamDiscardSource *rds);
+
+uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
+                                                 const MemoryRegion *mr);
+
+bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
+                                      const MemoryRegionSection *section);
+
+/**
+ * ram_discard_manager_replay_populated:
+ *
+ * A wrapper to call the #RamDiscardSourceClass.replay_populated callback
+ * of the #RamDiscardSource sources.
+ *
+ * @rdm: the #RamDiscardManager
+ * @section: the #MemoryRegionSection
+ * @replay_fn: the #ReplayRamDiscardState callback
+ * @opaque: pointer to forward to the callback
+ *
+ * Returns 0 on success, or a negative error if any notification failed.
+ */
+int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque);
+
+/**
+ * ram_discard_manager_replay_discarded:
+ *
+ * A wrapper to call the #RamDiscardSourceClass.replay_discarded callback
+ * of the #RamDiscardSource sources.
+ *
+ * @rdm: the #RamDiscardManager
+ * @section: the #MemoryRegionSection
+ * @replay_fn: the #ReplayRamDiscardState callback
+ * @opaque: pointer to forward to the callback
+ *
+ * Returns 0 on success, or a negative error if any notification failed.
+ */
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque);
+
+void ram_discard_manager_register_listener(RamDiscardManager *rdm,
+                                           RamDiscardListener *rdl,
+                                           MemoryRegionSection *section);
+
+void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
+                                             RamDiscardListener *rdl);
+
+/*
+ * Note: later refactoring should take the source into account and the manager
+ *       should be able to aggregate multiple sources.
+ */
+int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
+                                        uint64_t offset, uint64_t size);
+
+/*
+ * Note: later refactoring should take the source into account and the manager
+ *       should be able to aggregate multiple sources.
+ */
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
+#endif /* RAM_DISCARD_MANAGER_H */
diff --git a/system/memory.c b/system/memory.c
index 3e7fd759692..8b46cb87838 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2105,17 +2105,6 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
     return mr->rdm;
 }
 
-static RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
-                                                  RamDiscardSource *rds)
-{
-    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(object_new(TYPE_RAM_DISCARD_MANAGER));
-
-    rdm->rds = rds;
-    rdm->mr = mr;
-    QLIST_INIT(&rdm->rdl_list);
-    return rdm;
-}
-
 int memory_region_add_ram_discard_source(MemoryRegion *mr,
                                          RamDiscardSource *source)
 {
@@ -2137,200 +2126,6 @@ void memory_region_del_ram_discard_source(MemoryRegion *mr,
     mr->rdm = NULL;
 }
 
-static uint64_t ram_discard_source_get_min_granularity(const RamDiscardSource *rds,
-                                                       const MemoryRegion *mr)
-{
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
-
-    g_assert(rdsc->get_min_granularity);
-    return rdsc->get_min_granularity(rds, mr);
-}
-
-static bool ram_discard_source_is_populated(const RamDiscardSource *rds,
-                                            const MemoryRegionSection *section)
-{
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
-
-    g_assert(rdsc->is_populated);
-    return rdsc->is_populated(rds, section);
-}
-
-static int ram_discard_source_replay_populated(const RamDiscardSource *rds,
-                                               MemoryRegionSection *section,
-                                               ReplayRamDiscardState replay_fn,
-                                               void *opaque)
-{
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
-
-    g_assert(rdsc->replay_populated);
-    return rdsc->replay_populated(rds, section, replay_fn, opaque);
-}
-
-static int ram_discard_source_replay_discarded(const RamDiscardSource *rds,
-                                               MemoryRegionSection *section,
-                                               ReplayRamDiscardState replay_fn,
-                                               void *opaque)
-{
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
-
-    g_assert(rdsc->replay_discarded);
-    return rdsc->replay_discarded(rds, section, replay_fn, opaque);
-}
-
-uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-                                                 const MemoryRegion *mr)
-{
-    return ram_discard_source_get_min_granularity(rdm->rds, mr);
-}
-
-bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section)
-{
-    return ram_discard_source_is_populated(rdm->rds, section);
-}
-
-int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayRamDiscardState replay_fn,
-                                         void *opaque)
-{
-    return ram_discard_source_replay_populated(rdm->rds, section, replay_fn, opaque);
-}
-
-int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayRamDiscardState replay_fn,
-                                         void *opaque)
-{
-    return ram_discard_source_replay_discarded(rdm->rds, section, replay_fn, opaque);
-}
-
-static void ram_discard_manager_initfn(Object *obj)
-{
-    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
-
-    QLIST_INIT(&rdm->rdl_list);
-}
-
-static void ram_discard_manager_finalize(Object *obj)
-{
-    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
-
-    g_assert(QLIST_EMPTY(&rdm->rdl_list));
-}
-
-int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
-                                        uint64_t offset, uint64_t size)
-{
-    RamDiscardListener *rdl, *rdl2;
-    int ret = 0;
-
-    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
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
-
-    if (ret) {
-        /* Notify all already-notified listeners about discard. */
-        QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
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
-}
-
-void ram_discard_manager_notify_discard(RamDiscardManager *rdm,
-                                        uint64_t offset, uint64_t size)
-{
-    RamDiscardListener *rdl;
-
-    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            continue;
-        }
-        rdl->notify_discard(rdl, &tmp);
-    }
-}
-
-void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm)
-{
-    RamDiscardListener *rdl;
-
-    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        rdl->notify_discard(rdl, rdl->section);
-    }
-}
-
-static int rdm_populate_cb(MemoryRegionSection *section, void *opaque)
-{
-    RamDiscardListener *rdl = opaque;
-
-    return rdl->notify_populate(rdl, section);
-}
-
-void ram_discard_manager_register_listener(RamDiscardManager *rdm,
-                                           RamDiscardListener *rdl,
-                                           MemoryRegionSection *section)
-{
-    int ret;
-
-    g_assert(section->mr == rdm->mr);
-
-    rdl->section = memory_region_section_new_copy(section);
-    QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
-
-    ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
-                                              rdm_populate_cb, rdl);
-    if (ret) {
-        error_report("%s: Replaying populated ranges failed: %s", __func__,
-                     strerror(-ret));
-    }
-}
-
-void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl)
-{
-    g_assert(rdl->section);
-    g_assert(rdl->section->mr == rdm->mr);
-
-    rdl->notify_discard(rdl, rdl->section);
-    memory_region_section_free_copy(rdl->section);
-    rdl->section = NULL;
-    QLIST_REMOVE(rdl, next);
-}
-
-int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm)
-{
-    RamDiscardListener *rdl;
-    int ret = 0;
-
-    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
-                                                  rdm_populate_cb, rdl);
-        if (ret) {
-            break;
-        }
-    }
-    return ret;
-}
-
 /* Called with rcu_read_lock held.  */
 MemoryRegion *memory_translate_iotlb(IOMMUTLBEntry *iotlb, hwaddr *xlat_p,
                                      Error **errp)
@@ -3992,26 +3787,10 @@ static const TypeInfo iommu_memory_region_info = {
     .abstract           = true,
 };
 
-static const TypeInfo ram_discard_manager_info = {
-    .parent             = TYPE_OBJECT,
-    .name               = TYPE_RAM_DISCARD_MANAGER,
-    .instance_size      = sizeof(RamDiscardManager),
-    .instance_init      = ram_discard_manager_initfn,
-    .instance_finalize  = ram_discard_manager_finalize,
-};
-
-static const TypeInfo ram_discard_source_info = {
-    .parent             = TYPE_INTERFACE,
-    .name               = TYPE_RAM_DISCARD_SOURCE,
-    .class_size         = sizeof(RamDiscardSourceClass),
-};
-
 static void memory_register_types(void)
 {
     type_register_static(&memory_region_info);
     type_register_static(&iommu_memory_region_info);
-    type_register_static(&ram_discard_manager_info);
-    type_register_static(&ram_discard_source_info);
 }
 
 type_init(memory_register_types)
diff --git a/system/ram-discard-manager.c b/system/ram-discard-manager.c
new file mode 100644
index 00000000000..3d8c85617d7
--- /dev/null
+++ b/system/ram-discard-manager.c
@@ -0,0 +1,240 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * RAM Discard Manager
+ *
+ * Copyright Red Hat, Inc. 2026
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "system/memory.h"
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
+RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
+                                           RamDiscardSource *rds)
+{
+    RamDiscardManager *rdm;
+
+    rdm = RAM_DISCARD_MANAGER(object_new(TYPE_RAM_DISCARD_MANAGER));
+    rdm->rds = rds;
+    rdm->mr = mr;
+    QLIST_INIT(&rdm->rdl_list);
+    return rdm;
+}
+
+uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
+                                                 const MemoryRegion *mr)
+{
+    return ram_discard_source_get_min_granularity(rdm->rds, mr);
+}
+
+bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
+                                      const MemoryRegionSection *section)
+{
+    return ram_discard_source_is_populated(rdm->rds, section);
+}
+
+int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque)
+{
+    return ram_discard_source_replay_populated(rdm->rds, section,
+                                               replay_fn, opaque);
+}
+
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque)
+{
+    return ram_discard_source_replay_discarded(rdm->rds, section,
+                                               replay_fn, opaque);
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
+
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
+}
+
+void ram_discard_manager_register_listener(RamDiscardManager *rdm,
+                                           RamDiscardListener *rdl,
+                                           MemoryRegionSection *section)
+{
+    int ret;
+
+    g_assert(section->mr == rdm->mr);
+
+    rdl->section = memory_region_section_new_copy(section);
+    QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
+
+    ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
+                                              rdm_populate_cb, rdl);
+    if (ret) {
+        error_report("%s: Replaying populated ranges failed: %s", __func__,
+                     strerror(-ret));
+    }
+}
+
+void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
+                                             RamDiscardListener *rdl)
+{
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
+
+    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
+        ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
+                                                  rdm_populate_cb, rdl);
+        if (ret) {
+            break;
+        }
+    }
+    return ret;
+}
+
+static const TypeInfo ram_discard_manager_info = {
+    .parent             = TYPE_OBJECT,
+    .name               = TYPE_RAM_DISCARD_MANAGER,
+    .instance_size      = sizeof(RamDiscardManager),
+    .instance_init      = ram_discard_manager_initfn,
+    .instance_finalize  = ram_discard_manager_finalize,
+};
+
+static const TypeInfo ram_discard_source_info = {
+    .parent             = TYPE_INTERFACE,
+    .name               = TYPE_RAM_DISCARD_SOURCE,
+    .class_size         = sizeof(RamDiscardSourceClass),
+};
+
+static void ram_discard_manager_register_types(void)
+{
+    type_register_static(&ram_discard_manager_info);
+    type_register_static(&ram_discard_source_info);
+}
+
+type_init(ram_discard_manager_register_types)
diff --git a/system/meson.build b/system/meson.build
index 035f0ae7de4..87387486223 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -18,6 +18,7 @@ system_ss.add(files(
   'globals.c',
   'ioport.c',
   'ram-block-attributes.c',
+  'ram-discard-manager.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.53.0


