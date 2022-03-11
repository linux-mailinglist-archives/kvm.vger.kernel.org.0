Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E74D59AC
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346357AbiCKEgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346339AbiCKEgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:36:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36741A615B
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:21 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170902b70d00b0015317d9f08bso2592218pls.1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=usB0GBxRRdVr+B/0aKHFypKAZ1hq6jlpz8Jy0DI+uF4=;
        b=gcHWOWIHV+tTBgjHJX9jzdk/PMrKUgkzRAmL1ZK+8U2EPTyUUHFmURiZcg+BigNFsH
         ujMYWZOZrgbQF+dzAta+k1PyYB9jdNYoVcW15KywCDadDz1Ryol6l9GNrZC25QcNKr7u
         2BsMUnRQOTrCNuHeM4aW+zb//QrgOW1V3QHS5+fndf6fEOoEV586J3f2ZmLGzQIPcJh9
         kAqIdPTHRBGSPRuADdyxTfPKWTfIaDaP2X0zwCnnFUvpIS8KJp9bJ+pVe96WiF2svSdv
         iVcGLvIz0+6fmsL5msdZ9BKAmmqp9kiiaRMF3qxbvI5xk5YFbc/REQLfui3DyqkGy+jA
         K+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=usB0GBxRRdVr+B/0aKHFypKAZ1hq6jlpz8Jy0DI+uF4=;
        b=ervhyjr7ZQdclHMEl3udLUCpESLCqkc3IBIdsqY7wsidEdZHadnwy0DdZ6/vwOYV22
         Jxqg4+FlCNpjKduZtvMGkdwTnTIWRa8IoG6sUe3ppilUKTK/DXIw23X8V2lBfTul+tFN
         gIQhPTtVu5DM1AD2CPK4XwC3P7msYLnKb5mRs7U+OWTPsjmvwnejxeBiZDnwZ91BOnko
         8N4Xk5qp9H70dofKMh+FqJjzyLRq5XsDWP01ZZWXegikELtG3G1MQHH6NuzFI57PV7PQ
         1+osRXCzSVhkXtlHAoddgpvASy9rajScufLKHKUsElmPACh0bKejcx/kcBhhw0t/PXR5
         h/eg==
X-Gm-Message-State: AOAM533Ekv3JoFdan5XsSeV+7ZVyjr/7+dwvnFd3ZF4vmpwz0sr3Pr9T
        QtIGZrjmTQpQifI/zaX36ncvZxJE0XA=
X-Google-Smtp-Source: ABdhPJyJhPX61vPOaIFpK6NgMZc4sXBFVf0JJT3JwPXm1Qngue1PPW6Z0JVdCgJ/Dc6GWeLWzee8AAcANYA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14c1:b0:4f7:55ba:5f5a with SMTP id
 w1-20020a056a0014c100b004f755ba5f5amr8500794pfu.76.1646973321130; Thu, 10 Mar
 2022 20:35:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 04:35:15 +0000
In-Reply-To: <20220311043517.17027-1-seanjc@google.com>
Message-Id: <20220311043517.17027-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220311043517.17027-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 1/3] KVM: x86: Make APICv inihibit reasons an enum and cleanup naming
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an enum for the APICv inhibit reasons, there is no meaning behind
their values and they most definitely are not "unsigned longs".  Rename
the various params to "reason" for consistency and clarity (inhibit may
be confused as a command, i.e. inhibit APICv, instead of the reason that
is getting toggled/checked).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 25 +++++++++++++------------
 arch/x86/kvm/svm/avic.c         |  4 ++--
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/trace.h            | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 19 +++++++++++--------
 6 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..16f46faa7f80 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1047,14 +1047,16 @@ struct kvm_x86_msr_filter {
 	struct msr_bitmap_range ranges[16];
 };
 
-#define APICV_INHIBIT_REASON_DISABLE    0
-#define APICV_INHIBIT_REASON_HYPERV     1
-#define APICV_INHIBIT_REASON_NESTED     2
-#define APICV_INHIBIT_REASON_IRQWIN     3
-#define APICV_INHIBIT_REASON_PIT_REINJ  4
-#define APICV_INHIBIT_REASON_X2APIC	5
-#define APICV_INHIBIT_REASON_BLOCKIRQ	6
-#define APICV_INHIBIT_REASON_ABSENT	7
+enum kvm_apicv_inhibit {
+	APICV_INHIBIT_REASON_DISABLE,
+	APICV_INHIBIT_REASON_HYPERV,
+	APICV_INHIBIT_REASON_NESTED,
+	APICV_INHIBIT_REASON_IRQWIN,
+	APICV_INHIBIT_REASON_PIT_REINJ,
+	APICV_INHIBIT_REASON_X2APIC,
+	APICV_INHIBIT_REASON_BLOCKIRQ,
+	APICV_INHIBIT_REASON_ABSENT,
+};
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
@@ -1408,7 +1410,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*check_apicv_inhibit_reasons)(ulong bit);
+	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
@@ -1803,10 +1805,9 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
-			      unsigned long bit);
-
+			      enum kvm_apicv_inhibit reason);
 void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
-				unsigned long bit);
+				enum kvm_apicv_inhibit reason);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b37b353ec086..c5ef4715f3e0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -822,7 +822,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	return ret;
 }
 
-bool avic_check_apicv_inhibit_reasons(ulong bit)
+bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
@@ -833,7 +833,7 @@ bool avic_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
-	return supported & BIT(bit);
+	return supported & BIT(reason);
 }
 
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 93502d2a52ce..d07a5b88ea96 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -600,7 +600,7 @@ void __avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
-bool avic_check_apicv_inhibit_reasons(ulong bit);
+bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 193f5ba930d1..cf3e4838c86a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1340,22 +1340,22 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 );
 
 TRACE_EVENT(kvm_apicv_update_request,
-	    TP_PROTO(bool activate, unsigned long bit),
-	    TP_ARGS(activate, bit),
+	    TP_PROTO(bool activate, int reason),
+	    TP_ARGS(activate, reason),
 
 	TP_STRUCT__entry(
 		__field(bool, activate)
-		__field(unsigned long, bit)
+		__field(int, reason)
 	),
 
 	TP_fast_assign(
 		__entry->activate = activate;
-		__entry->bit = bit;
+		__entry->reason = reason;
 	),
 
-	TP_printk("%s bit=%lu",
+	TP_printk("%s reason=%u",
 		  __entry->activate ? "activate" : "deactivate",
-		  __entry->bit)
+		  __entry->reason)
 );
 
 TRACE_EVENT(kvm_apicv_accept_irq,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8963f5af618..fb8d5b6d05f7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7705,14 +7705,14 @@ static void vmx_hardware_unsetup(void)
 	free_kvm_area();
 }
 
-static bool vmx_check_apicv_inhibit_reasons(ulong bit)
+static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
-	return supported & BIT(bit);
+	return supported & BIT(reason);
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51106d32f04e..f295db4580a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9735,24 +9735,25 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
-void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
+				enum kvm_apicv_inhibit reason)
 {
 	unsigned long old, new;
 
 	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
 
-	if (!static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
+	if (!static_call(kvm_x86_check_apicv_inhibit_reasons)(reason))
 		return;
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
 	if (activate)
-		__clear_bit(bit, &new);
+		__clear_bit(reason, &new);
 	else
-		__set_bit(bit, &new);
+		__set_bit(reason, &new);
 
 	if (!!old != !!new) {
-		trace_kvm_apicv_update_request(activate, bit);
+		trace_kvm_apicv_update_request(activate, reason);
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in svm_vcpu_run().
@@ -9771,17 +9772,19 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
 		}
-	} else
+	} else {
 		kvm->arch.apicv_inhibit_reasons = new;
+	}
 }
 
-void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+void kvm_request_apicv_update(struct kvm *kvm, bool activate,
+			      enum kvm_apicv_inhibit reason)
 {
 	if (!enable_apicv)
 		return;
 
 	down_write(&kvm->arch.apicv_update_lock);
-	__kvm_request_apicv_update(kvm, activate, bit);
+	__kvm_request_apicv_update(kvm, activate, reason);
 	up_write(&kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
-- 
2.35.1.723.g4982287a31-goog

