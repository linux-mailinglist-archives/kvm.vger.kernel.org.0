Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF53689F52
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 15:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfHLNNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 09:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfHLNNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 09:13:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00B46300C22C;
        Mon, 12 Aug 2019 13:13:10 +0000 (UTC)
Received: from virtlab605.virt.lab.eng.bos.redhat.com (virtlab605.virt.lab.eng.bos.redhat.com [10.19.152.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D85E5D6A0;
        Mon, 12 Aug 2019 13:13:05 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com, cohuck@redhat.com
Subject: [RFC][PATCH v12 0/2] mm: Support for page reporting
Date:   Mon, 12 Aug 2019 09:12:33 -0400
Message-Id: <20190812131235.27244-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 12 Aug 2019 13:13:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series proposes an efficient mechanism for reporting free memory
from a guest to its hypervisor. It especially enables guests with no page cache
(e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
rapidly hand back free memory to the hypervisor.
This approach has a minimal impact on the existing core-mm infrastructure.

This approach tracks all freed pages of the order MAX_ORDER - 2 in bitmaps.
A new hook after buddy merging is used to set the bits in the bitmap for a freed 
page. Each set bit is cleared after they are processed/checked for
re-allocation.
Bitmaps are stored on a per-zone basis and are protected by the zone lock. A
workqueue asynchronously processes the bitmaps as soon as a pre-defined memory
threshold is met, trying to isolate and report pages that are still free.
The isolated pages are stored in a scatterlist and are reported via
virtio-balloon, which is responsible for sending batched pages to the
hypervisor. Once the hypervisor processed the reporting request, the isolated
pages are returned back to the buddy.
The thershold which defines the number of pages which will be isolated and
reported to the hypervisor at a time is currently hardcoded to 16 in the guest.

Benefit analysis:
Number of 5 GB guests (each touching 4 to 5 GB memory) that can be launched on a
15 GB single NUMA system without using swap space in the host.

	    Guest kernel-->	Unmodified		with v12 page reporting
	Number of guests-->	    2				7

Conclusion: In a page-reporting enabled kernel, the guest is able to report
most of its unused memory back to the host. Due to this on the same host, I was
able to launch 7 guests without touching any swap compared to 2 which were
launched with an unmodified kernel.

Performance Analysis:
In order to measure the performance impact of this patch-series over an
unmodified kernel, I am using will-it-scale/page_fault1 on a 30 GB, 24 vcpus
single NUMA guest which is affined to a single node in the host. Over several
runs, I observed that with this patch-series there is a degradation of around
1-3% for certain cases. This degradation could be a result of page-zeroing
overhead which comes with every page-fault in the guest.
I also tried this test on a 2 NUMA node host running page reporting
enabled 60GB guest also having 2 NUMA nodes and 24 vcpus. I observed a similar
degradation of around 1-3% in most of the cases.
For certain cases, the variability even with an unmodified kernel was around
4-6% with every fresh boot. I will continue to investigate this further to find
the reason behind it.

Ongoing work-items:
* I have a working prototype for supporting memory hotplug/hotremove with page
  reporting. However, it still requires more testing and fixes specifically on
  the hotremove side.
  Right now, for any memory hotplug or hotremove request bitmap or its
  respective fields are not changed. Hence, memory added via hotplug is not
  tracked in the bitmap. Similarly, removed memory is not reported to the
  hypervisor by using an online memory check. 
* I will also have to look into the details about how to handle page poisoning
  scenarios and test with directly assigned devices.


Changes from v11:
https://lkml.org/lkml/2019/7/10/742
* Moved the fields required to manage bitmap of free pages to 'struct zone'.
* Replaced the list which was used to hold and report the free pages with
  scatterlist.
* Tried to fix the anti-kernel patterns and improve overall code quality.
* Fixed a few bugs in the code which were reported in the last posting.
* Moved to use MADV_DONTNEED from MADV_FREE.
* Replaced page hinting in favor of page reporting.
* Addressed other comments which I received in the last posting.	


Changes from v10:
https://lkml.org/lkml/2019/6/3/943
* Added logic to take care of multiple NUMA nodes scenarios.
* Simplified the logic for reporting isolated pages to the host. (Eg. replaced
  dynamically allocated arrays with static ones, introduced wait event instead
  of the loop in order to wait for a response from the host)
* Added a mutex to prevent race condition when page reporting is enabled by
  multiple drivers.
* Simplified the logic responsible for decrementing free page counter for each
  zone.
* Simplified code structuring/naming.
 
--

Nitesh Narayan Lal (2):
  mm: page_reporting: core infrastructure
  virtio-balloon: interface to support free page reporting

 drivers/virtio/Kconfig              |   1 +
 drivers/virtio/virtio_balloon.c     |  64 +++++-
 include/linux/mmzone.h              |  11 +
 include/linux/page_reporting.h      |  63 ++++++
 include/uapi/linux/virtio_balloon.h |   1 +
 mm/Kconfig                          |   6 +
 mm/Makefile                         |   1 +
 mm/page_alloc.c                     |  42 +++-
 mm/page_reporting.c                 | 332 ++++++++++++++++++++++++++++
 9 files changed, 513 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

-- 


