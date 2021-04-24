Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3124369E0E
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244472AbhDXAvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244470AbhDXAtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:49:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B97C061363
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c1-20020a5b0bc10000b02904e7c6399b20so26348086ybr.12
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ybux/4YslnMEYEZsvkcGPcqviW6S9OYK5jonptQyC4I=;
        b=n131qTWJCuWa04F4oe/3zu7xSR7HCmvR/RjU/3fY9RqKUdbO5EOJoN1M9/J4pd8A6J
         1E1lRubsGs7E2kBG1YxPkF4VPlN1Jn7mZd1l3+UUvHisjWJB+6SmEHaumw3zglONg9vX
         0NAgrjMgC5gAYnf89al/eiJPhFA/YwcYdoOe9Fd1TeBFkivvrtYlj3JC5WqB9C1kdObb
         OJZB4Yc2GB22sYAlYhzmfBz1r94xKrkPOgxFoON73t6nw9+6Yp+YtB20u768tvdkz310
         Pi7Wun0oZc0rel4564fvhXVkolzMGmGXIldyNEeX0NWOr450PnCTWY97ha2lJ4xyfQTK
         f/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ybux/4YslnMEYEZsvkcGPcqviW6S9OYK5jonptQyC4I=;
        b=dmqy39uvZXmw3SRa7ssPcBI56e7zuBPnhzJ+W6ZdQBleSQL5xtg5dm8mZ6rNBdNSZr
         dA9vpCRjJOgRS1JDych2fIHA+W15DO89xO6Ua2wp6H/R17YggdoEUV/P+npf+bXfqZY+
         q88wUikE2C0/hfXDDXhhv98hrDOnt8IJrlXiLRyqStQ+zZTKmD87hQ/FR9wLd7a8CxMb
         Lf10V/AlW6JX6aPg5fJrfITktcnXesMF8or+1nLWgIVfXnqw/qvwFVLSbR+uO6ArnSAm
         M9Xr3KLeyndkkYiabk/onnm1Gg73tWoUuB3/UPmvXd+hh4kffSew8vb6WtBbtUcqquNR
         frew==
X-Gm-Message-State: AOAM531VIFRB1ArUfnOKHe+eOSfwoacNg9Z9OuQ10n+9wZRcJVw+OAJy
        crpFQeaYbDhy+uLfI8TmaE9zymQJfzA=
X-Google-Smtp-Source: ABdhPJyNpvOlFlK5nKkndMFN0zoAPRak6kIWE7dUUTmKDCl8k11TIMKl+UTWyXpWoIjH+UpQIIwz0khh63A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:8143:: with SMTP id j3mr9160217ybm.237.1619225261741;
 Fri, 23 Apr 2021 17:47:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:21 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-20-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 19/43] KVM: x86: Move EDX initialization at vCPU RESET to
 common code
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

Move the EDX initialization at vCPU RESET, which is now identical between
VMX and SVM, into common code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 -----
 arch/x86/kvm/svm/svm.c          | 13 -------------
 arch/x86/kvm/vmx/vmx.c          |  6 ------
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 4 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e5fc80a35c8..2b9799366dad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1701,11 +1701,6 @@ static inline unsigned long read_msr(unsigned long msr)
 }
 #endif
 
-static inline u32 get_rdx_init_val(void)
-{
-	return 0x600; /* P6 family */
-}
-
 static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 {
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271b6def087f..5c12ba725186 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1283,25 +1283,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 dummy;
-	u32 eax = 1;
 
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
 	init_vmcb(vcpu);
 
-	/*
-	 * Fall back to KVM's default Family/Model/Stepping if no CPUID match
-	 * is found.  Note, it's impossible to get a match at RESET since KVM
-	 * emulates RESET before exposing the vCPU to userspace, i.e. it's
-	 * impossible for kvm_cpuid() to find a valid entry on RESET.  But, go
-	 * through the motions in case that's ever remedied, and to be pedantic.
-	 */
-	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
-		eax = get_rdx_init_val();
-	kvm_rdx_write(vcpu, eax);
-
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40a4ac23d54f..805888541142 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4490,7 +4490,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 eax, dummy;
 	u64 cr0;
 
 	if (!init_event)
@@ -4501,11 +4500,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	eax = 1;
-	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
-		eax = get_rdx_init_val();
-	kvm_rdx_write(vcpu, eax);
-
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b87193190a73..167c650d1187 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10416,6 +10416,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
+	u32 eax, dummy;
 
 	kvm_lapic_reset(vcpu, init_event);
 
@@ -10482,6 +10483,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
+	/*
+	 * Fall back to KVM's default Family/Model/Stepping of 0x600 (P6/Athlon)
+	 * if no CPUID match is found.  Note, it's impossible to get a match at
+	 * RESET since KVM emulates RESET before exposing the vCPU to userspace,
+	 * i.e. it'simpossible for kvm_cpuid() to find a valid entry on RESET.
+	 * But, go through the motions in case that's ever remedied.
+	 */
+	eax = 1;
+	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
+		eax = 0x600;
+	kvm_rdx_write(vcpu, eax);
+
 	vcpu->arch.ia32_xss = 0;
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
-- 
2.31.1.498.g6c1eba8ee3d-goog

