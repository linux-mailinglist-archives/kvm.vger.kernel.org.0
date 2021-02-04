Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C3D30E82B
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhBDACM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbhBDACG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:06 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C948AC0613ED
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:26 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id j4so814647qvi.8
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=dJo6kFJmEbDB5bd7UwfejFyX5EAfXMAcoGeIEuOMPVE=;
        b=LXBrWS18jYUSu1XYyoRbNvnW7+RCLFt9G/CkNYIhWsRiIYBFSAclDZCqdSqGABk/f2
         rFYNe7EKHGinwliL71Ix0Qpajzv6M3Uvvthdhhza5TUPgda2gUY07pi2ugWK71AqBkEN
         tWYSxngdvvbj6OQSJHdiIvQNsHn23Iyx8sv+zxtHFLizh8HhHGrtGpw4IoH6+nUzGC1Q
         60Lt74GI5mnekorZnff5V3CExZAcjtTrB4QRh2Gcuezj73SOrNUyLCa2RuRlMWN2etOj
         9PJcOM9fWxcSm6WoraxMMY7TkQYh/UqgvnKR4wGirRIkkdPmywXPfO8fYEQl6ZdspbFt
         HopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=dJo6kFJmEbDB5bd7UwfejFyX5EAfXMAcoGeIEuOMPVE=;
        b=nfmp5/P8hjWpaHIkudc+uhnuGMDSvFB/C0C/drJ0hMRSNRWe2y2fj+FA41wNbM5kww
         lxKQmkyy7r3/ECmGX/Wrrk0SY1OtfGUrvbrYj+5qxeSqjGtsaYhpJdCD4Si9JDYNBByS
         /5Hl1otN+/THXbWrF0O3Cvw8yaglmDyP3uynXiqJyD0i8+XH8unmr0tST2zNd0wAeF//
         YJAlC08pvXUsvoEl8zSN+zde6tleC+Thrhqcilg+OSO8t5nTKA3vFthA01QMJGrroKzm
         Xh+QhBfuvq0pqUm2uOV741/5OfMwIqJBOGIYwXtbQQ5pYDDTspWv4Wy2fAJAJ88q0UEb
         V2mA==
X-Gm-Message-State: AOAM533kpBKP3WS9KwABgKvyzCwyYDi65gBL7DmoMXPELjxl5809qBtn
        ZI+tWPqD1UJ7uBSiG7s59mkXmsou/CY=
X-Google-Smtp-Source: ABdhPJzglTMM62OFGD8AVIT2ZfIrJ1rejTRBMaEUSi4jzKdS5oPhiunBh0RtUHhDNDPsxCPUKCg0dPhtkBc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:ad4:4742:: with SMTP id c2mr5131928qvx.46.1612396885867;
 Wed, 03 Feb 2021 16:01:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:05 -0800
Message-Id: <20210204000117.3303214-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 00/12] KVM: x86: Legal GPA fixes and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to consolidate the GPA reserved bits checks that are scattered
all over KVM, and fix a few bugs in the process.

The original motivation was simply to get rid of all the different open
coded variations of the checks (there were a lot), but this snowballed
into a more ambitious cleanup when I realized common helpers are more or
less required to correctly handle repurposed GPA bits, e.g. SEV's C-bit.

The last two patches (use nested VM-Enter failure tracepoints in SVM)
aren't directly related to the GPA checks, but the conflicts would be
rather messy, so I included them here.

Note, the SEV C-bit changes are technically bug fixes, but getting them in
stable kernels would require backporting this entire pile.  IMO, it's not
worth the effort given that it's extremely unlikely anyone will encounter
the bugs in anything but synthetic negative tests.

Based on kvm/queue, commit 3f87cb8253c3 ("KVM: X86: Expose bus lock debug
exception to guest").

Sean Christopherson (12):
  KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset
  KVM: nSVM: Don't strip host's C-bit from guest's CR3 when reading
    PDPTRs
  KVM: x86: Add a helper to check for a legal GPA
  KVM: x86: Add a helper to handle legal GPA with an alignment
    requirement
  KVM: VMX: Use GPA legality helpers to replace open coded equivalents
  KVM: nSVM: Use common GPA helper to check for illegal CR3
  KVM: x86: SEV: Treat C-bit as legal GPA bit regardless of vCPU mode
  KVM: x86: Use reserved_gpa_bits to calculate reserved PxE bits
  KVM: x86/mmu: Add helper to generate mask of reserved HPA bits
  KVM: x86: Add helper to consolidate "raw" reserved GPA mask
    calculations
  KVM: x86: Move nVMX's consistency check macro to common code
  KVM: nSVM: Trace VM-Enter consistency check failures

 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/cpuid.c            |  20 +++++-
 arch/x86/kvm/cpuid.h            |  24 +++++--
 arch/x86/kvm/mmu/mmu.c          | 110 ++++++++++++++++----------------
 arch/x86/kvm/mtrr.c             |  12 ++--
 arch/x86/kvm/svm/nested.c       |  35 +++++-----
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |  34 +++-------
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  11 ++--
 arch/x86/kvm/x86.h              |   8 +++
 11 files changed, 140 insertions(+), 120 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

