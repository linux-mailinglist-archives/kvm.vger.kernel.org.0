Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AFA1C86FB
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEGKd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:33:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37474 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727819AbgEGKdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 06:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gQ6eL9ADbM2wkypLrRFdn/IN6JfuTzMbKSfurnS/AY=;
        b=Wa9oZVvBEybMYpv/X+vrQbzwnyCWgXpVD6orTy+3y8A1VAMYe4bNqs4Vf5Vq24OgaMGNXB
        72sPZ37vkvLV/+ougrU4ceUvJ6Rzn9Gb897znoVo059Vmtfm6aa44GBbvFGyR57OARMyT9
        0VCi6gEPASpq3zZjxBcNaInhescPbRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-LSxa9YxtO16Q-JqjRgDGww-1; Thu, 07 May 2020 06:33:29 -0400
X-MC-Unique: LSxa9YxtO16Q-JqjRgDGww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8885C19200C1;
        Thu,  7 May 2020 10:33:27 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CA715D9C5;
        Thu,  7 May 2020 10:33:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v3 12/15] virtio-mem: Drop manual check for already present memory
Date:   Thu,  7 May 2020 12:31:16 +0200
Message-Id: <20200507103119.11219-13-david@redhat.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Registering our parent resource will fail if any memory is still present
(e.g., because somebody unloaded the driver and tries to reload it). No
need for the manual check.

Move our "unplug all" handling to after registering the resource.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 55 ++++++++-----------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 80cdb9e6b3c4..8dd57b61b09b 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -1616,23 +1616,6 @@ static int virtio_mem_init_vq(struct virtio_mem *v=
m)
 	return 0;
 }
=20
-/*
- * Test if any memory in the range is present in Linux.
- */
-static bool virtio_mem_any_memory_present(unsigned long start,
-					  unsigned long size)
-{
-	const unsigned long start_pfn =3D PFN_DOWN(start);
-	const unsigned long end_pfn =3D PFN_UP(start + size);
-	unsigned long pfn;
-
-	for (pfn =3D start_pfn; pfn !=3D end_pfn; pfn++)
-		if (present_section_nr(pfn_to_section_nr(pfn)))
-			return true;
-
-	return false;
-}
-
 static int virtio_mem_init(struct virtio_mem *vm)
 {
 	const uint64_t phys_limit =3D 1UL << MAX_PHYSMEM_BITS;
@@ -1664,32 +1647,6 @@ static int virtio_mem_init(struct virtio_mem *vm)
 	virtio_cread(vm->vdev, struct virtio_mem_config, region_size,
 		     &vm->region_size);
=20
-	/*
-	 * If we still have memory plugged, we might have to unplug all
-	 * memory first. However, if somebody simply unloaded the driver
-	 * we would have to reinitialize the old state - something we don't
-	 * support yet. Detect if we have any memory in the area present.
-	 */
-	if (vm->plugged_size) {
-		uint64_t usable_region_size;
-
-		virtio_cread(vm->vdev, struct virtio_mem_config,
-			     usable_region_size, &usable_region_size);
-
-		if (virtio_mem_any_memory_present(vm->addr,
-						  usable_region_size)) {
-			dev_err(&vm->vdev->dev,
-				"reloading the driver is not supported\n");
-			return -EINVAL;
-		}
-		/*
-		 * Note: it might happen that the device is busy and
-		 * unplugging all memory might take some time.
-		 */
-		dev_info(&vm->vdev->dev, "unplugging all memory required\n");
-		vm->unplug_all_required =3D 1;
-	}
-
 	/*
 	 * We always hotplug memory in memory block granularity. This way,
 	 * we have to wait for exactly one memory block to online.
@@ -1760,6 +1717,8 @@ static int virtio_mem_create_resource(struct virtio=
_mem *vm)
 	if (!vm->parent_resource) {
 		kfree(name);
 		dev_warn(&vm->vdev->dev, "could not reserve device region\n");
+		dev_info(&vm->vdev->dev,
+			 "reloading the driver is not supported\n");
 		return -EBUSY;
 	}
=20
@@ -1816,6 +1775,16 @@ static int virtio_mem_probe(struct virtio_device *=
vdev)
 	if (rc)
 		goto out_del_vq;
=20
+	/*
+	 * If we still have memory plugged, we have to unplug all memory first.
+	 * Registering our parent resource makes sure that this memory isn't
+	 * actually in use (e.g., trying to reload the driver).
+	 */
+	if (vm->plugged_size) {
+		vm->unplug_all_required =3D 1;
+		dev_info(&vm->vdev->dev, "unplugging all memory is required\n");
+	}
+
 	/* register callbacks */
 	vm->memory_notifier.notifier_call =3D virtio_mem_memory_notifier_cb;
 	rc =3D register_memory_notifier(&vm->memory_notifier);
--=20
2.25.3

