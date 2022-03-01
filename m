Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F614C915A
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiCARVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiCARVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:21:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 375CC5FFC
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646155253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TpCCGyVJGVfXxS3k6UJyCHnd6jf7rUXCZW6tbaMUeEk=;
        b=dnYzfJNHYr7acHYuiergyyJxffuNfVWdhZ4RfppKy4I8hkgu7CJkLlW9isYfuwSsb33bRx
        R5gDKbEizFXoCZQazYxnYf79cKG8SteX3q5fy659WgATd1O9fIDe7yYREDsgkaNTvy7UsC
        uJK7QhSvjmkcv48U7C+DA34A+M14sCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-tMwbKlSdPgyZJ1BT7SvuqA-1; Tue, 01 Mar 2022 12:20:50 -0500
X-MC-Unique: tMwbKlSdPgyZJ1BT7SvuqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D7B824FA8;
        Tue,  1 Mar 2022 17:20:48 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43772ED79;
        Tue,  1 Mar 2022 17:20:43 +0000 (UTC)
Message-ID: <c9e99c37e9d6c666ac790ee2166418eb9e54e3fd.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86: SVM: disable preemption in
 avic_refresh_apicv_exec_ctrl
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Tue, 01 Mar 2022 19:20:42 +0200
In-Reply-To: <Yh5UqJ0De0dk6uxD@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-3-mlevitsk@redhat.com> <Yh5UqJ0De0dk6uxD@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 17:15 +0000, Sean Christopherson wrote:
> On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > avic_refresh_apicv_exec_ctrl is called from vcpu_enter_guest,
> > without preemption disabled, however avic_vcpu_load, and
> > avic_vcpu_put expect preemption to be disabled.
> > 
> > This issue was found by lockdep.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index aea0b13773fd3..e23159f3a62ba 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -640,12 +640,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> >  	}
> >  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> >  
> > +	preempt_disable();
> > +
> >  	if (activated)
> >  		avic_vcpu_load(vcpu, vcpu->cpu);
> >  	else
> >  		avic_vcpu_put(vcpu);
> >  
> >  	avic_set_pi_irte_mode(vcpu, activated);
> > +
> > +	preempt_enable();
> 
> Assuming avic_set_pi_irte_mode() doesn't need to be protected, I'd prefer the
> below patch.  This is the second time we done messed this up.
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 1 Mar 2022 09:05:09 -0800
> Subject: [PATCH] KVM: SVM: Disable preemption across AVIC load/put during
>  APICv refresh
> 
> Disable preemption when loading/putting the AVIC during an APICv refresh.
> If the vCPU task is preempted and migrated ot a different pCPU, the
> unprotected avic_vcpu_load() could set the wrong pCPU in the physical ID
> cache/table.
> 
> Pull the necessary code out of avic_vcpu_{,un}blocking() and into a new
> helper to reduce the probability of introducing this exact bug a third
> time.
> 
> Fixes: df7e4827c549 ("KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC")
> Cc: stable@vger.kernel.org
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 103 ++++++++++++++++++++++------------------
>  arch/x86/kvm/svm/svm.c  |   4 +-
>  arch/x86/kvm/svm/svm.h  |   4 +-
>  3 files changed, 60 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index aea0b13773fd..1afde44b1252 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -616,38 +616,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>  	return ret;
>  }
>  
> -void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *vmcb = svm->vmcb01.ptr;
> -	bool activated = kvm_vcpu_apicv_active(vcpu);
> -
> -	if (!enable_apicv)
> -		return;
> -
> -	if (activated) {
> -		/**
> -		 * During AVIC temporary deactivation, guest could update
> -		 * APIC ID, DFR and LDR registers, which would not be trapped
> -		 * by avic_unaccelerated_access_interception(). In this case,
> -		 * we need to check and update the AVIC logical APIC ID table
> -		 * accordingly before re-activating.
> -		 */
> -		avic_apicv_post_state_restore(vcpu);
> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> -	} else {
> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> -	}
> -	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> -
> -	if (activated)
> -		avic_vcpu_load(vcpu, vcpu->cpu);
> -	else
> -		avic_vcpu_put(vcpu);
> -
> -	avic_set_pi_irte_mode(vcpu, activated);
> -}
> -
>  static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>  {
>  	unsigned long flags;
> @@ -899,7 +867,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  	return ret;
>  }
>  
> -void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	u64 entry;
>  	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
> @@ -936,7 +904,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
>  }
>  
> -void avic_vcpu_put(struct kvm_vcpu *vcpu)
> +void __avic_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	u64 entry;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -955,13 +923,63 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  }
>  
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_load(struct kvm_vcpu *vcpu)
>  {
> -	if (!kvm_vcpu_apicv_active(vcpu))
> -		return;
> +	int cpu = get_cpu();
>  
> +	WARN_ON(cpu != vcpu->cpu);
> +
> +	__avic_vcpu_load(vcpu, cpu);
> +
> +	put_cpu();
> +}
> +
> +static void avic_vcpu_put(struct kvm_vcpu *vcpu)
> +{
>  	preempt_disable();
>  
> +	__avic_vcpu_put(vcpu);
> +
> +	preempt_enable();
> +}
> +
> +void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +	bool activated = kvm_vcpu_apicv_active(vcpu);
> +
> +	if (!enable_apicv)
> +		return;
> +
> +	if (activated) {
> +		/**
> +		 * During AVIC temporary deactivation, guest could update
> +		 * APIC ID, DFR and LDR registers, which would not be trapped
> +		 * by avic_unaccelerated_access_interception(). In this case,
> +		 * we need to check and update the AVIC logical APIC ID table
> +		 * accordingly before re-activating.
> +		 */
> +		avic_apicv_post_state_restore(vcpu);
> +		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +	} else {
> +		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> +	}
> +	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> +
> +	if (activated)
> +		avic_vcpu_load(vcpu);
> +	else
> +		avic_vcpu_put(vcpu);
> +
> +	avic_set_pi_irte_mode(vcpu, activated);
> +}
> +
> +void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> +{
> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return;
> +
>         /*
>          * Unload the AVIC when the vCPU is about to block, _before_
>          * the vCPU actually blocks.
> @@ -976,21 +994,12 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>          * the cause of errata #1235).
>          */
>  	avic_vcpu_put(vcpu);
> -
> -	preempt_enable();
>  }
>  
>  void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
> -	int cpu;
> -
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> -	cpu = get_cpu();
> -	WARN_ON(cpu != vcpu->cpu);
> -
> -	avic_vcpu_load(vcpu, cpu);
> -
> -	put_cpu();
> +	avic_vcpu_load(vcpu);
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7038c76fa841..c5e3f219803e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1318,13 +1318,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		indirect_branch_prediction_barrier();
>  	}
>  	if (kvm_vcpu_apicv_active(vcpu))
> -		avic_vcpu_load(vcpu, cpu);
> +		__avic_vcpu_load(vcpu, cpu);
>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_vcpu_apicv_active(vcpu))
> -		avic_vcpu_put(vcpu);
> +		__avic_vcpu_put(vcpu);
>  
>  	svm_prepare_host_switch(vcpu);
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 70850cbe5bcb..e45b5645d5e0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -576,8 +576,8 @@ void avic_init_vmcb(struct vcpu_svm *svm);
>  int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>  int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
>  int avic_init_vcpu(struct vcpu_svm *svm);
> -void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> -void avic_vcpu_put(struct kvm_vcpu *vcpu);
> +void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> +void __avic_vcpu_put(struct kvm_vcpu *vcpu);
>  void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>  void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
> 
> base-commit: 44af02b939d6a6a166c9cd2d86d4c2a6959f0875


I don't see that this patch is much different that what I proposed,
especially since disable of preemption can be nested.

But I won't be arguing with you about this.

Best regards,
	Maxim levitsky


