Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F001558E147
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245467AbiHIUoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245562AbiHIUoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:44:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0E6020BF8
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 13:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660077846;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hF/O21/fgaT52LT5WFrobNDlRU8CsVUcEjOpjpcHhzo=;
        b=L/gsN0rVs+lRCHHYzBD0PNIefJDbCS63X9tNLkatTe4JbegjlM9iY99NkcXx/9HUfbAj4g
        AGLMeBpCOUCyygbSwiALyBJDeP+bYALfpsEP3M7fraZhHVhssKxoTFkg0F6ANIRmE7dANK
        osP/meZjsSnIyno9wnGmOwlDqtWlWxw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-QhVT6_ejOOiMm0SNAlyx8w-1; Tue, 09 Aug 2022 16:44:05 -0400
X-MC-Unique: QhVT6_ejOOiMm0SNAlyx8w-1
Received: by mail-qk1-f198.google.com with SMTP id az14-20020a05620a170e00b006b666c4627bso11197586qkb.23
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 13:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=hF/O21/fgaT52LT5WFrobNDlRU8CsVUcEjOpjpcHhzo=;
        b=X0mrUlVMU7zoCxi3ZMG7J3lfgd7cd0HGwdxaAZTpjbYXYe3kTW+Uh3jzMfch0FTKLB
         9I8oXvEka/7jIlKpZ6y4FBTLKfpmmLBytkO9aNkJdW4lr7K5TiyLq/rSUnF0xMOpxVFz
         A+AiRc2xlzHgHwI5CclLULudpmlnSZClsF1BbNV1i2oDS6rAU9jIvb9IfStzYMjwhnMy
         +Ha0c3OOtvpf7/ZvC8w6vgw6jOqUp/IDrgE2qDObY7Q4alTROKEJqbmpnyEjRlqbLmEq
         qDpNmLFTuP27Dhz4LQq2sxFV/f7qROVrPKMIHZVw6OGY8+kMLh43rgvMWuO5OF5qJMFX
         OjBA==
X-Gm-Message-State: ACgBeo1d+w9I4yCjNyds0foGPtctOQCLEPAEDJ6kgRjos22HVI6LU4pD
        IteDYlEgncKTl7sJUNeJnaMSkfqkdhW5RxbuwYD37n89rjCZ2ulKIf56BzY2JEpq+Od+Nremg1E
        +QW++6r8AGh43
X-Received: by 2002:a05:620a:3704:b0:6b8:f15d:f119 with SMTP id de4-20020a05620a370400b006b8f15df119mr17840448qkb.138.1660077845088;
        Tue, 09 Aug 2022 13:44:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6rehb2XWTsVKGarJ0QY3eUvRu065leXZcH51vY+vGnqGzlMYQADu5i34fa6GFG0Yq+lfe3CQ==
X-Received: by 2002:a05:620a:3704:b0:6b8:f15d:f119 with SMTP id de4-20020a05620a370400b006b8f15df119mr17840423qkb.138.1660077844792;
        Tue, 09 Aug 2022 13:44:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q15-20020ac8450f000000b0034303785596sm2947990qtn.34.2022.08.09.13.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:44:04 -0700 (PDT)
Message-ID: <3fe7398d-6496-717c-c0f0-f7af3c69cdd0@redhat.com>
Date:   Tue, 9 Aug 2022 22:43:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/5] KVM: x86: Add
 kvm_register_and_fire_irq_mask_notifier()
Content-Language: en-US
To:     Dmytro Maluka <dmy@semihalf.com>,
        Sean Christopherson <seanjc@google.com>,
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
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220805193919.1470653-3-dmy@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmytro,

On 8/5/22 21:39, Dmytro Maluka wrote:
> In order to implement postponing resamplefd notification until an
> interrupt is unmasked, we need not only to track changes of the
> interrupt mask state (which is already possible with
> kvm_register_irq_mask_notifier()) but also to know its initial
> mask state before any mask notifier has fired.
>
> Moreover, we need to do this initial check of the IRQ mask state in a
> race-free way, to ensure that we will not miss any further mask or
> unmask events after we check the initial mask state.
>
> So implement kvm_register_and_fire_irq_mask_notifier() which atomically
> registers an IRQ mask notifier and calls it with the current mask value
> of the IRQ. It does that using the same locking order as when calling
> notifier normally via kvm_fire_mask_notifiers(), to prevent deadlocks.
>
> Its implementation needs to be arch-specific since it relies on
> arch-specific synchronization (e.g. ioapic->lock and pic->lock on x86,
> or a per-IRQ lock on ARM vGIC) for serializing our initial reading of
> the IRQ mask state with a pending change of this mask state.
>
> For now implement it for x86 only, and for other archs add a weak dummy
> implementation which doesn't really call the notifier (as other archs
> don't currently implement calling notifiers normally via
> kvm_fire_mask_notifiers() either, i.e. registering mask notifiers has no
> effect on those archs anyway).
>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
> Link: https://lore.kernel.org/lkml/c7b7860e-ae3a-7b98-e97e-28a62470c470@semihalf.com/
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/i8259.c            |  6 ++++
>  arch/x86/kvm/ioapic.c           |  6 ++++
>  arch/x86/kvm/ioapic.h           |  1 +
>  arch/x86/kvm/irq_comm.c         | 57 +++++++++++++++++++++++++++++++++
>  include/linux/kvm_host.h        |  4 +++
>  virt/kvm/eventfd.c              | 31 ++++++++++++++++--
>  7 files changed, 104 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dc76617f11c1..cf0571ed2968 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1834,6 +1834,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
>  
>  int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
>  void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq);
>  
>  void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index e1bb6218bb96..1eb3127f6047 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -211,6 +211,12 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
>  	pic_unlock(s);
>  }
>  
> +/* Called with s->lock held. */
> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
> +{
> +	return !!(s->pics[irq >> 3].imr & (1 << irq));
> +}
> +
>  /*
>   * acknowledge interrupt 'irq'
>   */
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 765943d7cfa5..fab11de1f885 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -478,6 +478,12 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
>  	spin_unlock(&ioapic->lock);
>  }
>  
> +/* Called with ioapic->lock held. */
> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
> +{
> +	return !!ioapic->redirtbl[irq].fields.mask;
> +}
> +
>  static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
>  {
>  	int i;
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 539333ac4b38..fe1f51319992 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -114,6 +114,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>  		       int level, bool line_status);
>  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq);
>  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index f27e4c9c403e..4bd4218821a2 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -234,6 +234,63 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
>  	mutex_unlock(&kvm->irq_lock);
>  }
>  
> +void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
> +					     struct kvm_irq_mask_notifier *kimn)
> +{
> +	struct kvm_pic *pic = kvm->arch.vpic;
> +	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
> +	struct kvm_kernel_irq_routing_entry entries[KVM_NR_IRQCHIPS];
> +	struct kvm_kernel_irq_routing_entry *pic_e = NULL, *ioapic_e = NULL;
> +	int idx, i, n;
> +	bool masked;
> +
> +	mutex_lock(&kvm->irq_lock);
> +
> +	/*
> +	 * Not possible to detect if the guest uses the PIC or the
> +	 * IOAPIC. So assume the interrupt to be unmasked iff it is
> +	 * unmasked in at least one of both.
> +	 */
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	n = kvm_irq_map_gsi(kvm, entries, irq);
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +
> +	for (i = 0; i < n; i++) {
> +		if (entries[i].type != KVM_IRQ_ROUTING_IRQCHIP)
> +			continue;
> +
> +		switch (entries[i].irqchip.irqchip) {
> +		case KVM_IRQCHIP_PIC_MASTER:
> +		case KVM_IRQCHIP_PIC_SLAVE:
> +			pic_e = &entries[i];
> +			break;
> +		case KVM_IRQCHIP_IOAPIC:
> +			ioapic_e = &entries[i];
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (pic_e)
> +		spin_lock(&pic->lock);
> +	if (ioapic_e)
> +		spin_lock(&ioapic->lock);
> +
> +	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
> +
> +	masked = (!pic_e || kvm_pic_irq_is_masked(pic, pic_e->irqchip.pin)) &&
> +		 (!ioapic_e || kvm_ioapic_irq_is_masked(ioapic, ioapic_e->irqchip.pin));
Looks a bit cryptic to me. Don't you want pic_e && masked on pic ||
ioapic_e && masked on ioapic?

> +	kimn->func(kimn, masked);
> +
> +	if (ioapic_e)
> +		spin_unlock(&ioapic->lock);
> +	if (pic_e)
> +		spin_unlock(&pic->lock);
> +
> +	mutex_unlock(&kvm->irq_lock);
> +}
> +
>  bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
>  {
>  	return irqchip_in_kernel(kvm);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index dd5f14e31996..55233eb18eb4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1608,8 +1608,12 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
>  void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
> +void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> +				      struct kvm_irq_mask_notifier *kimn);
>  void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>  				    struct kvm_irq_mask_notifier *kimn);
> +void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
> +					     struct kvm_irq_mask_notifier *kimn);
>  void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
>  				      struct kvm_irq_mask_notifier *kimn);
>  void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 39403d9fbdcc..3007d956b626 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -519,15 +519,42 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  	kvm_arch_post_irq_ack_notifier_list_update(kvm);
>  }
>  
> +void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> +				      struct kvm_irq_mask_notifier *kimn)
> +{
> +	kimn->irq = irq;
> +	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
> +}
> +
>  void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
>  				    struct kvm_irq_mask_notifier *kimn)
>  {
>  	mutex_lock(&kvm->irq_lock);
> -	kimn->irq = irq;
> -	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
> +	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
>  	mutex_unlock(&kvm->irq_lock);
>  }
>  
> +/*
> + * kvm_register_and_fire_irq_mask_notifier() registers the notifier and
> + * immediately calls it with the current mask value of the IRQ. It does
> + * that atomically, so that we will find out the initial mask state of
> + * the IRQ and will not miss any further mask or unmask events. It does
> + * that using the same locking order as when calling notifier normally
> + * via kvm_fire_mask_notifiers(), to prevent deadlocks.
you may document somewhere that it must be called before

kvm_register_irq_ack_notifier()

> + *
> + * Implementation is arch-specific since it relies on arch-specific
> + * (irqchip-specific) synchronization. Below is a weak dummy
> + * implementation for archs not implementing it yet, as those archs
> + * don't implement calling notifiers normally via
> + * kvm_fire_mask_notifiers() either, i.e. registering mask notifiers
> + * has no effect on those archs anyway.
I would advise you to put Marc in the loop for the whole series (adding
him in CC).

Thanks

Eric
> + */
> +void __weak kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
> +						    struct kvm_irq_mask_notifier *kimn)
> +{
> +	kvm_register_irq_mask_notifier(kvm, irq, kimn);
> +}
> +
>  void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
>  				      struct kvm_irq_mask_notifier *kimn)
>  {

