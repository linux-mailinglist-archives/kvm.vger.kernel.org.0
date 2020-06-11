Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7C1F64D2
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgFKJfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 05:35:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726905AbgFKJfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 05:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591868137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=skekyVLdwFwBTm754pc77fwSJmldMeXVb8k3yiao8Zo=;
        b=CiYkZgksT71QAo9GQc/TM2XXvtrXM5TycKVm3BzS9JHAF2ZibGak5Fr0oL6MAyf1e1HDMM
        CheY6/Cqqu13PESHqjQIiJrAl3gnT/qroz5sBQHdKdK0gUCkPpeI+e5N2O5ryRgkuk9Oam
        c8oGE03bL2w2c+7fQl+N7mEVJzXdbGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-79N41bhHNyOSrHDxFwNDUg-1; Thu, 11 Jun 2020 05:35:35 -0400
X-MC-Unique: 79N41bhHNyOSrHDxFwNDUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C5E1883605;
        Thu, 11 Jun 2020 09:35:34 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-160.ams2.redhat.com [10.36.114.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B303110013C1;
        Thu, 11 Jun 2020 09:35:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>
Subject: [PATCH v1] virtio-mem: add memory via add_memory_driver_managed()
Date:   Thu, 11 Jun 2020 11:35:18 +0200
Message-Id: <20200611093518.5737-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtio-mem managed memory is always detected and added by the virtio-mem
driver, never using something like the firmware-provided memory map.
This is the case after an ordinary system reboot, and has to be guaranteed
after kexec. Especially, virtio-mem added memory resources can contain
inaccessible parts ("unblocked memory blocks"), blindly forwarding them
to a kexec kernel is dangerous, as unplugged memory will get accessed
(esp. written).

Let's use the new way of adding special driver-managed memory introduced
in commit 75ac4c58bc0d ("mm/memory_hotplug: introduce
add_memory_driver_managed()").

This will result in no entries in /sys/firmware/memmap ("raw firmware-
provided memory map"), the memory resource will be flagged
IORESOURCE_MEM_DRIVER_MANAGED (esp., kexec_file_load() will not place
kexec images on this memory), and it is exposed as "System RAM
(virtio_mem)" in /proc/iomem, so esp. kexec-tools can properly handle it.

Example /proc/iomem before this change:
  [...]
  140000000-333ffffff : virtio0
    140000000-147ffffff : System RAM
  334000000-533ffffff : virtio1
    338000000-33fffffff : System RAM
    340000000-347ffffff : System RAM
    348000000-34fffffff : System RAM
  [...]

Example /proc/iomem after this change:
  [...]
  140000000-333ffffff : virtio0
    140000000-147ffffff : System RAM (virtio_mem)
  334000000-533ffffff : virtio1
    338000000-33fffffff : System RAM (virtio_mem)
    340000000-347ffffff : System RAM (virtio_mem)
    348000000-34fffffff : System RAM (virtio_mem)
  [...]

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

Based on latest Linus' tree (and not a tag) because
- virtio-mem has just been merged via the vhost tree
- add_memory_driver_managed() has been merged a week ago via the -mm tree

I'd like to have this patch in 5.8, with the initial merge of virtio-mem
if possible (so the user space representation of virtio-mem added memory
resources won't change anymore).

---
 drivers/virtio/virtio_mem.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 50c689f250450..d2eab3558a9e1 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -101,6 +101,11 @@ struct virtio_mem {
 
 	/* The parent resource for all memory added via this device. */
 	struct resource *parent_resource;
+	/*
+	 * Copy of "System RAM (virtio_mem)" to be used for
+	 * add_memory_driver_managed().
+	 */
+	const char *resource_name;
 
 	/* Summary of all memory block states. */
 	unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
@@ -414,8 +419,20 @@ static int virtio_mem_mb_add(struct virtio_mem *vm, unsigned long mb_id)
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(addr);
 
+	/*
+	 * When force-unloading the driver and we still have memory added to
+	 * Linux, the resource name has to stay.
+	 */
+	if (!vm->resource_name) {
+		vm->resource_name = kstrdup_const("System RAM (virtio_mem)",
+						  GFP_KERNEL);
+		if (!vm->resource_name)
+			return -ENOMEM;
+	}
+
 	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
-	return add_memory(nid, addr, memory_block_size_bytes());
+	return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
+					 vm->resource_name);
 }
 
 /*
@@ -1890,10 +1907,12 @@ static void virtio_mem_remove(struct virtio_device *vdev)
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL] ||
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE] ||
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
-	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE])
+	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE]) {
 		dev_warn(&vdev->dev, "device still has system memory added\n");
-	else
+	} else {
 		virtio_mem_delete_resource(vm);
+		kfree_const(vm->resource_name);
+	}
 
 	/* remove all tracking data - no locking needed */
 	vfree(vm->mb_state);
-- 
2.26.2

