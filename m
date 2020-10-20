Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548C528E63F
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgJNS1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgJNS1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5EBC061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y6so328719pjb.8
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=3OwPD9JNIkkg/66kUX7JOx+qvCAxBgpPWoZ4pxvez7k=;
        b=lItDRVd5cQ5IIEtTz6X1ie5+pL9ESgJLgeZyxVtNXHGYlK7jQeI+WmWLEJiItBVt9N
         mOQC3YlpDvNZHCAheoHcba6Kj7h8mRdkiUiJ5rNgUZyc41UW5Utx9JrRWD5nyrKNEJec
         FDXTijiSEuxPs1dpq2ousd0PkiGkEv0bHpdFtGA8djfZf+P33qiCVg+opBpIWsZuFCe3
         pudFBc1uJgz0sMppEWU/MxRLBbGS85adq9t7IhvNqRfmF2GRO1yLMHvdo7O3TO9T11HI
         Hr6NeNuBQAkEQPoJjqEB0E6XOWviYqGEJ3+qF+aWs7QQzDUGy/eM5luXM/yvekuAZds7
         NSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=3OwPD9JNIkkg/66kUX7JOx+qvCAxBgpPWoZ4pxvez7k=;
        b=YtYQgdsUvjts8NEjyW5eHWgeK751IPgyV9kus2fyUQPk2z9WFjroUAojAw+yhIUXdr
         RkZ/z6WfgDa5FvvvIqStsv7zJJ5OyjIxxHLYHBqu7xvS61XlC+rXj3w1rDXpfG/1e1qE
         BbaQnWYSOabLU7QuEuItGuVaChXGQ0TgkIptQKoiFWdftXh+YBSizquxTvMuLSAVVQ9O
         YKz8JmtrNxlWmtdhKoa7iRsARQ7Gn8BIhDQcYyffVVkoBXSyedts1YdAZlDPyDABxqq1
         lG6a/b+gQhj1iVtS4XGCjwrrL983V3Qw42iGx6KavPbcJ0SzNoQiBKHn758sVN22icGD
         nsCQ==
X-Gm-Message-State: AOAM533gGCMNVwveT/o5s8lA3LD5jfbieJCjc9EZeD75/zbm2mn56OXJ
        fp5w3z1qdO1ydSc3TQkFODlOAR5MSYF/
X-Google-Smtp-Source: ABdhPJzmbjkLfxHv5DXV8PVqejr9VdMMeI+pdHIWv34F78h8VYGL0lGuDne+ScNCejcY+JQlskkT9jQRTEM2
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:aa7:8421:0:b029:155:3229:69cc with SMTP id
 q1-20020aa784210000b0290155322969ccmr567588pfn.36.1602700024177; Wed, 14 Oct
 2020 11:27:04 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:40 -0700
Message-Id: <20201014182700.2888246-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 00/20] Introduce the TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the years, the needs for KVM's x86 MMU have grown from running small
guests to live migrating multi-terabyte VMs with hundreds of vCPUs. Where
we previously depended on shadow paging to run all guests, we now have
two dimensional paging (TDP). This patch set introduces a new
implementation of much of the KVM MMU, optimized for running guests with
TDP. We have re-implemented many of the MMU functions to take advantage of
the relative simplicity of TDP and eliminate the need for an rmap.
Building on this simplified implementation, a future patch set will change
the synchronization model for this "TDP MMU" to enable more parallelism
than the monolithic MMU lock. A TDP MMU is currently in use at Google
and has given us the performance necessary to live migrate our 416 vCPU,
12TiB m2-ultramem-416 VMs.

This work was motivated by the need to handle page faults in parallel for
very large VMs. When VMs have hundreds of vCPUs and terabytes of memory,
KVM's MMU lock suffers extreme contention, resulting in soft-lockups and
long latency on guest page faults. This contention can be easily seen
running the KVM selftests demand_paging_test with a couple hundred vCPUs.
Over a 1 second profile of the demand_paging_test, with 416 vCPUs and 4G
per vCPU, 98% of the time was spent waiting for the MMU lock. At Google,
the TDP MMU reduced the test duration by 89% and the execution was
dominated by get_user_pages and the user fault FD ioctl instead of the
MMU lock.

This series is the first of two. In this series we add a basic
implementation of the TDP MMU. In the next series we will improve the
performance of the TDP MMU and allow it to execute MMU operations
in parallel.

The overall purpose of the KVM MMU is to program paging structures
(CR3/EPT/NPT) to encode the mapping of guest addresses to host physical
addresses (HPA), and to provide utilities for other KVM features, for
example dirty logging. The definition of the L1 guest physical address
(GPA) to HPA mapping comes in two parts: KVM's memslots map GPA to HVA,
and the kernel MM/x86 host page tables map HVA -> HPA. Without TDP, the
MMU must program the x86 page tables to encode the full translation of
guest virtual addresses (GVA) to HPA. This requires "shadowing" the
guest's page tables to create a composite x86 paging structure. This
solution is complicated, requires separate paging structures for each
guest CR3, and requires emulating guest page table changes. The TDP case
is much simpler. In this case, KVM lets the guest control CR3 and programs
the EPT/NPT paging structures with the GPA -> HPA mapping. The guest has
no way to change this mapping and only one version of the paging structure
is needed per L1 paging mode. In this case the paging mode is some
combination of the number of levels in the paging structure, the address
space (normal execution or system management mode, on x86), and other
attributes. Most VMs only ever use 1 paging mode and so only ever need one
TDP structure.

This series implements a "TDP MMU" through alternative implementations of
MMU functions for running L1 guests with TDP. The TDP MMU falls back to
the existing shadow paging implementation when TDP is not available, and
interoperates with the existing shadow paging implementation for nesting.
The use of the TDP MMU can be controlled by a module parameter which is
snapshot on VM creation and follows the life of the VM. This snapshot
is used in many functions to decide whether or not to use TDP MMU handlers
for a given operation.

This series can also be viewed in Gerrit here:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
(Thanks to Dmitry Vyukov <dvyukov@google.com> for setting up the
Gerrit instance)

Changes v1 -> v2:
  Big thanks to Paolo and Sean for your thorough reviews!
  - Moved some function definitions to mmu_internal.h instead of just
    declaring them there.
  - Dropped the commit to add an as_id field to memslots in favor of
    Peter Xu's which is part of the dirty ring patch set. I've included a
    copy of that patch from v13 of the patch set in this series.
  - Fixed comment style on SPDX license headers
  - Added a min_level to the tdp_iter and removed the tdp_iter_no_step_down
    function
  - Removed the tdp_mmu module parameter and defaulted the global to false
  - Unified more NX reclaim code
  - Added helper functions for setting SPTEs in the TDP MMU
  - Renamed tdp_iter macros to for clarity
  - Renamed kvm_tdp_mmu_page_fault to kvm_tdp_mmu_map and gave it the same
    signature as __direct_map
  - Converted some WARN_ONs to BUG_ONs or removed them
  - Changed dlog to dirty_log to match convention
  - Switched make_spte to return a return code and use a return parameter
    for the new SPTE
  - Refactored TDP MMU root allocation
  - Other misc cleanups and bug fixes

Ben Gardon (19):
  kvm: x86/mmu: Separate making SPTEs from set_spte
  kvm: x86/mmu: Introduce tdp_iter
  kvm: x86/mmu: Init / Uninit the TDP MMU
  kvm: x86/mmu: Allocate and free TDP MMU roots
  kvm: x86/mmu: Add functions to handle changed TDP SPTEs
  kvm: x86/mmu: Support zapping SPTEs in the TDP MMU
  kvm: x86/mmu: Separate making non-leaf sptes from link_shadow_page
  kvm: x86/mmu: Remove disallowed_hugepage_adjust shadow_walk_iterator
    arg
  kvm: x86/mmu: Add TDP MMU PF handler
  kvm: x86/mmu: Allocate struct kvm_mmu_pages for all pages in TDP MMU
  kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU
  kvm: x86/mmu: Add access tracking for tdp_mmu
  kvm: x86/mmu: Support changed pte notifier in tdp MMU
  kvm: x86/mmu: Support dirty logging for the TDP MMU
  kvm: x86/mmu: Support disabling dirty logging for the tdp MMU
  kvm: x86/mmu: Support write protection for nesting in tdp MMU
  kvm: x86/mmu: Support MMIO in the TDP MMU
  kvm: x86/mmu: Don't clear write flooding count for direct roots
  kvm: x86/mmu: NX largepage recovery for TDP MMU

Peter Xu (1):
  KVM: Cache as_id in kvm_memory_slot

 arch/x86/include/asm/kvm_host.h |   14 +
 arch/x86/kvm/Makefile           |    3 +-
 arch/x86/kvm/mmu/mmu.c          |  487 +++++++------
 arch/x86/kvm/mmu/mmu_internal.h |  242 +++++++
 arch/x86/kvm/mmu/paging_tmpl.h  |    3 +-
 arch/x86/kvm/mmu/tdp_iter.c     |  181 +++++
 arch/x86/kvm/mmu/tdp_iter.h     |   60 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 1154 +++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   48 ++
 include/linux/kvm_host.h        |    2 +
 virt/kvm/kvm_main.c             |   12 +-
 11 files changed, 1944 insertions(+), 262 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h

-- 
2.28.0.1011.ga647a8990f-goog

