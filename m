Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0B8D4891
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbfJKTkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 15:40:51 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:53546 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfJKTkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 15:40:51 -0400
Received: by mail-vk1-f201.google.com with SMTP id q5so3823770vkg.20
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 12:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+/jcGRcBsJzyIdBmTS9ExaE2iCkBC76r0L6qvqm8SAE=;
        b=K1PA1JbN3jWoC+Yzscc956ny8igDNYeg4F2KLHAhIuk6Bn6E9cUGr36qYC11FkcQJA
         MMwp10/9lO5c3Ioy9QrQUUPRUPoWiMBe4+UWc2LrOgZ+9HI41fYubVhfemf1p9FZl51r
         iCENgAbmQBStF1Uw5FcJYmsVqH5s76sKHNo7UrkNJ4RQz7kXA8hCdj0tOSLhf2rm1Po8
         FMxdMrYRemjkIhSWjpMbVZ6Lzoi15xgeQtdLsBkC5bSa2SsIcRCsiZrNeafOh4vpP+zz
         q8nxstt7di7/bEa1gWb5QSQviPDgevkyOqE6H/IUevO5Z02SFyy3RTWcReDtn8kn6D50
         wgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+/jcGRcBsJzyIdBmTS9ExaE2iCkBC76r0L6qvqm8SAE=;
        b=cwy36YKrDJRHZDvlx1KVrbvdWpqemYYlwqUi7QdcywxwvU0PLpXx626wIGQXu9UY0D
         w3f5jMUBccYXGHR3WMVLHUnFS0+5Og8iOoiRfkrWX1JaUiZsQmkH9QG0xH4Trsyccde9
         SL8GHgkXx1iuKuIAQQlLG6zIhxteX3DrFtyRsGH8UmRG6ayvmr9x+vqXuDOi1/K7FZ1a
         n08XK/b/AjVZqOQBq3NtPd1wDHOWp2riVBPM5lwyUXNhsiiuCqOKKMUnIzuy8F5u0PXf
         WifvOlqhmRf+Zn+cby4XE4+gOYyHNMlfUPwmbv1+/fM84jqN6a4oFYDl0ePKEeKpbP06
         UlBA==
X-Gm-Message-State: APjAAAVDzcgN/ZYafIX8jjuOZzDsFvRDceDP+G5laRA0itfexmdso2E8
        YxOiMT6PzWorKviXGIG49gpfQv1U5N8J7y3K
X-Google-Smtp-Source: APXvYqznQhZIPEGLrNQYQfiynO7xvd8eM3JxY8LXqIL6TbsAjmBFCoYnAdY9AWu7UvX1slIOiMdKo2G+8e6stcZC
X-Received: by 2002:ab0:6994:: with SMTP id t20mr3240391uaq.124.1570822849812;
 Fri, 11 Oct 2019 12:40:49 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:40:27 -0700
Message-Id: <20191011194032.240572-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v2 0/5] Add support for XSAVES on AMD and unify it with Intel
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unify AMD's and Intel's approach for supporting XSAVES.  To do this
change Intel's approach from using the MSR-load areas to writing
the guest/host values to IA32_XSS on a VM-enter/VM-exit.  Switching to
this strategy allows for a common approach between both AMD and Intel.
Additionally, define svm_xsaves_supported() based on AMD's feedback, and
add IA32_XSS to the emulated_msrs list, in preparation for the day when
the guest IA32_XSS may contain a non-zero value.

This change sets up IA32_XSS to be a non-zero value in the future, which
may happen sooner than later with support for guest CET feature being
added.

v1 -> v2:
 - Add the flag xsaves_enabled to kvm_vcpu_arch to track when XSAVES is
   enabled in the guest, whether or not XSAVES is enumerated in the
   guest CPUID.
 - Remove code that sets the X86_FEATURE_XSAVES bit in the guest CPUID
   which was added in patch "Enumerate XSAVES in guest CPUID when it is
   available to the guest".  As a result we no longer need that patch.
 - Added a comment to kvm_set_msr_common to describe how to save/restore
   PT MSRS without using XSAVES/XRSTORS.
 - Added more comments to the "Add support for XSAVES on AMD" patch.
 - Replaced vcpu_set_msr_expect_result() with _vcpu_set_msr() in the
   test library.

Aaron Lewis (5):
  KVM: VMX: Remove unneeded check for X86_FEATURE_XSAVE
  KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS
  kvm: svm: Add support for XSAVES on AMD
  kvm: x86: Add IA32_XSS to the emulated_msrs list
  kvm: tests: Add test to verify MSR_IA32_XSS

 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm.c                            | 19 +++--
 arch/x86/kvm/vmx/vmx.c                        | 46 ++++--------
 arch/x86/kvm/x86.c                            | 46 ++++++++++--
 arch/x86/kvm/x86.h                            |  4 +-
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  7 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 72 ++++++++++++++++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 70 ++++++++++++++++++
 10 files changed, 210 insertions(+), 57 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xss_msr_test.c

-- 
2.23.0.700.g56cf767bdb-goog

