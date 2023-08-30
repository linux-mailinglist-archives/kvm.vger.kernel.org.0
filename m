Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1778D0E7
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbjH3AHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbjH3AGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:43 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034DBCCE
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26d49dd574aso427181a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693353999; x=1693958799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WVVH5nRTRr0fqZdqxU2iU1BDtT9CWgWVgLBzLBzxuQ0=;
        b=7Dnpwt2v1KJ5YXfTvkX8XF2OamSbe1gsd6Jzk4AeAMNhmtelkgHoGAA2ixLYrEtJz4
         SWrba0GaUAANOPSCgVtITQJCR2xCnrTv6BvA/49sz3HIGqwp6gwaWAB5ND4Vk1RFukFA
         W736ypuHbtTk4Ab62z1nXW8jCPnxl4aHXaeZqBIsMWcJaJEy9qR40MbMbdhTg0VJpLZy
         kAE0dsyEnWt4IVOfALnOdpja0f/yiU9ej3cKj68TzmdFg4RfRA6aJInKOxoocUbLoP2X
         XfZnx/O1eREucgvWzJzvTPbqAoX/msObdsN9Cgfgi5nNcNGONJ9GrST4aPbnx7d+j2RD
         N8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693353999; x=1693958799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WVVH5nRTRr0fqZdqxU2iU1BDtT9CWgWVgLBzLBzxuQ0=;
        b=VDWmdClAopiWCwoTwawELiizDRPC5q0atAAifWKk2gein/iQUzpMdn/2c7sJ4LgcV0
         aP0BkdnHSg11VM/yLg6p3zTQn+yyMGnzHwlcs0QV7ChB9VoXphGsY2dwFk2/VTRZ7Vn/
         GiTt5JUh8Ej4g4AE/9HhRMPPprgLqiDH7ZlgdsO5qqCtETdkFvyuD2e0NzIQYcdrKYe1
         0Mbj4o1dW1ZWYhqKlq3Q44I7KgDFhJz0yVcBnW3Hj4u5udAn/KxW7jcXltnYYgwO571A
         gCKL3p6voORcAZmgm7KWqyaAzDppVj2ndDYHXRRYQRnajgl9cj4zmxh46dymqzzj5feh
         7OOQ==
X-Gm-Message-State: AOJu0YxdsUmdDgTrd1JIMMsLV2eu9V9GikHIRnHAIxf8vYzk/sGVIv1D
        G1ccUCdQ8EDmrGgvUtKDZ/ItSBxGDy8=
X-Google-Smtp-Source: AGHT+IF3sZAXM1ZOxh2SHoPEicvzN0FXDwihMc22UnZGVorjsnxQEaL2hdVNarkWP6/htwKBcl1BHbf2mA4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8304:b0:26d:5ce:b77f with SMTP id
 h4-20020a17090a830400b0026d05ceb77fmr208184pjn.1.1693353999359; Tue, 29 Aug
 2023 17:06:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:27 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Non-x86 changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull a few smallish KVM-wide changes.  This will conflict with the MMU
pull request, which changed a WARN_ON() to a WARN_ON_ONCE().  The resolution
is pretty straightfoward.

diff --cc arch/x86/kvm/mmu/tdp_mmu.c
index 6250bd3d20c1,b5629bc60e36..6c63f2d1675f
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@@ -1241,7 -1241,7 +1241,7 @@@ static bool set_spte_gfn(struct kvm *kv
        u64 new_spte;
  
        /* Huge pages aren't expected to be modified without first being zapped. */
-       WARN_ON(pte_huge(range->arg.pte) || range->start + 1 != range->end);
 -      WARN_ON_ONCE(pte_huge(range->pte) || range->start + 1 != range->end);
++      WARN_ON_ONCE(pte_huge(range->arg.pte) || range->start + 1 != range->end);
  
        if (iter->level != PG_LEVEL_4K ||
            !is_shadow_present_pte(iter->old_spte))

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.6

for you to fetch changes up to 458933d33af2cb3663bd8c0080c1efd1f9483db4:

  KVM: Remove unused kvm_make_cpus_request_mask() declaration (2023-08-17 11:59:43 -0700)

----------------------------------------------------------------
Common KVM changes for 6.6:

 - Wrap kvm_{gfn,hva}_range.pte in a union to allow mmu_notifier events to pass
   action specific data without needing to constantly update the main handlers.

 - Drop unused function declarations

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union

Yue Haibing (2):
      KVM: Remove unused kvm_device_{get,put}() declarations
      KVM: Remove unused kvm_make_cpus_request_mask() declaration

 arch/arm64/kvm/mmu.c       |  2 +-
 arch/mips/kvm/mmu.c        |  2 +-
 arch/riscv/kvm/mmu.c       |  2 +-
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
 include/linux/kvm_host.h   | 10 +++++-----
 virt/kvm/kvm_main.c        | 19 ++++++++++---------
 7 files changed, 22 insertions(+), 21 deletions(-)
