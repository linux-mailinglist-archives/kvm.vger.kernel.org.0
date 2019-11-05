Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39051F08E0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfKEWCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:02:05 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42421 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbfKEWCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:02:04 -0500
Received: by mail-pf1-f193.google.com with SMTP id s5so8762702pfh.9;
        Tue, 05 Nov 2019 14:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Fcg154L/fnezX3/fSPC15hneW3cO4j3xqpyZ8n4o6QY=;
        b=WwfTCqzZwoHIq0TpTCX0zNoKhEtQbyFPZ17XAQSK404ALLkSpR0pKpzbYFAU0+i38n
         EkwitgqQCuqa7vf7ejCG7Z19NbXOT8aoZ3FVL4RYwuMOPhdjTkGoUcxGO4zOKVKiMKK4
         Al1hALGqK2hXj0nLmmqLSxfXRz5cyKoGfgRV/eq9Nkd8iN7lQdY7JQfs0ZU0A3JsXmvk
         lGQSpB9YVQcPp/ujGjRZ3TvVHTnGe3T12C+eMg/JPsjHKtvQ5ealhw4WL9AI3pgVfgc+
         DEMKcI24DYyKcBSukxg4QLjNYu07E/N10RSh2GAYradq0k1TBMh5VZmT/5kG6n1pnoh2
         AABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Fcg154L/fnezX3/fSPC15hneW3cO4j3xqpyZ8n4o6QY=;
        b=RAOVUXA5FWL1OmR9qbuqlUgG871RrcfUGShBzqWAo+9co4eMxlkq4RAqZaOjXhF5dF
         jetjvfCvhCrUo4jnkK2Gy0CmLG/QYFhk71BvBYBHox+l9JUf9JHoMCnZeJDs6U3Swj4I
         5z1bQL0AC49Qo2PUNCXX4db3JfFHBOXh7G8X2TVQW+2evHTRq5Dfc9p+qqbPxoxcqdQz
         W78IKTbtfo1lbvd7Lx6pr7f83zyU16dPWoJw6MfYUBMn7igAGplBpYOyPBMJV5UfTttK
         0b3T56hxP2/5vnTbvtsncWqAvV3+XQeoiRSlTWf+9hZ7JavvQQ4/udzKBsouqV4nO2sF
         jXWA==
X-Gm-Message-State: APjAAAVrh3vNtx9FdznHqk3qgG8BzwUQhN9xMnwt3GI6QBsi3S2SfckU
        TpPH95V9XfnSCBHWdsZsdjM=
X-Google-Smtp-Source: APXvYqzDFKZThjskqAs3IVGBylZXSZ9ckHXVtlUqfVC3VhDWkPwD7r1lG7AJG/F0Bv0zBn4saCHvhg==
X-Received: by 2002:a63:f501:: with SMTP id w1mr40166118pgh.307.1572991321911;
        Tue, 05 Nov 2019 14:02:01 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x70sm25528448pfd.132.2019.11.05.14.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:02:01 -0800 (PST)
Subject: [PATCH v13 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 05 Nov 2019 14:02:00 -0800
Message-ID: <20191105215940.15144.65968.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an asynchronous means of reporting unused guest
pages to a hypervisor so that the memory associated with those pages can
be dropped and reused by other processes and/or guests on the host. Using
this it is possible to avoid unnecessary I/O to disk and greatly improve
performance in the case of memory overcommit on the host.

When enabled it will allocate a set of statistics to track the number of
reported pages. When the nr_free for a given free_area is greater than
this by the high water mark we will schedule a worker to begin allocating
the non-reported memory and to provide it to the reporting interface via a
scatterlist.

Currently this is only in use by virtio-balloon however there is the hope
that at some point in the future other hypervisors might be able to make
use of it. In the virtio-balloon/QEMU implementation the hypervisor is
currently using MADV_DONTNEED to indicate to the host kernel that the page
is currently unused. It will be faulted back into the guest the next time
the page is accessed.

To track if a page is reported or not the Uptodate flag was repurposed and
used as a Reported flag for Buddy pages. While we are processing the pages
in a given zone we have a set of pointers we track called
reported_boundary that is used to keep our processing time to a minimum.
Without these we would have to iterate through all of the reported pages
which would become a significant burden. I measured as much as a 20%
performance degradation without using the boundary pointers. In the event
of something like compaction needing to process the zone at the same time
it currently resorts to resetting the boundary if it is rearranging the
list. However in the future it could choose to delay processing the zone
if a flag is set indicating that a zone is being actively processed.

Below are the results from various benchmarks. I primarily focused on two
tests. The first is the will-it-scale/page_fault2 test, and the other is
a modified version of will-it-scale/page_fault1 that was enabled to use
THP. I did this as it allows for better visibility into different parts
of the memory subsystem. The guest is running with 32G for RAM on one
node of a E5-2630 v3.

Test                page_fault1 (THP)     page_fault2
Baseline         1  1209281.00  +/-0.47%   411314.00  +/-0.42%
                16  8804587.33  +/-1.80%  3419453.00  +/-1.80%

Patches applied  1  1209369.67  +/-0.06%   412187.00  +/-0.10%
                16  8812606.33  +/-0.06%  3435339.33  +/-1.82%

Patches enabled  1  1209104.67  +/-0.11%   413067.67  +/-0.43%
 MADV disabled  16  8835481.67  +/-0.29%  3463485.67  +/-0.50%

Patches enabled  1  1210367.67  +/-0.58%   416962.00  +/-0.14%
                16  8433236.00  +/-0.58%  3437897.67  +/-0.34%

The results above are for a baseline with a linux-next-20191031 kernel,
that kernel with this patch set applied but page reporting disabled in
virtio-balloon, patches applied but the madvise disabled by direct
assigning a device, and the patches applied and page reporting fully
enabled.  These results include the deviation seen between the average
value reported here versus the high and/or low value. I observed that
during the test the memory usage for the first three tests never dropped
whereas with the patches fully enabled the VM would drop to using only a
few GB of the host's memory when switching from memhog to page fault tests.

Most of the overhead seen with this patch set fully enabled is due to the
fact that accessing the reported pages will cause a page fault and the host
will have to zero the page before giving it back to the guest. The overall
guest size is kept fairly small to only a few GB while the test is running.
This overhead is much more visible when using THP than with standard 4K
pages. As such for the case where the host memory is not oversubscribed
this results in a performance regression, however if the host memory were
oversubscribed this patch set should result in a performance improvement
as swapping memory from the host can be avoided.

A brief history on the background of unused page reporting can be found at:
https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/

Changes from v11:
https://lore.kernel.org/lkml/20191001152441.27008.99285.stgit@localhost.localdomain/
Removed unnecessary whitespace change from patch 2
Minor tweak to get_unreported_page to avoid excess writes to boundary
Rewrote cover page to lay out additional performance info.

Changes from v12:
https://lore.kernel.org/lkml/20191022221223.17338.5860.stgit@localhost.localdomain/
Rebased on linux-next 20191031
Renamed page_is_reported to page_reported
Renamed add_page_to_reported_list to mark_page_reported
Dropped unused definition of add_page_to_reported_list for non-reporting case
Split free_area_reporting out from get_unreported_tail
Minor updates to cover page

---

Alexander Duyck (6):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Reported pages
      mm: Add device side and notifier for unused page reporting
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing unused page reports to host


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   88 ++++++++-
 include/linux/mmzone.h              |   60 ++----
 include/linux/page-flags.h          |   11 +
 include/linux/page_reporting.h      |   31 +++
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |   11 +
 mm/Makefile                         |    1 
 mm/compaction.c                     |    5 
 mm/memory_hotplug.c                 |    2 
 mm/page_alloc.c                     |  199 +++++++++++++++-----
 mm/page_reporting.c                 |  353 +++++++++++++++++++++++++++++++++++
 mm/page_reporting.h                 |  226 ++++++++++++++++++++++
 mm/shuffle.c                        |   12 +
 mm/shuffle.h                        |    6 +
 15 files changed, 905 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

--
