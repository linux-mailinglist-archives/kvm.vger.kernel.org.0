Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D958E0E28
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbfJVW14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:27:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42516 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388172AbfJVW1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:27:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id f14so10800523pgi.9;
        Tue, 22 Oct 2019 15:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=J0Cde3YCRyKb7sVda9AuSr3SUq1DFyMrFHgfTQRevNg=;
        b=kf9SehCNiEcM+GfhpzKh3NyW4ANcI4Qdoy/zWsrS/DaZYbQEvhhtjhO5o55SoORHVz
         kSiuvyY8pV6mlTEHPalaOwwbRqM0mBd2Drmym4mBY7jVdS4C0PSddXT9sePiecgGvYUE
         JVI1qNOYbEO0iOiOQETNouy/sRKJ/czZqmabrurDDThDhkLiBuj1+3o5c3LwXcFTAtxo
         zjumP+IQlO/rDNVbhKHSlpcYKWBes7iePihLor2Nr6QdefABT76ujZbKFE7TfNyAe68e
         84blhV53Q9HSAUfH72G4PO/cAqAjqbDo7slsDOGzq4P0drmRP/c+0FSDlgWpLM7Nhf8u
         xi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=J0Cde3YCRyKb7sVda9AuSr3SUq1DFyMrFHgfTQRevNg=;
        b=EfdnMSy95i8jqNvlX5Ip+p0WnprYI9JORIzGwD9mWPyYYhrdJ/kKLiZBSHFtR+CRV6
         wjf/VPfOzhlVBWg+AaoNGfy5eBnkatBTr72DLAxI97Bk4wxSh0PXZOZPcENMm6fsG7u7
         33iNalFToYwIOEeMp8SSFzpdP0LnZxCBRnsHJIR66l2PfTKJN24jYcOcio3jIvWcr/Ox
         n71hfB/o11zyJo/nfvqApRIKz7gSv1IJrAUupP1+gsPsPX612eXPfh5C7JdtkoszodSx
         elzyC4nHrYwt+mKqH56WpuLy2y66IW2WPsutTS8Ce5UqQmobs0R5fJV+Q4MC/NNx1I6E
         sYUw==
X-Gm-Message-State: APjAAAVqaSdoB4jFZpHC1yB9nTBi+2c1g38sAweF3zhQ7GilWD/qahfE
        Qxgq84C+WrCoA7DaonAfNQU=
X-Google-Smtp-Source: APXvYqxUpZCIgjB/RhowJmJMcKSaevo7BJq4WvFJyIaGUi8Z6RPUU8dpXpcsYruoZJ6BMwX+j5xojA==
X-Received: by 2002:aa7:9715:: with SMTP id a21mr6913876pfg.144.1571783274147;
        Tue, 22 Oct 2019 15:27:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id y15sm29621200pfp.111.2019.10.22.15.27.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:27:53 -0700 (PDT)
Subject: [PATCH v12 0/6] mm / virtio: Provide support for unused page
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
Date:   Tue, 22 Oct 2019 15:27:52 -0700
Message-ID: <20191022221223.17338.5860.stgit@localhost.localdomain>
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
be dropped and reused by other processes and/or guests.

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
of the memory subsystem. The guest is running on one node of a E5-2630 v3
CPU with 48G of RAM that I split up into two logical nodes in the guest
in order to test with NUMA as well.

Test		    page_fault1 (THP)     page_fault2
Baseline	 1  1256106.33  +/-0.09%   482202.67  +/-0.46%
                16  8864441.67  +/-0.09%  3734692.00  +/-1.23%

Patches applied  1  1257096.00  +/-0.06%   477436.00  +/-0.16%
                16  8864677.33  +/-0.06%  3800037.00  +/-0.19%

Patches enabled	 1  1258420.00  +/-0.04%   480080.00  +/-0.07%
 MADV disabled  16  8753840.00  +/-1.27%  3782764.00  +/-0.37%

Patches enabled	 1  1267916.33  +/-0.08%   472075.67  +/-0.39%
                16  8287050.33  +/-0.67%  3774500.33  +/-0.11%

The results above are for a baseline with a linux-next-20191021 kernel,
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

There is currently an alternative patch set[1] that has been under work
for some time however the v12 version of that patch set could not be
tested as it triggered a kernel panic when I attempted to test it. It
requires multiple modifications to get up and running with performance
comparable to this patch set. A follow-on set has yet to be posted. As
such I have not included results from that patch set, and I would
appreciate it if we could keep this patch set the focus of any discussion
on this thread.

For info on earlier versions you will need to follow the links provided
with the respective versions.

[1]: https://lore.kernel.org/lkml/20190812131235.27244-1-nitesh@redhat.com/

Changes from v10:
https://lore.kernel.org/lkml/20190918175109.23474.67039.stgit@localhost.localdomain/
Rebased on "Add linux-next specific files for 20190930"
Added page_is_reported() macro to prevent unneeded testing of PageReported bit
Fixed several spots where comments referred to older aeration naming
Set upper limit for phdev->capacity to page reporting high water mark
Updated virtio page poison detection logic to also cover init_on_free
Tweaked page_reporting_notify_free to reduce code size
Removed dead code in non-reporting path

Changes from v11:
https://lore.kernel.org/lkml/20191001152441.27008.99285.stgit@localhost.localdomain/
Removed unnecessary whitespace change from patch 2
Minor tweak to get_unreported_page to avoid excess writes to boundary
Rewrote cover page to lay out additional performance info.

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
 mm/page_alloc.c                     |  194 +++++++++++++++----
 mm/page_reporting.c                 |  353 +++++++++++++++++++++++++++++++++++
 mm/page_reporting.h                 |  225 ++++++++++++++++++++++
 mm/shuffle.c                        |   12 +
 mm/shuffle.h                        |    6 +
 15 files changed, 899 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

--
