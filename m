Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0C369DEC
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244194AbhDXArz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbhDXArs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:48 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C61C061756
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:09 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h22-20020a05620a13f6b02902e3e9aad4bdso11558051qkl.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Z23zPQAgxlBigLhFQaq/Iwh63wl+bRNTg9ZoEclpoEQ=;
        b=SWsFp/9EiXizbzTZHrHr0qgh4MJgPmOaDWL3ZJFP7m6lSN0+Oc4/yRfnkMabUXBbO8
         rrPWAtC/mzWxZlqtyksyKvjwtdZ6W4jL96KxqfaPjk8N4mxYETzupFdQgq7p7PZ3pXTi
         vGgmGYA1EDadD+YakYmwdBZILiSbwl/3hMaITsMCr9utLlKPjkUWBMiYa/CKEKoe3eiu
         ZKujj+e+blJrpSXrFco3lN84sEvEejoq9HVR78JJmEAa+HX3tn3+ZJK2wA9hymcKfp++
         RtBF3/69GAczeXPMUbVIJQFWveCrfDknw3pN8A8mInXKqOoBDP/THOWRvRh8P9Ft/A4j
         XSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Z23zPQAgxlBigLhFQaq/Iwh63wl+bRNTg9ZoEclpoEQ=;
        b=QzQGd12I061t6n1KGVNibm4XYAk1xnkObmOkogPogK5lSndIo+mNhBG8We/Y2wbZe7
         3QVFPDR5dM+mh6Lffcz+qBDj9XtyEwDxabea4ATnp7fvbJWUx8SSNxv0TgO1NZIPlAYp
         y+m4nGRBlikduRlBUFozGiNOTR98uYQOLca34jwcGpMg04mRdWWTvkNOauQMvfbl08Kx
         Upl2PDJMhG/n1PHhydGVye4ptwE7lLSDgf236uM0RqPBY1Nsn1xY/ZLnukzBx7yS9Fnr
         nGlfzAsxVeOGjZ4EIeOVgfz5P0sanghZYowg91bZwu6/L8w3E7mtAa+zF8wsUPTtyEsC
         HKSQ==
X-Gm-Message-State: AOAM531F/3TIN6b4GIm+gsYwSX8V2Bcu3hR4p+rRP/HWCpMvInSMmHIG
        /hkcZVw92y+Y+ZbvewOV5Lhtr4tikdY=
X-Google-Smtp-Source: ABdhPJwL+caeGee5q5H1DwGy2Zp+KrNbEV1OdzbTDu+pWbDKkegIYuDBsNf+879sZmeGGLjrZGJLv0D5FB0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a05:6214:88d:: with SMTP id
 cz13mr7404534qvb.13.1619225228657; Fri, 23 Apr 2021 17:47:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:06 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 04/43] KVM: SVM: Fall back to KVM's hardcoded value for EDX at RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b9e3229ddc27..d4d7720ce42f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1219,7 +1219,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	save->cr4 = X86_CR4_PAE;
-	/* rdx = ?? */
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
@@ -1299,7 +1298,15 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
2.31.1.498.g6c1eba8ee3d-goog

