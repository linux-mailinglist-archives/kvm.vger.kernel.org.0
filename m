Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195D73C74A9
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhGMQgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbhGMQgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794DC061788
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h7-20020a5b0a870000b029054c59edf217so27712991ybq.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TUihYYZX01zOKRYdFMaN5OLTZeUf4zUielfX3s9wDnE=;
        b=Dhw50de7+3iQD4SG+Jz/qLL69yJiabJyBAj5H5B7E3+UMuR2CyUW8NfEstP/fOuRRc
         mEf9TpUF8eo/vMnIZJA61FPtKnpR+g9c1bnT6FCBvW03iGvbh9ZAve+TVdOOoekYWcc3
         u/GRtrv7FQvpaPNjH0LK6SsgJ/Cd7BLOyAHTCGvHNVDnxFvIr+QZmwfZrXsXyjBM0Vvs
         berGIXOUWIrmoXTgV3U3Mb++Zrzn8H/k/ZRWI1g7ZciER+Q13T0wQx3cX5RkiMV990g6
         6c8Mi33kyQaz5AFnhpmrBAJdxk/3SLLpL5IAdfWzk0mWjqpENbWekjHuseVx3H0Lul5z
         oQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TUihYYZX01zOKRYdFMaN5OLTZeUf4zUielfX3s9wDnE=;
        b=Hp2Fc12iv7/eM5+6iqeJX+XRnLVxEzuSuJv2FlJkwEfubDswodU2b2ObsI92PAfkTu
         sqhTqQYkhHTm8Y5rKcENwu7QF+4uW0cUdmhBjZFxbjIkW0F0/F1t2APXTxIyu2fNaR+9
         1w5lgHa6NeKGgyeSp5kpVLBmuE3NMlNeWDOZlJqWXejMWHf8mcDstt/RZvakIEDngWH/
         oNx94MiVDgbqeJUzDRR33nh1ini7ZXsidnLOQYCf5cVDCkaWpdiugB7dGV2jKDcIh9nS
         G4EuDNn2IiIgRFzdP36qbdJydo2hKIZgXKqIjrIYWhdq3peGi4YQmKv8kOPEG7Ht21sa
         +LbA==
X-Gm-Message-State: AOAM532kdqexH2ZNUVIrkFBtWrsC8EB2e+gLBvnbIvFvyT1m1yrQHE1c
        44s7Lgfl42gB5onBDh/HekkLAyphCfs=
X-Google-Smtp-Source: ABdhPJweObVAAyzT25jnRiOd8aMiD8irO4yT89qYPN61ugodwuG6JmENd4I3SPiS4n83/LNgs+BVfFp2o/s=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:8208:: with SMTP id q8mr7275091ybk.378.1626194026059;
 Tue, 13 Jul 2021 09:33:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:44 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 06/46] KVM: SVM: Fall back to KVM's hardcoded value for EDX
 at RESET/INIT
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

At vCPU RESET/INIT (mostly RESET), stuff EDX with KVM's hardcoded,
default Family-Model-Stepping ID of 0x600 if CPUID.0x1 isn't defined.
At RESET, the CPUID lookup is guaranteed to "miss" because KVM emulates
RESET before exposing the vCPU to userspace, i.e. userspace can't
possibly have done set the vCPU's CPUID model, and thus KVM will always
write '0'.  At INIT, using 0x600 is less bad than using '0'.

While initializing EDX to '0' is _extremely_ unlikely to be noticed by
the guest, let alone break the guest, and can be overridden by
userspace for the RESET case, using 0x600 is preferable as it will allow
consolidating the relevant VMX and SVM RESET/INIT logic in the future.
And, digging through old specs suggests that neither Intel nor AMD have
ever shipped a CPU that initialized EDX to '0' at RESET.

Regarding 0x600 as KVM's default Family, it is a sane default and in
many ways the most appropriate.  Prior to the 386 implementations, DX
was undefined at RESET.  With the 386, 486, 586/P5, and 686/P6/Athlon,
both Intel and AMD set EDX to 3, 4, 5, and 6 respectively.  AMD switched
to using '15' as its primary Family with the introduction of AMD64, but
Intel has continued using '6' for the last few decades.

So, '6' is a valid Family for both Intel and AMD CPUs, is compatible
with both 32-bit and 64-bit CPUs (albeit not a perfect fit for 64-bit
AMD), and of the common Families (3 - 6), is the best fit with respect to
KVM's virtual CPU model.  E.g. prior to the P6, Intel CPUs did not have a
STI window.  Modern operating systems, Linux included, rely on the STI
window, e.g. for "safe halt", and KVM unconditionally assumes the virtual
CPU has an STI window.  Thus enumerating a Family ID of 3, 4, or 5 would
be provably wrong.

Opportunistically remove a stale comment.

Fixes: 66f7b72e1171 ("KVM: x86: Make register state after reset conform to specification")
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12e49dc16efe..7da214660c64 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1277,7 +1277,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	save->cr4 = X86_CR4_PAE;
-	/* rdx = ?? */
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
@@ -1359,7 +1358,15 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 	init_vmcb(vcpu);
 
-	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true);
+	/*
+	 * Fall back to KVM's default Family/Model/Stepping if no CPUID match
+	 * is found.  Note, it's impossible to get a match at RESET since KVM
+	 * emulates RESET before exposing the vCPU to userspace, i.e. it's
+	 * impossible for kvm_cpuid() to find a valid entry on RESET.  But, go
+	 * through the motions in case that's ever remedied, and to be pedantic.
+	 */
+	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
+		eax = get_rdx_init_val();
 	kvm_rdx_write(vcpu, eax);
 
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
-- 
2.32.0.93.g670b81a890-goog

