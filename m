Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A8D248FF4
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHRVQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgHRVQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B146C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r1so23905613ybg.4
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xHJvUF7NEOJ5tKpmZv+XE90DfAQGLbwQcHvn8trP0MA=;
        b=b2eihN35v+GXolKLzSig5M72cFvSDzwmPBpq7YKmDoE1f+Sw85kRT9KHt0EqjDsL1f
         7iTCwRceXHPPvZAm6usjEzwJExedA73fBlxJd5eWtXbwVYxff/obibIqw16f+iK5qGcE
         eFkev0iscwnHP4okkLRkOFJwJo55APJ2AQYatX7xiZExQJGhn+Ktjap1zQ+WmIf+fzr+
         PvrIqdvCQRBixISS9K4i9Ee9js+Cy/TizISdx89ltA1kROp20cRBmMj2snt9WfvwP/q8
         J/MYtSbCy9BBEKSOa4NWA/WEal2Ll0vsV+Io8MkZVYFkLLqS/cMyvkowDEv4EkLm2gk+
         RAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xHJvUF7NEOJ5tKpmZv+XE90DfAQGLbwQcHvn8trP0MA=;
        b=tWeCkhAVMiJ58OxYatu7uxSC8o/aG5+i9luPTnD6dwC6TjjwN2n4TWmF+CtGv/SWYb
         xsL+aMvqgSCYxg0Md9z2a3XwstXz6v5RRPaA3wup6eLQ+rzPBVIijFRdRzU46Ry2UvMh
         xATPFKyGnvkdvCevB4/k7Ca45N1ouFeTSitQUk17fAObT4ZSJXiwTsJNELWJjum3VGXh
         TWVtGbPr+qgz30E4J8j29gSdDxp/Yg8lARpEIXnUeiK5rJmqjrURqpYW0RF8YctDh6KV
         MjuFdI4IEon12Tuyj14CyhCKMnpzw1wXRekDOsmh/40S+XxSBZGoS3CT7olri5venIHT
         S4vw==
X-Gm-Message-State: AOAM530OioehslvoMNKTCb6xz7zEdtu1K9bKEav9jLHvTz2eZL43BBOs
        GXBFMo73R1K3zxHiZADJlt/F6BAfe5+r/Y0p
X-Google-Smtp-Source: ABdhPJwQAAfy6MFTPLF8YYNxLiTXeyLHm/XTBJ2s1i3Z0H6bJPKGWudT5lBXrNi1KDmndAxS9ppz97lR4eYsY2ZN
X-Received: by 2002:a25:cc12:: with SMTP id l18mr30292443ybf.224.1597785375229;
 Tue, 18 Aug 2020 14:16:15 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:22 -0700
Message-Id: <20200818211533.849501-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 00/12] Allow userspace to manage MSRs
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series makes it possible for userspace to manage MSRs by having KVM
forward select MSRs to it when rdmsr and wrmsr are executed in the guest.
Userspace can set this up by calling the ioctl KVM_SET_EXIT_MSRS with a
list of MSRs it wants to manage.  When KVM encounters any of these MSRs
they are forwarded to userspace for processing.  Userspace can then read
from or write to the MSR, or it can also throw a #GP if needed.

This series includes the kernel changes needed to implement this feature
and a test that exercises this behavior.  Also, included is an
implementation of expection handling in selftests, which allows the test
to excercise throwing a #GP.

v1 -> v2:

  - Added support for generic instruction emulator bouncing to userspace when
    rdmsr or wrmsr are called, and userspace has asked to manage the MSR.
    These changes are committed in patch 3, and are based on changes made by
    Alexander Graf <graf@amazon.com>.
  - Added tests to excercise the code paths for em_{rdmsr,wrmsr} and
    emulator_{get,set}_msr.  These changes are committed in patch 8.

v2 -> v3:

  - Added the series by Alexander Graf <graf@amazon.com> to the beginning of
    This series (patches 1-3).  The two have a lot of overlap, so it made sense
    to combine them to simplify merging them both upstream.  Alex's changes
    account for the first 3 commits in this series.  As a result of incorporating
    those changes, commit 05/12 required some refactoring.
  - Split exception handling in selftests into its own commit (patch 09/12).
  - Split the changes to ucall_get() into it's own commit based on Andrew Jones
    suggestion, and added support for aarch64 and s390x.

Aaron Lewis (12):
  KVM: x86: Deflect unknown MSR accesses to user space
  KVM: x86: Introduce allow list for MSR emulation
  KVM: selftests: Add test for user space MSR handling
  KVM: x86: Add ioctl for accepting a userspace provided MSR list
  KVM: x86: Add support for exiting to userspace on rdmsr or wrmsr
  KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
  KVM: x86: Ensure the MSR bitmap never clears userspace tracked MSRs
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Clear uc so UCALL_NONE is being properly reported
  selftests: kvm: Add exception handling to selftests
  selftests: kvm: Add a test to exercise the userspace MSR list
  selftests: kvm: Add emulated rdmsr, wrmsr tests

 Documentation/virt/kvm/api.rst                | 181 +++++++-
 arch/x86/include/asm/kvm_host.h               |  18 +
 arch/x86/include/uapi/asm/kvm.h               |  15 +
 arch/x86/kvm/emulate.c                        |  18 +-
 arch/x86/kvm/svm/svm.c                        |  93 ++--
 arch/x86/kvm/trace.h                          |  24 +
 arch/x86/kvm/vmx/nested.c                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  94 ++--
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            | 379 +++++++++++++++-
 include/trace/events/kvm.h                    |   2 +-
 include/uapi/linux/kvm.h                      |  17 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  21 +-
 .../selftests/kvm/include/x86_64/processor.h  |  29 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 tools/testing/selftests/kvm/lib/s390x/ucall.c |   3 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 168 ++++++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 221 +++++++++
 .../selftests/kvm/x86_64/userspace_msr_exit.c | 421 ++++++++++++++++++
 24 files changed, 1719 insertions(+), 96 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c

-- 
2.28.0.220.ged08abb693-goog

