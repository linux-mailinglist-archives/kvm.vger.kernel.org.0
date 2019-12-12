Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61A311D34E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfLLRMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:12:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56105 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730138AbfLLRMl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cioP1Au5xwfJCBdcc5XOpwCVArGo5wEcHN4WYiyUNDA=;
        b=A/xMs0OeYvn3A/CIJdsRru/ijEZeM5kPXJBzpdFZ7QdR6AgAphwH1kDQ7PUGMQYk2VfbTH
        4MDkiCpRjnMOKzSHuHOZJsOO+7QhDHMNA8m6vZD6LkQoOpUla0od4HgsKX6e5MBbkwAtgf
        GyyHyOrXMlCpPhI9d6P0GAMZ8WWSK1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Cq7CVDBDPvKYM77AioR_vg-1; Thu, 12 Dec 2019 12:12:30 -0500
X-MC-Unique: Cq7CVDBDPvKYM77AioR_vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27E901005502;
        Thu, 12 Dec 2019 17:12:28 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D4E25C1C3;
        Thu, 12 Dec 2019 17:12:19 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH RFC v4 04/13] mm: Export alloc_contig_range() / free_contig_range()
Date:   Thu, 12 Dec 2019 18:11:28 +0100
Message-Id: <20191212171137.13872-5-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A virtio-mem device wants to allocate memory from the memory region it
manages in order to unplug it in the hypervisor - similar to
a balloon driver. Also, it might want to plug previously unplugged
(allocated) memory and give it back to Linux. alloc_contig_range() /
free_contig_range() seem to be the perfect interface for this task.

In contrast to existing balloon devices, a virtio-mem device operates
on bigger chunks (e.g., 4MB) and only on physical memory it manages. It
tracks which chunks (subblocks) are still plugged, so it can go ahead
and try to alloc_contig_range()+unplug them on unplug request, or
plug+free_contig_range() unplugged chunks on plug requests.

A virtio-mem device will use alloc_contig_range() / free_contig_range()
only on ranges that belong to the same node/zone in at least
MAX(MAX_ORDER - 1, pageblock_order) order granularity - e.g., 4MB on
x86-64. The virtio-mem device added that memory, so the memory
exists and does not contain any holes. virtio-mem will only try to alloca=
te
on ZONE_NORMAL, never on ZONE_MOVABLE, just like when allocating
gigantic pages (we don't put unmovable data into the movable zone).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Alexander Potapenko <glider@google.com>
Acked-by: Michal Hocko <mhocko@suse.com> # to export contig range allocat=
or API
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 62dcd6b76c80..5334decc9e06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8494,6 +8494,7 @@ int alloc_contig_range(unsigned long start, unsigne=
d long end,
 				pfn_max_align_up(end), migratetype);
 	return ret;
 }
+EXPORT_SYMBOL(alloc_contig_range);
=20
 static int __alloc_contig_pages(unsigned long start_pfn,
 				unsigned long nr_pages, gfp_t gfp_mask)
@@ -8609,6 +8610,7 @@ void free_contig_range(unsigned long pfn, unsigned =
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
2.23.0

