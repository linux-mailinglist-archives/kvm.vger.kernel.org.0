Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFFB58E3EC
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 01:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiHIX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 19:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiHIX4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 19:56:37 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FB380495
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 16:56:34 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e15so19154310lfs.0
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 16:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=gUuhPzrcnrqpheUY4XkJI2wptYkRTVtSUR+joOkMlL0=;
        b=hhgOGpYxiDb+Y1lQQWGM+An5CSIukHuN7+js1MlfBaZ5CdDIxJK8QnnshuemoPA/m5
         8gVX4E/oNMg6Z/kSrBG0ZoAEvxfq/+sGQjtebAfiSl+xdVanDjL9eH4WgrPhMCc3C7nC
         9Grk8AXtre6YGbsC7AllUYKe0fDPE3cKIlyHULgAhCJgXZasRhf6zNe9VAigw1KKsxgX
         N6yYCeWWbMlODCu7TYUapresE15Lsp73NW6qkJLNFRTrLHfkwa8bpnEdMnlDgw62vc8O
         ehyyZpye/byJinMRwm6PPL70cyn9ecMTMI7yAaLTOP1IP9BHbp1v23cKdCjHE39SCh0z
         puow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=gUuhPzrcnrqpheUY4XkJI2wptYkRTVtSUR+joOkMlL0=;
        b=r8ZfskmTwfhRvHZf6HbAOmoBSD94ICEHc7C3AZb16y/Aqim3TjLSapE1Gt4h31HWa6
         Yk/Xdc7JtpLJ/9ncm/qCFf0qdImJILwIyFQk0gYjtitv2HYnXtF9eDNVo731NZO6Znl4
         eeVjfHGDcZl76sbVQo2tC3vtcDedA8sdtFXRne1GJ801qmSYsgcKT8AGSkz+Ai+P7grp
         eh7aRpcpt2tFXXkN+Wd1wX8db3pTmvEiuBHslwWJwysbPvULckBRIpEGwLn415rlbnN/
         wBdpYUG77q+aICc9yAm94NqGC9fxhI3PL+ROhm/LVNU/aSJQWPqqCYmJdsel4xdQnmAd
         xJcg==
X-Gm-Message-State: ACgBeo1uB+0Dw9M+HHwNR9GNaSkTByFbm/qw0/eb4EBYHEjk9gQVYGBg
        bfUbVM/c+bWAQdfmTqdJlSDHVA==
X-Google-Smtp-Source: AA6agR7Su6Z51/z9A/JyhsSTEncsYT4JZNQ+XNJDqglIcK2SNz+IaYg4FeESiMYn5t6OMfq6N83Yyw==
X-Received: by 2002:a05:6512:220d:b0:48b:45b:ac3d with SMTP id h13-20020a056512220d00b0048b045bac3dmr8304982lfu.15.1660089393055;
        Tue, 09 Aug 2022 16:56:33 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id a5-20020a056512390500b0048aeafde9b8sm131218lfu.108.2022.08.09.16.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 16:56:32 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] KVM: x86: Add
 kvm_register_and_fire_irq_mask_notifier()
To:     eric.auger@redhat.com, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <20220805193919.1470653-3-dmy@semihalf.com>
 <3fe7398d-6496-717c-c0f0-f7af3c69cdd0@redhat.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <c4fe06be-25fc-2c97-80ce-30b4dfe18e66@semihalf.com>
Date:   Wed, 10 Aug 2022 01:56:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3fe7398d-6496-717c-c0f0-f7af3c69cdd0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 8/9/22 10:43 PM, Eric Auger wrote:
> Hi Dmytro,
> 
> On 8/5/22 21:39, Dmytro Maluka wrote:
>> In order to implement postponing resamplefd notification until an
>> interrupt is unmasked, we need not only to track changes of the
>> interrupt mask state (which is already possible with
>> kvm_register_irq_mask_notifier()) but also to know its initial
>> mask state before any mask notifier has fired.
>>
>> Moreover, we need to do this initial check of the IRQ mask state in a
>> race-free way, to ensure that we will not miss any further mask or
>> unmask events after we check the initial mask state.
>>
>> So implement kvm_register_and_fire_irq_mask_notifier() which atomically
>> registers an IRQ mask notifier and calls it with the current mask value
>> of the IRQ. It does that using the same locking order as when calling
>> notifier normally via kvm_fire_mask_notifiers(), to prevent deadlocks.
>>
>> Its implementation needs to be arch-specific since it relies on
>> arch-specific synchronization (e.g. ioapic->lock and pic->lock on x86,
>> or a per-IRQ lock on ARM vGIC) for serializing our initial reading of
>> the IRQ mask state with a pending change of this mask state.
>>
>> For now implement it for x86 only, and for other archs add a weak dummy
>> implementation which doesn't really call the notifier (as other archs
>> don't currently implement calling notifiers normally via
>> kvm_fire_mask_notifiers() either, i.e. registering mask notifiers has no
>> effect on those archs anyway).
>>
>> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
>> Link: https://lore.kernel.org/lkml/c7b7860e-ae3a-7b98-e97e-28a62470c470@semihalf.com/
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/i8259.c            |  6 ++++
>>  arch/x86/kvm/ioapic.c           |  6 ++++
>>  arch/x86/kvm/ioapic.h           |  1 +
>>  arch/x86/kvm/irq_comm.c         | 57 +++++++++++++++++++++++++++++++++
>>  include/linux/kvm_host.h        |  4 +++
>>  virt/kvm/eventfd.c              | 31 ++++++++++++++++--
>>  7 files changed, 104 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index dc76617f11c1..cf0571ed2968 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1834,6 +1834,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
>>  
>>  int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
>>  void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
>> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq);
>>  
>>  void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>>  
>> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
>> index e1bb6218bb96..1eb3127f6047 100644
>> --- a/arch/x86/kvm/i8259.c
>> +++ b/arch/x86/kvm/i8259.c
>> @@ -211,6 +211,12 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
>>  	pic_unlock(s);
>>  }
>>  
>> +/* Called with s->lock held. */
>> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
>> +{
>> +	return !!(s->pics[irq >> 3].imr & (1 << irq));
>> +}
>> +
>>  /*
>>   * acknowledge interrupt 'irq'
>>   */
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 765943d7cfa5..fab11de1f885 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -478,6 +478,12 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
>>  	spin_unlock(&ioapic->lock);
>>  }
>>  
>> +/* Called with ioapic->lock held. */
>> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
>> +{
>> +	return !!ioapic->redirtbl[irq].fields.mask;
>> +}
>> +
>>  static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
>>  {
>>  	int i;
>> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
>> index 539333ac4b38..fe1f51319992 100644
>> --- a/arch/x86/kvm/ioapic.h
>> +++ b/arch/x86/kvm/ioapic.h
>> @@ -114,6 +114,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
>>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>>  		       int level, bool line_status);
>>  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
>> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq);
>>  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>>  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>>  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>> index f27e4c9c403e..4bd4218821a2 100644
>> --- a/arch/x86/kvm/irq_comm.c
>> +++ b/arch/x86/kvm/irq_comm.c
>> @@ -234,6 +234,63 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
>>  	mutex_unlock(&kvm->irq_lock);
>>  }
>>  
>> +void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
>> +					     struct kvm_irq_mask_notifier *kimn)
>> +{
>> +	struct kvm_pic *pic = kvm->arch.vpic;
>> +	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
>> +	struct kvm_kernel_irq_routing_entry entries[KVM_NR_IRQCHIPS];
>> +	struct kvm_kernel_irq_routing_entry *pic_e = NULL, *ioapic_e = NULL;
>> +	int idx, i, n;
>> +	bool masked;
>> +
>> +	mutex_lock(&kvm->irq_lock);
>> +
>> +	/*
>> +	 * Not possible to detect if the guest uses the PIC or the
>> +	 * IOAPIC. So assume the interrupt to be unmasked iff it is
>> +	 * unmasked in at least one of both.
>> +	 */
>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>> +	n = kvm_irq_map_gsi(kvm, entries, irq);
>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>> +
>> +	for (i = 0; i < n; i++) {
>> +		if (entries[i].type != KVM_IRQ_ROUTING_IRQCHIP)
>> +			continue;
>> +
>> +		switch (entries[i].irqchip.irqchip) {
>> +		case KVM_IRQCHIP_PIC_MASTER:
>> +		case KVM_IRQCHIP_PIC_SLAVE:
>> +			pic_e = &entries[i];
>> +			break;
>> +		case KVM_IRQCHIP_IOAPIC:
>> +			ioapic_e = &entries[i];
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (pic_e)
>> +		spin_lock(&pic->lock);
>> +	if (ioapic_e)
>> +		spin_lock(&ioapic->lock);
>> +
>> +	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
>> +
>> +	masked = (!pic_e || kvm_pic_irq_is_masked(pic, pic_e->irqchip.pin)) &&
>> +		 (!ioapic_e || kvm_ioapic_irq_is_masked(ioapic, ioapic_e->irqchip.pin));
> Looks a bit cryptic to me. Don't you want pic_e && masked on pic ||
> ioapic_e && masked on ioapic?

That would be quite different: it would be "masked on at least one of
both", while I want "masked on both (if both are used)".

> 
>> +	kimn->func(kimn, masked);
>> +
>> +	if (ioapic_e)
>> +		spin_unlock(&ioapic->lock);
>> +	if (pic_e)
>> +		spin_unlock(&pic->lock);
>> +
>> +	mutex_unlock(&kvm->irq_lock);
>> +}
>> +
>>  bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
>>  {
>>  	return irqchip_in_kernel(kvm);
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index dd5f14e31996..55233eb18eb4 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1608,8 +1608,12 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
>>  				   struct kvm_irq_ack_notifier *kian);
>>  void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>>  				   struct kvm_irq_ack_notifier *kian);
>> +void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>> +				      struct kvm_irq_mask_notifier *kimn);
>>  void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>>  				    struct kvm_irq_mask_notifier *kimn);
>> +void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
>> +					     struct kvm_irq_mask_notifier *kimn);
>>  void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
>>  				      struct kvm_irq_mask_notifier *kimn);
>>  void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 39403d9fbdcc..3007d956b626 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -519,15 +519,42 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>>  	kvm_arch_post_irq_ack_notifier_list_update(kvm);
>>  }
>>  
>> +void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>> +				      struct kvm_irq_mask_notifier *kimn)
>> +{
>> +	kimn->irq = irq;
>> +	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
>> +}
>> +
>>  void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>>  				    struct kvm_irq_mask_notifier *kimn)
>>  {
>>  	mutex_lock(&kvm->irq_lock);
>> -	kimn->irq = irq;
>> -	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
>> +	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
>>  	mutex_unlock(&kvm->irq_lock);
>>  }
>>  
>> +/*
>> + * kvm_register_and_fire_irq_mask_notifier() registers the notifier and
>> + * immediately calls it with the current mask value of the IRQ. It does
>> + * that atomically, so that we will find out the initial mask state of
>> + * the IRQ and will not miss any further mask or unmask events. It does
>> + * that using the same locking order as when calling notifier normally
>> + * via kvm_fire_mask_notifiers(), to prevent deadlocks.
> you may document somewhere that it must be called before
> 
> kvm_register_irq_ack_notifier()

Actually I think it would still be ok to call it after
kvm_register_irq_ack_notifier(), not necessarily before. We could then
miss a mask notification between kvm_register_irq_ack_notifier() and
kvm_register_and_fire_irq_mask_notifier(), but it's ok since
kvm_register_and_fire_irq_mask_notifier() would then immediately send a
new notification with the up-to-date mask value.

> 
>> + *
>> + * Implementation is arch-specific since it relies on arch-specific
>> + * (irqchip-specific) synchronization. Below is a weak dummy
>> + * implementation for archs not implementing it yet, as those archs
>> + * don't implement calling notifiers normally via
>> + * kvm_fire_mask_notifiers() either, i.e. registering mask notifiers
>> + * has no effect on those archs anyway.
> I would advise you to put Marc in the loop for the whole series (adding
> him in CC).

Ok.

> 
> Thanks
> 
> Eric
>> + */
>> +void __weak kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
>> +						    struct kvm_irq_mask_notifier *kimn)
>> +{
>> +	kvm_register_irq_mask_notifier(kvm, irq, kimn);
>> +}
>> +
>>  void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
>>  				      struct kvm_irq_mask_notifier *kimn)
>>  {
> 
