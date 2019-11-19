Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763AD102E79
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 22:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKSVqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 16:46:16 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44950 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKSVqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 16:46:16 -0500
Received: by mail-yw1-f67.google.com with SMTP id p128so7888270ywc.11;
        Tue, 19 Nov 2019 13:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=pUpWlzhNnUNrlheiRsxAz8OGFtPbKHfioHTNH0/oEpE=;
        b=JBrWf6e4IA8PUaXiQepHokT5R8iFYw1TRXjXUUVZtSdMQJk3bpaJpVUOCeSN/bZNho
         LH0WyDQF+fGSZkRfy1bZbEdm+I8eWWNdgTuatgbsZlzcc+CnSJejSfW/coRMo4175zoX
         EdAGXmly+HemG48vd1MF5bdMyd1F2TKrOl6xi92ZdzdDJxe8Y6eN/WcbYQWMKl5oJAcP
         tD1jZYtswA16KrtRooMm2io5iF+s+XM5urtJmYfvuAimFo4dbgiEbBdy7pLqWCq6KRDu
         KUAN1/0XjEEU59V89QXvHF0tpa5UNqbI9gXbyfBGSXB6buIICiFJJTl6e+QYxL0oE5fB
         +K4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=pUpWlzhNnUNrlheiRsxAz8OGFtPbKHfioHTNH0/oEpE=;
        b=G43Q1qM7GizyM7+3yeA0x7hvCEVuUUvc/Hy0kjg6gn0mV3huBPMcZ4EGifhgCRtw8j
         QsdsdUmi5tWHrwuVBH+3EyG56Br7fW9NaaOTU3TbZ+Y1rZQofHRSMCcs/rRRPvKKzL79
         ibjAd6/XL/ZMj95375k7WoOX2s5aBEYZeE2SD+B9XWPrJ3lrIYR93VnBwpYVb/HLj7oK
         SWvaykWh254cWvm1J23NTfBNSeUOZgYfLX/JnEFByU+7keQsqiR4xINZZ8sj+QPYMWDc
         j+HiCRBe7hF70q97ahWoL54eikWZzVXXKEWeYmFYgeSaROlOFClyKzd2+cwEOwhW30P5
         KQDw==
X-Gm-Message-State: APjAAAUApg+QfdU3jaLTCCK7yybz4FferSMvvHL07D2Tr9XuQzr9/Lm1
        0Kih5timy5Buz2nl8l6I3Qk=
X-Google-Smtp-Source: APXvYqyqnM7Mm250334POn8xmkE9jk/uGBRqiWKn9Tf1/k5diRgcKFSXylHiVM4SVIF7IsEWqpz/vw==
X-Received: by 2002:a81:168c:: with SMTP id 134mr4308yww.436.1574199973120;
        Tue, 19 Nov 2019 13:46:13 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id s18sm10437781ywk.33.2019.11.19.13.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:46:12 -0800 (PST)
Subject: [PATCH v14 0/6] mm / virtio: Provide support for unused page
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
Date:   Tue, 19 Nov 2019 13:46:09 -0800
Message-ID: <20191119214454.24996.66289.stgit@localhost.localdomain>
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
reported pages. When the nr_free for a given free area is greater than
this by the high water mark we will schedule a worker to begin pulling the
non-reported memory and to provide it to the reporting interface via a
scatterlist.

Currently this is only in use by virtio-balloon however there is the hope
that at some point in the future other hypervisors might be able to make
use of it. In the virtio-balloon/QEMU implementation the hypervisor is
currently using MADV_DONTNEED to indicate to the host kernel that the page
is currently unused. It will be zeroed and faulted back into the guest the
next time the page is accessed.

To track if a page is reported or not the Uptodate flag was repurposed and
used as a Reported flag for Buddy pages. We walk though the free list
isolating pages and adding them to the scatterlist until we either
encounter the end of the list or have filled the scatterlist with pages to
be reported. If we fill the scatterlist before we reach the end of the
list we rotate the list so that the first unreported page we encounter is
moved to the head of the list as that is where we will resume after we
have freed the reported pages back into the tail of the list.

Below are the results from various benchmarks. I primarily focused on two
tests. The first is the will-it-scale/page_fault2 test, and the other is
a modified version of will-it-scale/page_fault1 that was enabled to use
THP. I did this as it allows for better visibility into different parts
of the memory subsystem. The guest is running with 32G for RAM on one
node of a E5-2630 v3. The host has had some power saving features disabled
by setting the /dev/cpu_dma_latency value to 10ms.

Test                page_fault1 (THP)     page_fault2
Name         tasks  Process Iter  STDEV  Process Iter  STDEV
Baseline         1    1203934.75  0.04%     379940.75  0.11%
                16    8828217.00  0.85%    3178653.00  1.28%

Patches applied  1    1207961.25  0.10%     380852.25  0.25%
                16    8862373.00  0.98%    3246397.25  0.68%

Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
 MADV disabled  16    8870373.75  0.29%	   3204989.75  1.08%

Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
                16    8371359.75  0.65%    3233665.50  0.84%

Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
 page shuffle   16    8108719.75  0.58%    3218450.25  1.07%

The results above are for a baseline with a linux-next-20191115 kernel,
that kernel with this patch set applied but page reporting disabled in
virtio-balloon, patches applied but the madvise disabled by direct
assigning a device, the patches applied and page reporting fully
enabled, and the patches enabled with page shuffling enabled.  These
results include the deviation seen between the average value reported here
versus the high and/or low value. I observed that during the test memory
usage for the first three tests never dropped whereas with the patches
fully enabled the VM would drop to using only a few GB of the host's
memory when switching from memhog to page fault tests.

Most of the overhead seen with this patch set enabled seems due to page
faults caused by accessing the reported pages and the host zeroing the page
before giving it back to the guest. This overhead is much more visible when
using THP than with standard 4K pages. In addition page shuffling seemed to
increase the amount of faults generated due to an increase in memory churn.

The overall guest size is kept fairly small to only a few GB while the test
is running. If the host memory were oversubscribed this patch set should
result in a performance improvement as swapping memory in the host can be
avoided.

A brief history on the background of unused page reporting can be found at:
https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/

Changes from v12:
https://lore.kernel.org/lkml/20191022221223.17338.5860.stgit@localhost.localdomain/
Rebased on linux-next 20191031
Renamed page_is_reported to page_reported
Renamed add_page_to_reported_list to mark_page_reported
Dropped unused definition of add_page_to_reported_list for non-reporting case
Split free_area_reporting out from get_unreported_tail
Minor updates to cover page

Changes from v13:
https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost.localdomain/
Rewrote core reporting functionality
  Merged patches 3 & 4
  Dropped boundary list and related code
  Folded get_reported_page into page_reporting_fill
  Folded page_reporting_fill into page_reporting_cycle
Pulled reporting functionality out of free_reported_page
  Renamed it to __free_isolated_page
  Moved page reporting specific bits to page_reporting_drain
Renamed phdev to prdev since we aren't "hinting" we are "reporting"
Added documentation to describe the usage of unused page reporting
Updated cover page and patch descriptions to avoid mention of boundary


---

Alexander Duyck (6):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Reported pages
      mm: Add unused page reporting documentation
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing unused page reports to host


 Documentation/vm/unused_page_reporting.rst |   44 ++++
 drivers/virtio/Kconfig                     |    1 
 drivers/virtio/virtio_balloon.c            |   88 +++++++
 include/linux/mmzone.h                     |   56 +----
 include/linux/page-flags.h                 |   11 +
 include/linux/page_reporting.h             |   31 +++
 include/uapi/linux/virtio_balloon.h        |    1 
 mm/Kconfig                                 |   11 +
 mm/Makefile                                |    1 
 mm/memory_hotplug.c                        |    2 
 mm/page_alloc.c                            |  181 +++++++++++----
 mm/page_reporting.c                        |  337 ++++++++++++++++++++++++++++
 mm/page_reporting.h                        |  125 ++++++++++
 mm/shuffle.c                               |   12 -
 mm/shuffle.h                               |    6 
 15 files changed, 805 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/vm/unused_page_reporting.rst
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

--
