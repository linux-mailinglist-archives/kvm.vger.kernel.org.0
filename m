Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5BF1DB348
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgETMco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726870AbgETMco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 08:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mt6i0iRa8ceKFX3EkuTML686/jeI27NNRV5WKW+uffE=;
        b=DPMFsPuuIYNEncRXwf98a5PareFGilgOn43nf2MGTy1y5/Jaa+p41kyYbNpn1AHCVFqX9P
        SX9dOZJZfPe6cdkOQxC2x/j+e4MqkCpIOoCXVV9BLZ+xIrF0x7VPspXoLBfkLePoUOCce/
        lAImCuPta19QmEgUizEfqN3H56IbW4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-XE27Q_jKNaqC4su7L2k_4A-1; Wed, 20 May 2020 08:32:29 -0400
X-MC-Unique: XE27Q_jKNaqC4su7L2k_4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0703B8018AD;
        Wed, 20 May 2020 12:32:28 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB9076AD0E;
        Wed, 20 May 2020 12:32:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: [PATCH v2 05/19] virtio-balloon: Rip out qemu_balloon_inhibit()
Date:   Wed, 20 May 2020 14:31:38 +0200
Message-Id: <20200520123152.60527-6-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only remaining special case is postcopy. It cannot handle
concurrent discards yet, which would result in requesting already sent
pages from the source. Special-case it in virtio-balloon instead.

Introduce migration_in_incoming_postcopy(), to find out if incoming
postcopy is active.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 balloon.c                  | 18 ------------------
 hw/virtio/virtio-balloon.c |  8 +++++++-
 include/migration/misc.h   |  2 ++
 include/sysemu/balloon.h   |  2 --
 migration/migration.c      |  7 +++++++
 migration/postcopy-ram.c   | 23 -----------------------
 6 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/balloon.c b/balloon.c
index 5fff79523a..354408c6ea 100644
--- a/balloon.c
+++ b/balloon.c
@@ -36,24 +36,6 @@
 static QEMUBalloonEvent *balloon_event_fn;
 static QEMUBalloonStatus *balloon_stat_fn;
 static void *balloon_opaque;
-static int balloon_inhibit_count;
-
-bool qemu_balloon_is_inhibited(void)
-{
-    return atomic_read(&balloon_inhibit_count) > 0 ||
-           ram_block_discard_is_disabled();
-}
-
-void qemu_balloon_inhibit(bool state)
-{
-    if (state) {
-        atomic_inc(&balloon_inhibit_count);
-    } else {
-        atomic_dec(&balloon_inhibit_count);
-    }
-
-    assert(atomic_read(&balloon_inhibit_count) >= 0);
-}
 
 static bool have_balloon(Error **errp)
 {
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 065cd450f1..0a8e71db05 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -63,6 +63,12 @@ static bool virtio_balloon_pbp_matches(PartiallyBalloonedPage *pbp,
     return pbp->base_gpa == base_gpa;
 }
 
+static bool virtio_balloon_inhibited(void)
+{
+    /* Postcopy cannot deal with concurrent discards (yet), so it's special. */
+    return ram_block_discard_is_disabled() || migration_in_incoming_postcopy();
+}
+
 static void balloon_inflate_page(VirtIOBalloon *balloon,
                                  MemoryRegion *mr, hwaddr mr_offset,
                                  PartiallyBalloonedPage *pbp)
@@ -360,7 +366,7 @@ static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 
             trace_virtio_balloon_handle_output(memory_region_name(section.mr),
                                                pa);
-            if (!qemu_balloon_is_inhibited()) {
+            if (!virtio_balloon_inhibited()) {
                 if (vq == s->ivq) {
                     balloon_inflate_page(s, section.mr,
                                          section.offset_within_region, &pbp);
diff --git a/include/migration/misc.h b/include/migration/misc.h
index d2762257aa..34e7d75713 100644
--- a/include/migration/misc.h
+++ b/include/migration/misc.h
@@ -69,6 +69,8 @@ bool migration_has_failed(MigrationState *);
 /* ...and after the device transmission */
 bool migration_in_postcopy_after_devices(MigrationState *);
 void migration_global_dump(Monitor *mon);
+/* True if incomming migration entered POSTCOPY_INCOMING_DISCARD */
+bool migration_in_incoming_postcopy(void);
 
 /* migration/block-dirty-bitmap.c */
 void dirty_bitmap_mig_init(void);
diff --git a/include/sysemu/balloon.h b/include/sysemu/balloon.h
index aea0c44985..20a2defe3a 100644
--- a/include/sysemu/balloon.h
+++ b/include/sysemu/balloon.h
@@ -23,7 +23,5 @@ typedef void (QEMUBalloonStatus)(void *opaque, BalloonInfo *info);
 int qemu_add_balloon_handler(QEMUBalloonEvent *event_func,
                              QEMUBalloonStatus *stat_func, void *opaque);
 void qemu_remove_balloon_handler(void *opaque);
-bool qemu_balloon_is_inhibited(void);
-void qemu_balloon_inhibit(bool state);
 
 #endif
diff --git a/migration/migration.c b/migration/migration.c
index 0bb042a0f7..06000ef136 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -1772,6 +1772,13 @@ bool migration_in_postcopy_after_devices(MigrationState *s)
     return migration_in_postcopy() && s->postcopy_after_devices;
 }
 
+bool migration_in_incoming_postcopy(void)
+{
+    PostcopyState ps = postcopy_state_get();
+
+    return ps >= POSTCOPY_INCOMING_DISCARD && ps < POSTCOPY_INCOMING_END;
+}
+
 bool migration_is_idle(void)
 {
     MigrationState *s = current_migration;
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index a36402722b..b41a9fe2fd 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -27,7 +27,6 @@
 #include "qemu/notify.h"
 #include "qemu/rcu.h"
 #include "sysemu/sysemu.h"
-#include "sysemu/balloon.h"
 #include "qemu/error-report.h"
 #include "trace.h"
 #include "hw/boards.h"
@@ -520,20 +519,6 @@ int postcopy_ram_incoming_init(MigrationIncomingState *mis)
     return 0;
 }
 
-/*
- * Manage a single vote to the QEMU balloon inhibitor for all postcopy usage,
- * last caller wins.
- */
-static void postcopy_balloon_inhibit(bool state)
-{
-    static bool cur_state = false;
-
-    if (state != cur_state) {
-        qemu_balloon_inhibit(state);
-        cur_state = state;
-    }
-}
-
 /*
  * At the end of a migration where postcopy_ram_incoming_init was called.
  */
@@ -565,8 +550,6 @@ int postcopy_ram_incoming_cleanup(MigrationIncomingState *mis)
         mis->have_fault_thread = false;
     }
 
-    postcopy_balloon_inhibit(false);
-
     if (enable_mlock) {
         if (os_mlock() < 0) {
             error_report("mlock: %s", strerror(errno));
@@ -1160,12 +1143,6 @@ int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
     }
     memset(mis->postcopy_tmp_zero_page, '\0', mis->largest_page_size);
 
-    /*
-     * Ballooning can mark pages as absent while we're postcopying
-     * that would cause false userfaults.
-     */
-    postcopy_balloon_inhibit(true);
-
     trace_postcopy_ram_enable_notify();
 
     return 0;
-- 
2.25.4

