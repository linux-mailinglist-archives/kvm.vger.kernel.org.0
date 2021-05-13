Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27F637F06E
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 02:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhEMAiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 20:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346474AbhEMAge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 20:36:34 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C9C061361
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:06 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id b24-20020a0cb3d80000b02901e78b82d74aso10153590qvf.20
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q0AXb1y4mM0XDKonC9J0l8yMJqRoopU+CAh1mjQac5o=;
        b=CrI++EttyKCarsBHhj1NIQX1W4Ytekgna+XEc9ugobp0lUmmfIwZzFo1y6719X4mWa
         ooESkvHZZiXHLMJiUzFUa3jQ8is6sMQs66uj87aggctlJoUiOXzdNg5xNeRbPlyxwswt
         nzVEsXMgWAMJ7eFqvvONv0zXveT8YQkG5zoKsobt8vgpdjS4zhdnmkl2Zauylo0xQcRq
         gDQKSzHpD3Yj+drg8Tpqc1PvoJXRwIHYU2O8RVLyZ8vxUEDHKq4X9kQfRwd10ncllZRB
         Br4lXRxacQze9mIF9bm6EbcfXQa4TSUVRhvxdRUsEBFMJK78I1GY7nZKnq2GKDsGUN8x
         I4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q0AXb1y4mM0XDKonC9J0l8yMJqRoopU+CAh1mjQac5o=;
        b=Dovcp8ak+9+BHZOQDOGd6d96uhXtccXbWh3fl9HehMD9mWmpx8MsrEVvbQJCTwjrzm
         +0LHyqJQoUikAwr0WEjDHzb6Ux6xK8cJMvVXT1EfYb23FSPAm4DCz/WN9kqQBkRcxgYE
         BINSX+YxOxHt7PA3RQulF0I10lcMCe4dd2cSVuYldfKI7GoYryU7XXImS3bVMxjJwg2D
         J0VQFwaxpwCfTHMONf3n6DNqFOMRflEjIAIXALYvDUBanO6zbZOTt9S1vwjjh+D4ja7e
         nrMZTl+C6WYp1sboq4piRzCAtm/OfY3OKPNgAiJFRFveRWdZEd6mX7++pJEI+kOtuYyk
         03ng==
X-Gm-Message-State: AOAM532yasSNbiOXkJrEFX9uRDXdJwBZRrVQOCUyFT3Kdag7UcqRhxht
        BO7ILW+LPzBHdCaD/u6j6m4J6rZjdSlEBZq/H9WCIAZykQnw92WEnwrUS0HUqUMSrBT6Qn5zjUY
        TsL+MRSzKpqz6lvBrOMbUQpbCtfa1uTf0oCs2O89tXj9W3I6vBkgmSet6rjkOe/w=
X-Google-Smtp-Source: ABdhPJxhFvkTjka33EvfCorfu2A02LxQsuxtWR2/unbLQbI0MG7cVU2h5YFOzLNjwwnPjheVBuGa9gkKTi3q2Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:ef42:: with SMTP id
 t2mr34819008qvs.48.1620865685059; Wed, 12 May 2021 17:28:05 -0700 (PDT)
Date:   Wed, 12 May 2021 17:27:57 -0700
Message-Id: <20210513002802.3671838-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and debug test
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

v2 -> v3:

Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
the reviews and tests from Eric and Zenghui.
- add missing ISBs after writing into debug registers.
- not store/restore of sp_el0 on exceptions.
- add default handlers for Error and FIQ.
- change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
- use Andrew's suggestion regarding __GUEST_ASSERT modifications
  in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).

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
 .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
 .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
 .../selftests/kvm/include/x86_64/processor.h  |   4 +-
 .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 131 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  22 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 13 files changed, 615 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.31.1.607.g51e8a6a459-goog

