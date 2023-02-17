Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C9369A4B5
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBQEMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBQEMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:12:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F34D616
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v63-20020a254842000000b008f257b16d71so4262968yba.15
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H/GuDUROnbyTGes2XnyznN9mXaXPvxr+5www9rGuZjw=;
        b=H7ZJCjnVFcsNWTa2RG29/qsmeOGIVgu1iRjRZLzH/Okmppw4T2+P/DDHy58WBNdcLO
         PVojZBUjBg5LjGq2jrC7hXgb4zDE93b2TjmbkRijt+PL65Hcy3GZQzgEVtX7Mog9upc7
         t8VhxljQvKISaSwRRx8kwA+ZRtOHVEOCt7ujBNJnWU5lEGRUR6D5IMSsLD2wx1A7ihzs
         RNAHFB7TcVRkfy+Kew8x0stSzIp8l0Nq0TztZxKKbos0q83Boz780Kfso4O6Oe9vwb59
         zsDkMg7/13CjEN7WBjRKq4JrH3dQthNX5ytatHzVBkTCzmhRmaI9A/fqmVDEvNfE2KXn
         cdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H/GuDUROnbyTGes2XnyznN9mXaXPvxr+5www9rGuZjw=;
        b=1VmKuQeMee0UCnGgPMZPW2pXevmOhfFHXuXsbHdVL0of1w+C9Z8QNMB8dCZSCgshvd
         dh4tUw2v88pPSyyso5oipSo00hVSBOj1Fdb798C7YwSqJoNAGneB81E4iVjMyF2BYodN
         +k6Ce4f6yrLSHzliJsQTgqZoSH1oWPDyQAFaPRh/t+4wTr7zaaLsqRPCFfsch2jQZwl2
         4+43NHNHEdrwDVWkrjeNdppxNEcu5JUpxleHQVie/ht2bbnH/+54Qu/8+LR2Il6R5cw1
         ffQM7G8jbGzGVUs5iPte2wx4hcEYv+2yeeq7+51+0CJIzEzPXaWmlKpGyOmQ6VhxVhh7
         Fa9w==
X-Gm-Message-State: AO0yUKUPOMMwXUtZrXe0OTFnoW3qvSzGA44nG/vI6jBAzmNbBgNZQZ2M
        U1a9ePQjYrqGTaOQlur/7ghJhgyfeCs=
X-Google-Smtp-Source: AK7set+fTufSi1mf3NHWWE76I/+W+6rBUx1gHUmSS3v0Q9/+ecQDc4/dHySN2KHcxj5eSISsBgqTrYrEgZo=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:6fb3:61e:d31f:1ad3])
 (user=yuzhao job=sendgmr) by 2002:a05:6902:1024:b0:8fc:686c:cf87 with SMTP id
 x4-20020a056902102400b008fc686ccf87mr111670ybt.4.1676607155256; Thu, 16 Feb
 2023 20:12:35 -0800 (PST)
Date:   Thu, 16 Feb 2023 21:12:25 -0700
Message-Id: <20230217041230.2417228-1-yuzhao@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH mm-unstable v1 0/5] mm/kvm: lockless accessed bit harvest
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLDR
====
This patchset RCU-protects KVM page tables and compare-and-exchanges
KVM PTEs with the accessed bit set by hardware. It significantly
improves the performance of guests when the host is under heavy
memory pressure.

ChromeOS has been using a similar approach [1] since mid 2021 and it
was proven successful on tens of millions devices.

[1] https://crrev.com/c/2987928

Overview
========
The goal of this patchset is to optimize the performance of guests
when the host memory is overcommitted. It focuses on the vast
majority of VMs that are not nested and run on hardware that sets the
accessed bit in KVM page tables.

Note that nested VMs and hardware that does not support the accessed
bit are both out of scope.

This patchset relies on two techniques, RCU and cmpxchg, to safely
test and clear the accessed bit without taking kvm->mmu_lock. The
former protects KVM page tables from being freed while the latter
clears the accessed bit atomically against both hardware and other
software page table walkers.

A new MMU notifier API, mmu_notifier_test_clear_young(), is
introduced. It follows two design patterns: fallback and batching.
For any unsupported cases, it can optionally fall back to
mmu_notifier_ops->clear_young(). For a range of KVM PTEs, it can test
or test and clear their accessed bits according to a bitmap provided
by the caller.

This patchset only applies mmu_notifier_test_clear_young() to MGLRU.
A follow-up patchset will apply it to /proc/PID/pagemap and
/prod/PID/clear_refs.

Evaluation
==========
An existing selftest can quickly demonstrate the effectiveness of
this patchset. On a generic workstation equipped with 64 CPUs and
256GB DRAM:

  $ sudo max_guest_memory_test -c 64 -m 256 -s 256

  MGLRU      run2
  ---------------
  Before    ~600s
  After      ~50s
  Off       ~250s

  kswapd (MGLRU before)
    100.00%  balance_pgdat
      100.00%  shrink_node
        100.00%  shrink_one
          99.97%  try_to_shrink_lruvec
            99.06%  evict_folios
              97.41%  shrink_folio_list
                31.33%  folio_referenced
                  31.06%  rmap_walk_file
                    30.89%  folio_referenced_one
                      20.83%  __mmu_notifier_clear_flush_young
                        20.54%  kvm_mmu_notifier_clear_flush_young
  =>                      19.34%  _raw_write_lock

  kswapd (MGLRU after)
    100.00%  balance_pgdat
      100.00%  shrink_node
        100.00%  shrink_one
          99.97%  try_to_shrink_lruvec
            99.51%  evict_folios
              71.70%  shrink_folio_list
                7.08%  folio_referenced
                  6.78%  rmap_walk_file
                    6.72%  folio_referenced_one
                      5.60%  lru_gen_look_around
  =>                    1.53%  __mmu_notifier_test_clear_young

  kswapd (MGLRU off)
    100.00%  balance_pgdat
      100.00%  shrink_node
        99.92%  shrink_lruvec
          69.95%  shrink_folio_list
            19.35%  folio_referenced
              18.37%  rmap_walk_file
                17.88%  folio_referenced_one
                  13.20%  __mmu_notifier_clear_flush_young
                    11.64%  kvm_mmu_notifier_clear_flush_young
  =>                  9.93%  _raw_write_lock
          26.23%  shrink_active_list
            25.50%  folio_referenced
              25.35%  rmap_walk_file
                25.28%  folio_referenced_one
                  23.87%  __mmu_notifier_clear_flush_young
                    23.69%  kvm_mmu_notifier_clear_flush_young
  =>                  18.98%  _raw_write_lock

Comprehensive benchmarks are coming soon.

Yu Zhao (5):
  mm/kvm: add mmu_notifier_test_clear_young()
  kvm/x86: add kvm_arch_test_clear_young()
  kvm/arm64: add kvm_arch_test_clear_young()
  kvm/powerpc: add kvm_arch_test_clear_young()
  mm: multi-gen LRU: use mmu_notifier_test_clear_young()

 arch/arm64/include/asm/kvm_host.h       |   7 ++
 arch/arm64/include/asm/kvm_pgtable.h    |   8 ++
 arch/arm64/include/asm/stage2_pgtable.h |  43 ++++++++
 arch/arm64/kvm/arm.c                    |   1 +
 arch/arm64/kvm/hyp/pgtable.c            |  51 ++--------
 arch/arm64/kvm/mmu.c                    |  77 +++++++++++++-
 arch/powerpc/include/asm/kvm_host.h     |  18 ++++
 arch/powerpc/include/asm/kvm_ppc.h      |  14 +--
 arch/powerpc/kvm/book3s.c               |   7 ++
 arch/powerpc/kvm/book3s.h               |   2 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c  |  78 ++++++++++++++-
 arch/powerpc/kvm/book3s_hv.c            |  10 +-
 arch/x86/include/asm/kvm_host.h         |  27 +++++
 arch/x86/kvm/mmu/spte.h                 |  12 ---
 arch/x86/kvm/mmu/tdp_mmu.c              |  41 ++++++++
 include/linux/kvm_host.h                |  29 ++++++
 include/linux/mmu_notifier.h            |  40 ++++++++
 include/linux/mmzone.h                  |   6 +-
 mm/mmu_notifier.c                       |  26 +++++
 mm/rmap.c                               |   8 +-
 mm/vmscan.c                             | 127 +++++++++++++++++++++---
 virt/kvm/kvm_main.c                     |  58 +++++++++++
 22 files changed, 593 insertions(+), 97 deletions(-)

-- 
2.39.2.637.g21b0678d19-goog

