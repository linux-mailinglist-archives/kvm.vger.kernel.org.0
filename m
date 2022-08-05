Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3A58B297
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbiHEXFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238411AbiHEXFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AACB1147A
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f3959ba41so32514917b3.2
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=e2Wr2MwiioMSCLqWtC02430vhbFmKWBtRWtzfefBsQM=;
        b=soiQYBuzvfzJhZrCaJmG97rWO+rQNcOYYYd9Aif7XN/d9aHuOLnpmsWBbNBCS2VcZq
         8VwCDxIM2tKb29vfhcGvgz2e73bJES5UuQRPQUwp+OKnvc8C4EkRPy+iqJU1asN1lqK3
         hW7qJpe/Qsvze8bAQiZLsnUFUiVWkXCYygkcTtSR66CvVmEUInaebi/b56NU0+dUMkaz
         CYB3dIzK/Jp8BOjxk9m+inCnWiPqGIg6SToroEyivHmAG7xh927QbERV4RQPMrVGVqrL
         coLnpCCjTDfjFScGddYRa4OOL9+0bQiMRFKb8nx7uRRPbTtIHfT2MPuY5RvWn9VdT7CQ
         kOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=e2Wr2MwiioMSCLqWtC02430vhbFmKWBtRWtzfefBsQM=;
        b=twBDLrxmuiwwAsXT/Jvo1DP05LTk/sSb5PLcynmKOMRtPswlfehlME31yOeS4HvSRj
         8PS1qmv1Ie6AGcdQJbvP+oRewZFy7ypJuDCcwZcAWBem1Ey7WmALbmjT+iZoiC1VsGac
         XDC57ysOpa8e9NO9dIYqhhBAUBmSKqqobsGiXvB/HDJMP+R0FCXq7ggh+9cb1NUKfHLE
         42gygkIuD0lsUNV1ksMZmXuxiXvcXU9qujWvgLVJKhpbqAnIa6UmU6+WFJr4p65nvPNS
         beCq9g+VJ2P7jr0jhVJIW8UG9axp+42c6LgtAQrE3UNi9Q3paAAUHMX3jlh7K32G8uw2
         vF8w==
X-Gm-Message-State: ACgBeo3VMdz0EL/ds0q6vcvF1X7CMbohfdOIcQBcHWde8mwrYzYL0YOM
        An4sDksucAB6fmgRVPw81zrMULzChKU=
X-Google-Smtp-Source: AA6agR4lozPjZq7A5eAdRjsEine2rVyRuK9dj0Z1TmdZln8C1d5Zi+RXznCNaeEBHpEvNyyBow5i/eE6LLI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bb43:0:b0:31d:d6d8:2d57 with SMTP id
 a3-20020a81bb43000000b0031dd6d82d57mr8104067ywl.236.1659740720440; Fri, 05
 Aug 2022 16:05:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:05 +0000
Message-Id: <20220805230513.148869-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 0/8] KVM: x86: Apply NX mitigation more precisely
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

v3:
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
  KVM: x86/mmu: Bug the VM if KVM attempts to double count an NX huge
    page
  KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
  KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
  KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
    MMUs
  KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
    SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages
  KVM: x86/mmu: Add helper to convert SPTE value to its shadow page

 arch/x86/include/asm/kvm_host.h |  19 ++---
 arch/x86/kvm/mmu/mmu.c          | 123 +++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |  33 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
 arch/x86/kvm/mmu/spte.c         |  12 ++++
 arch/x86/kvm/mmu/spte.h         |  17 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  59 ++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 8 files changed, 178 insertions(+), 93 deletions(-)


base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.559.g78731f0fdb-goog

