Return-Path: <kvm+bounces-71991-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNc/E/1WoGn4iQQAu9opvQ
	(envelope-from <kvm+bounces-71991-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB21A1A76A7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3E04430A7DB4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E90937417B;
	Thu, 26 Feb 2026 14:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evtaDKR2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D0E3815F3
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114453; cv=none; b=c/yKDoRMV2dLz2cxMthf+evwqEg6bsoYGxCdzsAe3CELrqbdQsKGe5MuHYKt+anBpwM2eaoR9GH0fM+bWdU+MngjnK3LxWI/eIpD4xoxjPRg5ZZyTkTgO4sT/JMFw7CWJCyb18QtB6HGJbvb4g28V/PbUBG7s8wN5MBhurJQEJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114453; c=relaxed/simple;
	bh=0fhGVe1wLdQmS+97bdXSxFW+svgkAbQgxV3Xl4c20fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCmU+fPESiXerX9644wSBTQdKcjDqHvSBnkZ4iuMIRslWIt90mX20rmMfjQt9OGWPnSCSeh/LNzu/lVlwpoY/ZRZCT3AOQFxtitC+4gdHtNCtSCZTb+HMgELPlSn/v3VeDAv0pFE8AH+8OOiGwfZYJ7+ksAaicMWhhAwufdJ2F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evtaDKR2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXYnbdQyIwBONsl+rO+1NpKwtNwPjj8Hi2z+cNrS7zU=;
	b=evtaDKR2ATPuUxwrwOaaLKbKAzYc80gySjRuMIB400PvD/FnBStxxTvp/cxLHGhSpkFUZK
	lhDwpon/uxeYdISdM3vsdxkJoth81iTmMpozJ8qn54ikLZrCF2etZnayNbRLldrdjRY57F
	0HnlSA0lKZRAsjIh0i28mo60D9nz1p8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-fisDdXWDO0uZBI5AE8J7oA-1; Thu,
 26 Feb 2026 09:00:38 -0500
X-MC-Unique: fisDdXWDO0uZBI5AE8J7oA-1
X-Mimecast-MFC-AGG-ID: fisDdXWDO0uZBI5AE8J7oA_1772114437
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F50E1800464;
	Thu, 26 Feb 2026 14:00:37 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF2551800370;
	Thu, 26 Feb 2026 14:00:35 +0000 (UTC)
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
Subject: [PATCH v3 09/15] system/ram-discard-manager: implement replay via is_populated iteration
Date: Thu, 26 Feb 2026 14:59:54 +0100
Message-ID: <20260226140001.3622334-10-marcandre.lureau@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71991-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB21A1A76A7
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Replace the source-level replay wrappers with a new
replay_by_populated_state() helper that iterates the section at
min-granularity, calls is_populated() for each chunk, and aggregates
consecutive chunks of the same state before invoking the callback.

This moves the iteration logic from individual sources into the manager,
preparing for multi-source aggregation where the manager must combine
state from multiple sources anyway.

The replay_populated/replay_discarded vtable entries in
RamDiscardSourceClass are no longer called but remain in the interface
for now; they will be removed in follow-up commits along with the
now-dead source implementations.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 system/ram-discard-manager.c | 85 ++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 24 deletions(-)

diff --git a/system/ram-discard-manager.c b/system/ram-discard-manager.c
index 1c9ff7fda58..25beb052a1e 100644
--- a/system/ram-discard-manager.c
+++ b/system/ram-discard-manager.c
@@ -27,26 +27,65 @@ static bool ram_discard_source_is_populated(const RamDiscardSource *rds,
     return rdsc->is_populated(rds, section);
 }
 
-static int ram_discard_source_replay_populated(const RamDiscardSource *rds,
-                                               const MemoryRegionSection *section,
-                                               ReplayRamDiscardState replay_fn,
-                                               void *opaque)
+/*
+ * Iterate the section at source granularity, aggregating consecutive chunks
+ * with matching populated state, and call replay_fn for each run.
+ */
+static int replay_by_populated_state(const RamDiscardManager *rdm,
+                                     const MemoryRegionSection *section,
+                                     bool replay_populated,
+                                     ReplayRamDiscardState replay_fn,
+                                     void *opaque)
 {
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+    uint64_t granularity, offset, size, end, pos, run_start;
+    bool in_run = false;
+    int ret = 0;
 
-    g_assert(rdsc->replay_populated);
-    return rdsc->replay_populated(rds, section, replay_fn, opaque);
-}
+    granularity = ram_discard_source_get_min_granularity(rdm->rds, rdm->mr);
+    offset = section->offset_within_region;
+    size = int128_get64(section->size);
+    end = offset + size;
+
+    /* Align iteration to granularity boundaries */
+    pos = QEMU_ALIGN_DOWN(offset, granularity);
+
+    for (; pos < end; pos += granularity) {
+        MemoryRegionSection chunk = {
+            .mr = section->mr,
+            .offset_within_region = pos,
+            .size = int128_make64(granularity),
+        };
+        bool populated = ram_discard_source_is_populated(rdm->rds, &chunk);
+
+        if (populated == replay_populated) {
+            if (!in_run) {
+                run_start = pos;
+                in_run = true;
+            }
+        } else if (in_run) {
+            MemoryRegionSection tmp = *section;
+
+            if (memory_region_section_intersect_range(&tmp, run_start,
+                                                      pos - run_start)) {
+                ret = replay_fn(&tmp, opaque);
+                if (ret) {
+                    return ret;
+                }
+            }
+            in_run = false;
+        }
+    }
 
-static int ram_discard_source_replay_discarded(const RamDiscardSource *rds,
-                                               const MemoryRegionSection *section,
-                                               ReplayRamDiscardState replay_fn,
-                                               void *opaque)
-{
-    RamDiscardSourceClass *rdsc = RAM_DISCARD_SOURCE_GET_CLASS(rds);
+    if (in_run) {
+        MemoryRegionSection tmp = *section;
 
-    g_assert(rdsc->replay_discarded);
-    return rdsc->replay_discarded(rds, section, replay_fn, opaque);
+        if (memory_region_section_intersect_range(&tmp, run_start,
+                                                  pos - run_start)) {
+            ret = replay_fn(&tmp, opaque);
+        }
+    }
+
+    return ret;
 }
 
 RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
@@ -78,8 +117,7 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    return ram_discard_source_replay_populated(rdm->rds, section,
-                                               replay_fn, opaque);
+    return replay_by_populated_state(rdm, section, true, replay_fn, opaque);
 }
 
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
@@ -87,8 +125,7 @@ int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
                                          ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
-    return ram_discard_source_replay_discarded(rdm->rds, section,
-                                               replay_fn, opaque);
+    return replay_by_populated_state(rdm, section, false, replay_fn, opaque);
 }
 
 static void ram_discard_manager_initfn(Object *obj)
@@ -182,8 +219,8 @@ void ram_discard_manager_register_listener(RamDiscardManager *rdm,
     rdl->section = memory_region_section_new_copy(section);
     QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
 
-    ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
-                                              rdm_populate_cb, rdl);
+    ret = ram_discard_manager_replay_populated(rdm, rdl->section,
+                                               rdm_populate_cb, rdl);
     if (ret) {
         error_report("%s: Replaying populated ranges failed: %s", __func__,
                      strerror(-ret));
@@ -208,8 +245,8 @@ int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm)
     int ret = 0;
 
     QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
-        ret = ram_discard_source_replay_populated(rdm->rds, rdl->section,
-                                                  rdm_populate_cb, rdl);
+        ret = ram_discard_manager_replay_populated(rdm, rdl->section,
+                                                   rdm_populate_cb, rdl);
         if (ret) {
             break;
         }
-- 
2.53.0


