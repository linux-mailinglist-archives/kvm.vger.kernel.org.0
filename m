Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5395A5814C7
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbiGZOHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 10:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiGZOHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 10:07:42 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F7225C45
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:07:38 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p11so17986467lfu.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RyhRhomMz4nT+4TMp0miaESIXdA47gDix20qJIWvqaI=;
        b=B6zfGE/7VH5CKF2Zsd9KhEeTMyAQTZoFytUzryvEA6rtPRCfOlZQQWSV93P89g76AQ
         sjFofZkaF4IoGjzluor7sYflndTc35vKqiBXIH3cbuzCKNyJcTGNVON1W9nRO51b0ab0
         lVLF34WoYg+hwn88v+YSzIWud8ppe17wOGELRELl5dkWZmVbldLtueeAe1M5ZCN0HpNz
         cvrdxq0Cr3RrDSWy5UxVEK8S1jgcyFQLdUddmm5QHnn8+37WJwJD938xeOfLSimP8/yX
         LJ3zQfcwxEBKwFkSUO5Ler0Xy7enDLKbkxFoV+6HVoLxaS8zLpcxMbnbScjdYj66cZ8q
         IfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RyhRhomMz4nT+4TMp0miaESIXdA47gDix20qJIWvqaI=;
        b=YsO1aBA5U6wQlANcVR2cGf0x+Y0GzYyU8MQeg9WAA2srhtFm+LJ7akUewOSi+m28Yj
         C4BcJmzUwlgCTdBtFlNGm9L0aCQVnQIkI2oUQFDnMYD0lev6MS0moZH771x2aID+5fTa
         jekeOsNSVui/+1RlFDkf/g8L1dzPpHHjtVnfgOu7dJjRp5R49RbsU7r3dViIiR1xll8P
         nXsfNJIHSmCRZEXp1MRMKuM3heYWmFhb10R+tFys1Hv5/ctXtxM7DpOvBp2ungiHkfKk
         591r8NcQzZ6oVfNwhLOU5OGPOWnw+XGXnQrNeSTkL57jYgkKEll1ylv7OebyPnANn/tH
         N0mw==
X-Gm-Message-State: AJIora8iINvKTzvA+g87t70YW7IKDqYlxFZDn+dbR1bpR2CTcgncWduP
        xLw7qeHQYI3hyRc6Z+3s/31rIQ==
X-Google-Smtp-Source: AGRyM1spnJVsqOi7TedoD+/0R0F3DLflNwZ8ksJ3LptV+oMNaCQcUtNcs1qfq8HVpqopQK9OoT+4+w==
X-Received: by 2002:a19:6b01:0:b0:48a:9ef7:a8a6 with SMTP id d1-20020a196b01000000b0048a9ef7a8a6mr1578939lfa.59.1658844455754;
        Tue, 26 Jul 2022 07:07:35 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id t26-20020ac24c1a000000b0048a7b5ee999sm2290000lfq.209.2022.07.26.07.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 07:07:35 -0700 (PDT)
Message-ID: <e5e5ca30-6ae6-250d-7c1e-77ebfabc4c1f@semihalf.com>
Date:   Tue, 26 Jul 2022 16:07:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Content-Language: en-US
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
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <MW3PR11MB4554E98CE51B883764BE4FB4C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Rong,

On 7/26/22 01:44, Liu, Rong L wrote:
> Hi Dmytro,
> 
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Friday, July 15, 2022 8:59 AM
>> To: Christopherson,, Sean <seanjc@google.com>; Paolo Bonzini
>> <pbonzini@redhat.com>; kvm@vger.kernel.org
>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>> <eric.auger@redhat.com>; Alex Williamson
>> <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry
>> Torokhov <dtor@google.com>; Dmytro Maluka <dmy@semihalf.com>
>> Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
>> interrupts
>>
>> The existing KVM mechanism for forwarding of level-triggered interrupts
>> using resample eventfd doesn't work quite correctly in the case of
>> interrupts that are handled in a Linux guest as oneshot interrupts
>> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
>> threaded irq handler, i.e. later than it is acked to the interrupt
>> controller (EOI at the end of hardirq), not earlier.
>>
>> Linux keeps such interrupt masked until its threaded handler finishes,
>> to prevent the EOI from re-asserting an unacknowledged interrupt.
>> However, with KVM + vfio (or whatever is listening on the resamplefd)
>> we don't check that the interrupt is still masked in the guest at the
>> moment of EOI. Resamplefd is notified regardless, so vfio prematurely
>> unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
>> is generated in the host and queued for injection to the guest.
>>
>> The fact that the virtual IRQ is still masked doesn't prevent this new
>> physical IRQ from being propagated to the guest, because:
>>
>> 1. It is not guaranteed that the vIRQ will remain masked by the time
>>    when vfio signals the trigger eventfd.
>> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
>>    new pending interrupt is injected by KVM to the guest anyway.
>>
>> There are observed at least 2 user-visible issues caused by those
>> extra erroneous pending interrupts for oneshot irq in the guest:
>>
>> 1. System suspend aborted due to a pending wakeup interrupt from
>>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
>> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>>    every time the touchpad is touched.
>>
>> This patch fixes the issue on x86 by checking if the interrupt is
>> unmasked when we receive irq ack (EOI) and, in case if it's masked,
>> postponing resamplefd notify until the guest unmasks it.
>>
>> Important notes:
>>
>> 1. It doesn't fix the issue for other archs yet, due to some missing
>>    KVM functionality needed by this patch:
>>      - calling mask notifiers is implemented for x86 only
>>      - irqchip ->is_masked() is implemented for x86 only
>>
>> 2. It introduces an additional spinlock locking in the resample notify
>>    path, since we are no longer just traversing an RCU list of irqfds
>>    but also updating the resampler state. Hopefully this locking won't
>>    noticeably slow down anything for anyone.
>>
> 
> Instead of using a spinlock waiting for the unmask event, is it possible to call
> resampler notify directly when unmask event happens, instead of calling it on
> EOI?

In this patch, resampler notify is already called directly when unmask
happens: e.g. with IOAPIC, when the guest unmasks the interrupt by
writing to IOREDTBLx register, ioapic_write_indirect() calls
kvm_fire_mask_notifiers() which calls irqfd_resampler_mask() which
notifies the resampler. On EOI we postpone it just by setting
resampler->pending to true, not by waiting. The spinlock is needed
merely to synchronize reading & updating resampler->pending and
resampler->masked values between possibly concurrently running instances
of irqfd_resampler_ack() and/or irqfd_resampler_mask().

Thanks,
Dmytro

> 
>> Regarding #2, there may be an alternative solution worth considering:
>> extend KVM irqfd (userspace) API to send mask and unmask notifications
>> directly to vfio/whatever, in addition to resample notifications, to
>> let vfio check the irq state on its own. There is already locking on
>> vfio side (see e.g. vfio_platform_unmask()), so this way we would avoid
>> introducing any additional locking. Also such mask/unmask notifications
>> could be useful for other cases.
>>
>> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
>> d2fde2700083@semihalf.com/
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
>> ---
>>  include/linux/kvm_irqfd.h | 14 ++++++++++++
>>  virt/kvm/eventfd.c        | 45
>> +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 59 insertions(+)
>>
>> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
>> index dac047abdba7..01754a1abb9e 100644
>> --- a/include/linux/kvm_irqfd.h
>> +++ b/include/linux/kvm_irqfd.h
>> @@ -19,6 +19,16 @@
>>   * resamplefd.  All resamplers on the same gsi are de-asserted
>>   * together, so we don't need to track the state of each individual
>>   * user.  We can also therefore share the same irq source ID.
>> + *
>> + * A special case is when the interrupt is still masked at the moment
>> + * an irq ack is received. That likely means that the interrupt has
>> + * been acknowledged to the interrupt controller but not acknowledged
>> + * to the device yet, e.g. it might be a Linux guest's threaded
>> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
>> + * resamplefd is postponed until the guest unmasks the interrupt,
>> + * which is detected through the irq mask notifier. This prevents
>> + * erroneous extra interrupts caused by premature re-assert of an
>> + * unacknowledged interrupt by the resamplefd listener.
>>   */
>>  struct kvm_kernel_irqfd_resampler {
>>  	struct kvm *kvm;
>> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>>  	 */
>>  	struct list_head list;
>>  	struct kvm_irq_ack_notifier notifier;
>> +	struct kvm_irq_mask_notifier mask_notifier;
>> +	bool masked;
>> +	bool pending;
>> +	spinlock_t lock;
>>  	/*
>>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>>  	 * resamplers among irqfds on the same gsi.
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 50ddb1d1a7f0..9ff47ac33790 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -75,6 +75,44 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier
>> *kian)
>>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>  		    resampler->notifier.gsi, 0, false);
>>
>> +	spin_lock(&resampler->lock);
>> +	if (resampler->masked) {
>> +		resampler->pending = true;
>> +		spin_unlock(&resampler->lock);
>> +		return;
>> +	}
>> +	spin_unlock(&resampler->lock);
>> +
>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>> +
>> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
>> +	    srcu_read_lock_held(&kvm->irq_srcu))
>> +		eventfd_signal(irqfd->resamplefd, 1);
>> +
>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>> +}
>> +
>> +static void
>> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool
>> masked)
>> +{
>> +	struct kvm_kernel_irqfd_resampler *resampler;
>> +	struct kvm *kvm;
>> +	struct kvm_kernel_irqfd *irqfd;
>> +	int idx;
>> +
>> +	resampler = container_of(kimn,
>> +			struct kvm_kernel_irqfd_resampler, mask_notifier);
>> +	kvm = resampler->kvm;
>> +
>> +	spin_lock(&resampler->lock);
>> +	resampler->masked = masked;
>> +	if (masked || !resampler->pending) {
>> +		spin_unlock(&resampler->lock);
>> +		return;
>> +	}
>> +	resampler->pending = false;
>> +	spin_unlock(&resampler->lock);
>> +
>>  	idx = srcu_read_lock(&kvm->irq_srcu);
>>
>>  	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
>> @@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct
>> kvm_kernel_irqfd *irqfd)
>>  	if (list_empty(&resampler->list)) {
>>  		list_del(&resampler->link);
>>  		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
>> +		kvm_unregister_irq_mask_notifier(kvm, resampler-
>>> mask_notifier.irq,
>> +						 &resampler->mask_notifier);
>>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>  			    resampler->notifier.gsi, 0, false);
>>  		kfree(resampler);
>> @@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct
>> kvm_irqfd *args)
>>  			INIT_LIST_HEAD(&resampler->list);
>>  			resampler->notifier.gsi = irqfd->gsi;
>>  			resampler->notifier.irq_acked = irqfd_resampler_ack;
>> +			resampler->mask_notifier.func = irqfd_resampler_mask;
>> +			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler-
>>> masked);
>> +			spin_lock_init(&resampler->lock);
>>  			INIT_LIST_HEAD(&resampler->link);
>>
>>  			list_add(&resampler->link, &kvm->irqfds.resampler_list);
>>  			kvm_register_irq_ack_notifier(kvm,
>>  						      &resampler->notifier);
>> +			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
>> +						       &resampler->mask_notifier);
>>  			irqfd->resampler = resampler;
>>  		}
>>
>> --
>> 2.37.0.170.g444d1eabd0-goog
> 
