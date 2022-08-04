Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB21A589DB5
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbiHDOkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 10:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240060AbiHDOju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 10:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4502A4D820
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 07:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659623973;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IoEVNA5Csx+V7GmeVHVVn6ViAtHF0BGVPyJivuLEoMQ=;
        b=K187uhMV4FsBCh6oOuAxjL7o/krF60+9EmUgqHmtq1I1uAsay9ct+2BZ7v6bkQ057XMZeQ
        G0XAnPgEHCPLKsvEg7N3xbXr9PczT17oV67KFclMNm5557Khv7i8pZa2vbU5Rd1TYyBrX9
        pHLE3qktGH3JKhPvxlySUdE0TeRlcf4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-tCzKBT5UOdG_sMrhqJRtuQ-1; Thu, 04 Aug 2022 10:39:32 -0400
X-MC-Unique: tCzKBT5UOdG_sMrhqJRtuQ-1
Received: by mail-qt1-f198.google.com with SMTP id k3-20020ac86043000000b0033cab47c483so4262088qtm.4
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 07:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=IoEVNA5Csx+V7GmeVHVVn6ViAtHF0BGVPyJivuLEoMQ=;
        b=QJc1pTJewDXP94cJJ0kpSRupugp7VyN9HAnAPKxnO8ETwY/y7YEHViOdLd9S4dI1jX
         dI9NSlzdHXguJCOwPSkp4S+sZRQ/Fa4ZgfqmLwnzSl9QmkmlesCGW35R4W1+nDxUyCdD
         r62yDp6jOulFEPNEySVo6RrYuswmlHGfMDbA1QA14wWn/3xIrENDgFvBc+z2SB2MORiQ
         PmSs+kHyG02w4O26rcD77HHd4w9kAJArRl0OjsdTJU3ve72ZhXtbSwfTZyu5ttLxDwg7
         M3mZg3KQqa1nqNSRTLXJgvA2rGU0h5gszuhEumjzDu+DVxmN+404tyBcTAvdRm0wVuwN
         ZSow==
X-Gm-Message-State: ACgBeo0SyvT8bbRlCeHEi1IswrYK6wPGkDeNTWM+qN1FoUftEZZildLY
        0jpzwV6DmDjJpD88RCS89ks12AmL9n33ngYQjMN/RggFL/tyJmp3nUNrgnGuXvu2Hsvpyhs43mk
        EGWASz1YVhEYq
X-Received: by 2002:a05:620a:11a7:b0:6b8:fbf8:4321 with SMTP id c7-20020a05620a11a700b006b8fbf84321mr1646766qkk.659.1659623971909;
        Thu, 04 Aug 2022 07:39:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5d19XAB9SSecPelcVNPfIHBJKvPBI5uZlug9nCUX3BMzyLIPH7Hs1IgXuNkCmW6C77YY/wbQ==
X-Received: by 2002:a05:620a:11a7:b0:6b8:fbf8:4321 with SMTP id c7-20020a05620a11a700b006b8fbf84321mr1646748qkk.659.1659623971657;
        Thu, 04 Aug 2022 07:39:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w4-20020a05620a424400b006b8d1914504sm812519qko.22.2022.08.04.07.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 07:39:30 -0700 (PDT)
Message-ID: <069a98a2-d4a1-8599-9deb-069115d5d22c@redhat.com>
Date:   Thu, 4 Aug 2022 16:39:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Content-Language: en-US
To:     "Liu, Rong L" <rong.l.liu@intel.com>,
        Dmytro Maluka <dmy@semihalf.com>,
        Micah Morton <mortonm@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <0a974041-0c61-e98b-d335-76f94618b5a7@redhat.com>
 <d6f3205c-6229-3b58-cdc2-a5d0f6cfb98f@semihalf.com>
 <MW3PR11MB455491C48BD1F630654CD491C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <MW3PR11MB455491C48BD1F630654CD491C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URI_DOTEDU autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

H Liu,

On 7/26/22 00:03, Liu, Rong L wrote:
> Hi Eric,
>
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Thursday, July 7, 2022 2:16 AM
>> To: eric.auger@redhat.com; Micah Morton <mortonm@chromium.org>
>> Cc: Alex Williamson <alex.williamson@redhat.com>;
>> kvm@vger.kernel.org; Christopherson,, Sean <seanjc@google.com>;
>> Paolo Bonzini <pbonzini@redhat.com>; Liu, Rong L
>> <rong.l.liu@intel.com>; Tomasz Nowicki <tn@semihalf.com>; Grzegorz
>> Jaszczyk <jaz@semihalf.com>; Dmitry Torokhov <dtor@google.com>
>> Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
>>
>> Hi Eric,
>>
>> On 7/7/22 10:25 AM, Eric Auger wrote:
>>>> Again, this doesn't seem to be true. Just as explained in my above
>>>> reply to Alex, the guest deactivates (EOI) the vIRQ already after the
>>>> completion of the vIRQ hardirq handler, not the vIRQ thread.
>>>>
>>>> So VFIO unmask handler gets called too early, before the interrupt
>>>> gets serviced and acked in the vIRQ thread.
>>> Fair enough, on vIRQ hardirq handler the physical IRQ gets unmasked.
>>> This event occurs on guest EOI, which triggers the resamplefd. But what
>>> is the state of the vIRQ? Isn't it stil masked until the vIRQ thread
>>> completes, preventing the physical IRQ from being propagated to the
>> guest?
>>
>> Even if vIRQ is still masked by the time when
>> vfio_automasked_irq_handler() signals the eventfd (which in itself is
>> not guaranteed, I guess), I believe KVM is buffering this event, so
>> after the vIRQ is unmasked, this new IRQ will be injected to the guest
>> anyway.
>>
>>>> It seems the obvious fix is to postpone sending irq ack notifications
>>>> in KVM from EOI to unmask (for oneshot interrupts only). Luckily, we
>>>> don't need to provide KVM with the info that the given interrupt is
>>>> oneshot. KVM can just find it out from the fact that the interrupt is
>>>> masked at the time of EOI.
>>> you mean the vIRQ right?
>> Right.
>>
>>> Before going further and we invest more time in that thread, please
>>> could you give us additional context info and confidence
>>> in/understanding of the stakes. This thread is from Jan 2021 and was
>>> discontinued for a while. vfio-platform currently only is enabled on
>> ARM
>>> and maintained for very few devices which properly implement reset
>>> callbacks and duly use an underlying IOMMU.
> Do you have more questions about this issue after following info and POC from
> Dmytro?
> I agree that we tried to extend the vfio infrastructure to x86 and a few more
> devices which may not "traditionally" supported by current vfio implementation. 
> However if we view vfio as a general infrastructure to be used for pass-thru
> devices (this is what we intend to do, implementation may vary),   Oneshot
> interrupt is not properly handled. 

sorry for the delay, I was out of office and it took me some time to
catch up.

Yes the problem and context is clearer now after the last emails. I now
understand the vEOI (inducing the VFIO pIRQ unmask) is done before the
device interrupt line is deasserted by the threaded handler and the vIRQ
unmask is done, causing spurious hits of the same oneshot IRQ.

Thanks

Eric
>
> From this discussion when oneshot interrupt is first upstreamed:
> https://lkml.iu.edu/hypermail/linux/kernel/0908.1/02114.html it says: "... we
> need to keep the interrupt line masked until the threaded handler has executed. 
> ... The interrupt line is unmasked after the thread handler function has been
> executed." using today's vfio architecture, (physical) interrupt line is
> unmasked by vfio after EOI introduced vmexit, instead after the threaded
> function has been executed (or in x86 world, when virtual interrupt is
> unmasked): this totally violates how oneshot irq should be used.   We have a few
> internal discussions and we couldn't find a solution which are both correct and
> efficient.  But at least we can target a "correct" solution first and that will
> help us resolve bugs we have on our products now.
>
>> Sure. We are not really using vfio-platform for the devices we are
>> concerned with, since those are not DMA capable devices, and some of
>> them are not really platform devices but I2C or SPI devices. Instead we
>> are using (hopefully temporarily) Micah's module for forwarding
>> arbitrary IRQs [1][2] which mostly reimplements the VFIO irq forwarding
>> mechanism.
>>
>> Also with a few simple hacks I managed to use vfio-platform for the same
>> thing (just as a PoC) and confirmed, unsurprisingly, that the problems
>> with oneshot interrupts are observed with vfio-platform as well.
>>
>> [1]
>> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/
>> refs/heads/chromeos-5.10-manatee/virt/lib/platirqforward.c
>>
>> [2]
>> https://lkml.kernel.org/kvm/CAJ-
>> EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail
>> .com/T/
>>
>> Thanks,
>> Dmytro

