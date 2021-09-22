Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10676413E65
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhIVAIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhIVAHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:07:46 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BC6C0613E5
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:08 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h25-20020a0cab19000000b0037a49d15c93so6853368qvb.22
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QkPwm3zvrM5/6qTUHoNNLSAbgPAl2i0gmFlu0epOg4o=;
        b=d1KD92GmsPFOnc9Voj9I1ga0GeAS7/A1M3Ff0hwfVHHw2F6NmCxAZ84UfNg13BcPCi
         lG4uDVWzzMX9YcA/y1gf96xoTBNuPhAlxwTx2TA/MtTqi0CKnLCaTn1XKcjET/qIHw/W
         PFtn2f+5xRKyIIgk8E1s1kBonYCZbxSjMNPx2Pcoaxli0kTn68s/Bp75u+cWhB/zdDT2
         joJ0rxsuthSJgBA//ri2dU4acF1OCR0lq3uBlgPA2WynVs0lVsjJioXNEExBFYXBNxT3
         Bx/JzoAA/ewtVFiSqKGlN2hvDgXry2asA82RE64+sST1QDa4vg0dMxQ7kXfb5GF5+5GY
         /rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QkPwm3zvrM5/6qTUHoNNLSAbgPAl2i0gmFlu0epOg4o=;
        b=eHxJYnhxhSD2BmtpMuAJ1wTcPlmhd5qQ957x1AG8B2YoCxTxDNNl0DlKBelpz1rbsx
         vUwYCjOMfVkL09jbv8YdBAE9ihaptMA5nl7yl0e62QilyQLs7Xp2gWuCMRllUzFxJxF5
         oKsg+wP5IEYdr28Qrvz6TzY5yJ/euxCpX7M3wXLcvYo8pub62dBfxG21Oo2Yz+OTycGe
         ANEjc6XRpwKcisEQLi0jED8P8sv501qBlKx8bTSGWLlCXrbHb8FAk6sBbjoYCIvvw5Cb
         ND3MGDHpISTM/OzbQdTps0749bOWb/nqTE4cdb8VDyVg20thagGrZbymtalLfJF082mO
         ZsrA==
X-Gm-Message-State: AOAM532BGn/7cx2qJsudhhNsQtfMNxnlamGyUhvD0+PuN7yHqgl8moi3
        N+6KRdANaH4wwSDVmrk4aaAuxXvjJm4=
X-Google-Smtp-Source: ABdhPJwFZxN2Kv1ibh5ZHwIVIA/ukWkfcwWerZdycqHkme9lr0IiGpVtUFqWcbWB5ZsvLCpW/DgRz3yzrYw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:ad4:4a93:: with SMTP id h19mr34366283qvx.41.1632269167312;
 Tue, 21 Sep 2021 17:06:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:28 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 11/16] KVM: x86: More precisely identify NMI from guest
 when handling PMI
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Differntiate between IRQ and NMI for KVM's PMC overflow callback, which
was originally invoked in response to an NMI that arrived while the guest
was running, but was inadvertantly changed to fire on IRQs as well when
support for perf without PMU/NMI was added to KVM.  In practice, this
should be a nop as the PMC overflow callback shouldn't be reached, but
it's a cheap and easy fix that also better documents the situation.

Note, this also doesn't completely prevent false positives if perf
somehow ends up calling into KVM, e.g. an NMI can arrive in host after
KVM sets its flag.

Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  4 +++-
 arch/x86/kvm/x86.c     |  2 +-
 arch/x86/kvm/x86.h     | 13 ++++++++++---
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..0a0c01744b63 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,7 +3843,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_before_interrupt(vcpu);
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f19d72136f77..61a4f5ff2acd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6344,7 +6344,9 @@ void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 					unsigned long entry)
 {
-	kvm_before_interrupt(vcpu);
+	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
+
+	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
 	vmx_do_interrupt_nmi_irqoff(entry);
 	kvm_after_interrupt(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24a6faa07442..412646b973bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9676,7 +9676,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * interrupts on processors that implement an interrupt shadow, the
 	 * stat.exits increment will do nicely.
 	 */
-	kvm_before_interrupt(vcpu);
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	local_irq_enable();
 	++vcpu->stat.exits;
 	local_irq_disable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a9c107e7c907..9b26f9b09d2a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,9 +387,16 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
+enum kvm_intr_type {
+	/* Values are arbitrary, but must be non-zero. */
+	KVM_HANDLING_IRQ = 1,
+	KVM_HANDLING_NMI,
+};
+
+static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
+					enum kvm_intr_type intr)
 {
-	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 1);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);
 }
 
 static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
@@ -399,7 +406,7 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_handling_nmi_from_guest(struct kvm_vcpu *vcpu)
 {
-	return !!vcpu->arch.handling_intr_from_guest;
+	return vcpu->arch.handling_intr_from_guest == KVM_HANDLING_NMI;
 }
 
 static inline bool kvm_pat_valid(u64 data)
-- 
2.33.0.464.g1972c5931b-goog

