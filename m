Return-Path: <kvm+bounces-71992-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFp6Hv1WoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-71992-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 663091A76AE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AFCD431BCD55
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00063A784B;
	Thu, 26 Feb 2026 14:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RCaQDbuV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CE53A9DAF
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114454; cv=none; b=iJTfjYzqefFeQv8OKksP022fRCLBVW4EAcsMFGDtk0+KwcFs7Sb6R2AqxdyM4RqSf3vTbyoVXqerMeP+bd9Z4/CjFsKMorSKqRBvNVk1GOWmFak5/7g8rADBf5XJHPmXe7yIxpIYhS/YN/iMjv3a2QaEelRP3jtbg8yyhw1TDXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114454; c=relaxed/simple;
	bh=u7CbJw3jdOKUopHmoM1/Y+86KkrVjKyaPcVMkwkYNh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxAEp50rYlNuUv/JFr0ixFQR59CC/EiIrLqRx4KNzSkxKCSNl+Bq7BbQKC87ns25aVSJDkk56nCndNanBM+eo1HAJE+wRtalvusRl2UjJh3dg6Kd7QQIxg6JZ+3FZxBr6PsetVVsWoVpjB7uCFjUQLcjdxn7R55tgDwnE8EK+dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RCaQDbuV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVM51KZ1grB02Ebp/ONla2ZoUr/rU2xVZe/nndet3tw=;
	b=RCaQDbuVsgxSarF4EdGl7HVhM80u1Ri7TXhBk/eYZU1gkQ5rXvJrjeBOItHFxHOEfIiFBc
	Zvp3YhdoLP6JEig1iWomKCMlvJe8YZZ3kJ18RxSrTqCEyOjre/QwzBO8nW0HSv37T5b/Ou
	Xvp19cokZGE44EKCproqJlO9fYezgQs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-R2FHYCEiOXuYFKCgyd006g-1; Thu,
 26 Feb 2026 09:00:41 -0500
X-MC-Unique: R2FHYCEiOXuYFKCgyd006g-1
X-Mimecast-MFC-AGG-ID: R2FHYCEiOXuYFKCgyd006g_1772114440
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B88D318004AD;
	Thu, 26 Feb 2026 14:00:39 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 300F11956053;
	Thu, 26 Feb 2026 14:00:38 +0000 (UTC)
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
Subject: [PATCH v3 10/15] virtio-mem: remove replay_populated/replay_discarded implementation
Date: Thu, 26 Feb 2026 14:59:55 +0100
Message-ID: <20260226140001.3622334-11-marcandre.lureau@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71992-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 663091A76AE
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

The replay iteration logic has been moved into the RamDiscardManager,
which now iterates at source granularity using is_populated(). The
source-level replay_populated/replay_discarded methods and their
helpers are no longer called.

Remove the now-dead replay methods, the VirtIOMEMReplayData struct,
the virtio_mem_for_each_plugged/unplugged_section() helpers (only used
by the replay methods), and the virtio_mem_section_cb typedef.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 hw/virtio/virtio-mem.c | 112 -----------------------------------------
 1 file changed, 112 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index ec165503205..2b67b2882d2 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -259,72 +259,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
     return ret;
 }
 
-typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
-
-static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
-                                               const MemoryRegionSection *s,
-                                               void *arg,
-                                               virtio_mem_section_cb cb)
-{
-    unsigned long first_bit, last_bit;
-    uint64_t offset, size;
-    int ret = 0;
-
-    first_bit = s->offset_within_region / vmem->block_size;
-    first_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size, first_bit);
-    while (first_bit < vmem->bitmap_size) {
-        MemoryRegionSection tmp = *s;
-
-        offset = first_bit * vmem->block_size;
-        last_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
-                                      first_bit + 1) - 1;
-        size = (last_bit - first_bit + 1) * vmem->block_size;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            break;
-        }
-        ret = cb(&tmp, arg);
-        if (ret) {
-            break;
-        }
-        first_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size,
-                                  last_bit + 2);
-    }
-    return ret;
-}
-
-static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
-                                                 const MemoryRegionSection *s,
-                                                 void *arg,
-                                                 virtio_mem_section_cb cb)
-{
-    unsigned long first_bit, last_bit;
-    uint64_t offset, size;
-    int ret = 0;
-
-    first_bit = s->offset_within_region / vmem->block_size;
-    first_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size, first_bit);
-    while (first_bit < vmem->bitmap_size) {
-        MemoryRegionSection tmp = *s;
-
-        offset = first_bit * vmem->block_size;
-        last_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size,
-                                 first_bit + 1) - 1;
-        size = (last_bit - first_bit + 1) * vmem->block_size;
-
-        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
-            break;
-        }
-        ret = cb(&tmp, arg);
-        if (ret) {
-            break;
-        }
-        first_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
-                                       last_bit + 2);
-    }
-    return ret;
-}
-
 static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
                                      uint64_t size)
 {
@@ -1667,50 +1601,6 @@ static bool virtio_mem_rds_is_populated(const RamDiscardSource *rds,
     return virtio_mem_is_range_plugged(vmem, start_gpa, end_gpa - start_gpa);
 }
 
-struct VirtIOMEMReplayData {
-    ReplayRamDiscardState fn;
-    void *opaque;
-};
-
-static int virtio_mem_rds_replay_cb(MemoryRegionSection *s, void *arg)
-{
-    struct VirtIOMEMReplayData *data = arg;
-
-    return data->fn(s, data->opaque);
-}
-
-static int virtio_mem_rds_replay_populated(const RamDiscardSource *rds,
-                                           const MemoryRegionSection *s,
-                                           ReplayRamDiscardState replay_fn,
-                                           void *opaque)
-{
-    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
-    struct VirtIOMEMReplayData data = {
-        .fn = replay_fn,
-        .opaque = opaque,
-    };
-
-    g_assert(s->mr == &vmem->memdev->mr);
-    return virtio_mem_for_each_plugged_section(vmem, s, &data,
-                                               virtio_mem_rds_replay_cb);
-}
-
-static int virtio_mem_rds_replay_discarded(const RamDiscardSource *rds,
-                                           const MemoryRegionSection *s,
-                                           ReplayRamDiscardState replay_fn,
-                                           void *opaque)
-{
-    const VirtIOMEM *vmem = VIRTIO_MEM(rds);
-    struct VirtIOMEMReplayData data = {
-        .fn = replay_fn,
-        .opaque = opaque,
-    };
-
-    g_assert(s->mr == &vmem->memdev->mr);
-    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
-                                                 virtio_mem_rds_replay_cb);
-}
-
 static void virtio_mem_unplug_request_check(VirtIOMEM *vmem, Error **errp)
 {
     if (vmem->unplugged_inaccessible == ON_OFF_AUTO_OFF) {
@@ -1766,8 +1656,6 @@ static void virtio_mem_class_init(ObjectClass *klass, const void *data)
 
     rdsc->get_min_granularity = virtio_mem_rds_get_min_granularity;
     rdsc->is_populated = virtio_mem_rds_is_populated;
-    rdsc->replay_populated = virtio_mem_rds_replay_populated;
-    rdsc->replay_discarded = virtio_mem_rds_replay_discarded;
 }
 
 static const TypeInfo virtio_mem_info = {
-- 
2.53.0


