Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95E1310212
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhBEBFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhBEA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:58:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3354EC06178C
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:57:57 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c13so5079247ybg.8
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=vymoThU2kZn6CShsxR9WgxAmamCnipq0tqheseyfNyU=;
        b=Ls6BzEgdqejASEjV5/w5AR50u/CZv61muIlLt0GQ2ojWO8i6hGBynOEZSDArnF1FzR
         2dbSfZwv6ZH5DQJwlNtMVei5B2XPvH00Xf3MQVCILq8o/LOYc7lC+2ezPIbY8g/oquMJ
         lac7TBntrO1Pl/+k2ssdsV/HedQ3dcQFVaD9GoQjlA1Ws7RXoW6Z3BmKto++IhtYyJ95
         k19hNhtCG3eiUOf6eTCaCnEg9eloccV/hbKQQimEOTALzXi1BzexD6Z5WF9IDYwGYUua
         L3bt92kLWSzWLiwzc1B1RwU4fIpuqy7PBELd4bZAjC5Q1p536+uvUTH+B6w0n/ovxEkl
         14Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=vymoThU2kZn6CShsxR9WgxAmamCnipq0tqheseyfNyU=;
        b=tlGfMLVVNa/IRj+aI5Jbo8ksF9Nt7xD5sQ6KX7JZrSrvPtYiiDfj1/n3iKSm+n3iyS
         fFjfXSdySxEHFePTybM2qroW8B85byIA3jUHpQBQTK0xAgksgUHZzbxyhX34z50AiUPQ
         gkECbtz0yynFEtKWzD0PyAA/sKHTyyjAuWxp/ruj3X6lIA+hu1k/65XodJV++wBoZYL0
         CzB9zcLOcG7V2gIQm3WJC/cLajcNBGjgOk/0Ac8cQ78oLtEgLo1Cyt0TUFli7ep5G7WO
         yJhKdhSM4RugFlplDckAkzY5Dm3/aozffwl7+ncjIY7x/HA0RNo5HfpZ1deL+NlEvjrD
         DjBg==
X-Gm-Message-State: AOAM532hC7zrRZ2x+by0ymf7t9MkXNpbCKOPY0p5BIxDCNolYJ5Tc6pe
        q0oScFXyLgaZEAKI8YcI2ZXbTAwtrJY=
X-Google-Smtp-Source: ABdhPJxr2ZiQHdnP7iWR5rwAXD71zSddwZf08dhGIlcnW8ER/PinIIsK1p3Q4oaWC7eOshYMG7efHowQF5k=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:782:: with SMTP id 124mr307947ybh.53.1612486676355;
 Thu, 04 Feb 2021 16:57:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:41 -0800
Message-Id: <20210205005750.3841462-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 0/9] KVM: x86: Move common exit handlers to x86.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main focus of this series is moving common exit handlers to x86.c,
to avoid duplicate code between SVM and VMX, and also to help prevent
silly divergences between SVM and VMX.

Except for patch 03, which is absolutely grotesque, the changes are
relatively small.

To allow wiring up the common handlers directly to SVM's exit handler
array, patch 03 changes the prototype for SVM's handlers to take @vcpu
instead of @svm.  That created a cascade effect where many helpers were
doing pointless conversions from vcpu->svm->vcpu, and cleaning up those
snowballed into a broader purging of svm->vcpu.  There are still quite a
few instances of svm->vcpu, but the ones remaining are at least
reasonable.  E.g. patterns like this were fairly common (though this was
the most egregious).

        static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
        {
                struct vcpu_svm *svm = to_svm(vcpu);

                return !!(svm->vcpu.arch.hflags & HF_NMI_MASK);
        }

        static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
        {
                struct vcpu_svm *svm = to_svm(vcpu);

                if (masked) {
                        svm->vcpu.arch.hflags |= HF_NMI_MASK;
                        if (!sev_es_guest(svm->vcpu.kvm))
                                svm_set_intercept(svm, INTERCEPT_IRET);
                } else {
                        svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
                        if (!sev_es_guest(svm->vcpu.kvm))
                                svm_clr_intercept(svm, INTERCEPT_IRET);
                }
        }

This is based on kvm/queue, commit 4edbfa87f4f4 ("KVM: X86: Expose bus lock
debug exception to guest").  It should also apply fairly cleanly on
kvm/nested-svm, commit f8a5f661936a ("KVM: nSVM: Trace VM-Enter consistency
check failures").

Paolo, I based this on kvm/queue under the assumption it can all wait until
5.13.  I don't think there's anything urgent here, and the conflicts with
the stuff in kvm/nested-svm are annoying.  Let me know if you want me to
rebase anything/all to get something into 5.12, I know 5.12 is a little
light on x86 changes :-D.

Sean Christopherson (9):
  KVM: SVM: Move AVIC vCPU kicking snippet to helper function
  KVM: SVM: Remove an unnecessary forward declaration
  KVM: SVM: Pass @vcpu to exit handlers (and many, many other places)
  KVM: nSVM: Add VMLOAD/VMSAVE helper to deduplicate code
  KVM: x86: Move XSETBV emulation to common code
  KVM: x86: Move trivial instruction-based exit handlers to common code
  KVM: x86: Move RDPMC emulation to common code
  KVM: SVM: Don't manually emulate RDPMC if nrips=0
  KVM: SVM: Skip intercepted PAUSE instructions after emulation

 arch/x86/include/asm/kvm_host.h |   9 +-
 arch/x86/kvm/svm/avic.c         |  57 +--
 arch/x86/kvm/svm/nested.c       | 119 +++---
 arch/x86/kvm/svm/sev.c          |  27 +-
 arch/x86/kvm/svm/svm.c          | 629 ++++++++++++++------------------
 arch/x86/kvm/svm/svm.h          |  12 +-
 arch/x86/kvm/vmx/vmx.c          |  74 +---
 arch/x86/kvm/x86.c              |  62 +++-
 8 files changed, 447 insertions(+), 542 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

