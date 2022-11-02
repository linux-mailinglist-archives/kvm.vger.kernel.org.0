Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909B36170DE
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiKBWvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiKBWvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEE9B1C3
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so264297ybc.18
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5VTJpHz7x8u1ScRpoPJIuogZHH0CHqFgGNRlcDYy0A=;
        b=J4kZzEVvdMlUNyeRve9/RH1xz8kLf1E0JOqOsSj39haZF/rcV8DPNRM430BkkUKaSm
         2uAEY2shHCmHB8Beh6V4bGy7MLF7dOuytf/drS6tZypTLuQTyzhu28JeD5+tC2l2m5w+
         zxphxBQpJNJDabjxy/os5V2bWhZxBvgNkyYhWTx4Qc8ON3eyEb6IoUglyIMxDMlfrFbd
         5xucEODO+EDpJVVW5+Px2Lal6f5f6h4jw5lh5PjhhgWxBppQww98Q6oNbtkArj+EW4Ap
         nJvbIrz2TavbXYD9L0w4bZfTBC3W5bPlFt3cEXbVQISCEo1mHKGH/WJQnSoowdINXsGm
         q3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5VTJpHz7x8u1ScRpoPJIuogZHH0CHqFgGNRlcDYy0A=;
        b=pA6sOmcG9nayt5VtcpXPZ0F+44XgEVV5eE8f5IW7WMDlRkxwwtoz0DYfof8DJ5o5V8
         asxM4c7QjNhOiWcocivXmahYYBWs9/nWwDKjUipM1WXnrfiDLWvkLwODYEvEopSNfa/+
         WCvoP99lb3bf6wkJrq9kLEiIy/9VSljadLh4Jtz4iqNsTY/BlbNgQILe4NkMPmexZOXO
         C1MP5s8PGn7waNwyN5gliPKz0EZD+wHbGDGOtzRiidBWLSPVSEvevyTJB+/xYZtz5nXb
         vyUbblP1g/oLXYia3cC8pwgtNLyzbOxoDizRDU+N0VPArfm+7KI5M9rxGmDfC3dOyYgD
         yIjg==
X-Gm-Message-State: ACrzQf1VemWGvuu9dXCvmd3D/4EoYkv+QaEtlIwUalm64MbMSRMFzs9S
        XtodbUuHF+BRsIEhjb3MKizogwMU4g0=
X-Google-Smtp-Source: AMsMyM47f7cs3ZGsyYM9mMbQ3NmDZ1HCSavLk+YrN9+Bh11t2KwGfdl/vau+srVW/IVkZ9rvqcUUPnotPYY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:920e:0:b0:368:25a5:e82d with SMTP id
 j14-20020a81920e000000b0036825a5e82dmr26562274ywg.375.1667429474090; Wed, 02
 Nov 2022 15:51:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 00/27] x86/pmu: Test case optimization,
 fixes and additions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

This series is a big pile of PMU cleanups and enhancements from Like.

The changes are roughly divided into three parts: (1) fixes (2) cleanups,
and (3) new test cases.  The changes are bundled in a mega-series as the
original, separate series was difficult to review/manage due to a number
of dependencies.

There are no major changes in the test logic. The big cleanups are to add
lib/x86/pmu.[c,h] and a global PMU capabilities struct to improve
readability of the code and to hide some AMD vs. Intel details.

Like's v4 was tested on AMD Zen3/4 and Intel ICX/SPR machines, but this
version has only been tested on AMD Zen3 (Milan) and Intel ICX and HSW,
i.e. I haven't tested AMD PMU v2 or anything new in SPR (if there is
anything in SPR?).

Like Xu (22):
  x86/pmu: Add PDCM check before accessing PERF_CAP register
  x86/pmu: Test emulation instructions on full-width counters
  x86/pmu: Pop up FW prefix to avoid out-of-context propagation
  x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
  x86/pmu: Fix printed messages for emulated instruction test
  x86/pmu: Introduce __start_event() to drop all of the manual zeroing
  x86/pmu: Introduce multiple_{one, many}() to improve readability
  x86/pmu: Reset the expected count of the fixed counter 0 when i386
  x86: create pmu group for quick pmu-scope testing
  x86/pmu: Refine info to clarify the current support
  x86/pmu: Update rdpmc testcase to cover #GP path
  x86/pmu: Rename PC_VECTOR to PMI_VECTOR for better readability
  x86/pmu: Add lib/x86/pmu.[c.h] and move common code to header files
  x86/pmu: Snapshot PMU perf_capabilities during BSP initialization
  x86/pmu: Track GP counter and event select base MSRs in pmu_caps
  x86/pmu: Add helper to get fixed counter MSR index
  x86/pmu: Track global status/control/clear MSRs in pmu_caps
  x86: Add tests for Guest Processor Event Based Sampling (PEBS)
  x86/pmu: Add global helpers to cover Intel Arch PMU Version 1
  x86/pmu: Add gp_events pointer to route different event tables
  x86/pmu: Update testcases to cover AMD PMU
  x86/pmu: Add AMD Guest PerfMonV2 testcases

Sean Christopherson (5):
  x86: Add a helper for the BSP's final init sequence common to all
    flavors
  x86/pmu: Snapshot CPUID.0xA PMU capabilities during BSP initialization
  x86/pmu: Drop wrappers that just passthrough pmu_caps fields
  x86/pmu: Reset GP and Fixed counters during pmu_init().
  x86/pmu: Add pmu_caps flag to track if CPU is Intel (versus AMD)

 lib/x86/asm/setup.h |   1 +
 lib/x86/msr.h       |  30 +++
 lib/x86/pmu.c       |  67 +++++++
 lib/x86/pmu.h       | 187 +++++++++++++++++++
 lib/x86/processor.h |  80 ++------
 lib/x86/setup.c     |  13 +-
 x86/Makefile.common |   1 +
 x86/Makefile.x86_64 |   1 +
 x86/cstart.S        |   4 +-
 x86/cstart64.S      |   4 +-
 x86/pmu.c           | 360 ++++++++++++++++++++----------------
 x86/pmu_lbr.c       |  24 +--
 x86/pmu_pebs.c      | 433 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +
 x86/vmx_tests.c     |   1 +
 15 files changed, 975 insertions(+), 241 deletions(-)
 create mode 100644 lib/x86/pmu.c
 create mode 100644 lib/x86/pmu.h
 create mode 100644 x86/pmu_pebs.c


base-commit: 73d9d850f1c2c9f0df321967e67acda0d2c305ea
-- 
2.38.1.431.g37b22c650d-goog

