Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF12355A1E
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhDFRSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbhDFRSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:18:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE09C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 10:18:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n67so5872942ybf.11
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 10:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2QVarXwWjfAQ6D128GVf+WS0ZBaSudzPxzhf4vjW9Pc=;
        b=RzlDtRxBkXkLYNyInRsipPHgQI+EUlsswpmhz7RqwzjyAtRO5C9CPPWpjLTorw4/ag
         QpOPm5hG55P2oRNMWitz44qrKmz5bBmdnZcjjhOiCu0faVVLgZHbOgEJrPbqxWsMEbMb
         QqSythYmiBIiBAZFEAGg/yAmaus7Ei0C2t6lzEEMJaJ7iHVCuSARwIMkHma3v9FNSodX
         BwPrZHyrtwxeiQtWy4EsDaZUrWgW9IuU6Nu6vFaV89xfak/0Cw2wmVsntgf1DBMUogHO
         Jpd7y2sjb5Wo8FWjMKWzkp9YKCbPtgrZgodM4ie2JdCgVJN+PwTjgxaKdVquyvBD8aWN
         x0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=2QVarXwWjfAQ6D128GVf+WS0ZBaSudzPxzhf4vjW9Pc=;
        b=ZRdTm8SBaMYlpthf982/GR10tphxzQs2lydxGw9qWaUZe+Ca6uSPI46ucv+dbRAUAD
         R1qxAGnXvN7hC5SZn6yW44D3HVODF6gsd9mJKKKEfbYKlB+cfoksA/n2TFVt6UTJonfl
         q/tQmYDoQJgA5DXB8Q3dX5a7pvl4QTCF9q0k5UbTJlSUPGxH9RGNSOG8RQxVd+oSwe7Q
         sdHUcfuFnXUBI3Ws30vlmYvXE9833iDGAo5OeCzKnZh+ymesfejhf+OVpR4Atpw1SINJ
         vFg5hwIRh4HqBjkr0+t9P70V9o75m2q1DcCc3KiB/0mrGL/ZClTBOvYpNHhQuVxss0HK
         iOKw==
X-Gm-Message-State: AOAM5325bwkPBEfz0seXkPDHUtc6AuM4fQUCRV7AzoW2KEO6qjeICsF0
        sMgbzpUiG+K1oc25uuIEdve104zffLk=
X-Google-Smtp-Source: ABdhPJx0P56RiIuz/a4w5YDahtfmvb66qqZAu2XOJs8zEcjT81edWLuMZVNWSJPcP+l7dOYSkfOiIIvC5DU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:1186:: with SMTP id 128mr43976001ybr.59.1617729494045;
 Tue, 06 Apr 2021 10:18:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 10:18:07 -0700
Message-Id: <20210406171811.4043363-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 0/4] KVM: SVM: A fix and cleanups for vmcb tracking
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Belated code review for the vmcb changes that are queued for 5.13.

Sean Christopherson (4):
  KVM: SVM: Don't set current_vmcb->cpu when switching vmcb
  KVM: SVM: Drop vcpu_svm.vmcb_pa
  KVM: SVM: Add a comment to clarify what vcpu_svm.vmcb points at
  KVM: SVM: Enhance and clean up the vmcb tracking comment in
    pre_svm_run()

 arch/x86/kvm/svm/svm.c | 29 +++++++++++++----------------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 14 insertions(+), 17 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

