Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BDF773FFE
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjHHQ6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjHHQ53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:57:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491361FFB;
        Tue,  8 Aug 2023 08:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509361; x=1723045361;
  h=from:to:cc:subject:date:message-id;
  bh=Vk5oRN79w/cLbLNx3NSjT6+SGZdwpnI5SrG+5/rFROM=;
  b=WMRta5pXM2WzqBbEDFnIePz90d6/yUTY0Nc79rR+LbpjwpBfAoUJLU//
   rCXoJ1YhtJ6uvXBzjmvOWexf1Hgk/yAThrosO9TJfGnSVKXpfF5latMz5
   gSy+9vDOf9NChui6e1rDYju4ITdV+/tifIWNgKUly7V2YnUam8i+blXmJ
   BSnQj95H9F0mQh3uGKj+paJunZLmKmYipGjucW6H185zlN4von9OdAecw
   Xo9dvO1aWcRiAvUOdxvleSO7OgFpa5RVAH8EDa0pJg3injbaC6qBjPIDK
   2DOY9eMR6xiEnfvnmJhyb3Sk20GBZErfG/2ULee3QYl2Sn4oQbDd/GXeC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457130721"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="457130721"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="731281811"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="731281811"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:40:22 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 0/3] Reduce NUMA balance caused TLB-shootdowns in a VM
Date:   Tue,  8 Aug 2023 15:13:29 +0800
Message-Id: <20230808071329.19995-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

Then, with patch 3, during zapping KVM's secondary MMU, KVM can check
and keep accessing the long-term pinned pages even though it's
PROT_NONE-mapped in the primary MMU.

Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
MMU to avoid NUMA protection introduced page faults and restoration of old
huge PMDs/PTEs in primary MMU. As change_pmd_range() will first send
.invalidate_range_start() before going down and checking the pages to skip,
patch 1 and 3 are still required for KVM.

In my test environment, with this series, during boot-up with a VM with
assigned devices:
TLB shootdown count in KVM caused by .invalidate_range_start() sent for
NUMA balancing in change_pmd_range() is reduced from 9000+ on average to 0.

Yan Zhao (3):
  mm/mmu_notifier: introduce a new mmu notifier flag
    MMU_NOTIFIER_RANGE_NUMA
  mm: don't set PROT_NONE to maybe-dma-pinned pages for NUMA-migrate
    purpose
  KVM: x86/mmu: skip zap maybe-dma-pinned pages for NUMA migration

 arch/x86/kvm/mmu/mmu.c       |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c   | 26 ++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h   |  4 ++--
 include/linux/kvm_host.h     |  1 +
 include/linux/mmu_notifier.h |  1 +
 mm/huge_memory.c             |  5 +++++
 mm/mprotect.c                |  9 ++++++++-
 virt/kvm/kvm_main.c          |  5 +++++
 8 files changed, 46 insertions(+), 9 deletions(-)

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.17.1

