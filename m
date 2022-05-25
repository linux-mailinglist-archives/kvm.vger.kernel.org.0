Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125CB534596
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbiEYVEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 17:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240401AbiEYVEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 17:04:52 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AF4BA57E
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:04:51 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y202-20020a6264d3000000b00518297f1410so5161pfb.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=QomCG97xArSjBeEKWzBOAokkYzU04yNWeTK5y9/ZMlw=;
        b=XU3Id7VYyglpjdYcRKpTkcNiV28q88bUG4DHvqX3DKxcrzLx/JG3pnxd5yVWwuz76b
         yFmPjJnIWWpri5WIFFTtRQkP/kuswjmF9Nj4u5DkV5aXjFrzw7FqDuixi1Vigu9wXNoI
         vV6NAWrr0uYZhUybWxSJdEb7WK8EcL/zoznOmFAaxRv6DRzx4gthNIndeCuKIbgh++AX
         GPh3LN58r93aLQCOu1q27RiDoFcgygEdeCJo8HI0UXqhW2cCP+DceBMg4k/SGTipQFwI
         yvI1wtppMnR3da/Y7/O7EFAUhrcbDiJShnrgL3TvY9vUbMhyLvpPn0mPUzAhTcHK5qQH
         3MlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=QomCG97xArSjBeEKWzBOAokkYzU04yNWeTK5y9/ZMlw=;
        b=lXJparzmzJoyHf5TozsU3kvg1gkZOCHQsDBgRP3ecDsEyAmGz9F6fdY3elMYZC7yGc
         j///FfWhTyaB+e93UCyJM6cvAA4/aSIXVPEeo9iGdtd1wN220GopS/wE4rV2GIBRbacK
         CrPEE/wVNm5LKZCw2IJTYdBmlHEuL+T/+ERo5uim0wxRKZYLGjI0IWTSNmHUed4lrY29
         n1n1lPoAGYtO2D/QzCNlChJtLFO8MDhDzPsoSQZuUGDlhymFndrdV+HAt192Xb4sDhzd
         u+DVWzdYixAqWt69Oxd1cxooR0UELhZqJNQBmEXk3XeOa/L8lZskNv4ZchrEWBcLX1W1
         9Dag==
X-Gm-Message-State: AOAM5334DGOTM2Y+43fszxALoZ6GTBipJxx/DmdAlOq/eVedq4BVUoMy
        iS6AkA9K/FF89KIM4lxFWdTR/7qTowc=
X-Google-Smtp-Source: ABdhPJyEODHAGPHiUxSQ5qZmumgYwlMCmweGBOQLGEvxMThAVVfXJiKrgwS1trRnBIorXWNEk5L9EIQF2GE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d2:b0:163:5376:b4d7 with SMTP id
 o18-20020a170902d4d200b001635376b4d7mr5805189plg.66.1653512690712; Wed, 25
 May 2022 14:04:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 25 May 2022 21:04:45 +0000
Message-Id: <20220525210447.2758436-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 0/2] KVM: VMX: Sanitize VM-Entry/VM-Exit pairs during setup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
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

Sanitize the VM-Entry/VM-Exit load+load and load+clear pairs when kvm_intel
is loaded instead of checking both controls at runtime.  Not sanitizing
means KVM ends up setting non-dynamic bits in the VMCS.

Add an opt-in knob to force kvm_intel to bail if an inconsistent pair is
detected instead of using a degraded and/or potentially broken setup.

Arguably patch 01 is stable material, but my mental coin flip came up
negative and I didn't Cc: stable.

And for patch 02, I'd definitely be favor of making it opt-out instead of
opt-in, but there's a non-zero chance that someone out there is running
KVM in a misconfigured VM...

Sean Christopherson (2):
  KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at kvm_intel load
    time
  KVM: VMX: Add knob to allow rejecting kvm_intel on inconsistent VMCS
    config

 arch/x86/kvm/vmx/capabilities.h | 13 +++-----
 arch/x86/kvm/vmx/vmx.c          | 55 +++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 12 deletions(-)


base-commit: 90bde5bea810d766e7046bf5884f2ccf76dd78e9
-- 
2.36.1.124.g0e6072fb45-goog

