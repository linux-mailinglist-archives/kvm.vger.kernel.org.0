Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD90758E145
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbiHIUnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbiHIUnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:43:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24CE81EC72
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 13:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660077829;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VHCqagx+Q/5UqLIOqFwQ1G5YBCgWRBgX1q89tLaRlLY=;
        b=HMHuQqct4k0Um2tE8hxh77rJUjUCrhquax0KJA2o8l5UnKWOLHJsf+SPfP0rKulnTKvrOv
        oPVcxRGHcKHFqR7vEqu8GcIwZ2u+P7L2hHUc8V0fRiKFB9VC/NUW1QGPfTOtGA9gR0JqJL
        xDCBY0sZsQrJlfPuDrymvwKKoD4gxNg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-lAHvNmIcOK-KHyZz_pj23A-1; Tue, 09 Aug 2022 16:43:48 -0400
X-MC-Unique: lAHvNmIcOK-KHyZz_pj23A-1
Received: by mail-qv1-f72.google.com with SMTP id oh2-20020a056214438200b0047bd798af75so1571158qvb.6
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 13:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=VHCqagx+Q/5UqLIOqFwQ1G5YBCgWRBgX1q89tLaRlLY=;
        b=IKG51Li05eYPkCgeuQ1bX9Je8j2ndRzqBWKr2Vvg4Qkk2acNP2hZYfhSVeaEs0XMzW
         z9b3jwV3RhVL0nSUiSZupHF+p7SZZaiCmnkYf/4vdAe/Jrcmhx9vxSCueu9EJAptmut+
         eKkUR97wdat1z4hAmmPTStsrO7Jgic+umxyBbcfo7+iXMUNxUExL2eSbA/aAm1N5uCoM
         HT0qexMiYTNS/c/boaTW9bhlOe9qip4duYbEFl74pYzLHuIeLfNeF2OeqDz7xy1W+4IO
         4G1sZmE/K+a1sx0hczR/3KP2p/GjTGFh24HbADB3Hp9JP4m9TzEnIJeOZxVsvZ0RP30k
         ua9A==
X-Gm-Message-State: ACgBeo0s9mdSYIa+IYSdLZZdhwBcohD8C3OgLfuZdDYVT7rCqYR06m3R
        MqC9b25hPEfOQLzcupMqmlYGl0RxBxuP2XaM50u3xjEmeQtzW360kXeRw2eWm8HdUtn1qexSv2+
        YHBX+2urApdyZ
X-Received: by 2002:a05:620a:4f1:b0:6b9:4a38:3d5a with SMTP id b17-20020a05620a04f100b006b94a383d5amr8510631qkh.291.1660077827580;
        Tue, 09 Aug 2022 13:43:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4v7XpirFxkeQr8yHl2flNupq/yC4ddptLH2fHH6UlHswTFg36I0FSF1l+rgXrUOuw6ueFTnA==
X-Received: by 2002:a05:620a:4f1:b0:6b9:4a38:3d5a with SMTP id b17-20020a05620a04f100b006b94a383d5amr8510614qkh.291.1660077827345;
        Tue, 09 Aug 2022 13:43:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m16-20020a05620a24d000b006b8cff25187sm13066668qkn.42.2022.08.09.13.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:43:46 -0700 (PDT)
Message-ID: <9548fad8-3146-7c28-1828-bc676d2a41bc@redhat.com>
Date:   Tue, 9 Aug 2022 22:43:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/5] KVM: x86: Move irq mask notifiers from x86 to
 generic KVM
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
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <20220805193919.1470653-2-dmy@semihalf.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220805193919.1470653-2-dmy@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmytro,
On 8/5/22 21:39, Dmytro Maluka wrote:
> Currently irq mask notifiers are used only internally in the x86 code
> for PIT emulation. However they are not really arch specific. We are
> going to use them in the generic irqfd code, for postponing resampler
> irqfd notification until the interrupt is unmasked. So move the
> implementation of mask notifiers to the generic code, to allow irqfd to
> register its mask notifiers.
>
> Note that calling mask notifiers via calling kvm_fire_mask_notifiers()
> is still implemented for x86 only, so registering mask notifiers on
> other architectures will have no effect for now.
>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/x86/include/asm/kvm_host.h | 16 ----------------
>  arch/x86/kvm/irq_comm.c         | 33 ---------------------------------
>  arch/x86/kvm/x86.c              |  1 -
>  include/linux/kvm_host.h        | 15 +++++++++++++++
>  virt/kvm/eventfd.c              | 33 +++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c             |  1 +
>  6 files changed, 49 insertions(+), 50 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9217bd6cf0d1..dc76617f11c1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1198,9 +1198,6 @@ struct kvm_arch {
>  
>  	struct kvm_xen_hvm_config xen_hvm_config;
>  
> -	/* reads protected by irq_srcu, writes by irq_lock */
> -	struct hlist_head mask_notifier_list;
> -
>  	struct kvm_hv hyperv;
>  	struct kvm_xen xen;
>  
> @@ -1688,19 +1685,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
>  int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			  const void *val, int bytes);
>  
> -struct kvm_irq_mask_notifier {
> -	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
> -	int irq;
> -	struct hlist_node link;
> -};
> -
> -void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> -				    struct kvm_irq_mask_notifier *kimn);
> -void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
> -				      struct kvm_irq_mask_notifier *kimn);
> -void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
> -			     bool mask);
> -
>  extern bool tdp_enabled;
>  
>  u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 0687162c4f22..f27e4c9c403e 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -234,39 +234,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
>  	mutex_unlock(&kvm->irq_lock);
>  }
>  
> -void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> -				    struct kvm_irq_mask_notifier *kimn)
> -{
> -	mutex_lock(&kvm->irq_lock);
> -	kimn->irq = irq;
> -	hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
> -	mutex_unlock(&kvm->irq_lock);
> -}
> -
> -void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
> -				      struct kvm_irq_mask_notifier *kimn)
> -{
> -	mutex_lock(&kvm->irq_lock);
> -	hlist_del_rcu(&kimn->link);
> -	mutex_unlock(&kvm->irq_lock);
> -	synchronize_srcu(&kvm->irq_srcu);
> -}
> -
> -void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
> -			     bool mask)
> -{
> -	struct kvm_irq_mask_notifier *kimn;
> -	int idx, gsi;
> -
> -	idx = srcu_read_lock(&kvm->irq_srcu);
> -	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
> -	if (gsi != -1)
> -		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
> -			if (kimn->irq == gsi)
> -				kimn->func(kimn, mask);
> -	srcu_read_unlock(&kvm->irq_srcu, idx);
> -}
> -
>  bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
>  {
>  	return irqchip_in_kernel(kvm);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5fa335a4ea7..a0a776f5c42f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11818,7 +11818,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out_page_track;
>  
> -	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>  	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>  	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 90a45ef7203b..dd5f14e31996 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -760,7 +760,10 @@ struct kvm {
>  	struct kvm_irq_routing_table __rcu *irq_routing;
>  #endif
>  #ifdef CONFIG_HAVE_KVM_IRQFD
> +	/* reads protected by irq_srcu, writes by irq_lock */
>  	struct hlist_head irq_ack_notifier_list;
> +	/* reads protected by irq_srcu, writes by irq_lock */
> +	struct hlist_head irq_mask_notifier_list;
>  #endif
>  
>  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> @@ -1581,6 +1584,12 @@ struct kvm_irq_ack_notifier {
>  	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
>  };
>  
> +struct kvm_irq_mask_notifier {
> +	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
> +	int irq;
> +	struct hlist_node link;
> +};
> +
>  int kvm_irq_map_gsi(struct kvm *kvm,
>  		    struct kvm_kernel_irq_routing_entry *entries, int gsi);
>  int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin);
> @@ -1599,6 +1608,12 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
>  void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
> +void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> +				    struct kvm_irq_mask_notifier *kimn);
> +void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
> +				      struct kvm_irq_mask_notifier *kimn);
> +void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
> +			     bool mask);
>  int kvm_request_irq_source_id(struct kvm *kvm);
>  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
>  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2a3ed401ce46..39403d9fbdcc 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -518,6 +518,39 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  	synchronize_srcu(&kvm->irq_srcu);
>  	kvm_arch_post_irq_ack_notifier_list_update(kvm);
>  }
> +
> +void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> +				    struct kvm_irq_mask_notifier *kimn)
> +{
> +	mutex_lock(&kvm->irq_lock);
> +	kimn->irq = irq;
> +	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
> +	mutex_unlock(&kvm->irq_lock);
> +}
> +
> +void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
> +				      struct kvm_irq_mask_notifier *kimn)
> +{
> +	mutex_lock(&kvm->irq_lock);
> +	hlist_del_rcu(&kimn->link);
> +	mutex_unlock(&kvm->irq_lock);
> +	synchronize_srcu(&kvm->irq_srcu);
> +}
> +
> +void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
> +			     bool mask)
> +{
> +	struct kvm_irq_mask_notifier *kimn;
> +	int idx, gsi;
> +
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
> +	if (gsi != -1)
> +		hlist_for_each_entry_rcu(kimn, &kvm->irq_mask_notifier_list, link)
> +			if (kimn->irq == gsi)
> +				kimn->func(kimn, mask);
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +}
>  #endif
>  
>  void
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a49df8988cd6..5ca7fb0b8257 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1144,6 +1144,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>  	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
> +	INIT_HLIST_HEAD(&kvm->irq_mask_notifier_list);
>  #endif
>  
>  	r = kvm_init_mmu_notifier(kvm);

