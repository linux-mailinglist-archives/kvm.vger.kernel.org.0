Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680145A7208
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiH3Xzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiH3Xzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:55:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108B82ED5A
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u5-20020a17090a1d4500b001fad7c5f685so5482171pju.9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=cNAoNO+6MPQXzIUTyfZPcKrAHIqJmjqzWZR1Z6VP+DA=;
        b=PwGnLTkwxgwRu42iuFpo2T4D/GwMmfwekg2VvlwAb7npHOMz+Hzh5o4WmTXr+TVSvH
         XBXar62/Wmxclu2ongTjIDAl2+XRg17op8Vn0rVEWX18pht0x5LQPX42NU+OvTdCNd69
         6A10iDWXkt+bqEwQT3+CSBAJvve1CKTXtvcI5zKso6GkcS5/uf4DWVSalVhkUuQvM7Kn
         MirfyTru0S2MNmHbKVwdV+80vqQBlB0RGwkyz9nSepmJR2JYYTicOdYwNsW9KXZ3CslK
         jW9izlI3P6SQ84UN8ktrK5kHQ34xi4xgqd8PzxJ62vHqO9fsjc9sIX1OAEACahiHUyeG
         xY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=cNAoNO+6MPQXzIUTyfZPcKrAHIqJmjqzWZR1Z6VP+DA=;
        b=60OIrVkOKK83V6k2fFlODxaqKoLymP7EBTdvV3aPw3YuxUzibUDQEQNzaneqyNQZ+G
         LH2jpkx9NVU9fwukh5ztRShX+kfcfYNc5klcGBT92EfIca0hhGZ/EFtk2qq2SCGZKxcG
         e+0Ldyammr194Dyvkx8mo7tLx0KVhsm+zGhXjHVMDwJ2wN/q74dNiHwY35ZU4jJ0h8Ax
         6gGcp/+aEO3uSTgjYysHPh9dvkadixT9ZiI3eG0HX+71Qut1IIYV6iMcDtgSlt/sTl/C
         xFb2oL0nXpuqCvL0kaF0Nk9y1yyvpHCW4Y0ZB/S8vVL+jnbzAhUSs7/W8gTyl2hk8T0Y
         WWew==
X-Gm-Message-State: ACgBeo3yrK2QtPQbUJcoDeoT6yvNfeU6g0WlV5rsLVfEgSTpVzB2SYKW
        fja4y5ppexmYCIPYwdcDWW7j6XE2kko=
X-Google-Smtp-Source: AA6agR7UmQaOToCi7P7gZZS6XCA6mVUek/X4135u5cDFfDSpwdCHGnPDTkW5mmZCl/pG/T7a3L2nqFTLu0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:92:b0:174:6796:e3d0 with SMTP id
 o18-20020a170903009200b001746796e3d0mr18176625pld.97.1661903739548; Tue, 30
 Aug 2022 16:55:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:55:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830235537.4004585-1-seanjc@google.com>
Subject: [PATCH v4 0/9] KVM: x86: Apply NX mitigation more precisely
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note, this applies on Yosry's stats series (there's a trivial-but-subtle
conflict in the TDP MMU shadow page accounting).
https://lore.kernel.org/all/20220823004639.2387269-1-yosryahmed@google.com

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

v4:
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

Sean Christopherson (8):
  KVM: x86/mmu: Bug the VM if KVM attempts to double count an NX huge
    page
  KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
  KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
  KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
    MMUs
  KVM: x86/mmu: Document implicit barriers/ordering in TDP MMU shared
    mode
  KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
    SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages
  KVM: x86/mmu: Add helper to convert SPTE value to its shadow page

 arch/x86/include/asm/kvm_host.h |  30 +++++----
 arch/x86/kvm/mmu/mmu.c          | 115 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  33 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
 arch/x86/kvm/mmu/spte.c         |  12 ++++
 arch/x86/kvm/mmu/spte.h         |  17 +++++
 arch/x86/kvm/mmu/tdp_iter.h     |   6 ++
 arch/x86/kvm/mmu/tdp_mmu.c      |  48 +++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 9 files changed, 176 insertions(+), 93 deletions(-)


base-commit: 6f87cacaf4fe95288ac4cbe01a2fadc5d2b8b936
-- 
2.37.2.672.g94769d06f0-goog

