Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75EE370405
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhD3XZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3XZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:25:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF49BC06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u5-20020a17090a3fc5b029014e545d9a6eso2427493pjm.2
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E9dhF2zRcjBoJyUagXIfZYrtnBYAcfcBi4++x+LfSDA=;
        b=eK+y/OfDIUCfpXL+6G9kEV5E1+nBdAlojXSCo0Mp5ScQGuZNoHJeAGJ4Egi6+RKL9Z
         zrmB1RpeE5bjubElxSbmIx52AhCcA5mvZMUz4IgwpZ29/DFmJ/YBfPh2A8hcZzfJXz6f
         Jstp0DbCQ/ZTzdSUOo6t9IXl1MoylEMA+PsEQozOB/STsbzC2+WdPRqrT2mv34O6rt/W
         SJwpLhRhMlapWReiTXgtI5qQ4PJuDsfZKHC6zgAXsHhTTBiDYqaqzTEexOVHb4vr7RhQ
         dvuiA2rWiTz7zsaXh7XsJwMiaOQxQj3aUnDQ0tVvYybkEIkP73dOpremRPmtcxlH3KA5
         xZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E9dhF2zRcjBoJyUagXIfZYrtnBYAcfcBi4++x+LfSDA=;
        b=q1Qmu9lnaEiDYmi75LWd+PpQpD3NO5vgYGVQlUGZVRjd430/CTl/k+n5HhwK8IDb8F
         vVCg1ywkmX/pMHtZXUX7PpbKszc7LdyGcaC4FrXLvZjK/y4n67VkshrhneKkIKxi3pX3
         jc3DgcksUlahnxqCNHwhF7gC7h2Sapdg/e1RZ/t4uuFSbuh9i6pWc5g+meMTu11OtcVT
         tx14VNGx9mLtTspKnGtZJn7wN3zLwRpH4B9UDr1HNXI5vCoQzhYikmXiDMNMx82BgOyh
         556/hfy0PDrFV2DZ7okuL8DA/kqGK9KhdkYZIN7z4LzaT8OD4c2EguZJYQpZ3OJoXVGo
         JRTQ==
X-Gm-Message-State: AOAM530kti7F65QVehYawBJXxKXPF6okMLZpZlkhNAK1h6u8r4k8to0s
        jtOHVKckx/+Bbq1Ku33X4F+LZ8NV6XOx9Jd9pti0J7x6iH81nB9V5HAqUlQkfDoHdVZg0iQclg1
        Xu2egdztIIgugR+xPNsIvdx+53WWpLAUfdlXv+l5rkFbV/jCS2/LmIWtTgoshM8A=
X-Google-Smtp-Source: ABdhPJx8Zj51M8c+P8fjodtaWXMvKND3bUmTo0cpsuI7daS6L06aMBpeM4573QKUNZ9T/hCuJU9qEZzNtfCIXA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:dacf:b029:ee:ac0e:d0fe with SMTP
 id q15-20020a170902dacfb02900eeac0ed0femr2916269plx.30.1619825050505; Fri, 30
 Apr 2021 16:24:10 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:24:02 -0700
Message-Id: <20210430232408.2707420-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 0/5] KVM: selftests: arm64 exception handling and debug test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

These patches add a debug exception test in aarch64 KVM selftests while
also adding basic exception handling support.

The structure of the exception handling is based on its x86 counterpart.
Tests use the same calls to initialize exception handling and both
architectures allow tests to override the handler for a particular
vector, or (vector, ec) for synchronous exceptions in the arm64 case.

The debug test is similar to x86_64/debug_regs, except that the x86 one
controls the debugging from outside the VM. This proposed arm64 test
controls and handles debug exceptions from the inside.

Thanks,
Ricardo

v1 -> v2:

Addressed comments from Andrew and Marc (thank you very much):
- rename vm_handle_exception in all tests.
- introduce UCALL_UNHANDLED in x86 first.
- move GUEST_ASSERT_EQ to common utils header.
- handle sync and other exceptions separately: use two tables (like
  kvm-unit-tests).
- add two separate functions for installing sync versus other exceptions
- changes in handlers.S: use the same layout as user_pt_regs, treat the
  EL1t vectors as invalid, refactor the vector table creation to not use
  manual numbering, add comments, remove LR from the stored registers.
- changes in debug-exceptions.c: remove unused headers, use the common
  GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
- changes in processor.h: write_sysreg with support for xzr, replace EL1
  with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.

Ricardo Koller (5):
  KVM: selftests: Rename vm_handle_exception
  KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
    reporting
  KVM: selftests: Move GUEST_ASSERT_EQ to utils header
  KVM: selftests: Add exception handling support for aarch64
  KVM: selftests: Add aarch64/debug-exceptions test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  90 ++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +-
 .../selftests/kvm/lib/aarch64/handlers.S      | 130 ++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 124 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  19 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 13 files changed, 611 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.31.1.527.g47e6f16901-goog

