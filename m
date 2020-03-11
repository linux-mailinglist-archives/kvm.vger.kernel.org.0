Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DDD181EFD
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbgCKRQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:16:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730341AbgCKRQE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 13:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583946963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUPkyWfPObsIY0DZQSPrijCHG7LExrL/8dv4FXU4BII=;
        b=MNSvGa62zad2XrxSnyj1FmF847iS4PZOgEKlK0BMUMS70PTrLGw7DhTU/YQnoJTUJNIoXw
        H0b7iw+Pm23/kzg++2BU9FU0LHucXVHrJhR+Ugi6XQJwAhLHpFE0db5WfzFfGUF2FywvKz
        zScx+pm9U5VqbjhwsNq66v4j4ZqD1FM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Ixxu5hKKP4a_cCK4Z25P4A-1; Wed, 11 Mar 2020 13:15:59 -0400
X-MC-Unique: Ixxu5hKKP4a_cCK4Z25P4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FE19DBA3;
        Wed, 11 Mar 2020 17:15:57 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3209592D2D;
        Wed, 11 Mar 2020 17:15:42 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 04/10] virtio-mem: Paravirtualized memory hotunplug part 2
Date:   Wed, 11 Mar 2020 18:14:16 +0100
Message-Id: <20200311171422.10484-5-david@redhat.com>
In-Reply-To: <20200311171422.10484-1-david@redhat.com>
References: <20200311171422.10484-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We also want to unplug online memory (contained in online memory blocks
and, therefore, managed by the buddy), and eventually replug it later.

When requested to unplug memory, we use alloc_contig_range() to allocate
subblocks in online memory blocks (so we are the owner) and send them to
our hypervisor. When requested to plug memory, we can replug such memory
using free_contig_range() after asking our hypervisor.

We also want to mark all allocated pages PG_offline, so nobody will
touch them. To differentiate pages that were never onlined when
onlining the memory block from pages allocated via alloc_contig_range(), =
we
use PageDirty(). Based on this flag, virtio_mem_fake_online() can either
online the pages for the first time or use free_contig_range().

It is worth noting that there are no guarantees on how much memory can
actually get unplugged again. All device memory might completely be
fragmented with unmovable data, such that no subblock can get unplugged.

We are not touching the ZONE_MOVABLE. If memory is onlined to the
ZONE_MOVABLE, it can only get unplugged after that memory was offlined
manually by user space. In normal operation, virtio-mem memory is
suggested to be onlined to ZONE_NORMAL. In the future, we will try to
make unplug more likely to succeed.

Add a module parameter to control if online memory shall be touched.

As we want to access alloc_contig_range()/free_contig_range() from
kernel module context, export the symbols.

Note: Whenever virtio-mem uses alloc_contig_range(), all affected pages
are on the same node, in the same zone, and contain no holes.

Acked-by: Michal Hocko <mhocko@suse.com> # to export contig range allocat=
or API
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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/Kconfig      |   1 +
 drivers/virtio/virtio_mem.c | 157 ++++++++++++++++++++++++++++++++----
 mm/page_alloc.c             |   2 +
 3 files changed, 146 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 95ea2094a6b4..6af35ffb9796 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -72,6 +72,7 @@ config VIRTIO_MEM
 	depends on VIRTIO
 	depends on MEMORY_HOTPLUG_SPARSE
 	depends on MEMORY_HOTREMOVE
+	select CONTIG_ALLOC
 	help
 	 This driver provides access to virtio-mem paravirtualized memory
 	 devices, allowing to hotplug and hotunplug memory.
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index c1fc7f9c4acf..5b26d57be551 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -22,6 +22,10 @@
=20
 #include <acpi/acpi_numa.h>
=20
+static bool unplug_online =3D true;
+module_param(unplug_online, bool, 0644);
+MODULE_PARM_DESC(unplug_online, "Try to unplug online memory");
+
 enum virtio_mem_mb_state {
 	/* Unplugged, not added to Linux. Can be reused later. */
 	VIRTIO_MEM_MB_STATE_UNUSED =3D 0,
@@ -652,23 +656,35 @@ static int virtio_mem_memory_notifier_cb(struct not=
ifier_block *nb,
 }
=20
 /*
- * Set a range of pages PG_offline.
+ * Set a range of pages PG_offline. Remember pages that were never onlin=
ed
+ * (via generic_online_page()) using PageDirty().
  */
 static void virtio_mem_set_fake_offline(unsigned long pfn,
-					unsigned int nr_pages)
+					unsigned int nr_pages, bool onlined)
 {
-	for (; nr_pages--; pfn++)
-		__SetPageOffline(pfn_to_page(pfn));
+	for (; nr_pages--; pfn++) {
+		struct page *page =3D pfn_to_page(pfn);
+
+		__SetPageOffline(page);
+		if (!onlined)
+			SetPageDirty(page);
+	}
 }
=20
 /*
- * Clear PG_offline from a range of pages.
+ * Clear PG_offline from a range of pages. If the pages were never onlin=
ed,
+ * (via generic_online_page()), clear PageDirty().
  */
 static void virtio_mem_clear_fake_offline(unsigned long pfn,
-					  unsigned int nr_pages)
+					  unsigned int nr_pages, bool onlined)
 {
-	for (; nr_pages--; pfn++)
-		__ClearPageOffline(pfn_to_page(pfn));
+	for (; nr_pages--; pfn++) {
+		struct page *page =3D pfn_to_page(pfn);
+
+		__ClearPageOffline(page);
+		if (!onlined)
+			ClearPageDirty(page);
+	}
 }
=20
 /*
@@ -684,10 +700,26 @@ static void virtio_mem_fake_online(unsigned long pf=
n, unsigned int nr_pages)
 	 * We are always called with subblock granularity, which is at least
 	 * aligned to MAX_ORDER - 1.
 	 */
-	virtio_mem_clear_fake_offline(pfn, nr_pages);
+	for (i =3D 0; i < nr_pages; i +=3D 1 << order) {
+		struct page *page =3D pfn_to_page(pfn + i);
=20
-	for (i =3D 0; i < nr_pages; i +=3D 1 << order)
-		generic_online_page(pfn_to_page(pfn + i), order);
+		/*
+		 * If the page is PageDirty(), it was kept fake-offline when
+		 * onlining the memory block. Otherwise, it was allocated
+		 * using alloc_contig_range(). All pages in a subblock are
+		 * alike.
+		 */
+		if (PageDirty(page)) {
+			virtio_mem_clear_fake_offline(pfn + i, 1 << order,
+						      false);
+			generic_online_page(page, order);
+		} else {
+			virtio_mem_clear_fake_offline(pfn + i, 1 << order,
+						      true);
+			free_contig_range(pfn + i, 1 << order);
+			adjust_managed_page_count(page, 1 << order);
+		}
+	}
 }
=20
 static void virtio_mem_online_page_cb(struct page *page, unsigned int or=
der)
@@ -716,7 +748,8 @@ static void virtio_mem_online_page_cb(struct page *pa=
ge, unsigned int order)
 		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
 			generic_online_page(page, order);
 		else
-			virtio_mem_set_fake_offline(PFN_DOWN(addr), 1 << order);
+			virtio_mem_set_fake_offline(PFN_DOWN(addr), 1 << order,
+						    false);
 		rcu_read_unlock();
 		return;
 	}
@@ -1184,6 +1217,72 @@ static int virtio_mem_mb_unplug_any_sb_offline(str=
uct virtio_mem *vm,
 	return 0;
 }
=20
+/*
+ * Unplug the desired number of plugged subblocks of an online memory bl=
ock.
+ * Will skip subblock that are busy.
+ *
+ * Will modify the state of the memory block.
+ *
+ * Note: Can fail after some subblocks were successfully unplugged. Can
+ *       return 0 even if subblocks were busy and could not get unplugge=
d.
+ */
+static int virtio_mem_mb_unplug_any_sb_online(struct virtio_mem *vm,
+					      unsigned long mb_id,
+					      uint64_t *nb_sb)
+{
+	const unsigned long nr_pages =3D PFN_DOWN(vm->subblock_size);
+	unsigned long start_pfn;
+	int rc, sb_id;
+
+	/*
+	 * TODO: To increase the performance we want to try bigger, consecutive
+	 * subblocks first before falling back to single subblocks. Also,
+	 * we should sense via something like is_mem_section_removable()
+	 * first if it makes sense to go ahead any try to allocate.
+	 */
+	for (sb_id =3D 0; sb_id < vm->nb_sb_per_mb && *nb_sb; sb_id++) {
+		/* Find the next candidate subblock */
+		while (sb_id < vm->nb_sb_per_mb &&
+		       !virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
+			sb_id++;
+		if (sb_id >=3D vm->nb_sb_per_mb)
+			break;
+
+		start_pfn =3D PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
+				     sb_id * vm->subblock_size);
+		rc =3D alloc_contig_range(start_pfn, start_pfn + nr_pages,
+					MIGRATE_MOVABLE, GFP_KERNEL);
+		if (rc =3D=3D -ENOMEM)
+			/* whoops, out of memory */
+			return rc;
+		if (rc)
+			/* memory busy, we can't unplug this chunk */
+			continue;
+
+		/* Mark it as fake-offline before unplugging it */
+		virtio_mem_set_fake_offline(start_pfn, nr_pages, true);
+		adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
+
+		/* Try to unplug the allocated memory */
+		rc =3D virtio_mem_mb_unplug_sb(vm, mb_id, sb_id, 1);
+		if (rc) {
+			/* Return the memory to the buddy. */
+			virtio_mem_fake_online(start_pfn, nr_pages);
+			return rc;
+		}
+
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL);
+		*nb_sb -=3D 1;
+	}
+
+	/*
+	 * TODO: Once all subblocks of a memory block were unplugged, we want
+	 * to offline the memory block and remove it.
+	 */
+	return 0;
+}
+
 /*
  * Try to unplug the requested amount of memory.
  */
@@ -1223,8 +1322,37 @@ static int virtio_mem_unplug_request(struct virtio=
_mem *vm, uint64_t diff)
 		cond_resched();
 	}
=20
+	if (!unplug_online) {
+		mutex_unlock(&vm->hotplug_mutex);
+		return 0;
+	}
+
+	/* Try to unplug subblocks of partially plugged online blocks. */
+	virtio_mem_for_each_mb_state_rev(vm, mb_id,
+					 VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL) {
+		rc =3D virtio_mem_mb_unplug_any_sb_online(vm, mb_id,
+							&nb_sb);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		mutex_unlock(&vm->hotplug_mutex);
+		cond_resched();
+		mutex_lock(&vm->hotplug_mutex);
+	}
+
+	/* Try to unplug subblocks of plugged online blocks. */
+	virtio_mem_for_each_mb_state_rev(vm, mb_id,
+					 VIRTIO_MEM_MB_STATE_ONLINE) {
+		rc =3D virtio_mem_mb_unplug_any_sb_online(vm, mb_id,
+							&nb_sb);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		mutex_unlock(&vm->hotplug_mutex);
+		cond_resched();
+		mutex_lock(&vm->hotplug_mutex);
+	}
+
 	mutex_unlock(&vm->hotplug_mutex);
-	return 0;
+	return nb_sb ? -EBUSY : 0;
 out_unlock:
 	mutex_unlock(&vm->hotplug_mutex);
 	return rc;
@@ -1330,7 +1458,8 @@ static void virtio_mem_run_wq(struct work_struct *w=
ork)
 	case -EBUSY:
 		/*
 		 * The hypervisor cannot process our request right now
-		 * (e.g., out of memory, migrating).
+		 * (e.g., out of memory, migrating) or we cannot free up
+		 * any memory to unplug it (all plugged memory is busy).
 		 */
 	case -ENOMEM:
 		/* Out of memory, try again later. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 79e950d76ffc..8d7be3f33e26 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8597,6 +8597,7 @@ int alloc_contig_range(unsigned long start, unsigne=
d long end,
 				pfn_max_align_up(end), migratetype);
 	return ret;
 }
+EXPORT_SYMBOL(alloc_contig_range);
=20
 static int __alloc_contig_pages(unsigned long start_pfn,
 				unsigned long nr_pages, gfp_t gfp_mask)
@@ -8712,6 +8713,7 @@ void free_contig_range(unsigned long pfn, unsigned =
int nr_pages)
 	}
 	WARN(count !=3D 0, "%d pages are still in use!\n", count);
 }
+EXPORT_SYMBOL(free_contig_range);
=20
 /*
  * The zone indicated has a new number of managed_pages; batch sizes and=
 percpu
--=20
2.24.1

