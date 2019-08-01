Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628AF7E5A3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 00:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbfHAW1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 18:27:04 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37077 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfHAW1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 18:27:03 -0400
Received: by mail-oi1-f195.google.com with SMTP id t76so55311932oih.4;
        Thu, 01 Aug 2019 15:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=jjVaiL9PlJtpvUqKX80XgUrDQiaG4FJpJKI6tyDVArI=;
        b=ZrRacyXdKI8lnbczd4//nr2xpTwQ3BkyvQbkNShzIE1E0SDVfeul5NXlmgkWqQfJTG
         omf/6sfYJ95+PhEEsADPMGwTXt2GOvqIDxePdxXajthC8lzqpON1/ZHPp7/YI3F2HvtX
         L/4pSxQvxeC40ffelKuabrC9d5+9G3Zca2k1WVIsj+pIK/8DrACq9tky0Ssc5t//qtZY
         y27zx5mVNxtBnCOy3OpXcZ30VWvM8T6XyBiMJm853KEJlphOE6SDcZRM1STFMg1kQnUp
         ej0iCu1ArOTU7GjQicbQAfy9u5GCQphYefiPdQ4vu406H8OIWTGJlpZTYn6TagPI927N
         sXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=jjVaiL9PlJtpvUqKX80XgUrDQiaG4FJpJKI6tyDVArI=;
        b=aE849JX6mgc8fu0QkkKQbO3p6zaXhHqvr0vr24Ffm+Ej3D2/mqHheUsrxrAijbvaeO
         F/7ETAIzAfMY0qjWr2gtNbSf6YpFSRAZIZrkWFZW5vyZHizb13UBYbFuon2tySqU7W+Z
         TEJyYESHR0cpM82jGAVs2Q8X4ayPJ9ItemlFHxrPaToOnvkrvwaVT8vZeu/6CtMdfa2w
         +3ZhFdHDmRUR1wv/gNugIuR10l2MNVO2vK8kvokAwNPUgxXcRtlLyLPOK20XYN14Z0IE
         wRtsL8K478h9ZoIztHlGJCcGlta7HJXqRtSmIUKiaEwnCck2f3tuptBBQa5E4AN3hAmP
         tNmw==
X-Gm-Message-State: APjAAAV82Ep3qDxL32ZzYyYdXIgtBzO3NKYprhPqWNUIoi8UInKRsv8N
        6fEEiF0XrNQrzL0yU8U4UkE=
X-Google-Smtp-Source: APXvYqwz7cn/2YMdeMQ0x9s9lVejvU6i/X+Wfx1SCCjJ0F2gKCgp6QocGTmCTwFXuNThq4TZh5DfzQ==
X-Received: by 2002:aca:bf54:: with SMTP id p81mr718285oif.1.1564698422089;
        Thu, 01 Aug 2019 15:27:02 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id i19sm24559702oib.12.2019.08.01.15.27.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 15:27:01 -0700 (PDT)
Subject: [PATCH v3 0/6] mm / virtio: Provide support for unused page
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
Date:   Thu, 01 Aug 2019 15:24:49 -0700
Message-ID: <20190801222158.22190.96964.stgit@localhost.localdomain>
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
queue used to store the scatterlist.

My primary testing has just been to verify the memory is being freed after
allocation by running memhog 40g on a 40g guest and watching the total
free memory via /proc/meminfo on the host. With this I have verified most
of the memory is freed after each iteration. As far as performance I have
been mainly focusing on the will-it-scale/page_fault1 test running with
16 vcpus. With that I have seen up to a 2% difference between the base
kernel without these patches and the patches with virtio-balloon enabled
or disabled.

One side effect of these patches is that the guest becomes much more
resilient in terms of NUMA locality. With the pages being freed and then
reallocated when used it allows for the pages to be much closer to the
active thread, and as a result there can be situations where this patch
set will out-perform the stock kernel when the guest memory is not local
to the guest vCPUs.

Patch 4 is a bit on the large side at about 600 lines of change, however
I really didn't see a good way to break it up since each piece feeds into
the next. So I couldn't add the statistics by themselves as it didn't
really make sense to add them without something that will either read or
increment/decrement them, or add the Hinted state without something that
would set/unset it. As such I just ended up adding the entire thing as
one patch. It makes it a bit bigger but avoids the issues in the previous
set where I was referencing things that had not yet been added.

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

---

Alexander Duyck (6):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Move set/get_pcppage_migratetype to mmzone.h
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce Reported pages
      virtio-balloon: Pull page poisoning config out of free page hinting
      virtio-balloon: Add support for providing unused page reports to host


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   75 ++++++++-
 include/linux/mmzone.h              |  116 ++++++++------
 include/linux/page-flags.h          |   11 +
 include/linux/page_reporting.h      |  138 ++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/internal.h                       |   18 ++
 mm/memory_hotplug.c                 |    1 
 mm/page_alloc.c                     |  238 ++++++++++++++++++++--------
 mm/page_reporting.c                 |  299 +++++++++++++++++++++++++++++++++++
 mm/shuffle.c                        |   24 ---
 mm/shuffle.h                        |   32 ++++
 14 files changed, 821 insertions(+), 139 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

--
