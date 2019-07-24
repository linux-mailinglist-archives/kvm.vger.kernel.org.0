Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDA67344A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 18:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfGXQ4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 12:56:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44351 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfGXQ4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 12:56:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so21523034pgl.11;
        Wed, 24 Jul 2019 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=PhVb6RN1Ss2cdB2PwVe0HtBm8bfHqYHCMNa/n92glxA=;
        b=eWuAulp7lVJApkFKE01P2svmwkQSz+xZKBk4ILTbKSTUXwG6JPCNOThPtpZipJJywM
         fuowmbFRGkDa4VN4iOGrb0ez3a8/f+PT1HLrK2ycWYe5GcKy2PJft0JrgMFUQkF2bieb
         ynYDQR9OITwdZktFzeBHzKB6sV1c5twRJTSBsPEnRwP0UGx9fodzsh0b20sSvwmvC2Xi
         cvRh0qC/t6520YdzswKjIplH1tFaH3L80ZrxvZWu8xdOgdPTNrqVsRj2JinU6lrnNAps
         IQlQV0ZJRP+Jdf9NjxJl5OKKqIQodIiqsGrqolvaBYG528KyU0W6Dhi7ELw8W4uH1nTa
         KROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=PhVb6RN1Ss2cdB2PwVe0HtBm8bfHqYHCMNa/n92glxA=;
        b=HAn4nZYWcrHEvrXcBVbTJ6Hm4TNvEBZzjtG7uZHvDqsF93yyQZfakCz29FoYA2w2eU
         QkT0ndohqlF7VPcul//bDkGcNIhXvYKBBM5GsMrS+jlBOfsDgu/qib2YtjDUQzc+VlQ2
         PQvKPuX1N47lMSkV3yaFdl/NC4JEpDBJhDoq7HBbKkBwNC5j7yUXJj8E4kP8mXoZXmDX
         aRaPll7diYV8/qNvw9ZU2cuYZ+u0zwyPHnbYIlpwkb4aBHOgXI3wE1/16dTKNJSAHpFW
         JZfLSkG4sd5rK9hP5BmYNkvejkjxizbHBMfG0D712BVUiq8/yFQ5lxLbMg5n5vkmroVZ
         7tiA==
X-Gm-Message-State: APjAAAXjawygl3KNZTE1NXKW61UhDqKVEmpXpZumHZUNpOsx0pHaxR6W
        a579BlbHsSGKQK/ZBJn5Mqo=
X-Google-Smtp-Source: APXvYqy5FhBKIOIqEhIwqKISuGQ+P1R0oDCuSk0WbIIGBn5tah6kKqrwZ+sY9jBZWmTnJ8zO8szXNw==
X-Received: by 2002:a63:f304:: with SMTP id l4mr81474308pgh.66.1563987370874;
        Wed, 24 Jul 2019 09:56:10 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id r61sm61815112pjb.7.2019.07.24.09.56.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 09:56:10 -0700 (PDT)
Subject: [PATCH v2 0/5] mm / virtio: Provide support for page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 24 Jul 2019 09:54:02 -0700
Message-ID: <20190724165158.6685.87228.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an asynchronous means of hinting to a hypervisor
that a guest page is no longer in use and can have the data associated
with it dropped. To do this I have implemented functionality that allows
for what I am referring to as page hinting

The functionality for this is fairly simple. When enabled it will allocate
statistics to track the number of hinted pages in a given free area. When
the number of free pages exceeds this value plus a high water value,
currently 32, it will begin performing page hinting which consists of
pulling pages off of free list and placing them into a scatter list. The
scatterlist is then given to the page hinting device and it will perform
the required action to make the pages "hinted", in the case of
virtio-balloon this results in the pages being madvised as MADV_DONTNEED
and as such they are forced out of the guest. After this they are placed
back on the free list, and an additional bit is added if they are not
merged indicating that they are a hinted buddy page instead of a standard
buddy page. The cycle then repeats with additional non-hinted pages being
pulled until the free areas all consist of hinted pages.

I am leaving a number of things hard-coded such as limiting the lowest
order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
determine what the limit is on how many pages it wants to allocate to
process the hints.

My primary testing has just been to verify the memory is being freed after
allocation by running memhog 79g on a 80g guest and watching the total
free memory via /proc/meminfo on the host. With this I have verified most
of the memory is freed after each iteration. As far as performance I have
been mainly focusing on the will-it-scale/page_fault1 test running with
16 vcpus. With that I have seen at most a 2% difference between the base
kernel without these patches and the patches with virtio-balloon disabled.
With the patches and virtio-balloon enabled with hinting the results
largely depend on the host kernel. On a 3.10 RHEL kernel I saw up to a 2%
drop in performance as I approached 16 threads, however on the the lastest
linux-next kernel I saw roughly a 4% to 5% improvement in performance for
all tests with 8 or more threads. I believe the difference seen is due to
the overhead for faulting pages back into the guest and zeroing of memory.

Patch 4 is a bit on the large side at about 600 lines of change, however
I really didn't see a good way to break it up since each piece feeds into
the next. So I couldn't add the statistics by themselves as it didn't
really make sense to add them without something that will either read or
increment/decrement them, or add the Hinted state without something that
would set/unset it. As such I just ended up adding the entire thing as
one patch. It makes it a bit bigger but avoids the issues in the previous
set where I was referencing things before they had been added.

Changes from the RFC:
https://lore.kernel.org/lkml/20190530215223.13974.22445.stgit@localhost.localdomain/
Moved aeration requested flag out of aerator and into zone->flags.
Moved bounary out of free_area and into local variables for aeration.
Moved aeration cycle out of interrupt and into workqueue.
Left nr_free as total pages instead of splitting it between raw and aerated.
Combined size and physical address values in virtio ring into one 64b value.

Changes from v1:
https://lore.kernel.org/lkml/20190619222922.1231.27432.stgit@localhost.localdomain/
Dropped "waste page treatment" in favor of "page hinting"
Renamed files and functions from "aeration" to "page_hinting"
Moved from page->lru list to scatterlist
Replaced wait on refcnt in shutdown with RCU and cancel_delayed_work_sync
Virtio now uses scatterlist directly instead of intermedate array
Moved stats out of free_area, now in seperate area and pointed to from zone
Merged patch 5 into patch 4 to improve reviewability
Updated various code comments throughout

---

Alexander Duyck (5):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Move set/get_pcppage_migratetype to mmzone.h
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Hinted pages
      virtio-balloon: Add support for providing page hints to host


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   47 ++++++
 include/linux/mmzone.h              |  116 ++++++++------
 include/linux/page-flags.h          |    8 +
 include/linux/page_hinting.h        |  139 ++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/internal.h                       |   18 ++
 mm/memory_hotplug.c                 |    1 
 mm/page_alloc.c                     |  238 ++++++++++++++++++++--------
 mm/page_hinting.c                   |  298 +++++++++++++++++++++++++++++++++++
 mm/shuffle.c                        |   24 ---
 mm/shuffle.h                        |   32 ++++
 14 files changed, 796 insertions(+), 133 deletions(-)
 create mode 100644 include/linux/page_hinting.h
 create mode 100644 mm/page_hinting.c

--
