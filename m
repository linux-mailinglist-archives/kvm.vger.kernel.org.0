Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6553D3677AB
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhDVDFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhDVDFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A56C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o187-20020a2528c40000b02904e567b4bf7eso18377430ybo.10
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=GEE7iwBMh55ZA3nDYZ+A1ZRgLSr1EBOEkFXO00qCpVE=;
        b=ToZj3C/GTylu2ZEXzHw6Zet8SEH5L2AZLPoCjdVXz5Um1i5TrWh7J4O4GWeXkwJT1i
         eS3152Sp3bLZQghSNsczy50n53Z6Moq1kSC4V+qHEFR3zqbFL1GNnfFCu/fC7qu7SmiO
         4WbCuT1S40C4imNqj0aPs/3p3TEXxGt+6MUJ8GTRN5OYUO9cxcqrWhXP6v9L3QIpe9hL
         2HthvaYgssL7wc0ZXgKSiFBD6zQe94yZkjq/vObkSjNCPQY9bEnWaOKfBokyGWG4qO+S
         yl1pZe5LMmKwGLoVDRonzKh9la1KeX69F0ZRY79EVqoLickgCrCwtiCKRha/31AaB+R5
         efKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=GEE7iwBMh55ZA3nDYZ+A1ZRgLSr1EBOEkFXO00qCpVE=;
        b=J/0B3Oy6vonGC1c7n3BwjXjMnSrvIXOMUuojUQnapmhYEZyD7TTc277RMSojbX/3IK
         lf4sbZl5YuTdHuIuaO7JGqfp1OLE6vAlj7wuxNmHnYR+YzJmpwLpnups8h0ungHtRSzT
         XKyUfyoF+c5HIgXWUihXZQ4rEidoopOOWIZ4W/Z9ak0u/85yKNRSrZQwUFvGmIf7r1iv
         87c1wkfuaSwMmuriLYJw4cvzvVvB7nnBL4RtI+uDK9SbitEg5qDwdHGh44gNuxXfo6ug
         9wQaFTGp0kMqKIDYqBhLQqrCkL39B9aZYXoP7M/tdMPsXTJi2lch1cX4R1pMIW0RF/hP
         KFTQ==
X-Gm-Message-State: AOAM533EmRSw8bfjuv/2rEvaax3hxcndl88P5NCkLxD0a1fbfOyNjvL2
        h3Y0HNvghFAYMkQLbE0WzW6Xf1heupA=
X-Google-Smtp-Source: ABdhPJzoQ1UwbCADUhDub0Tt5++DII0c4YunbBfG4xsHkDLpPNn/keOxoxeFmjQuPfqTIWaAsFrCFga9N8o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:b993:: with SMTP id r19mr1663455ybg.445.1619060708693;
 Wed, 21 Apr 2021 20:05:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:50 -0700
Message-Id: <20210422030504.3488253-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 00/14] x86: MSR_GS_BASE and friends
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix unit tests on 32-bit SVM, and on VMX if/when 32-bit VMX starts
rejecting MSR_GS_BASE accesses.

Fix a variety of semi-related bugs in the MSR test, rework the test to
make the code maintainable, and expand its test coverage.

Sean Christopherson (14):
  x86/cstart: Don't use MSR_GS_BASE in 32-bit boot code
  x86: msr: Exclude GS/FS_BASE MSRs from 32-bit builds
  x86: msr: Advertise GenuineIntel as vendor to play nice with SYSENTER
  x86: msr: Restore original MSR value after writing arbitrary test
    value
  x86: Force the compiler to retrieve exception info from per-cpu area
  x86: msr: Replace spaces with tabs in all of msr.c
  x86: msr: Use ARRAY_SIZE() instead of open coded equivalent
  x86: msr: Use the #defined MSR indices in favor of open coding the
    values
  x86: msr: Drop the explicit expected value
  x86: msr: Add builder macros to define MSR entries
  x86: msr: Pass msr_info instead of doing a lookup at runtime
  x86: msr: Verify 64-bit only MSRs fault on 32-bit hosts
  x86: msr: Test that always-canonical MSRs #GP on non-canonical value
  x86: msr: Verify that EFER.SCE can be written on 32-bit vCPUs

 lib/x86/desc.c      |   6 +-
 lib/x86/processor.h |  24 +++++++
 x86/cstart.S        |  28 ++++++--
 x86/msr.c           | 163 +++++++++++++++++++++-----------------------
 x86/unittests.cfg   |   5 ++
 x86/vmx_tests.c     |   2 -
 6 files changed, 131 insertions(+), 97 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

