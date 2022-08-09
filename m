Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9940058E150
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbiHIUqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbiHIUpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:45:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14A6EB4B2
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660077931;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/i6fOhflSC2Z18Mj3rM5lG4QJQLFl+L71qd8wct29I=;
        b=WeRbD6rsdE8hvd3iJbvJOzDQghUDc+eeAHj6sTAx2FV1Tn0htJcLenF0xugxaaI4T4OVrR
        WwHiavnSYmjmomgZLU2cDH753AQlR8N1gAveoDP+aKujgU9QqV+s8AVhfekT0V/M0X3zSw
        LBO2+hEx7ZFggwAflYM64WbyVCdHWj8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-Y82fgQMPPsOcRqvf097ioQ-1; Tue, 09 Aug 2022 16:45:30 -0400
X-MC-Unique: Y82fgQMPPsOcRqvf097ioQ-1
Received: by mail-qt1-f200.google.com with SMTP id hf13-20020a05622a608d00b003214b6b3777so9847314qtb.13
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 13:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=H/i6fOhflSC2Z18Mj3rM5lG4QJQLFl+L71qd8wct29I=;
        b=s3QUEVdszL/CADriFXZI3GS4LkAW2SFmuHC3pZKzB0QbOifKTcar6kRgGuAN5uxFo7
         2FcgbIbKMgItL1rapTYH06C71Fh5H7/zl54gy+4C/3Z2OtKXJUlwgag7mSXRuERmjLKf
         qhpnP/1jucvmWHg2olNymn1CHL90dN3PWk4rlaBZVXzlKdaz+ttTEN2J1VWT0TgBapM4
         ataZxtq4Ud05IzEgxumYnhZuSig6nIkeIKu+sExhwwfOjTR5wJ5+W0W8faEQpuXszpxF
         +NZQvC5pbrzH97J+KD0G8IIrAS6rsxns2bfQDbPug2+K8mjXVh2WXg9VWYGDgn0xcaVs
         rHXw==
X-Gm-Message-State: ACgBeo2Z7wvp6D0eOJ2KoJrctF+nwdw1KNsLY9liRCkqDhFxHPQBN/jc
        pbcVZmP7/iq8R7Iue9qil0t0NjXDicsZl8igTKyP4KSicQ9319bziXIzfWkNvbdso0V+32Jnekq
        DFH0rNhwJsf+p
X-Received: by 2002:a05:622a:394:b0:31f:4518:2656 with SMTP id j20-20020a05622a039400b0031f45182656mr21801069qtx.174.1660077930264;
        Tue, 09 Aug 2022 13:45:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7T3x9qb5STCbT5iYR3g4AYyyOkm6wcALFX9S2H0JvmSUuJXwQELjGl514Pn9qv1FASiP0oqw==
X-Received: by 2002:a05:622a:394:b0:31f:4518:2656 with SMTP id j20-20020a05622a039400b0031f45182656mr21801048qtx.174.1660077929984;
        Tue, 09 Aug 2022 13:45:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id x21-20020a05620a0ed500b006b615cd8c13sm11404289qkm.106.2022.08.09.13.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:45:29 -0700 (PDT)
Message-ID: <56ab2bc2-378b-3ece-2d45-e0f484087aa7@redhat.com>
Date:   Tue, 9 Aug 2022 22:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 3/5] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
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
 <20220805193919.1470653-4-dmy@semihalf.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220805193919.1470653-4-dmy@semihalf.com>
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
> The existing KVM mechanism for forwarding of level-triggered interrupts
> using resample eventfd doesn't work quite correctly in the case of
> interrupts that are handled in a Linux guest as oneshot interrupts
> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
> threaded irq handler, i.e. later than it is acked to the interrupt
> controller (EOI at the end of hardirq), not earlier.
>
> Linux keeps such interrupt masked until its threaded handler finishes,
> to prevent the EOI from re-asserting an unacknowledged interrupt.
> However, with KVM + vfio (or whatever is listening on the resamplefd)
> we don't check that the interrupt is still masked in the guest at the
> moment of EOI. Resamplefd is notified regardless, so vfio prematurely
> unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
> is generated in the host and queued for injection to the guest.
>
> The fact that the virtual IRQ is still masked doesn't prevent this new
> physical IRQ from being propagated to the guest, because:
>
> 1. It is not guaranteed that the vIRQ will remain masked by the time
>    when vfio signals the trigger eventfd.
> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
>    new pending interrupt is injected by KVM to the guest anyway.
>
> There are observed at least 2 user-visible issues caused by those
> extra erroneous pending interrupts for oneshot irq in the guest:
>
> 1. System suspend aborted due to a pending wakeup interrupt from
>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>    every time the touchpad is touched.
>
> This patch fixes the issue on x86 by checking if the interrupt is
> unmasked when we receive irq ack (EOI) and, in case if it's masked,
> postponing resamplefd notify until the guest unmasks it.
>
> It doesn't fix the issue for other archs yet, since it relies on KVM
> irq mask notifiers functionality which currently works only on x86.
> On other archs we can register mask notifiers but they are never called.
> So on other archs resampler->masked is always false, so the behavior is
> the same as before this patch.
>
> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
> ---
>  include/linux/kvm_irqfd.h | 14 ++++++++++
>  virt/kvm/eventfd.c        | 56 +++++++++++++++++++++++++++++++++++----
>  2 files changed, 65 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index dac047abdba7..01754a1abb9e 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -19,6 +19,16 @@
>   * resamplefd.  All resamplers on the same gsi are de-asserted
>   * together, so we don't need to track the state of each individual
>   * user.  We can also therefore share the same irq source ID.
> + *
> + * A special case is when the interrupt is still masked at the moment
> + * an irq ack is received. That likely means that the interrupt has
> + * been acknowledged to the interrupt controller but not acknowledged
> + * to the device yet, e.g. it might be a Linux guest's threaded
> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
> + * resamplefd is postponed until the guest unmasks the interrupt,
> + * which is detected through the irq mask notifier. This prevents
> + * erroneous extra interrupts caused by premature re-assert of an
> + * unacknowledged interrupt by the resamplefd listener.
>   */
>  struct kvm_kernel_irqfd_resampler {
>  	struct kvm *kvm;
> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>  	 */
>  	struct list_head list;
>  	struct kvm_irq_ack_notifier notifier;
> +	struct kvm_irq_mask_notifier mask_notifier;
> +	bool masked;
> +	bool pending;
> +	spinlock_t lock;
>  	/*
>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>  	 * resamplers among irqfds on the same gsi.
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 3007d956b626..f98dcce3959c 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -67,6 +67,7 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
>  	struct kvm *kvm;
>  	struct kvm_kernel_irqfd *irqfd;
>  	int idx;
> +	bool notify = true;
>  
>  	resampler = container_of(kian,
>  			struct kvm_kernel_irqfd_resampler, notifier);
> @@ -75,13 +76,52 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  		    resampler->notifier.gsi, 0, false);
>  
> -	idx = srcu_read_lock(&kvm->irq_srcu);
> +	spin_lock(&resampler->lock);
> +	if (resampler->masked) {
> +		notify = false;
> +		resampler->pending = true;
> +	}
> +	spin_unlock(&resampler->lock);
> +
> +	if (notify) {
> +		idx = srcu_read_lock(&kvm->irq_srcu);
>  
> -	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> -	    srcu_read_lock_held(&kvm->irq_srcu))
> -		eventfd_signal(irqfd->resamplefd, 1);
> +		list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> +		    srcu_read_lock_held(&kvm->irq_srcu))
> +			eventfd_signal(irqfd->resamplefd, 1);
nit: you may introduce a helper for above code as the code is duplicated.
>  
> -	srcu_read_unlock(&kvm->irq_srcu, idx);
> +		srcu_read_unlock(&kvm->irq_srcu, idx);
> +	}
> +}
> +
> +static void irqfd_resampler_mask_notify(struct kvm_irq_mask_notifier *kimn,
> +					bool masked)
> +{
> +	struct kvm_kernel_irqfd_resampler *resampler;
> +	struct kvm *kvm;
> +	struct kvm_kernel_irqfd *irqfd;
> +	int idx;
> +	bool notify;
> +
> +	resampler = container_of(kimn,
> +			struct kvm_kernel_irqfd_resampler, mask_notifier);
> +	kvm = resampler->kvm;
> +
> +	spin_lock(&resampler->lock);
> +	notify = !masked && resampler->pending;
> +	resampler->masked = masked;
> +	resampler->pending = false;
> +	spin_unlock(&resampler->lock);
> +
> +	if (notify) {
> +		idx = srcu_read_lock(&kvm->irq_srcu);
> +
> +		list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> +		    srcu_read_lock_held(&kvm->irq_srcu))
> +			eventfd_signal(irqfd->resamplefd, 1);
> +
> +		srcu_read_unlock(&kvm->irq_srcu, idx);
> +	}
>  }
>  
>  static void
> @@ -98,6 +138,8 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
>  	if (list_empty(&resampler->list)) {
>  		list_del(&resampler->link);
>  		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
> +		kvm_unregister_irq_mask_notifier(kvm, resampler->mask_notifier.irq,
> +						 &resampler->mask_notifier);
>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  			    resampler->notifier.gsi, 0, false);
>  		kfree(resampler);
> @@ -367,9 +409,13 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  			INIT_LIST_HEAD(&resampler->list);
>  			resampler->notifier.gsi = irqfd->gsi;
>  			resampler->notifier.irq_acked = irqfd_resampler_ack;
> +			resampler->mask_notifier.func = irqfd_resampler_mask_notify;
> +			spin_lock_init(&resampler->lock);
>  			INIT_LIST_HEAD(&resampler->link);
>  
>  			list_add(&resampler->link, &kvm->irqfds.resampler_list);
> +			kvm_register_and_fire_irq_mask_notifier(kvm, irqfd->gsi,
> +								&resampler->mask_notifier);
>  			kvm_register_irq_ack_notifier(kvm,
>  						      &resampler->notifier);
>  			irqfd->resampler = resampler;
Adding Marc in CC

Thanks

Eric

