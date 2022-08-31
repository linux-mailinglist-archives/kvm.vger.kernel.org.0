Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C334A5A72AE
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiHaAg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiHaAgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473DA97EE0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gg12-20020a17090b0a0c00b001fbc6ba91bbso1564606pjb.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=vQjfmAeokYMHaFKC24HPf5qSFHNWZwCTyrVaZZhdr6g=;
        b=HyZQtTQe8sv1fFpmWsBB1x/zoopbd0fljzA3156nZJgj+zmKIG/p1Bw22VR0a72shj
         tXrjBM8Z8BVHkXg9rfk4YHYpUbmPOLwMSBO6Kn+RueEpko/LscZDgYKz0XCrVQnjJMn0
         a1knszFnqc8fRjcL31Fbfur8Dk0v/69sc9Tgr5v+sNSFwN08VAr7kZ55KSJM5RsuZbM2
         OQhQNE16zaNgbS1yAeEqo7nyaAdtaNyP7mXiGvlZ+cyafkKmL0HtxJplQV9gTvj/ghVN
         ziitxO2FItbRBTwMfBP3vGk4O21i0v5+0CgQwnGNGnF0OFiRd6o25C5SEStRNDRZ7pRX
         plIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=vQjfmAeokYMHaFKC24HPf5qSFHNWZwCTyrVaZZhdr6g=;
        b=WUlfQq35+IcT4R8mat+KWMGposvrinviW0RNoeUEQfU54gqgmiD7aDwVlTkItLqw5j
         u0v8Lj3XW6NwH5OEzcsXEFpt1IjXX8c3pKh+pMRtd322bKgyGVGNyUxWO9xMO5/HqOe+
         C7dkboZKzNq0yDq0o+gNDJNt1cuhx4kRmNVkVfbE0Vi93YA7g/N0ORehrXYZQ4Fhj4/T
         gyqZt+CUyrqQjlXVcGTVdHyvIFrIMo5OUsTjVzIEIEZr3vX+b2zbTwB0Vc2TI94p0LDX
         OnSTrpzQskzieOy9kRWX6OumUo+WicXbYP+osdvuj0e2nXkN971CmlhW79PwAzXXn141
         3iKw==
X-Gm-Message-State: ACgBeo3O0rgs1FiJqGpojhXJwERlqmtH5nWSVt57x2V8doWPWmJ1Vy3K
        YytGlmMPvAz7TBr3y2AjcydrAXGe3HM=
X-Google-Smtp-Source: AA6agR48IkDisKJLCllOWr3gCFWtwysHo4voHNcs55clmzzgw9G7CJBinW+TyQzT6XVubKAgJxdg4jQf4Zs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr26541pje.0.1661906109176; Tue, 30 Aug
 2022 17:35:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-1-seanjc@google.com>
Subject: [PATCH 00/19] KVM: x86: AVIC and local APIC fixes+cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This started as a simple cleanup, and then I made the mistake of writing
a test to verify my changes to AVIC's handling of logical mode interrupts.

TL;DR: KVM's AVIC and optimized APIC map code doesn't correctly handle
various edge cases that are 100% architecturally legal, but are unlikely
to occur in most real world scenarios.

There are a variety of other fixes, but most of them are non-fatal.

I have tested this heavily with KUT, but I haven't booted Windows and
don't have access to x2AVIC, so additional testing would be much
appreciated.

I'll post my KVM-Unit-Tests later this week (need to write quite a few
changelogs).  The gist of the tests is to target multiple and non-existent
vCPUs in logical mode, and to target multiple vCPUs in physical mode by
aliasing vCPU0 and vCPU1 to the same physical ID.

Sean Christopherson (19):
  KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid
    target
  KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
  Revert "KVM: SVM: Introduce hybrid-AVIC mode"
  KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean
  KVM: SVM: Compute dest based on sender's x2APIC status for AVIC kick
  KVM: SVM: Get x2APIC logical dest bitmap from ICRH[15:0], not
    ICHR[31:16]
  KVM: SVM: Drop buggy and redundant AVIC "single logical dest" check
  KVM: SVM: Remove redundant cluster calculation that also creates a
    shadow
  KVM: SVM: Drop duplicate calcuation of AVIC/x2AVIC "logical index"
  KVM: SVM: Document that vCPU ID == APIC ID in AVIC kick fastpatch
  KVM: SVM: Add helper to perform final AVIC "kick" of single vCPU
  KVM: x86: Disable APIC logical map if logical ID covers multiple MDAs
  KVM: x86: Disable APIC logical map if vCPUs are aliased in logical
    mode
  KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs
  KVM: x86: Explicitly skip optimized logical map setup if vCPU's LDR==0
  KVM: x86: Explicitly track all possibilities for APIC map's logical
    modes
  KVM: SVM: Handle multiple logical targets in AVIC kick fastpath
  KVM: SVM: Ignore writes to Remote Read Data on AVIC write traps
  Revert "KVM: SVM: Do not throw warning when calling avic_vcpu_load on
    a running vcpu"

 Documentation/virt/kvm/x86/errata.rst |  11 ++
 arch/x86/include/asm/kvm_host.h       |  27 ++-
 arch/x86/kvm/lapic.c                  | 100 ++++++++--
 arch/x86/kvm/svm/avic.c               | 273 ++++++++++++++------------
 arch/x86/kvm/svm/svm.c                |   2 +-
 arch/x86/kvm/svm/svm.h                |   9 +-
 6 files changed, 260 insertions(+), 162 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.672.g94769d06f0-goog

