Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8C3413E5F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhIVAIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhIVAHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:07:38 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F48AC0613D9
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:06 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 70-20020aed20cc000000b002a69b3ea30aso4992550qtb.15
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AVVcTJjDaboxmrWd01mlihP+thyDmwt+Wb6UJcWJ0SA=;
        b=qnB3SQiaaF6WC9mC3PxEeBeR+5lv1WF2OZ5dAEYuga9do3ZxizL42FhUWbNnGQsLJy
         kFlr7gl1wrMF1pi+KoC28DCxMnwiq7dfm7LkdmgwbfFIj+yZF87g+RiucCIIlaGk9z2L
         ul3JXkYMG1M7a8Mo36cpf3Rry/Wo1HIBeW17Zi62PJjYFnKdmXhaubK0jiBQ5d6UqeTU
         1+L7Uftzwd0fGoYUuho0kFZqMWYiIl8q0A+4IRcVGFEDRYPi1z57sEg8moGTEmHEg6dI
         5vqXyNGrS9ZLp2cByIwk1QgXLXs643+yydpAgPnozKp/YE6+BzivoiQrohhBs0bP0EIW
         FUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AVVcTJjDaboxmrWd01mlihP+thyDmwt+Wb6UJcWJ0SA=;
        b=2bnrk8pp5kF8ZI7J5zt8rszJzQ7o3RQX4FRM8GRt3dWdZw+ooADVQCGjs4qtmLjqcC
         qwu9RBivNqAO1m27UzS6aSG1sBgbgfF4bvWheWLzAadefXtWLL0Ch9425RL0vEETS1uD
         uhsUPMOwmaBeNeO/mhFpGORrXlU728erkcnZhDhfXIg6gRPDIqS9q8EVaHnY0qnaS7+0
         RlUVS3IkwkXglIbcMJLMdd/nG0YC+isAi83eTqNib9AHtpDHMF8Ts0F+8lRiKhuqMPlz
         gPt7u7vXwW3BtQGyszvvklY93QyGl48gfu0RDComYT6dCq1Sjm9Ur1lNvSlh9FcF4YWB
         C00A==
X-Gm-Message-State: AOAM531Mi0r9xn/CosckB1NdWVYlCmLYHYIrcXhQl3hBNmigFP84YuFd
        Dv2v2S5c6jGdNiW8rq7N5ZPpJ7axqi4=
X-Google-Smtp-Source: ABdhPJx1BhnGeS4TuFK4bgjBOJbTLeLAb6P4HGUosvLJGU/FqZfGimhs446IdcpbQjbCIE0AbY4YgA9+Mxg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1430:: with SMTP id
 o16mr30643490qvx.66.1632269165263; Tue, 21 Sep 2021 17:06:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:27 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 10/16] KVM: x86: Drop current_vcpu for kvm_running_vcpu +
 kvm_arch_vcpu variable
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

Use the generic kvm_running_vcpu plus a new 'handling_intr_from_guest'
variable in kvm_arch_vcpu instead of the semi-redundant current_vcpu.
kvm_before/after_interrupt() must be called while the vCPU is loaded,
(which protects against preemption), thus kvm_running_vcpu is guaranteed
to be non-NULL when handling_intr_from_guest is non-zero.

Switching to kvm_get_running_vcpu() will allows moving KVM's perf
callbacks to generic code, and the new flag will be used in a future
patch to more precisely identify the "NMI from guest" case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/x86.c              | 21 ++++++++++++---------
 arch/x86/kvm/x86.h              | 10 ++++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1080166fc0cf..2d86a2dfc775 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -763,6 +763,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	u8 handling_intr_from_guest;
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -1874,8 +1875,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-unsigned int kvm_guest_state(void);
-
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5b68d4188de0..eef48258e50f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_guest_state())
+		if (!kvm_handling_nmi_from_guest(pmc->vcpu))
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6cc66466f301..24a6faa07442 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,15 +8264,17 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
+static inline bool kvm_pmi_in_guest(struct kvm_vcpu *vcpu)
+{
+	return vcpu && vcpu->arch.handling_intr_from_guest;
+}
 
-unsigned int kvm_guest_state(void)
+static unsigned int kvm_guest_state(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	unsigned int state;
 
-	if (!vcpu)
+	if (!kvm_pmi_in_guest(vcpu))
 		return 0;
 
 	state = PERF_GUEST_ACTIVE;
@@ -8284,9 +8286,10 @@ unsigned int kvm_guest_state(void)
 
 static unsigned long kvm_guest_get_ip(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	if (WARN_ON_ONCE(!vcpu))
+	/* Retrieving the IP must be guarded by a call to kvm_guest_state(). */
+	if (WARN_ON_ONCE(!kvm_pmi_in_guest(vcpu)))
 		return 0;
 
 	return kvm_rip_read(vcpu);
@@ -8294,10 +8297,10 @@ static unsigned long kvm_guest_get_ip(void)
 
 static unsigned int kvm_handle_intel_pt_intr(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!vcpu)
+	if (!kvm_pmi_in_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d66d63dc55a..a9c107e7c907 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,18 +387,20 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
 {
-	__this_cpu_write(current_vcpu, vcpu);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 1);
 }
 
 static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 {
-	__this_cpu_write(current_vcpu, NULL);
+	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);
 }
 
+static inline bool kvm_handling_nmi_from_guest(struct kvm_vcpu *vcpu)
+{
+	return !!vcpu->arch.handling_intr_from_guest;
+}
 
 static inline bool kvm_pat_valid(u64 data)
 {
-- 
2.33.0.464.g1972c5931b-goog

