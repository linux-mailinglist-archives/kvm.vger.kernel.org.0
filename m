Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBA510E13
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356839AbiD0BnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbiD0BnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856566451
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:10 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d5-20020a62f805000000b0050566b4f4c0so239988pfh.11
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=E6b4RUB6yiJozhocspZho5VN8Dj9jOha4ZGR+JtnIzw=;
        b=aB0BVHl1fDQTWvZpJetVN2BVGU/Gsu6opWExqCnQV4/lzJJJUN7hzKYr9Qjgq02ffs
         ums3zRwHz045FExBTSnTeuyKz//IjL5vLFuri47r4TrGUHFMdA22Iv3aw0jn8jP4nM21
         rhPDZP32EF4Qr5M/N4OS0UYZscXbe1IaW6YdY7C9g+2RT7BkFO20XiwgT8NbhZZOvK4S
         4vTgA+7rdSxppQrLXPj0BRMQ/sWcrROfbwX/Yvb2aKxxPzvi7TSSC0vMgYavEoOyy+l/
         qmUn1OPbcQIcObUrXHCuUmSNRTbu96DkNAjJSISVIFh1njICackkjLRHQ+g9Si1HMUBj
         ioqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=E6b4RUB6yiJozhocspZho5VN8Dj9jOha4ZGR+JtnIzw=;
        b=fV0QCQU/0j2fESRdZF1Sby5GzluS02qCLNyxSx/3ovfFBUUdZ89yiv4+LE0WvWoKtk
         K9vl9xF6kvJwuBdaeYhb5JZOWrYf4bC8MEeVaejnO8yU0SJv6xTe/EIntFI15TWx8sjz
         ceVs9BM9ptyidmOewMp1sSUJpV6v2AAGl8JfvZ3hM0uqqDiVBcl2hWV4+Ga6ljBCpgFZ
         y66R98Bsm37usSDWgfShxNBC5o2vchvXNAzH/5vuaJSxhlMtj1taOpHWo4Xjjv8kyGnX
         RM+Mw+D7GFoA+LLzyeqHxt4IIynNu4fIjOWFZ4l1Pvncvf9uy02RZsFkD06Yfmqq3k64
         GnLQ==
X-Gm-Message-State: AOAM532UXMOhgAlaY66uxjQaD18yXY4TJE9B7ZHl0znF+y6W1/FkjonV
        SMAaNYH+PyWLq6bxXZFQBYpBseIr0XY=
X-Google-Smtp-Source: ABdhPJx/cybrsoL4+mEtqB0ygN7DaGVe+z/aXar5zfElXJ0YgBnF3R4jQBLl++Q/eR5DClG9/8rHrZRlef4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b4b:b0:1d2:e3fe:e1a1 with SMTP id
 ot11-20020a17090b3b4b00b001d2e3fee1a1mr41417318pjb.239.1651023610015; Tue, 26
 Apr 2022 18:40:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:39:56 +0000
Message-Id: <20220427014004.1992589-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 0/8] KVM: Fix mmu_notifier vs. pfncache vs. pfncache races
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Fix races between mmu_notifier invalidation and pfncache refresh, and
within the pfncache itself.

The first two patches are reverts of the patches sitting in kvm/queue,
trying to separate and fix the races independently is nigh impossible.
I assume/hope they can be ignored and the original patches dropped.

I verified internal races using the attached hack-a-test.  Running the
test against the current implementation fails due to KVM writing the
current GPA into the wrong page.

I don't think the race with the mmu_notifier is technically proven, e.g. I
never encountered a use-after-free even running with KASAN.

Ran with PROVE_LOCKING and DEBUG_ATOMIC_SLEEP, so in theory there shouldn't
be any lurking locking goofs this time...

v2:
  - Map the pfn=>khva outside of gpc->lock. [Maxim]
  - Fix a page leak.
  - Fix more races.

v1:
  https://lore.kernel.org/all/20220420004859.3298837-1-seanjc@google.com

Sean Christopherson (8):
  Revert "KVM: Do not speculatively mark pfn cache valid to "fix" race"
  Revert "KVM: Fix race between mmu_notifier invalidation and pfncache
    refresh"
  KVM: Drop unused @gpa param from gfn=>pfn cache's __release_gpc()
    helper
  KVM: Put the extra pfn reference when reusing a pfn in the gpc cache
  KVM: Do not incorporate page offset into gfn=>pfn cache user address
  KVM: Fix multiple races in gfn=>pfn cache refresh
  KVM: Do not pin pages tracked by gfn=>pfn caches
  DO NOT MERGE: Hack-a-test to verify gpc invalidation+refresh

 arch/x86/kvm/x86.c                     |  30 ++++
 include/linux/kvm_host.h               |   2 +
 include/linux/kvm_types.h              |   1 +
 tools/testing/selftests/kvm/.gitignore |   1 +
 tools/testing/selftests/kvm/Makefile   |   2 +
 tools/testing/selftests/kvm/gpc_test.c | 217 +++++++++++++++++++++++++
 virt/kvm/pfncache.c                    | 188 +++++++++++++--------
 7 files changed, 372 insertions(+), 69 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/gpc_test.c


base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

