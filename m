Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2F444CE0C
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhKKAGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhKKAGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:05 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECFEC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:17 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso1910243pjb.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=puRYWI4avhociHSaO6PkBsC+dGQfbUhSErR9iQtcCYQ=;
        b=nlNwE7YgCBPh78a/AcfjEYEuim6GEuEGfYmro28Ir27clTxpwW2jfsEWx1RefhS0Qy
         LqrQMSLkjzGdPIwz7sBaW6IJHHf+BAZ7wP2k65qeSU6cJZxiUjPZt91yn1Q7GrT/mhVu
         AHdCfFRd6xvIAX9nmCgygutO3o+yrk+AGPOuNYBMOKpZr8IHyLbZzYaSyaefAXxdEwZl
         /DV8cdvsXk7qq+VD1xBcU9gjGssL0nPZww5ltgubFdPpGCwlX3hpwqkUCj5xQIcnd4vy
         EoQUg7k4PYbnFEwJ1nWJlquK0ycTn0FfoKgAmjdCoPtuSuzaNGyauSfU80jvIEofPuJf
         3hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=puRYWI4avhociHSaO6PkBsC+dGQfbUhSErR9iQtcCYQ=;
        b=HfyDyN2BEYcyuGzY/1crwORsqIyPKU1E0gUN2Ze2tLKGC9i/RFd/LMgRS13AI/uV+s
         yVcpgv18y0DrtD1kgQDQOQvOvhfCUY0bydX5iGG20lH7eDp9rv2aSHMKkRyjFhBGyJN0
         RuNamsPJ7vipdtEcZyTlez7lS2vlQi4cL9PiWgivqKDl8sNcjPPor7Yebyl3QtcfW84D
         SVb3UfkTbwg//f2O6cVXPezuaMhMHY0cE/Dl3GmXQI8/MEasMF7hr7a3Y/P5U1wPHu+f
         JEfKPaF+2dhnzys0E49dlykKEMdacevVrCxfZIR14+JPnOAcF8qjEMdUqjqHdxHggZKn
         KV7A==
X-Gm-Message-State: AOAM533mJj+N/XQ86OrL6qtbu78wb6t7+L2flx4RAFcRVS5y8juwQ1fl
        cF09uuTU9OtEDbdMP5bx7o4fbu2FL9WNMg==
X-Google-Smtp-Source: ABdhPJwY6xm0J03NNsrdqX4WgtwPbNRpFk8tJDyLWOrN8jKExT3rZTRL7KwrTHRqBAbFST7fpm4H3oELCvuXUg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr89872pjf.1.1636588996159; Wed, 10 Nov 2021 16:03:16 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:02:58 +0000
Message-Id: <20211111000310.1435032-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 00/12] KVM: selftests: Hugepage fixes and cleanups
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix hugepage bugs in the KVM selftests that specifically affect dirty
logging and demand paging tests.  Found while attempting to verify KVM
changes/fixes related to hugepages and dirty logging (patches incoming in
a separate series).

Clean up the perf_test_args util on top of the hugepage fixes to clarify
what "page size" means, and to improve confidence in the code doing what
it thinks it's doing.  In a few cases, users of perf_test_args were
duplicating (approximating?) calculations made by perf_test_args, and it
wasn't obvious that both pieces of code were guaranteed to end up with the
same result.

v2:
- Add separate align up/down helpers and use the throughout the series
  rather than openly coding the bitwise math [Ben, Paolo]
- Do no pad HugeTLB mmaps [Yanan]
- Drop "[PATCH 04/15] KVM: selftests: Force stronger HVA alignment (1gb)
  for hugepages" since HugeTLB does not require manual HVA alignment
  [David]
- Drop "[PATCH 15/15] KVM: selftests: Get rid of gorilla math in memslots
  modification test" since the gorilla math no longer exists [David]
- Drop "[PATCH 14/15] KVM: selftests: Track size of per-VM memslot in
  perf_test_args" since it was just a prep patch for [PATCH 15/15]
  [David]
- Update the series to kvm/next [David]

v1: https://lore.kernel.org/kvm/20210210230625.550939-1-seanjc@google.com/.

Sean Christopherson (12):
  KVM: selftests: Explicitly state indicies for vm_guest_mode_params
    array
  KVM: selftests: Expose align() helpers to tests
  KVM: selftests: Assert mmap HVA is aligned when using HugeTLB
  KVM: selftests: Require GPA to be aligned when backed by hugepages
  KVM: selftests: Use shorthand local var to access struct
    perf_tests_args
  KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
  KVM: selftests: Use perf util's per-vCPU GPA/pages in demand paging
    test
  KVM: selftests: Move per-VM GPA into perf_test_args
  KVM: selftests: Remove perf_test_args.host_page_size
  KVM: selftests: Create VM with adjusted number of guest pages for perf
    tests
  KVM: selftests: Fill per-vCPU struct during "perf_test" VM creation
  KVM: selftests: Sync perf_test_args to guest during VM creation

 .../selftests/kvm/access_tracking_perf_test.c |   8 +-
 .../selftests/kvm/demand_paging_test.c        |  31 +----
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   6 +-
 .../selftests/kvm/include/perf_test_util.h    |  18 +--
 .../testing/selftests/kvm/include/test_util.h |  26 ++++
 .../selftests/kvm/kvm_page_table_test.c       |   2 +-
 tools/testing/selftests/kvm/lib/elf.c         |   3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++---
 .../selftests/kvm/lib/perf_test_util.c        | 126 ++++++++++--------
 tools/testing/selftests/kvm/lib/test_util.c   |   5 +
 .../kvm/memslot_modification_stress_test.c    |  13 +-
 12 files changed, 153 insertions(+), 139 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

