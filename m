Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4A242BD39
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJMKlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhJMKlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+drgKSyBp+3GOfFgRCVw00nbzgTkvgCinN1Uq8+5xro=;
        b=A/Z94K5xPzxrGGYjUnGzKubOS7bghNHEGapC6gK/Uz3iTEoiKzSK7D9bBkPB9Xvu9V7b/v
        FvIkb7gWGhoAE10PXg0R3b7yhc+mih87sfn7xwac2kqHDaQ0ocMdxiSLPczF2OxVTOzAJv
        Og4Pa52d3bCyBFaS+cHGnK/6UnFFmvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-VAyqgU9YN0mfZYNoK44x7A-1; Wed, 13 Oct 2021 06:39:08 -0400
X-MC-Unique: VAyqgU9YN0mfZYNoK44x7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B07A318D6A25;
        Wed, 13 Oct 2021 10:39:06 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B21D5D9D5;
        Wed, 13 Oct 2021 10:38:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Subject: [PATCH RFC 10/15] virtio-mem: Set the RamDiscardManager for the RAM memory region earlier
Date:   Wed, 13 Oct 2021 12:33:25 +0200
Message-Id: <20211013103330.26869-11-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's set the RamDiscardManager earlier, logically before we expose the
RAM memory region to the system. This is a preparation for further changes
and is logically cleaner: before we expose the RAM memory region to
migration code, make sure we have the RamDiscardManager setup.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index d5a578142b..b2ad27ed7f 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -773,16 +773,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
                 sizeof(struct virtio_mem_config));
     vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
 
-    host_memory_backend_set_mapped(vmem->memdev, true);
-    vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
-    qemu_register_reset(virtio_mem_system_reset, vmem);
-
     /*
-     * Set ourselves as RamDiscardManager before the plug handler maps the
-     * memory region and exposes it via an address space.
+     * Set ourselves as RamDiscardManager before we expose the memory region
+     * to the system (e.g., marking the RAMBlock migratable, mapping the
+     * region).
      */
     memory_region_set_ram_discard_manager(&vmem->memdev->mr,
                                           RAM_DISCARD_MANAGER(vmem));
+
+    host_memory_backend_set_mapped(vmem->memdev, true);
+    vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
+    qemu_register_reset(virtio_mem_system_reset, vmem);
 }
 
 static void virtio_mem_device_unrealize(DeviceState *dev)
@@ -790,14 +791,10 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VirtIOMEM *vmem = VIRTIO_MEM(dev);
 
-    /*
-     * The unplug handler unmapped the memory region, it cannot be
-     * found via an address space anymore. Unset ourselves.
-     */
-    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     qemu_unregister_reset(virtio_mem_system_reset, vmem);
     vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
     host_memory_backend_set_mapped(vmem->memdev, false);
+    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
     g_free(vmem->bitmap);
-- 
2.31.1

