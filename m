Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48089480DE2
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 00:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhL1XYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 18:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbhL1XYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 18:24:41 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D97C06173E
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p2-20020a17090a2c4200b001b1866beecbso16531556pjm.5
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=VCUbiUfxRQgO1C3fIu9TBCkG8k6G/qD2BOcSRTbuD1c=;
        b=lB59nZUv8KWJ5mLd88XkrXrrAgAQ6si3Sg1nBEAgELcKOmTCvXm44WSrvCJLWidktY
         4ldpdJUkkLqwAtYCIm7aixOmQ/mHsI5qEDn1XlOJ1Mun5XP0Qml/697U181sepfza350
         wjtDbCnHecuHUTFurFEw3CPXDr5PLs16oTKZM3Rgqn6ESeMAE5XBsi05rHElabyPJNKI
         KLsJ+uYTZlaHW0iYvhM/ZkXagRhmN2fbLwzb2oVIMbAxwERg7UcUEQaLp4MOG1BU/uOS
         FpHfHw4VxJZRmvpyHhxOlC8rNr/Hs9xmocB4pC0vIo49B+ounp4WZdXt6RstW3W6hiQU
         a5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=VCUbiUfxRQgO1C3fIu9TBCkG8k6G/qD2BOcSRTbuD1c=;
        b=GJjXPAzCH+AoBLBXv2xeNxtDtTK0xs7yMpKj8C+irOvqpx/f6M1YVEx6SiXYbzGPrv
         XvstE4RInDt0kSm5N3CMWfapGs5DLraJNBQxe4s3Ej5eoOi+1Jmo/6Tl2mVTIHzPF2E/
         fEEZLntGju38Yt7auGV4VZ/5y7J1kdNLX767U1Fhl5K2K3nrB0ALtn/1vWbhxAdQQlse
         0eE7DvVIXfXKbzg/Tf8GmNgn2ZyeEkYUCLL7NMxSVXW95m8NcM7Bq5X1oB/bJFvOcmj8
         0PoF0opTspSgbAmTn6kLKRhayPly6w5h5joTH1vwAIo/dfs9ub6TWdZ6dgQ7cx4fdo3f
         AQ1A==
X-Gm-Message-State: AOAM532AGHG8bAHQC3srNzM7n6JooZBPfD1GoBr2VFKXqwTaQzy4DPhR
        uRu5tuVq0vpBeoVW96jsi5Vb5yMC2X4=
X-Google-Smtp-Source: ABdhPJzPjPTQbztBMp2uTNDFtTsH69aLQHjp2cS0Tw9ZlDzLurVhqCX/7moCfZkIjtfq+1Hqy+N1RtO0QOU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9298:0:b0:4ba:7d3a:1742 with SMTP id
 j24-20020aa79298000000b004ba7d3a1742mr24182188pfa.62.1640733881004; Tue, 28
 Dec 2021 15:24:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Dec 2021 23:24:35 +0000
Message-Id: <20211228232437.1875318-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH 0/2] KVM: VMX: Fix and test for emulation + exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an issue that allows userspace to trigger a WARN by rejecting KVM_RUN
if userspace attempts to run a vCPU that require emulation in KVM and has
a pending exception, which is not supported in KVM.

No small part of me thinks this is a waste of code and that we'd be better
off just deleting the WARN.  But it's also not hard to fix and there are
still folks out there that run on Core2...

Intentionally didn't tag for stable.  I highly doubt this actually fixes
anything for anyone, the goal is purely to prevent userspace from triggering
the WARN.

Sean Christopherson (2):
  KVM: VMX: Reject KVM_RUN if emulation is required with pending
    exception
  KVM: selftests: Add a test to force emulation with a pending exception

 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/svm.c                        |   6 +
 arch/x86/kvm/vmx/vmx.c                        |  22 ++-
 arch/x86/kvm/x86.c                            |  12 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../vmx_exception_with_invalid_guest_state.c  | 139 ++++++++++++++++++
 8 files changed, 178 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c

-- 
2.34.1.448.ga2b2bfdf31-goog

