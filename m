Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368F2591AD1
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbiHMOEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 10:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbiHMOEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 10:04:07 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C46813F35
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 07:04:06 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z20so3427719ljq.3
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 07:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=qyCH1Xo3YO20trnPHb9qoKkPoh3odrsC9eN4HgrltUw=;
        b=pSjJl9nWWTwf30szirsqzHpUBwAT4x3UZvhP0LsmCQk5oPk2gCWtyKyw7etOt1IYj+
         B4IXN9FAv7NcHFX2MvF4MWy6MIad0C54UZ+W96jFFi/3UVco/0Yrns3GXb5JIdA74BUn
         rvohWFIy1n1T3aRJVh5QhOrhzafYQePE/PgVpGFaOUsflOM3NhiIMjW6/HzYKTwE2hrq
         vvur8llMkR0wo2oFUT3PWlj+CQWyOgcoLu1o152c5dzf6YgdHwMvj4Oa8z4EnFd2k0sI
         PfwCw1QvZ3ZEeMDMXtEh1mlmRYPS+YHLWrgcs160//0Uhyyi5V+obpdHan8wNTsMAAh1
         BzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=qyCH1Xo3YO20trnPHb9qoKkPoh3odrsC9eN4HgrltUw=;
        b=NgrCViRyBIIM7NOmddndnZHAhi7UnkJEEaCz3yBdfWL1C0AK9VZfWKU/+F+vI5N8vo
         oum9c5QpHCn4LzOUmvYT52DtzX1JJshF4dpL0B4eKhEFYog4njovA9Hez5kl281vzJBR
         tilw63/tqejRHIQ09dT3ElU63rZWCnUzK4W3NBJPIiJm/3YnAUBMz6bRuAxf7hsctF8o
         jdTB56uV7CA8Vlh87atdo9yOjwaONHQLZWs1d/d7tw+g9BVvBGEGwW3l6JmwE6sUnORz
         eLT0SuWR1fN5viz1eIg0YAIDOAGs8v/e8IE2GkNKAmwHwqZ9941rD8dqS3CRMkqEkdg4
         voYA==
X-Gm-Message-State: ACgBeo1/DHQscaeNXlXqDn2L/W0o9l6WPHNBQVOW51kpIEGUkVHp+Uhx
        mFRlrnUIIhb8an2ZskBvWzm5hw==
X-Google-Smtp-Source: AA6agR5VxsPrML+qpTqW2rw4vgpk7nmQXlRpcrdzJOBbwoJsnBmFxEP9T1qSfVEidE7fMp/9En26gQ==
X-Received: by 2002:a2e:bcc5:0:b0:261:737a:1d1f with SMTP id z5-20020a2ebcc5000000b00261737a1d1fmr2121381ljp.418.1660399444627;
        Sat, 13 Aug 2022 07:04:04 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id h6-20020a2ea486000000b0025e57b40009sm767472lji.89.2022.08.13.07.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 07:04:03 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
To:     "Liu, Rong L" <rong.l.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
Cc:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
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
 <8ff76b5e-ae28-70c8-2ec5-01662874fb15@redhat.com>
 <87r11ouu9y.wl-maz@kernel.org>
 <72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com>
 <d8704ffa-8d9e-2261-1bcf-1b402f955fad@redhat.com>
 <MW3PR11MB4554AAFB43FA6B0B612150D9C7649@MW3PR11MB4554.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <f843fa85-41ce-bf45-d1d7-69341dea2939@semihalf.com>
Date:   Sat, 13 Aug 2022 16:04:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB4554AAFB43FA6B0B612150D9C7649@MW3PR11MB4554.namprd11.prod.outlook.com>
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

On 8/12/22 12:40 AM, Liu, Rong L wrote:
> Hi Paolo and Dmytro,
> 
>> -----Original Message-----
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Sent: Wednesday, August 10, 2022 11:48 PM
>> To: Dmytro Maluka <dmy@semihalf.com>; Marc Zyngier
>> <maz@kernel.org>; eric.auger@redhat.com
>> Cc: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>> <seanjc@google.com>; kvm@vger.kernel.org; Thomas Gleixner
>> <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav
>> Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>> kernel@vger.kernel.org; Alex Williamson <alex.williamson@redhat.com>;
>> Liu, Rong L <rong.l.liu@intel.com>; Zhenyu Wang
>> <zhenyuw@linux.intel.com>; Tomasz Nowicki <tn@semihalf.com>;
>> Grzegorz Jaszczyk <jaz@semihalf.com>; upstream@semihalf.com;
>> Dmitry Torokhov <dtor@google.com>
>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>
>> On 8/10/22 19:02, Dmytro Maluka wrote:
>>>      1. If vEOI happens for a masked vIRQ, notify resamplefd as usual,
>>>         but also remember this vIRQ as, let's call it, "pending oneshot".
>>>
> 
> This is the part always confuses me.   In x86 case, for level triggered
> interrupt, even if it is not oneshot, there is still "unmask" and the unmask
> happens in the same sequence as in oneshot interrupt, just timing is different. 
>  So are you going to differentiate oneshot from "normal" level triggered
> interrupt or not?   And there is any situation that vEOI happens for an unmasked
> vIRQ?

We were already talking about it in [1] and before. It still seems to me
that your statement is wrong and that with x86 ioapic, "normal"
level-triggered interrupts normally stay unmasked all the time, and only
EOI is used for interrupt completion. To double-confirm that, I was once
tracing KVM's ioapic_write_indirect() and confirmed that it's not called
when Linux guest is handling a "normal" level-triggered interrupt.

However, it seems that even if you were right and for normal interrupts
an EOI was always followed by an unmask, this proposal would still work
correctly. 

> 
>  > >      2. A new physical IRQ is immediately generated, so the vIRQ is
>>>         properly set as pending.
>>>
> 
> I am not sure this is always the case.  For example, a device may not raise a
> new interrupt until it is notified that "done reading" - by device driver
> writing to a register or something when device driver finishes reading data.  So
> how do you handle this situation?

Right, the device will not raise new interrupts, but also it will not
lower the currently pending interrupt until "done reading". Precisely
for this reason the host will receive a new interrupt immediately after
vfio unmasks the physical IRQ.

It's also possible that the driver will notify "done reading" quite
early, so the device will lower the interrupt before vfio unmasks it, so
no new physical interrupt will be generated, - and that is fine too,
since it means that the physical IRQ is no longer pending, so we don't
need to notify KVM to set the virtual IRQ status to "pending".

> 
>>>      3. After the vIRQ is unmasked by the guest, check and find out that
>>>         it is not just pending but also "pending oneshot", so don't
>>>         deliver it to a vCPU. Instead, immediately notify resamplefd once
>>>         again.
>>>
> 
> Does this mean the change of vfio code also?  That seems the case: vfio seems
> keeping its own internal "state" whether the irq is enabled or not.

I don't quite get why would it require changing vfio. Could you
elaborate?

[1] https://lore.kernel.org/kvm/9054d9f9-f41e-05c7-ce8d-628a6c827c40@semihalf.com/

Thanks,
Dmytro

> 
> Thanks,
> 
> Rong
>>> In other words, don't avoid extra physical interrupts in the host
>>> (rather, use those extra interrupts for properly updating the pending
>>> state of the vIRQ) but avoid propagating those extra interrupts to the
>>> guest.
>>>
>>> Does this sound reasonable to you?
>>
>> Yeah, this makes sense and it lets the resamplefd set the "pending"
>> status in the vGIC.  It still has the issue that the interrupt can
>> remain pending in the guest for longer than it's pending on the host,
>> but that can't be fixed?
>>
>> Paolo
> 
