Return-Path: <kvm+bounces-71984-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OQpQK+RWoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-71984-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C601A7682
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4065F307BE2E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5686F3C1990;
	Thu, 26 Feb 2026 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXPy2QFN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321083AEF30
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114426; cv=none; b=UnCU1KGNrThh1fy4ufhfwVjuwjHgHi0DbvXZWcLouXCC9TtuGCBpNrL7Am7XI1jQuo4avQQcVfcVxaPxNhCDhtBJZZr53vNELYC2nzL9f9xhMRCiapeNjuFJ2SVUb9a+SjaK+EaMxKppBMc2NjEEBlXImhsh/a/IJU8N+OLKwa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114426; c=relaxed/simple;
	bh=dvBB2iFDR3jb07E5qoD7/nDOHFEOEtIi7ST1sS4W1dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nk+UgGNvbdwL1fGXgPhO2HFtdLf8HPG8a42Os9JN+jgXe4k8gSwp85RXwSmgnRRI1q/sfBQmzD0MhF1i7Ub8Gg+SDGxyEenai6YNxSyRJip2aj8ztOkF3EeIZ9PJ+lZ51oKKotncZWXZ32NmYejKN/qYn+MSfLOVul99cne+r7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXPy2QFN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHe9iQ+1P8ZlO5xByO1a0ChmR22YDJBfDZShZX5olz8=;
	b=iXPy2QFNlhCWyIP/upM1rax2SC72buvFahJXPouKYnFNDApXi3LFL2bRaOrrywL//WtXQy
	WjyNEG125v15/wRzWqH5kkQA6+Xt8ugItiv/EQMapQklwlFdv1HudWNha1DRXtiZ8JxW7e
	Xzu5axo2q8fe+2iT+F6eTH4g+O28vxA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-hcP5uesGOUi3WMeofA4mnQ-1; Thu,
 26 Feb 2026 09:00:14 -0500
X-MC-Unique: hcP5uesGOUi3WMeofA4mnQ-1
X-Mimecast-MFC-AGG-ID: hcP5uesGOUi3WMeofA4mnQ_1772114413
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A71818005BC;
	Thu, 26 Feb 2026 14:00:13 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9820D19560B5;
	Thu, 26 Feb 2026 14:00:10 +0000 (UTC)
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
Subject: [PATCH v3 02/15] memory: drop RamDiscardListener::double_discard_supported
Date: Thu, 26 Feb 2026 14:59:47 +0100
Message-ID: <20260226140001.3622334-3-marcandre.lureau@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71984-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 47C601A7682
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

This was never turned off, effectively some dead code.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 include/system/memory.h       | 12 +-----------
 hw/vfio/listener.c            |  2 +-
 hw/virtio/virtio-mem.c        | 22 ++--------------------
 system/ram-block-attributes.c | 23 +----------------------
 4 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index 0562af31361..be36fd93dc0 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -580,26 +580,16 @@ struct RamDiscardListener {
      */
     NotifyRamDiscard notify_discard;
 
-    /*
-     * @double_discard_supported:
-     *
-     * The listener suppors getting @notify_discard notifications that span
-     * already discarded parts.
-     */
-    bool double_discard_supported;
-
     MemoryRegionSection *section;
     QLIST_ENTRY(RamDiscardListener) next;
 };
 
 static inline void ram_discard_listener_init(RamDiscardListener *rdl,
                                              NotifyRamPopulate populate_fn,
-                                             NotifyRamDiscard discard_fn,
-                                             bool double_discard_supported)
+                                             NotifyRamDiscard discard_fn)
 {
     rdl->notify_populate = populate_fn;
     rdl->notify_discard = discard_fn;
-    rdl->double_discard_supported = double_discard_supported;
 }
 
 /**
diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
index 1087fdc142e..960da9e0a93 100644
--- a/hw/vfio/listener.c
+++ b/hw/vfio/listener.c
@@ -283,7 +283,7 @@ static bool vfio_ram_discard_register_listener(VFIOContainer *bcontainer,
 
     ram_discard_listener_init(&vrdl->listener,
                               vfio_ram_discard_notify_populate,
-                              vfio_ram_discard_notify_discard, true);
+                              vfio_ram_discard_notify_discard);
     ram_discard_manager_register_listener(rdm, &vrdl->listener, section);
     QLIST_INSERT_HEAD(&bcontainer->vrdl_list, vrdl, next);
 
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index c1e2defb68e..251d1d50aaa 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -331,14 +331,6 @@ static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
     return rdl->notify_populate(rdl, s);
 }
 
-static int virtio_mem_notify_discard_cb(MemoryRegionSection *s, void *arg)
-{
-    RamDiscardListener *rdl = arg;
-
-    rdl->notify_discard(rdl, s);
-    return 0;
-}
-
 static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
                                      uint64_t size)
 {
@@ -398,12 +390,7 @@ static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
     }
 
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
-        } else {
-            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
-                                                virtio_mem_notify_discard_cb);
-        }
+        rdl->notify_discard(rdl, rdl->section);
     }
 }
 
@@ -1824,12 +1811,7 @@ static void virtio_mem_rdm_unregister_listener(RamDiscardManager *rdm,
 
     g_assert(rdl->section->mr == &vmem->memdev->mr);
     if (vmem->size) {
-        if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
-        } else {
-            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
-                                                virtio_mem_notify_discard_cb);
-        }
+        rdl->notify_discard(rdl, rdl->section);
     }
 
     memory_region_section_free_copy(rdl->section);
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index 9f72a6b3545..630b0fda126 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -61,16 +61,6 @@ ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
     return rdl->notify_populate(rdl, section);
 }
 
-static int
-ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
-                                       void *arg)
-{
-    RamDiscardListener *rdl = arg;
-
-    rdl->notify_discard(rdl, section);
-    return 0;
-}
-
 static int
 ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
                                                 MemoryRegionSection *section,
@@ -191,22 +181,11 @@ ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
                                              RamDiscardListener *rdl)
 {
     RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
-    int ret;
 
     g_assert(rdl->section);
     g_assert(rdl->section->mr == attr->ram_block->mr);
 
-    if (rdl->double_discard_supported) {
-        rdl->notify_discard(rdl, rdl->section);
-    } else {
-        ret = ram_block_attributes_for_each_populated_section(attr,
-                rdl->section, rdl, ram_block_attributes_notify_discard_cb);
-        if (ret) {
-            error_report("%s: Failed to unregister RAM discard listener: %s",
-                         __func__, strerror(-ret));
-            exit(1);
-        }
-    }
+    rdl->notify_discard(rdl, rdl->section);
 
     memory_region_section_free_copy(rdl->section);
     rdl->section = NULL;
-- 
2.53.0


