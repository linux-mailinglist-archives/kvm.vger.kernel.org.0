Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DB1C86F2
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgEGKdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:33:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727808AbgEGKdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 06:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I34kuI9zP9SIjkHokU9MyLfMs/Qz8/WCUk75Q38T3ns=;
        b=FTHQ6UfsPQaTyfvrrKTmHvjRXFPfLAJBLry249ycdYz1LtqYHU+tt+J9Qk58ZduE0LBXUw
        xWm3BtRWgw5LGMOkykisjpxeGCdEzaPHubEkutblSm7TbC7/edpvELUKwbmwq2jl0+FiCm
        EsElOsZ0d1NUHXErmX3hWG34lXnpiRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-mTnmAXzkOxq8aWqGcm09yg-1; Thu, 07 May 2020 06:33:26 -0400
X-MC-Unique: mTnmAXzkOxq8aWqGcm09yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40967107ACCA;
        Thu,  7 May 2020 10:33:25 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DD5F5D9C5;
        Thu,  7 May 2020 10:33:23 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v3 11/15] virtio-mem: Add parent resource for all added "System RAM"
Date:   Thu,  7 May 2020 12:31:15 +0200
Message-Id: <20200507103119.11219-12-david@redhat.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a parent resource, named after the virtio device (inspired by
drivers/dax/kmem.c). This allows user space to identify which memory
belongs to which virtio-mem device.

With this change and two virtio-mem devices:
	:/# cat /proc/iomem
	00000000-00000fff : Reserved
	00001000-0009fbff : System RAM
	[...]
	140000000-333ffffff : virtio0
	  140000000-147ffffff : System RAM
	  148000000-14fffffff : System RAM
	  150000000-157ffffff : System RAM
	[...]
	334000000-3033ffffff : virtio1
	  338000000-33fffffff : System RAM
	  340000000-347ffffff : System RAM
	  348000000-34fffffff : System RAM
	[...]

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 52 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index eb4c16d634e0..80cdb9e6b3c4 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -99,6 +99,9 @@ struct virtio_mem {
 	/* Id of the next memory bock to prepare when needed. */
 	unsigned long next_mb_id;
=20
+	/* The parent resource for all memory added via this device. */
+	struct resource *parent_resource;
+
 	/* Summary of all memory block states. */
 	unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
 #define VIRTIO_MEM_NB_OFFLINE_THRESHOLD		10
@@ -1741,6 +1744,44 @@ static int virtio_mem_init(struct virtio_mem *vm)
 	return 0;
 }
=20
+static int virtio_mem_create_resource(struct virtio_mem *vm)
+{
+	/*
+	 * When force-unloading the driver and removing the device, we
+	 * could have a garbage pointer. Duplicate the string.
+	 */
+	const char *name =3D kstrdup(dev_name(&vm->vdev->dev), GFP_KERNEL);
+
+	if (!name)
+		return -ENOMEM;
+
+	vm->parent_resource =3D __request_mem_region(vm->addr, vm->region_size,
+						   name, IORESOURCE_SYSTEM_RAM);
+	if (!vm->parent_resource) {
+		kfree(name);
+		dev_warn(&vm->vdev->dev, "could not reserve device region\n");
+		return -EBUSY;
+	}
+
+	/* The memory is not actually busy - make add_memory() work. */
+	vm->parent_resource->flags &=3D ~IORESOURCE_BUSY;
+	return 0;
+}
+
+static void virtio_mem_delete_resource(struct virtio_mem *vm)
+{
+	const char *name;
+
+	if (!vm->parent_resource)
+		return;
+
+	name =3D vm->parent_resource->name;
+	release_resource(vm->parent_resource);
+	kfree(vm->parent_resource);
+	kfree(name);
+	vm->parent_resource =3D NULL;
+}
+
 static int virtio_mem_probe(struct virtio_device *vdev)
 {
 	struct virtio_mem *vm;
@@ -1770,11 +1811,16 @@ static int virtio_mem_probe(struct virtio_device =
*vdev)
 	if (rc)
 		goto out_del_vq;
=20
+	/* create the parent resource for all memory */
+	rc =3D virtio_mem_create_resource(vm);
+	if (rc)
+		goto out_del_vq;
+
 	/* register callbacks */
 	vm->memory_notifier.notifier_call =3D virtio_mem_memory_notifier_cb;
 	rc =3D register_memory_notifier(&vm->memory_notifier);
 	if (rc)
-		goto out_del_vq;
+		goto out_del_resource;
 	rc =3D register_virtio_mem_device(vm);
 	if (rc)
 		goto out_unreg_mem;
@@ -1788,6 +1834,8 @@ static int virtio_mem_probe(struct virtio_device *v=
dev)
 	return 0;
 out_unreg_mem:
 	unregister_memory_notifier(&vm->memory_notifier);
+out_del_resource:
+	virtio_mem_delete_resource(vm);
 out_del_vq:
 	vdev->config->del_vqs(vdev);
 out_free_vm:
@@ -1848,6 +1896,8 @@ static void virtio_mem_remove(struct virtio_device =
*vdev)
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE])
 		dev_warn(&vdev->dev, "device still has system memory added\n");
+	else
+		virtio_mem_delete_resource(vm);
=20
 	/* remove all tracking data - no locking needed */
 	vfree(vm->mb_state);
--=20
2.25.3

