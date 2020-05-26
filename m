Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8441C8D38
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEGOCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 10:02:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28597 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726408AbgEGOCN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 10:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588860131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YnnUFsND7O7jqtL6msM8nwBMUisTSmUw25RGNt2JJrs=;
        b=cA2dOUFyzz3xZhTTLdSIVp2NdSKgyvVyjJ7QTDkMFgWT9gTFSDzCrdeUyfPikRSQMu3xGf
        Mq74s3CzLtsnht/MY5YB3umFiMFUBEIhpmuc16oAZyq+CtENaxIBF23J2auFnsQThh6Tyl
        aRd0kk9AqCyan2cnxq6EYo9YLniVyaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-rdP8lYCVMWC9u4yrElCVAQ-1; Thu, 07 May 2020 10:02:03 -0400
X-MC-Unique: rdP8lYCVMWC9u4yrElCVAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4169835B45;
        Thu,  7 May 2020 14:01:58 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF26260FB9;
        Thu,  7 May 2020 14:01:40 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v4 00/15] virtio-mem: paravirtualized memory
Date:   Thu,  7 May 2020 16:01:24 +0200
Message-Id: <20200507140139.17083-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is based on v5.7-rc4. The patches are located at:
    https://github.com/davidhildenbrand/linux.git virtio-mem-v4

This is basically a resend of v3 [1], now based on v5.7-rc4 and restested.
One patch was reshuffled and two ACKs I missed to add were added. The
rebase did not require any modifications to patches.

Details about virtio-mem can be found in the cover letter of v2 [2]. A
basic QEMU implementation was posted yesterday [3].

[1] https://lkml.kernel.org/r/20200507103119.11219-1-david@redhat.com
[2] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
[3] https://lkml.kernel.org/r/20200506094948.76388-1-david@redhat.com

v3 -> v4:
- Move "MAINTAINERS: Add myself as virtio-mem maintainer" to #2
- Add two ACKs from Andrew (in reply to v2)
-- "mm: Allow to offline unmovable PageOffline() pages via ..."
-- "mm/memory_hotplug: Introduce offline_and_remove_memory()"

v2 -> v3:
- "virtio-mem: Paravirtualized memory hotplug"
-- Include "linux/slab.h" to fix build issues
-- Remember the "region_size", helpful for patch #11
-- Minor simplifaction in virtio_mem_overlaps_range()
-- Use notifier_from_errno() instead of notifier_to_errno() in notifier
-- More reliable check for added memory when unloading the driver
- "virtio-mem: Allow to specify an ACPI PXM as nid"
-- Also print the nid
- Added patch #11-#15

David Hildenbrand (15):
  virtio-mem: Paravirtualized memory hotplug
  MAINTAINERS: Add myself as virtio-mem maintainer
  virtio-mem: Allow to specify an ACPI PXM as nid
  virtio-mem: Paravirtualized memory hotunplug part 1
  virtio-mem: Paravirtualized memory hotunplug part 2
  mm: Allow to offline unmovable PageOffline() pages via
    MEM_GOING_OFFLINE
  virtio-mem: Allow to offline partially unplugged memory blocks
  mm/memory_hotplug: Introduce offline_and_remove_memory()
  virtio-mem: Offline and remove completely unplugged memory blocks
  virtio-mem: Better retry handling
  virtio-mem: Add parent resource for all added "System RAM"
  virtio-mem: Drop manual check for already present memory
  virtio-mem: Unplug subblocks right-to-left
  virtio-mem: Use -ETXTBSY as error code if the device is busy
  virtio-mem: Try to unplug the complete online memory block first

 MAINTAINERS                     |    7 +
 drivers/acpi/numa/srat.c        |    1 +
 drivers/virtio/Kconfig          |   17 +
 drivers/virtio/Makefile         |    1 +
 drivers/virtio/virtio_mem.c     | 1962 +++++++++++++++++++++++++++++++
 include/linux/memory_hotplug.h  |    1 +
 include/linux/page-flags.h      |   10 +
 include/uapi/linux/virtio_ids.h |    1 +
 include/uapi/linux/virtio_mem.h |  208 ++++
 mm/memory_hotplug.c             |   81 +-
 mm/page_alloc.c                 |   26 +
 mm/page_isolation.c             |    9 +
 12 files changed, 2314 insertions(+), 10 deletions(-)
 create mode 100644 drivers/virtio/virtio_mem.c
 create mode 100644 include/uapi/linux/virtio_mem.h

-- 
2.25.3

