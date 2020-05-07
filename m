Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900631C8D5D
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEGOC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 10:02:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725953AbgEGOC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 10:02:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588860173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kvuJlgdu8CYgQhsdBt2rDY9C6TscE/9QuM1q1Smjntc=;
        b=KGB3E3wpUfd+Xe1ENxeyRwTB3BUcf2RyL9auuu72SZrr+64epGM+MSmeyQubZRzE3FeQFx
        Vg1AulhTFCxzahB2Gh9vX7jhTqENZXtAkPEFx1o3xygJAhW1Id6fuH944qDqYMhg1JQRn+
        cXX9ZZjMti2ThdMTqJjGemiY5XoJaFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-f88VkdM-MWil9n9Y9a7FmQ-1; Thu, 07 May 2020 10:02:47 -0400
X-MC-Unique: f88VkdM-MWil9n9Y9a7FmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 605E9835B43;
        Thu,  7 May 2020 14:02:44 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F67A6109E;
        Thu,  7 May 2020 14:02:35 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
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
Subject: [PATCH v4 05/15] virtio-mem: Paravirtualized memory hotunplug part 2
Date:   Thu,  7 May 2020 16:01:29 +0200
Message-Id: <20200507140139.17083-6-david@redhat.com>
In-Reply-To: <20200507140139.17083-1-david@redhat.com>
References: <20200507140139.17083-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
onlining the memory block from pages allocated via alloc_contig_range(), we
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

Acked-by: Michal Hocko <mhocko@suse.com> # to export contig range allocator API
Tested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
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
index d6dde7d2cf76..4c1e14615001 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -85,6 +85,7 @@ config VIRTIO_MEM
 	depends on VIRTIO
 	depends on MEMORY_HOTPLUG_SPARSE
 	depends on MEMORY_HOTREMOVE
+	select CONTIG_ALLOC
 	help
 	 This driver provides access to virtio-mem paravirtualized memory
 	 devices, allowing to hotplug and hotunplug memory.
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index a3ec795be8be..74f0d3cb1d22 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -23,6 +23,10 @@
 
 #include <acpi/acpi_numa.h>
 
+static bool unplug_online = true;
+module_param(unplug_online, bool, 0644);
+MODULE_PARM_DESC(unplug_online, "Try to unplug online memory");
+
 enum virtio_mem_mb_state {
 	/* Unplugged, not added to Linux. Can be reused later. */
 	VIRTIO_MEM_MB_STATE_UNUSED = 0,
@@ -654,23 +658,35 @@ static int virtio_mem_memory_notifier_cb(struct notifier_block *nb,
 }
 
 /*
- * Set a range of pages PG_offline.
+ * Set a range of pages PG_offline. Remember pages that were never onlined
+ * (via generic_online_page()) using PageDirty().
  */
 static void virtio_mem_set_fake_offline(unsigned long pfn,
-					unsigned int nr_pages)
+					unsigned int nr_pages, bool onlined)
 {
-	for (; nr_pages--; pfn++)
-		__SetPageOffline(pfn_to_page(pfn));
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		__SetPageOffline(page);
+		if (!onlined)
+			SetPageDirty(page);
+	}
 }
 
 /*
- * Clear PG_offline from a range of pages.
+ * Clear PG_offline from a range of pages. If the pages were never onlined,
+ * (via generic_online_page()), clear PageDirty().
  */
 static void virtio_mem_clear_fake_offline(unsigned long pfn,
-					  unsigned int nr_pages)
+					  unsigned int nr_pages, bool onlined)
 {
-	for (; nr_pages--; pfn++)
-		__ClearPageOffline(pfn_to_page(pfn));
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		__ClearPageOffline(page);
+		if (!onlined)
+			ClearPageDirty(page);
+	}
 }
 
 /*
@@ -686,10 +702,26 @@ static void virtio_mem_fake_online(unsigned long pfn, unsigned int nr_pages)
 	 * We are always called with subblock granularity, which is at least
 	 * aligned to MAX_ORDER - 1.
 	 */
-	virtio_mem_clear_fake_offline(pfn, nr_pages);
+	for (i = 0; i < nr_pages; i += 1 << order) {
+		struct page *page = pfn_to_page(pfn + i);
 
-	for (i = 0; i < nr_pages; i += 1 << order)
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
 
 static void virtio_mem_online_page_cb(struct page *page, unsigned int order)
@@ -718,7 +750,8 @@ static void virtio_mem_online_page_cb(struct page *page, unsigned int order)
 		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
 			generic_online_page(page, order);
 		else
-			virtio_mem_set_fake_offline(PFN_DOWN(addr), 1 << order);
+			virtio_mem_set_fake_offline(PFN_DOWN(addr), 1 << order,
+						    false);
 		rcu_read_unlock();
 		return;
 	}
@@ -1186,6 +1219,72 @@ static int virtio_mem_mb_unplug_any_sb_offline(struct virtio_mem *vm,
 	return 0;
 }
 
+/*
+ * Unplug the desired number of plugged subblocks of an online memory block.
+ * Will skip subblock that are busy.
+ *
+ * Will modify the state of the memory block.
+ *
+ * Note: Can fail after some subblocks were successfully unplugged. Can
+ *       return 0 even if subblocks were busy and could not get unplugged.
+ */
+static int virtio_mem_mb_unplug_any_sb_online(struct virtio_mem *vm,
+					      unsigned long mb_id,
+					      uint64_t *nb_sb)
+{
+	const unsigned long nr_pages = PFN_DOWN(vm->subblock_size);
+	unsigned long start_pfn;
+	int rc, sb_id;
+
+	/*
+	 * TODO: To increase the performance we want to try bigger, consecutive
+	 * subblocks first before falling back to single subblocks. Also,
+	 * we should sense via something like is_mem_section_removable()
+	 * first if it makes sense to go ahead any try to allocate.
+	 */
+	for (sb_id = 0; sb_id < vm->nb_sb_per_mb && *nb_sb; sb_id++) {
+		/* Find the next candidate subblock */
+		while (sb_id < vm->nb_sb_per_mb &&
+		       !virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
+			sb_id++;
+		if (sb_id >= vm->nb_sb_per_mb)
+			break;
+
+		start_pfn = PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
+				     sb_id * vm->subblock_size);
+		rc = alloc_contig_range(start_pfn, start_pfn + nr_pages,
+					MIGRATE_MOVABLE, GFP_KERNEL);
+		if (rc == -ENOMEM)
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
+		rc = virtio_mem_mb_unplug_sb(vm, mb_id, sb_id, 1);
+		if (rc) {
+			/* Return the memory to the buddy. */
+			virtio_mem_fake_online(start_pfn, nr_pages);
+			return rc;
+		}
+
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL);
+		*nb_sb -= 1;
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
@@ -1225,8 +1324,37 @@ static int virtio_mem_unplug_request(struct virtio_mem *vm, uint64_t diff)
 		cond_resched();
 	}
 
+	if (!unplug_online) {
+		mutex_unlock(&vm->hotplug_mutex);
+		return 0;
+	}
+
+	/* Try to unplug subblocks of partially plugged online blocks. */
+	virtio_mem_for_each_mb_state_rev(vm, mb_id,
+					 VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL) {
+		rc = virtio_mem_mb_unplug_any_sb_online(vm, mb_id,
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
+		rc = virtio_mem_mb_unplug_any_sb_online(vm, mb_id,
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
@@ -1332,7 +1460,8 @@ static void virtio_mem_run_wq(struct work_struct *work)
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
index 69827d4fa052..43fbee4ee606 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8594,6 +8594,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 				pfn_max_align_up(end), migratetype);
 	return ret;
 }
+EXPORT_SYMBOL(alloc_contig_range);
 
 static int __alloc_contig_pages(unsigned long start_pfn,
 				unsigned long nr_pages, gfp_t gfp_mask)
@@ -8709,6 +8710,7 @@ void free_contig_range(unsigned long pfn, unsigned int nr_pages)
 	}
 	WARN(count != 0, "%d pages are still in use!\n", count);
 }
+EXPORT_SYMBOL(free_contig_range);
 
 /*
  * The zone indicated has a new number of managed_pages; batch sizes and percpu
-- 
2.25.3

