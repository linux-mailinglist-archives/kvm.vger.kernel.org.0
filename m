Return-Path: <kvm+bounces-71993-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBewCIZVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71993-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B12001A750C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5DEFA30AB17C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38A33A4F3A;
	Thu, 26 Feb 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XlW085Lh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345C12135AD
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114458; cv=none; b=L1c4b0/nwKz8WtoCd3yUa2s6S09RPqxuZD/96W2CLJkOBlra8QjKDu9T6l2+wq0BYXcGyWvuj4PB4/qhERkKxi7GA7qmJcpz1GkF7Tt0tWWPYJNGlwjrFis8LDlA5z2jDXGct5RPftgpDH5smLM4YKsvgW+qV43zDticN3G0YJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114458; c=relaxed/simple;
	bh=TlQc338n0J+6SC6E+LWbRhonIKEqIMSdITlyXWSTUu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYVP+wrGtmQSskJhUrIsuqwQLcdEDcfvL48kHT6KAvhH0MswBM4i7NRwto0TkLIf4weOh9osk+gG1CZ/0aKE88UGJt1itWTcpmgBSZ8P0rSTDJHWgmpcMBcpr7+Wfn8aHcdXmsTvsobaEv3ubu6rUZQCL7b+6PvnK5WNAa16gBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XlW085Lh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaPxp1WEdRt0jnZCBSLHJX1sxKAQNNgjpbASlQsTY/o=;
	b=XlW085LhDyjOonIqbhKEKQDCr/NAMRqrRW+2nvYa2CT59yPQxnQn6SFzepZw68ePlKUstu
	yO0cbnNM8ulZESt++kBRrR09tzq9W40sp+s8PJTKo4OtI3xPEm7aaTURV9VUuPBPw0vmGO
	A3Dtl7X/5Jc0SWgbI//6O3lYGgtzXwc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-psG25dyUPuaBt4FDWhuJzQ-1; Thu,
 26 Feb 2026 09:00:43 -0500
X-MC-Unique: psG25dyUPuaBt4FDWhuJzQ-1
X-Mimecast-MFC-AGG-ID: psG25dyUPuaBt4FDWhuJzQ_1772114442
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 548371956046;
	Thu, 26 Feb 2026 14:00:42 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FBFB1956056;
	Thu, 26 Feb 2026 14:00:41 +0000 (UTC)
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
Subject: [PATCH v3 11/15] system/ram-discard-manager: drop replay from source interface
Date: Thu, 26 Feb 2026 14:59:56 +0100
Message-ID: <20260226140001.3622334-12-marcandre.lureau@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71993-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: B12001A750C
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Remove replay_populated and replay_discarded from RamDiscardSourceClass
now that the RamDiscardManager handles replay iteration internally via
is_populated.

Remove the now-dead replay methods, helpers, and
for_each_populated/discarded_section() from ram-block-attributes, which
was the last source still carrying this code.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/system/ram-discard-manager.h |  52 +++--------
 system/ram-block-attributes.c        | 130 ---------------------------
 2 files changed, 10 insertions(+), 172 deletions(-)

diff --git a/include/system/ram-discard-manager.h b/include/system/ram-discard-manager.h
index b188e09a30f..b5dbcb4a82d 100644
--- a/include/system/ram-discard-manager.h
+++ b/include/system/ram-discard-manager.h
@@ -77,8 +77,8 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
 /**
  * typedef ReplayRamDiscardState:
  *
- * The callback handler for #RamDiscardSourceClass.replay_populated/
- * #RamDiscardSourceClass.replay_discarded to invoke on populated/discarded
+ * The callback handler used by ram_discard_manager_replay_populated() and
+ * ram_discard_manager_replay_discarded() to invoke on populated/discarded
  * parts.
  *
  * @section: the #MemoryRegionSection of populated/discarded part
@@ -134,42 +134,6 @@ struct RamDiscardSourceClass {
      */
     bool (*is_populated)(const RamDiscardSource *rds,
                          const MemoryRegionSection *section);
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
-                            const MemoryRegionSection *section,
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
-                            const MemoryRegionSection *section,
-                            ReplayRamDiscardState replay_fn, void *opaque);
 };
 
 /**
@@ -226,8 +190,10 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 /**
  * ram_discard_manager_replay_populated:
  *
- * A wrapper to call the #RamDiscardSourceClass.replay_populated callback
- * of the #RamDiscardSource sources.
+ * Iterate the given #MemoryRegionSection at minimum granularity, calling
+ * #RamDiscardSourceClass.is_populated for each chunk, and invoke @replay_fn
+ * for each contiguous populated range. In case any call fails, no further
+ * calls are made.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
@@ -244,8 +210,10 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
 /**
  * ram_discard_manager_replay_discarded:
  *
- * A wrapper to call the #RamDiscardSourceClass.replay_discarded callback
- * of the #RamDiscardSource sources.
+ * Iterate the given #MemoryRegionSection at minimum granularity, calling
+ * #RamDiscardSourceClass.is_populated for each chunk, and invoke @replay_fn
+ * for each contiguous discarded range. In case any call fails, no further
+ * calls are made.
  *
  * @rdm: the #RamDiscardManager
  * @section: the #MemoryRegionSection
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index e921e09f5b3..718c7075cec 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -32,106 +32,6 @@ ram_block_attributes_get_block_size(void)
     return qemu_real_host_page_size();
 }
 
-typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
-                                               void *arg);
-
-static int
-ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
-                                                const MemoryRegionSection *section,
-                                                void *arg,
-                                                ram_block_attributes_section_cb cb)
-{
-    unsigned long first_bit, last_bit;
-    uint64_t offset, size;
-    const size_t block_size = ram_block_attributes_get_block_size();
-    int ret = 0;
-
-    first_bit = section->offset_within_region / block_size;
-    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
-                              first_bit);
-
-    while (first_bit < attr->bitmap_size) {
-        MemoryRegionSection tmp = *section;
-
-        offset = first_bit * block_size;
-        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
-                                      first_bit + 1) - 1;
-        size = (last_bit - first_bit + 1) * block_size;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            break;
-        }
-
-        ret = cb(&tmp, arg);
-        if (ret) {
-            error_report("%s: Failed to notify RAM discard listener: %s",
-                         __func__, strerror(-ret));
-            break;
-        }
-
-        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
-                                  last_bit + 2);
-    }
-
-    return ret;
-}
-
-static int
-ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
-                                                const MemoryRegionSection *section,
-                                                void *arg,
-                                                ram_block_attributes_section_cb cb)
-{
-    unsigned long first_bit, last_bit;
-    uint64_t offset, size;
-    const size_t block_size = ram_block_attributes_get_block_size();
-    int ret = 0;
-
-    first_bit = section->offset_within_region / block_size;
-    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
-                                   first_bit);
-
-    while (first_bit < attr->bitmap_size) {
-        MemoryRegionSection tmp = *section;
-
-        offset = first_bit * block_size;
-        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
-                                 first_bit + 1) - 1;
-        size = (last_bit - first_bit + 1) * block_size;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            break;
-        }
-
-        ret = cb(&tmp, arg);
-        if (ret) {
-            error_report("%s: Failed to notify RAM discard listener: %s",
-                         __func__, strerror(-ret));
-            break;
-        }
-
-        first_bit = find_next_zero_bit(attr->bitmap,
-                                       attr->bitmap_size,
-                                       last_bit + 2);
-    }
-
-    return ret;
-}
-
-
-typedef struct RamBlockAttributesReplayData {
-    ReplayRamDiscardState fn;
-    void *opaque;
-} RamBlockAttributesReplayData;
-
-static int ram_block_attributes_rds_replay_cb(MemoryRegionSection *section,
-                                              void *arg)
-{
-    RamBlockAttributesReplayData *data = arg;
-
-    return data->fn(section, data->opaque);
-}
-
 /* RamDiscardSource interface implementation */
 static uint64_t
 ram_block_attributes_rds_get_min_granularity(const RamDiscardSource *rds,
@@ -159,34 +59,6 @@ ram_block_attributes_rds_is_populated(const RamDiscardSource *rds,
     return first_discarded_bit > last_bit;
 }
 
-static int
-ram_block_attributes_rds_replay_populated(const RamDiscardSource *rds,
-                                          const MemoryRegionSection *section,
-                                          ReplayRamDiscardState replay_fn,
-                                          void *opaque)
-{
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
-    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
-
-    g_assert(section->mr == attr->ram_block->mr);
-    return ram_block_attributes_for_each_populated_section(attr, section, &data,
-                                                           ram_block_attributes_rds_replay_cb);
-}
-
-static int
-ram_block_attributes_rds_replay_discarded(const RamDiscardSource *rds,
-                                          const MemoryRegionSection *section,
-                                          ReplayRamDiscardState replay_fn,
-                                          void *opaque)
-{
-    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rds);
-    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
-
-    g_assert(section->mr == attr->ram_block->mr);
-    return ram_block_attributes_for_each_discarded_section(attr, section, &data,
-                                                           ram_block_attributes_rds_replay_cb);
-}
-
 static bool
 ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
                                     uint64_t size)
@@ -346,6 +218,4 @@ static void ram_block_attributes_class_init(ObjectClass *klass,
 
     rdsc->get_min_granularity = ram_block_attributes_rds_get_min_granularity;
     rdsc->is_populated = ram_block_attributes_rds_is_populated;
-    rdsc->replay_populated = ram_block_attributes_rds_replay_populated;
-    rdsc->replay_discarded = ram_block_attributes_rds_replay_discarded;
 }
-- 
2.53.0


