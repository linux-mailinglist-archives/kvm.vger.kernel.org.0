Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703101C8D72
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgEGODn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 10:03:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58813 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727822AbgEGODm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 10:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588860220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdxcxGx7SFVn0D0LAwJ67gF+eYTXzdSapCaeVtSsCtE=;
        b=cYjVGAmSZusXBfMrICFra5lXKeP1JnalvsJhBc2K27CW6nQDmnHE1pUueZKywIuA9TkZzI
        KfgXZitj+7kULjFwCz3MSJKh6qEtXrqEX9VsYW1FfWty5mlkkb5pkN84V9/fRQi1kdHJEo
        YYf1JR2rUHDQ9vv2Df71JJatwY7+cCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-lxBhMOqPN9WKvoonpKCTZQ-1; Thu, 07 May 2020 10:03:38 -0400
X-MC-Unique: lxBhMOqPN9WKvoonpKCTZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80EC9107ACCD;
        Thu,  7 May 2020 14:03:36 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E53F60BEC;
        Thu,  7 May 2020 14:03:34 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PATCH v4 12/15] virtio-mem: Drop manual check for already present memory
Date:   Thu,  7 May 2020 16:01:36 +0200
Message-Id: <20200507140139.17083-13-david@redhat.com>
In-Reply-To: <20200507140139.17083-1-david@redhat.com>
References: <20200507140139.17083-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
@@ -1616,23 +1616,6 @@ static int virtio_mem_init_vq(struct virtio_mem *vm)
 	return 0;
 }
 
-/*
- * Test if any memory in the range is present in Linux.
- */
-static bool virtio_mem_any_memory_present(unsigned long start,
-					  unsigned long size)
-{
-	const unsigned long start_pfn = PFN_DOWN(start);
-	const unsigned long end_pfn = PFN_UP(start + size);
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn != end_pfn; pfn++)
-		if (present_section_nr(pfn_to_section_nr(pfn)))
-			return true;
-
-	return false;
-}
-
 static int virtio_mem_init(struct virtio_mem *vm)
 {
 	const uint64_t phys_limit = 1UL << MAX_PHYSMEM_BITS;
@@ -1664,32 +1647,6 @@ static int virtio_mem_init(struct virtio_mem *vm)
 	virtio_cread(vm->vdev, struct virtio_mem_config, region_size,
 		     &vm->region_size);
 
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
-		vm->unplug_all_required = 1;
-	}
-
 	/*
 	 * We always hotplug memory in memory block granularity. This way,
 	 * we have to wait for exactly one memory block to online.
@@ -1760,6 +1717,8 @@ static int virtio_mem_create_resource(struct virtio_mem *vm)
 	if (!vm->parent_resource) {
 		kfree(name);
 		dev_warn(&vm->vdev->dev, "could not reserve device region\n");
+		dev_info(&vm->vdev->dev,
+			 "reloading the driver is not supported\n");
 		return -EBUSY;
 	}
 
@@ -1816,6 +1775,16 @@ static int virtio_mem_probe(struct virtio_device *vdev)
 	if (rc)
 		goto out_del_vq;
 
+	/*
+	 * If we still have memory plugged, we have to unplug all memory first.
+	 * Registering our parent resource makes sure that this memory isn't
+	 * actually in use (e.g., trying to reload the driver).
+	 */
+	if (vm->plugged_size) {
+		vm->unplug_all_required = 1;
+		dev_info(&vm->vdev->dev, "unplugging all memory is required\n");
+	}
+
 	/* register callbacks */
 	vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
 	rc = register_memory_notifier(&vm->memory_notifier);
-- 
2.25.3

