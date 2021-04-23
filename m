Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37D1369CC8
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 00:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhDWWfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 18:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhDWWey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 18:34:54 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F3C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:12 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id f7-20020a0562141d27b029019a6fd0a183so19367620qvd.23
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=m6vJDTZh9Y+DWagifmx06cOkYlWeKqEnHAb9nbqa1eA=;
        b=CcRHYOxRXnTeyAVKtPEMTQinsgIPUinhJmw50/VjAVx0sHoMnBHFxt4xxBAzhbSZVd
         sENXQVewfxQg75TVjm+J51qqFaMgyXnZVyw/SIZ1W+f7t7oVrs9SWCYS+tZST9scSCr7
         OTg6K1O+cQNXEiSVv+HncalpXuhgJT77Nv//jU7Sp4qTJcXSatGXfyRH8JkZdmWmNxXk
         TEE2dI8CM3Fzx4Fdu0+XGZ3Yci140NegEICdP84q+viRUGd1ipq8FJYNAKOgKx5lvgxr
         dmAgZ+F4Jq4HZ5P3INtAFPTVQ/sCB6CpVKt/7Njt0HM7+2JFQRhh+223JvXKSyI+sH8n
         bFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=m6vJDTZh9Y+DWagifmx06cOkYlWeKqEnHAb9nbqa1eA=;
        b=RB63Gx1zisVppmnUigDYV1d+FLn03C1YR7XG2Yj/+qRYBMg3zEHR9gr5ObVR1/N/jA
         bxFFYTIZAHur+zOyPCkg9hCAomaOSODJx0VRNczEJh0kl4QoPjEVtUmHl6pvQ7MuB5BH
         IKoEWeVMGspzBteCgBA8QOqUPMEXZUAppQXkga9w40LwQUmNjcbxIE9nHEMMVVqp+aTy
         BPZlG9kfnZNblfQ7Q3iJNm1tyMuKCuGHGlv1coFamEv2uiaTHYRwlegDidvK2JBTNnYy
         EfClYg0vhZ2e753p/FwgSeEKNIKZ4TwT4BJDRYTku3OL0fGQZ6jZhrAvBPkcN7fUO5hZ
         0ZOg==
X-Gm-Message-State: AOAM530X8XU5/HnlQhdXwBH1sVF+NwwsSNOTkB13ObQ8b+dNWHCbOHqo
        QlG8Vp5DICxU+/JZmjC3o6dS2TJhp/s=
X-Google-Smtp-Source: ABdhPJz2JaYjQg+M5aZIzXLOM6Yt0ZXJrk6bikDyhR8ewjoF5usQ78BsWJrMhwWlVO57AGSylWfnzdGbc1U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:ecca:: with SMTP id o10mr7044437qvq.52.1619217250987;
 Fri, 23 Apr 2021 15:34:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 15:34:00 -0700
Message-Id: <20210423223404.3860547-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v3 0/4] KVM: x86: MSR_TSC_AUX fixes and improvements
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix potential cross-vendor landmines due to Intel and AMD having different
behavior for MSR_TSC_AUX[63:32], unify the logic across SVM and VMX, and
switch MSR_TSC_AUX via user return MSRs on SVM (the original goal).

v3:
  - Fix a comment typo. [Reiji]
  - Add patches to add missing guest_cpuid_has() check, drop bits 63:32 on
    AMD, and unify VMX and SVM emulation.
  - Rebase to kvm/next, commit c4f71901d53b ("Merge tag 'kvmarm-5.13' ... )

v2:
  - Rebase to kvm/queue (ish), commit 0e91d1992235 ("KVM: SVM: Allocate SEV
    command structures on local stack")
  - https://lkml.kernel.org/r/20210422001736.3255735-1-seanjc@google.com

v1: https://lkml.kernel.org/r/20210206003224.302728-1-seanjc@google.com


Sean Christopherson (4):
  KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP
    unsupported
  KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
  KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to guest CPU
    model
  KVM: SVM: Delay restoration of host MSR_TSC_AUX until return to
    userspace

 arch/x86/kvm/svm/svm.c | 58 +++++++++++++++++-------------------------
 arch/x86/kvm/svm/svm.h |  7 -----
 arch/x86/kvm/vmx/vmx.c | 13 ----------
 arch/x86/kvm/x86.c     | 34 +++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 54 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

