Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0127348CE1C
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 22:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiALV6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 16:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiALV6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 16:58:04 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EE9C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:58:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l9-20020a170903120900b0014a4205ebe3so3911262plh.11
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=igLjj0A++i30pVA7kgFR/QMd6mo7LkmGz0qIVHPXfWA=;
        b=HFADNUBY6hPLMwA+aRVDP334m9jCuJIOcAz0TGEI6LSAt2tu/OOzh4w7NgzVCN6xEA
         PfZFhjEat2iUK08rbj3sjfQe81Ha2NNTj87rZTfATO9ubBKni+ahElWmJdd1X3DWT2im
         2+nhBwrLEScOqoyIYQdtYpW7+KhfB6alrU/sfpROXGPwV1gQxtej7oi8HGoMo/71F3La
         odxzRinwTFjiKxPrxsexceBzZMWk+1G4563YHpgIkSdSNBLXX6QngRM+6pQ0YEdoj+CA
         Pxho7E/ZWH+6QhLx/gBkoXUjvHGegBEMlfFRvHk/POrmulNfDDcERiQVG5o2u47mcTTy
         NdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=igLjj0A++i30pVA7kgFR/QMd6mo7LkmGz0qIVHPXfWA=;
        b=q7o7kKa65gYK6ymUiIt9/LWIJbqTZ5DJSRK/C62lncuKfjyaPTDkHbFF+B4NsAV9SO
         e2xdCsgVbkvxZ7eY+Fo8plVVaC1r2BXsCNhintHbMI1dxFyY7/DBfihbQTjd8gEsRLfD
         1D+mDNyWze//wi3boNYyQvs1+EXxuT4bFX4uECb39uyOKrQGElKJINcH9KKs58RrlxWd
         NHDvYxZDWKBu6ZdEWYl253M5Li+I3GdVyQl3Nw25nmHfJOyyVf4R5OAZFWMTC3PNtd17
         hPJE0hPrvh10rSlu1cdFb+fWQXs9S49KU8kNIUdVx6VVFCXPPYKZgsU2A8wfvuLsteNy
         rknw==
X-Gm-Message-State: AOAM531BZUXVXg7OfgjGknLiU+zbMpKxc3L25s0h05J+60U3QVcThK2v
        hAHg2kcf7nqPAumNy9okQ12T3+/bmFpFrg==
X-Google-Smtp-Source: ABdhPJwNsrjo58pN5TB/A3yQEwgc2NpvUSIQsc5PNMsJAEnlBSwUZ8RaPm2kvGRHdeSoUWIdgOHl/OS+ofp8Vg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:228a:b0:4c1:e696:6784 with SMTP
 id f10-20020a056a00228a00b004c1e6966784mr310831pfe.74.1642024683722; Wed, 12
 Jan 2022 13:58:03 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:57:59 +0000
Message-Id: <20220112215801.3502286-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 0/2] KVM: x86/mmu: Fix write-protection bug in the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While attempting to understand the big comment in
kvm_mmu_slot_remove_write_access() about TLB flushing, I discovered a
bug in the way the TDP MMU write-protects GFNs. I have not managed to
reproduce the bug as it requires a rather complex set up of live
migrating a VM that is using nested virtualization while the TDP MMU is
enabled.

Patch 1 fixes the bug and patch 2 fixes up the afformentioned comment to
be more readable.

Tested using the kvm-unit-tests and KVM selftests.

David Matlack (2):
  KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
  KVM: x86/mmu: Improve comment about TLB flush semantics for
    write-protection

 arch/x86/kvm/mmu/mmu.c     | 29 ++++++++++++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.c | 27 ++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 16 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

