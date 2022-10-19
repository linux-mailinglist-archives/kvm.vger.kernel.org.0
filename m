Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3828604DEF
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiJSQ5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJSQ4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:36 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090B01D0649
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:33 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id c4-20020a4a9c44000000b00480da4502b9so2885970ook.15
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY8XEU2fkYE98MWfcMi47y+6Tzv6AnBcVCW4WAVAxZs=;
        b=fVWJHQO1iTUYtO4q3pmDdPVGWF8C/VkhPKaSCksdqw87DP+QbVYQ/D1uq5s9E8NTyM
         dTa/z2un1OlcetlYIE/0vuJ9bmf4ZSHOqS4EhSIukjXDon/1k2yigUL7qePGTrrn0v7h
         zpVk1ki0ET/8ZBMiJGz97h1Bpis+t3+V/1FEEWdhJAM1GKu5aV0ylCHq9UIfYTzmTSqm
         rmWLLInstHjp94OdB5019J/+pnIwEXlcNcJOiLLTcMBSQmbzgPt3a4DEr2HmW6W4OcUn
         jBIhNHhi+fU16/EWupEOzUQWwoZY7RijHxcm7pgbVuK/09IiULzqaR352cCzp7W2LNrJ
         bQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oY8XEU2fkYE98MWfcMi47y+6Tzv6AnBcVCW4WAVAxZs=;
        b=chpihjvNn9zUeOARRsZvWTIWZLOvQMQFn3qN1I3HIbEbe/3z4W3vYJFIgCwbrAPaqE
         BhCVRpDfpsKLo3rPo/p06OhnxjqzsYVkvvNrvpeeoA8VzERGZJPGlnoDuBpRQVVxwB4M
         LF42rReAtmb9Zx1hLAvjdqFTR86meePbrUVeJ+fyjzjeUcVJU3dkNRUksClfTC3aq3xj
         7NiKhbkdXD3tGG/4eAugrDxFu0lPcH32chZ2A+T5pUW0h6Hd8UX+astB6mstcqHFZ0YN
         OxKmvyHPOrADdR2mS0A5BrYh5C8xbHToZq5TfQxW9dyYG9hzPaXlMeNgQLbe5NeH+UcH
         TSbg==
X-Gm-Message-State: ACrzQf1IBu25yd/s5eWEoIrmTdRjc4PVIrlRMGXyn3C0o8r37xGZwiB+
        UIWtIfFF40xCWr23Tf1UqLd9pDsvWyQ=
X-Google-Smtp-Source: AMsMyM6n/I3reJT7orVHRTr5HcoVoECUey8oDxHaW6HZriXy9eaHoIi9nO9JeA79Z4woO84UPW72GPnq64A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3505:b0:20d:ba2e:994b with SMTP id
 ls5-20020a17090b350500b0020dba2e994bmr34572645pjb.46.1666198582055; Wed, 19
 Oct 2022 09:56:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-1-seanjc@google.com>
Subject: [PATCH v6 0/8] KVM: x86: Apply NX mitigation more precisely
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David and Ben, I kept your Reviewed-by for patch 7 even though it's now a
fairly different patch than what you reviewed, as the code generation is
identical.  Holler if you want your review dropped.

Precisely track (via kvm_mmu_page) if a non-huge page is being forced
and use that info to avoid unnecessarily forcing smaller page sizes in
disallowed_hugepage_adjust().

KVM incorrectly assumes that the NX huge page mitigation is the only
scenario where KVM will create a non-leaf page instead of a huge page.
As a result, if the original source of huge page incompatibility goes
away, the NX mitigation is enabled, and KVM encounters an present shadow
page when attempting to install a huge page, KVM will force a smaller page
regardless of whether or not a smaller page is actually necessary to
satisfy the NX huge page mitigation.

Unnecessarily forcing small pages can result in degraded guest performance,
especially on larger VMs.  The bug was originally discovered when testing
dirty log performance, as KVM would leave small pages lying around when
zapping collapsible SPTEs.  That case was indadvertantly fixed by commit
5ba7c4c6d1c7 ("KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
logging"), but other scenarios are still affected, e.g. KVM will not
rebuild a huge page if the mmu_notifier zaps a range of PTEs because the
primary MMU is creating a huge page.

v6:
 - Fold the nx_huge_page_disallowed check in disallowed_hugepage_adjust()
   into the existing if-statement. [Yan]
 - Add a patch to extend the accounting sanity check in recovery to the
   TDP MMU. [Yan]

v5:
 - Drop boneheaded KVM_BUG_ON() GFN aliasing. [Vitaly]
 - Drop incorrect barrier documentation. [Yan]

v4:
 - https://lore.kernel.org/all/20220830235537.4004585-1-seanjc@google.com
 - Collect reviews. [Mingwei]
 - Add comment to document possible_nx_huge_pages. [Mingwei]
 - Drop extra memory barriers. [Paolo]
 - Document ordering providing by TDP SPTE helpers. [Paolo]

v3:
 - https://lore.kernel.org/all/20220805230513.148869-1-seanjc@google.com
 - Bug the VM if KVM attempts to double account a shadow page that
   disallows a NX huge page. [David]
 - Split the rename to separate patch. [Paolo]
 - Rename more NX huge page variables/functions. [David]
 - Combine and tweak the comments about enforcing the NX huge page
   mitigation for non-paging MMUs. [Paolo, David]
 - Call out that the shadow MMU holds mmu_lock for write and doesn't need
   to manual handle memory ordering when accounting NX huge pages. [David]
 - Add a smp_rmb() when unlinking shadow pages in the TDP MMU.
 - Rename spte_to_sp() to spte_to_child_sp(). [David]
 - Collect reviews. [David]
 - Tweak the changelog for the final patch to call out that precise
   accounting addresses real world performance bugs. [Paolo]
 - Reword the changelog for the patch to (almost) always tag disallowed
   NX huge pages, and call out that it doesn't fix the TDP MMU. [David]

v2: Rebase, tweak a changelog accordingly.

v1: https://lore.kernel.org/all/20220409003847.819686-1-seanjc@google.com


Mingwei Zhang (1):
  KVM: x86/mmu: explicitly check nx_hugepage in
    disallowed_hugepage_adjust()

Sean Christopherson (7):
  KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
  KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
  KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
    MMUs
  KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
    SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages
  KVM: x86/mmu: Add helper to convert SPTE value to its shadow page
  KVM: x86/mmu: WARN if TDP MMU SP disallows hugepage after being zapped

 arch/x86/include/asm/kvm_host.h |  30 ++++----
 arch/x86/kvm/mmu/mmu.c          | 122 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  33 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
 arch/x86/kvm/mmu/spte.c         |  12 ++++
 arch/x86/kvm/mmu/spte.h         |  17 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  43 ++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 8 files changed, 170 insertions(+), 95 deletions(-)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.0.413.g74048e4d9e-goog

