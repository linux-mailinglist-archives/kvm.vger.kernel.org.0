Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9B85F16D2
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiI3Xs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiI3Xs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:48:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7D61A6E9F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:48:57 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u10-20020a056a00098a00b00543b3eb6416so3568849pfg.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=OzaJ4ScQjHBlz5c/uDjxK7PJx4Q+zqh6kK2FLraX9ZA=;
        b=C6nPwaKmoUkFb7EkGjw3AonYkoFlHEvmOV2lnpmZ3qTW6NENjrART337E+K5QgRB98
         ALrrBw1PmRnD507v/iCpQqL2p/ClkgcquHCKiLcWK/FJSQw7iXuFA0efA+rkNUV59jB0
         z1x9/jAAirUh8kJhrZRFn8PcoKpM9nfWnLULztDulQQ1u6g6X8VYnX9UuyIB0nt0A966
         tMnVM1P+T7ZQD1rAPESB9cJFAnLyUi5IIqG9nE98QVlm9PPnBKrjqeayFSpX2glhaKaV
         NGuRMaYJTioYLYSO1HZa6mmXUvO0RFtyZOE8bYEiZzjP9ZbIjjFYaZNSrRR2zOs+bfgl
         JQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OzaJ4ScQjHBlz5c/uDjxK7PJx4Q+zqh6kK2FLraX9ZA=;
        b=0unVPovy5/6qREvKGD+7l/SA2rUSfoaXMfSebew+IP7BQhAmPN7uZXMRTTzpY6NGKn
         SSHCOPQ/DfQQY2xR5ik14U+lZeOvVF8QUP0f2eTt/YTscH86dWGfu7G3krPw5G0cl92o
         NcFedRoHEG/4GRnhqjfjpvtyx7G8w/N+2fOz9eKzRYLFH1VqAaZiz0d+pdDGxTWMT4pz
         OvdPWLn6BfzFmOgRG9sJvjR+IENbAvKqFJnk8HDG41CaM+n10InewseFVuLZNcIRUKJI
         Tb5gCmwBBk7YBUD8Sv5/WNGetw72hZtSqljdk0x/K4IYlo6Rz+j6kI5t2A2JTHhnz8U8
         sogQ==
X-Gm-Message-State: ACrzQf2w92QNN3iJq4LzPm4LKsqOj9RAYBT2oTKRjS5JVwUTBXbo2v0X
        RjNPG+55ec461TsJAWoLHDlkH7LcyfU=
X-Google-Smtp-Source: AMsMyM4cqtjQeAm7Lv9wtlAxQqbTRX3VF7xjr7jX+m6h+yKrtK2RQyHWKVm8y2HLjXu2AdUaY9XRVDM6kWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP id
 d6-20020a17090acd0600b00203ae0e6a21mr500783pju.0.1664581736975; Fri, 30 Sep
 2022 16:48:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:48:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930234854.1739690-1-seanjc@google.com>
Subject: [PATCH v5 0/7] KVM: x86: Apply NX mitigation more precisely
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Sean Christopherson (6):
  KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
  KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
  KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
    MMUs
  KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
    SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages
  KVM: x86/mmu: Add helper to convert SPTE value to its shadow page

 arch/x86/include/asm/kvm_host.h |  30 ++++----
 arch/x86/kvm/mmu/mmu.c          | 123 +++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |  33 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
 arch/x86/kvm/mmu/spte.c         |  12 ++++
 arch/x86/kvm/mmu/spte.h         |  17 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  43 ++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 8 files changed, 173 insertions(+), 93 deletions(-)


base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.38.0.rc1.362.ged0d419d3c-goog
