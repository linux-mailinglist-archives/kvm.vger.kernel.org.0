Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973EE647890
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiLHWFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLHWFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:05:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D352680A0C
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670537020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KeqB0c67FU/hSjaDlhtaHPZfL63d5D3XG7iv2OZowY=;
        b=iv8TbOCvv7yEkoBFOnWGE979UkwQsojODCst5oRXfcnKEjE3uJxLWb6jjKHFimVA0gO5Gw
        c7/00DMjGwB02In0vYOVruSgvEEvl8UXXm+TnZx/IjLCXRfVzNqNORT9Rb3VC7dRr3pide
        mIbl4R+az5x8j53CuC54CGgxTrdGUC4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-1VhRlEmAOhG9J9dFvHjigg-1; Thu, 08 Dec 2022 17:03:38 -0500
X-MC-Unique: 1VhRlEmAOhG9J9dFvHjigg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EE0C83397C;
        Thu,  8 Dec 2022 22:03:37 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 361A440C2065;
        Thu,  8 Dec 2022 22:03:36 +0000 (UTC)
Message-ID: <c5cfa5b8b33ed4ef8d1aff16ff0212e4d0ae30cd.camel@redhat.com>
Subject: Re: [PATCH v4 32/32] KVM: x86: Track required APICv inhibits with
 variable, not callback
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 09 Dec 2022 00:03:35 +0200
In-Reply-To: <20221001005915.2041642-33-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-33-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Track the per-vendor required APICv inhibits with a variable instead of
> calling into vendor code every time KVM wants to query the set of
> required inhibits.  The required inhibits are a property of the vendor's
> virtualization architecture, i.e. are 100% static.
> 
> Using a variable allows the compiler to inline the check, e.g. generate
> a single-uop TEST+Jcc, and thus eliminates any desire to avoid checking
> inhibits for performance reasons.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 -
>  arch/x86/include/asm/kvm_host.h    |  2 +-
>  arch/x86/kvm/svm/avic.c            | 20 --------------------
>  arch/x86/kvm/svm/svm.c             |  2 +-
>  arch/x86/kvm/svm/svm.h             | 17 ++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.c             | 24 +++++++++++-------------
>  arch/x86/kvm/x86.c                 |  9 +++++++--
>  7 files changed, 36 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 82ba4a564e58..533d0e804e5a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -76,7 +76,6 @@ KVM_X86_OP(set_nmi_mask)
>  KVM_X86_OP(enable_nmi_window)
>  KVM_X86_OP(enable_irq_window)
>  KVM_X86_OP_OPTIONAL(update_cr8_intercept)
> -KVM_X86_OP(check_apicv_inhibit_reasons)
>  KVM_X86_OP(refresh_apicv_exec_ctrl)
>  KVM_X86_OP_OPTIONAL(hwapic_irr_update)
>  KVM_X86_OP_OPTIONAL(hwapic_isr_update)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4fd06965c773..41d1c684a1e1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1566,7 +1566,7 @@ struct kvm_x86_ops {
>  	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
> -	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
> +	const unsigned long required_apicv_inhibits;
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>  	void (*hwapic_isr_update)(int isr);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 35b0ef877e53..5b25944274b5 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -966,26 +966,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  	return ret;
>  }
>  
> -bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
> -{
> -	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> -			  BIT(APICV_INHIBIT_REASON_ABSENT) |
> -			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> -			  BIT(APICV_INHIBIT_REASON_NESTED) |
> -			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> -			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> -			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> -			  BIT(APICV_INHIBIT_REASON_SEV)      |
> -			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_X2APIC) |
> -			  BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
> -
> -	return supported & BIT(reason);
> -}
> -
> -
>  static inline int
>  avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 37fe7bcf8496..6bca3f9f39e6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4800,8 +4800,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.update_cr8_intercept = svm_update_cr8_intercept,
>  	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
> -	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
> +	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
>  
>  	.get_exit_info = svm_get_exit_info,
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 29c334a932c3..dfde85782da5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -619,6 +619,22 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
>  extern struct kvm_x86_nested_ops svm_nested_ops;
>  
>  /* avic.c */
> +#define AVIC_REQUIRED_APICV_INHIBITS			\
> +(							\
> +	BIT(APICV_INHIBIT_REASON_DISABLE) |		\
> +	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
> +	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
> +	BIT(APICV_INHIBIT_REASON_NESTED) |		\
> +	BIT(APICV_INHIBIT_REASON_IRQWIN) |		\
> +	BIT(APICV_INHIBIT_REASON_PIT_REINJ) |		\
> +	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
> +	BIT(APICV_INHIBIT_REASON_SEV)      |		\
> +	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
> +	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
> +	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
> +	BIT(APICV_INHIBIT_REASON_X2APIC) |		\
> +	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
> +)
>  
>  bool avic_hardware_setup(struct kvm_x86_ops *ops);
>  int avic_ga_log_notifier(u32 ga_tag);
> @@ -632,7 +648,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  void avic_vcpu_put(struct kvm_vcpu *vcpu);
>  void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>  void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
> -bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
>  int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  			uint32_t guest_irq, bool set);
>  void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5920166d7260..54bc447ba87e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7949,18 +7949,16 @@ static void vmx_hardware_unsetup(void)
>  	free_kvm_area();
>  }
>  
> -static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
> -{
> -	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> -			  BIT(APICV_INHIBIT_REASON_ABSENT) |
> -			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> -			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> -			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> -
> -	return supported & BIT(reason);
> -}
> +#define VMX_REQUIRED_APICV_INHIBITS			\
> +(							\
> +	BIT(APICV_INHIBIT_REASON_DISABLE)|		\
> +	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
> +	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
> +	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
> +	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
> +	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
> +	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED)	\
> +)
>  
>  static void vmx_vm_destroy(struct kvm *kvm)
>  {
> @@ -8044,7 +8042,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
>  	.apicv_post_state_restore = vmx_apicv_post_state_restore,
> -	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
> +	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
>  	.hwapic_irr_update = vmx_hwapic_irr_update,
>  	.hwapic_isr_update = vmx_hwapic_isr_update,
>  	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a20002924eb4..b307637d9200 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10251,6 +10251,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> +static bool kvm_is_required_apicv_inhibit(enum kvm_apicv_inhibit reason)
> +{
> +	return kvm_x86_ops.required_apicv_inhibits & BIT(reason);
> +}
> +
>  void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -10294,7 +10299,7 @@ static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	if (apic_x2apic_mode(vcpu->arch.apic) &&
> -	    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC))
> +	    kvm_is_required_apicv_inhibit(APICV_INHIBIT_REASON_X2APIC))
>  		kvm_inhibit_apic_access_page(vcpu);
>  
>  	__kvm_vcpu_update_apicv(vcpu);
> @@ -10307,7 +10312,7 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  
>  	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
>  
> -	if (!static_call(kvm_x86_check_apicv_inhibit_reasons)(reason))
> +	if (!kvm_is_required_apicv_inhibit(reason))
>  		return;
>  
>  	old = new = kvm->arch.apicv_inhibit_reasons;



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

