Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4E44EE848
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245003AbiDAGic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbiDAGib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D580018BCDC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h8-20020a25e208000000b00628c0565607so1573967ybe.0
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XQvLD2+VCYd8ujZZrqgQBNdJ/k/pqWdcD1uVLP/SETA=;
        b=sH93jOlXhmqZmKDjrsQbSWVdjXjJqk+GKrq1tU8ecmKG9I9YGN1wq9h9X3EHpxMLhD
         rGHw1tW7KIdSh+hYASkRfIqbbyE0JcM8HeORxn1Lcnp+q/b8AoLTx8nQ8po3wxLys0bS
         QlNIaKsfbtMkSxFTSXoyPnY2iDkhlvk6sdhZ48tsByMCAAO72C6WonIqHvDw/hcPNKvQ
         p3w6y5MApQdxoD1UndJkoSG9aogE/xQnXzDkAv9+4hYCo4/6H5qsmer4RSr0q6clYVjY
         sru4JNUxygoVeynQGPA7i7mCBW6s2nhAveOY5ZET2JNArgNKJrmcqp70euMsY5vZizNQ
         SjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=XQvLD2+VCYd8ujZZrqgQBNdJ/k/pqWdcD1uVLP/SETA=;
        b=TWdk9alokpcbCX7+WMd1kNOcMr9E1uXJ66YYi0sp9NTAa+1pBG0mlwZEILCmnExwbn
         dGuEiGBi3nwLkYoZSvJn+rpMX5nKlEfymQmls+vVwSACKUJGnRxdKLY/zgZcVrYKz6Xc
         vISjD5yJt8Fpb3AAecLM5xvIPehY9HMWkE/75cZ/9kh5CzP+TGp6WthqxHAk2E/C5eoU
         v158KNh9GPFV3KhYQuRjhcbMmYPsaZBl6KGW/uXdbJWo7E3BvAlKLPMlZv5bVuagxjbk
         C/ibx29hJqx8f1ylBFixPvY7T6tl6C2VcEdLywIXyGUqgeiwEVHQ84ZBbPWUKWoPuQEL
         N1ow==
X-Gm-Message-State: AOAM5302Q2xS4RWHsPIlxmk8Rx8ZHJh4UaQz+uUwkuZh7XEy4VMCxHgh
        g4BZPPnLwlV8XeXIN36cfS7o/3pwYzjS
X-Google-Smtp-Source: ABdhPJxZ7sZf94C9h1cvuMDEav1FZz68pj0JWMlS+wdg+e54npkSGG3TjrUEs8SuBMuUEoDmw/c8BxsJIPyB
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:cdca:0:b0:633:c810:6ca with SMTP id
 d193-20020a25cdca000000b00633c81006camr7285622ybf.261.1648795002090; Thu, 31
 Mar 2022 23:36:42 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:30 +0000
Message-Id: <20220401063636.2414200-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 0/6] Verify dirty logging works properly with page stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set aims to fix a bug in which KVM incorrectly assumes a large
page as a NX huge page. The bug would prevent guest VM from regaining large
pages and cause performance issue. We fix the bug by explicitly checking
the lpage_disallowed field in the shadow page.  Moreover, to fix the bug
properly for TDP MMU, we integrate two patches from Sean that ensures that
we update lpage_disallowed in shadow page before making spte visible to
guest.

To verify the bug fixed, we use dirty logging as the testing target and
dirty_log_perf_test as the selftest binary. By adding the code to check the
page stats from the per-VM interface, we discovered that VMs could regain
large pages after dirty logging disabled. We also verify the existence of
the bug if running with unpatched kernels.

To make the selftest working properly with per-VM stats interface, we
borrowes two patches come from Ben's series: "[PATCH 00/13] KVM: x86: Add a
cap to disable NX hugepages on a VM" [1].

[1] https://lore.kernel.org/all/20220310164532.1821490-2-bgardon@google.com/T/


v2 -> v3:
 - Update lpage_disallowed before making spte visible [seanjc].
 - Adding tdp_mmu_pages stats [seanjc]
 - update comments in selftest [bgardon]

v2: https://lore.kernel.org/lkml/20220323184915.1335049-1-mizhang@google.com/T/

v1 -> v2:
 - Update the commit message. [dmatlack]
 - Update the comments in patch 3/4 to clarify the motivation. [bgardon]
 - Add another iteration in dirty_log_perf_test to regain pages [bgardon]


Ben Gardon (2):
  KVM: selftests: Dump VM stats in binary stats test
  KVM: selftests: Test reading a single stat

Mingwei Zhang (2):
  KVM: x86/mmu: explicitly check nx_hugepage in
    disallowed_hugepage_adjust()
  selftests: KVM: use page stats to check if dirty logging works
    properly

Sean Christopherson (2):
  KVM: x86/mmu: Set lpage_disallowed in TDP MMU before setting SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages

 arch/x86/include/asm/kvm_host.h               |  11 +-
 arch/x86/kvm/mmu/mmu.c                        |  28 ++-
 arch/x86/kvm/mmu/mmu_internal.h               |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  36 ++--
 .../selftests/kvm/dirty_log_perf_test.c       |  53 +++++
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 196 ++++++++++++++++++
 8 files changed, 303 insertions(+), 31 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

