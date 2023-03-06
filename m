Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8913C6AD1C6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCFWlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCFWlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:41:40 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB88274A76
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:34 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id s8-20020a170902b18800b0019c92f56a8aso6710388plr.22
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142494;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bFNJWG6qjm2MPxLP7ev67uNQscemoGBQSlcIHBm/wyc=;
        b=C7ey9k8kuVCYIYxg7pb/31RB4zdzj0lDq+3l5WlFPkoz5lEb4hLTDreF0q/eEjxDM8
         bBip4kKF/B/Fzc+u4bI9iSMbiEbYNzCMn64/UPrjVW7/6EO5wcixYlAA+waXBdkR17lB
         EIZPnmJeuxODV5D50rWDNHTVpcp8LCE8875YkAU5IZTO+uHE02KGiKtqNy64GPQdMTXI
         YmM1E60e9EjAzPfrEs0O1dUCkHSCQWcYn++QXl/HAHXSUsOhoVu0h0NCAq/LdgI/sk/L
         ZrJn9jbv6c8bEspACsek8WeEVXfEJRc98+PQCxJyfclbW1ekDOaMbC9V6ed9Oqru+YAt
         40kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142494;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bFNJWG6qjm2MPxLP7ev67uNQscemoGBQSlcIHBm/wyc=;
        b=7IfwcyDn5iAFDXySxUYz93QIcUoFkGAba8TrksjUowH3x9asDfFeGxgFE9GmpGqt95
         svb3AYCao3hOfRxKmXxx4G77DTD7qUiSK1mrMS10vtlc+zcb6zYP3cUZHXWP3Jdx46xJ
         TsHs/XWBLycrb113oPZ3vWED2x9TL6xu8h7tBFw0cMkePNeOpUk3FwFj/XTGDjpaMn3E
         usiH5Bm/e9Kz7WQ4H9oQUqHRcFM1SwmDgs7u/pv+P/j8rQlbsEQvvD88EJM4l00N4HiV
         ME4BsuOoJWOiJzFSF5rzvXvBa/FgqCPE8nPCKBhSoUL77073O3LaktqXilp+r1qkxWBr
         RH1Q==
X-Gm-Message-State: AO0yUKWr7m3AQK/lly6j9C8Ya3sou6djqUEvyzdOuk2Akbgg++X8Lcgo
        t5QcsQc035vov/Ya43L/DZUQMcX1q8mj
X-Google-Smtp-Source: AK7set9qQPyLdRr5f3blHETLHZwfdyYDQ93LBqDMsRXqKj6MExxdOFo3X9A70W3eA+mCA3SlWfjx7pJFgaly
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a62:8307:0:b0:5a8:4dc1:5916 with SMTP id
 h7-20020a628307000000b005a84dc15916mr5433004pfe.2.1678142494296; Mon, 06 Mar
 2023 14:41:34 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:09 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-1-vipinsh@google.com>
Subject: [Patch v4 00/18] NUMA aware page table allocation
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series build up based on the feedback on v3.

Biggest change in features is to enable NUMA aware page table per VM
basis instead of using a module parameter for all VMs on a host. This
was decided based on an internal discussion to avoid forcing all VMs to
be NUMA aware on a host. We need to collect more data to see how much
performance degradation a VM can get in negative testing, where vCPUs in
VM are always accessing remote NUMA nodes memory instead of staying
local compared to a VM which is not NUMA aware.

There are other changes which are mentioned in the change log below for
v4.

Thanks
Vipin

v4:
- Removed module parameter for enabling NUMA aware page table.
- Added new capability KVM_CAP_NUMA_AWARE_PAGE_TABLE to enable this
  feature per VM.
- Added documentation for the new capability.
- Holding mutex just before the top up and releasing it after the
  fault/split is addressed. Previous version were using spinlocks two
  times, first time for topup and second time fetching the page from
  cache.
- Using the existing slots_lock for split_shadow_page_cache operations.
- KVM MMU shrinker will also shrink mm_shadow_info_cache besides
  split_shadow_page_cache and mmu_shadow_page_cache.
- Reduced cache default size to 4.
- Split patches into smaller ones.

v3: https://lore.kernel.org/lkml/20221222023457.1764-1-vipinsh@google.com/
- Split patches into smaller ones.
- Repurposed KVM MMU shrinker to free cache pages instead of oldest page table
  pages
- Reduced cache size from 40 to 5
- Removed __weak function and initializing node value in all architectures.
- Some name changes.

v2: https://lore.kernel.org/lkml/20221201195718.1409782-1-vipinsh@google.com/
- All page table pages will be allocated on underlying physical page's
  NUMA node.
- Introduced module parameter, numa_aware_pagetable, to disable this
  feature.
- Using kvm_pfn_to_refcounted_page to get page from a pfn.

v1: https://lore.kernel.org/all/20220801151928.270380-1-vipinsh@google.com/

Vipin Sharma (18):
  KVM: x86/mmu: Change KVM mmu shrinker to no-op
  KVM: x86/mmu: Remove zapped_obsolete_pages from struct kvm_arch{}
  KVM: x86/mmu: Track count of pages in KVM MMU page caches globally
  KVM: x86/mmu: Shrink shadow page caches via MMU shrinker
  KVM: x86/mmu: Add split_shadow_page_cache pages to global count of MMU
    cache pages
  KVM: x86/mmu: Shrink split_shadow_page_cache via MMU shrinker
  KVM: x86/mmu: Unconditionally count allocations from MMU page caches
  KVM: x86/mmu: Track unused mmu_shadowed_info_cache pages count via
    global counter
  KVM: x86/mmu: Shrink mmu_shadowed_info_cache via MMU shrinker
  KVM: x86/mmu: Add per VM NUMA aware page table capability
  KVM: x86/mmu: Add documentation of NUMA aware page table capability
  KVM: x86/mmu: Allocate NUMA aware page tables on TDP huge page splits
  KVM: mmu: Add common initialization logic for struct
    kvm_mmu_memory_cache{}
  KVM: mmu: Initialize kvm_mmu_memory_cache.gfp_zero to __GFP_ZERO by
    default
  KVM: mmu: Add NUMA node support in struct kvm_mmu_memory_cache{}
  KVM: x86/mmu: Allocate numa aware page tables during page fault
  KVM: x86/mmu: Allocate shadow mmu page table on huge page split on the
    same NUMA node
  KVM: x86/mmu: Reduce default mmu memory cache size

 Documentation/virt/kvm/api.rst   |  29 +++
 arch/arm64/kvm/arm.c             |   2 +-
 arch/arm64/kvm/mmu.c             |   2 +-
 arch/mips/kvm/mips.c             |   3 +
 arch/riscv/kvm/mmu.c             |   8 +-
 arch/riscv/kvm/vcpu.c            |   2 +-
 arch/x86/include/asm/kvm_host.h  |  17 +-
 arch/x86/include/asm/kvm_types.h |   6 +-
 arch/x86/kvm/mmu/mmu.c           | 319 +++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h  |  38 ++++
 arch/x86/kvm/mmu/paging_tmpl.h   |  29 +--
 arch/x86/kvm/mmu/tdp_mmu.c       |  23 ++-
 arch/x86/kvm/x86.c               |  18 +-
 include/linux/kvm_host.h         |   2 +
 include/linux/kvm_types.h        |  21 ++
 include/uapi/linux/kvm.h         |   1 +
 virt/kvm/kvm_main.c              |  24 ++-
 17 files changed, 386 insertions(+), 158 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

