Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DBF349F95
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhCZCU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhCZCUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFECC0613D7
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n13so8314236ybp.14
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TJ1NUSk1GLSfqgDLwJHTOvG8sJKDNqf4viNk18VjKYo=;
        b=EdH+MQMlq9K3NZE/QJpnecrIsQDbVa65LdQms8OUGXWWpfpYFJnuhWs2rq7TcHjpDq
         pCYtvjmoUxEHpN+E1h9PLwkdrJ1ALR7vaQ8K9DXsdjSZh2YseC5DINhzQQjMqaQmuGTA
         OtpKaXL9Fco/djGBD992n9sq6fKLeJ6eS4tl43w1X11oUNO4qUTS5nV8NpYLJopqKtBP
         JY+TUDHqJjicrZujGxNk5mBb6AgYo+xnomEiIKjkry8Rud1FrliNZgfyW9VqpygR6q4o
         askVlrUa0FZQhLta15P0aW9vXCsEoYuJLlz+qNgb18Lf5rX6GFjh/gWYd+LcigWG7nHX
         IWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TJ1NUSk1GLSfqgDLwJHTOvG8sJKDNqf4viNk18VjKYo=;
        b=ogePzTOHcbtHwdwqjdevuso3UUJPgkpGIIsGthbTlwWONd6w4btlTtQR2bcfxedenk
         jLmhK1gGM1fIvtVjxqEhuZ7z+Bc2l1ul8Vb7WPbOHUNTpxS2n6exhMxvegURNYe1PVhk
         Jd6QSlJxdV+/OaaB3drpxQH0+CFyqU8wzL/hnORKfJuZs4MUQDXyqfZqh9jJp2UdvNwO
         I9GgUe+xlFLfvmmn+zxfHIqL8OqITkKFxZPSvkOsDi8JONcI84nTWbnwfXfxBZ07KCOD
         nAlt7g4Rt03H2CVIfher6X8eGP4fmAFiQED7Atj5mlDHzZZ6DN+uggb5FtUYJ0Bvm709
         acjw==
X-Gm-Message-State: AOAM532xH1GnPYoMY4MQ412LMowOlTyl4xZGnc6eZaDtWDlxDmyhJnZG
        2T2maODaLy+OWkUZaYn0Ls/6ne9ceEE=
X-Google-Smtp-Source: ABdhPJyjTzhMUsvBcDeO5HnO1o8pMJu/Pf6cqTV1gYjxP6rrgfWVB7Wh+dDzlNrLO5iiBOh2qPwlx8SGkDg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:d44f:: with SMTP id m76mr17466319ybf.101.1616725229004;
 Thu, 25 Mar 2021 19:20:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:47 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 08/18] KVM: Move prototypes for MMU notifier callbacks to
 generic code
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the prototypes for the MMU notifier callbacks out of arch code and
into common code.  There is no benefit to having each arch replicate the
prototypes since any deviation from the invocation in common code will
explode.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   | 5 -----
 arch/mips/include/asm/kvm_host.h    | 5 -----
 arch/powerpc/include/asm/kvm_host.h | 7 -------
 arch/x86/include/asm/kvm_host.h     | 6 +-----
 include/linux/kvm_host.h            | 8 ++++++++
 5 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..72e6b4600264 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,11 +582,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 3a5612e7304c..feaa77036b67 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,11 +967,6 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 05fb00d37609..1e83359f286b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -56,13 +56,6 @@
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
-extern int kvm_unmap_hva_range(struct kvm *kvm,
-			       unsigned long start, unsigned long end,
-			       unsigned flags);
-extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-
 #define HPTEG_CACHE_NUM			(1 << 15)
 #define HPTEG_HASH_BITS_PTE		13
 #define HPTEG_HASH_BITS_PTE_LONG	12
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..99778ac51243 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1718,11 +1718,7 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_cpu_has_extint(struct kvm_vcpu *v);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1b65e7204344..e6d77353025c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -218,6 +218,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
+#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end, unsigned flags);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+#endif
+
 enum {
 	OUTSIDE_GUEST_MODE,
 	IN_GUEST_MODE,
-- 
2.31.0.291.g576ba9dcdaf-goog

