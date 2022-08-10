Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4FD58E872
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 10:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiHJIMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 04:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiHJIMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 04:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F1F281B3D
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 01:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660119143;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVu58TYO0FPeW6T6G0V7mzScRg9HM7I3clRpI4N+hAQ=;
        b=gT5vOG9ITfisuccqcbBP4ZA2+Zp/XudzWhyAXHn1ri6k8G/L+Sk2dfJfQxZICtpv1RZLWb
        YEEzwKw1FmdLvvcCWcKLWnS1fpK5h9Tf3FvPseeqHD+beXZfNlfYFaaR0G5homKAaZ+qPw
        ikwjroObE7GX6nxWsyt+oVko+raVt74=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-ENSKPukeP2-za_MgdTAftA-1; Wed, 10 Aug 2022 04:12:22 -0400
X-MC-Unique: ENSKPukeP2-za_MgdTAftA-1
Received: by mail-wm1-f69.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so760775wmq.0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 01:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=BVu58TYO0FPeW6T6G0V7mzScRg9HM7I3clRpI4N+hAQ=;
        b=pZvAnD3rSx/TPUSH3BAeB0vSLO9A64+O8RBz3SqXnu3BFaCC3I1YZ8Buar6Y9ekYek
         ICPnUbzKJtmdCdGlv7oVOUQ6v1DiQy/to0lATYSGRdsSOb8AN1LxSIunzCrNuXzf4iWu
         ICx+YmUuDPweKYphSDx9ZgkIo0/H2y5XsOMEHI89Hg307kmpTBe9vEQTxq9UkOVBY+KG
         xPDsIVT8LR45RwToSj9y/E1kCALbFknlYko9qG6hh/6t8DCS2ZoP6yLCjd+sjE9kSaGn
         6siWudUORpcg9IxcCx6AXAYLhCb6As/1sBBEMAgD8tioOcm7Augkjz4BKVrRdTpqQFF8
         oOng==
X-Gm-Message-State: ACgBeo0QYXOYfYoROgAMZfL0KSSsgvdESUbsv5t87HHbkUKyl9Yd1b4j
        d6p7qKpmP/4h1hVJr4bnGNN1hSt4qh5cdLfKBnfGnev4W8kSHPYWWnX0x4Lu7v+Xzcq863x1GJ/
        eIJE6wXjeNqcQ
X-Received: by 2002:a05:600c:1f08:b0:3a3:1b00:c201 with SMTP id bd8-20020a05600c1f0800b003a31b00c201mr1529695wmb.171.1660119141172;
        Wed, 10 Aug 2022 01:12:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7oCp90BLj4T5HGfpvC4HP9o0gO2Cs98+Ewm/lwRDzAkI2WRcLJZnfEgmVfFNIcV13+azy3JQ==
X-Received: by 2002:a05:600c:1f08:b0:3a3:1b00:c201 with SMTP id bd8-20020a05600c1f0800b003a31b00c201mr1529662wmb.171.1660119140917;
        Wed, 10 Aug 2022 01:12:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id x11-20020adfdd8b000000b0020fff0ea0a3sm15273002wrl.116.2022.08.10.01.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 01:12:20 -0700 (PDT)
Message-ID: <8ff76b5e-ae28-70c8-2ec5-01662874fb15@redhat.com>
Date:   Wed, 10 Aug 2022 10:12:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, Dmytro Maluka <dmy@semihalf.com>
Cc:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <87o7wsbngz.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87o7wsbngz.wl-maz@kernel.org>
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

Hi Marc,

On 8/10/22 08:51, Marc Zyngier wrote:
> On Wed, 10 Aug 2022 00:30:29 +0100,
> Dmytro Maluka <dmy@semihalf.com> wrote:
>> On 8/9/22 10:01 PM, Dong, Eddie wrote:
>>>
>>>> -----Original Message-----
>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>> Sent: Tuesday, August 9, 2022 12:24 AM
>>>> To: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>> kvm@vger.kernel.org
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>;
>>>> Borislav Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>>>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>>>> kernel@vger.kernel.org; Eric Auger <eric.auger@redhat.com>; Alex
>>>> Williamson <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>>>> upstream@semihalf.com; Dmitry Torokhov <dtor@google.com>
>>>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>>>
>>>> On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>>>>> The existing KVM mechanism for forwarding of level-triggered
>>>>>> interrupts using resample eventfd doesn't work quite correctly in the
>>>>>> case of interrupts that are handled in a Linux guest as oneshot
>>>>>> interrupts (IRQF_ONESHOT). Such an interrupt is acked to the device
>>>>>> in its threaded irq handler, i.e. later than it is acked to the
>>>>>> interrupt controller (EOI at the end of hardirq), not earlier. The
>>>>>> existing KVM code doesn't take that into account, which results in
>>>>>> erroneous extra interrupts in the guest caused by premature re-assert of an
>>>> unacknowledged IRQ by the host.
>>>>> Interesting...  How it behaviors in native side?
>>>> In native it behaves correctly, since Linux masks such a oneshot interrupt at the
>>>> beginning of hardirq, so that the EOI at the end of hardirq doesn't result in its
>>>> immediate re-assert, and then unmasks it later, after its threaded irq handler
>>>> completes.
>>>>
>>>> In handle_fasteoi_irq():
>>>>
>>>> 	if (desc->istate & IRQS_ONESHOT)
>>>> 		mask_irq(desc);
>>>>
>>>> 	handle_irq_event(desc);
>>>>
>>>> 	cond_unmask_eoi_irq(desc, chip);
>>>>
>>>>
>>>> and later in unmask_threaded_irq():
>>>>
>>>> 	unmask_irq(desc);
>>>>
>>>> I also mentioned that in patch #3 description:
>>>> "Linux keeps such interrupt masked until its threaded handler finishes, to
>>>> prevent the EOI from re-asserting an unacknowledged interrupt.
>>> That makes sense. Can you include the full story in cover letter too?
>> Ok, I will.
>>
>>>
>>>> However, with KVM + vfio (or whatever is listening on the resamplefd) we don't
>>>> check that the interrupt is still masked in the guest at the moment of EOI.
>>>> Resamplefd is notified regardless, so vfio prematurely unmasks the host
>>>> physical IRQ, thus a new (unwanted) physical interrupt is generated in the host
>>>> and queued for injection to the guest."
> Sorry to barge in pretty late in the conversation (just been Cc'd on
> this), but why shouldn't the resamplefd be notified? If there has been
yeah sorry to get you involved here ;-)
> an EOI, a new level must be made visible to the guest interrupt
> controller, no matter what the state of the interrupt masking is.
>
> Whether this new level is actually *presented* to a vCPU is another
> matter entirely, and is arguably a problem for the interrupt
> controller emulation.

FWIU on guest EOI the physical line is still asserted so the pIRQ is
immediatly re-sampled by the interrupt controller (because the
resamplefd unmasked the physical IRQ) and recorded as a guest IRQ
(although it is masked at guest level). When the guest actually unmasks
the vIRQ we do not get a chance to re-evaluate the physical line level.

When running native, when EOI is sent, the physical line is still
asserted but the IRQ is masked. When unmasking, the line is de-asserted.

Thanks

Eric
>
> For example on arm64, we expect to be able to read the pending state
> of an interrupt from the guest irrespective of the masking state of
> that interrupt. Any change to the interrupt flow should preserve this.
>
> Thankfully, we don't have the polarity issue (there is no such thing
> in the GIC architecture) and we only deal with pending/not-pending.
>
> Thanks,
>
> 	M.
>

