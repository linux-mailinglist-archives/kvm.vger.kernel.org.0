Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF45145B00
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAVRnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:43:12 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38476 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:43:11 -0500
Received: by mail-pj1-f68.google.com with SMTP id l35so222171pje.3;
        Wed, 22 Jan 2020 09:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=P5+icQ8BDY6WxlCeHi1fiyxdWvp6MMGPohpf3gPJOd4=;
        b=kWGpB8v7CqiQd5/bFL5Nz9r6nqQ9JA9tNcCevjcWdNykkdFL7HJyNllrBPhI31z/79
         1L8sMtultKc1qsv9MCIFbQnF5r5mRhTH1cXK8KGlvfUySmq6L+sHCBMDbHjHap2o76xK
         xdM0qQVf//I1G8ASyuXH1Gyp71LiWi2xKeSf5nw04OxoIAHFjtMFshTgQ+aCyH+rWQQT
         YnGhfxXwRIyDHOc9KrsgYNWxck6426XDuv3JVf+uzWsxnzAth7eXvZaQIMB5oNHPY2kr
         p04xhNiT4YXpmr0vyWJHrvklaNC9x/fQmgZHJN1hysmSabMObX4gAHv1SgMaPUHTuzGu
         cEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=P5+icQ8BDY6WxlCeHi1fiyxdWvp6MMGPohpf3gPJOd4=;
        b=lpMoRUbQTvmxEnyY8cSV4C83lbuTjeRe2eAUo3jhRSBwMcnB/WqCWZhy2nKZe8Q4MK
         u/VnyjppOibh3MWHCIb8p9rYRizVMLLUrJLwxO6tjmS3G9w2q6cTV5AeMZJFHkQm9TW1
         +qi9+lqfVGOvmziJHs+xFkFeW11YWI1ZpAyooysZeOYMeOku4fJD+dM6RvWQuV1EX1YY
         iucWLsAiPiNszG/rBVUMTtnc/jGZ3MWZfgG/TgiKThssyEJx+jv3bfnD0Gn8LdZQZ2b+
         roHZnq6ylI8R1HsKv2eSQ5pQ1efqohyxwgx8m7HiueqAzfg8JWoy21FwMAq1Vtsnk5p2
         T7SA==
X-Gm-Message-State: APjAAAV7BzEbREX6avCrj/FLU8t7w70rAeps71GiOGqhb1OaB7m2e2zK
        Y6b3jvdFLATOJ3TgxXGhsek=
X-Google-Smtp-Source: APXvYqwrrXFBUOhYuESjActt63ZoVo+k34diseqrDnaKZeQAtWnPv5/xnOO2/Hleq+jBN2tQFKY01A==
X-Received: by 2002:a17:902:7613:: with SMTP id k19mr12380575pll.7.1579714990896;
        Wed, 22 Jan 2020 09:43:10 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id b98sm4004007pjc.16.2020.01.22.09.43.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:43:10 -0800 (PST)
Subject: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
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
Date:   Wed, 22 Jan 2020 09:43:09 -0800
Message-ID: <20200122173040.6142.39116.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an asynchronous means of reporting free guest pages
to a hypervisor so that the memory associated with those pages can be
dropped and reused by other processes and/or guests on the host. Using
this it is possible to avoid unnecessary I/O to disk and greatly improve
performance in the case of memory overcommit on the host.

When enabled we will be performing a scan of free memory every 2 seconds
while pages of sufficiently high order are being freed. In each pass at
least one sixteenth of each free list will be reported. By doing this we
avoid racing against other threads that may be causing a high amount of
memory churn.

The lowest page order currently scanned when reporting pages is
pageblock_order so that this feature will not interfere with the use of
Transparent Huge Pages in the case of virtualization.

Currently this is only in use by virtio-balloon however there is the hope
that at some point in the future other hypervisors might be able to make
use of it. In the virtio-balloon/QEMU implementation the hypervisor is
currently using MADV_DONTNEED to indicate to the host kernel that the page
is currently free. It will be zeroed and faulted back into the guest the
next time the page is accessed.

To track if a page is reported or not the Uptodate flag was repurposed and
used as a Reported flag for Buddy pages. We walk though the free list
isolating pages and adding them to the scatterlist until we either
encounter the end of the list, processed as many pages as were listed in
nr_free prior to us starting, or have filled the scatterlist with pages to
be reported. If we fill the scatterlist before we reach the end of the
list we rotate the list so that the first unreported page we encounter is
moved to the head of the list as that is where we will resume after we
have freed the reported pages back into the tail of the list.

Below are the results from various benchmarks. I primarily focused on two
tests. The first is the will-it-scale/page_fault2 test, and the other is
a modified version of will-it-scale/page_fault1 that was enabled to use
THP. I did this as it allows for better visibility into different parts
of the memory subsystem. The guest is running with 32G for RAM on one
node of a E5-2630 v3. The host has had some features such as CPU turbo
disabled in the BIOS.

Test                   page_fault1 (THP)    page_fault2
Name            tasks  Process Iter  STDEV  Process Iter  STDEV
Baseline            1    1012402.50  0.14%     361855.25  0.81%
                   16    8827457.25  0.09%    3282347.00  0.34%

Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
                   16    8784741.75  0.39%    3240669.25  0.48%

Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
                   16    8756219.00  0.24%    3226608.75  0.97%

Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
 page shuffle      16    8672601.25  0.49%    3223177.75  0.40%

Patches enabled     1    1003238.00  0.22%     360211.00  0.22%
 shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%

The results above are for a baseline with a linux-next-20191219 kernel,
that kernel with this patch set applied but page reporting disabled in
virtio-balloon, the patches applied and page reporting fully enabled, the
patches enabled with page shuffling enabled, and the patches applied with
page shuffling enabled and an RFC patch that makes used of MADV_FREE in
QEMU. These results include the deviation seen between the average value
reported here versus the high and/or low value. I observed that during the
test memory usage for the first three tests never dropped whereas with the
patches fully enabled the VM would drop to using only a few GB of the
host's memory when switching from memhog to page fault tests.

Any of the overhead visible with this patch set enabled seems due to page
faults caused by accessing the reported pages and the host zeroing the page
before giving it back to the guest. This overhead is much more visible when
using THP than with standard 4K pages. In addition page shuffling seemed to
increase the amount of faults generated due to an increase in memory churn.
The overhead is reduced when using MADV_FREE as we can avoid the extra
zeroing of the pages when they are reintroduced to the host, as can be seen
when the RFC is applied with shuffling enabled.

The overall guest size is kept fairly small to only a few GB while the test
is running. If the host memory were oversubscribed this patch set should
result in a performance improvement as swapping memory in the host can be
avoided.

A brief history on the background of free page reporting can be found at:
https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/

Changes from v14:
https://lore.kernel.org/lkml/20191119214454.24996.66289.stgit@localhost.localdomain/
Renamed "unused page reporting" to "free page reporting"
  Updated code, kconfig, and patch descriptions
Split out patch for __free_isolated_page
  Renamed function to __putback_isolated_page
Rewrote core reporting functionality
  Added logic to reschedule worker in 2 seconds instead of run to completion
  Removed reported_pages statistics
  Removed REPORTING_REQUESTED bit used in zone flags
  Replaced page_reporting_dev_info refcount with state variable
  Removed scatterlist from page_reporting_dev_info
  Removed capacity from page reporting device
  Added dynamic scatterlist allocation/free at start/end of reporting process
  Updated __free_one_page so that reported pages are not always added to tail
  Added logic to handle error from report function
Updated virtio-balloon patch that adds support for page reporting
  Updated patch description to try and highlight differences in approaches
  Updated logic to reflect that we cannot limit the scatterlist from device
  Added logic to return error from report function
Moved documentation patch to end of patch set

Changes from v15:
https://lore.kernel.org/lkml/20191205161928.19548.41654.stgit@localhost.localdomain/
Rebased on linux-next-20191219
Split out patches for budget and moving head to last page processed
Updated budget code to reduce how much memory is reported per pass
Added logic to also rotate the list if we exit due a page isolation failure
Added migratetype as argument in __putback_isolated_page

Changes from v16:
https://lore.kernel.org/lkml/20200103210509.29237.18426.stgit@localhost.localdomain/
Rebased on linux-next-20200122
  Updated patch 2 to to account for removal of pr_info in __isolate_free_page
Updated patch title for patches 7, 8, and 9 to use prefix mm/page_reporting
No code changes other than conflict resolution for patch 2

---

Alexander Duyck (9):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Add function __putback_isolated_page
      mm: Introduce Reported pages
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing free page reports to host
      mm/page_reporting: Rotate reported pages to the tail of the list
      mm/page_reporting: Add budget limit on how many pages can be reported per pass
      mm/page_reporting: Add free page reporting documentation


 Documentation/vm/free_page_reporting.rst |   41 +++
 drivers/virtio/Kconfig                   |    1 
 drivers/virtio/virtio_balloon.c          |   87 +++++++
 include/linux/mmzone.h                   |   44 ----
 include/linux/page-flags.h               |   11 +
 include/linux/page_reporting.h           |   26 ++
 include/uapi/linux/virtio_balloon.h      |    1 
 mm/Kconfig                               |   11 +
 mm/Makefile                              |    1 
 mm/internal.h                            |    2 
 mm/page_alloc.c                          |  164 ++++++++++----
 mm/page_isolation.c                      |    6 
 mm/page_reporting.c                      |  364 ++++++++++++++++++++++++++++++
 mm/page_reporting.h                      |   54 ++++
 mm/shuffle.c                             |   12 -
 mm/shuffle.h                             |    6 
 16 files changed, 725 insertions(+), 106 deletions(-)
 create mode 100644 Documentation/vm/free_page_reporting.rst
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

--
