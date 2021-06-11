Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9653A3928
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFKBMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFKBMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:12:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D60CC061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:25 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s5-20020aa78d450000b02902ace63a7e93so2242830pfe.8
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DuE/A6+ZG6NpgPPBvCfV9lHnuaMSkQcZ44Y2TiheBkQ=;
        b=F22a2+85RJnBkVWxq5Kh8Pdmyio3mW2wK7/olsitxBFoTGLNxInLljycY77yuxSItw
         C55BMRBGnhzYXmhmmpgf78DEkdwnbmvuEio7gIpkRA8/NM9jgV0TmCgNKdVzwlqWQL5C
         bIQvuxjob1rTEUHi+proCfcxriz4axUWbDqOIJJ7Fj5uoCH6Blq1JuMkuoZgKMXevK8c
         TT55V1sF+fny8XLEs5cMXkcmkqE5JZIEAcoP7XhhUFA5tvJ0HgXKPezXS6P1ofxSL8DU
         uRXsypP+UdiiUtrDI84K10gS0SDSNv51N4qpxMI62Ur1MOwQ9qCj7FqW779z6e+hLCAr
         eTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DuE/A6+ZG6NpgPPBvCfV9lHnuaMSkQcZ44Y2TiheBkQ=;
        b=rh9UC+W0SeZc9Ltyo0sXgv4/dsHKF+BYIfOlvIqU+QIFvE21fTJd431ARnGFXb2xMb
         p5xWqLTAmEP9awuDqnvtP8xBNxh8O4+siNnj5F3Jvu/3QGpcQWOtJv5mbPnCuOL6oZ/c
         N0n7aldNmtZHJow98CPfnHDFLGYnUHOGqwzatutsM1fP3a7CKs75nOsedWgStRgm8Bqg
         e2ergsKh+TjHO234zbV7+CWxDQth/hxohxPXdJzL5+JlTfsxI2MXlzEVh1kwjMVy9oZs
         BFhNZUBW1YHJpkgcFFzgvnlyjwNRyAojOObW30eMOcfPmYgxvcGFIHm7Q8e5Rg6cdFan
         LgSA==
X-Gm-Message-State: AOAM531+YFr9cyr4a4qeIBfBj+Z845vl/a25AB3goRQ0j3+KLASsszn0
        SpGsX55nPUir/FIi6rUALLEymjN0awDIWFgaJWs3ZeLNoT44KFAgPGNsnaGJ1L6mBFea9BR9f5s
        5SqRJ0Cbm9kBAsjSOcIfYUpHqb+rKrPQfH24oxw61/m+J2EHcqNKQI9gBp++Axjc=
X-Google-Smtp-Source: ABdhPJzc1OUhWq39DEGvv1Q74X5Z4DbZEnAcBKCVfLNVtFdyoXJi3s+G+XZTARgAKKJiJiuDplex0QiX0AP9vQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP
 id u4-20020a622e040000b02902db4c99614fmr5640609pfu.47.1623373823732; Thu, 10
 Jun 2021 18:10:23 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:14 -0700
Message-Id: <20210611011020.3420067-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and debug test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
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

v3 -> v4:

V3 was dropped because it was breaking x86 selftests builds (reported by
the kernel test robot).
- rename vm_handle_exception to vm_install_sync_handler instead of
  vm_install_vector_handlers. [Sean]
- use a single level of routing for exception handling. [Sean]
- fix issue in x86_64/sync_regs_test when switching to ucalls for unhandled
  exceptions reporting.

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

Ricardo Koller (6):
  KVM: selftests: Rename vm_handle_exception
  KVM: selftests: Complete x86_64/sync_regs_test ucall
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
 .../selftests/kvm/lib/aarch64/handlers.S      | 126 +++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |  97 +++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  23 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   4 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |   7 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 15 files changed, 592 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.32.0.272.g935e593368-goog

