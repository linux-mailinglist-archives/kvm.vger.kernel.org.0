Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190E844232C
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhKAWN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:13:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231805AbhKAWN1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSoWVIR9hKZoxnk9uhtu16nhbmo8V4KFxeuBGBhsQZ8=;
        b=Xz8WAKU0qeaUHBDnUDYZzJTqk32rCZpYKnK9irXFZE4NLnE2XElKjXTqRxlSF5Yn7ldMMq
        gbQ2hsQQy1GHkhK1a1DLC+IRtuwOO7geWuz2/5c/Jc/q4C8SEEPzzoDl6sG+Q4dYBh1Nd7
        4bnlxrmRXJJo/oy0YUvIxgGV/JUtdzQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4--_H1QlISMeWoLIYpphj3zg-1; Mon, 01 Nov 2021 18:09:31 -0400
X-MC-Unique: -_H1QlISMeWoLIYpphj3zg-1
Received: by mail-wr1-f69.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so3583075wro.4
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fSoWVIR9hKZoxnk9uhtu16nhbmo8V4KFxeuBGBhsQZ8=;
        b=P2WxvFFrSKLbYrgIQ3bI8cQepDEX2nMtRZgPZZlWSJRCrgJdV7yBdeFJ37EOBi7OD/
         G1/Pm6L9w5lDnuP5lLSpY6702fTJlvastEIfAaZrVXA3pBMfHLgaJB7Fq6cawbvFhA1n
         hI00naXhedVJxlPucWJUfa795pqwYknzaTmrhDani4/3NCRYACzvS5VI9HoFddrp6MIp
         mmvrM2hg9dK/4kFBzzmeXv8ZofDZaGvgzhtW/pstF/oURSTSJtyoH/7oLuKiAmclXcQN
         IK6OVdiEd+90jp+1NgX0v3CgjsLBXZeJ0OsJAhYbT9reGyFg1yyg14ECYqQg8kUbsxm5
         ZaRg==
X-Gm-Message-State: AOAM530czyIjk66h5sdRql5OSqGvdr4Cd007ddk6ysOEE3WNpM7Px/kP
        Enls0Zmo6rdtPv9xM+iEJhCSlorBrES+A0WOJrg0tMYHsN4CK6qymLjjWUlbTFYPiTMjMLa4ZZ8
        iDAroW7CGaMKM
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr1960966wmh.19.1635804570445;
        Mon, 01 Nov 2021 15:09:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwu/QxnhEuNymsrQqTg8NiGiNIcnxGmbn+stcw6LipoHUBGhkcJBUusifbHj5C9b6NJX/heIQ==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr1960945wmh.19.1635804570300;
        Mon, 01 Nov 2021 15:09:30 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id f133sm655275wmf.31.2021.11.01.15.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:29 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 12/20] virtio-mem: Implement replay_discarded RamDiscardManager callback
Date:   Mon,  1 Nov 2021 23:09:04 +0100
Message-Id: <20211101220912.10039-13-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Implement it similar to the replay_populated callback.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 hw/virtio/virtio-mem.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index df91e454b2..284096ec5f 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -228,6 +228,38 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
     return ret;
 }
 
+static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
+                                                 MemoryRegionSection *s,
+                                                 void *arg,
+                                                 virtio_mem_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    int ret = 0;
+
+    first_bit = s->offset_within_region / vmem->bitmap_size;
+    first_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size, first_bit);
+    while (first_bit < vmem->bitmap_size) {
+        MemoryRegionSection tmp = *s;
+
+        offset = first_bit * vmem->block_size;
+        last_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size,
+                                 first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * vmem->block_size;
+
+        if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
+            break;
+        }
+        ret = cb(&tmp, arg);
+        if (ret) {
+            break;
+        }
+        first_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
+                                       last_bit + 2);
+    }
+    return ret;
+}
+
 static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
 {
     RamDiscardListener *rdl = arg;
@@ -1170,6 +1202,31 @@ static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
                                             virtio_mem_rdm_replay_populated_cb);
 }
 
+static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
+                                              void *arg)
+{
+    struct VirtIOMEMReplayData *data = arg;
+
+    ((ReplayRamDiscard)data->fn)(s, data->opaque);
+    return 0;
+}
+
+static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                            MemoryRegionSection *s,
+                                            ReplayRamDiscard replay_fn,
+                                            void *opaque)
+{
+    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    struct VirtIOMEMReplayData data = {
+        .fn = replay_fn,
+        .opaque = opaque,
+    };
+
+    g_assert(s->mr == &vmem->memdev->mr);
+    virtio_mem_for_each_unplugged_section(vmem, s, &data,
+                                          virtio_mem_rdm_replay_discarded_cb);
+}
+
 static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
                                              RamDiscardListener *rdl,
                                              MemoryRegionSection *s)
@@ -1234,6 +1291,7 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
     rdmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
     rdmc->is_populated = virtio_mem_rdm_is_populated;
     rdmc->replay_populated = virtio_mem_rdm_replay_populated;
+    rdmc->replay_discarded = virtio_mem_rdm_replay_discarded;
     rdmc->register_listener = virtio_mem_rdm_register_listener;
     rdmc->unregister_listener = virtio_mem_rdm_unregister_listener;
 }
-- 
2.33.1

