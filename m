Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994135A3261
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbiHZXMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345073AbiHZXMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826A4E0FCF
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dc888dc62so47633627b3.4
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=yrCSotaULNTTVXdK8iDHV7jTejyPhwdaEx0i2dIbtHM=;
        b=bmNYpDLupSkR8/KtS6WUEXRozCi+1NP1UafS+i9UqJw1YOnjvppa+1dnBbAKdfwiN6
         TEiXNA5lmQ+TDRs7Fg5cm226SRrB6ear7NWBzRpGMg98pFREu9DIj3KeQeQWhfstQDw8
         EcavclXmHkuABLDjM99wgSZt1WHqu9fHXrKHVwZp0nj2Vp2adHKdYrftYAAqtzBT8QYM
         zaM4OQZR7uEsROvh0pbhZnccWj7URMNJZHlJ+TtXXEy/zYn1XF1ER7dXK46T/b5XF7Dd
         i0920kpFMg11Qov5NRVK3WfvtD9ha0luTFeOpqt5vLXa6sni5MP2OsNHfa2145d+jCJN
         +j+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=yrCSotaULNTTVXdK8iDHV7jTejyPhwdaEx0i2dIbtHM=;
        b=nY5jG9ycibgmokbMYOTwpbk+mbqS95FMZs4g9uDSKMGFdcln0olHTgPgdYgzbMq0q3
         9KykO2IZQs3YWOcPyGsCWr77jvLgwz88zjpTVVYBuvSTButFMjZOCtv0IgFhOgpHEzP4
         3+O+jK1aPvK24rn70WjpmDcgsVCTh53kiHsI/6dk8YUKWPs1M1dstxLIEEq8wvYTusjc
         uHf9Y1QMgTV3nrfTpg6Wz31FxfNjesH3ag+2F1I2BHaFcjNKHknAVGnw10JmGA3lNy9j
         d3II0L1jEdIpWFwuhyaCo+D8+fHWEA5rBPv14DEMJkGnc9SafqZ1vnOjy3KeQ2SUrbXY
         9x5A==
X-Gm-Message-State: ACgBeo09IVFv+Tq7B0cVTs3oL8h+MA1tb/KqEbeCD/NqEjG6N9hgR42j
        IU2//3wecxOa8uD7BqXQFBlmvrncCC2TXg==
X-Google-Smtp-Source: AA6agR5xxmqnxC39+fH1w3r+qRd0elMT8D7dnC/glCFqqSOs9+RkAEqBvHUx8an4RD8BxqUMDFfinx3JOHBUcQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:e850:0:b0:33d:c65e:db0f with SMTP id
 r77-20020a0de850000000b0033dc65edb0fmr2022158ywe.253.1661555550863; Fri, 26
 Aug 2022 16:12:30 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-1-dmatlack@google.com>
Subject: [PATCH v2 00/10] KVM: x86/mmu: Make tdp_mmu read-only and clean up
 TPD MMU fault handler
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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

This series changes the tdp_mmu module parameter to read-only so that
the TDP MMU can be tracked in a global variable instead of per-VM
state. Then it splits out a separate page fault handler for the TDP MMU
and makes some clean ups along the way.

v2:
 - Make tdp_mmu read-only instead of deleting it entirely [Paolo]
 - Fix 32-bit compilation failures [kernel test robot]

v1: https://lore.kernel.org/kvm/20220815230110.2266741-1-dmatlack@google.com/

Cc: Kai Huang <kai.huang@intel.com>
Cc: Peter Xu <peterx@redhat.com>

David Matlack (10):
  KVM: x86/mmu: Change tdp_mmu to a read-only parameter
  KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
  KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
  KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
  KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON
    handling
  KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
  KVM: x86/mmu: Initialize fault.{gfn,slot} earlier for direct MMUs
  KVM: x86/mmu: Split out TDP MMU page fault handling
  KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU
    faults
  KVM: x86/mmu: Rename __direct_map() to direct_map()

 arch/x86/include/asm/kvm_host.h |   9 --
 arch/x86/kvm/mmu.h              |  11 +-
 arch/x86/kvm/mmu/mmu.c          | 241 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  12 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  11 --
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 7 files changed, 170 insertions(+), 129 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.2.672.g94769d06f0-goog

