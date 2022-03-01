Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E327D4C9147
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiCARQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiCARQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:16:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A479A21818
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:15:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so2457236pjb.5
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AjcgGR00bXsUioPujuBwKUyu1B4XAu5nOt3te8sxl+E=;
        b=i4avky59c8iTL8/+3XnZVrWOb3J8VtHPl2qItCiEe5F+FwNrcMphlEQxrfBkXdfuK6
         fP3T6Akr+cgEP9oSrJjssyWamcDMTS4+bJQsvaWWoxyUghoT8A+KarBJjZKetGFN4ScS
         EF4eRB3acLv8kHc6y8gx9ihLiLchnoSyKG6ICMAbLTLd8v/YJ6OdUdD1mBqqLXOf6KWT
         HxtoBCTBVJyv7BDf4pANruCCz2XzvZLTgal3jBfUacXhK5IstnD17GdSc1NzudN8wUVX
         PwqjaxV4i6UCrM7VlSUHz5Od88DjaCh/cEFExpAjec1jzsru+v+G4MjXWiRJv0O0eVjj
         mLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AjcgGR00bXsUioPujuBwKUyu1B4XAu5nOt3te8sxl+E=;
        b=0rsARGxv6eW/yvNlvKlRsWszVsLhsZavhV+jKaUrYUQcN9ly7nL2k4WqcHnQTds3kL
         HUP5pZE5BSsxR7P3BouXQ1eiyBjh0yHa1nBjn5zVTzRbJa+iGooRJRAOkSlrTqKzWC93
         3y+DBFwkIHxgOMUVz5NoYmjNoqmRkiNSmMt4syuf67HRNFRrq7l6hp646Q1NnegcojVg
         rZx456PrmNJnVv6gtcRDe5x+2rDUANS/IvjrAHcnH+GL22wcxY0SvmLWKa/lV4/Mh3u7
         KnJsyJVj0PaORN8Jf3Rl5C9OgsGKHGJCjxYQF5SEbMvQU6EH6NiRjQhmce5cDrf/umLt
         EDrw==
X-Gm-Message-State: AOAM530IHr/W08X0rUPBP1tiTf2KZD6jSnYdDRmU/GdtKbHJSiSyTD6M
        S2cmXfwuQU+QWyxUN2sxvUfVTw==
X-Google-Smtp-Source: ABdhPJyhhKmfCEYjAZxpMYXiqop8g629LaD2lYWzZw+L+FgxUtcEKTpTwfmVMpvjImBEsx+OVfJVmQ==
X-Received: by 2002:a17:903:40cf:b0:151:6e0f:884c with SMTP id t15-20020a17090340cf00b001516e0f884cmr9565132pld.12.1646154923988;
        Tue, 01 Mar 2022 09:15:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00218c00b004c3a2450acasm18966719pfi.147.2022.03.01.09.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:15:23 -0800 (PST)
Date:   Tue, 1 Mar 2022 17:15:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 2/4] KVM: x86: SVM: disable preemption in
 avic_refresh_apicv_exec_ctrl
Message-ID: <Yh5UqJ0De0dk6uxD@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301135526.136554-3-mlevitsk@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> avic_refresh_apicv_exec_ctrl is called from vcpu_enter_guest,
> without preemption disabled, however avic_vcpu_load, and
> avic_vcpu_put expect preemption to be disabled.
> 
> This issue was found by lockdep.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/avic.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index aea0b13773fd3..e23159f3a62ba 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -640,12 +640,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  	}
>  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
>  
> +	preempt_disable();
> +
>  	if (activated)
>  		avic_vcpu_load(vcpu, vcpu->cpu);
>  	else
>  		avic_vcpu_put(vcpu);
>  
>  	avic_set_pi_irte_mode(vcpu, activated);
> +
> +	preempt_enable();

Assuming avic_set_pi_irte_mode() doesn't need to be protected, I'd prefer the
below patch.  This is the second time we done messed this up.

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 1 Mar 2022 09:05:09 -0800
Subject: [PATCH] KVM: SVM: Disable preemption across AVIC load/put during
 APICv refresh

Disable preemption when loading/putting the AVIC during an APICv refresh.
If the vCPU task is preempted and migrated ot a different pCPU, the
unprotected avic_vcpu_load() could set the wrong pCPU in the physical ID
cache/table.

Pull the necessary code out of avic_vcpu_{,un}blocking() and into a new
helper to reduce the probability of introducing this exact bug a third
time.

Fixes: df7e4827c549 ("KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC")
Cc: stable@vger.kernel.org
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 103 ++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c  |   4 +-
 arch/x86/kvm/svm/svm.h  |   4 +-
 3 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aea0b13773fd..1afde44b1252 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -616,38 +616,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-
-	if (!enable_apicv)
-		return;
-
-	if (activated) {
-		/**
-		 * During AVIC temporary deactivation, guest could update
-		 * APIC ID, DFR and LDR registers, which would not be trapped
-		 * by avic_unaccelerated_access_interception(). In this case,
-		 * we need to check and update the AVIC logical APIC ID table
-		 * accordingly before re-activating.
-		 */
-		avic_apicv_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
-	}
-	vmcb_mark_dirty(vmcb, VMCB_AVIC);
-
-	if (activated)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-
-	avic_set_pi_irte_mode(vcpu, activated);
-}
-
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
@@ -899,7 +867,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 	return ret;
 }
 
-void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
 	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
@@ -936,7 +904,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
-void avic_vcpu_put(struct kvm_vcpu *vcpu)
+void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -955,13 +923,63 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
+	int cpu = get_cpu();
 
+	WARN_ON(cpu != vcpu->cpu);
+
+	__avic_vcpu_load(vcpu, cpu);
+
+	put_cpu();
+}
+
+static void avic_vcpu_put(struct kvm_vcpu *vcpu)
+{
 	preempt_disable();
 
+	__avic_vcpu_put(vcpu);
+
+	preempt_enable();
+}
+
+void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+	bool activated = kvm_vcpu_apicv_active(vcpu);
+
+	if (!enable_apicv)
+		return;
+
+	if (activated) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_access_interception(). In this case,
+		 * we need to check and update the AVIC logical APIC ID table
+		 * accordingly before re-activating.
+		 */
+		avic_apicv_post_state_restore(vcpu);
+		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	} else {
+		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+	}
+	vmcb_mark_dirty(vmcb, VMCB_AVIC);
+
+	if (activated)
+		avic_vcpu_load(vcpu);
+	else
+		avic_vcpu_put(vcpu);
+
+	avic_set_pi_irte_mode(vcpu, activated);
+}
+
+void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
        /*
         * Unload the AVIC when the vCPU is about to block, _before_
         * the vCPU actually blocks.
@@ -976,21 +994,12 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
         * the cause of errata #1235).
         */
 	avic_vcpu_put(vcpu);
-
-	preempt_enable();
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	int cpu;
-
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	cpu = get_cpu();
-	WARN_ON(cpu != vcpu->cpu);
-
-	avic_vcpu_load(vcpu, cpu);
-
-	put_cpu();
+	avic_vcpu_load(vcpu);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa841..c5e3f219803e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1318,13 +1318,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
-		avic_vcpu_load(vcpu, cpu);
+		__avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_apicv_active(vcpu))
-		avic_vcpu_put(vcpu);
+		__avic_vcpu_put(vcpu);
 
 	svm_prepare_host_switch(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70850cbe5bcb..e45b5645d5e0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -576,8 +576,8 @@ void avic_init_vmcb(struct vcpu_svm *svm);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
-void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void avic_vcpu_put(struct kvm_vcpu *vcpu);
+void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void __avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);

base-commit: 44af02b939d6a6a166c9cd2d86d4c2a6959f0875
-- 

