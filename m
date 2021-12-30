Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CE7481E9B
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbhL3R0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 12:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhL3R0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 12:26:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A218FC061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:26:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so23765438pjp.0
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lBCsFftBWdAXzjaoaZyUCTgBOsRdtYNsGz6SR7hrmps=;
        b=Oc/19XPrA7rVSvCOE1ol6CZ+7XIoX4GWD+2JXAi4ZGLQzGtSyCTazv7qZB4vBjB8JX
         yh8/oYdLZC/XuQD20tWuG29Mppxcv7f/G1rRsmyUXLAy3Yex3Am7nWFSjb5QvWuPWbm3
         UawMUSAN3dtzpimPwpWjfaaZTpEWeO7E9bKKIURFaHjKFoitADegn6SiLRJYOY1IUf8n
         t0cK02CRvUNrt/ueb3k72xzSKDbap9WkwHZoSdJItU5c3UMVzOUaTwExMD7vfuhPE2q3
         ptNIR69+eYl3GqtSIiqixzfTGrFNaMD3OC7S7vuyu/LMuBMkPaKOy+ArgUtognDwLQTe
         UgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lBCsFftBWdAXzjaoaZyUCTgBOsRdtYNsGz6SR7hrmps=;
        b=5gZI1RzbnRVHrMybEQ8ymGIoi7xF+xzR/lykI0nS1zrIIws9p+w4YPugqur1Hg/HpB
         9cx1k43xNbZyRkrFO5lmR/OELRczI1v69UgSP4ti3iUHlu7hmG07qCHQqWoFL7WUDX0S
         6E8HhQnKNqvp1tkF/XlQ+79uApb+Ehr7nK1o+cJVJXE404gh+pNOAC71jKDeWe5ZA14s
         OH5Xb6pJidODl1hjj8mm76KuNr9b4ZfSJ1L1Uu5L6XOWRUSkmFwvgR2gV8NODj167ePj
         52nLpF6bWAh+A8kpuFeN0tQjkziMcp6wOld18rXwYSov58w7Zr21wQYT4p/h7eTss7ng
         LQdw==
X-Gm-Message-State: AOAM533pIl/lV9R9TLxAkHG19KvlsDq49pBtpsN71lRCk9WTjqoAvdK/
        imccjQKfDTXufkdjHMxV4zj/rQ==
X-Google-Smtp-Source: ABdhPJzFz5vTIRvW6iqMN9QXKJe8F518FSAWxeQa3njfmQDjSNwChQBYHye8hWWk05YqFMYbv4cang==
X-Received: by 2002:a17:90b:70f:: with SMTP id s15mr18641617pjz.35.1640885208886;
        Thu, 30 Dec 2021 09:26:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cv14sm21464315pjb.24.2021.12.30.09.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:26:48 -0800 (PST)
Date:   Thu, 30 Dec 2021 17:26:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Subject: Re: [PATCH v3 1/3] KVM: SVM: Refactor AVIC hardware setup logic into
 helper function
Message-ID: <Yc3r1U6WFVDtJCZn@google.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-2-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213113110.12143-2-suravee.suthikulpanit@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Suravee Suthikulpanit wrote:
> To prepare for upcoming AVIC changes. There is no functional change.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 ++++++++++
>  arch/x86/kvm/svm/svm.c  |  8 +-------
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 8052d92069e0..63c3801d1829 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_update_apicv(vcpu);
>  	avic_set_running(vcpu, true);
>  }
> +
> +bool avic_hardware_setup(bool avic)
> +{
> +	if (!avic || !npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
> +		return false;
> +
> +	pr_info("AVIC enabled\n");
> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +	return true;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 989685098b3e..e59f663ab8cb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1031,13 +1031,7 @@ static __init int svm_hardware_setup(void)
>  			nrips = false;
>  	}
>  
> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> -
> -	if (enable_apicv) {
> -		pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	}
> +	enable_apicv = avic = avic_hardware_setup(avic);

Rather than pass in "avic", just do

	enable_apicv = avic == avic && avic_hardware_setup();

This also conflicts with changes sitting in kvm/queue to nullify vcpu_(un)blocking
when AVIC is disabled.  But moving AVIC setup to avic.c provides an opportunity for
further cleanup, as it means vcpu_(un)blocking can be NULL by default and set to
the AVIC helpers if and only if AVIC is enable.  That will allow making the helpers
static in avic.c.  E.g.

---
 arch/x86/kvm/svm/avic.c | 17 +++++++++++++++--
 arch/x86/kvm/svm/svm.c  | 13 +------------
 arch/x86/kvm/svm/svm.h  |  3 +--
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..f5c6cab42d74 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1027,7 +1027,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }

-void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -1052,7 +1052,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }

-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	int cpu;

@@ -1066,3 +1066,16 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)

 	put_cpu();
 }
+
+bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
+		return false;
+
+	x86_ops->vcpu_blocking = avic_vcpu_blocking,
+	x86_ops->vcpu_unblocking = avic_vcpu_unblocking,
+
+	pr_info("AVIC enabled\n");
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6cb38044a860..6cb0f58238cd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4390,8 +4390,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = avic_vcpu_blocking,
-	.vcpu_unblocking = avic_vcpu_unblocking,

 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
@@ -4674,16 +4672,7 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}

-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
-
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
-		svm_x86_ops.vcpu_blocking = NULL;
-		svm_x86_ops.vcpu_unblocking = NULL;
-	}
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);

 	if (vls) {
 		if (!npt_enabled ||
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..59d91b969bd7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -573,6 +573,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;

 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL

+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
@@ -593,8 +594,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);

 /* sev.c */

--


