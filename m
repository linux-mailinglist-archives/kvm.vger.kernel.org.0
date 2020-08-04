Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B123B3C8
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 06:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgHDEUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 00:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgHDEUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 00:20:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D446AC06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 21:20:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l67so13173328ybb.7
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 21:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UAH7GGDxpw0Jk/D++xQ0t+lcW0UcVRC2qykxqWivZiM=;
        b=SRPje/kNJFU7MFZoYvFTbxK52Da+79MbhvNtVCBuEXfYWQjvgGBV93+pbpGsqIOzGE
         W3QfMtwZrfMQWjc7IKqZvn502x38fvzu6bDPywlTAIAZYxwCD3UR/rSgIotM5JgVI5lP
         YbcfND8Jud3NSGMrfZ9llxh3z0M5hS955BWkjCSe8Ay67F5ZCOLu2eaDOnyFqapf+1XS
         pXjktlITU6fSCcwQyYSxfo0x2OEJDDj69kMiC8a7lLrkbprpSVycpY9lhFdlocW0Cowf
         plEDFLlgdI/kP/5HeRZkg+cA01am/t37xMlFq31Gpz+Q+oNKmfwOof7p/86im+vfO59R
         MbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UAH7GGDxpw0Jk/D++xQ0t+lcW0UcVRC2qykxqWivZiM=;
        b=C6AfNvBeR1z+OPELBLHQgNu2Q3Zaw8ZFWOjpEJFFLoXGa/vnUjh8WT33TQEQqANHwv
         QOFjFsao4u1h95fxFrJtEoXGoTx0pTr0Vqjxl9y1hUz22Ds6UCux8L/XUcPlhA0StNmv
         iNvllT+PSZShs0v5HdmRFBeFNlDF83qphtfFiEQe+bSGDZ3XtCwm6AeL3GPS76sGbqkA
         kmpHSnHN5k8jkewEiZlj9iJNgJti1ABqoufDFtE0Um7S+KYWqgRzO9xMkrw/AWSB25Vj
         HR1Jy5gC4zU0Zu3N7I253tpxmXkcAAxJBX9TMdXZftmLLHCcey0eE+GYX/fRmwgj+ryH
         x0dQ==
X-Gm-Message-State: AOAM530CKEpyTi4b+RnWp+/R5x/Tq2sq5A4ldERjyCx90tmWByq8IHiY
        bCI1rofTJkBJF5gb9+dscW5poaNiHxln98Hk
X-Google-Smtp-Source: ABdhPJwLH2zd00jjwKbPMH781SkgiXbKWtsMsMfu9kHcdzFtIWiY5PYRl8PzAg3eF2SFh5vhh+jPp0nkmLe2coxD
X-Received: by 2002:a25:ae59:: with SMTP id g25mr29619447ybe.135.1596514852934;
 Mon, 03 Aug 2020 21:20:52 -0700 (PDT)
Date:   Mon,  3 Aug 2020 21:20:37 -0700
Message-Id: <20200804042043.3592620-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 0/6] Allow userspace to manage MSRs
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

Aaron Lewis (6):
  KVM: x86: Add ioctl for accepting a userspace provided MSR list
  KVM: x86: Add support for exiting to userspace on rdmsr or wrmsr
  KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
  KVM: x86: Ensure the MSR bitmap never clears userspace tracked MSRs
  selftests: kvm: Fix the segment descriptor layout to match the actual
    layout
  selftests: kvm: Add test to exercise userspace MSR list

 Documentation/virt/kvm/api.rst                |  53 +++-
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/svm/svm.c                        |  93 ++++--
 arch/x86/kvm/trace.h                          |  24 ++
 arch/x86/kvm/vmx/nested.c                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  94 +++---
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            | 140 +++++++++
 include/trace/events/kvm.h                    |   2 +-
 include/uapi/linux/kvm.h                      |  12 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  20 +-
 .../selftests/kvm/include/x86_64/processor.h  |  29 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 ++
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  83 ++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 168 ++++++++++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
 .../selftests/kvm/x86_64/userspace_msr_exit.c | 271 ++++++++++++++++++
 19 files changed, 931 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c

-- 
2.28.0.163.g6104cc2f0b6-goog

