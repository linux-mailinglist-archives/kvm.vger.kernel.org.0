Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E743FE54B
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbhIAWLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343674AbhIAWLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:11:24 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3A7C061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:10:27 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e14-20020a056214162e00b00375ec21dd99so1058982qvw.23
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ALl97lKhsbxJ/NiiAvNW+lyq6xZyCyUk+3VnN2UOJAA=;
        b=PhyJtRw/19bMj/3oy9PlGHHbFe4J7RbPe7eyKEJfjET0e0J4UVbE72Cv/sGgJZxSkZ
         EXPXMgPnNR6/TKiaON5k3jlvp+8xCctCPbpzzugG5Q2izHFPWUH8OKxnjP25nkwiArVF
         5FQI6GS63tNLwkgEW78e6oYmCK47cOVMBWMdFvxtQT0IFOzWkRc46zYiG32ABKP7rc/z
         ZOK7YER3+j/29k7iHEMYZ5hAYWlY/Q4MJL3aFA76H+iJ7FECKKi8/2M0D2r3yBWq9s2D
         O9qiGkQVibiVP54M6JeSd75bJ02Robd4iOE73+HZkrzdjGgaj2BMibNqbj/yTHQOTPHV
         J+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ALl97lKhsbxJ/NiiAvNW+lyq6xZyCyUk+3VnN2UOJAA=;
        b=SghydbWyrXk5SBBBGuQs8GGqt1cR5lcf4Xwvvmxy7A8+IQhOUvuvjOhVQOqYtpu9uO
         Gf6FkZpYk6i+kclrvozEBCqYSnghO/kJPXriHGu53O8j8Pk91UHZgnFBPsaqS4I6dbOt
         2yZH1+uizTE+JLsvL5PGyMFT7pYz4jTIUg6njKNsdvqglmLlqcPA9oygcsXmXI+IFJ9L
         R/3PNQrPvEYe++MnT1oLSeWlAhExUsARNoVTyLuwE4UPOtNYagfb5oFf2/NGbV0B5N/p
         D4U6lPIgXlsn5V4hVTuBERlBFq69EnCMrbcMxOOJNM3GkCk9HZXPZl3N3MCa2Zq5+ZR8
         mdwg==
X-Gm-Message-State: AOAM533/jbydZkOELWhvM1OlTJnD+7/obG5g5xtQtBGU3dpr92EOjlHh
        eW+HY3KYaSVXUSEdfwj8wSdenrs7ZH8=
X-Google-Smtp-Source: ABdhPJy2XduhtgCTgV3BaVLkTfU4bAudbwfcIULDKv3cwvK7W9UX0UY+9kA9Gimfys/Z1VWA8xfmQqI24Ao=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:9935:5a5e:c7b6:e649])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c87:: with SMTP id
 r7mr2088190qvr.2.1630534226644; Wed, 01 Sep 2021 15:10:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  1 Sep 2021 15:10:20 -0700
Message-Id: <20210901221023.1303578-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/3] KVM: x86/mmu: kvm_mmu_page cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia He <justin.he@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is from Jia He to remove a defunct boolean from kvm_mmu_page
(link[*] below if you want to take it directly).

Patch 2 builds on that patch to micro-optimize the TDP MMU flag.

Patch 3 is another micro-optimization that probably doesn't buy much
performance (I didn't check), feel free to ignore it.

[*] https://lkml.kernel.org/r/20210830145336.27183-1-justin.he@arm.com

Jia He (1):
  KVM: x86/mmu: Remove unused field mmio_cached in struct kvm_mmu_page

Sean Christopherson (2):
  KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for better cache
    locality
  KVM: x86/mmu: Move lpage_disallowed_link further "down" in
    kvm_mmu_page

 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

