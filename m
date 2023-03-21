Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53F6C3D41
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCUWA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCUWAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:00:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678343C33
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q30-20020a17090a17a100b0023d376ac2c5so5961819pja.5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436024;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+AyS3qLAngEd+4v3YTH37wX1v3joPIWuJJ+LA8XqHs=;
        b=OCfGn8zxOqlPVCaKyiMVKorp/2xxvaVp8MEemcBkwehLu6OBQQ9iQkUxnqBjEbqH6o
         d+lIg1ZfF8iqlGl+/oAY1ZHHG6tprSUidOrS+W758WOYiDlarYqRbIOgMpJPYYsYfbDp
         FrUfVY5yMmot6hpeZQIQriwxe2YOyEEkDEHMW++rfLLIw/4VonCFYuQ1ylcnJ1S0pnbQ
         jBM+jjEVapJZzmecpFKlBinvT02sW9cDLdkFqDENYVjuuuSXjJL9zzQCeUhRt9P715B1
         t2nTzLE/Q14CUGVc0KMfKmhi+B74I1Ui/XV3l4WXPniITLINHSyGCNbSp0AxpavOQewH
         advw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436024;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+AyS3qLAngEd+4v3YTH37wX1v3joPIWuJJ+LA8XqHs=;
        b=oUsIw+5eMxnd1jWYxPcQWLpOFaLwiCb6u9GIPzU5L+eC5cBwWnJi34ZBMVmPGvjRSX
         cX0jJFWRm930mwmIjN/10q1Dh21PkqvsL8MhWDDdGUZ1DURo2X5twn1+/8Aqq2eMqWRR
         K4WmFuh+UmeBQexMDJE6om6wSgJR0B/az1IbtH2sLtp76WYQR8PghhopRo3feB1oF0gQ
         0iKtyjrS97eEFf+9pcb5bx4Qc+9fWGjlpR4G0ySAMga5/Wx3/AIb0dvSExv2Hv8QZWaD
         6cJ3Dyk64n8CMboCUw1ZfeHSRKOkyhA7mUsGxG+FphVcLd733r/VLH4hN/tHDXR0IK9a
         2y+Q==
X-Gm-Message-State: AO0yUKUX55VLguTFoOtKc4G7n+mGz50gTvYnSu1V1CAl53+NwkqW5X0M
        iAOBYQbwH1i9eqxQuonTv8J8jd/l4/c=
X-Google-Smtp-Source: AK7set9pLa3LCmuE2pzR0ufgMjazp5NKgQ40wShH7pV5gcVAZ3XrSkrbzxL6Rjqw+gAkBWmAsvh4mHmJHFo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:61b0:0:b0:50c:bde:50c7 with SMTP id
 i16-20020a6561b0000000b0050c0bde50c7mr133167pgv.12.1679436023853; Tue, 21 Mar
 2023 15:00:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 15:00:08 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321220021.2119033-1-seanjc@google.com>
Subject: [PATCH v4 00/13] KVM: x86/mmu: Optimize clear dirty log
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a massaged version of Vipin's series to optimize clearing dirty
state in the TDP MMU.  It's basically the same as v3, just spread out over
more patches.  The only meaningful difference in the end is that
clear_dirty_gfn_range() also gets similar treatment in handling Dirty vs.
Writable logic.

Vipin, I'm still planning on applying this for 6.4, but the changes ended
up being a wee bit bigger than I'm comfortable making on the fly, thus the
formal posting.

v4:
- Split patches into more fine-grained chunks.
- Massage changelogs as needed.
- Collect reviews. [David]

v3:
- https://lore.kernel.org/all/20230211014626.3659152-1-vipinsh@google.com
- Tried to do better job at writing commit messages.
- Made kvm_tdp_mmu_clear_spte_bits() similar to the kvm_tdp_mmu_write_spte().
- clear_dirty_pt_masked() evaluates mask for the bit to be cleared outside the
  loop and use that for all of the SPTEs instead of calculating for each SPTE.
- Some naming changes based on the feedbacks.
- Split out the dead code clean from the optimization code.


v2: https://lore.kernel.org/lkml/20230203192822.106773-1-vipinsh@google.com/
- Clear dirty log and age gfn range does not go through
  handle_changed_spte, they handle their SPTE changes locally to improve
  their speed.
- Clear only specific bits atomically when updating SPTEs in clearing
  dirty log and aging gfn range functions.
- Removed tdp_mmu_set_spte_no_[acc_track|dirty_log] APIs.
- Converged all handle_changed_spte related functions to one place.

v1: https://lore.kernel.org/lkml/20230125213857.824959-1-vipinsh@google.com

Vipin Sharma (13):
  KVM: x86/mmu: Add a helper function to check if an SPTE needs atomic
    write
  KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need
    wrprot
  KVM: x86/mmu: Consolidate Dirty vs. Writable clearing logic in TDP MMU
  KVM: x86/mmu: Atomically clear SPTE dirty state in the clear-dirty-log
    flow
  KVM: x86/mmu: Drop access tracking checks when clearing TDP MMU dirty
    bits
  KVM: x86/mmu: Bypass __handle_changed_spte() when clearing TDP MMU
    dirty bits
  KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
  KVM: x86/mmu: Clear only A-bit (if enabled) when aging TDP MMU SPTEs
  KVM: x86/mmu: Drop unnecessary dirty log checks when aging TDP MMU
    SPTEs
  KVM: x86/mmu: Bypass __handle_changed_spte() when aging TDP MMU SPTEs
  KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
  KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
  KVM: x86/mmu: Merge all handle_changed_pte*() functions

 arch/x86/kvm/mmu/tdp_iter.h |  48 +++++---
 arch/x86/kvm/mmu/tdp_mmu.c  | 215 ++++++++++++------------------------
 2 files changed, 106 insertions(+), 157 deletions(-)


base-commit: f3d90f901d18749dca096719540a075f59240051
-- 
2.40.0.rc2.332.ga46443480c-goog

