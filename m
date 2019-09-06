Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B436CABB69
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394658AbfIFOxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:53:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44929 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390603AbfIFOxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:53:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so3621327pgl.11;
        Fri, 06 Sep 2019 07:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=rjoMQB+Mq/0ixcTPll/Yse8OkMaybjf8D43LT3d+qZU=;
        b=vTKtJTgGYzko+zxYP9jTUKCr0CEaCV8I9MWTE+JyW+0OCfmB3oALdTDUOnaXz9Boph
         sOrEhQLuUtARbbCrM9mbjLUDJDbymk9ylw4rQ5oSTpg+pb4XNuRhjzi3JpIfJ0SfDlx/
         Vj5hl15j1P7NiEXVuQvkc9qmTh6Az1uyepCMS6can8870ArD2s+d2XC8iAw8vwP4ko6c
         WEm5lyyrSpSn+T0JeRVy5bxIAsQtvmtN7J/b/A9dF+a96J5ZscVpOLhczqSESCpezWeH
         2FnbAhz/LvJkxEDAcVs9REOq5YfRrVUq0ubJpYaSeVS5tlbfNEhdUgXA0Mbp+J25IXZr
         Xp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=rjoMQB+Mq/0ixcTPll/Yse8OkMaybjf8D43LT3d+qZU=;
        b=UckbjvlBUx8FFEpJPZ9X4qXzqkATQnXqPa3fUxQhYfbEgOc3mbUxuZIeZKVrCNzoU4
         pmGDJyhKyTybbxfpXlkoftf7f+DrR9laNjYPfYONDqqA6ucevIo52Cla7lzZEVblD01s
         RgcLXUxliyv3zJfrs6hBdiqjtAoCHTqgEk+TdF3PYUneuA6wYjAH1H6KXNPvxcEzvosG
         ePbY0oplt5egd76V6doKH9EXwa7LrtJ/M1d9Dnc1F/ilkgU48YRGsYhAfXSPqp1SV5Ww
         iourUU8gzvnpz8PJlH8pOsjD33FpOU31N8hAOyXVrWC13GkVby9+HGjb+T4AQJ8/jUGR
         fUhA==
X-Gm-Message-State: APjAAAUjUvofoqu1pp05jKaEIMULZ8yxqP/HcGlh4QRelMKsNo9CeuJS
        BHHFQ27mwz7N1ckvnme+fjo=
X-Google-Smtp-Source: APXvYqz/VYIeGaQ7/nloI3Gq0Su4n93sg05uXSyruDOcPtM8ukUWtB0e4mHXCeiQtVrowWPTWIhBaQ==
X-Received: by 2002:a62:ee0a:: with SMTP id e10mr11272952pfi.197.1567781602887;
        Fri, 06 Sep 2019 07:53:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c1sm7901978pfd.117.2019.09.06.07.53.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:53:22 -0700 (PDT)
Subject: [PATCH v8 0/7] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Fri, 06 Sep 2019 07:53:21 -0700
Message-ID: <20190906145213.32552.30160.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an asynchronous means of reporting to a hypervisor
that a guest page is no longer in use and can have the data associated
with it dropped. To do this I have implemented functionality that allows
for what I am referring to as unused page reporting

The functionality for this is fairly simple. When enabled it will allocate
statistics to track the number of reported pages in a given free area.
When the number of free pages exceeds this value plus a high water value,
currently 32, it will begin performing page reporting which consists of
pulling pages off of free list and placing them into a scatter list. The
scatterlist is then given to the page reporting device and it will perform
the required action to make the pages "reported", in the case of
virtio-balloon this results in the pages being madvised as MADV_DONTNEED
and as such they are forced out of the guest. After this they are placed
back on the free list, and an additional bit is added if they are not
merged indicating that they are a reported buddy page instead of a
standard buddy page. The cycle then repeats with additional non-reported
pages being pulled until the free areas all consist of reported pages.

I am leaving a number of things hard-coded such as limiting the lowest
order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
determine what the limit is on how many pages it wants to allocate to
process the hints. The upper limit for this is based on the size of the
queue used to store the scattergather list.

My primary testing has just been to verify the memory is being freed after
allocation by running memhog 40g on a 40g guest and watching the total
free memory via /proc/meminfo on the host. With this I have verified most
of the memory is freed after each iteration. As far as performance I have
been mainly focusing on the will-it-scale/page_fault1 test running with
16 vcpus. I have modified it to use Transparent Huge Pages. With this I
see almost no difference, -0.08%, with the patches applied and the feature
disabled. I see a regression of -0.86% with the feature enabled, but the
madvise disabled in the hypervisor due to a device being assigned. With
the feature fully enabled I see a regression of -3.27% versus the baseline
without these patches applied. In my testing I found that most of the
overhead was due to the page zeroing that comes as a result of the pages
having to be faulted back into the guest.

One side effect of these patches is that the guest becomes much more
resilient in terms of NUMA locality. With the pages being freed and then
reallocated when used it allows for the pages to be much closer to the
active thread, and as a result there can be situations where this patch
set will out-perform the stock kernel when the guest memory is not local
to the guest vCPUs. To avoid that in my testing I set the affinity of all
the vCPUs and QEMU instance to the same node.

Changes from the RFC:
https://lore.kernel.org/lkml/20190530215223.13974.22445.stgit@localhost.localdomain/
Moved aeration requested flag out of aerator and into zone->flags.
Moved boundary out of free_area and into local variables for aeration.
Moved aeration cycle out of interrupt and into workqueue.
Left nr_free as total pages instead of splitting it between raw and aerated.
Combined size and physical address values in virtio ring into one 64b value.

Changes from v1:
https://lore.kernel.org/lkml/20190619222922.1231.27432.stgit@localhost.localdomain/
Dropped "waste page treatment" in favor of "page hinting"
Renamed files and functions from "aeration" to "page_hinting"
Moved from page->lru list to scatterlist
Replaced wait on refcnt in shutdown with RCU and cancel_delayed_work_sync
Virtio now uses scatterlist directly instead of intermediate array
Moved stats out of free_area, now in separate area and pointed to from zone
Merged patch 5 into patch 4 to improve review-ability
Updated various code comments throughout

Changes from v2:
https://lore.kernel.org/lkml/20190724165158.6685.87228.stgit@localhost.localdomain/
Dropped "page hinting" in favor of "page reporting"
Renamed files from "hinting" to "reporting"
Replaced "Hinted" page type with "Reported" page flag
Added support for page poisoning while hinting is active
Add QEMU patch that implements PAGE_POISON feature

Changes from v3:
https://lore.kernel.org/lkml/20190801222158.22190.96964.stgit@localhost.localdomain/
Added mutex lock around page reporting startup and shutdown
Fixed reference to "page aeration" in patch 2
Split page reporting function bit out into separate QEMU patch
Limited capacity of scatterlist to vq size - 1 instead of vq size
Added exception handling for case of virtio descriptor allocation failure

Changes from v4:
https://lore.kernel.org/lkml/20190807224037.6891.53512.stgit@localhost.localdomain/
Replaced spin_(un)lock with spin_(un)lock_irq in page_reporting_cycle()
Dropped if/continue for ternary operator in page_reporting_process()
Added checks for isolate and cma types to for_each_reporting_migratetype_order
Added virtio-dev, Michal Hocko, and Oscar Salvador to to:/cc:
Rebased on latest linux-next and QEMU git trees

Changes from v5:
https://lore.kernel.org/lkml/20190812213158.22097.30576.stgit@localhost.localdomain/
Replaced spin_(un)lock with spin_(un)lock_irq in page_reporting_startup()
Updated shuffle code to use "shuffle_pick_tail" and updated patch description
Dropped storage of order and migratettype while page is being reported
Used get_pfnblock_migratetype to determine migratetype of page
Renamed put_reported_page to free_reported_page, added order as argument
Dropped check for CMA type as I believe we should be reporting those
Added code to allow moving of reported pages into and out of isolation
Defined page reporting order as minimum of Huge Page size vs MAX_ORDER - 1
Cleaned up use of static branch usage for page_reporting_notify_enabled

Changes from v6:
https://lore.kernel.org/lkml/20190821145806.20926.22448.stgit@localhost.localdomain/
Rebased on linux-next for 20190903
Added jump label to __page_reporting_request so we release RCU read lock
Removed "- 1" from capacity limit based on virtio ring
Added code to verify capacity is non-zero or return error on startup

Changes from v7:
https://lore.kernel.org/lkml/20190904150920.13848.32271.stgit@localhost.localdomain/
Updated poison fixes to clear flag if "nosanity" is enabled in kernel config
Split shuffle per-cpu optimization into seperate patch
Moved check for !phdev->capacity into reporting patch where it belongs
Added Reviewed-by tags received for v7

---

Alexander Duyck (7):
      mm: Add per-cpu logic to page shuffling
      mm: Adjust shuffle code to allow for future coalescing
      mm: Move set/get_pcppage_migratetype to mmzone.h
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Reported pages
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing unused page reports to host


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   87 ++++++++-
 include/linux/mmzone.h              |  124 ++++++++-----
 include/linux/page-flags.h          |   11 +
 include/linux/page_reporting.h      |  177 ++++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/internal.h                       |   18 ++
 mm/memory_hotplug.c                 |    1 
 mm/page_alloc.c                     |  216 ++++++++++++++++------
 mm/page_reporting.c                 |  340 +++++++++++++++++++++++++++++++++++
 mm/shuffle.c                        |   40 ++--
 mm/shuffle.h                        |   12 +
 14 files changed, 902 insertions(+), 132 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

--
