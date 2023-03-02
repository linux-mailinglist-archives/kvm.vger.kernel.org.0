Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D9E6A7FB8
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCBKLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 05:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjCBKL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 05:11:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6DC2594B
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 02:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677751843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aTsyym2ojY15BDjEKvUAQ9jN35vY4GlELhzsk2Jls4g=;
        b=I+QX+AcrEf2mkhda9qUFXKVACQe5zGDq1i1Won9ldzXiVN4/SPdlR+O5NQj/x80u+Vo2kP
        S7DSkXszj0hFUs8PKYZXmaSEq3AlrrXC2s3zbn6ZUIm4Sml5q/8jTMf/ucpQrTrw7nnJuG
        cHKxgq8w9lYudmHfJmL9bEBmxzvuT2M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-xX0T2WMNNeycuCkMMW8-Hw-1; Thu, 02 Mar 2023 05:10:41 -0500
X-MC-Unique: xX0T2WMNNeycuCkMMW8-Hw-1
Received: by mail-qv1-f72.google.com with SMTP id y3-20020a0cec03000000b0056ee5b123bbso8637980qvo.7
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 02:10:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677751841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aTsyym2ojY15BDjEKvUAQ9jN35vY4GlELhzsk2Jls4g=;
        b=2/CSL14p2k9J3tK8AY3uTkemzfluyss64hnYxg6vkf08H+yxe9gI7PTv8o4cgR3m6V
         fJr8MgfHo5Q+BSkdhnMf4pzcwyT7XAsbBjU/F7E4ojlFduZX55s5H4eTBsTxX4kFiCDy
         RBw0T9dPbWHKMbyu56vWnn39jbPsXA0kq3PeHrjZYSrp7ZBdbAU3uoiB6oh+6hVNSDEC
         BzW6PkrBWX6cKz5bqzuhXy0ELtDEDB7k9K1M6qEaKBAgW76u4WDbEhH6KAfJG7lprYOI
         1SND1fj4sGOI2ZhtxwpqmE11cEbSDE1mvvi+FByOAlsG0mM8l+q41/6NrNMcuXFkxgaB
         KUMw==
X-Gm-Message-State: AO0yUKVZB6dKPff7YFzQosJrBXC7G8jjtEWBmGasPF6+Lr45cy9e67vk
        pAHvfcFAj/6bebZQX+EOKg70ToxHawkV3Otk/Ds7iAWwhX/OnKihGMtpzDgWiGbHRDBfDVNmrFP
        BqH8uwQBKV5Wd
X-Received: by 2002:a05:622a:1ba4:b0:3bf:cc1b:9512 with SMTP id bp36-20020a05622a1ba400b003bfcc1b9512mr16236831qtb.1.1677751841123;
        Thu, 02 Mar 2023 02:10:41 -0800 (PST)
X-Google-Smtp-Source: AK7set8iuxjq/oS9wjoGamA+RNusWuw/Uj844NboAKo/EYygRedlk1SaYZHPi5oAEfYrvSJ4EeJe3A==
X-Received: by 2002:a05:622a:1ba4:b0:3bf:cc1b:9512 with SMTP id bp36-20020a05622a1ba400b003bfcc1b9512mr16236808qtb.1.1677751840898;
        Thu, 02 Mar 2023 02:10:40 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o26-20020ac8429a000000b003b64f1b1f40sm10036549qtl.40.2023.03.02.02.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 02:10:40 -0800 (PST)
Message-ID: <ba22acfd-b1a5-626b-c1e7-e1268dc5ab7d@redhat.com>
Date:   Thu, 2 Mar 2023 18:10:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RESEND kvm-unit-tests 1/3] arm: gic: Write one bit per time in
 gic_irq_set_clr_enable()
Content-Language: en-US
To:     eric.auger@redhat.com, kvmarm@lists.linux.dev
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "open list:ARM" <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-2-shahuang@redhat.com>
 <a9799d3b-e7c5-89fd-a910-b574cff67913@redhat.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <a9799d3b-e7c5-89fd-a910-b574cff67913@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 3/2/23 16:19, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 3/2/23 04:02, Shaoqin Huang wrote:
>> When use gic_irq_set_clr_enable() to disable an interrupt, it will
>> disable all interrupt since it first read from Interrupt Clear-Enable
>> Registers and then write this value with a mask back.
> 
> nit: it first read from Interrupt Clear-Enable Registers where '1' indicates that forwarding of the corresponding interrupt is enabled
> 

Thanks for your advice.

>>
>> So diretly write one bit per time to enable or disable interrupt.
> directly

I will fix it in v2.

Thanks,

>> Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Thanks
> 
> Eirc
>> ---
>>   lib/arm/gic.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
>> index 1bfcfcf..89a15fe 100644
>> --- a/lib/arm/gic.c
>> +++ b/lib/arm/gic.c
>> @@ -176,7 +176,6 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>>   void gic_irq_set_clr_enable(int irq, bool enable)
>>   {
>>   	u32 offset, split = 32, shift = (irq % 32);
>> -	u32 reg, mask = BIT(shift);
>>   	void *base;
>>   
>>   	assert(irq < 1020);
>> @@ -199,8 +198,7 @@ void gic_irq_set_clr_enable(int irq, bool enable)
>>   		assert(0);
>>   	}
>>   	base += offset + (irq / split) * 4;
>> -	reg = readl(base);
>> -	writel(reg | mask, base);
>> +	writel(BIT(shift), base);
>>   }
>>   
>>   enum gic_irq_state gic_irq_state(int irq)
> 

-- 
Shaoqin

