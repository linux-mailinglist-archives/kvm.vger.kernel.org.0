Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8344913D0
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 02:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiARB5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 20:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239084AbiARB5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 20:57:08 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0213C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:07 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i6-20020a626d06000000b004c0abfd53b3so7192179pfc.12
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vJOiObhxu95/kxDXA87lBI0whmijrZSeIBoPadjg9mo=;
        b=Pt60whvLgekWJhH1GRWxJSl/e5HGmX1wB5gUdjm2pEz6QXWyaVd4fG5NFIZvX3th6k
         L6RyOu9Limw3r9t5JXd45PhYQ9KOT34iq8bQnDZe5fmCSotaFdD93kRGqcWtcGh/8DhI
         v1rx3CsjPK4ApY/SBPTbinMBBvHW5RruKG7y2Sf5ihfOmOAwPL4ZVEd6Cq/pALCWFc+5
         bfY3/QneI0cRibvCdD+yMAO0ZmlDCmNRhuK0QHy7oSAQnTZYUQ+vWgTJ8Wm0HPnL7K2+
         XPhdsddsnYC2TneQ79IVqcTOLR9F8lKHcBOrjvdfFX3rNUFJkrGZXrpxQm934/Luquu7
         AUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vJOiObhxu95/kxDXA87lBI0whmijrZSeIBoPadjg9mo=;
        b=7xnohjHGo8O5ldAIZpVSsVYyhBUR7/xltnoC9xs3v/LwJa87Fi6Jv/vQxRd+VnAf5F
         YZL+PJtoc42iMCqd5C1w2K62i5N0usHJemZTrCdrbDzj8d6ipLLUVpHY9KN0cjY1gHP4
         8qe6wfhbs2/E4oMBumDmm6GplMx9Tb1BopOgl/9aq9uQo2YEpKcmXvPsFCMFedpGfAe5
         jYR+HDiR2b6mFAZuriOg2rZ0w2O7Am7Aw6a9TzvrcFu37IAkh7bxXaP1czKsM8Pnt3jc
         jnharZTD7k56OvvMj6k7dh2jf/pE/4+UeEzlgPZg+jq79+hJStznoygtadSOIWq5FQNg
         yAmA==
X-Gm-Message-State: AOAM532+EGNfexkKq92QqC1QJfv2EXV90G/zNReYVlIkQeIKEZ2SHJaD
        TXZ4qoO00kdO0ISEY3W0t4b0VwvqhtOtAgWyG9RVKQPND4PLVC0usoS9rvpBHEFC5BDDecTGNwk
        rPjpGPq7gwdbLX65viNUTFj9u5HCns7tH0nBOWkmnDhxqeDmTg7S8wd6cA2NGCSXhcpRlIGg=
X-Google-Smtp-Source: ABdhPJwRk9u/XzSP0HuCbMjd6ti3DsYyIEU8xQCyhdJ7euIPihphq+67Gz5FH5UrKmUCSggrkREN7GbJpKNcZfeDlA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e8c8:b0:149:eb6d:23fb with
 SMTP id v8-20020a170902e8c800b00149eb6d23fbmr25496710plg.53.1642471026898;
 Mon, 17 Jan 2022 17:57:06 -0800 (PST)
Date:   Tue, 18 Jan 2022 01:57:00 +0000
Message-Id: <20220118015703.3630552-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 0/3] ARM64: Guest performance improvement during dirty
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is to reduce the performance degradation of guest workload during
dirty logging on ARM64. A fast path is added to handle permission relaxation
during dirty logging. The MMU lock is replaced with rwlock, by which all
permision relaxations on leaf pte can be performed under the read lock. This
greatly reduces the MMU lock contention during dirty logging. With this
solution, the source guest workload performance degradation can be improved
by more than 60%.

Problem:
  * A Google internal live migration test shows that the source guest workload
  performance has >99% degradation for about 105 seconds, >50% degradation
  for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
  This shows that most of the time, the guest workload degradtion is above
  99%, which obviously needs some improvement compared to the test result
  on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
  * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB, PageSize: 4K
  * VM spec: #vCPU: 48, #Mem/vCPU: 4GB, PageSize: 4K, 2M hugepage backed

Analysis:
  * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
    the number of contentions of MMU lock and the "dirty memory time" on
    various VM spec. The "dirty memory time" is the time vCPU threads spent
    in KVM after fault. Higher "dirty memory time" means higher degradation
    to guest workload.
    '-m 2' specifies the mode "PA-bits:48,  VA-bits:48,  4K pages".
    By using test command
    ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
    Below are the results:
    +-------+------------------------+-----------------------+
    | #vCPU | dirty memory time (ms) | number of contentions |
    +-------+------------------------+-----------------------+
    | 1     | 926                    | 0                     |
    +-------+------------------------+-----------------------+
    | 2     | 1189                   | 4732558               |
    +-------+------------------------+-----------------------+
    | 4     | 2503                   | 11527185              |
    +-------+------------------------+-----------------------+
    | 8     | 5069                   | 24881677              |
    +-------+------------------------+-----------------------+
    | 16    | 10340                  | 50347956              |
    +-------+------------------------+-----------------------+
    | 32    | 20351                  | 100605720             |
    +-------+------------------------+-----------------------+
    | 64    | 40994                  | 201442478             |
    +-------+------------------------+-----------------------+

  * From the test results above, the "dirty memory time" and the number of
    MMU lock contention scale with the number of vCPUs. That means all the
    dirty memory operations from all vCPU threads have been serialized by
    the MMU lock. Further analysis also shows that the permission relaxation
    during dirty logging is where vCPU threads get serialized.

Solution:
  * On ARM64, there is no mechanism as PML (Page Modification Logging) and
    the dirty-bit solution for dirty logging is much complicated compared to
    the write-protection solution. The straight way to reduce the guest
    performance degradation is to enhance the concurrency for the permission
    fault path during dirty logging.
  * In this patch, we only put leaf PTE permission relaxation for dirty
    logging under read lock, all others would go under write lock.
    Below are the results based on the fast path solution:
    +-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 965                    |
    +-------+------------------------+
    | 2     | 1006                   |
    +-------+------------------------+
    | 4     | 1128                   |
    +-------+------------------------+
    | 8     | 2005                   |
    +-------+------------------------+
    | 16    | 3903                   |
    +-------+------------------------+
    | 32    | 7595                   |
    +-------+------------------------+
    | 64    | 15783                  |
    +-------+------------------------+

  * Furtuer analysis shows that there is another bottleneck caused by the
    setup of the test code itself. The 3rd commit is meant to fix that by
    setting up vgic in the test code. With the test code fix, below are
    the results which show better improvement.
    +-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 803                    |
    +-------+------------------------+
    | 2     | 843                    |
    +-------+------------------------+
    | 4     | 942                    |
    +-------+------------------------+
    | 8     | 1458                   |
    +-------+------------------------+
    | 16    | 2853                   |
    +-------+------------------------+
    | 32    | 5886                   |
    +-------+------------------------+
    | 64    | 12190                  |
    +-------+------------------------+
    All "dirty memory time" has been reduced by more than 60% when the
    number of vCPU grows.
  * Based on the solution, the test results from the Google internal live
    migration test also shows more than 60% improvement with >99% for 30s,
    >50% for 58s and >10% for 76s.

---

* v1 -> v2
  - Renamed flag name from use_mmu_readlock to logging_perm_fault.
  - Removed unnecessary check for fault_granule to use readlock.
* RFC -> v1
  - Rebase to kvm/queue, commit fea31d169094
    (KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event)
  - Moved the fast path in user_mem_abort, as suggested by Marc.
  - Addressed other comments from Marc.

[v1] https://lore.kernel.org/all/20220113221829.2785604-1-jingzhangos@google.com
[RFC] https://lore.kernel.org/all/20220110210441.2074798-1-jingzhangos@google.com

---

Jing Zhang (3):
  KVM: arm64: Use read/write spin lock for MMU protection
  KVM: arm64: Add fast path to handle permission relaxation during dirty
    logging
  KVM: selftests: Add vgic initialization for dirty log perf test for
    ARM

 arch/arm64/include/asm/kvm_host.h             |  2 +
 arch/arm64/kvm/mmu.c                          | 49 ++++++++++++-------
 .../selftests/kvm/dirty_log_perf_test.c       | 10 ++++
 3 files changed, 43 insertions(+), 18 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

