Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C765D591B02
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiHMOdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 10:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbiHMOd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 10:33:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6E32ED5A
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 07:33:27 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d14so4769228lfl.13
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 07:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=2XU0dq+Px6DSYX8CRrbEtKFU/LJXZ71iIvju+DoTLoU=;
        b=W4+mnAYMuOPQSgH8TGiCPtDgiKcGsOEPPy3ZUHvNb8dqtFcJW8W0PskyY6RGoHi0/V
         NiydllcGLgDbn2QJUc55+ipFX5hrMyrX+AY/0ZbtO5RWUaeUKofgx0JuctUUuEW7r/ab
         gejzxkIMmcfe6ZUtJpwrsBogiz/U8UiYIm0g37S/2yicvSMKi1JIsnPhnEAgEeYmajje
         LdrjGAYInnxtEde714BPrNe6fVodqrpwoiK/pvcZuQD1Wkymd/IKo7JP3bpB0sOgRwzW
         FcK3MZUxt4t1x46YWyNcXzwMlUq/16PUsLJvICZcI5/qjW3Mf+u6zbrxDJINZl4PNSbC
         FKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=2XU0dq+Px6DSYX8CRrbEtKFU/LJXZ71iIvju+DoTLoU=;
        b=g4Cav6DSrzFDVWDVcM2CyLLcaXqJrI4zD463njpRH2CAyUYrwFYHSP1l8O+I1etx69
         fhvZXDD4iZTpf76oO2axUVO4MWRQgWxbX3tp/brU9jPhOsemsWXfwweMwE6+S1peouhG
         IwmScTMfBtoNkovw9I0O0A/EchEej4AZyR24vq1nnlsnndDhSNniV5nkgv0SRFVygANJ
         X2lhxrDDlwR/jqgIFnC3eT0Jhqtv2pP9GGXOqwLKV7ycsgUr58y/fR3fs34li/Qp9nzv
         CQScBylvCZfJItpcBfv5LVSSDXpcG70cBEHoenAM1Ekmp9m3XjHxfEVVrskSdY5thYa3
         GNQg==
X-Gm-Message-State: ACgBeo2h3mxRAquB1z6khefizKSQ2F9+XSbzj8fGY/0g22013Fo5pJNa
        5POzHgbHpU2+9nYMwPi6eZjdmg==
X-Google-Smtp-Source: AA6agR50lzxmIhVnTHsUxl0WAxKa8kOLwG2KVvWp6/lVjfgj1EICyl0crMSIoGANVM/1fyj3/QjD8A==
X-Received: by 2002:a05:6512:909:b0:48b:954c:8e23 with SMTP id e9-20020a056512090900b0048b954c8e23mr3043027lft.670.1660401205568;
        Sat, 13 Aug 2022 07:33:25 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id o9-20020ac24bc9000000b0048af749c060sm555910lfq.157.2022.08.13.07.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 07:33:25 -0700 (PDT)
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
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-4-dmy@semihalf.com>
 <MW3PR11MB4554E98CE51B883764BE4FB4C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
 <e5e5ca30-6ae6-250d-7c1e-77ebfabc4c1f@semihalf.com>
 <MW3PR11MB4554A01E691ED2070D98EE2CC7999@MW3PR11MB4554.namprd11.prod.outlook.com>
 <923b0e08-6e19-69c1-a9a2-4127c619e707@semihalf.com>
 <MW3PR11MB4554486DB4289342D0D568C8C7629@MW3PR11MB4554.namprd11.prod.outlook.com>
 <1d1555fd-eea6-95a6-e396-a6907322b778@semihalf.com>
 <MW3PR11MB45543702BEB58F160A81E5B8C7649@MW3PR11MB4554.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <72e5fd62-8e24-2022-0df3-348c305997be@semihalf.com>
Date:   Sat, 13 Aug 2022 16:33:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB45543702BEB58F160A81E5B8C7649@MW3PR11MB4554.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Rong,

On 8/11/22 6:12 PM, Liu, Rong L wrote:
> Hi Dmytro,
> 
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Tuesday, August 9, 2022 5:57 PM
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
>> On 8/10/22 12:02 AM, Liu, Rong L wrote:
>>> Hi Dmytro,
>>>
>>>> -----Original Message-----
>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>> Sent: Saturday, July 30, 2022 7:35 AM
>>>> To: Liu, Rong L <rong.l.liu@intel.com>; Christopherson,, Sean
>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>> kvm@vger.kernel.org
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>>>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
>>>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>>>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>>>> <eric.auger@redhat.com>; Alex Williamson
>>>> <alex.williamson@redhat.com>; Zhenyu Wang
>>>> <zhenyuw@linux.intel.com>; Tomasz Nowicki <tn@semihalf.com>;
>>>> Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry Torokhov
>>>> <dtor@google.com>
>>>> Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for
>>>> oneshot interrupts
>>>>
>>>> On 7/29/22 10:48 PM, Liu, Rong L wrote:
>>>>> Hi Dmytro,
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>>>> Sent: Tuesday, July 26, 2022 7:08 AM
>>>>>> To: Liu, Rong L <rong.l.liu@intel.com>; Christopherson,, Sean
>>>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>>>> kvm@vger.kernel.org
>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>>>>>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave
>> Hansen
>>>>>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>>>>>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>>>>>> <eric.auger@redhat.com>; Alex Williamson
>>>>>> <alex.williamson@redhat.com>; Zhenyu Wang
>>>>>> <zhenyuw@linux.intel.com>; Tomasz Nowicki <tn@semihalf.com>;
>>>>>> Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry Torokhov
>>>>>> <dtor@google.com>
>>>>>> Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify
>> for
>>>>>> oneshot interrupts
>>>>>>
>>>>>> Hi Rong,
>>>>>>
>>>>>> On 7/26/22 01:44, Liu, Rong L wrote:
>>>>>>> Hi Dmytro,
>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>>>>>> Sent: Friday, July 15, 2022 8:59 AM
>>>>>>>> To: Christopherson,, Sean <seanjc@google.com>; Paolo Bonzini
>>>>>>>> <pbonzini@redhat.com>; kvm@vger.kernel.org
>>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>>>>>>>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave
>>>> Hansen
>>>>>>>> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
>>>>>>>> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
>>>>>>>> <eric.auger@redhat.com>; Alex Williamson
>>>>>>>> <alex.williamson@redhat.com>; Liu, Rong L
>> <rong.l.liu@intel.com>;
>>>>>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>>>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>>>> Dmitry
>>>>>>>> Torokhov <dtor@google.com>; Dmytro Maluka
>>>> <dmy@semihalf.com>
>>>>>>>> Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for
>>>>>> oneshot
>>>>>>>> interrupts
>>>>>>>>
>>>>>>>> The existing KVM mechanism for forwarding of level-triggered
>>>>>> interrupts
>>>>>>>> using resample eventfd doesn't work quite correctly in the case
>> of
>>>>>>>> interrupts that are handled in a Linux guest as oneshot interrupts
>>>>>>>> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
>>>>>>>> threaded irq handler, i.e. later than it is acked to the interrupt
>>>>>>>> controller (EOI at the end of hardirq), not earlier.
>>>>>>>>
>>>>>>>> Linux keeps such interrupt masked until its threaded handler
>>>> finishes,
>>>>>>>> to prevent the EOI from re-asserting an unacknowledged
>> interrupt.
>>>>>>>> However, with KVM + vfio (or whatever is listening on the
>>>> resamplefd)
>>>>>>>> we don't check that the interrupt is still masked in the guest at
>> the
>>>>>>>> moment of EOI. Resamplefd is notified regardless, so vfio
>>>> prematurely
>>>>>>>> unmasks the host physical IRQ, thus a new (unwanted) physical
>>>>>> interrupt
>>>>>>>> is generated in the host and queued for injection to the guest.
>>>>>>>>
>>>>>>>> The fact that the virtual IRQ is still masked doesn't prevent this
>> new
>>>>>>>> physical IRQ from being propagated to the guest, because:
>>>>>>>>
>>>>>>>> 1. It is not guaranteed that the vIRQ will remain masked by the
>> time
>>>>>>>>    when vfio signals the trigger eventfd.
>>>>>>>> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>>>>>>>>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked,
>> this
>>>>>>>>    new pending interrupt is injected by KVM to the guest anyway.
>>>>>>>>
>>>>>>>> There are observed at least 2 user-visible issues caused by those
>>>>>>>> extra erroneous pending interrupts for oneshot irq in the guest:
>>>>>>>>
>>>>>>>> 1. System suspend aborted due to a pending wakeup interrupt
>> from
>>>>>>>>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
>>>>>>>> 2. Annoying "invalid report id data" errors from ELAN0000
>>>> touchpad
>>>>>>>>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest
>> dmesg
>>>>>>>>    every time the touchpad is touched.
>>>>>>>>
>>>>>>>> This patch fixes the issue on x86 by checking if the interrupt is
>>>>>>>> unmasked when we receive irq ack (EOI) and, in case if it's
>> masked,
>>>>>>>> postponing resamplefd notify until the guest unmasks it.
>>>>>>>>
>>>>>>>> Important notes:
>>>>>>>>
>>>>>>>> 1. It doesn't fix the issue for other archs yet, due to some missing
>>>>>>>>    KVM functionality needed by this patch:
>>>>>>>>      - calling mask notifiers is implemented for x86 only
>>>>>>>>      - irqchip ->is_masked() is implemented for x86 only
>>>>>>>>
>>>>>>>> 2. It introduces an additional spinlock locking in the resample
>> notify
>>>>>>>>    path, since we are no longer just traversing an RCU list of irqfds
>>>>>>>>    but also updating the resampler state. Hopefully this locking
>> won't
>>>>>>>>    noticeably slow down anything for anyone.
>>>>>>>>
>>>>>>>
>>>>>>> Instead of using a spinlock waiting for the unmask event, is it
>>>> possible
>>>>>> to call
>>>>>>> resampler notify directly when unmask event happens, instead of
>>>>>> calling it on
>>>>>>> EOI?
>>>>>>
>>>>>> In this patch, resampler notify is already called directly when
>> unmask
>>>>>> happens: e.g. with IOAPIC, when the guest unmasks the interrupt by
>>>>>> writing to IOREDTBLx register, ioapic_write_indirect() calls
>>>>>> kvm_fire_mask_notifiers() which calls irqfd_resampler_mask()
>> which
>>>>>> notifies the resampler. On EOI we postpone it just by setting
>>>>>> resampler->pending to true, not by waiting. The spinlock is needed
>>>>>> merely to synchronize reading & updating resampler->pending and
>>>>>> resampler->masked values between possibly concurrently running
>>>>>> instances
>>>>>> of irqfd_resampler_ack() and/or irqfd_resampler_mask().
>>>>>>
>>>>>> Thanks,
>>>>>> Dmytro
>>>>>>
>>>>>
>>>>> I mean the organization of the code.  In current implementation,
>>>>> kvm_ioapic_update_eoi_one() calls kvm_notify_acked_irq(), in your
>>>> patch, why not
>>>>> call kvm_notify_acked_irq() from ioapic_write_indirect() (roughly at
>>>> the same
>>>>> place where kvm_fire_mask_notifiers is called), instead of calling it
>>>> from
>>>>> kvm_ioapic_update_eoi_one, since what your intention here is to
>>>> notify
>>>>> vfio of the end of interrupt at the event of ioapic unmask, instead of
>>>>> EOI?
>>>>
>>>> Ah ok, got your point.
>>>>
>>>> That was my initial approach in my PoC patch posted in [1]. But then I
>>>> dropped it, for 2 reasons:
>>>>
>>>> 1. Upon feedback from Sean I realized that kvm_notify_acked_irq() is
>>>>    also doing some other important things besides notifying vfio. In
>>>>    particular, in irqfd_resampler_ack() we also de-assert the vIRQ via
>>>>    kvm_set_irq(). In case of IOAPIC it means clearing its bit in IRR
>>>>    register. If we delay that until unmasking, it means that we change
>>>>    the way how KVM emulates the interrupt controller. That would
>> seem
>>>>    inconsistent.
>>>>
>>>
>>> Thanks for clarification.  I totally agree that it is important to keep the
>> way
>>> how KVM emulates the interrupt controller.
>>>
>>>>    Also kvm_notify_acked_irq() notifies the emulated PIT timer via
>>>>    kvm_pit_ack_irq(). I haven't analyzed how exactly that PIT stuff
>>>>    works, so I'm not sure if delaying that until unmask wouldn't cause
>>>>    any unwanted effects.
>>>>
>>>>    So the idea is to postpone eventfd_signal() only, to fix interaction
>>>>    with vfio while keeping the rest of the KVM behavior intact. Because
>>>>    the KVM job is to emulate the interrupt controller (which it already
>>>>    does correctly), not the external device which is the job of vfio*.
>>>>
>>>
>>> I made a mistake in my last post.  I mean just to delay the notification
>> of
>>> vfio, but keep the rest of the code as intact as possible.
>>
>> Hmm, thanks, until now I wasn't thinking about another possibility: call
>> delayed eventfd_signal() directly from ioapic_write_indirect().
>>
>> However, now thinking about that, I don't really see advantages. We
>> wouldn't
>> need to use mask notifiers then, but we would still need the same logic
>> and
>> synchronization in irqfd_resampler_ack() for checking whether we
>> should delay
>> the notification. Moreover, I'm not sure how would I then address the
>> resampler->masked initialization race issue, which I addressed in v2 by
>> implementing kvm_register_and_fire_irq_mask_notifier() in [1].
>>
>> [1] https://lore.kernel.org/lkml/20220805193919.1470653-3-
>> dmy@semihalf.com/
>>
> 
> I haven't finished reading your v2 patch, especially regarding the racing
> conditions.  However, I think there are some advantages to let irqchip call the
> eventfd_signal, one thing is clearer code organization.  The other is that it
> seems it is necessary to differentiate the handling among different irqchips,
> the goal here is to keep logic around other types of irqchips intact to reduce
> code turmoil and fix ioapic?  It looks like every irqchip has its own "set_irq"
> function (You probably already know this: kvm_set_routing_entry), I think it is
> logical to let every type irqchip (it is maybe necessary for other types of irq
> too) to decide when to notify vfio.

In a way that is already the case with this patchset. Each irqchip
decides when to call kvm_fire_mask_notifiers(), so it (indirectly)
decides when to send the delayed vfio notification. Actually non-x86
irqchips currently never call kvm_fire_mask_notifiers(), so their
behavior is kept intact.

Regarding code organization, the tricky thing is the synchronization
needed for detecting whether to postpone resamplefd at vEOI or not.
Anyway, v3 will probably implement quite a different approach (to
address the issue pointed out by Marc: we should maintain correct vIRQ
pending state presented to the guest), without postponing resamplefd, so
maybe the implementation will be more in line with your suggestions.

> 
>>>
>>>> 2. kvm_notify_acked_irq() can't be called under ioapic->lock, so in [1]
>>>>    I was unlocking ioapic->lock in ioapic_write_indirect() with a naive
>>>>    assumption that it was as safe as doing it in
>>>>    kvm_ioapic_update_eoi_one(). That was probably racy, and I hadn't
>>>>    figured out how to rework it in a race-free way.
>>>>
>>>> [1] https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
>>>> d2fde2700083@semihalf.com/
>>>>
>>>> [*] By "vfio" I always mean "vfio or any other resamplefd user".
>>>>
>>>> Thanks,
>>>> Dmytro
>>>>
>>>>>
>>>>>>>
>>>>>>>> Regarding #2, there may be an alternative solution worth
>>>> considering:
>>>>>>>> extend KVM irqfd (userspace) API to send mask and unmask
>>>>>> notifications
>>>>>>>> directly to vfio/whatever, in addition to resample notifications,
>> to
>>>>>>>> let vfio check the irq state on its own. There is already locking on
>>>>>>>> vfio side (see e.g. vfio_platform_unmask()), so this way we would
>>>>>> avoid
>>>>>>>> introducing any additional locking. Also such mask/unmask
>>>>>> notifications
>>>>>>>> could be useful for other cases.
>>>>>>>>
>>>>>>>> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
>>>>>>>> d2fde2700083@semihalf.com/
>>>>>>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>>>>>>> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
>>>>>>>> ---
>>>>>>>>  include/linux/kvm_irqfd.h | 14 ++++++++++++
>>>>>>>>  virt/kvm/eventfd.c        | 45
>>>>>>>> +++++++++++++++++++++++++++++++++++++++
>>>>>>>>  2 files changed, 59 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
>>>>>>>> index dac047abdba7..01754a1abb9e 100644
>>>>>>>> --- a/include/linux/kvm_irqfd.h
>>>>>>>> +++ b/include/linux/kvm_irqfd.h
>>>>>>>> @@ -19,6 +19,16 @@
>>>>>>>>   * resamplefd.  All resamplers on the same gsi are de-asserted
>>>>>>>>   * together, so we don't need to track the state of each individual
>>>>>>>>   * user.  We can also therefore share the same irq source ID.
>>>>>>>> + *
>>>>>>>> + * A special case is when the interrupt is still masked at the
>>>> moment
>>>>>>>> + * an irq ack is received. That likely means that the interrupt has
>>>>>>>> + * been acknowledged to the interrupt controller but not
>>>>>> acknowledged
>>>>>>>> + * to the device yet, e.g. it might be a Linux guest's threaded
>>>>>>>> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying
>>>> through
>>>>>>>> + * resamplefd is postponed until the guest unmasks the
>> interrupt,
>>>>>>>> + * which is detected through the irq mask notifier. This prevents
>>>>>>>> + * erroneous extra interrupts caused by premature re-assert of
>> an
>>>>>>>> + * unacknowledged interrupt by the resamplefd listener.
>>>>>>>>   */
>>>>>>>>  struct kvm_kernel_irqfd_resampler {
>>>>>>>>  	struct kvm *kvm;
>>>>>>>> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>>>>>>>>  	 */
>>>>>>>>  	struct list_head list;
>>>>>>>>  	struct kvm_irq_ack_notifier notifier;
>>>>>>>> +	struct kvm_irq_mask_notifier mask_notifier;
>>>>>>>> +	bool masked;
>>>>>>>> +	bool pending;
>>>>>>>> +	spinlock_t lock;
>>>>>>>>  	/*
>>>>>>>>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>>>>>>>>  	 * resamplers among irqfds on the same gsi.
>>>>>>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>>>>>>> index 50ddb1d1a7f0..9ff47ac33790 100644
>>>>>>>> --- a/virt/kvm/eventfd.c
>>>>>>>> +++ b/virt/kvm/eventfd.c
>>>>>>>> @@ -75,6 +75,44 @@ irqfd_resampler_ack(struct
>>>>>> kvm_irq_ack_notifier
>>>>>>>> *kian)
>>>>>>>>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>>>>>>>  		    resampler->notifier.gsi, 0, false);
>>>>>>>>
>>>>>>>> +	spin_lock(&resampler->lock);
>>>>>>>> +	if (resampler->masked) {
>>>>>>>> +		resampler->pending = true;
>>>>>>>> +		spin_unlock(&resampler->lock);
>>>>>>>> +		return;
>>>>>>>> +	}
>>>>>>>> +	spin_unlock(&resampler->lock);
>>>>>>>> +
>>>>>>>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>>>>>>>> +
>>>>>>>> +	list_for_each_entry_srcu(irqfd, &resampler->list,
>>>> resampler_link,
>>>>>>>> +	    srcu_read_lock_held(&kvm->irq_srcu))
>>>>>>>> +		eventfd_signal(irqfd->resamplefd, 1);
>>>>>>>> +
>>>>>>>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void
>>>>>>>> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn,
>> bool
>>>>>>>> masked)
>>>>>>>> +{
>>>>>>>> +	struct kvm_kernel_irqfd_resampler *resampler;
>>>>>>>> +	struct kvm *kvm;
>>>>>>>> +	struct kvm_kernel_irqfd *irqfd;
>>>>>>>> +	int idx;
>>>>>>>> +
>>>>>>>> +	resampler = container_of(kimn,
>>>>>>>> +			struct kvm_kernel_irqfd_resampler,
>>>> mask_notifier);
>>>>>>>> +	kvm = resampler->kvm;
>>>>>>>> +
>>>>>>>> +	spin_lock(&resampler->lock);
>>>>>>>> +	resampler->masked = masked;
>>>>>>>> +	if (masked || !resampler->pending) {
>>>>>>>> +		spin_unlock(&resampler->lock);
>>>>>>>> +		return;
>>>>>>>> +	}
>>>>>>>> +	resampler->pending = false;
>>>>>>>> +	spin_unlock(&resampler->lock);
>>>>>>>> +
>>>>>>>>  	idx = srcu_read_lock(&kvm->irq_srcu);
>>>>>>>>
>>>>>>>>  	list_for_each_entry_srcu(irqfd, &resampler->list,
>>>> resampler_link,
>>>>>>>> @@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct
>>>>>>>> kvm_kernel_irqfd *irqfd)
>>>>>>>>  	if (list_empty(&resampler->list)) {
>>>>>>>>  		list_del(&resampler->link);
>>>>>>>>  		kvm_unregister_irq_ack_notifier(kvm, &resampler-
>>>>> notifier);
>>>>>>>> +		kvm_unregister_irq_mask_notifier(kvm, resampler-
>>>>>>>>> mask_notifier.irq,
>>>>>>>> +						 &resampler->mask_notifier);
>>>>>>>>  		kvm_set_irq(kvm,
>>>> KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>>>>>>>>  			    resampler->notifier.gsi, 0, false);
>>>>>>>>  		kfree(resampler);
>>>>>>>> @@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm,
>>>> struct
>>>>>>>> kvm_irqfd *args)
>>>>>>>>  			INIT_LIST_HEAD(&resampler->list);
>>>>>>>>  			resampler->notifier.gsi = irqfd->gsi;
>>>>>>>>  			resampler->notifier.irq_acked =
>>>> irqfd_resampler_ack;
>>>>>>>> +			resampler->mask_notifier.func =
>>>> irqfd_resampler_mask;
>>>>>>>> +			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler-
>>>>>>>>> masked);
>>>>>>>> +			spin_lock_init(&resampler->lock);
>>>>>>>>  			INIT_LIST_HEAD(&resampler->link);
>>>>>>>>
>>>>>>>>  			list_add(&resampler->link, &kvm-
>>>>> irqfds.resampler_list);
>>>>>>>>  			kvm_register_irq_ack_notifier(kvm,
>>>>>>>>  						      &resampler->notifier);
>>>>>>>> +			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
>>>>>>>> +						       &resampler->mask_notifier);
>>>>>>>>  			irqfd->resampler = resampler;
>>>>>>>>  		}
>>>>>>>>
>>>>>>>> --
>>>>>>>> 2.37.0.170.g444d1eabd0-goog
>>>>>>>
