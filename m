Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B662F5682
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbhANBs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbhANAi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:38:26 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01078C061575
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:34 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id b24so2953748qtt.22
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=M4LPvVO0tM+kRKTIgz3UZuoOLiPTa+F2++4IgfISsGU=;
        b=i7ZE3PF376aaxN+KR1fKdzuL+kCPx/rAU4BbsW6Zsv5hRh80qwO4OekpJ/Q3LNVd+S
         buGljMOzOYmqZJeNpGO+/eE7DBn0+kPAz0VC1jUNpCJzIfth1ks/WwaKXag+n4X0BTu2
         2+o6sUyFYRn/yMn6sLiKJyQy2zSUYTDdkE3MFN3HaP9mK8weIglwU1E0Ta6JTmU9Egod
         dMr1QOE5kLBhWsEfEVYzD/vLA/kexAyTOcKR48vd2e6V2pWr2aAqzj0pKDKaCO4f0neg
         zqYXqyA3VlpudbEv7MQi//44BASoZUlPGuRgBHj2eQs1UAwmRQ8GEk7uPJCbvanhHTQ0
         gKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=M4LPvVO0tM+kRKTIgz3UZuoOLiPTa+F2++4IgfISsGU=;
        b=CRAfSmgLlx7yan0QM/ted6suR64/QglWK0IcWdDxLcDvCFcjhZiWQa9w414uh/qBN8
         QPc2pzX0ZvQp5AYW9PMCYI1khIZGQ0KAV59rsl1aGHTZwMv8vp8vWCUHKzdJ14XTarCG
         rmrKbYGunoVFd2mS2DaC4G6EcxMqzfxgaJEVLokplWxdac7z9Zs0aNtx51dLJDAnkd4f
         49a2vZXcB31BWlJ8IIepL/lKAJV9JDlGrm/+ayWKAcEq/KJdGHaYiSXHrHr/njxoQ5T5
         DkotIb4abSkxaUTGgo6JCyeRQyoWuBLa7sX7RtPYqMfF2prVq6l+Zkb30yaQQ9BEEAAW
         2xCg==
X-Gm-Message-State: AOAM530IfAL6FoIN6wZQ014Ugb76sFQQuTqpG+bhtOJMk/bvWqH9VBvQ
        IKr8jme14FFWvO3K9nIKfIz8rp6wyLE=
X-Google-Smtp-Source: ABdhPJwbERTz6kYhk+OHyi8G3KqDtkL7UYRk6F/n3LLIR83DuPSgMDOE973G2VwAgirc0O4J+unHa1FD5X0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:1b05:: with SMTP id b5mr7077713ybb.298.1610584653170;
 Wed, 13 Jan 2021 16:37:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:36:54 -0800
Message-Id: <20210114003708.3798992-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 00/14] KVM: SVM: Misc SEV cleanups
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

Based on kvm/master, commit 872f36eb0b0f ("KVM: x86: __kvm_vcpu_halt can
be static").

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

Sean Christopherson (14):
  KVM: SVM: Zero out the VMCB array used to track SEV ASID association
  KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
  KVM: SVM: Move SEV module params/variables to sev.c
  x86/cpufeatures: Assign dedicated feature word for AMD mem encryption
  KVM: x86: Override reported SME/SEV feature flags with host mask
  x86/sev: Drop redundant and potentially misleading 'sev_enabled'
  KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control
    variables
  KVM: SVM: Condition sev_enabled and sev_es_enabled on
    CONFIG_KVM_AMD_SEV=y
  KVM: SVM: Unconditionally invoke sev_hardware_teardown()
  KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
  KVM: SVM: Move SEV VMCB tracking allocation to sev.c
  KVM: SVM: Drop redundant svm_sev_enabled() helper
  KVM: SVM: Remove an unnecessary prototype declaration of
    sev_flush_asids()
  KVM: SVM: Skip SEV cache flush if no ASIDs have been used

 arch/x86/include/asm/cpufeature.h             |  7 +-
 arch/x86/include/asm/cpufeatures.h            | 17 +++--
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/mem_encrypt.h            |  1 -
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/kernel/cpu/common.c                  |  3 +
 arch/x86/kernel/cpu/scattered.c               |  5 --
 arch/x86/kvm/cpuid.c                          |  2 +
 arch/x86/kvm/cpuid.h                          |  1 +
 arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++------
 arch/x86/kvm/svm/svm.c                        | 35 +++------
 arch/x86/kvm/svm/svm.h                        |  8 +--
 arch/x86/mm/mem_encrypt.c                     | 12 ++--
 arch/x86/mm/mem_encrypt_identity.c            |  1 -
 .../arch/x86/include/asm/disabled-features.h  |  3 +-
 .../arch/x86/include/asm/required-features.h  |  3 +-
 16 files changed, 96 insertions(+), 79 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

