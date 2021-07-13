Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A3B3C74C4
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhGMQhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhGMQhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEF6C0617A7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x15-20020a25ce0f0000b029055bb0981111so27835773ybe.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZGE0Ud/qVCZnk8Jm0n4NdfNCnKEFqwV9kF+jzCOxReM=;
        b=eJE/vsjdoIjKg0l/fefgluUoqMn1tp8SQbilZDd1BIAdea2s9uik2rUcU1yJtYlmaU
         nUVojmJULs7MYLUu7Kuq0hULFwA5xjoU+9R2N1LRwBdYUlECLFOIFApwpOsC6q+0n6+L
         /MOSbc0J72hfumxHjNz8NyQPb+s1lSgOY3KQSmUUZkxn6jTLNsp8hxAlsz5c11N0mcuc
         IqG6+6+R5+hmeyfZ44Q1cu9vXCgA6HGao//Zhb5yOwVFbQ8M6RqETRRSuwN210UvRRTg
         g3+Ne7Qjj4SkShboKxugnosuwXj40arzmFzyT1Ysjv2Gn0xw3C1A2aDCXvelTmflOe1N
         /HBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZGE0Ud/qVCZnk8Jm0n4NdfNCnKEFqwV9kF+jzCOxReM=;
        b=ZHak6nnyG6/mVEzPJXonrAc2tl51nafX43ti+wOI59+3VRGofbtK5FQB0gjwJ7JgUG
         vU4gnqe7jve/+okH89cpu5cF3trMud6OzkX/4uSM7q2tVyMT0iN+hqB28lwa3hmHMoTg
         xQV8bQSt6EDpY6rpfv5hHPHHh5O4uIROCVC1qqh+OaXod+znKgOM3hEB7W2+JeziAu01
         n3UxI6j/G48JPdsI2DDC63d1Tx7W0U5JzlVOlEB1m4Bkqx2vCxhVqUwrHcz/NZ4qzSrP
         BL45SFBboOcnZDQ7bq8hNP5qk0AUchAPlwX/C4VCClnhY5SFCk2xLcSr3R4dURG5N52V
         diMg==
X-Gm-Message-State: AOAM533byO/VoGbjDHeVozNX5xczLIv9EpX5sksE1Ui7BS7KY+H450Eq
        mSxXwxee658XFxGRQIErgxKhGbTUbHI=
X-Google-Smtp-Source: ABdhPJwxjBtS/4+vWcO0fWKUNC/RdbMGpPpcjqp9zN0/Nc25SyYzwzdI0AiObIIA5+t7C6z3KURNPGbhH50=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:b790:: with SMTP id n16mr7108901ybh.274.1626194049930;
 Tue, 13 Jul 2021 09:34:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:57 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-20-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 19/46] KVM: x86: Move EDX initialization at vCPU RESET to
 common code
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

Move the EDX initialization at vCPU RESET, which is now identical between
VMX and SVM, into common code.

No functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 -----
 arch/x86/kvm/svm/svm.c          | 13 -------------
 arch/x86/kvm/vmx/vmx.c          |  6 ------
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 4 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..0ec988778db1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1772,11 +1772,6 @@ static inline unsigned long read_msr(unsigned long msr)
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
index f7486b1645de..268580713938 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1343,25 +1343,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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
index ff82c05b948b..f506b94539ab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4387,7 +4387,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 eax, dummy;
 	u64 cr0;
 
 	if (!init_event)
@@ -4398,11 +4397,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	eax = 1;
-	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
-		eax = get_rdx_init_val();
-	kvm_rdx_write(vcpu, eax);
-
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ffc4ca7d7b0..fd9026437fdd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10787,6 +10787,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+	u32 eax, dummy;
 
 	kvm_lapic_reset(vcpu, init_event);
 
@@ -10853,6 +10854,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
2.32.0.93.g670b81a890-goog

