Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2B41C86BD
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGKcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:32:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgEGKcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 06:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588847519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VLTLF8okWG2U8qocbOPYjuf/W5P0dXVCWo4Nb3iuQAg=;
        b=HWfo/ttFkGYtqRBHinrbWAUXGMYA7twEqvIgY6sK2QxBEj+RZ4RpmJc9xjz2R0/JxN4LWy
        pDajlhza+8EZBvA75EXp8SdxqZnMtnzbq3JjAab8KLVy2vdzWPbBGCgVfIiJ//1mafUEVg
        F19+MdELaQO9s0QhrFUa4wEH4Jdecqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-7KSFfIZuMTWeQ6b4FFHZvw-1; Thu, 07 May 2020 06:31:55 -0400
X-MC-Unique: 7KSFfIZuMTWeQ6b4FFHZvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0208780183C;
        Thu,  7 May 2020 10:31:51 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D8415D9C5;
        Thu,  7 May 2020 10:31:28 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
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
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 00/15] virtio-mem: paravirtualized memory
Date:   Thu,  7 May 2020 12:31:04 +0200
Message-Id: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is based on latest linux-next. The patches are located at:
    https://github.com/davidhildenbrand/linux.git virtio-mem-v3

Patch #1 - #10 where contained in v2 and only contain minor modifications
(mostly smaller fixes). The remaining patches are new and contain smaller
optimizations.

Details about virtio-mem can be found in the cover letter of v2 [1]. A
basic QEMU implementation was posted yesterday [2].

[1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
[2] https://lkml.kernel.org/r/20200506094948.76388-1-david@redhat.com

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

Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Robert Bradford <robert.bradford@intel.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>

David Hildenbrand (15):
  virtio-mem: Paravirtualized memory hotplug
  virtio-mem: Allow to specify an ACPI PXM as nid
  virtio-mem: Paravirtualized memory hotunplug part 1
  virtio-mem: Paravirtualized memory hotunplug part 2
  mm: Allow to offline unmovable PageOffline() pages via
    MEM_GOING_OFFLINE
  virtio-mem: Allow to offline partially unplugged memory blocks
  mm/memory_hotplug: Introduce offline_and_remove_memory()
  virtio-mem: Offline and remove completely unplugged memory blocks
  virtio-mem: Better retry handling
  MAINTAINERS: Add myself as virtio-mem maintainer
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

--=20
2.25.3

