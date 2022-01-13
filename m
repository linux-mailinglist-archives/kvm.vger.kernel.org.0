Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2B48E026
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiAMWSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiAMWSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:18:38 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51B9C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:38 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id d11-20020a17090a498b00b001b3fb4f070bso7303281pjh.5
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mi/LQKgmJBmAiBILdAflGAgvF9Fnz9F9pCGXYuc0pHk=;
        b=C1n/8cnWnu3xuCdFOKSMkC93/HRTCL3jtnOCsUeptqcbjRmRp2bczstGuyEHO4cPOW
         VvHDp/n/6Zj+QeLKLRLaYODsYeR27fwKaULahXdoPEt6cgEHb6GSRiMtO9sqbZXOs/M2
         7mEF7rWirq40vk6Zu+WSAt2kSwr3hXToXbty5sbUS27AeDN+SvKRKTTS41sZFfP/sq3/
         Fy5hNs3I1g1Mp7y+QalVIsuXYS/5BA9hUqhbbR6CSWuqhGsNCc7s/7k/on+NC9baGVvI
         WhfkRq0Q0KEqU/1J7NDU16iImxxNrNLslDG5/58AoznmF9LMzGnW8aDJZOhW8ubyYAdU
         xP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mi/LQKgmJBmAiBILdAflGAgvF9Fnz9F9pCGXYuc0pHk=;
        b=Byo7rTiju6mFyNsJuyrl1gPoHTRkMY3k3ySM1szmzPG4mnfR4zktsPzTgIxwIWP60e
         YEXdnK7ISgMASOdDM2WjnOBmUx0TdMfuL7Yu3/+TyfUEVrCPgUhSqXfxyjZhnnLhBAMo
         40mGiDfTsXHPT+dZ/StK/ynCSuC4z0iDr5GQGdCgvS/xJtznRawO9WBbMaA6x78VFVkm
         RYokDyNhNs8D8nTSHnugVgEqI+37c20XfCF3uDh3/valWJFattbZ9A2nOso48eawVbAR
         N9Amtty3eFS6pmTGToa9i1L6n7Uz7F3lVawdDItRIIElK8GO0KhNxvmRAP4Op4D6nhEi
         Ae8g==
X-Gm-Message-State: AOAM532vpqJT45dRZblT5r5aKQ9iv8EfZG+a1gxOuqiUnuHaILbalgQE
        5I/CpXaFPmtjc2MA6V6pmt/cmQHihcMxmjsUspjoXsIQ37rfW1zvNhrejVt95ni7qVWYd95sOGy
        toQ0J4QO95J37y+DljtgU6S2BCKo8AJ9jlPxV4/Vh71nnxnA7u+St0FO6f/mWFOf/9U5WGAQ=
X-Google-Smtp-Source: ABdhPJxY7dyxWRS3DN+Mpqc5rukx0G5buKmfcllLybveSLqyNmyoVgftxn9suoQQ2b7q4ICBT2MW0cGZ+soaEsBZTQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a62:bd0d:0:b0:4bf:299c:4c93 with SMTP
 id a13-20020a62bd0d000000b004bf299c4c93mr6225813pff.14.1642112317954; Thu, 13
 Jan 2022 14:18:37 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:18:26 +0000
Message-Id: <20220113221829.2785604-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v1 0/3] ARM64: Guest performance improvement during dirty
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

* RFC -> v1
  - Rebase to kvm/queue, commit fea31d169094
    (KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event)
  - Moved the fast path in user_mem_abort, as suggested by Marc.
  - Addressed other comments from Marc.

[RFC] https://lore.kernel.org/all/20220110210441.2074798-1-jingzhangos@google.com

---

Jing Zhang (3):
  KVM: arm64: Use read/write spin lock for MMU protection
  KVM: arm64: Add fast path to handle permission relaxation during dirty
    logging
  KVM: selftests: Add vgic initialization for dirty log perf test for
    ARM

 arch/arm64/include/asm/kvm_host.h             |  2 +
 arch/arm64/kvm/mmu.c                          | 52 ++++++++++++-------
 .../selftests/kvm/dirty_log_perf_test.c       | 10 ++++
 3 files changed, 46 insertions(+), 18 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

