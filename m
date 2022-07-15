Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582EE576A07
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiGOWmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiGOWmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:33 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1523A4AB
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q12-20020a632a0c000000b00419b66851e8so3099407pgq.3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eiZ0YogoucqOWJ1ghV62jBhqCkLp0b2ZKJN8u6KRml8=;
        b=JkwcvpUThP6lq5IEN+4um/frEv/e04RuBQf/pjtebj5liCTv+d56ASU3OESMSdxsww
         AXGaB4eam+RNNCzF0HfC4tfj6fZHemhsJlj3yOksY3Eny4Vd/vhj0WnM1ChmBLIZCzrd
         tpOiHH+QnHxgd2d5Q7qsXRqfBWLvOdP4lwj6b0hCnUP6k6gyzGQSoy6GB5eaQWUm0OBs
         O1w0cZaqaJkM2UqTKDwnd9GEESkGbV8xUpuCcHeGlkyIrmszc6Zo3uqDDD0KXTvPiMad
         3k4iSElPr5GzqtSVZz0dsajI5TS0LIvXyW/tJaSxxIaCHmA2p9FhYxOEzQWmRvlZzgbB
         5FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eiZ0YogoucqOWJ1ghV62jBhqCkLp0b2ZKJN8u6KRml8=;
        b=YXb1mfJEi+ruSzaGtYW5m9I7khcYiFwUY7pnyzmsnqtBnda0WWZcfypTnWNOaKyols
         okArO3x+1w48xh5lqmbFY2DG917MhxSri37wcymTaktnl7YzWerrysyuGZVFfa6irE83
         IPazWJrf98LxFhhqSUDl2l0NPLojVrhm3f2XHi5zxuhGNr8q2vn9dkO7ddnBLJMHk+U+
         +WIx9l4/u32sbvZVA+MTnB5hRpZCrQlSYKydFWkufT9NvEfEb8k2z/X7RGL2aDhdVj+r
         7oQOdONWhLUl8R/VMgv38q6sjNxjWT1EsErUfVgyDUZrt4zsEP+FXq/j06kx+Bx89C0S
         RWpA==
X-Gm-Message-State: AJIora8auKkXYd0DM13paF+YjiNkwizr5brmeOmO3/NTqunL/1vpPtob
        HWgVjSfp0Dyjw/XAnlu9ZMbLwvOFNbQ=
X-Google-Smtp-Source: AGRyM1uLr/VSfzLPmDD/lpWJePtSXMCZ/J/O8/bkW40kvhu00AZGmI9NwQjjQKyJQ5wy/g+n5WBciCdi4lk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24cc:b0:50d:58bf:5104 with SMTP id
 d12-20020a056a0024cc00b0050d58bf5104mr16327025pfv.36.1657924951468; Fri, 15
 Jul 2022 15:42:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:19 +0000
Message-Id: <20220715224226.3749507-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 0/7] KVM: x86: Clean up rmap zap helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Clean up the rmap helpers (mostly renames) to yield a more coherent set of
APIs, and to purge the irritating and inconsistent "rmapp" (p is for pointer)
nomenclature.

Patch 1 is a tangentially related fix for a benign bug.

v2:
  - Split up patches into smaller, more related chunks. [Paolo]
  - Reorder patches to put all renames at the end. [Paolo]
  - Avoid quadruple underscores and use more consistent names. [Paolo]

v1: https://lore.kernel.org/all/20220712015558.1247978-1-seanjc@google.com

Sean Christopherson (7):
  KVM: x86/mmu: Return a u64 (the old SPTE) from
    mmu_spte_clear_track_bits()
  KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps
  KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
  KVM: x86/mmu: Rename __kvm_zap_rmaps() to align with other
    nomenclature
  KVM: x86/mmu: Rename rmap zap helpers to eliminate "unmap" wrapper
  KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap
    SPTEs
  KVM: x86/mmu: Remove underscores from __pte_list_remove()

 arch/x86/kvm/mmu/mmu.c | 74 +++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 37 deletions(-)


base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
-- 
2.37.0.170.g444d1eabd0-goog

