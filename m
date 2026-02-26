Return-Path: <kvm+bounces-71990-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPYEH4tVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71990-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C38711A7524
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 539D4312B22D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532623D4138;
	Thu, 26 Feb 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9sNs3rS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8BF3B52EA
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114452; cv=none; b=cNROLkjKvWPiK0lwTHktEEHGJtFg9uRIqYdal2+0NiNIq17AV3+CzfsYZOykEhyyl/+uRJRTTHW967Zm9uKHXNOOkndVIXeMrZe4GKIbxZ3KnGqW+6XMyMP7gFSFNOQeb7HpzOUmfwbu8e/YLblgTVFZggqdjLj7tEbJ9oORYsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114452; c=relaxed/simple;
	bh=VoAjia3x6JImOmC6RSHCbKeaYBPZgTx1PbSA3vxeBhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyrZ6KZ5j79m2I3B93qj3AhzxxWyIi3ZR5RJyaRU8XHu6ox38sKx/Ytl9ZGcLF3rm6hHaBlHH+bynDtKx/J7d/Ntvn1LtWog8kGE/HpFYMshNLxg32mbH3UndxrRQbrikNoHli9tp2rt44rUPKLwHR5cdoUPea7UEiicPS7VVWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9sNs3rS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0nd8w74Eg1MZwcVqt9ubuzj/ONkZRtMKFKv1IXrpoA=;
	b=T9sNs3rSDSRDSABrVhED8e9HsahTXW/EMxryRHpP2Y8ORFho5wGaNmbLqKDe0iElAG9zR/
	Ac+OaV5FIkSiN8pydjr3BtCx+uIJJSS+uZQ5QXpuowFjVyVQkWZN4nlDhwHVZp0aN2pd9k
	m3jlqQQWiU8KOZmO25jtsLlCvWZ+Tjc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-82LJ4GjdPg6jNFUvPy69eA-1; Thu,
 26 Feb 2026 09:00:34 -0500
X-MC-Unique: 82LJ4GjdPg6jNFUvPy69eA-1
X-Mimecast-MFC-AGG-ID: 82LJ4GjdPg6jNFUvPy69eA_1772114433
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D7E319560AD;
	Thu, 26 Feb 2026 14:00:33 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE9C219560B5;
	Thu, 26 Feb 2026 14:00:31 +0000 (UTC)
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
Subject: [PATCH v3 08/15] system/memory: constify section arguments
Date: Thu, 26 Feb 2026 14:59:53 +0100
Message-ID: <20260226140001.3622334-9-marcandre.lureau@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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
	TAGGED_FROM(0.00)[bounces-71990-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C38711A7524
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

The sections shouldn't be modified.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 include/hw/vfio/vfio-container.h     |  2 +-
 include/hw/vfio/vfio-cpr.h           |  2 +-
 include/system/ram-discard-manager.h | 14 +++++++-------
 hw/vfio/cpr-legacy.c                 |  4 ++--
 hw/vfio/listener.c                   | 10 +++++-----
 hw/virtio/virtio-mem.c               | 10 +++++-----
 migration/ram.c                      |  6 +++---
 system/memory_mapping.c              |  4 ++--
 system/ram-block-attributes.c        |  8 ++++----
 system/ram-discard-manager.c         | 10 +++++-----
 10 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/hw/vfio/vfio-container.h b/include/hw/vfio/vfio-container.h
index a7d5c5ed679..b2e7f4312c3 100644
--- a/include/hw/vfio/vfio-container.h
+++ b/include/hw/vfio/vfio-container.h
@@ -277,7 +277,7 @@ struct VFIOIOMMUClass {
 };
 
 VFIORamDiscardListener *vfio_find_ram_discard_listener(
-    VFIOContainer *bcontainer, MemoryRegionSection *section);
+    VFIOContainer *bcontainer, const MemoryRegionSection *section);
 
 void vfio_container_region_add(VFIOContainer *bcontainer,
                                MemoryRegionSection *section, bool cpr_remap);
diff --git a/include/hw/vfio/vfio-cpr.h b/include/hw/vfio/vfio-cpr.h
index 4606da500a7..ecabe0c747d 100644
--- a/include/hw/vfio/vfio-cpr.h
+++ b/include/hw/vfio/vfio-cpr.h
@@ -69,7 +69,7 @@ void vfio_cpr_giommu_remap(struct VFIOContainer *bcontainer,
                            MemoryRegionSection *section);
 
 bool vfio_cpr_ram_discard_replay_populated(
-    struct VFIOContainer *bcontainer, MemoryRegionSection *section);
+    struct VFIOContainer *bcontainer, const MemoryRegionSection *section);
 
 void vfio_cpr_save_vector_fd(struct VFIOPCIDevice *vdev, const char *name,
                              int nr, int fd);
diff --git a/include/system/ram-discard-manager.h b/include/system/ram-discard-manager.h
index da55658169f..b188e09a30f 100644
--- a/include/system/ram-discard-manager.h
+++ b/include/system/ram-discard-manager.h
@@ -26,9 +26,9 @@ DECLARE_OBJ_CHECKERS(RamDiscardSource, RamDiscardSourceClass,
 
 typedef struct RamDiscardListener RamDiscardListener;
 typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
+                                 const MemoryRegionSection *section);
 typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
+                                 const MemoryRegionSection *section);
 
 struct RamDiscardListener {
     /*
@@ -86,7 +86,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
  *
  * Returns 0 on success, or a negative error if failed.
  */
-typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
+typedef int (*ReplayRamDiscardState)(const MemoryRegionSection *section,
                                      void *opaque);
 
 /*
@@ -151,7 +151,7 @@ struct RamDiscardSourceClass {
      * Returns 0 on success, or a negative error if any notification failed.
      */
     int (*replay_populated)(const RamDiscardSource *rds,
-                            MemoryRegionSection *section,
+                            const MemoryRegionSection *section,
                             ReplayRamDiscardState replay_fn, void *opaque);
 
     /**
@@ -168,7 +168,7 @@ struct RamDiscardSourceClass {
      * Returns 0 on success, or a negative error if any notification failed.
      */
     int (*replay_discarded)(const RamDiscardSource *rds,
-                            MemoryRegionSection *section,
+                            const MemoryRegionSection *section,
                             ReplayRamDiscardState replay_fn, void *opaque);
 };
 
@@ -237,7 +237,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
  * Returns 0 on success, or a negative error if any notification failed.
  */
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
+                                         const MemoryRegionSection *section,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque);
 
@@ -255,7 +255,7 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
  * Returns 0 on success, or a negative error if any notification failed.
  */
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
+                                         const MemoryRegionSection *section,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque);
 
diff --git a/hw/vfio/cpr-legacy.c b/hw/vfio/cpr-legacy.c
index 033a546c301..cca7dd08dfc 100644
--- a/hw/vfio/cpr-legacy.c
+++ b/hw/vfio/cpr-legacy.c
@@ -226,7 +226,7 @@ void vfio_cpr_giommu_remap(VFIOContainer *bcontainer,
     memory_region_iommu_replay(giommu->iommu_mr, &giommu->n);
 }
 
-static int vfio_cpr_rdm_remap(MemoryRegionSection *section, void *opaque)
+static int vfio_cpr_rdm_remap(const MemoryRegionSection *section, void *opaque)
 {
     RamDiscardListener *rdl = opaque;
 
@@ -242,7 +242,7 @@ static int vfio_cpr_rdm_remap(MemoryRegionSection *section, void *opaque)
  * directly, which calls vfio_legacy_cpr_dma_map.
  */
 bool vfio_cpr_ram_discard_replay_populated(VFIOContainer *bcontainer,
-                                           MemoryRegionSection *section)
+                                           const MemoryRegionSection *section)
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
     VFIORamDiscardListener *vrdl =
diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
index 960da9e0a93..d24780e089d 100644
--- a/hw/vfio/listener.c
+++ b/hw/vfio/listener.c
@@ -203,7 +203,7 @@ out:
 }
 
 static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
-                                            MemoryRegionSection *section)
+                                            const MemoryRegionSection *section)
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
@@ -221,7 +221,7 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
 }
 
 static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
-                                            MemoryRegionSection *section)
+                                            const MemoryRegionSection *section)
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
@@ -465,7 +465,7 @@ static void vfio_device_error_append(VFIODevice *vbasedev, Error **errp)
 }
 
 VFIORamDiscardListener *vfio_find_ram_discard_listener(
-    VFIOContainer *bcontainer, MemoryRegionSection *section)
+    VFIOContainer *bcontainer, const MemoryRegionSection *section)
 {
     VFIORamDiscardListener *vrdl = NULL;
 
@@ -1147,8 +1147,8 @@ out:
     }
 }
 
-static int vfio_ram_discard_query_dirty_bitmap(MemoryRegionSection *section,
-                                             void *opaque)
+static int vfio_ram_discard_query_dirty_bitmap(const MemoryRegionSection *section,
+                                               void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
     const hwaddr iova = section->offset_within_address_space;
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index be149ee9441..ec165503205 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -262,7 +262,7 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
 typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
 
 static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
-                                               MemoryRegionSection *s,
+                                               const MemoryRegionSection *s,
                                                void *arg,
                                                virtio_mem_section_cb cb)
 {
@@ -294,7 +294,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
 }
 
 static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
-                                                 MemoryRegionSection *s,
+                                                 const MemoryRegionSection *s,
                                                  void *arg,
                                                  virtio_mem_section_cb cb)
 {
@@ -1680,7 +1680,7 @@ static int virtio_mem_rds_replay_cb(MemoryRegionSection *s, void *arg)
 }
 
 static int virtio_mem_rds_replay_populated(const RamDiscardSource *rds,
-                                           MemoryRegionSection *s,
+                                           const MemoryRegionSection *s,
                                            ReplayRamDiscardState replay_fn,
                                            void *opaque)
 {
@@ -1692,11 +1692,11 @@ static int virtio_mem_rds_replay_populated(const RamDiscardSource *rds,
 
     g_assert(s->mr == &vmem->memdev->mr);
     return virtio_mem_for_each_plugged_section(vmem, s, &data,
-                                            virtio_mem_rds_replay_cb);
+                                               virtio_mem_rds_replay_cb);
 }
 
 static int virtio_mem_rds_replay_discarded(const RamDiscardSource *rds,
-                                           MemoryRegionSection *s,
+                                           const MemoryRegionSection *s,
                                            ReplayRamDiscardState replay_fn,
                                            void *opaque)
 {
diff --git a/migration/ram.c b/migration/ram.c
index fc7ece2c1a1..57237385300 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -860,7 +860,7 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
     return ret;
 }
 
-static int dirty_bitmap_clear_section(MemoryRegionSection *section,
+static int dirty_bitmap_clear_section(const MemoryRegionSection *section,
                                       void *opaque)
 {
     const hwaddr offset = section->offset_within_region;
@@ -1595,7 +1595,7 @@ static inline void populate_read_range(RAMBlock *block, ram_addr_t offset,
     }
 }
 
-static inline int populate_read_section(MemoryRegionSection *section,
+static inline int populate_read_section(const MemoryRegionSection *section,
                                         void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
@@ -1670,7 +1670,7 @@ void ram_write_tracking_prepare(void)
     }
 }
 
-static inline int uffd_protect_section(MemoryRegionSection *section,
+static inline int uffd_protect_section(const MemoryRegionSection *section,
                                        void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
diff --git a/system/memory_mapping.c b/system/memory_mapping.c
index da708a08ab7..cacef504f68 100644
--- a/system/memory_mapping.c
+++ b/system/memory_mapping.c
@@ -196,7 +196,7 @@ typedef struct GuestPhysListener {
 } GuestPhysListener;
 
 static void guest_phys_block_add_section(GuestPhysListener *g,
-                                         MemoryRegionSection *section)
+                                         const MemoryRegionSection *section)
 {
     const hwaddr target_start = section->offset_within_address_space;
     const hwaddr target_end = target_start + int128_get64(section->size);
@@ -248,7 +248,7 @@ static void guest_phys_block_add_section(GuestPhysListener *g,
 #endif
 }
 
-static int guest_phys_ram_populate_cb(MemoryRegionSection *section,
+static int guest_phys_ram_populate_cb(const MemoryRegionSection *section,
                                       void *opaque)
 {
     GuestPhysListener *g = opaque;
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index ceb7066e6b9..e921e09f5b3 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -37,7 +37,7 @@ typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
 
 static int
 ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
-                                                MemoryRegionSection *section,
+                                                const MemoryRegionSection *section,
                                                 void *arg,
                                                 ram_block_attributes_section_cb cb)
 {
@@ -78,7 +78,7 @@ ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
 
 static int
 ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
-                                                MemoryRegionSection *section,
+                                                const MemoryRegionSection *section,
                                                 void *arg,
                                                 ram_block_attributes_section_cb cb)
 {
@@ -161,7 +161,7 @@ ram_block_attributes_rds_is_populated(const RamDiscardSource *rds,
 
 static int
 ram_block_attributes_rds_replay_populated(const RamDiscardSource *rds,
-                                          MemoryRegionSection *section,
+                                          const MemoryRegionSection *section,
                                           ReplayRamDiscardState replay_fn,
                                           void *opaque)
 {
@@ -175,7 +175,7 @@ ram_block_attributes_rds_replay_populated(const RamDiscardSource *rds,
 
 static int
 ram_block_attributes_rds_replay_discarded(const RamDiscardSource *rds,
-                                          MemoryRegionSection *section,
+                                          const MemoryRegionSection *section,
                                           ReplayRamDiscardState replay_fn,
                                           void *opaque)
 {
diff --git a/system/ram-discard-manager.c b/system/ram-discard-manager.c
index 3d8c85617d7..1c9ff7fda58 100644
--- a/system/ram-discard-manager.c
+++ b/system/ram-discard-manager.c
@@ -28,7 +28,7 @@ static bool ram_discard_source_is_populated(const RamDiscardSource *rds,
 }
 
 static int ram_discard_source_replay_populated(const RamDiscardSource *rds,
-                                               MemoryRegionSection *section,
+                                               const MemoryRegionSection *section,
                                                ReplayRamDiscardState replay_fn,
                                                void *opaque)
 {
@@ -39,7 +39,7 @@ static int ram_discard_source_replay_populated(const RamDiscardSource *rds,
 }
 
 static int ram_discard_source_replay_discarded(const RamDiscardSource *rds,
-                                               MemoryRegionSection *section,
+                                               const MemoryRegionSection *section,
                                                ReplayRamDiscardState replay_fn,
                                                void *opaque)
 {
@@ -74,7 +74,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 }
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
+                                         const MemoryRegionSection *section,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
@@ -83,7 +83,7 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
 }
 
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
+                                         const MemoryRegionSection *section,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
@@ -164,7 +164,7 @@ void ram_discard_manager_notify_discard_all(RamDiscardManager *rdm)
     }
 }
 
-static int rdm_populate_cb(MemoryRegionSection *section, void *opaque)
+static int rdm_populate_cb(const MemoryRegionSection *section, void *opaque)
 {
     RamDiscardListener *rdl = opaque;
 
-- 
2.53.0


