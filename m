Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6251344CCB9
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhKJWdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbhKJWdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:03 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EEBC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:15 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso1804157pjf.9
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ySCPE8NAX1lRNmXxmGQ5E/m3CVpAu99HXBKNvXv9kkM=;
        b=LTg73mxCDpv/bUa367hpKKQTs8+f020jMdII0VJpFbsREwildaLz4hxe6678FTiu7h
         md41/Lb9SO1bRb4M0WDT8Eda86oOjpWByBQr53u52ukVh582EmpvBlaT5toa4QaOy2x4
         OTuxdblS/TiiXBwYTkpGQGbZ8oMqUI+12GM3jqVU3Mg7oYYRClUHzWjOqjfSpvBLaVq5
         Tv0g9mUDLIf4kvP7KsmitBk8DEWVimHAEGYKfbKya1ExDOOCiXO9O1N0E5aIaNhBaL4M
         V3nFIPcv2/N4a4+FYrRPAIWLCFyfl1Gjnv3KSVQDKqSRIV6yA35cBhROaTH5fAn4bH53
         V3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ySCPE8NAX1lRNmXxmGQ5E/m3CVpAu99HXBKNvXv9kkM=;
        b=1ZpsbIvOpq0+KkcC374NkO4wKPbZWLOoqSQvkTlREvfuODbO5j614c7Zc3cewn1uGI
         yugyVxS0V7wXpyr5eHx0MMXmryRrnkmUWsA1PsS1NnzjaB5DwPmpL9knlSx8FBylcuP2
         eaB+M036XlBCwxnQGoCnmgS1ll4xVsoVjZGdUkIqRjrz0tzH26YxrqH4BLg4//RZ3jYe
         A57ZVcluMpF35ZrgX+6Sulg3+tsv+4DJDMhF9Fxtjvwgelm075UDi/ydfPTR/ycBf8mf
         /RkfaKQIJOJdKbWQgp9HN5tf5LTNMNBqfOjJEQiUEqiq4UmD+O0yo2eZDtbyNsqnf78i
         Zv+g==
X-Gm-Message-State: AOAM5306e/PaJjE6fsYZE6Iai6eknddTp/HhA3s0DNSOi1brxJKaOY05
        tb7rIRwkC9tp0fwZijpaneu2B0QKQQX6
X-Google-Smtp-Source: ABdhPJzZ+0cyrVw2fijQ8nnmwqZWeRr/iTDWlvwZ+Oau0OvBfck4jGr2gNprTC4fvjJSYNCrO74pcvpKhUNo
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a63:5642:: with SMTP id
 g2mr1548108pgm.152.1636583415047; Wed, 10 Nov 2021 14:30:15 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:51 -0800
Message-Id: <20211110223010.1392399-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 00/19] KVM: x86/mmu: Optimize disabling dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently disabling dirty logging with the TDP MMU is extremely slow.
On a 96 vCPU / 96G VM it takes ~45 seconds to disable dirty logging
with the TDP MMU, as opposed to ~3.5 seconds with the legacy MMU. This
series optimizes TLB flushes and introduces in-place large page
promotion, to bring the disable dirty log time down to ~2 seconds.

Testing:
Ran KVM selftests and kvm-unit-tests on an Intel Skylake. This
series introduced no new failures.

Performance:
To collect these results I needed to apply Mingwei's patch
"selftests: KVM: align guest physical memory base address to 1GB"
https://lkml.org/lkml/2021/8/29/310
David Matlack is going to send out an updated version of that patch soon.

Without this series, TDP MMU:
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 10.966500447s
Enabling dirty logging time: 0.002068737s

Iteration 1 dirty memory time: 0.047556280s
Iteration 1 get dirty log time: 0.001253914s
Iteration 1 clear dirty log time: 0.049716661s
Iteration 2 dirty memory time: 3.679662016s
Iteration 2 get dirty log time: 0.000659546s
Iteration 2 clear dirty log time: 1.834329322s
Disabling dirty logging time: 45.738439510s
Get dirty log over 2 iterations took 0.001913460s. (Avg 0.000956730s/iteration)
Clear dirty log over 2 iterations took 1.884045983s. (Avg 0.942022991s/iteration)

Without this series, Legacy MMU:
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 12.664750666s
Enabling dirty logging time: 0.002025510s

Iteration 1 dirty memory time: 0.046240875s
Iteration 1 get dirty log time: 0.001864342s
Iteration 1 clear dirty log time: 0.170243637s
Iteration 2 dirty memory time: 31.571088701s
Iteration 2 get dirty log time: 0.000626245s
Iteration 2 clear dirty log time: 1.294817729s
Disabling dirty logging time: 3.566831573s
Get dirty log over 2 iterations took 0.002490587s. (Avg 0.001245293s/iteration)
Clear dirty log over 2 iterations took 1.465061366s. (Avg 0.732530683s/iteration)

With this series, TDP MMU:
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 12.016653537s
Enabling dirty logging time: 0.001992860s

Iteration 1 dirty memory time: 0.046701599s
Iteration 1 get dirty log time: 0.001214806s
Iteration 1 clear dirty log time: 0.049519923s
Iteration 2 dirty memory time: 3.581931268s
Iteration 2 get dirty log time: 0.000621383s
Iteration 2 clear dirty log time: 1.894597059s
Disabling dirty logging time: 1.950542092s
Get dirty log over 2 iterations took 0.001836189s. (Avg 0.000918094s/iteration)
Clear dirty log over 2 iterations took 1.944116982s. (Avg 0.972058491s/iteration)

Patch breakdown:
Patch 1 is a fix for a bug in the way the TBP MMU issues TLB flushes
Patches 2-5 eliminate many unnecessary TLB flushes through better batching
Patches 6-12 remove the need for a vCPU pointer to make_spte
Patches 13-18 are small refactors in perparation for patch 19
Patch 19 implements in-place largepage promotion when disabling dirty logging

Ben Gardon (19):
  KVM: x86/mmu: Fix TLB flush range when handling disconnected pt
  KVM: x86/mmu: Batch TLB flushes for a single zap
  KVM: x86/mmu: Factor flush and free up when zapping under MMU write
    lock
  KVM: x86/mmu: Yield while processing disconnected_sps
  KVM: x86/mmu: Remove redundant flushes when disabling dirty logging
  KVM: x86/mmu: Introduce vcpu_make_spte
  KVM: x86/mmu: Factor wrprot for nested PML out of make_spte
  KVM: x86/mmu: Factor mt_mask out of make_spte
  KVM: x86/mmu: Remove need for a vcpu from
    kvm_slot_page_track_is_active
  KVM: x86/mmu: Remove need for a vcpu from mmu_try_to_unsync_pages
  KVM: x86/mmu: Factor shadow_zero_check out of make_spte
  KVM: x86/mmu: Replace vcpu argument with kvm pointer in make_spte
  KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
  KVM: x86/mmu: Propagate memslot const qualifier
  KVM: x86/MMU: Refactor vmx_get_mt_mask
  KVM: x86/mmu: Factor out part of vmx_get_mt_mask which does not depend
    on vcpu
  KVM: x86/mmu: Add try_get_mt_mask to x86_ops
  KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
  KVM: x86/mmu: Promote pages in-place when disabling dirty logging

 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/include/asm/kvm_page_track.h |   6 +-
 arch/x86/kvm/mmu/mmu.c                |  45 +++---
 arch/x86/kvm/mmu/mmu_internal.h       |   6 +-
 arch/x86/kvm/mmu/page_track.c         |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h        |   6 +-
 arch/x86/kvm/mmu/spte.c               |  43 +++--
 arch/x86/kvm/mmu/spte.h               |  17 +-
 arch/x86/kvm/mmu/tdp_mmu.c            | 217 +++++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h            |   5 +-
 arch/x86/kvm/svm/svm.c                |   8 +
 arch/x86/kvm/vmx/vmx.c                |  40 +++--
 include/linux/kvm_host.h              |  10 +-
 virt/kvm/kvm_main.c                   |  12 +-
 15 files changed, 302 insertions(+), 124 deletions(-)

-- 
2.34.0.rc0.344.g81b53c2807-goog

