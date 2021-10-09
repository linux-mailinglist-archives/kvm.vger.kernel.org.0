Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CEB427486
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 02:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhJIANI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 20:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243892AbhJIANH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 20:13:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81474C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 17:11:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b197-20020a2534ce000000b005b71a4e189eso14845366yba.5
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 17:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=EsXKxBGCni9aCrMUCZ3dcGRsp5mvNJAnlof7sA2/gMU=;
        b=r7TVramm4KQYMm4ZbJewSuH45QEg2ckrho/CW1KrjHjc2thA66/vB+3BJd37qYdEqo
         8SJocOQHOYIRX/ksQvW6Db0DVqoN/rQq6z/BtbPTYeKviOYr4wGKG+Tiwvt54C3OAEw5
         DEKmbIkxS3jz3tQJ+KTzgGcELVK0IefB3AkcjzqkeXtaMZERFTcKUmLjDkipznsLirCh
         m4l1L/SHSVd0jsqc2SgZnetIHlr14wqa7xBUsJI4qzJLpiScDBtZda2dK3zc4mPqgQvY
         LW3Sqx83mehztENWAzPJpUMJN5cowrW6Jn7cC2CX5sB/X3WUHf+xkAdfF+JOvji+vPQh
         GQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=EsXKxBGCni9aCrMUCZ3dcGRsp5mvNJAnlof7sA2/gMU=;
        b=ZJKfRazcUBFUeE8UY5K1PD/PgwPXa9OdN2VnHWFbOiwZP+RXY/EndOjyTwmH1jV7YN
         8ExVxz34iPG5b1BX+sLt+PNI6FkvYP5rExkoXXoBPq7f6G/IyD7N1T2MZZlyvaI/jaaa
         IZmikShI9RvAszWR3BOWCKv4015S00U8z0+dH61XyITeKAAy2LUQXGvuPNzhLjlViUvJ
         QD91ZKktISVazH+hIpGcpH5mTUgWPgxcOwY9PeT0eRMT2dQDVoP1wQHyDdOKMgf4MHUE
         Z3jpHzj8OSG19lvC/cB2AIflaMNqvveVyZ4HmnAdOyKyyNGEY79KBdOASQc7xrlPVGMO
         01GQ==
X-Gm-Message-State: AOAM530WsqxFHqlq04WNdH2qgoEdc34jiqRaQeRdjDVT8u+/BQAtt0rv
        7QAZmRri5CvjAqZUycUOscYEUhPdQxs=
X-Google-Smtp-Source: ABdhPJzeH5KJuoZncUc/SVbpxwGP+sApSgKZJEvS5AFcD3CoEq/XEZUf9MgZc8kmDJAIx4mRVDMMlw1m5dg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:b904:: with SMTP id x4mr6122257ybj.48.1633738270781;
 Fri, 08 Oct 2021 17:11:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 17:11:03 -0700
Message-Id: <20211009001107.3936588-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 0/4] x86/x86: KVM: Fixes for KVM's PI wakeup handler
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two fixes and two cleanups related to KVM's posted interrupt wakeup
handler.  Fix #1 ensures any in-flight IRQs finish after changing the
handler.  Fix #2 actually uninstalls KVM's handler so that a spurious IRQ
won't jump into a freed module.

AFAIK, no one has actually hit these bugs as it would require a really
spurious IRQ, or a bug+race elsehwere that caused a device to post an
interrupt well after a KVM guest is torn down.

Sean Christopherson (4):
  x86/irq: Ensure PI wakeup handler is unregistered before module unload
  KVM: VMX: Unregister posted interrupt wakeup handler on hardware
    unsetup
  x86/irq: KVM: Harden posted interrupt (un)registration paths
  KVM: VMX: Register posted interrupt wakeup handler iff APICv is
    enabled

 arch/x86/include/asm/irq.h |  3 ++-
 arch/x86/kernel/irq.c      | 30 +++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c     |  9 +++++++--
 3 files changed, 30 insertions(+), 12 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

