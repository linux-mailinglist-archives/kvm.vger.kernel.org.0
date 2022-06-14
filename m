Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF3554BE4E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbiFNXdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238234AbiFNXdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135A74CD64
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:35 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id q12-20020a056a0002ac00b0051bb2e66c91so4326493pfs.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=RLjwpUgrQld2IadGR7ke2jwP+ko9Ytby9Ifc1yeHho4=;
        b=NnrFOmxaXlolnOZ4zOwyM45sGetWmK8pBfOzGCq4bgATHK4Q6cUg4JW1FEPkRPokQi
         EdPGSF2vSW/TgXhoawsV4hlkoIHznqpUb+ejtk3jWlp47BQAq4Dve5HRLrYj5W+763Ri
         W+W2CLhOS/fsml+8SiyNl6Rln2HVRUPFIonQ6mQSalHkU7jkadF5Bz9k8znncsk5JkWv
         WUpTOe+p0J+LNiVDqdZR20bN09ExUOzOdtTYOSuFerW/1Dr0xZiO2A+r6O+GSRfR0AcY
         zRZA7+hgFHsqhTXWg3ETn4h0MGi5bYycsK2buTdLZBCVzNLKPRMF2DuBZctunw8h1GZR
         J62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=RLjwpUgrQld2IadGR7ke2jwP+ko9Ytby9Ifc1yeHho4=;
        b=EoXWcZX8A5mTFK/zkFc2cmnj/pSS1Lr5SweeJxmdz/RRgkdkGvlTpkoM6FNBzxY7YS
         NwepbvYMoxiSufRPtwooZtIHdGs3uxMvwhW23zKS9TTvhriS5CoEi0s1XTapz0SSyXyT
         kUj5HGCcWVqmnDTCPghYMe5GxsZ7x8CtxSbU+3y3x2XSLrjtBpA664HYW7zKyx5r+hMS
         h5w3BhyyCfObC3nLUR1DzGyP1XwID+KerrLbbFhBNJ7gfm6VWRZzWmlvBXSowlFicYLJ
         mX0ECe4Oa87NUVzwZGtWi+mi+P+y8tOLkWh/RhxiesBmQZnmQtjyeaiNV+J3iV4raI/b
         srYg==
X-Gm-Message-State: AOAM532A0GwhWuegB5EI/CpVGNalmGPae7Ysb5BYo1CzvwcHf0fMIYVq
        wdK41B4EB81tOxCg7Gi8JfxWxJhTVKs=
X-Google-Smtp-Source: ABdhPJwjXKQDy2nT+/ZoD3beslO/H0/x3QOlGWxUvBo5PFi+sUG33Ct3ksHIiH+NdOOnGIgytN5xJK6kki8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c951:b0:166:4f65:cff2 with SMTP id
 i17-20020a170902c95100b001664f65cff2mr6552735pla.7.1655249614340; Tue, 14 Jun
 2022 16:33:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:20 +0000
Message-Id: <20220614233328.3896033-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 0/8] KVM: x86/mmu: Use separate namespaces gPTEs and SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
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

This is based on kvm/queue + "Remove unused PT32_DIR_BASE_ADDR_MASK from mmu.c",
so I think it should apply cleanly on top of what you already grabbed.

Clean up the x86 MMU code to use separate namespaces for guest PTEs and
shadow PTEs.  While there is most definitely overlap, especially in
attribute bits, the rules for walking gPTEs and for generating/walking
SPTEs differ in subtle ways, e.g. see commit fc9bf2e087ef ("KVM: x86/mmu:
Do not apply HPA (memory encryption) mask to GPAs").  The paging32 macros
in particular should never be used outside of paging_tmpl.h.

Separating gPTEs from SPTEs actually provides for nice cleanups (see the
diffstat) as KVM has ended up with a fair bit of copy+paste code that can
be deduplicated once KVM isn't trying to use PT64_* defines for both gPTEs
and SPTEs.

This is a spiritual successor to patches 4-7 of the series[*] that added
the aformentenioned commit.

v2:
  - Don't move is_cpuid_PSE36(). [Lai Jiangshan]
  - Change author for patch 1 (yeah, I was lazy). [Lai Jiangshan]
  - Fix a random typo in patch 7's changelog.
  - Rebase to play nice with PT32_DIR_BASE_ADDR_MASK.

v1: https://lore.kernel.org/all/20220613225723.2734132-2-seanjc@google.com

[*] https://lore.kernel.org/all/20210623230552.4027702-1-seanjc@google.com

Lai Jiangshan (1):
  KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h

Sean Christopherson (7):
  KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
  KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
  KVM: x86/mmu: Dedup macros for computing various page table masks
  KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs
  KVM: x86/mmu: Use common macros to compute 32/64-bit paging masks
  KVM: x86/mmu: Truncate paging32's PT_BASE_ADDR_MASK to 32 bits
  KVM: x86/mmu: Use common logic for computing the 32/64-bit base PA
    mask

 arch/x86/kvm/mmu.h              | 10 ------
 arch/x86/kvm/mmu/mmu.c          | 57 +++++++++------------------------
 arch/x86/kvm/mmu/mmu_internal.h | 17 ++++++++++
 arch/x86/kvm/mmu/paging.h       | 14 --------
 arch/x86/kvm/mmu/paging_tmpl.h  | 55 ++++++++++++++++---------------
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/spte.h         | 28 +++++++---------
 arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 10 files changed, 82 insertions(+), 115 deletions(-)
 delete mode 100644 arch/x86/kvm/mmu/paging.h


base-commit: ccf1c220033d8d6fe50d8d11daa3dec5640f8c4d
-- 
2.36.1.476.g0c4daa206d-goog

