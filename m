Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1E32B59A
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381420AbhCCHSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581641AbhCBTBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:01:23 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773F0C0617A7
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:45:47 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a63so23606144yba.2
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=VYcraVM6eYRTiYr4kgYEHlwMTRpeY9P3GO9XK/0lU2o=;
        b=XFbg/eQuj3Sy+wrWVWQ/Fp31hmbqgCWbVr3sSyOpNvlmHZ/gXL4xREMztarlLPBikO
         HPoy2AlH/OReWCzdcOjt7pVgzlDxwXbuksIXbzRZ6rhG9MT8kDSKwnbzXgxCLhzKHHP5
         7DtdxlwVzq3H2CY1Y0y14427uQfAdM8tJHXKy1WAJkb9Ha8GtPi0aqq8oK2upzGE/6eb
         nhJvJNaF92FanjJnbDPW39/FLt83Os61/NA40ZAoUzGc62wqrCVG93rpfv5a4USTI8VY
         ZO3WnWggf7o2sJXBmkgG+A0wVeSKo7Lsx+uXUIULl5WrxIs97a08bFGloNyLZAWbGx6P
         zZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=VYcraVM6eYRTiYr4kgYEHlwMTRpeY9P3GO9XK/0lU2o=;
        b=rtusKJnCqpBxcXWvSpYFVJPTGlQA6lAPZpi9jx36FqG5tsmTJ5M/DlFM+TUwUmEGxd
         Z95wTr0EI9oMjiYP52ffW6KLQBApPvm29AoIvxEu4FP18Ac9iOVN0jz6Qwc4FsHeiusM
         5hT5JMmwi/pkq3IPK9HSfs9tNs5KxoDT0nMlyLruREi7jja5nF2nqkr9wUxJ9TfYAMyD
         inSzTDK+ytoo88G0GjTggFxvRBD891p1X791kY8+fUjGR0YIH/TRp9JMC4m6bB7JayDt
         VYMJAVnwHEdLgPqB3eLMAl4PyYKAqBjMTtk/5OdLdpv8h9uPJg4rf3FgsYFvN1Wc/Ztj
         e38Q==
X-Gm-Message-State: AOAM5306bO66au40o6yH/GLUp7uEeWLPfZy3ZQS9e1gXKrZqXPHReKXz
        hA3RN0UxKOgBkOjN8F+bkdUABZtQRUo=
X-Google-Smtp-Source: ABdhPJwLBhu8iDVKF68Sp3ys/BcAFOpaKd1kiJyVRW6h90C7425cn05lTdhUKpRdMAmHNFZ0DpqfZSmkYbc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1025:: with SMTP id
 x5mr32938653ybt.21.1614710746747; Tue, 02 Mar 2021 10:45:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:25 -0800
Message-Id: <20210302184540.2829328-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 00/15] KVM: x86/mmu: Lots of bug fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix nested NPT (nSVM) with 32-bit L1 and SME with shadow paging, which
are completely broken.  Opportunistically fix theoretical bugs related to
prematurely reloading/unloading the MMU.

If nNPT is enabled, L1 can crash the host simply by using 32-bit NPT to
trigger a null pointer dereference on pae_root.

SME with shadow paging (including nNPT) fails to set the C-bit in the
shadow pages that don't go through standard MMU flows (PDPTPRs and the
PML4 used by nNPT to shadow legacy NPT).  It also failes to account for
CR3[63:32], and thus the C-bit, being ignored outside of 64-bit mode.

Patches 01 and 02 fix the null pointer bugs.

Patches 03-07 fix mostly-benign related memory leaks.

Patches 08-10 fix the SME shadow paging bugs, which are also what led me to
the nNPT null pointer bugs.

Patches 11 and 12 fix theoretical bugs with PTP_SWITCH and INVPCID that
I found when auditing flows that touch the MMU context.

Patches 13-15 do additional clean up to hopefully make it harder to
introduce bugs in the future.

On the plus side, I finally understand why KVM supports shadowing 2-level
page tables with 4-level page tables...

Based on kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S exception
fixups out of line").  The null pointer fixes cherry-pick cleanly onto
kvm/master, haven't tried the other bug fixes (I doubt they're worth
backporting even though I tagged 'em with stable).

Sean Christopherson (15):
  KVM: nSVM: Set the shadow root level to the TDP level for nested NPT
  KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with
    64-bit
  KVM: x86/mmu: Ensure MMU pages are available when allocating roots
  KVM: x86/mmu: Allocate the lm_root before allocating PAE roots
  KVM: x86/mmu: Check PDPTRs before allocating PAE roots
  KVM: x86/mmu: Fix and unconditionally enable WARNs to detect PAE leaks
  KVM: x86/mmu: Use '0' as the one and only value for an invalid PAE
    root
  KVM: x86/mmu: Set the C-bit in the PDPTRs and LM pseudo-PDPTRs
  KVM: x86/mmu: Mark the PAE roots as decrypted for shadow paging
  KVM: SVM: Don't strip the C-bit from CR2 on #PF interception
  KVM: nVMX: Defer the MMU reload to the normal path on an EPTP switch
  KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
  KVM: x86/mmu: Unexport MMU load/unload functions
  KVM: x86/mmu: Sync roots after MMU load iff load as successful
  KVM: x86/mmu: WARN on NULL pae_root and bad shadow root level

 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/mmu.h              |   4 +
 arch/x86/kvm/mmu/mmu.c          | 209 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  23 +---
 arch/x86/kvm/svm/svm.c          |   9 +-
 arch/x86/kvm/vmx/nested.c       |   9 +-
 arch/x86/kvm/x86.c              |   2 +-
 7 files changed, 142 insertions(+), 117 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

