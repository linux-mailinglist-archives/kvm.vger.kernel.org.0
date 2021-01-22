Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06607300D9F
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbhAVUXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbhAVUWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:22:32 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2E9C06174A
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:21:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so6563484ybs.8
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7RwhFYrcnoJXpobXbjPYpOWtvrgfjh0dgKM1o8v6SyQ=;
        b=k0MOtVqkrh587ap4u1TL5jVh9BDawHezCrrcAPdLUOfvQrD7yVpvrHnLcjIrkDKLDD
         u/BK0AYcLMIVZPDmGODEvPHpzZFKWVCQFfIGSvK6sWFS0/eHFOX9EaaPIHS0tYn/3ty0
         ZCUTO0P2vcm5JaV1yrsy7AfkhE9ZG88eick69Yc/WtIoPkwy+Sg9vZNe118M9qJ7Q2bf
         5tumrVEz0bJjWuj8xM1+BGwcOezUqZyqqGvI2Lcb+Ejun+SbrtNY9zxgrx8z1SX/Wt0Y
         Z4F42J6Jt4ZlGpGp0kAG3RblCAwGm+9BUDugBQ8xEDOGvVb0mT0f1WuE6cf/moAztY0x
         xaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=7RwhFYrcnoJXpobXbjPYpOWtvrgfjh0dgKM1o8v6SyQ=;
        b=J7VbwFRAesYB6fBckNuk5VhREo24tgt3bmvNX3qhwPXbK8RKHQUCxqXm/3Z7uvRKJB
         bzrx/a/SiaXIQtofvjO6puLrgk3DBkPwMIgJKPP4YhcUXqyGwf06o3bkPR7B/DJ+x259
         EwRLwZ9rdznlZP1ASTz3whkSpwpU8ZRTKXn9T4XrOr+vxnIslL+KnAG4Z+gJC9/KKfbx
         MoYa7bwYOABof31YW/yH+oBg38iFGK02pR+SoxuX1Tiu99Y5a2Ygc2ToT+uPVqmUEjM0
         vjKiXjyADMleL3ZRZToGxx3wR4zNn41vty5Wx3kc2zbLm0tsDF068UHERzb/tb+Exmm0
         CuTw==
X-Gm-Message-State: AOAM5330mU5f3q9S6UrE6E+g9RUflr485hAvLy+Ky0inbG15iIYovNHW
        jSIwaqBs8aSzjE+XcFvpnzioNw6xjsE=
X-Google-Smtp-Source: ABdhPJwcgryrk4tZExGjyr0534evimoJtjIFiSLe5u1LnX0hMunee/z+PGQjJP3z0dF1B9wvxTPVgd7CI0s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:e90e:: with SMTP id n14mr8872967ybd.185.1611346911657;
 Fri, 22 Jan 2021 12:21:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:31 -0800
Message-Id: <20210122202144.2756381-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 00/13] KVM: SVM: Misc SEV cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor bug fixes and refactorings of SEV related code, mainly to clean up
the KVM code for tracking whether or not SEV and SEV-ES are enabled.  E.g.
KVM has both sev_es and svm_sev_enabled(), and a global 'sev' flag while
also using 'sev' as a local variable in several places.

Based on v5.11-rc3.

v3:
 - Drop two patches: add a dedicated feature word for CPUID_0x8000001F,
   and use the new word to mask host CPUID in KVM.  I'll send these as a
   separate mini-series so that Boris can take them through tip.
 - Add a patch to remove dependency on
   CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT. [Boris / Paolo]
 - Use kcalloc() instead of an open-coded equivalent. [Tom]
 - Nullify sev_asid_bitmap when freeing it during setup. [Tom]
 - Add a comment in sev_hardware_teardown() to document why it's safe to
   query the ASID bitmap without taking the lock. [Tom]
 - Collect reviews. [Tom and Brijesh]
v2:
 - Remove the kernel's sev_enabled instead of renaming it to sev_guest.
 - Fix various build issues. [Tom]
 - Remove stable tag from the patch to free sev_asid_bitmap.  Keeping the
   bitmap on failure is truly only a leak once svm_sev_enabled() is
   dropped later in the series.  It's still arguably a fix since KVM will
   unnecessarily keep memory, but it's not stable material. [Tom]
 - Collect one Ack. [Tom]

v1:
 - https://lkml.kernel.org/r/20210109004714.1341275-1-seanjc@google.com


Sean Christopherson (13):
  KVM: SVM: Zero out the VMCB array used to track SEV ASID association
  KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
  KVM: SVM: Move SEV module params/variables to sev.c
  x86/sev: Drop redundant and potentially misleading 'sev_enabled'
  KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control
    variables
  KVM: SVM: Condition sev_enabled and sev_es_enabled on
    CONFIG_KVM_AMD_SEV=y
  KVM: SVM: Enable SEV/SEV-ES functionality by default (when supported)
  KVM: SVM: Unconditionally invoke sev_hardware_teardown()
  KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
  KVM: SVM: Move SEV VMCB tracking allocation to sev.c
  KVM: SVM: Drop redundant svm_sev_enabled() helper
  KVM: SVM: Remove an unnecessary prototype declaration of
    sev_flush_asids()
  KVM: SVM: Skip SEV cache flush if no ASIDs have been used

 arch/x86/include/asm/mem_encrypt.h |  1 -
 arch/x86/kvm/svm/sev.c             | 72 +++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c             | 35 +++++----------
 arch/x86/kvm/svm/svm.h             |  8 +---
 arch/x86/mm/mem_encrypt.c          | 12 +++--
 arch/x86/mm/mem_encrypt_identity.c |  1 -
 6 files changed, 67 insertions(+), 62 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

