Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC913EBD71
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhHMUff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhHMUfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E744C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w5-20020a170902e885b029012cf3ddd763so6825794plg.17
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XrhioAKT7DeWiKgmwundTZ+OwNu0PRvaU+357/cSBQw=;
        b=Uq9EXyP7sD0LnBObzCAIBWskW5rFJ9BuS+b8tEXUFNAfVV2tCncg6PI7/wuiQlgWoO
         g4yMl0uUhh3e/kGFK8PSSLPTK8XTM4gQYcEHFgoBLpDY6Gmw7tiPsR6ALf5tjMTfVRNG
         mItepTmn14QkqPszOcGiY94zzveT8Kh7fVlEwD+bBbwjEOs19jduWzVosrrNRydVtiFI
         sFYKYm0Ot5SCfaWPn9fcTE3NXWmm07ln8JnZBpgYqhiJQeRc4rs0U6LdS/eGJvxOaKwS
         +gTOfhkmt1r1PRubnVqLw25ACIBM84jLg+AjzLNYvm94nG9Fyw3ZumT64j0is94hRebm
         FBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XrhioAKT7DeWiKgmwundTZ+OwNu0PRvaU+357/cSBQw=;
        b=s3mAOGMTOBONy9d9+/f309peUg0hHKUmf9ZS2R5ei9iK1dV36LgKQi0cTh+I56Tfpv
         1AZYbougvq+QUG2SvGtKmdoWunqsJs4Fykf/Khr15rVUcDxkX/BhG5mPecNslW5dxhfX
         WvYpFMwgWb1VjFyDDb/T+9R1fSXs0k9f6XjSYUO5LIx4V10dsHx+XeGPM22eXfkDl0//
         KePRZ0aKggvmtGX9kmBFsmZfKmMUs82ysllWiGfYKs3N64en2g68xqJEc3oopHFJ7FiB
         gnW1kmH+kaMW1vkbljJpXKFZ9cao+f6rWFJsMSK1BF0Oszy6ZnhiwlVGeG2HUyaIJvBi
         FuXQ==
X-Gm-Message-State: AOAM531s1TGNpsm5G9hmU+UmfO+2gkCMtjMHXTiah8el3+g9+8qa6Kj+
        NT8vwvn7U0NnLkr0XM3TotQ/y6pmUDMyzg==
X-Google-Smtp-Source: ABdhPJyjHkWFxeI7Nr4q5qwN/7ZgfKDB0WA88trny4DDBhYHjfXfed1lo/AKXx7W8ipOQq9u4LvYsINKiUtzvw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c202:b029:12d:65b0:fd3b with SMTP
 id 2-20020a170902c202b029012d65b0fd3bmr3438229pll.25.1628886906702; Fri, 13
 Aug 2021 13:35:06 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:34:58 +0000
Message-Id: <20210813203504.2742757-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 0/6] Pass memslot around during page fault handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series avoids kvm_vcpu_gfn_to_memslot() calls during page fault
handling by passing around the memslot in struct kvm_page_fault. This
idea came from Ben Gardon who authored an similar series in Google's
kernel.

This series is an RFC because kvm_vcpu_gfn_to_memslot() calls are
actually quite cheap after commit fe22ed827c5b ("KVM: Cache the last
used slot index per vCPU") since we always hit the cache. However
profiling shows there is still some time (1-2%) spent in
kvm_vcpu_gfn_to_memslot() and that hot instructions are the memory loads
for kvm->memslots[as_id] and slots->used_slots. This series eliminates
this remaining overhead but at the cost of a bit of code churn.

Design
------

We can avoid the cost of kvm_vcpu_gfn_to_memslot() by looking up the
slot once and passing it around. In fact this is quite easy to do now
that KVM passes around struct kvm_page_fault to most of the page fault
handling code.  We can store the slot there without changing most of the
call sites.

The one exception to this is mmu_set_spte, which does not take a
kvm_page_fault since it is also used during spte prefetching. There are
three memslots lookups under mmu_set_spte:

mmu_set_spte
  rmap_add
    kvm_vcpu_gfn_to_memslot
  rmap_recycle
    kvm_vcpu_gfn_to_memslot
  set_spte
    make_spte
      mmu_try_to_unsync_pages
        kvm_page_track_is_active
          kvm_vcpu_gfn_to_memslot

Avoiding these lookups requires plumbing the slot through all of the
above functions. I explored creating a synthetic kvm_page_fault for
prefetching so that kvm_page_fault could be passed to all of these
functions instead, but that resulted in even more code churn.

Patches
-------

Patches 1-2 are small cleanups related to the series.

Patches 3-4 pass the memslot through kvm_page_fault and use it where
kvm_page_fault is already accessible.

Patches 5-6 plumb the memslot down into the guts of mmu_set_spte to
avoid the remaining memslot lookups.

Performance
-----------

I measured the performance using dirty_log_perf_test and taking the
average "Populate memory time" over 10 runs. To help inform whether or
not different parts of this series is worth the code churn I measured
the performance of pages 1-4 and 1-6 separately.

Test                            | tdp_mmu | kvm/queue | Patches 1-4 | Patches 1-6
------------------------------- | ------- | --------- | ----------- | -----------
./dirty_log_perf_test -v64      | Y       | 5.22s     | 5.20s       | 5.20s
./dirty_log_perf_test -v64 -x64 | Y       | 5.23s     | 5.14s       | 5.14s
./dirty_log_perf_test -v64      | N       | 17.14s    | 16.39s      | 15.36s
./dirty_log_perf_test -v64 -x64 | N       | 17.17s    | 16.60s      | 15.31s

This series provides no performance improvement to the tdp_mmu but
improves the legacy MMU page fault handling by about 10%.

David Matlack (6):
  KVM: x86/mmu: Rename try_async_pf to kvm_faultin_pfn in comment
  KVM: x86/mmu: Fold rmap_recycle into rmap_add
  KVM: x86/mmu: Pass around the memslot in kvm_page_fault
  KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
  KVM: x86/mmu: Avoid memslot lookup in rmap_add
  KVM: x86/mmu: Avoid memslot lookup in mmu_try_to_unsync_pages

 arch/x86/include/asm/kvm_page_track.h |   4 +-
 arch/x86/kvm/mmu.h                    |   5 +-
 arch/x86/kvm/mmu/mmu.c                | 110 +++++++++-----------------
 arch/x86/kvm/mmu/mmu_internal.h       |   3 +-
 arch/x86/kvm/mmu/page_track.c         |   6 +-
 arch/x86/kvm/mmu/paging_tmpl.h        |  18 ++++-
 arch/x86/kvm/mmu/spte.c               |  11 +--
 arch/x86/kvm/mmu/spte.h               |   9 ++-
 arch/x86/kvm/mmu/tdp_mmu.c            |  12 +--
 9 files changed, 80 insertions(+), 98 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

