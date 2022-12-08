Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB064785C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLHV5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLHV5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:57:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F746B985
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZCinmbgpWapNjGONPgQkHqdJY2lciOCgFni4oji3gTA=;
        b=eB8Xt8WK5hV1bra2lD3JTvdZDB5TjUUyWWHRZAp20pxkx9EXxPjzwHI1Yajj4klQx54vbI
        7mQFMp5BKtyEgs/Kuio5RyrySvQqH5bCDC6YRXbt7/PUm8l5L9Irp3dF1a3KkHelV5rSAd
        Gkf9NIS9LmnPjAbjaBTGN1FzxAWbQgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-2mY4gBvHMgOT7NfwEIHXTQ-1; Thu, 08 Dec 2022 16:56:35 -0500
X-MC-Unique: 2mY4gBvHMgOT7NfwEIHXTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEFC3101A54E;
        Thu,  8 Dec 2022 21:56:34 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52776492B04;
        Thu,  8 Dec 2022 21:56:33 +0000 (UTC)
Message-ID: <90d4a2a1733cdb21e7c00843ddafee78ce52bbdc.camel@redhat.com>
Subject: Re: [PATCH v4 11/32] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:56:32 +0200
In-Reply-To: <20221001005915.2041642-12-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Free the APIC access page memslot if any vCPU enables x2APIC and SVM's
> AVIC is enabled to prevent accesses to the virtual APIC on vCPUs with
> x2APIC enabled.  On AMD, due to its "hybrid" mode where AVIC is enabled
> when x2APIC is enabled even without x2AVIC support, keeping the APIC
> access page memslot results in the guest being able to access the virtual
> APIC page as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> that the guest is operating in x2APIC mode.
> 
> Exempt nested SVM's update of APICv state from new logic as x2APIC can't
> be toggled on VM-Exit.  In practice, invoking the x2APIC logic should be
> harmless precisely because it should be a glorified nop, but play it
> safe to avoid latent bugs, e.g. with dropping the vCPU's SRCU lock.
> 
> Intel doesn't suffer from the same issue as APICv has fully independent
> VMCS controls for xAPIC vs. x2APIC virtualization.  Technically, KVM
> should provide bus error semantics and not memory semantics for the APIC
> page when x2APIC is enabled, but KVM already provides memory semantics in
> other scenarios, e.g. if APICv/AVIC is enabled and the APIC is hardware
> disabled (via APIC_BASE MSR).
> 
> Reserve an inhibit bit so that common code can detect whether or not the
> "x2APIC inhibit" applies, but use a dedicated flag to track the inhibit
> so that it doesn't need to be stripped from apicv_inhibit_reasons (since
> it's not a "full" inhibit).
> 
> Note, checking apic_access_memslot_enabled without taking locks relies
> it being set during vCPU creation (before kvm_vcpu_reset()).  vCPUs can
> race to set the inhibit and delete the memslot, i.e. can get false
> positives, but can't get false negatives as apic_access_memslot_enabled
> can't be toggled "on" once any vCPU reaches KVM_RUN.
> 
> Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> the "Note:" down a line to conform to preferred kernel/KVM multi-line
> comment style.
> 
> Opportunistically update the apicv_update_lock comment, as it isn't
> actually used to protect apic_access_memslot_enabled (it's protected by
> slots_lock).
> 
> Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 20 +++++++++++++----
>  arch/x86/kvm/lapic.c            | 38 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/lapic.h            |  1 +
>  arch/x86/kvm/svm/avic.c         | 15 +++++++------
>  arch/x86/kvm/svm/nested.c       |  2 +-
>  arch/x86/kvm/x86.c              | 16 ++++++++++++--
>  6 files changed, 77 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d40206b16d6c..062758135c86 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1139,6 +1139,17 @@ enum kvm_apicv_inhibit {
>  	 * AVIC is disabled because SEV doesn't support it.
>  	 */
>  	APICV_INHIBIT_REASON_SEV,
> +
> +	/*
> +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> +	 * deleted if any vCPU has x2APIC enabled as SVM doesn't provide fully
> +	 * independent controls for AVIC vs. x2AVIC, and also because SVM
> +	 * supports a "hybrid" AVIC mode for CPUs that support AVIC but not
> +	 * x2AVIC.  Note, this isn't a "full" inhibit and is tracked separately.
> +	 * AVIC can still be activated, but KVM must not create SPTEs for the
> +	 * APIC base.  For simplicity, this is sticky.
> +	 */
> +	APICV_INHIBIT_REASON_X2APIC,

I still don't understand why do you want this to be an inhibit bit.

Now this 'inhibit' is not even set/clear.

I prefer to just have a boolean 'is_avic' or, '.needs_x2apic_memslot_inhibition'
in the vendor ops, and check it in 'kvm_vcpu_update_apicv' with the above comment on top of it.

need_x2apic_memslot_inhibition can even be set to false when x2avic is supported at the initalization time,
because then AVIC behaves just like APICv (when x2avic bit is enabled, AVIC mmio is no longer decoded).



static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
        if (!lapic_in_kernel(vcpu))
		return;

	/
	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
	 * deleted if any vCPU has x2APIC enabled as SVM without X2AVIC supoprt 
         * doesn't provide fully independent controls for AVIC vs. x2AVIC.
	 * For simplicity, this is sticky.
	/
 
 	if (apic_x2apic_mode(vcpu->arch.apic) && kvm_x86_ops.needs_x2apic_memslot_inhibition)
 		kvm_inhibit_apic_access_page(vcpu);
 
 	__kvm_vcpu_update_apicv(vcpu);
 }


With this fixed:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


>  };
>  
>  struct kvm_arch {
> @@ -1176,10 +1187,11 @@ struct kvm_arch {
>  	struct kvm_apic_map __rcu *apic_map;
>  	atomic_t apic_map_dirty;
>  
> -	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
> -	struct rw_semaphore apicv_update_lock;
> -
>  	bool apic_access_memslot_enabled;
> +	bool apic_access_memslot_inhibited;
> +
> +	/* Protects apicv_inhibit_reasons */
> +	struct rw_semaphore apicv_update_lock;
>  	unsigned long apicv_inhibit_reasons;
>  
>  	gpa_t wall_clock;
> @@ -1912,7 +1924,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>  
>  bool kvm_apicv_activated(struct kvm *kvm);
>  bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
> -void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
> +void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
>  void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  				      enum kvm_apicv_inhibit reason, bool set);
>  void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 80e8b1cc6dc2..42b61469674d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2443,7 +2443,8 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
>  	int ret = 0;
>  
>  	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.apic_access_memslot_enabled)
> +	if (kvm->arch.apic_access_memslot_enabled ||
> +	    kvm->arch.apic_access_memslot_inhibited)
>  		goto out;
>  
>  	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> @@ -2471,6 +2472,41 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
>  
> +void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm->arch.apic_access_memslot_enabled)
> +		return;
> +
> +	kvm_vcpu_srcu_read_unlock(vcpu);
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	if (kvm->arch.apic_access_memslot_enabled) {
> +		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
> +		/*
> +		 * Clear "enabled" after the memslot is deleted so that a
> +		 * different vCPU doesn't get a false negative when checking
> +		 * the flag out of slots_lock.  No additional memory barrier is
> +		 * needed as modifying memslots requires waiting other vCPUs to
> +		 * drop SRCU (see above), and false positives are ok as the
> +		 * flag is rechecked after acquiring slots_lock.kvm_vcpu_update_apicv
> +		 */
> +		kvm->arch.apic_access_memslot_enabled = false;
> +
> +		/*
> +		 * Mark the memslot as inhibited to prevent reallocating the
> +		 * memslot during vCPU creation, e.g. if a vCPU is hotplugged.
> +		 */
> +		kvm->arch.apic_access_memslot_inhibited = true;
> +	}
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	kvm_vcpu_srcu_read_lock(vcpu);
> +}
> +
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0587a8282cb3..a318609bb050 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -113,6 +113,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
>  int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
>  void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
>  int kvm_alloc_apic_access_page(struct kvm *kvm);
> +void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu);
>  
>  bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ec28ba4c5f1b..535e35edce1d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -72,12 +72,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  
>  	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
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
> +	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
> +	 * AVIC in hybrid mode activates only the doorbell mechanism.
>  	 */
>  	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
>  	    avic_mode == AVIC_MODE_X2) {
> @@ -975,7 +975,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>  			  BIT(APICV_INHIBIT_REASON_SEV)      |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> +			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> +			  BIT(APICV_INHIBIT_REASON_X2APIC);
>  
>  	return supported & BIT(reason);
>  }
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 4c620999d230..8d5e00a7ef84 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1084,7 +1084,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	 * to benefit from it right away.
>  	 */
>  	if (kvm_apicv_activated(vcpu->kvm))
> -		kvm_vcpu_update_apicv(vcpu);
> +		__kvm_vcpu_update_apicv(vcpu);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb9d2c23fb04..a20002924eb4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10251,7 +10251,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> -void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> +void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	bool activate;
> @@ -10286,7 +10286,19 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	preempt_enable();
>  	up_read(&vcpu->kvm->arch.apicv_update_lock);
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
> +EXPORT_SYMBOL_GPL(__kvm_vcpu_update_apicv);
> +
> +static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> +{
> +	if (!lapic_in_kernel(vcpu))
> +		return;
> +
> +	if (apic_x2apic_mode(vcpu->arch.apic) &&
> +	    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC))
> +		kvm_inhibit_apic_access_page(vcpu);
> +
> +	__kvm_vcpu_update_apicv(vcpu);
> +}
>  
>  void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  				      enum kvm_apicv_inhibit reason, bool set)


