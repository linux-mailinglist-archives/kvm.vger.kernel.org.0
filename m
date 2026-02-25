Return-Path: <kvm+bounces-71831-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACn1GKblnmkCXwQAu9opvQ
	(envelope-from <kvm+bounces-71831-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:05:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABA6196F76
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 439563022556
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 12:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFA73ACF02;
	Wed, 25 Feb 2026 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4S35KuQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA1E221F24
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772021136; cv=none; b=ZY28HKysuqZZjqQ6IhjVrtcPAcEuSDq3wwE1VU01Znn6nXl2g/KhOdxQj5kB96lhy+6w9tMQzXl/L6zATJMSoInLQoRqpzBtno2KZIZHsmHps21sbvhnQ1Cfr9J4O17A+UMq/F09lrcYwCqTA83jAk1e5cf+2eEoSzNaubq9fao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772021136; c=relaxed/simple;
	bh=TlQc338n0J+6SC6E+LWbRhonIKEqIMSdITlyXWSTUu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INJB5Gl3KQaSjMSv0ArG7RxU1aw2wjWF/8StGW4ifDDz5uX6BscpLqWjK5jCTe/2PzfO9sqTGLw9yuvVEGpvkNWJ6HENJIXImYwj9TRfpG1OpngStnn6YcCYweAflnlbb3aCfz3FjxFZLqW2hYcWJ5tvDprNIwmsk5uL8ATSfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4S35KuQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772021133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaPxp1WEdRt0jnZCBSLHJX1sxKAQNNgjpbASlQsTY/o=;
	b=Z4S35KuQ+HmCCrJSXonNtefNzE5mmP6JxwdI5BuqILXtxUDTiKTEW7OosFwJHg5NsWLE6f
	pps4YUulja01T9orejmdq8K0LV7D3gIIB+UdEB3cmDge2zDx4DJYpCAR+BvnVH7ohjDa4C
	ACjtYxNk2ZkCd/jbj4zMLVIEk24Eu8k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-UhbaNF1kO8OIerHXDyerwA-1; Wed,
 25 Feb 2026 07:05:30 -0500
X-MC-Unique: UhbaNF1kO8OIerHXDyerwA-1
X-Mimecast-MFC-AGG-ID: UhbaNF1kO8OIerHXDyerwA_1772021129
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3225A19560A2;
	Wed, 25 Feb 2026 12:05:29 +0000 (UTC)
Received: from localhost (unknown [10.48.1.67])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B82E21955F43;
	Wed, 25 Feb 2026 12:05:27 +0000 (UTC)
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
Subject: [PATCH v2 11/14] system/ram-discard-manager: drop replay from source interface
Date: Wed, 25 Feb 2026 13:04:52 +0100
Message-ID: <20260225120456.3170057-12-marcandre.lureau@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71831-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 1ABA6196F76
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


