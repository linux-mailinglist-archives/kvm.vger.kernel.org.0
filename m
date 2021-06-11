Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06193A4B80
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhFLAA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 20:00:26 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:50074 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhFLAA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 20:00:26 -0400
Received: by mail-yb1-f201.google.com with SMTP id v184-20020a257ac10000b02904f84a5c5297so6324549ybc.16
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oa07k1Ea4brTa/98WVOO3kGqFYzDvx2VJURBpmM7C3Q=;
        b=mhd/lZuZiXYf1Ec6QlbuFlFJvxpYrLSqk78XJ2SkRWEkpkQPJRzktXRB47BZJBf/4A
         4KkouVs95GWOKjW+aI4bkXzPIL6V6yuK63GNcuDa1L3ZIXom7QYHYnh0Z2zWpTA0PbN1
         sNGlh1ZlvUccCMXzuQwpSIUROtd0BFixp26KR2n+GGgZT2liJXmUY1lHI7Vt2Zy7pNEM
         /Sb4uO6Cj0sQGFlf3qxYmr+B0sjrJIdT+1xIGPXHoBKeaiAz/1/me95CTAXqgC7+XaEr
         9O//pip7V1UGjKatWi/UvLQ4TxUSCg8cu4LfhYbLhT8aEtDkqYMJxtvimJfPaLBMchuI
         ZtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oa07k1Ea4brTa/98WVOO3kGqFYzDvx2VJURBpmM7C3Q=;
        b=nXorTMRW3i5egLEjVQksGx2Vm5NvF9D/LAihNzammkvfVeFbPCvREIvp8LwDXxL7w6
         mT10mtKnigH0UG1MCcRip6VmdjYx3yxkpOXQ3IarZwl8KqkkN/RtgEuX0AROTru2ENHV
         j4WjAaSIqq0A8epyMVhceC+NwFjOLgbkhoIeBDxBopNYqrvlcaJ0GFqazswm5FHU1Jsl
         jOaO/VjBpsuX8UAmVT1c6M5/EBcE5gpTaa8ZXgJRUR6onaipim3aj9wCg10GJ0/4Q5RE
         /r608ku44c0KxEwUUUgjjc+f8gkCBwoAP0rtt1LRHqolHp4jbYeKZEqbDWpbmEa5BwpV
         toUA==
X-Gm-Message-State: AOAM530AIK4qhp6IkyYHCKoKQphYLIoBShc/NKyzRktqB7WX/wYLSBNZ
        Zitzf2TZkTkgrWyFyGw0bMiSSdmpilwMgKI4KtPi11YhQD0wtgFdW3JRgShi+sWRCyMElh3O3WK
        CWQSejdYonOuZCtvkK9c3gcrrXD977rxReUXDsj1bIULIdMcJEFHmpeqEbTOerk8=
X-Google-Smtp-Source: ABdhPJzJCQr5D24FM6T8SupQ1Cj+MchayfqiUFqqyICFJo9Qh3BwMpdsZvJhLFaOreRDSPNaMJCSqr2aiSPhqw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:dc14:: with SMTP id
 y20mr10310655ybe.243.1623455839179; Fri, 11 Jun 2021 16:57:19 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:53 +0000
Message-Id: <20210611235701.3941724-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds support for the TDP MMU in the fast_page_fault
path, which enables certain write-protection and access tracking faults
to be handled without taking the KVM MMU lock. This series brings the
performance of these faults up to par with the legacy MMU.

Design
------

This series enables the existing fast_page_fault handler to operate
independent of whether the TDP MMU is enabled or not by abstracting out
the details behind a new lockless page walk API. I tried an alterative
design where the TDP MMU provided its own fast_page_fault handler and
there was a shared helper code for modifying the PTE. However I decided
against this approach because it forced me to duplicate the retry loop,
resulted in calls back and forth between mmu.c and tdp_mmu.c, and
passing around the RET_PF_* values got complicated fast.

Testing
-------

Setup:
 - Ran all tests on a Cascade Lake machine.
 - Ran all tests with kvm_intel.eptad=N, kvm_intel.pml=N, kvm.tdp_mmu=N.
 - Ran all tests with kvm_intel.eptad=N, kvm_intel.pml=N, kvm.tdp_mmu=Y.

Tests:
 - Ran ll KVM selftests with default arguments
 - ./access_tracking_perf_test -v 4
 - ./access_tracking_perf_test -v 4 -o
 - ./access_tracking_perf_test -v 4 -s anonymous_thp
 - ./access_tracking_perf_test -v 4 -s anonymous_thp -o
 - ./access_tracking_perf_test -v 64
 - ./dirty_log_perf_test -v 4 -s anonymous_thp
 - ./dirty_log_perf_test -v 4 -s anonymous_thp -o
 - ./dirty_log_perf_test -v 4 -o
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

Both metrics improved by 10x:

Metric                            | tdp_mmu=Y before   | tdp_mmu=Y after
--------------------------------- | ------------------ | --------------------
Iteration 2 dirty memory time     | 3.545234984s       | 0.312197959s
Writing to idle memory            | 3.249645416s       | 0.298275545s

The TDP MMU is now on par with the legacy MMU:

Metric                            | tdp_mmu=N          | tdp_mmu=Y
--------------------------------- | ------------------ | --------------------
Iteration 2 dirty memory time     | 0.300802793s       | 0.312197959s
Writing to idle memory            | 0.295591860s       | 0.298275545s

David Matlack (8):
  KVM: x86/mmu: Refactor is_tdp_mmu_root()
  KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
  KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
  KVM: x86/mmu: Common API for lockless shadow page walks
  KVM: x86/mmu: Also record spteps in shadow_page_walk
  KVM: x86/mmu: fast_page_fault support for the TDP MMU
  KVM: selftests: Fix missing break in dirty_log_perf_test arg parsing
  KVM: selftests: Introduce access_tracking_perf_test

 arch/x86/kvm/mmu/mmu.c                        | 159 +++----
 arch/x86/kvm/mmu/mmu_internal.h               |  18 +
 arch/x86/kvm/mmu/mmutrace.h                   |   3 +
 arch/x86/kvm/mmu/tdp_mmu.c                    |  37 +-
 arch/x86/kvm/mmu/tdp_mmu.h                    |  14 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/access_tracking_perf_test.c | 419 ++++++++++++++++++
 .../selftests/kvm/dirty_log_perf_test.c       |   1 +
 9 files changed, 559 insertions(+), 96 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/access_tracking_perf_test.c

-- 
2.32.0.272.g935e593368-goog

