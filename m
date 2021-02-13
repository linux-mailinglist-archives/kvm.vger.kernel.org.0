Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6743031A8F8
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhBMAvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhBMAvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:51:02 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BDCC061756
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:22 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f3so1318090qtx.18
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=B4CJaxKFMc+dqDZ9nbv+QUPSRmvNDPY/ZFqR7df/PF0=;
        b=fL8hQzokABhTqNEOqbM/Ylp50TCYwNe7DpnzPcHsJQpyHAU76uRAiMCZ2DbbU+FSjW
         MmlQKPkPEtH8pEGQXpgf1Ei1IYerm5FlXoO9UTRcq7JW9WByA47I8cBVU3uC6+CCVje9
         HHyOJyZk4egFJxonkFQDBfdlHUksI5Gg6RVnRMpDYW3r9a4XWsttsNRZy0qsNqoY710T
         JWkdKnd5tSu5OxtPFfkUXTDAYO7riwxHqiANAgi1Ee6mCgr0VZ32g53B3yxfYmO9kWRO
         Hr3i4Ljcj3cnRsp89Vfqlom1clZD2Z2Xck32fZZTdjCQ4CUZ0mkKR3/4RLu0m9dqgadi
         Xh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=B4CJaxKFMc+dqDZ9nbv+QUPSRmvNDPY/ZFqR7df/PF0=;
        b=Zi4VunQ7551WqbAdF2jxBSQvNwrr/d2aMd8Yc8GKEofU68mnFCG11bUQbfWxXzFXZ4
         TGeeVKwCI+FQk3BKrWvXFE4kWelWnMOsDEICZfdNNfZ78EfcbD7ziRjdWd92argvrBu1
         tsmwg51pCaEgf9q0vVLdDo2zZey8tHP8V6fDZ8v7BcawHPw0p4uQJjFQt6Dxrag3ID1s
         UOFUI9sZMQ83riNbRh0fIhqI1GYpnCmEBS4WheDFCn5JD0+bnXaBmAk/W//crFbgkCap
         pQVE3tWy/QAkyLO2vCwQ+fbCiAMDduzqwyrUHbOLr2IduEJkETXlYMPFEEdJX+RdLvNY
         M/Dg==
X-Gm-Message-State: AOAM530Xy6jPeWyqr9H//QBWKdEzCL+bgIHFlnsuq2Pz7MKCH4jOzrXX
        Y3WLLTjqiIOpDhZH2MIgCSdjg9k+Gbk=
X-Google-Smtp-Source: ABdhPJyudnIPApIy7Nm66X8yqyeGaOrIdBSvHRVveVNyzL3uEudKmIVxnTmngjCy4IoAK3JPNKBaxaAMohI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a05:6214:504:: with SMTP id
 v4mr5165665qvw.58.1613177421259; Fri, 12 Feb 2021 16:50:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:01 -0800
Message-Id: <20210213005015.1651772-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 00/14] KVM: x86/mmu: Dirty logging fixes and improvements
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, this is more or less ready, but on final read-through before
sending I realized it would be a good idea to WARN during VM destruction
if cpu_dirty_logging_count is non-zero.  I wanted to get you this before
the 5.12 window opens in case you want the TDP MMU fixes for 5.12.  I'll
do the above change and retest next week (note, Monday is a US holiday).

On to the code...

This started out as a small tweak to collapsible SPTE zapping in the TDP
MMU, and ended up as a rather large overhaul of CPU dirty logging, a.k.a.
PML.

Four main highlights:

  - Do a more precise check on whether or not a SPTE should be zapped to
    rebuild it as a large page.
  - Disable PML when running L2.  PML is fully emulated for L1 VMMs, thus
    enabling PML in L2 can only hurt and never help.
  - Drop the existing PML kvm_x86_ops.  They're basically trampolines into
    the MMU, and IMO do far more harm than good.
  - Turn on PML only when it's needed instead of setting all dirty bits to
    soft disable PML.

What led me down the rabbit's hole of ripping out the existing PML
kvm_x86_ops isn't really shown here.  Prior to incorporating Makarand's
patch, which allowed for the wholesale remove of setting dirty bits,
I spent a bunch of time poking around the "set dirty bits" code.  My
original changes optimized that path to skip setting dirty bits in the
nested MMU, since the nested MMU relies on write-protection and not PML.
That in turn allowed the TDP MMU zapping to completely skip walking the
rmaps, but doing so based on a bunch of callbacks was a twisted mess.

Happily, those patches got dropped in favor of nuking the code entirely.

Ran selftest and unit tests, and migrated actual VMs on AMD and Intel,
with and without TDP MMU, and with and without EPT.  The AMD system I'm
testing on infinite loops on the reset vector due to a #PF when NPT is
disabled, so that didn't get tested.  That reproduces with kvm/next,
I'll dig into it next week (no idea if it's a KVM or hardware issue).

For actual migration, I ran kvm-unit-tests in L1 along with stress to
hammer memory, and verified migration was effectively blocked until the
stress threads were killed (I didn't feel like figuring out how to
throttle the VM).

Makarand Sonare (1):
  KVM: VMX: Dynamically enable/disable PML based on memslot dirty
    logging

Sean Christopherson (13):
  KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE
    pages
  KVM: x86/mmu: Don't unnecessarily write-protect small pages in TDP MMU
  KVM: x86/mmu: Split out max mapping level calculation to helper
  KVM: x86/mmu: Pass the memslot to the rmap callbacks
  KVM: x86/mmu: Consult max mapping level when zapping collapsible SPTEs
  KVM: nVMX: Disable PML in hardware when running L2
  KVM: x86/mmu: Expand on the comment in
    kvm_vcpu_ad_need_write_protect()
  KVM: x86/mmu: Make dirty log size hook (PML) a value, not a function
  KVM: x86: Move MMU's PML logic to common code
  KVM: x86: Further clarify the logic and comments for toggling log
    dirty
  KVM: x86/mmu: Don't set dirty bits when disabling dirty logging w/ PML
  KVM: x86: Fold "write-protect large" use case into generic
    write-protect
  KVM: x86/mmu: Remove a variety of unnecessary exports

 arch/x86/include/asm/kvm-x86-ops.h |   6 +-
 arch/x86/include/asm/kvm_host.h    |  36 +----
 arch/x86/kvm/mmu/mmu.c             | 203 +++++++++--------------------
 arch/x86/kvm/mmu/mmu_internal.h    |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  66 +---------
 arch/x86/kvm/mmu/tdp_mmu.h         |   3 +-
 arch/x86/kvm/vmx/nested.c          |  34 +++--
 arch/x86/kvm/vmx/vmx.c             |  94 +++++--------
 arch/x86/kvm/vmx/vmx.h             |   2 +
 arch/x86/kvm/x86.c                 | 145 +++++++++++++--------
 10 files changed, 230 insertions(+), 366 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

