Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842FE44CFB9
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 03:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhKKCL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 21:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbhKKCK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 21:10:59 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFA8C06120B
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:57 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id p123-20020a622981000000b004a00d95bb44so3115257pfp.0
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Lyt/rTDjGnKoutcwJre3yNnjqLDOGX/x3OkYu61FqOk=;
        b=I8XIHSvwNQ1fcpkSdsGc4AiCdO+YuaQlW3RXJZULkdkHSVSpiSB2z5tzowllmJ+Tdh
         VAXBm73ZsKSWwoJMRNxrsMKG+icBCC6PildLyn4ZRrgxZFW7lw+uDQaRe13J0ZYYFICw
         RY/Ms9WJCbbSEl49Bxj866E13R0XzMlHdhSmaskdgLqSdcLwszfqInJfpHSHPuytmZSx
         BsgHHmWeayoYirawUXu3l+QK3yaTIngZgf0YqEx4vJLxeQLzupJ+MgudJMmYzpfRhKvP
         CFiOg76ypH6eMg3NIm3Zg1wASou7RXi8yICFp/t7wWu2cdovARfNECA30eFWZRrYjIAv
         j/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Lyt/rTDjGnKoutcwJre3yNnjqLDOGX/x3OkYu61FqOk=;
        b=K8+E37pVu1JrqlLU2zTAZzPRLHnKVXRfKPp7Wk7tW2+Y/lQ3NnlVyeOxjQLqaD6ul/
         xiIfvnB/yUP6MM0SccbfPsGei6VdKvW8nDSBaZvBt0KUba00QBR9eSGuhZP7sPL8Nv//
         aKzMUKIIzpBWwlSH+Xm1dHJZmEW/24y7oApGzoq4PNBZ2pu1eJRl8FYrapyRvAbPiWiX
         QtiSz1nxdVJheHKTIrDzpoJqLB27PuIg8SaVrBleNcocn6bp7SqmDAcuU5GLCSnBbTxn
         reKY0nP4oYqUSc3zGR7lm1txsG+2AZUYW23k74jGbuzndJ9edar1+MfqyBh1GFTCPBuB
         TNPw==
X-Gm-Message-State: AOAM532JffI5SH7/2bdQbPVtK0S0KQ4IrHcewrCgYEQLooT/arOzB/Ev
        VkQ010COGhIvpt9VKkNHk5TZC2lXM68=
X-Google-Smtp-Source: ABdhPJzwe3ySftIMFIDWAgLK4p70yiGU7wr0OHMFB4yOPKar4RINHPheEDQEOrP3eF5wXmfUmDTfro+u2BU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:174e:b0:43b:80ba:99c8 with SMTP id
 j14-20020a056a00174e00b0043b80ba99c8mr3561997pfc.51.1636596477237; Wed, 10
 Nov 2021 18:07:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Nov 2021 02:07:31 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 10/17] KVM: x86: Drop current_vcpu for kvm_running_vcpu +
 kvm_arch_vcpu variable
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>,
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

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/x86.c              | 21 ++++++++++++---------
 arch/x86/kvm/x86.h              | 10 ++++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 112ffb355552..812c08e797fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -773,6 +773,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	u8 handling_intr_from_guest;
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -1893,8 +1894,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
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
index ceb09d78277e..c8ef49385c99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8410,15 +8410,17 @@ static void kvm_timer_init(void)
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
@@ -8430,9 +8432,10 @@ unsigned int kvm_guest_state(void)
 
 static unsigned long kvm_guest_get_ip(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	if (WARN_ON_ONCE(!vcpu))
+	/* Retrieving the IP must be guarded by a call to kvm_guest_state(). */
+	if (WARN_ON_ONCE(!kvm_pmi_in_guest(vcpu)))
 		return 0;
 
 	return kvm_rip_read(vcpu);
@@ -8440,10 +8443,10 @@ static unsigned long kvm_guest_get_ip(void)
 
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
index ea264c4502e4..d070043fd2e8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -385,18 +385,20 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
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
2.34.0.rc0.344.g81b53c2807-goog

