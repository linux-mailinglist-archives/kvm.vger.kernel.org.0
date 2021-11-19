Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63D4579C9
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhKTABU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKTABM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:12 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B3C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u4-20020a056a00098400b004946fc3e863so6465309pfg.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=x+AXPIBrd7fYBtaaBeVAoiT8PlAZmTojHdyAgPBqmHg=;
        b=CF6XeEePv3BPlNMureJYj8TgbKSi+LoGwjdRz28WaqmgNZoOeI9dxgTFA81jw4R6Q+
         5zeIE1X0eLnSQL0NRxFUFnk7Mh8UqwShiOyi/lZ/Zd24k4SBjZWpYivx5T3fAvnH6jlP
         kNAbquEdTgUkQsPTr2amA+gQHHxhfHOIdKi8JgLi+d4KY2Mna2ACtBDzAB81+cIOZApf
         ep4WVXu3HMtb+LD84KeOnQQPSZ4h8fhktJ1kl3+Dd7wpD1PNc1qeJcDNBaUMudw66SLx
         S3vpyKEojDLGjUtcEe8MmMQgVq3A/fpQBDHAJakMU0BeK4PqPR00F3u0V0jcZk0XA0fO
         IA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=x+AXPIBrd7fYBtaaBeVAoiT8PlAZmTojHdyAgPBqmHg=;
        b=l8ZYNC4cLoojNElN/crTOaCmZ58KE0EthDEv5W8tjeZ462TGtNg1p8XaCWt7d0r0aX
         EgABM55jp0EnHC2mHTCbp7bb4jso8juVmR+O1ZRvawBSwTX3FShDWcs2z+u8WGfyYbOZ
         LVIuLUB8gqjrfZ1Mjz6KxpwMfkmQe0G+oEf3EFMoBhJH37f52LR4OReyVO+c6CL26hAb
         R8nwY8WovRYhLgyDpRgBqwaKe6FOUh3AsF/kXUcIJR8E3uDVVQoOkxLoKIAdGYYYS/wO
         LclysPLZUf3rN4IoBnHl18PzXuWCYkIJ8XMvxbsF+YUSHdWwiHKCIOa8zzii1uOjjTu/
         bdmw==
X-Gm-Message-State: AOAM5304nQy8h8E9zPsvu6TYVHGq+6lkMIoCWoQ5/kdjPvX5Kg8CZSHx
        ziQqga84iKEhxl5NmhBhB3J5UEfScJzV6A==
X-Google-Smtp-Source: ABdhPJwoNfRB4cP86yt0myx6V9vDZoBvpRNX65i5sd/wT7wAOgTLQrn2Pu8xKPK/xcXGAhZuG6PKy3QqU3eing==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP
 id v11-20020a170902b7cb00b00141b33a9589mr82303406plz.9.1637366289637; Fri, 19
 Nov 2021 15:58:09 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:44 +0000
Message-Id: <20211119235759.1304274-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 00/15] KVM: x86/mmu: Eager Page Splitting for the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a first pass at implementing Eager Page Splitting for the
TDP MMU. For context on the motivation and design of Eager Page
Splitting, please see the RFC design proposal and discussion [1].

Paolo, I went ahead and added splitting in both the intially-all-set
case (only splitting the region passed to CLEAR_DIRTY_LOG) and the
case where we are not using initially-all-set (splitting the entire
memslot when dirty logging is enabled) to give you an idea of what
both look like.

Note: I will be on vacation all of next week so I will not be able to
respond to reviews until Monday November 29. I thought it would be
useful to seed discussion and reviews with an early version of the code
rather than putting it off another week. But feel free to also ignore
this until I get back :)

This series compiles and passes the most basic splitting test:

$ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 2 -i 4

But please operate under the assumption that this code is probably
buggy.

[1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t

David Matlack (15):
  KVM: x86/mmu: Rename rmap_write_protect to kvm_vcpu_write_protect_gfn
  KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
  KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
  KVM: x86/mmu: Factor out logic to atomically install a new page table
  KVM: x86/mmu: Abstract mmu caches out to a separate struct
  KVM: x86/mmu: Derive page role from parent
  KVM: x86/mmu: Pass in vcpu->arch.mmu_caches instead of vcpu
  KVM: x86/mmu: Helper method to check for large and present sptes
  KVM: x86/mmu: Move restore_acc_track_spte to spte.c
  KVM: x86/mmu: Abstract need_resched logic from
    tdp_mmu_iter_cond_resched
  KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
  KVM: x86/mmu: Split large pages when dirty logging is enabled
  KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
  KVM: x86/mmu: Add tracepoint for splitting large pages
  KVM: x86/mmu: Update page stats when splitting large pages

 arch/x86/include/asm/kvm_host.h |  22 ++-
 arch/x86/kvm/mmu/mmu.c          | 185 +++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +
 arch/x86/kvm/mmu/mmutrace.h     |  20 ++
 arch/x86/kvm/mmu/spte.c         |  64 +++++++
 arch/x86/kvm/mmu/spte.h         |   7 +
 arch/x86/kvm/mmu/tdp_iter.c     |   5 +-
 arch/x86/kvm/mmu/tdp_iter.h     |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 322 +++++++++++++++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 +
 arch/x86/kvm/x86.c              |   6 +
 11 files changed, 501 insertions(+), 148 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

