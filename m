Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F9424116C
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgHJULp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHJULo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:11:44 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848AC061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z16so8632988pfq.7
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Pp8R7nnv+2JoUCzxa3oLmSoFgzBnbxveQGdZZC5Ootg=;
        b=l8xhWFmhR4chfzDKN9bwJ+mXpjBrNrQ5B88HuHRZMAlBLXQnvjCDUGvbvkvCAUmFDE
         5MLQkEflwo1GhQPFT6TSJ5wN2y6G4JxIM1PDsQkWC5ag1jaEOk8kSDYN1Rc0hMod0xAb
         QCOf0vr5RPkGkZUNDJMn4P6hhjpTHTURQI5JPd8DVKlg1Kwlt0DrwV3rTd4UnxpgC7XR
         1LltKnWrirIPSxgBf+nEt+nyAzlM1HCowcdHkRqOMRmMj9FrFpBhdkAYbrCloRUs2DJO
         7Jg5E4Ms+d//uYoFi1GpUIKCSS2G8anDp00BWnr4x0JNyYQxP+kl5DUvGeIwvC7lazNE
         S+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Pp8R7nnv+2JoUCzxa3oLmSoFgzBnbxveQGdZZC5Ootg=;
        b=sSbnbc+avWVX2b4UbHx4gdZFQCkf5FSHF7d9NIfPonfqqiBjpFOY4e+Qv34vxVXXq7
         4THzdFt/t9sbLymToW7VKmsWfAWe1QaZTmGEg+rfjizq01lz42rFc8N50lld+Yia6WD/
         JD6gp9zzIPfCNC8WxUgXQ08wQhOEXIUoZxHRfAMamPtFFpVyfsPbcRDyjjFSBI85O1/t
         rV5CH5zkCFWOAfUnxGf+v7n/zpvlosPyEaee9ArGdT2NoLk/efOBT7QwdTneKOs/GnKZ
         rVqsmi5+7RzmvULuh7M+QLyKryiHJl6b4vIx0sS+FHtCoO40HtMBpZnx0MpXRjCsa+TV
         Nnug==
X-Gm-Message-State: AOAM5331cisKyUQGUyC8c180epuZOFqA/XOBk9ZHKBBi97NOEmm5w/LO
        bT8hsNijvLMLHh5cTudu5rkIv6MvM6KLLzvu
X-Google-Smtp-Source: ABdhPJwBQ7ZZq8p3BRL4vGXBUZdQLy0EbtgySt0gTRV0eUaSco3xPljbGDGG1jbIeHvuR9TCsdOmnSnxgcVlxL9i
X-Received: by 2002:a17:90a:c917:: with SMTP id v23mr1009952pjt.38.1597090303285;
 Mon, 10 Aug 2020 13:11:43 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:26 -0700
Message-Id: <20200810201134.2031613-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 0/8] Allow userspace to manage MSRs
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
  emulator_{get,set}_msr.  These chagnes are committed in patch 8.

Aaron Lewis (8):
  KVM: x86: Add ioctl for accepting a userspace provided MSR list
  KVM: x86: Add support for exiting to userspace on rdmsr or wrmsr
  KVM: x86: Allow em_{rdmsr,wrmsr} to bounce to userspace
  KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
  KVM: x86: Ensure the MSR bitmap never clears userspace tracked MSRs
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Add test to exercise userspace MSR list
  selftests: kvm: Add emulated rdmsr, wrmsr tests

 Documentation/virt/kvm/api.rst                |  53 ++-
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/emulate.c                        |  18 +-
 arch/x86/kvm/svm/svm.c                        |  93 ++--
 arch/x86/kvm/trace.h                          |  24 +
 arch/x86/kvm/vmx/nested.c                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  94 ++--
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            | 174 +++++++-
 include/trace/events/kvm.h                    |   2 +-
 include/uapi/linux/kvm.h                      |  12 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  20 +-
 .../selftests/kvm/include/x86_64/processor.h  |  29 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  83 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 168 ++++++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../selftests/kvm/x86_64/userspace_msr_exit.c | 421 ++++++++++++++++++
 20 files changed, 1129 insertions(+), 94 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c

-- 
2.28.0.236.gb10cc79966-goog

