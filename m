Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0457EB08
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiGWBXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiGWBXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3165567CB7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y4-20020a25b9c4000000b0066e573fb0fcso4897746ybj.21
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=/gYd/fZvacXV103c8Lv/rGV7oRgkLYVyY8qKay9SInY=;
        b=cV861rw7TopdwNZfjzFLsWvW1zofCcUZDGXRFCfdk/hnh/KEKQARihawDtz0JOa5R5
         +ChtrCDJJ7VytXjFDlIJ+My/SgqZYEw9LUXTHIg1pmDaXKAd0IGNocf/w5XUclYDrP5T
         pOUOvCSFrxYCD/vOnfzTJspdfHHho4BOrcxcWxm+INEfHiqiYCUNiL3DvcpuAeSw1H8j
         YzdhfxTqCT6fwvAvekTu5aAyWwxApEk6jyiKKAN6V4dii8hY6eygJlpQuY94Zqkphsym
         jxl4fs4F2/l40rmjHe98W1D9d+wKK20FFFLdL5WWx61V/3HGS3Ch99KtgzW8+qg2u/pw
         RCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=/gYd/fZvacXV103c8Lv/rGV7oRgkLYVyY8qKay9SInY=;
        b=xG9MBYC7mLxfQglv3SyS/PZ9IeTkSbFXwXzNQI9rd1cXhcGr7tswaBeKK0ldOLfSrL
         fCLAjni7a9cgXErZqjsPCKb90uitUfTMDlCHT8h03v26zhJOkQgvUl16AAPXIqUWVGf0
         o2FvkDnVzndMR9PXws+yqKOaNi01SDes2aGXjrXREYTUbwUdIqj8JFHIqOhxTCVQwVsl
         POH2OM691SrRhgKnCqiYkjBYoPUayDWRg9hOfJ/TirmZjX+AVqhqu8IrD9g5UMF6gN7G
         cXN4toZsAXD7T3rCpfuKUlK/JtPREXVb8FUTy+PNyzibgJGlqWPVpyjMNmhmpOw8Yar6
         w8+w==
X-Gm-Message-State: AJIora9a2H/r5ZINilPreLkof2XXJCKSmLCLs5GymQwwEJEY5hDLAZtE
        uiQSf+NsyYo7+SkKkWCzx9rBFzlrVUo=
X-Google-Smtp-Source: AGRyM1sx0VIq9j0LtHvFZvxQ31X4Dbrctolz4QwoeZHvPWPrKKa8y/ba1dnHkCstwXZzXSHJ4dTclNaXz+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:190f:0:b0:31e:66e3:79e0 with SMTP id
 15-20020a81190f000000b0031e66e379e0mr2128354ywz.331.1658539410510; Fri, 22
 Jul 2022 18:23:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:19 +0000
Message-Id: <20220723012325.1715714-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

Patch 6 from Mingwei is the end goal of the series.  KVM incorrectly
assumes that the NX huge page mitigation is the only scenario where KVM
will create a non-leaf page instead of a huge page.   Precisely track
(via kvm_mmu_page) if a non-huge page is being forced and use that info
to avoid unnecessarily forcing smaller page sizes in
disallowed_hugepage_adjust().

v2: Rebase, tweak a changelog accordingly.

v1: https://lore.kernel.org/all/20220409003847.819686-1-seanjc@google.com

Mingwei Zhang (1):
  KVM: x86/mmu: explicitly check nx_hugepage in
    disallowed_hugepage_adjust()

Sean Christopherson (5):
  KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
  KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
    MMUs
  KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
    SPTE
  KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
    pages
  KVM: x86/mmu: Add helper to convert SPTE value to its shadow page

 arch/x86/include/asm/kvm_host.h |  17 ++---
 arch/x86/kvm/mmu/mmu.c          | 107 ++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  41 +++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
 arch/x86/kvm/mmu/spte.c         |  11 ++++
 arch/x86/kvm/mmu/spte.h         |  17 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
 8 files changed, 167 insertions(+), 83 deletions(-)


base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.359.gd136c6c3e2-goog

