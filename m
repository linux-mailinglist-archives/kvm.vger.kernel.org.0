Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD833DCC2
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbhCPSpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbhCPSoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:44:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BCFC061756
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f81so42580147yba.8
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=B7pVfJtAzkpAW4g2RjA9F8Hx9jH9epVTR8buiCtjOQY=;
        b=IdEsbcouCphArUM6+1+XobihwWZocP60WYNQ4DKS/5AwQbJgTBuKe/m843KN+Hlqum
         rvUGFgkyRm4NIHHBX7VbABhnkub0YGM22LDSHVS0FcLSv7J8PMISZ29743QEgPHIZNCT
         abhSfEW+w43DCWYcO0xgndK0b4cMWBmMyDiOQdkkCyAfH1goeopGZynOl3EHl2Rkpy9p
         wF+/W1aDlhCB0Sn+DGpbQbVKPQJDqxiFvk6X0AB8hCvIHlMPEy8230mFyuEXMyQixJqQ
         7/7D8G2Wj+l4t2uLIenENHfL96u+yxGT/WXpw81B1qTL6WeEyRYmdodvqc7Y4SS6qQf7
         VE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=B7pVfJtAzkpAW4g2RjA9F8Hx9jH9epVTR8buiCtjOQY=;
        b=abuOUQllP3tGGhivechZdsTgtPGStY+A04AO9IZIlIsZGC6xwTdLd3dZ/xVFfjM1sJ
         der82pa18pFq4VY5UpF9J9Wy4idQOJamyeNEY1mM3dH90O01U15zfMci+eqG7B7ujZ8r
         QvCaSEuHPT1ZZj+OLZQM5UGeKNdzsyB3DuJ/LM4QmbLS4fzDZ+9uCcCai9RnI9V0gc8S
         DWQRfTk6Bx0hKzm1MX1xMa9xnIQDyq8xm4lFSWJHRrPb+kMHSx4IeMb/tliPuAJ3NU8x
         7fYBHJzYrQZYNXtpLDcU4IoxDtLYxOWQu2gSKu4PEbPA1gJqVNO1Akoz1Zy6Ymb955wP
         3hPw==
X-Gm-Message-State: AOAM533c4+vJXz50qcAmpVjHzn5bA8N3vrjEGu0niuUNU3A8TZ996P3L
        VFP4AJ+xpySfTelzkMAK4wUlmmnsqcs=
X-Google-Smtp-Source: ABdhPJyekYTrFapZGgOnWObiCCFKwGHsizuQQ3hq48wnHVlvZApvgk42WrY4I/0k/TMh9fye+P0QgCtuAgI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
 (user=seanjc job=sendgmr) by 2002:a25:bc41:: with SMTP id d1mr322696ybk.125.1615920285519;
 Tue, 16 Mar 2021 11:44:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Mar 2021 11:44:32 -0700
Message-Id: <20210316184436.2544875-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 0/4] KVM: x86: MSR filtering and related fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the MSR filtering implementation to treat a given filter instance
as an atomic unit, and to properly protect it with SRCU.

Fix two nVMX bugs related to MSR filtering (one directly, one indirectly),
and additional cleanup on top.

Regarding the macro insanity in patch 03, I verified the before and after
binary output for vmx_set_intercept_for_msr() was identical (this required
wrapping "if (msr <= 0x1fff)" with (un)likely in both the before and after
versions; gcc made seemingly random choices without forcing it to favor a
specific branch).

Sean Christopherson (4):
  KVM: x86: Protect userspace MSR filter with SRCU, and set
    atomically-ish
  KVM: nVMX: Handle dynamic MSR intercept toggling
  KVM: VMX: Macrofy the MSR bitmap getters and setters
  KVM: nVMX: Clean up x2APIC MSR handling for L2

 Documentation/virt/kvm/api.rst  |   6 +-
 arch/x86/include/asm/kvm_host.h |  17 ++--
 arch/x86/kvm/vmx/nested.c       | 161 +++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c          |  67 +------------
 arch/x86/kvm/vmx/vmx.h          |  32 +++++++
 arch/x86/kvm/x86.c              | 109 ++++++++++++---------
 6 files changed, 176 insertions(+), 216 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

