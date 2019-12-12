Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED9C11D357
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbfLLRNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:13:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36917 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730190AbfLLRNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5AU/VyzF87tvu+cshF+3w2ny6cT9bermISGCUG/Yli4=;
        b=Zp6P/wR2bDCE+9a569MgGFULgdUJQBvd5hn7oP21p8qhZSQS7JjfBp8zK8LoDl6iLz6e0D
        W3+Wy1gKoTsZ8mBLRVBtRIUAUgOKww/JqxRgfjWq4CNGw+mMbyEd/d2JgRF0msfJ4n150B
        IK26LHJRos+8Ch4EHfssOdUy3Yveym0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-v7hnQy_5PeGS2XdIH4L5TA-1; Thu, 12 Dec 2019 12:12:57 -0500
X-MC-Unique: v7hnQy_5PeGS2XdIH4L5TA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229B3800053;
        Thu, 12 Dec 2019 17:12:56 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E93A5C298;
        Thu, 12 Dec 2019 17:12:48 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH RFC v4 07/13] virtio-mem: Allow to offline partially unplugged memory blocks
Date:   Thu, 12 Dec 2019 18:11:31 +0100
Message-Id: <20191212171137.13872-8-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dropping the reference count of PageOffline() pages allows offlining
code to skip them. However, we also have to convert PG_reserved to
another flag - let's use PG_dirty - so has_unmovable_pages() will
properly handle them. PG_reserved pages get detected as unmovable right
away.

We need the flag to see if we are onlining pages the first time, or if
we allocated them via alloc_contig_range().

Properly take care of offlining code also modifying the stats and
special handling in case the driver gets unloaded.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 64 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 5a142a371222..a12a0f9c076b 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -564,6 +564,53 @@ static void virtio_mem_notify_online(struct virtio_m=
em *vm, unsigned long mb_id,
 		virtio_mem_retry(vm);
 }
=20
+static void virtio_mem_notify_going_offline(struct virtio_mem *vm,
+					    unsigned long mb_id)
+{
+	const unsigned long nr_pages =3D PFN_DOWN(vm->subblock_size);
+	unsigned long pfn;
+	int sb_id, i;
+
+	for (sb_id =3D 0; sb_id < vm->nb_sb_per_mb; sb_id++) {
+		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
+			continue;
+		/*
+		 * Drop our reference to the pages so the memory can get
+		 * offlined and add the unplugged pages to the managed
+		 * page counters (so offlining code can correctly subtract
+		 * them again).
+		 */
+		pfn =3D PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
+			       sb_id * vm->subblock_size);
+		adjust_managed_page_count(pfn_to_page(pfn), nr_pages);
+		for (i =3D 0; i < nr_pages; i++)
+			page_ref_dec(pfn_to_page(pfn + i));
+	}
+}
+
+static void virtio_mem_notify_cancel_offline(struct virtio_mem *vm,
+					     unsigned long mb_id)
+{
+	const unsigned long nr_pages =3D PFN_DOWN(vm->subblock_size);
+	unsigned long pfn;
+	int sb_id, i;
+
+	for (sb_id =3D 0; sb_id < vm->nb_sb_per_mb; sb_id++) {
+		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
+			continue;
+		/*
+		 * Get the reference we dropped when going offline and
+		 * subtract the unplugged pages from the managed page
+		 * counters.
+		 */
+		pfn =3D PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
+			       sb_id * vm->subblock_size);
+		adjust_managed_page_count(pfn_to_page(pfn), -nr_pages);
+		for (i =3D 0; i < nr_pages; i++)
+			page_ref_inc(pfn_to_page(pfn + i));
+	}
+}
+
 /*
  * This callback will either be called synchonously from add_memory() or
  * asynchronously (e.g., triggered via user space). We have to be carefu=
l
@@ -611,6 +658,7 @@ static int virtio_mem_memory_notifier_cb(struct notif=
ier_block *nb,
 			break;
 		mutex_lock(&vm->hotplug_mutex);
 		vm->hotplug_active =3D true;
+		virtio_mem_notify_going_offline(vm, mb_id);
 		break;
 	case MEM_GOING_ONLINE:
 		spin_lock_irq(&vm->removal_lock);
@@ -636,6 +684,12 @@ static int virtio_mem_memory_notifier_cb(struct noti=
fier_block *nb,
 		mutex_unlock(&vm->hotplug_mutex);
 		break;
 	case MEM_CANCEL_OFFLINE:
+		if (!vm->hotplug_active)
+			break;
+		virtio_mem_notify_cancel_offline(vm, mb_id);
+		vm->hotplug_active =3D false;
+		mutex_unlock(&vm->hotplug_mutex);
+		break;
 	case MEM_CANCEL_ONLINE:
 		if (!vm->hotplug_active)
 			break;
@@ -660,8 +714,11 @@ static void virtio_mem_set_fake_offline(unsigned lon=
g pfn,
 		struct page *page =3D pfn_to_page(pfn);
=20
 		__SetPageOffline(page);
-		if (!onlined)
+		if (!onlined) {
 			SetPageDirty(page);
+			/* FIXME: remove after cleanups */
+			ClearPageReserved(page);
+		}
 	}
 }
=20
@@ -1719,6 +1776,11 @@ static void virtio_mem_remove(struct virtio_device=
 *vdev)
 		rc =3D virtio_mem_mb_remove(vm, mb_id);
 		BUG_ON(rc);
 	}
+	/*
+	 * After we unregistered our callbacks, user space can no longer
+	 * offline partially plugged online memory blocks. No need to worry
+	 * about them.
+	 */
=20
 	/* unregister callbacks */
 	unregister_virtio_mem_device(vm);
--=20
2.23.0

