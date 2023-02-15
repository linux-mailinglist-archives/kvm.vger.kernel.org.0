Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CC669733D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbjBOBKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjBOBKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:10:23 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679BA32E5A
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id l20-20020a17090ac59400b00233dc329a18so276847pjt.2
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wBnLaCuaQHue5r3LlxOvH+/hIU83D2TBPNlncWYFxkk=;
        b=h5CKOSYxj8FHzA4Jq/zKj1V84UYqGxOv54HdMWQ218xlsrDNSSgKvHBxYUi8jXQuSS
         w2nvXa6YxMUNLOi2VliP2k7HvE2YvUW5nysT31rxT3/Zfyjq2JVdwn/XWb1ucZevTtKw
         evO0t9hr0X8iDBim/NxETPwRDMi1dc6+wRRUumME/9Adq357FRVcwtBf2qYiq2SzxrWl
         3srBf0VPy+oIxhXsD8mO7vpuphAmS6UnmxRV/I6kOgjcMHbhBCwqzMS67LId045524xo
         FC6dpk481aX7TSB7ShT/0vdB3N3IMmy7ivXgjmhboaz/zK+Ab+ysQPBoTnr+Q/M5iV+C
         MO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBnLaCuaQHue5r3LlxOvH+/hIU83D2TBPNlncWYFxkk=;
        b=OykZUJUYgBo9HvNncFB3LYZtzows0ADSusSZBwlQRkESnt74KgQm8PNbHJzXbLRIJ1
         7A7J0ApNDojy0bcWvgWaLte1+Gj4ca/bMoX075mWYBLnY3f1TiWxG5gKKW9L2GdSZ0Wd
         9FtGc3UELs1w9mfMakXHzy1P2SDKAdNVHRuoDB1/3vFIhqj3/TcP6q+EJKx3uFfXLOX8
         wuB3TRhGVqhrylnW+9Su+S/xZFNr2EaDsiIeHgk4iE00r29LaUYTur0gj4hupsVyYWKK
         BZQorEDxp8a2h7QxsLRMGd45a6/OZ1qFoz55eL+TlpCFTc/VwM58+2qb5fYAwS6Uy908
         VT/w==
X-Gm-Message-State: AO0yUKV8wRf/nIZWpVc7VrKPMvhqujUxay02FK3nhCqqSPwNDKzX81gl
        IiTbEaZLc0Lt0M7WZqh72x9pSmkYYfQ=
X-Google-Smtp-Source: AK7set8THymUnG7147NM6k17ye6v2R5uAUPVC611uPuYPQf6QVtD7lhnMShzANadwVNAeLo9qJKPcbqoOI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d94e:0:b0:4fb:3896:a7d4 with SMTP id
 e14-20020a63d94e000000b004fb3896a7d4mr58640pgj.7.1676423313835; Tue, 14 Feb
 2023 17:08:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:14 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

KVM x86/mmu changes for 6.3.  Not much this time around, Hou's fixes for range-
based TLB flushing are by far the most interesting.  Not that it likely affects
anything, but I'm expecting 6.4 to have quite a bit more MMU stuff.

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.3

for you to fetch changes up to 11b36fe7d4500c8ef73677c087f302fd713101c2:

  KVM: x86/mmu: Use kstrtobool() instead of strtobool() (2023-01-24 10:05:49 -0800)

----------------------------------------------------------------
KVM x86 MMU changes for 6.3:

 - Fix and cleanup the range-based TLB flushing code, used when KVM is
   running on Hyper-V

 - A few one-off cleanups

----------------------------------------------------------------
Christophe JAILLET (1):
      KVM: x86/mmu: Use kstrtobool() instead of strtobool()

Hou Wenlong (6):
      KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
      KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
      KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
      KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
      KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
      KVM: x86/mmu: Cleanup range-based flushing for given page

Lai Jiangshan (2):
      kvm: x86/mmu: Rename SPTE_TDP_AD_ENABLED_MASK to SPTE_TDP_AD_ENABLED
      kvm: x86/mmu: Don't clear write flooding for direct SP

Wei Liu (1):
      KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd()

 arch/x86/kvm/mmu/mmu.c          | 45 +++++++++++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h | 14 +++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 13 +++++-------
 arch/x86/kvm/mmu/spte.c         |  6 +++---
 arch/x86/kvm/mmu/spte.h         | 16 +++++++--------
 arch/x86/kvm/mmu/tdp_iter.c     | 11 +++-------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++----
 7 files changed, 63 insertions(+), 48 deletions(-)
