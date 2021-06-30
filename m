Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F503B8A31
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhF3Vuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3Vuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6F3C061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 17-20020a630b110000b029022064e7cdcfso2591068pgl.10
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MxOyG3/xcTj3e35bf3NZtrTTT83mMQslJvdMq5xN5rk=;
        b=LhBC+MuL07jtC8jjvaPye25YIeoiaOkd9erRCAfZwSRcB1ajOMatPEwjMS5b3FguvD
         9F10sImkoekwy/UCE8sFY56BW17dQ1zxZEry22Jr398L3RCLPAAIA7vv04hU7Gf4i3Rt
         vYuvkL6J+PFRyaSFjZRaKdb/8P8Qg4pN7XzMWbIZQLEn90+70Hsq2fAbkAxxafaQ6Q/2
         9UG6f17qnE4nQJ8cDcJfVxTgpemxX8lotfbsvmmQy8eTSf1vgCaKO4fQ6Np/gMRpPvw3
         Wikw4jHz5csecaCpm9JsV6/E1uVW3a62Pr4ZgjclxDgDytOOCeKKWGjeo0Xs1+wI1d/k
         lfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MxOyG3/xcTj3e35bf3NZtrTTT83mMQslJvdMq5xN5rk=;
        b=NG8mXbLATAZcVrKiVvQWlMmkf3+7RjBmn/mzRioEKsE/tkyITn//2hfWgTJAkDhsLY
         ffB7VwpqZmxg1aZ/QUdWtXxFYswsL5Q7n7dMeW6KrA3KWxeoS/okd/gnvM6Hhkuqc26L
         wLvRtksIn7mLbSLXh/FpqsENlueUeVGuYxJZ5CAEszelYSc+fkusI5Jsfk2DXU7ZOROp
         Dd9pIfYgfX040fo7WI9bNoPZTfdlNaU08lA2bazMS4rba0t6Z/x+Ruww/hOKN8xNn039
         KYTc2S0GeEmAe9yCsAop4SvjP0LWaJ3SalLJMLqoV0VMjfomgBSWkNLUTmehn1nqWuHf
         aUpA==
X-Gm-Message-State: AOAM530+Q9KPP7qZoETgtBNW1Jqz9jVdMYrmDnz2XhooBkh1Sd/lK6Vl
        ScWoWf2wBQoBNLpTL1wenOa/3jVPmJIat8ZDuw5eOTEXticpQVWgeJ6nmSQRe7zkj3OT2viZeSA
        /9JFqs38S+mvK1VEhmLkB/ZOLBNJnnt5UxJBqEWfm8iy9oF/qjmjgHvHqF1M/ioY=
X-Google-Smtp-Source: ABdhPJysxFw4HkbiXxMnjIN9oe1lozhct7rOptlvwuCcguao0LGatJtMDvVy9gslwbpr2KgdIupRGNGwyBp4XA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a393:: with SMTP id
 x19mr166464pjp.1.1625089698860; Wed, 30 Jun 2021 14:48:18 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:47:56 +0000
Message-Id: <20210630214802.1902448-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds support for the TDP MMU in the fast_page_fault
path, which enables certain write-protection and access tracking faults
to be handled without taking the KVM MMU lock. This series brings the
performance of these faults up to par with the legacy MMU.

Since there is not currently any KVM test coverage for access tracking
faults, this series introduces a new KVM selftest,
access_tracking_perf_test. Note that this test relies on page_idle to
enable access tracking from userspace (since it is the only available
usersapce API to do so) and page_idle is being considered for removal
from Linux
(https://lore.kernel.org/linux-mm/20210612000714.775825-1-willy@infradead.org/).

Design
------

This series enables the existing fast_page_fault handler to operate
independent of whether the TDP MMU is enabled or not by abstracting out
the details behind a new lockless page walk API.

An alternative design considered was to add a separate fast_page_fault
handler to the TDP MMU. The code that inspects the spte and genereates
the new spte can be shared with the legacy MMU. However with this
design the retry loop has to be duplicated, there are many calls back
and forth between mmu.c and tdp_mmu.c, and passing around the RET_PF_*
values gets complicated.

Testing
-------

This series was tested on an Intel Cascade Lake machine. The kvm_intel
parameters eptad and pml were disabled to force access and dirty
tracking to go through fast_page_fault. All tests were run with the
TDP MMU enabled and then again disabled.

Tests ran:
 - All KVM selftests with default arguments
 - All x86_64 kvm-unit-tests.
 - ./access_tracking_perf_test -v 4
 - ./access_tracking_perf_test -v 4 -o
 - ./access_tracking_perf_test -v 4 -s anonymous_thp
 - ./access_tracking_perf_test -v 4 -s anonymous_thp -o
 - ./access_tracking_perf_test -v 64
 - ./dirty_log_perf_test -v 4
 - ./dirty_log_perf_test -v 4 -o
 - ./dirty_log_perf_test -v 4 -s anonymous_thp
 - ./dirty_log_perf_test -v 4 -s anonymous_thp -o
 - ./dirty_log_perf_test -v 64

For certain tests I also collected the fast_page_fault tracepoint to
manually make sure it was getting triggered properly:

  perf record -e kvmmmu:fast_page_fault --filter "old_spte != 0" -- <test>

Performance Results
-------------------

To measure performance I ran dirty_log_perf_test and
access_tracking_perf_test with 64 vCPUs. For dirty_log_perf_test
performance is measured by "Iteration 2 dirty memory time", the time it
takes for all vCPUs to write to their memory after it has been
write-protected. For access_tracking_perf_test performance is measured
by "Writing to idle memory", the time it takes for all vCPUs to write to
their memory after it has been access-protected.

Metric                            | tdp_mmu=Y before   | tdp_mmu=Y after
--------------------------------- | ------------------ | --------------------
Iteration 2 dirty memory time     | 3.545234984s       | 0.315209625s
Writing to idle memory            | 3.249645416s       | 0.301676189s

The performance improvement comes from less time spent acquiring the
mmu lock in read mode and less time looking up the memslot for the
faulting gpa.

The TDP MMU is now on par with the legacy MMU:

Metric                            | tdp_mmu=N          | tdp_mmu=Y
--------------------------------- | ------------------ | --------------------
Iteration 2 dirty memory time     | 0.303452990s       | 0.315209625s
Writing to idle memory            | 0.291742127s       | 0.301676189s

v2:
 * Split is_tdp_mmu_root cleanup into a separate series. [Sean]
   https://lore.kernel.org/kvm/20210617231948.2591431-1-dmatlack@google.com/
 * Split walk_shadow_page_lockless into 2 APIs. [Sean]
 * Perform rcu_dereference on TDP MMU sptep.
 * Add comment to tdp_mmu_set_spte_atomic explaining new interaction
 * with fast_pf_fix_direct_spte. [Ben]
 * Document pagemap shifts in access_tracking_perf_test. [Ben]
 * Skip test if lacking pagemap permissions (present pfn is 0). [Ben]
 * Add Ben's Reviewed-by tags.

v1: https://lore.kernel.org/kvm/20210611235701.3941724-1-dmatlack@google.com/

David Matlack (6):
  KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
  KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
  KVM: x86/mmu: Make walk_shadow_page_lockless_{begin,end} interoperate
    with the TDP MMU
  KVM: x86/mmu: fast_page_fault support for the TDP MMU
  KVM: selftests: Fix missing break in dirty_log_perf_test arg parsing
  KVM: selftests: Introduce access_tracking_perf_test

 arch/x86/kvm/mmu/mmu.c                        |  83 +++-
 arch/x86/kvm/mmu/mmutrace.h                   |   3 +
 arch/x86/kvm/mmu/tdp_mmu.c                    |  56 ++-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   8 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/access_tracking_perf_test.c | 429 ++++++++++++++++++
 .../selftests/kvm/dirty_log_perf_test.c       |   1 +
 8 files changed, 550 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/access_tracking_perf_test.c

-- 
2.32.0.93.g670b81a890-goog

