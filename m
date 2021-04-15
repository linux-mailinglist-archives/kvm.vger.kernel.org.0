Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57D361552
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhDOWVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhDOWVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:21:38 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FC5C061574
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id g186so2474696qke.23
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=idyJBHB3aj+yzlWK6cDPev1Rpg8zeSoDNtXngbtjsz4=;
        b=AZh7zKKHUCfrzkZWZ/vE2t7RwQ1yja5O9PUCkcECAY1mEd/FGtO7mtGxl7i/Trs0me
         mNt4tcvic4/HAMsK9m1FuKs88rViIm6MWc4VeQKZMLlsGDDlslg5ZIa0/wMgHOo4/Ozf
         WIDfgqoHY0+CdRlDEz+xAJfUR76aPM4qEbT0LVK/7/Q/UrvBPkQiA0dnTPXUbbxUCTTL
         T+/U28uiY5qkFjV6G3tLJ7P74lu8kTqnMC9Mpb/Gbdxf6ZzR0loNJQIqIL0d6CzkGi8Z
         YkL9Q5Md/3j1vELZNuE+2vV98dK3eVc8yMKVGbAFStESq99YYHoMxLKJxZTn5UKQMcGG
         l6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=idyJBHB3aj+yzlWK6cDPev1Rpg8zeSoDNtXngbtjsz4=;
        b=kCIvPDQe7x8MrGvFYJ1esyBeYpwrFlA3GZ6WzkMjkn3y9D7Pf2EkA5AoS4DTqSTp1r
         PI7XjNjtSNFftXcgdOFNiq14gv3lvTkIvKw2itAYKwbBIXvbZpCO6HMQbXmYeBQFSA4M
         /HA8s3utRsJQTRacmgeEigATlv19T3XYqtLH2z+K1Dd4qQvlAledzn8NVMMW9+yIT+Kj
         JWtPN6OEzTv4wunJulr5aE5KDzQshqpm6w8yLCSjpF44dtyVHswWHqiymBhHk2FIOXiA
         6tfc6kZZ3Rb0udm5aXyNr5/X5vdzvfh4L1kzAwQ+JT0DTmcrkz1kKKFARu2DlLp1KkNS
         CC6A==
X-Gm-Message-State: AOAM532eBz97iknq+GvtlDLIVU1QV5zKx6eMSj42H5MV2lv+ClRKuWjm
        UiAnxx4U0UOHs7meHmYG2Ebpsnaquio=
X-Google-Smtp-Source: ABdhPJyzq2DFbJV2Asv7A8wZh4pNHIG7vnTBd4k7SUprsKaon5I87ZlHqAwJcVNXzpddgQHCsOALUImGaec=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:a0c:d605:: with SMTP id c5mr5279271qvj.25.1618525273925;
 Thu, 15 Apr 2021 15:21:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:20:57 -0700
Message-Id: <20210415222106.1643837-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 0/9] KVM: Fix tick-based accounting for x86 guests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of Wanpeng's series[1] to fix tick-based CPU time
accounting on x86, with my cleanups[2] bolted on top.  The core premise of
Wanpeng's patches are preserved, but they are heavily stripped down.
Specifically, only the "guest exit" paths are split, and no code is
consolidated.  The intent is to do as little as possible in the three
patches that need to be backported.  Keeping those changes as small as
possible also meant that my cleanups did not need to unwind much 
refactoring.

On x86, tested CONFIG_VIRT_CPU_ACCOUNTING_GEN =y and =n, and with
CONFIG_DEBUG_ENTRY=y && CONFIG_VALIDATE_STACKS=y.  Compile tested arm64,
MIPS, PPC, and s390, the latter with CONFIG_DEBUG_ENTRY=y for giggles.

One last note: I elected to use vtime_account_guest_exit() in the x86 code
instead of open coding these equivalents:

	if (vtime_accounting_enabled_this_cpu())
		vtime_guest_exit(current);
...
	if (!vtime_accounting_enabled_this_cpu())
		current->flags &= ~PF_VCPU;

With CONFIG_VIRT_CPU_ACCOUNTING_GEN=n, this is a complete non-issue, but
for the =y case it means context_tracking_enabled_this_cpu() is being
checked back-to-back.  The redundant checks bug me, but open coding the
gory details in x86 or providing funky variants in vtime.h felt worse.

Delta from Wanpeng's v2:

  - s/context_guest/context_tracking_guest, purely to match the existing
    functions.  I have no strong opinion either way.
  - Split only the "exit" functions.
  - Partially open code vcpu_account_guest_exit() and
    __vtime_account_guest_exit() in x86 to avoid churn when segueing into
    my cleanups (see above).

[1] https://lkml.kernel.org/r/1618298169-3831-1-git-send-email-wanpengli@tencent.com
[2] https://lkml.kernel.org/r/20210413182933.1046389-1-seanjc@google.com

Sean Christopherson (6):
  sched/vtime: Move vtime accounting external declarations above inlines
  sched/vtime: Move guest enter/exit vtime accounting to vtime.h
  context_tracking: Consolidate guest enter/exit wrappers
  context_tracking: KVM: Move guest enter/exit wrappers to KVM's domain
  KVM: x86: Consolidate guest enter/exit logic to common helpers
  KVM: Move instrumentation-safe annotations for enter/exit to x86 code

Wanpeng Li (3):
  context_tracking: Move guest exit context tracking to separate helpers
  context_tracking: Move guest exit vtime accounting to separate helpers
  KVM: x86: Defer tick-based accounting 'til after IRQ handling

 arch/x86/kvm/svm/svm.c           |  39 +--------
 arch/x86/kvm/vmx/vmx.c           |  39 +--------
 arch/x86/kvm/x86.c               |   8 ++
 arch/x86/kvm/x86.h               |  52 ++++++++++++
 include/linux/context_tracking.h |  92 ++++-----------------
 include/linux/kvm_host.h         |  38 +++++++++
 include/linux/vtime.h            | 138 +++++++++++++++++++------------
 7 files changed, 204 insertions(+), 202 deletions(-)

-- 
2.31.1.368.gbe11c130af-goog

