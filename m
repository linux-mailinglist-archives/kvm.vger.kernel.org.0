Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7EC45D2F3
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhKYCN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbhKYCNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:13:10 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3526AC0698D1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:49 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020aa7980c000000b0049fa3fc29d0so2577028pfl.10
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=45VhrJ35QrhBrjhlycTcaZjncxM1bb+aJa1df+T91rg=;
        b=tPFRpWOIUe7vQqyBUAQLs1tTr/BaAkqJWDe4thIHwCyzRO3ZkV/2heUBe0KTweACA4
         uIR84nNgbQBL55CEtyryNB6VmhheK47Kl7XgvpJJaDfreuTRuXTp0i2o1FvrsN9WrBzX
         yKYGaaJUMcaa6vMjMY4gJnK/GTHJZifskhafC5PEyXY6F4DrDfiHet+UUxlRhC3t5Lzv
         EL1Exu77QDSaytSY1x15E9BazM0tWW9+lPvbVy5XKgDtYsMdgnOx/tPBOIJjBl7USWDQ
         cX2hOrzoNmDU0j4OMSPZPsdEFAC9MtqUF8cdeJ9X6lYEH0KfObJ0JHzBI1Sqj9iEUw/u
         O7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=45VhrJ35QrhBrjhlycTcaZjncxM1bb+aJa1df+T91rg=;
        b=Sbu1hVRF6/ObQNT0ULQi0p7GE+dMLNFyDwdQNFhfMMI++vRT0RzC4D6Q8XHpDnxmKS
         vxPotmTMvvrsw9Mf8Q5gf3PlJjOlV3QEBaeGMyUEnyH2zwlEsf6TXqkZCF9mSe174XdQ
         YvuawWznApAL/Vt8ttnsDjO7bpzw+dU6Ld5dvD2vTK8FH1eZGBm7XBdS8qvApHvXES2h
         HViTYaF2UF9H6l6QQERd/rtsx4zOVX9/rDpUUCnXI5sRuhTWU6czDtss2PCYGZS3YlMp
         0NJOnlT+Ztkj7ZbdFpEm9wzmTaRJxNAoAuTmgu11ePyhy4Z9iSKqGcotmt2BCpE5AFMQ
         LSGQ==
X-Gm-Message-State: AOAM53258RQqZ8ClPoLjMksDzPnohmd9dy5tBXnaxTwCgrKJ14vK2Ce6
        LcClk/l6DNWehG559PbJ/tIRa07nivg=
X-Google-Smtp-Source: ABdhPJxLzJ1wyNIEnrII3HWoOks8rgvVmjF5wWFMhMVW5VL0UlLnttgZV3XmODTIf/nMSilQsUK00+gBla4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:31d1:b0:141:f14b:6ebd with SMTP id
 v17-20020a17090331d100b00141f14b6ebdmr24799985ple.75.1637804988693; Wed, 24
 Nov 2021 17:49:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:49:42 +0000
Message-Id: <20211125014944.536398-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 0/2] KVM: nVMX: Fix VPID + !EPT TLB bugs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two bugs reported by Lai where KVM mishandles guest-scoped TLB flushes
when L2 is active.  Bugs confirmed (and confirmed fixed) by the VPID+access
test (patches posted for kvm-unit-tests).

Sean Christopherson (2):
  KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
  KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12

 arch/x86/kvm/vmx/nested.c | 45 +++++++++++++++++----------------------
 arch/x86/kvm/vmx/vmx.c    | 23 ++++++++++++--------
 arch/x86/kvm/x86.c        | 28 ++++++++++++++++++++----
 arch/x86/kvm/x86.h        |  7 +-----
 4 files changed, 59 insertions(+), 44 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

