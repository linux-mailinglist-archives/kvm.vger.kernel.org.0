Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0135A4A5478
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 02:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiBABI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 20:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiBABI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 20:08:56 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F990C061714
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:08:55 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z20-20020aa791d4000000b004bd024eaf19so8234158pfa.16
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=o/Ctb5pvdqwrLO0223Se29dTZOlhSsjZ5d2ehUka66I=;
        b=etjsVyvxzc7GGnO//2K7LB7LkTZ1BVRdiBiYBT1C6zYTHsbZrDskSdgDCC3t1iuWzA
         Es73xw3u8AMCXcdAB6FBLEtaXATkKNJfB7voLQt8EAL97SGbadTk3YIlKbLggC6mp6Rw
         bfbPLyUfUSO1Z0VEEU0tKKwmoRgBbapm2RMizqdLtxUyXTivDY4q3UZYY8Sj2OGjZO3g
         scKPmN8PY6hbjMILBLGd1aKaSKKyzZmaoaLhRzw9lJ+GvIAn2XCcLVMtjst/Lp9tK/qG
         SjGnTxEy5+GzBOcMCyzMKFFrAJIM7VeLveT5mwaxT19QtEKA5IXXJn8o89iXxjJBSMn2
         pPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=o/Ctb5pvdqwrLO0223Se29dTZOlhSsjZ5d2ehUka66I=;
        b=f8JxCkV6OnuBHorhr6IEgbnaFvq8Ma71+3kti2pbS+HXbWHyfWGY17FGnmPNxXOcmA
         99CIUe8tQAeS1xPTOjM5qorg8ESeRZuFHIcFAhJ6mpB7rbmS4UNL2LA0XfCMy7dfK4iv
         fs1rIl+VeIA8F2S5K6vlIEXSf3MRwFqwHfLbcSqhw7wHfscpWxC08KP0Takcx1wpljRJ
         qAw0MT3r0bN2MvShsQHdfML5DpGZEntdHwiJp8PYJSc2HggnVmXkjM6hvcJJh7DLbdcY
         /qdKw13AFHfM0jkhv9aVuaYB1Y8iwfm7lqjLQKXIUYvB1wHTB4NlWE0cJeG8nTgb7vmm
         raDg==
X-Gm-Message-State: AOAM531+0kRQ4rQhAcVx/HCVOon8fuPaTftsUREckYHTVvkSGK1cq/DY
        6eC3Nvymcch8/kVId1yIiGGqnzAaTYQ=
X-Google-Smtp-Source: ABdhPJxoV8PyBKTYstfYoP9G1h0gzxSu1PyQr0nSaF8PIuXs5c2bvk3gV2Jkm8KymhboRC/DVy2FtpVEd+k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:17c6:: with SMTP id
 q64mr27331538pja.170.1643677735134; Mon, 31 Jan 2022 17:08:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  1 Feb 2022 01:08:33 +0000
Message-Id: <20220201010838.1494405-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 0/5] x86: uaccess CMPXCHG + KVM bug fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add uaccess macros for doing CMPXCHG on userspace addresses and use the
macros to fix KVM bugs by replacing flawed code that maps memory into the
kernel address space without proper mmu_notifier protection (or with
broken pfn calculations in one case).

Add yet another Kconfig for guarding asm_volatile_goto() to workaround a
clang-13 bug.  I've verified the test passes on gcc versions of arm64,
PPC, RISC-V, and s390x that also pass the CC_HAS_ASM_GOTO_OUTPUT test.

Patches 1-4 are tagged for stable@ as patches 3 and 4 (mostly 3) need a
backportable fix, and doing CMPXCHG on the userspace address is the
simplest fix from a KVM perspective.

Peter Zijlstra (1):
  x86/uaccess: Implement macros for CMPXCHG on user addresses

Sean Christopherson (4):
  Kconfig: Add option for asm goto w/ tied outputs to workaround
    clang-13 bug
  KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits
  KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses
  KVM: x86: Bail to userspace if emulation of atomic user access faults

 arch/x86/include/asm/uaccess.h | 131 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h |  45 +----------
 arch/x86/kvm/x86.c             |  35 ++++-----
 init/Kconfig                   |   4 +
 4 files changed, 150 insertions(+), 65 deletions(-)


base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
-- 
2.35.0.rc2.247.g8bbb082509-goog

