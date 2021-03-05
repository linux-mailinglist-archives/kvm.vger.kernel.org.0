Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD8C32DECF
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCEBLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCEBLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CEAC061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a186so712053ybg.1
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=JQj32MjsoOkFQgAa4dRvlgfsPVUAE2bdIFl0c0to9LI=;
        b=Ipbo52HC6kb61zCq1TqaOzcodnmP4A3+oLF5d4EY7YdMqapY7cDqY1zMePWCnXEyiK
         R1+6lFVHDwDin+Y7is5gabYeALsOH8nyaI978z430vam5oafunfX9xUBJK/I0BY0Ml8H
         aGubULvlQP/z3esxtjOv7LtOBkgXOeZ/abgYi3zTng0Ab+ch+nqauKOXWwWr0dpaDt2T
         VQPNcL/WK45ZFrIu0uDIgc2zU+bFQtMv+CMTf6kwNbJD4VdM+pjmi0wpn0buHKZL+RDE
         +76LU02R8rhjccX2ZfbPlIpTselpu5rT4hb3esySS2i8FcwSSFdPPqzmK/CkzmHw/vZy
         ItiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=JQj32MjsoOkFQgAa4dRvlgfsPVUAE2bdIFl0c0to9LI=;
        b=OORLiSxM1j6Bxap7QkR+/vQiWRmcDL9yrGiKUlKp/wAbjlbworRL66R+x1BcaORjPq
         aKi3MnLSof394tnZ7ApzVrInwLWFhkIil5o0kIXYN9vljA7kAIax1ZCxkh+/OX1BJaRz
         XxSyli/4Cg903I41csKAYi+nM5+qOtQIa2sWoXESEYk72NDq3HmeKnEUuQZ4TguphkEv
         KIxwEo0tkCASGfF3cgmllK2rqpoEqg0EiKzgH5hjfeSneCI8Om8jcds0yJ8bFbNrqjTa
         9WFjkFZBfxq1C+TxP0wzQ6O3ULLRbhalnsCA1Pg1ZKkwD8fILNoLsNmhZEsHa7mJzymo
         U//Q==
X-Gm-Message-State: AOAM531rGa6GWs9MKei2IeGnkfiub0FjBVn9Q1ARmPfG3ywSrmzM1rZc
        mNdp7XWrxFf3NGNTxVL9146EsH29SP8=
X-Google-Smtp-Source: ABdhPJyJ+Bog5SRGTPV/+GyISdqN2oduHDRYE/B34rx/eftGyz66dYWdH1dFwn0T+iZKZykB5xNkjJxYkus=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:40d8:: with SMTP id n207mr10059603yba.3.1614906664878;
 Thu, 04 Mar 2021 17:11:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:44 -0800
Message-Id: <20210305011101.3597423-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 00/17] KVM: x86/mmu: Lots of bug fixes
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

Patches 03-09 fix mostly-benign related memory leaks.

Patches 10-12 fix the SME shadow paging bugs, which are also what led me to
the nNPT null pointer bugs.

Patches 13 and 14 fix theoretical bugs with PTP_SWITCH and INVPCID that
I found when auditing flows that touch the MMU context.

Patches 14-17 do additional clean up to hopefully make it harder to
introduce bugs in the future.

On the plus side, I finally understand why KVM supports shadowing 2-level
page tables with 4-level page tables...

Based on kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S exception
fixups out of line").  The null pointer fixes cherry-pick cleanly onto
kvm/master, haven't tried the other bug fixes (I doubt they're worth
backporting even though I tagged 'em with stable).

v2:
  - Collect a review from Ben (did not include his review of patch 03
    since the patch and its direct dependencies were changed).
  - Move pae_root and lm_root allocation to a separate helper to avoid
    sleeping via get_zeroed_page() while holding mmu_lock.
  - Add a patch to grab 'mmu' in a local variable.
  - Remove the BUILD_BUG_ON() in make_mmu_pages_available() since the
    final check wouldn't actually guarnatee 4 pages were "available".
    Instead, add a comment about the limit being soft.

v1:
  - https://lkml.kernel.org/r/20210302184540.2829328-1-seanjc@google.com
 
Sean Christopherson (17):
  KVM: nSVM: Set the shadow root level to the TDP level for nested NPT
  KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with
    64-bit
  KVM: x86/mmu: Capture 'mmu' in a local variable when allocating roots
  KVM: x86/mmu: Allocate the lm_root before allocating PAE roots
  KVM: x86/mmu: Allocate pae_root and lm_root pages in dedicated helper
  KVM: x86/mmu: Ensure MMU pages are available when allocating roots
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
  KVM: x86/mmu: WARN on NULL pae_root or lm_root, or bad shadow root
    level

 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/mmu.h              |   4 +
 arch/x86/kvm/mmu/mmu.c          | 273 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  23 +--
 arch/x86/kvm/svm/svm.c          |   9 +-
 arch/x86/kvm/vmx/nested.c       |   9 +-
 arch/x86/kvm/x86.c              |   2 +-
 7 files changed, 192 insertions(+), 131 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

