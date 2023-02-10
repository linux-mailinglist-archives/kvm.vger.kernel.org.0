Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B9269156E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBJAb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBJAby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:31:54 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109DCF745
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:31:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t13-20020a056902018d00b0074747131938so3476867ybh.12
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFhz51bmO6L+hGiFm94j+Ms1OEhMmWjzfV3eVwNpPHQ=;
        b=W5fHjC8OEI6F3ULmI/sRLPpDuQzOpP13b9ojrI1N7SNPnHQugQG8bdXqm9nPHY58t+
         FMPpMvr446bCY4vMbYK6H4/DnnoTESwtnDC9r/GGGO+KLH+csIULiYqLNKE/x9rKI17n
         7L7m9HFtrDqFe9e9eVcu6wPWDUja8aaKZIuMV7UnGKR3k8bExOQ2sLN5RtFlowKe5bzj
         Td9D61ps5o/YQNsLa773+EpQgjaK8hYzwsWD42tNhhXUY1hdd6rUox9SGtwS2CiOISlv
         KYmrJWlGDHEPsqPBc0iS5PF1i13fzzti8Z/euSG/Bzk8hui8m+j+1z81s6aFRt98H7OU
         SvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFhz51bmO6L+hGiFm94j+Ms1OEhMmWjzfV3eVwNpPHQ=;
        b=dcvhP4TAEb5ea+Kj0spB+Il5arhNhvlJYUuX7fA+Fn+gckteCuLc8POCcaarwDxFoD
         68435xo6t1Cc0Rt5uKa6hZRqNlx5Fayxtbz7C7YnHp8qxI9JKeX6+ggT6/2P4q/+uE6D
         wFWStsn52qxfFq8+aWtzxmwR8e93NO00P7Hq2mrqumNGqiuoxj4OfDt+kRaxxVNfLudv
         ioboImlRLstJBTs5ojXqzsN0818G7bcSMRMMaHL5uMb9dnZxmetLCgHVjRy6SWSEKCJ+
         8ptau5JX7Kl9Iy0t1HeIJVhXpvXBFFdvMkwIjLiP75fSAB4Vgz2qfXqhYSCNtrUjPQkm
         mEuA==
X-Gm-Message-State: AO0yUKW9ShmaJM7e7Ak9LqW1qsiBi72U3RjSYsN2cSQYRlOfyIlxLH+t
        c3p09f+Z2G9K3EMLlM/MwtRLGD1H07w=
X-Google-Smtp-Source: AK7set/WbIU32sB+o3ONbQM2+BM3mjD4Xxlay8lnBQqoWEt2rzjjP+reY0qLfZtf02YgZ+g0CYN1UHu6U0I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e808:0:b0:527:b484:aa14 with SMTP id
 r8-20020a0de808000000b00527b484aa14mr1691127ywe.263.1675989111337; Thu, 09
 Feb 2023 16:31:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-1-seanjc@google.com>
Subject: [PATCH v2 00/21] KVM: x86: Disallow writes to feature MSRs post-KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give feature MSRs that same treatment as CPUID and disallow changing said
MSRs after KVM_RUN.  Fix a tangentially related bug in the vPMU where KVM
leaves the vLBRs enabled after userspace disables the guest's entire vPMU.

The bulk of this series is a rework of the vmx_pmu_caps_test, a.k.a.
the PERF_CAPABILITIES selftests, to expand its coverage.  In addition to
verifying that KVM rejects changes after KVM_RUN, verify other bits beyond
full-width writes and the LBR format.

Note!  There is a sneaky, small, but massive change buried halfway through
this series that will affect all x86 selftests.  Patch

  Verify KVM preserves userspace writes to "durable" MSRs

adds a KVM_GET_MSRS after every KVM_SET_MSRS that writes a single MSR and
expects to succeeded.  The intent is to opportunistically verify that KVM
provides "read what you wrote" for all "durable" MSRs.  The PERF_CAPS test
was manually verifying this behavior, and while it seems kinda gratuitous,
the coverage is quite cheap from both a performance and maintenance cost,
i.e. I can't think of a reason _not_ to do it.

Applies on https://github.com/kvm-x86/linux/tree/next.

Sean Christopherson (21):
  KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple
    lists
  KVM: x86: Add a helper to query whether or not a vCPU has ever run
  KVM: x86: Add macros to track first...last VMX feature MSRs
  KVM: x86: Generate set of VMX feature MSRs using first/last
    definitions
  KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
  KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU has
    run
  KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
  KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after
    KVM_RUN
  KVM: selftests: Move 0/initial value PERF_CAPS checks to dedicated
    sub-test
  KVM: selftests: Assert that full-width PMC writes are supported if
    PDCM=1
  KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
  KVM: selftests: Verify KVM preserves userspace writes to "durable"
    MSRs
  KVM: selftests: Drop now-redundant checks on PERF_CAPABILITIES writes
  KVM: selftests: Test all fungible features in PERF_CAPABILITIES
  KVM: selftests: Test all immutable non-format bits in
    PERF_CAPABILITIES
  KVM: selftests: Expand negative testing of guest writes to
    PERF_CAPABILITIES
  KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
  KVM: selftests: Drop "all done!" printf() from PERF_CAPABILITIES test
  KVM: selftests: Refactor LBR_FMT test to avoid use of separate macro
  KVM: selftests: Add negative testcase for PEBS format in
    PERF_CAPABILITIES
  KVM: selftests: Verify LBRs are disabled if vPMU is disabled

 arch/x86/kvm/cpuid.c                          |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |   2 +-
 arch/x86/kvm/pmu.c                            |   3 +
 arch/x86/kvm/svm/svm.c                        |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  10 +
 arch/x86/kvm/vmx/vmx.c                        |   8 +-
 arch/x86/kvm/x86.c                            | 103 +++++---
 arch/x86/kvm/x86.h                            |  13 +
 .../selftests/kvm/include/x86_64/processor.h  |  41 ++-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 248 ++++++++++++++----
 10 files changed, 342 insertions(+), 90 deletions(-)


base-commit: 62ef199250cd46fb66fe98267137b7f64e0b41b4
-- 
2.39.1.581.gbfd45094c4-goog

