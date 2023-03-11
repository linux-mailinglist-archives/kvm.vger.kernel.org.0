Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D86B56EE
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCKAqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCKAqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:46:23 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982DC134AE0
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:22 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ip3-20020a17090b314300b00237c16adf30so5064365pjb.5
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495582;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6jB3AffI+mzIeDfH7lhfpRtRWP3b9HQWuNQ7/qAbfQ=;
        b=PCgmNstkwCq+t9aNKV5H7SBwehSEZfL3UigzGdkYxjcn/GyFQzTrk1CFufFxdbBzNh
         i/9gLASWq3yoqqRyGlIvmsN/IkOxukWHCTD0bL1z5sR5yZMZxCqSUMfEWJvKDtmLidEl
         7+ft3ttv03XQlaNbqAW65LJX9HycjJ3vXOThrfLgdQTvLS0HbjzdvhCCuDOEfDfuobVd
         yya3y4FPNyVCRUg9VXkwBBWrVnDVhyzR9x6dUp/GxF1eXl06TKnKHrBzaP9sOJYhqlRX
         Iy1Um+3m635nQ/99QzaZNaDWosrLj4t6aQI/hDkit6g6wwv8USSgRcnKqooXCZZXi8PT
         105Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495582;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6jB3AffI+mzIeDfH7lhfpRtRWP3b9HQWuNQ7/qAbfQ=;
        b=PENh4UvIosH0uO9NU/1gVuvrK2i/jWfQv08Yx3iFeHg9P/w4f+9oQ00lZDTFoihPHs
         vP8GAnDpb1XC4lXSPEwceWoC424u7iAzmVLWBB2WRs7zJidpMbEIvE5f2mPYeZso1qGt
         jOMGApN3VIgaUgzGAHOW98bPmG5afujPxAkexx6ZJGG2g6gSv60xNc88Mq7yMV+t/OPg
         tKCoszE3Wuc5LT4zjaBDnu0ogXcC4M1VpkD5wbU8ysu1XM23fCl5cZoX73VMkrejJYWm
         low3mE9v2XZx9kpQP/6Z0tBaUBOtJiCYOxsFo9VIweIq4UJjKLeYp8rySlPYHbXf7Zow
         hedg==
X-Gm-Message-State: AO0yUKVOb6bXNOsMlnV3wG5+wah5iiDC7lhGn7Sl84azzDwfUhgichoT
        1xq4aueVEjd+lQz5IDaUm3rhY/cinU4=
X-Google-Smtp-Source: AK7set9HsgPKZIqPKHolTOcqUY5PlcbraVBRRAWBqbFVKD7SSeEuap9r42LOXrLMz5nDYOdc1zUKKG0G7pI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1a1f:0:b0:4f2:8281:8afb with SMTP id
 a31-20020a631a1f000000b004f282818afbmr9015323pga.4.1678495582183; Fri, 10 Mar
 2023 16:46:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:45:57 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-1-seanjc@google.com>
Subject: [PATCH v3 00/21] KVM: x86: Disallow writes to feature MSRs post-KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

v3:
 - Collect reviews. [Xiaoyao]
 - Fix the PMU selftests _before_ introducing the breaking KVM change. [Like]
 - Actually use kvm_vcpu_has_run()... [Yu]

v2: https://lore.kernel.org/all/20230210003148.2646712-1-seanjc@google.com

v1: https://lore.kernel.org/all/20220805172945.35412-1-seanjc@google.com

Sean Christopherson (21):
  KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple
    lists
  KVM: x86: Add a helper to query whether or not a vCPU has ever run
  KVM: x86: Add macros to track first...last VMX feature MSRs
  KVM: x86: Generate set of VMX feature MSRs using first/last
    definitions
  KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after
    KVM_RUN
  KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
  KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU has
    run
  KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
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
 arch/x86/kvm/x86.c                            | 102 ++++---
 arch/x86/kvm/x86.h                            |  13 +
 .../selftests/kvm/include/x86_64/processor.h  |  41 ++-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 248 ++++++++++++++----
 10 files changed, 341 insertions(+), 90 deletions(-)


base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.40.0.rc1.284.g88254d51c5-goog

