Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD22C3902
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfJAP3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:29:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35958 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389528AbfJAP3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:29:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so8255291pfr.3;
        Tue, 01 Oct 2019 08:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=7IVtwir5rJCl/l+meHu5GdAZZYvG0EyeZNBbmna3l+s=;
        b=iRXjxotrgfUGFawrkMu5c5MHLo0jOWciV9xYLegj7/skijRl18LOSviHWG3D0kwwpq
         a7pf3LGFeK62QGv0NpnwVpbDj2sLhcjEKV/9QQkg+OcLGtTi44RrD6tvmBfc9NFNe1ZH
         2w0ZKJy1GpXdszfS7jqFersSuYcJCnjRVeTMxsjKoC9SSFpzy1GR/TR/W44A94i9Pf8l
         JyVt0GRy2BcdSX4fjVi1JXhelTVQN1+ER3S08n8zjQRMq/Mv3/A5S3BnEZxM3Aflwi2l
         R0GdZ1EetgjZYXenpxg7qyq9IXoCEWrVEt+dMu4fz/vw/hJ/nK4RYDOTtepQIi66TOV4
         omZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=7IVtwir5rJCl/l+meHu5GdAZZYvG0EyeZNBbmna3l+s=;
        b=H2S6NDxy2s5cCdzydOct+6gzEYE6kCtvabHgS2Wc+6DD349XrCzne/NUgamyh3pT9L
         P4rqNkSzOx/usM0QgcyFjkUQ393/vU3UfcaER/MoPEYEqcaHK3IyduuDumj3hCEIcyCV
         VU8kbRGIjNb22w/oy8ag6s609UrTCdD7xpAqHXE13QnSA7FI+j63ZrKkZ5CTFnXiQOD7
         CaDnkHcTVkOJ6czrd0LeTAvW6djJWethLERw65EzRLQsAT91wgXESQwUdlNZujd8Zu1m
         ddXTTb/X6oe6otF7cFzfatBCIX9x89BpnLBIaGLzq01dcR22WbMtlvTldl9OoHhTYIV5
         BRSA==
X-Gm-Message-State: APjAAAWIFM9S52ZM01mY/PZqN82xHj1A3qjJ+ygPsf/Ho1ldA/ld2VGE
        y9mR2MOBXXFbqZaK7CyvFUk=
X-Google-Smtp-Source: APXvYqw+igPOQgS5RyPXPG7xdSwHmMKAA0Hr0JZYWjNlVUght/lJ3ipL4t7XF++SFxirihSTMtDWqQ==
X-Received: by 2002:a65:68d3:: with SMTP id k19mr30947812pgt.149.1569943756735;
        Tue, 01 Oct 2019 08:29:16 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id b5sm18552586pfp.38.2019.10.01.08.29.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:29:15 -0700 (PDT)
Subject: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Tue, 01 Oct 2019 08:29:14 -0700
Message-ID: <20191001152441.27008.99285.stgit@localhost.localdomain>
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
for what I am referring to as unused page reporting. The advantage of
unused page reporting is that we can support a significant amount of
memory over-commit with improved performance as we can avoid having to
write/read memory from swap as the VM will instead actively participate
in freeing unused memory so it doesn't have to be written.

The functionality for this is fairly simple. When enabled it will allocate
statistics to track the number of reported pages in a given free area.
When the number of free pages exceeds this value plus a high water value,
currently 32, it will begin performing page reporting which consists of
pulling non-reported pages off of the free lists of a given zone and
placing them into a scatterlist. The scatterlist is then given to the page
reporting device and it will perform the required action to make the pages
"reported", in the case of virtio-balloon this results in the pages being
madvised as MADV_DONTNEED. After this they are placed back on their
original free list. If they are not merged in freeing an additional bit is
set indicating that they are a "reported" buddy page instead of a standard
buddy page. The cycle then repeats with additional non-reported pages
being pulled until the free areas all consist of reported pages.

In order to try and keep the time needed to find a non-reported page to
a minimum we maintain a "reported_boundary" pointer. This pointer is used
by the get_unreported_pages iterator to determine at what point it should
resume searching for non-reported pages. In order to guarantee pages do
not get past the scan I have modified add_to_free_list_tail so that it
will not insert pages behind the reported_boundary. Doing this allows us
to keep the overhead to a minimum as re-walking the list without the
boundary will result in as much as 18% additional overhead on a 32G VM.

If another process needs to perform a massive manipulation of the free
list, such as compaction, it can either reset a given individual boundary
which will push the boundary back to the list_head, or it can clear the
bit indicating the zone is actively processing which will result in the
reporting process resetting all of the boundaries for a given zone.

I am leaving a number of things hard-coded such as limiting the lowest
order processed to pageblock_order, and have left it up to the guest to
determine what the limit is on how many pages it wants to allocate to
process the hints. The upper limit for this is based on the size of the
queue used to store the scatterlist.

I wanted to avoid gaming the performance testing for this. As far as
possible gain a significant performance improvement should be visible in
cases where guests are forced to write/read from swap. As such, testing
it would be more of a benchmark of copying a page from swap versus just
allocating a zero page. I have been verifying that the memory is being
freed using memhog to allocate all the memory on the guest, and then
watching /proc/meminfo to verify the host sees the memory returned after
the test completes.

As far as possible regressions I have focused on cases where performing
the hinting would be non-optimal, such as cases where the code isn't
needed as memory is not over-committed, or the functionality is not in
use. I have been using the will-it-scale/page_fault1 test running with 16
vcpus and have modified it to use Transparent Huge Pages. With this I see
almost no difference with the patches applied and the feature disabled.
Likewise I see almost no difference with the feature enabled, but the
madvise disabled in the hypervisor due to a device being assigned. With
the feature fully enabled in both guest and hypervisor I see a regression
between -1.86% and -8.84% versus the baseline. I found that most of the
overhead was due to the page faulting/zeroing that comes as a result of
the pages having been evicted from the guest.

For info on earlier versions you will need to follow the links provided
with the respective versions.

Changes from v9:
https://lore.kernel.org/lkml/20190907172225.10910.34302.stgit@localhost.localdomain/
Updated cover page
Dropped per-cpu page randomization entropy patch
Added "to_tail" boolean value to __free_one_page to improve readability
Renamed __shuffle_pick_tail to shuffle_pick_tail, avoiding extra inline function
Dropped arm64 HUGLE_TLB_ORDER movement patch since it is no longer needed
Significant rewrite of page reporting functionality
  Updated logic to support interruptions from compaction
  get_unreported_page will now walk through reported sections
  Moved free_list manipulators out of mmzone.h and into page_alloc.c
  Removed page_reporting.h include from mmzone.h
  Split page_reporting.h between include/linux/ and mm/
  Added #include <asm/pgtable.h>" to mm/page_reporting.h
  Renamed page_reporting_startup/shutdown to page_reporting_register/unregister
Updated comments related to virtio page poison tracking feature

Changes from v10:
https://lore.kernel.org/lkml/20190918175109.23474.67039.stgit@localhost.localdomain/
Rebased on "Add linux-next specific files for 20190930"
Added page_is_reported() macro to prevent unneeded testing of PageReported bit
Fixed several spots where comments referred to older aeration naming
Set upper limit for phdev->capacity to page reporting high water mark
Updated virtio page poison detection logic to also cover init_on_free
Tweaked page_reporting_notify_free to reduce code size
Removed dead code in non-reporting path

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
 mm/compaction.c                     |    5 +
 mm/memory_hotplug.c                 |    2 
 mm/page_alloc.c                     |  194 +++++++++++++++----
 mm/page_reporting.c                 |  350 +++++++++++++++++++++++++++++++++++
 mm/page_reporting.h                 |  225 +++++++++++++++++++++++
 mm/shuffle.c                        |   12 +
 mm/shuffle.h                        |    6 +
 15 files changed, 896 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

--
