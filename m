Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA7D855F4
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 00:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbfHGWlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 18:41:44 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:34872 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGWlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 18:41:44 -0400
Received: by mail-pl1-f170.google.com with SMTP id w24so42643916plp.2;
        Wed, 07 Aug 2019 15:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=DhnaK+E+cD1d4FfpxlhTEJTkSE09JujNXjxgkkK1vJE=;
        b=YaA1+UJgWbYYhzA5ckir1hw+FEk6ooMKk5sxW19z4hdcLO5udpPEh6tEyudLebcAh0
         MaJd6MzePwU7wnzaxsP0a64TSWwNqTyFyeAwyl1D1NoqtTRncdFx8aUDn0dfXCSy9eKl
         I7IfSH7OCmiI0YC0cRS7u+3iq3zZI/Xr9eI5XrlJPEzCMOYxnjWJ6InRCvDlg0Fj2DaJ
         n7G1IjpFBmmjnby80AzF0kphE4Mi7Fk3w0JsxZP1ba35MgtcO0st+cBjrAgGn0qax68M
         YhBozEOk83Yi9BF45fZ7GdGo/VgkR+3f4M9vrLTdVHp48FFvvaHV49CXioDsGSy2HYPa
         6SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=DhnaK+E+cD1d4FfpxlhTEJTkSE09JujNXjxgkkK1vJE=;
        b=IaXugj9WVEUpwsZoFPcbjL57UFzhHD5rt0+w4PwavUTpLL0B4PinGUnZUyXe76bo6U
         OUI01+OmQrV9zd+TAMr/1g4PJgV/T3pnWNc7teNE7MtvqnWIt4VOwyhmMEXsV9TyOCN8
         QOnvc4GF/HF1pDQFs2/xrEiu/P9bdO2ufLETKxbnJcw+G/IJvTRF7wyAU9K6XV2XqyEv
         FwV0D7/HHdjH2dFIftcP0J9AhDpKmlx0xxnQerDu5dVLztkZg2kzMCnq0VQZP39+xh8G
         C/UhXyLUzDI40JYOmjLStzGQvIBldXTY32kW9G+APKAl0KGZGf5RTX66NGk8Q9dSifT9
         E+KA==
X-Gm-Message-State: APjAAAUACSRhrHgH0a/YyBvNScp5L9k2x6Kivei5ysQwYmUlCF2y56Mg
        /J17K79KWQJkh2miVoODYG0=
X-Google-Smtp-Source: APXvYqxLZr/16PeXJ4PFdN305ipuBBLeLVoDqSoS42N/o1FnkzSdt4bS8MHl+GGCe3JLu7QffAnFZg==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr10433713plo.42.1565217702846;
        Wed, 07 Aug 2019 15:41:42 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e189sm80104548pgc.15.2019.08.07.15.41.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:41:42 -0700 (PDT)
Subject: [PATCH v4 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Wed, 07 Aug 2019 15:41:41 -0700
Message-ID: <20190807224037.6891.53512.stgit@localhost.localdomain>
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

---

Alexander Duyck (6):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Move set/get_pcppage_migratetype to mmzone.h
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Reported pages
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing unused page reports to host


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   84 +++++++++
 include/linux/mmzone.h              |  116 ++++++++-----
 include/linux/page-flags.h          |   11 +
 include/linux/page_reporting.h      |  138 +++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/internal.h                       |   18 ++
 mm/memory_hotplug.c                 |    1 
 mm/page_alloc.c                     |  238 +++++++++++++++++++--------
 mm/page_reporting.c                 |  313 +++++++++++++++++++++++++++++++++++
 mm/shuffle.c                        |   24 ---
 mm/shuffle.h                        |   32 ++++
 14 files changed, 844 insertions(+), 139 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

--
