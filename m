Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFB8585ACD
	for <lists+kvm@lfdr.de>; Sat, 30 Jul 2022 16:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiG3OfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jul 2022 10:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiG3OfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jul 2022 10:35:05 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5AB16596
        for <kvm@vger.kernel.org>; Sat, 30 Jul 2022 07:35:03 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id p21so7905966ljh.12
        for <kvm@vger.kernel.org>; Sat, 30 Jul 2022 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HYBvPQ0/dZTssANTzYAcyxdQOc98Xjy8TUlO08s2/HY=;
        b=VAaazy479QCvUyl13T9eLxbGRQOz+DWtmF8DI2HBSDdy9Rd/IcnZIVAtGJdJM0hHEI
         URFEVrKGhlcEH3pU3LJX6d6fb/lS9Pyg1WCQAwsjaJhBbie3G3bXg/E6bWW6v7fk6JCL
         xcOTksbny4Bx7Ij9Av18xk5JR82/m2Ns6NvxKGRiDXQHhJiIMXQivNlOW3eJdq8MkUG4
         +Hm0bWPs9+F301Y+z8KdLfSUd83fLdUnh/nkwozkDaAEQbEJX5f5R3Qy3LOB8pCmueMd
         nyDaQa7MwLjoSnlUn69uMQFONMlkkHgxMNuE339RZJIIweCymYQWgI3AJN6wphD/KNZo
         sk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYBvPQ0/dZTssANTzYAcyxdQOc98Xjy8TUlO08s2/HY=;
        b=dDdT5oDLwMNzKI6Kyas4k+HZoLAMP60EX7E7u1DciK3x6y5R+ScuI9sqLMOvH7psFS
         CJnEfcHKUD/hUlF7pc5xb1EA4xpZ0PR5iCOTbTCHkVjvqxoAXlu79XNRwYV5200DHWRk
         BAeyuccJ3gIm52dv+26Ooa1Fp83GCn/OEQfG6feTIDzW5i6WvgY4uzpQLCaL4VE5W3TW
         VOMfymwWvs6LyEZvK1KER6eWQbEP8SPUFfJyfokE310WgdG4BMwfSUZgD6/Gpqa1vDHA
         OG3e2Zk7mApezM/n9wbU3eVd4WbM2CwvJ3XA2b6yID8p6s85jWGnPs12ob1OQ8KYrWIN
         2j9g==
X-Gm-Message-State: AJIora9pUHYdL0h/6miU9eu2GEbCDBPwaKwXGFdxPYxaWKGB7EZFf7Mj
        JdbZuJaVc56wct/ZeVpA10rZgA==
X-Google-Smtp-Source: AGRyM1va6iRmgjJh6MKj+SRZ4XvvjVifZWTA8CpufbE139IsxPIY8cbRUjV4lssqnPvMZssJWAZB0g==
X-Received: by 2002:a2e:a7cc:0:b0:25e:22db:fb0d with SMTP id x12-20020a2ea7cc000000b0025e22dbfb0dmr2563865ljp.494.1659191701564;
        Sat, 30 Jul 2022 07:35:01 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id v8-20020a2ea448000000b0025e2c5a12b6sm1005041ljn.129.2022.07.30.07.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 07:35:01 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
To:     "Liu, Rong L" <rong.l.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-4-dmy@semihalf.com>
 <MW3PR11MB4554E98CE51B883764BE4FB4C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
 <e5e5ca30-6ae6-250d-7c1e-77ebfabc4c1f@semihalf.com>
 <MW3PR11MB4554A01E691ED2070D98EE2CC7999@MW3PR11MB4554.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <923b0e08-6e19-69c1-a9a2-4127c619e707@semihalf.com>
Date:   Sat, 30 Jul 2022 16:34:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB4554A01E691ED2070D98EE2CC7999@MW3PR11MB4554.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/22 10:48 PM, Liu, Rong L wrote:
> Hi Dmytro,
> 
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Tuesday, July 26, 2022 7:08 AM
>> To: Liu, Rong L <rong.l.liu@intel.com>; Christopherson,, Sean
>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>> kvm@vger.kernel.org
>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>> <eric.auger@redhat.com>; Alex Williamson
>> <alex.williamson@redhat.com>; Zhenyu Wang
>> <zhenyuw@linux.intel.com>; Tomasz Nowicki <tn@semihalf.com>;
>> Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry Torokhov
>> <dtor@google.com>
>> Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for
>> oneshot interrupts
>>
>> Hi Rong,
>>
>> On 7/26/22 01:44, Liu, Rong L wrote:
>>> Hi Dmytro,
>>>
>>>> -----Original Message-----
>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>> Sent: Friday, July 15, 2022 8:59 AM
>>>> To: Christopherson,, Sean <seanjc@google.com>; Paolo Bonzini
>>>> <pbonzini@redhat.com>; kvm@vger.kernel.org
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>>>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
>>>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>>>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>>>> <eric.auger@redhat.com>; Alex Williamson
>>>> <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry
>>>> Torokhov <dtor@google.com>; Dmytro Maluka <dmy@semihalf.com>
>>>> Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for
>> oneshot
>>>> interrupts
>>>>
>>>> The existing KVM mechanism for forwarding of level-triggered
>> interrupts
>>>> using resample eventfd doesn't work quite correctly in the case of
>>>> interrupts that are handled in a Linux guest as oneshot interrupts
>>>> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
>>>> threaded irq handler, i.e. later than it is acked to the interrupt
>>>> controller (EOI at the end of hardirq), not earlier.
>>>>
>>>> Linux keeps such interrupt masked until its threaded handler finishes,
>>>> to prevent the EOI from re-asserting an unacknowledged interrupt.
>>>> However, with KVM + vfio (or whatever is listening on the resamplefd)
>>>> we don't check that the interrupt is still masked in the guest at the
>>>> moment of EOI. Resamplefd is notified regardless, so vfio prematurely
>>>> unmasks the host physical IRQ, thus a new (unwanted) physical
>> interrupt
>>>> is generated in the host and queued for injection to the guest.
>>>>
>>>> The fact that the virtual IRQ is still masked doesn't prevent this new
>>>> physical IRQ from being propagated to the guest, because:
>>>>
>>>> 1. It is not guaranteed that the vIRQ will remain masked by the time
>>>>    when vfio signals the trigger eventfd.
>>>> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>>>>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
>>>>    new pending interrupt is injected by KVM to the guest anyway.
>>>>
>>>> There are observed at least 2 user-visible issues caused by those
>>>> extra erroneous pending interrupts for oneshot irq in the guest:
>>>>
>>>> 1. System suspend aborted due to a pending wakeup interrupt from
>>>>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
>>>> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>>>>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>>>>    every time the touchpad is touched.
>>>>
>>>> This patch fixes the issue on x86 by checking if the interrupt is
>>>> unmasked when we receive irq ack (EOI) and, in case if it's masked,
>>>> postponing resamplefd notify until the guest unmasks it.
>>>>
>>>> Important notes:
>>>>
>>>> 1. It doesn't fix the issue for other archs yet, due to some missing
>>>>    KVM functionality needed by this patch:
>>>>      - calling mask notifiers is implemented for x86 only
>>>>      - irqchip ->is_masked() is implemented for x86 only
>>>>
>>>> 2. It introduces an additional spinlock locking in the resample notify
>>>>    path, since we are no longer just traversing an RCU list of irqfds
>>>>    but also updating the resampler state. Hopefully this locking won't
>>>>    noticeably slow down anything for anyone.
>>>>
>>>
>>> Instead of using a spinlock waiting for the unmask event, is it possible
>> to call
>>> resampler notify directly when unmask event happens, instead of
>> calling it on
>>> EOI?
>>
>> In this patch, resampler notify is already called directly when unmask
>> happens: e.g. with IOAPIC, when the guest unmasks the interrupt by
>> writing to IOREDTBLx register, ioapic_write_indirect() calls
>> kvm_fire_mask_notifiers() which calls irqfd_resampler_mask() which
>> notifies the resampler. On EOI we postpone it just by setting
>> resampler->pending to true, not by waiting. The spinlock is needed
>> merely to synchronize reading & updating resampler->pending and
>> resampler->masked values between possibly concurrently running
>> instances
>> of irqfd_resampler_ack() and/or irqfd_resampler_mask().
>>
>> Thanks,
>> Dmytro
>>
> 
> I mean the organization of the code.  In current implementation,
> kvm_ioapic_update_eoi_one() calls kvm_notify_acked_irq(), in your patch, why not
> call kvm_notify_acked_irq() from ioapic_write_indirect() (roughly at the same
> place where kvm_fire_mask_notifiers is called), instead of calling it from
> kvm_ioapic_update_eoi_one, since what your intention here is to notify
> vfio of the end of interrupt at the event of ioapic unmask, instead of
> EOI?

Ah ok, got your point.

That was my initial approach in my PoC patch posted in [1]. But then I
dropped it, for 2 reasons:

1. Upon feedback from Sean I realized that kvm_notify_acked_irq() is
   also doing some other important things besides notifying vfio. In
   particular, in irqfd_resampler_ack() we also de-assert the vIRQ via
   kvm_set_irq(). In case of IOAPIC it means clearing its bit in IRR
   register. If we delay that until unmasking, it means that we change
   the way how KVM emulates the interrupt controller. That would seem
   inconsistent.

   Also kvm_notify_acked_irq() notifies the emulated PIT timer via
   kvm_pit_ack_irq(). I haven't analyzed how exactly that PIT stuff
   works, so I'm not sure if delaying that until unmask wouldn't cause
   any unwanted effects.

   So the idea is to postpone eventfd_signal() only, to fix interaction
   with vfio while keeping the rest of the KVM behavior intact. Because
   the KVM job is to emulate the interrupt controller (which it already
   does correctly), not the external device which is the job of vfio*.

2. kvm_notify_acked_irq() can't be called under ioapic->lock, so in [1]
   I was unlocking ioapic->lock in ioapic_write_indirect() with a naive
   assumption that it was as safe as doing it in
   kvm_ioapic_update_eoi_one(). That was probably racy, and I hadn't
   figured out how to rework it in a race-free way.

[1] https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/

[*] By "vfio" I always mean "vfio or any other resamplefd user".

Thanks,
Dmytro

> 
>>>
>>>> Regarding #2, there may be an alternative solution worth considering:
>>>> extend KVM irqfd (userspace) API to send mask and unmask
>> notifications
>>>> directly to vfio/whatever, in addition to resample notifications, to
>>>> let vfio check the irq state on its own. There is already locking on
>>>> vfio side (see e.g. vfio_platform_unmask()), so this way we would
>> avoid
>>>> introducing any additional locking. Also such mask/unmask
>> notifications
>>>> could be useful for other cases.
>>>>
>>>> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
>>>> d2fde2700083@semihalf.com/
>>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>>> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
>>>> ---
>>>>  include/linux/kvm_irqfd.h | 14 ++++++++++++
>>>>  virt/kvm/eventfd.c        | 45
>>>> +++++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 59 insertions(+)
>>>>
>>>> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
>>>> index dac047abdba7..01754a1abb9e 100644
>>>> --- a/include/linux/kvm_irqfd.h
>>>> +++ b/include/linux/kvm_irqfd.h
>>>> @@ -19,6 +19,16 @@
>>>>   * resamplefd.  All resamplers on the same gsi are de-asserted
>>>>   * together, so we don't need to track the state of each individual
>>>>   * user.  We can also therefore share the same irq source ID.
>>>> + *
>>>> + * A special case is when the interrupt is still masked at the moment
>>>> + * an irq ack is received. That likely means that the interrupt has
>>>> + * been acknowledged to the interrupt controller but not
>> acknowledged
>>>> + * to the device yet, e.g. it might be a Linux guest's threaded
>>>> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
>>>> + * resamplefd is postponed until the guest unmasks the interrupt,
>>>> + * which is detected through the irq mask notifier. This prevents
>>>> + * erroneous extra interrupts caused by premature re-assert of an
>>>> + * unacknowledged interrupt by the resamplefd listener.
>>>>   */
>>>>  struct kvm_kernel_irqfd_resampler {
>>>>  	struct kvm *kvm;
>>>> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>>>>  	 */
>>>>  	struct list_head list;
>>>>  	struct kvm_irq_ack_notifier notifier;
>>>> +	struct kvm_irq_mask_notifier mask_notifier;
>>>> +	bool masked;
>>>> +	bool pending;
>>>> +	spinlock_t lock;
>>>>  	/*
>>>>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>>>>  	 * resamplers among irqfds on the same gsi.
>>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>>> index 50ddb1d1a7f0..9ff47ac33790 100644
>>>> --- a/virt/kvm/eventfd.c
>>>> +++ b/virt/kvm/eventfd.c
>>>> @@ -75,6 +75,44 @@ irqfd_resampler_ack(struct
>> kvm_irq_ack_notifier
>>>> *kian)
>>>>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>>>  		    resampler->notifier.gsi, 0, false);
>>>>
>>>> +	spin_lock(&resampler->lock);
>>>> +	if (resampler->masked) {
>>>> +		resampler->pending = true;
>>>> +		spin_unlock(&resampler->lock);
>>>> +		return;
>>>> +	}
>>>> +	spin_unlock(&resampler->lock);
>>>> +
>>>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>>>> +
>>>> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
>>>> +	    srcu_read_lock_held(&kvm->irq_srcu))
>>>> +		eventfd_signal(irqfd->resamplefd, 1);
>>>> +
>>>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>>>> +}
>>>> +
>>>> +static void
>>>> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool
>>>> masked)
>>>> +{
>>>> +	struct kvm_kernel_irqfd_resampler *resampler;
>>>> +	struct kvm *kvm;
>>>> +	struct kvm_kernel_irqfd *irqfd;
>>>> +	int idx;
>>>> +
>>>> +	resampler = container_of(kimn,
>>>> +			struct kvm_kernel_irqfd_resampler, mask_notifier);
>>>> +	kvm = resampler->kvm;
>>>> +
>>>> +	spin_lock(&resampler->lock);
>>>> +	resampler->masked = masked;
>>>> +	if (masked || !resampler->pending) {
>>>> +		spin_unlock(&resampler->lock);
>>>> +		return;
>>>> +	}
>>>> +	resampler->pending = false;
>>>> +	spin_unlock(&resampler->lock);
>>>> +
>>>>  	idx = srcu_read_lock(&kvm->irq_srcu);
>>>>
>>>>  	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
>>>> @@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct
>>>> kvm_kernel_irqfd *irqfd)
>>>>  	if (list_empty(&resampler->list)) {
>>>>  		list_del(&resampler->link);
>>>>  		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
>>>> +		kvm_unregister_irq_mask_notifier(kvm, resampler-
>>>>> mask_notifier.irq,
>>>> +						 &resampler->mask_notifier);
>>>>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>>>  			    resampler->notifier.gsi, 0, false);
>>>>  		kfree(resampler);
>>>> @@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct
>>>> kvm_irqfd *args)
>>>>  			INIT_LIST_HEAD(&resampler->list);
>>>>  			resampler->notifier.gsi = irqfd->gsi;
>>>>  			resampler->notifier.irq_acked = irqfd_resampler_ack;
>>>> +			resampler->mask_notifier.func = irqfd_resampler_mask;
>>>> +			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler-
>>>>> masked);
>>>> +			spin_lock_init(&resampler->lock);
>>>>  			INIT_LIST_HEAD(&resampler->link);
>>>>
>>>>  			list_add(&resampler->link, &kvm->irqfds.resampler_list);
>>>>  			kvm_register_irq_ack_notifier(kvm,
>>>>  						      &resampler->notifier);
>>>> +			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
>>>> +						       &resampler->mask_notifier);
>>>>  			irqfd->resampler = resampler;
>>>>  		}
>>>>
>>>> --
>>>> 2.37.0.170.g444d1eabd0-goog
>>>
