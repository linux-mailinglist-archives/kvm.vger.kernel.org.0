Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCDB4E3314
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiCUWt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiCUWta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4712C67C
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mq8-20020a17090b380800b001c6f8962e95so348180pjb.1
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=duWOk9J5Rn3bjagoFq9i2kDyIyZnSP5TRc8u4qHhNfc=;
        b=Pbm8QX/YyzkKPwPzsQYphCPvViUlrGZ4HzV1Z42L6Cf/bmYgIou7g0C9QUdXKWoy+7
         DjYM69lY6J38IsyXQke7TIIR5Lr1K5waEfqw8b2N1GXPLRd4TiDMI41YBW4iAv1F1dLI
         CyHmC9cUT5wQhKKT/iHDgPjDVqpr/U0PL1+4RkVl+HNbk45Wc5pp2AGcDP96NbVSdSTo
         ps9qYmkf9aTdutmz15SjIpucdkZjOl05F+Nj+c6meZGiY/oxe8o/R65JNC01KiGnsiUi
         wpJgG0LIISGTBMU0aFmwqmk2Q8yvJcUM0mv/VSxoTVzsnXGDxuu1MKLg8+9jEUZs2bhW
         UUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=duWOk9J5Rn3bjagoFq9i2kDyIyZnSP5TRc8u4qHhNfc=;
        b=UWqRSvEa/wBz6ACPSesFixg2ptYPYrqclcuAdDkOF5vf+SFd/VVpy6Y4HGRx2fYndQ
         pOwzQnIwhVAjEo6G/540yQm5ijVVZUBm4rUR6BXfsFBDSpffjz2kJChMleC8VXnP8YvG
         ZC6tveyRr6Rakj06ix2YMnMoLXJ5tnPkZSmmijPqgFpnkrsqSmTUFKFjPMLou+fAiZPV
         BVBwLQj8fYBjk2k4siBcsbeyNdZtwceMzrmnBqmVKYbootDhllB+yC7sNZCNULq6Syw9
         4hxoVB+b6pDV7ypaPOAPjM6enpzfUBcmQXOM38bqRjy/sbsnfeBuCw8m/Xgrbf7nEuD9
         CXOg==
X-Gm-Message-State: AOAM532yaJXLi8gxnRL3SUAYjKz7WgxltAemog8NPtsdA13mEGK+d3XL
        sPyCDye1zFJciJDPJ137Yk/NmJdFvbPC
X-Google-Smtp-Source: ABdhPJytHGDouKoHJ9pRLVFB3Z6mEk4NzNC1Z7XTnWfFcOGBMjMjihWhYrp1JPCBQ/kOlhRedUpIllb6zEum
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:902:ea09:b0:154:4af3:bb77 with SMTP id
 s9-20020a170902ea0900b001544af3bb77mr9669730plg.4.1647902640776; Mon, 21 Mar
 2022 15:44:00 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:49 -0700
Message-Id: <20220321224358.1305530-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 0/9] KVM: x86/MMU: Optimize disabling dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Currently disabling dirty logging with the TDP MMU is extremely slow.
On a 96 vCPU / 96G VM it takes ~256 seconds to disable dirty logging
with the TDP MMU, as opposed to ~4 seconds with the legacy MMU. This
series optimizes TLB flushes and introduces in-place large page
promotion, to bring the disable dirty log time down to ~3 seconds.

Testing:
Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
series introduced no new failures.

Performance:

Without this series, TDP MMU:
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 4.972184425s
Enabling dirty logging time: 0.001943807s

Iteration 1 dirty memory time: 0.061862112s
Iteration 1 get dirty log time: 0.001416413s
Iteration 1 clear dirty log time: 1.417428057s
Iteration 2 dirty memory time: 0.664103656s
Iteration 2 get dirty log time: 0.000676724s
Iteration 2 clear dirty log time: 1.149387201s
Disabling dirty logging time: 256.682188868s
Get dirty log over 2 iterations took 0.002093137s. (Avg 0.001046568s/iteration)
Clear dirty log over 2 iterations took 2.566815258s. (Avg 1.283407629s/iteration)

Without this series, Legacy MMU:
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 4.892940915s
Enabling dirty logging time: 0.001864603s

Iteration 1 dirty memory time: 0.060490391s
Iteration 1 get dirty log time: 0.001416277s
Iteration 1 clear dirty log time: 0.323548614s
Iteration 2 dirty memory time: 29.217064826s
Iteration 2 get dirty log time: 0.000696202s
Iteration 2 clear dirty log time: 0.907089084s
Disabling dirty logging time: 4.246216551s
Get dirty log over 2 iterations took 0.002112479s. (Avg 0.001056239s/iteration)
Clear dirty log over 2 iterations took 1.230637698s. (Avg 0.615318849s/iteration)

With this series, TDP MMU:
(Updated since RFC. Pulling out patches 1-4 could have a performance impact.)
> ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
Test iterations: 2
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fe7c0000000
Populate memory time: 4.878083336s
Enabling dirty logging time: 0.001874340s

Iteration 1 dirty memory time: 0.054867383s
Iteration 1 get dirty log time: 0.001368377s
Iteration 1 clear dirty log time: 1.406960856s
Iteration 2 dirty memory time: 0.679301083s
Iteration 2 get dirty log time: 0.000662905s
Iteration 2 clear dirty log time: 1.138263359s
Disabling dirty logging time: 3.169381810s
Get dirty log over 2 iterations took 0.002031282s. (Avg 0.001015641s/iteration)
Clear dirty log over 2 iterations took 2.545224215s. (Avg 1.272612107s/iteration)

Patch breakdown:
Patches 1-4 remove the need for a vCPU pointer to make_spte
Patches 5-8 are small refactors in preparation for in-place lpage promotion
Patch 9 implements in-place largepage promotion when disabling dirty logging

Changelog:
RFC -> v1:
	Dropped the first 4 patches from the series. Patch 1 was sent
	separately, patches 2-4 will be taken over by Sean Christopherson.
	Incorporated David Matlack's Reviewed-by.
v1 -> v2:
	Several patches were queued and dropped from this revision.
	Incorporated feedback from Peter Xu on the last patch in the series.
	Refreshed performance data
		Between versions 1 and 2 of this series, disable time without
		the TDP MMU went from 45s to 256, a major regression. I was
		testing on a skylake before and haswell this time, but that
		does not explain the huge performance loss.

Ben Gardon (9):
  KVM: x86/mmu: Move implementation of make_spte to a helper
  KVM: x86/mmu: Factor mt_mask out of __make_spte
  KVM: x86/mmu: Factor shadow_zero_check out of __make_spte
  KVM: x86/mmu: Replace vcpu argument with kvm pointer in make_spte
  KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
  KVM: x86/mmu: Factor out part of vmx_get_mt_mask which does not depend
    on vcpu
  KVM: x86/mmu: Add try_get_mt_mask to x86_ops
  KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
  KVM: x86/mmu: Promote pages in-place when disabling dirty logging

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +
 arch/x86/kvm/mmu/mmu.c             | 21 +++++----
 arch/x86/kvm/mmu/mmu_internal.h    |  6 +++
 arch/x86/kvm/mmu/spte.c            | 39 +++++++++++-----
 arch/x86/kvm/mmu/spte.h            |  6 +++
 arch/x86/kvm/mmu/tdp_mmu.c         | 73 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c             |  9 ++++
 arch/x86/kvm/vmx/vmx.c             | 25 ++++++++--
 9 files changed, 155 insertions(+), 27 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

