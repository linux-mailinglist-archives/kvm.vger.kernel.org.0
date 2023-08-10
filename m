Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8DF77745C
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjHJJXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjHJJXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:23:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBC31704;
        Thu, 10 Aug 2023 02:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659414; x=1723195414;
  h=from:to:cc:subject:date:message-id;
  bh=gfW6MuZeHTt533K3UHwW/pOHp5AwnMiWdNZRUvGivNY=;
  b=AEiVB1CcAEAQbPqTR9gK9lAKt1PADBhjGFeSJBxEIYcoHPB/gmRSVViZ
   wDJvQULKrYL/tDOqoKX+bsBg1zJhNSotWpJuHzTVg4aq0KBpRiMFdgpa0
   O5SaKd+4O16Yom+8cGHdBzEA4lDVIFXXcbzZfNF9KxEfkbJ3GcGDO0k3x
   MiEzvKkl2qYuZZpjcYQV/blCrkRX3lUvZjjn0bISa8V9gt6Ev3wFo4ZeX
   CFQbHORkNxNzuHe2kA2UqKosKYVJ2+6iPuvjJ1mkNbd47nzLgE+xztBZE
   sVv1YufoFPciAWr+4jsjqOxfl6n5EUttJ0jr6Jg//xBleFnvcfZ+DQJzI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="435245958"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="435245958"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="802128926"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="802128926"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:23:30 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a VM
Date:   Thu, 10 Aug 2023 16:56:36 +0800
Message-Id: <20230810085636.25914-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an RFC series trying to fix the issue of unnecessary NUMA
protection and TLB-shootdowns found in VMs with assigned devices or VFIO
mediated devices during NUMA balance.

For VMs with assigned devices or VFIO mediated devices, all or part of
guest memory are pinned for long-term.

Auto NUMA balancing will periodically selects VMAs of a process and change
protections to PROT_NONE even though some or all pages in the selected
ranges are long-term pinned for DMAs, which is true for VMs with assigned
devices or VFIO mediated devices.

Though this will not cause real problem because NUMA migration will
ultimately reject migration of those kind of pages and restore those
PROT_NONE PTEs, it causes KVM's secondary MMU to be zapped periodically
with equal SPTEs finally faulted back, wasting CPU cycles and generating
unnecessary TLB-shootdowns.

This series first introduces a new flag MMU_NOTIFIER_RANGE_NUMA in patch 1
to work with mmu notifier event type MMU_NOTIFY_PROTECTION_VMA, so that
the subscriber (e.g.KVM) of the mmu notifier can know that an invalidation
event is sent for NUMA migration purpose in specific.

Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
MMU to avoid NUMA protection introduced page faults and restoration of old
huge PMDs/PTEs in primary MMU.

Patch 3 introduces a new mmu notifier callback .numa_protect(), which
will be called in patch 4 when a page is ensured to be PROT_NONE protected.

Then in patch 5, KVM can recognize a .invalidate_range_start() notification
is for NUMA balancing specific and do not do the page unmap in secondary
MMU until .numa_protect() comes.


Changelog:
RFC v1 --> v2:
1. added patch 3-4 to introduce a new callback .numa_protect()
2. Rather than have KVM duplicate logic to check if a page is pinned for
long-term, let KVM depend on the new callback .numa_protect() to do the
page unmap in secondary MMU for NUMA migration purpose.

RFC v1:
https://lore.kernel.org/all/20230808071329.19995-1-yan.y.zhao@intel.com/ 

Yan Zhao (5):
  mm/mmu_notifier: introduce a new mmu notifier flag
    MMU_NOTIFIER_RANGE_NUMA
  mm: don't set PROT_NONE to maybe-dma-pinned pages for NUMA-migrate
    purpose
  mm/mmu_notifier: introduce a new callback .numa_protect
  mm/autonuma: call .numa_protect() when page is protected for NUMA
    migrate
  KVM: Unmap pages only when it's indeed protected for NUMA migration

 include/linux/mmu_notifier.h | 16 ++++++++++++++++
 mm/huge_memory.c             |  6 ++++++
 mm/mmu_notifier.c            | 18 ++++++++++++++++++
 mm/mprotect.c                | 10 +++++++++-
 virt/kvm/kvm_main.c          | 25 ++++++++++++++++++++++---
 5 files changed, 71 insertions(+), 4 deletions(-)

-- 
2.17.1

