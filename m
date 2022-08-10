Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA75158F1A1
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiHJRe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiHJRe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:34:27 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF24A82776
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:34:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id j3so9637729ljo.0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=SspRo8j3eYOak2Or93Ie6jAhlC0rna8TGwHIKsAIEiQ=;
        b=lOhgyb0o5yEA35AJoSIfAzLAbl2zzGS5GqFCmePaZtF00tBUKojZx+pF8rDF6OHEWM
         PQ7gg7OQs3rtxsU3sytaJiOc5vFd22H9A4BlRzffRgAtrDwuyP3A/jwTtrIWiBQlTi+f
         28IY2k6x2rmh32fTZzN6CEMqMp2YzhApGRopKs+Y0FbYuZIWU1eRTsdKfMSs7eCWJ4Af
         o3YPZop0rvEG3FHRMP11YxfVsirNEXJT/rSPMPJnQZiCYYtzu4dATqRCJhxzM3qhhTVa
         68qkF0xz4owQtcJH1YpimeS/PgQvjR8foTRt1SZ5PDUwDS/8wDwZ8kYA9EqYd2lZO4nX
         oA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=SspRo8j3eYOak2Or93Ie6jAhlC0rna8TGwHIKsAIEiQ=;
        b=46xyg5vU2fCjIY0JByR+aQrAYohIbnuB9nxAmEeuqBNGsxZLJdGxkbM+xRNFaGNWaO
         GAtN089ZReenk6+hk6jGfWny430T/pEwRbhSTtpJeE8wYMjjzLNwnZ1W+oNA1TOi+p5v
         4C6n4fzXfSeTVe8rhjYBbVPJJ2x6mpSb4u379V6GkiNBQnaeyZb3M4SNBcU+LhpKhmaR
         n5xK6fglJ/TKdEKupeF36V7dRWenYVO8DD0/hCjPxti6lTSWFmWndK356pMOqyMWAtzz
         2S/SKyRTR7Esg7/xOXAUlCjOGAMOe8OXohsXUE2WhEJl1i5GWPhLNzM+O6i19qzhKhms
         uTbA==
X-Gm-Message-State: ACgBeo0rC5kKsIpcP7ZkPb2f/d+TZGb/pDlSu7nzHpfHzgKl5yX/i2nI
        SknNYs4F1L1dlX0D+hbosS16hNmc7QYgt5L6
X-Google-Smtp-Source: AA6agR5sPZFBxjtQl34ZjT0NG3HJ01eW3HJOAqyqT/fchHh6VXDzjeNV3FITMPbJIr5RJlsmF2A3nQ==
X-Received: by 2002:a05:651c:446:b0:25e:5629:213b with SMTP id g6-20020a05651c044600b0025e5629213bmr8665148ljg.53.1660152862760;
        Wed, 10 Aug 2022 10:34:22 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id h2-20020ac25962000000b0048b0aa2f87csm407376lfp.181.2022.08.10.10.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 10:34:22 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
To:     "Dong, Eddie" <eddie.dong@intel.com>,
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
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <BL0PR11MB304290D4AACC3C1E2661C9668A659@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <f4b162a5-1da6-478f-fcab-d79cece32dde@semihalf.com>
Date:   Wed, 10 Aug 2022 19:34:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <BL0PR11MB304290D4AACC3C1E2661C9668A659@BL0PR11MB3042.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 7:17 PM, Dong, Eddie wrote:
>>>
>>>
>>>> However, with KVM + vfio (or whatever is listening on the resamplefd)
>>>> we don't check that the interrupt is still masked in the guest at the moment
>> of EOI.
>>>> Resamplefd is notified regardless, so vfio prematurely unmasks the
>>>> host physical IRQ, thus a new (unwanted) physical interrupt is
>>>> generated in the host and queued for injection to the guest."
>>>>
>>>
>>> Emulation of level triggered IRQ is a pain point ☹ I read we need to
>>> emulate the "level" of the IRQ pin (connecting from device to IRQchip, i.e.
>> ioapic here).
>>> Technically, the guest can change the polarity of vIOAPIC, which will
>>> lead to a new  virtual IRQ even w/o host side interrupt.
>>
>> Thanks, interesting point. Do you mean that this behavior (a new vIRQ as a
>> result of polarity change) may already happen with the existing KVM code?
>>
>> It doesn't seem so to me. AFAICT, KVM completely ignores the vIOAPIC polarity
>> bit, in particular it doesn't handle change of the polarity by the guest (i.e.
>> doesn't update the virtual IRR register, and so on), so it shouldn't result in a
>> new interrupt.
> 
> Correct, KVM doesn't handle polarity now. Probably because unlikely the commercial OSes 
> will change polarity.
> 
>>
>> Since commit 100943c54e09 ("kvm: x86: ignore ioapic polarity") there seems to
>> be an assumption that KVM interpretes the IRQ level value as active (asserted)
>> vs inactive (deasserted) rather than high vs low, i.e.
> 
> Asserted/deasserted vs. high/low is same to me, though asserted/deasserted hints more for event rather than state.
> 
>> the polarity doesn't matter to KVM.
>>
>> So, since both sides (KVM emulating the IOAPIC, and vfio/whatever emulating
>> an external interrupt source) seem to operate on a level of abstraction of
>> "asserted" vs "de-asserted" interrupt state regardless of the polarity, and that
>> seems not a bug but a feature, it seems that we don't need to emulate the IRQ
>> level as such. Or am I missing something?
> 
> YES, I know current KVM doesn't handle it.  Whether we should support it is another story which I cannot speak for.
> Paolo and Alex are the right person 😊
> The reason I mention this is because the complexity to adding a pending event vs. supporting a interrupt pin state is same.
> I am wondering if we need to revisit it or not.  Behavior closing to real hardware helps us to avoid potential issues IMO, but I am fine to either choice.

I guess that would imply revisiting KVM irqfd interface, since its
design is based rather on events than states, even for level-triggered
interrupts:

- trigger event (from vfio to KVM) to assert an IRQ
- resample event (from KVM to vfio) to de-assert an IRQ

> 
>>
>> OTOH, I guess this means that the existing KVM's emulation of level-triggered
>> interrupts is somewhat limited (a guest may legitimately expect an interrupt
>> fired as a result of polarity change, and that case is not supported by KVM). But
>> that is rather out of scope of the oneshot interrupts issue addressed by this
>> patchset.
> 
> Agree.
> I didn't know any commercial OSes change polarity either. But I know Xen hypervisor uses polarity under certain condition.
> One day, we may see the issue when running Xen as a L1 hypervisor.  But this is not the current worry.
> 
> 
>>
>>> "pending" field of kvm_kernel_irqfd_resampler in patch 3 means more an
>> event rather than an interrupt level.
> 
> I know.  I am fine either.
> 
> Thanks Eddie
> 
>>>
>>>
