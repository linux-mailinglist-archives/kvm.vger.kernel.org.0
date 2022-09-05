Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F5E5ADB0D
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 00:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiIEWCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 18:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiIEWCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 18:02:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5AC24082
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662415331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tkLdlVSrqLfk4ELCimBUjuMwQTz/dEFdfp2U2u1GO8=;
        b=EuUDJxLEY+9/sFAXN6h4v3dAMJ5PDKaEPBLI1kEz87iANlZsxuSFkerCUFFNSqZnT3jXY4
        cb1j/oWDdwL6WwtLCGH5zkg0LgIUDBbnBEgWOUFZY+yaPcCfW1ZOKpZrrA2nM/JQ5fMaUW
        mI8ybr8KIaPdG27OmQxb88iL7eyCd+U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-jv0bGyjfO5yEwmtHtyawZg-1; Mon, 05 Sep 2022 18:02:10 -0400
X-MC-Unique: jv0bGyjfO5yEwmtHtyawZg-1
Received: by mail-ej1-f69.google.com with SMTP id qk37-20020a1709077fa500b00730c2d975a0so2638403ejc.13
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 15:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2tkLdlVSrqLfk4ELCimBUjuMwQTz/dEFdfp2U2u1GO8=;
        b=Cyeiswwfa/2eoft4oD9Z62Q1svyaB3B/z4VFg+qnEdbn+JtSz9Q9vHs/LS0LuX2Z+F
         dzbliaCQq9XMKiyGf3yja7HzimNPeRrJ0tOF/1GqsPbPiWbDwRWwwcatVckYEhL9D75J
         YMv+Uuo+mrxr62EN715e/Yrgf0zCw1fatNghjSJpTBp+eafBkwFalgyo4mTyg6wbGZp6
         f4qO4noCsOni/zWZM85RLb5qGROXugOU93X5ZqyQNJCt/jwyxqsrzjJtDSLVbzAplMQB
         6k/1oYcgt/fkYdU+RFgdhF9Ia6cxc+BdfTwuZCb8rcGVIufva350wqu4xhyCIAApQmst
         RXKw==
X-Gm-Message-State: ACgBeo396XIfXbXXTloxfgttxaxE95oL8T3cSJkAguzLhLIZvYSelv+E
        shsh94Cyofx+ZgtYRLub2Qplj4uFcok+ek6huBqd/Nv+fZCCDBSGtZLnsUYw3CUq7t2lBmC1Npk
        il5Rozkgx8Pln
X-Received: by 2002:a17:906:4fd0:b0:73d:be5b:291d with SMTP id i16-20020a1709064fd000b0073dbe5b291dmr37021640ejw.506.1662415329082;
        Mon, 05 Sep 2022 15:02:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR52sFWM1W3cmPMZN8ylpzLYXX++KXSgfoyeqAZu/twF+jtoPkOV/4hOs23zvxq/ZQrjAYPIRw==
X-Received: by 2002:a17:906:4fd0:b0:73d:be5b:291d with SMTP id i16-20020a1709064fd000b0073dbe5b291dmr37021625ejw.506.1662415328825;
        Mon, 05 Sep 2022 15:02:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id y2-20020aa7ce82000000b004483a543794sm7059380edv.96.2022.09.05.15.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 15:02:08 -0700 (PDT)
Message-ID: <eee9ab0f-a96f-2b92-1021-0c94492d5a55@redhat.com>
Date:   Tue, 6 Sep 2022 00:02:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU enables
 x2APIC
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220903002254.2411750-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/22 02:22, Sean Christopherson wrote:
> Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> to fix a bug where the APIC access page is visible to vCPUs that have
> x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> 
> On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> enabled even without x2AVIC support, the bug occurs any time AVIC is
> enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> that the guest is operating in x2APIC mode.
> 
> Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> the "Note:" down a line to conform to preferred kernel/KVM multi-line
> comment style.
> 
> Leave Intel as-is for now to avoid a subtle performance regression, even
> though Intel likely suffers from the same bug.  On Intel, in theory the
> bug rears its head only when vCPUs share host page tables (extremely
> likely) and x2APIC enabling is not consistent within the guest, i.e. if
> some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> except in certain situations, e.g. bringing up APs).
> 
> Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
> Cc: stable@vger.kernel.org
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++++++++
>   arch/x86/kvm/lapic.c            |  4 +++-
>   arch/x86/kvm/mmu/mmu.c          |  2 +-
>   arch/x86/kvm/svm/avic.c         | 15 +++++++-------
>   arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++----
>   5 files changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..1fd1b66ceeb6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1132,6 +1132,15 @@ enum kvm_apicv_inhibit {
>   	 * AVIC is disabled because SEV doesn't support it.
>   	 */
>   	APICV_INHIBIT_REASON_SEV,
> +
> +	/*
> +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> +	 * inhibited if any vCPU has x2APIC enabled.  Note, this is a "partial"
> +	 * inhibit; APICv can still be activated, but KVM mustn't retain/create
> +	 * SPTEs for the APIC access page.  Like the APIC ID and APIC base
> +	 * inhibits, this is sticky for simplicity.
> +	 */
> +	APICV_INHIBIT_REASON_X2APIC,
>   };
>   
>   struct kvm_arch {
> @@ -1903,6 +1912,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
>   gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>   				struct x86_exception *exception);
>   
> +bool kvm_apicv_memslot_activated(struct kvm *kvm);
>   bool kvm_apicv_activated(struct kvm *kvm);
>   bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
>   void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 38e9b8e5278c..d956cd37908e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2394,8 +2394,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>   		}
>   	}
>   
> -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>   		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
> +	}
>   
>   	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
>   		kvm_vcpu_update_apicv(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..cea25552869f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4150,7 +4150,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   		 * when the AVIC is re-enabled.
>   		 */
>   		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -		    !kvm_apicv_activated(vcpu->kvm))
> +		    !kvm_apicv_memslot_activated(vcpu->kvm))
>   			return RET_PF_EMULATE;
>   	}
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6a3d225eb02c..19be5f1afaac 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -72,12 +72,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   
>   	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>   
> -	/* Note:
> -	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
> -	 * MSR accesses, while interrupt injection to a running vCPU
> -	 * can be achieved using AVIC doorbell. The AVIC hardware still
> -	 * accelerate MMIO accesses, but this does not cause any harm
> -	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
> +	/*
> +	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
> +	 * accesses, while interrupt injection to a running vCPU can be
> +	 * achieved using AVIC doorbell.  KVM disables the APIC access page
> +	 * (prevents mapping it into the guest) if any vCPU has x2APIC enabled,
> +	 * thus enabling AVIC activates only the doorbell mechanism.
>   	 */
>   	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
>   	    avic_mode == AVIC_MODE_X2) {
> @@ -1014,7 +1014,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>   			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>   			  BIT(APICV_INHIBIT_REASON_SEV)      |
>   			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> +			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> +			  BIT(APICV_INHIBIT_REASON_X2APIC);
>   
>   	return supported & BIT(reason);
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..6ab9088c2531 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9379,15 +9379,29 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>   	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
>   }
>   
> -bool kvm_apicv_activated(struct kvm *kvm)
> +bool kvm_apicv_memslot_activated(struct kvm *kvm)
>   {
>   	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
>   }
> +
> +static unsigned long kvm_apicv_get_inhibit_reasons(struct kvm *kvm)
> +{
> +	/*
> +	 * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
> +	 * APICv can continue to be utilized.
> +	 */
> +	return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~APICV_INHIBIT_REASON_X2APIC;
> +}
> +
> +bool kvm_apicv_activated(struct kvm *kvm)
> +{
> +	return !kvm_apicv_get_inhibit_reasons(kvm);
> +}
>   EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>   
>   bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
>   {
> -	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
> +	ulong vm_reasons = kvm_apicv_get_inhibit_reasons(vcpu->kvm);
>   	ulong vcpu_reasons = static_call(kvm_x86_vcpu_get_apicv_inhibit_reasons)(vcpu);
>   
>   	return (vm_reasons | vcpu_reasons) == 0;
> @@ -10122,7 +10136,15 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   
>   	set_or_clear_apicv_inhibit(&new, reason, set);
>   
> -	if (!!old != !!new) {
> +	/*
> +	 * If the overall "is APICv activated" status is unchanged, simply add
> +	 * or remove the inihbit from the pile.  x2APIC is an exception, as it
> +	 * is a partial inhibit (only blocks SPTEs for the APIC access page).
> +	 * If x2APIC is the only inhibit in either the old or the new set, then
> +	 * vCPUs need to be kicked to transition between partially-inhibited
> +	 * and fully-inhibited.
> +	 */
> +	if ((!!old != !!new) || old == X2APIC_ENABLE || new == X2APIC_ENABLE) {
>   		/*
>   		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
>   		 * false positives in the sanity check WARN in svm_vcpu_run().
> @@ -10137,7 +10159,12 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   		 */
>   		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>   		kvm->arch.apicv_inhibit_reasons = new;
> -		if (new) {
> +
> +		/*
> +		 * Zap SPTEs for the APIC access page if APICv is newly
> +		 * inhibited (partially or fully).
> +		 */
> +		if (new && !old) {
>   			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
>   			kvm_zap_gfn_range(kvm, gfn, gfn+1);
>   		}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

