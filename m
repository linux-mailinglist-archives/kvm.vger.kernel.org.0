Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF1430429
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE3Vxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:53:38 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40580 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3Vxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:53:38 -0400
Received: by mail-oi1-f193.google.com with SMTP id r136so6178407oie.7;
        Thu, 30 May 2019 14:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=L4eRJoRAM9BshBnywrSkE8cQ8ajHKA/DqmlOsjnC6aU=;
        b=DrgK6T7pO2KGErcPsenn6+dgrK5pYhXn1+wL/FHloXypSYcxVhuuFIcgp3mZZdPpO7
         znr5fDthSEHXSBn0urZKNPauubicT85wwoRDbjY/XAvZjGgEnW83XCGc6KG4wGcUyoka
         eZjtLlLKozdey6w7A6Yqi3yO/XCFSfSm/GgmDHQ0UCDzCxLZmuLBnQ0n4ZLMcudRoT2s
         UTBBdTmwz5GhlW2PWNRhpo/aeKN/B+tN1xMSwAUrpsMPSdICbdawNhP1rTWjU4YW3AoQ
         ArhdHt1cN+GD4z0ZFxlnFnD/pTsYbCwEvJtp5kYdMQrSgLur3PRx3kmaw34F9amOAACA
         s+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=L4eRJoRAM9BshBnywrSkE8cQ8ajHKA/DqmlOsjnC6aU=;
        b=pqjVuicle5KMpP/RcSBe4JlSydMGZe9vyaJNXMDv45TVTSd6+ivSo8MTOawSiqL0OD
         nBBAGBPubysj+lw5dR23J3fYTpGusE4z0ZfzkFJQDdF4+lGn8bpbABYvUTMF4mbikuOt
         1WVq3GAoxqmDZIWfb6b89vqsLpEsRhgh87fbF1H1JWUkRXSPoshEb+VJ4NbBU4DxpxiT
         V/KSPJKa8HzBb8sVKDzbrXRyfZqQtnh1jzSdOWXHUQo6Q4dvjKkPpOF2723IJ3+Sr/hK
         B1AX4dgdHY9CMEUlkM+bFtFSwgVZAdUHgqgSOE33w3/2nirPZ2KVl5/tTAK8Eok7Ej/t
         Q4Lg==
X-Gm-Message-State: APjAAAWcDwcB6jlR/Zigg4neP5G85cTnUcUWo8K1yFiFAombo+r6IisN
        tuWH2M7JU5dxIyTWjIySQj0=
X-Google-Smtp-Source: APXvYqxFvLQbXtfmzGSX+Ab6mYng9B7q/SFrUu2Vi2ikCBcKwjb0GT4lghL89v6z5fdD+2Y9eB47Og==
X-Received: by 2002:aca:c057:: with SMTP id q84mr4092001oif.135.1559253216673;
        Thu, 30 May 2019 14:53:36 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id a31sm1557360otc.60.2019.05.30.14.53.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:53:36 -0700 (PDT)
Subject: [RFC PATCH 00/11] mm / virtio: Provide support for paravirtual
 waste page treatment
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:53:34 -0700
Message-ID: <20190530215223.13974.22445.stgit@localhost.localdomain>
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
for what I am referring to as "waste page treatment".

I have based many of the terms and functionality off of waste water
treatment, the idea for the similarity occured to me after I had reached
the point of referring to the hints as "bubbles", as the hints used the
same approach as the balloon functionality but would disappear if they
were touched, as a result I started to think of the virtio device as an
aerator. The general idea with all of this is that the guest should be
treating the unused pages so that when they end up heading "downstream"
to either another guest, or back at the host they will not need to be
written to swap.

So for a bit of background for the treatment process, it is based on a
sequencing batch reactor (SBR)[1]. The treatment process itself has five
stages. The first stage is the fill, with this we take the raw pages and
add them to the reactor. The second stage is react, in this stage we hand
the pages off to the Virtio Balloon driver to have hints attached to them
and for those hints to be sent to the hypervisor. The third stage is
settle, in this stage we are waiting for the hypervisor to process the
pages, and we should receive an interrupt when it is completed. The fourth
stage is to decant, or drain the reactor of pages. Finally we have the
idle stage which we will go into if the reference count for the reactor
gets down to 0 after a drain, or if a fill operation fails to obtain any
pages and the reference count has hit 0. Otherwise we return to the first
state and start the cycle over again.

This patch set is still far more intrusive then I would really like for
what it has to do. Currently I am splitting the nr_free_pages into two
values and having to add a pointer and an index to track where we area in
the treatment process for a given free_area. I'm also not sure I have
covered all possible corner cases where pages can get into the free_area
or move from one migratetype to another.

Also I am still leaving a number of things hard-coded such as limiting the
lowest order processed to PAGEBLOCK_ORDER, and have left it up to the
guest to determine what size of reactor it wants to allocate to process
the hints.

Another consideration I am still debating is if I really want to process
the aerator_cycle() function in interrupt context or if I should have it
running in a thread somewhere else.

[1]: https://en.wikipedia.org/wiki/Sequencing_batch_reactor

---

Alexander Duyck (11):
      mm: Move MAX_ORDER definition closer to pageblock_order
      mm: Adjust shuffle code to allow for future coalescing
      mm: Add support for Treated Buddy pages
      mm: Split nr_free into nr_free_raw and nr_free_treated
      mm: Propogate Treated bit when splitting
      mm: Add membrane to free area to use as divider between treated and raw pages
      mm: Add support for acquiring first free "raw" or "untreated" page in zone
      mm: Add support for creating memory aeration
      mm: Count isolated pages as "treated"
      virtio-balloon: Add support for aerating memory via bubble hinting
      mm: Add free page notification hook


 arch/x86/include/asm/page.h         |   11 +
 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |   89 ++++++++++
 include/linux/gfp.h                 |   10 +
 include/linux/memory_aeration.h     |   54 ++++++
 include/linux/mmzone.h              |  100 +++++++++--
 include/linux/page-flags.h          |   32 +++
 include/linux/pageblock-flags.h     |    8 +
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/aeration.c                       |  324 +++++++++++++++++++++++++++++++++++
 mm/compaction.c                     |    4 
 mm/page_alloc.c                     |  220 ++++++++++++++++++++----
 mm/shuffle.c                        |   24 ---
 mm/shuffle.h                        |   35 ++++
 mm/vmstat.c                         |    5 -
 17 files changed, 838 insertions(+), 86 deletions(-)
 create mode 100644 include/linux/memory_aeration.h
 create mode 100644 mm/aeration.c

--
