Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0F7CF31C
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjJSIpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbjJSIo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4124D7D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697705026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNhtEDb46cdwd0UeanpUYMMLzJiY9Fo2EaQX8hX2fF8=;
        b=DGEHFAGPn454pIpiRLi6q1arlo8C9Reup1r6INOaW3X/pHnjYbXBeHaRf5K96fk0xH7BKR
        DPA3JGnvx3TMY4eRMbggMN0mAIe2V+4cTFD/vWvQENHnVjkiBMqRCjajCqHigoRAwaFTzj
        lg/6wukUCxrloZSbQh38vZhVVuhTZDU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-gkJ8pLk2NUSe0HitWLqJhg-1; Thu, 19 Oct 2023 04:43:40 -0400
X-MC-Unique: gkJ8pLk2NUSe0HitWLqJhg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66d35dda745so60844716d6.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697705020; x=1698309820;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNhtEDb46cdwd0UeanpUYMMLzJiY9Fo2EaQX8hX2fF8=;
        b=NVEmN3IHFiTP7iS/5g10NI0AvAs3olqMfnIg0MXcmdejWReNrKCPeY0/+NCnJV9FyD
         XcLAQKPo+Oivh+1G7rmloSRemTT2H5Yw+7YG6lPZNdrz+RG1x7NaS0pAplCwlfT7o269
         sVcbrFjjzqaPLjDVhYSBlNk/JFNSmJp5mhf8SA3ex4CErIRrts9yfvyxsSlNZatrGXNu
         TtTSM/4Ex9juKVQItunQG/Fqnc3Mf8vVjQGAvr5y8KXNgTBALUd7Sl5DIXI1ymCEiBNF
         Nmba9Ikex/gKCFG9tY7R4yY3NRnnwwZUmxkQ4vkzQKOv8jVEvctVMNJRyl8AShe8VUZf
         4cuA==
X-Gm-Message-State: AOJu0Yyn1IbVLzRset5XH+s+oeGJ+47KkTvzTzC3lt/UtoIe8w/y5Og3
        HChXA5V44oe/Mzm62nzjar1mC2ZOVz1Sa642uBA19I+VqhJt/cNNrUzD5g4T+qfE39Qwut1oD5M
        O2yj3rd/dh3Ey
X-Received: by 2002:ad4:5fcd:0:b0:66c:ffe1:e244 with SMTP id jq13-20020ad45fcd000000b0066cffe1e244mr2186140qvb.62.1697705020215;
        Thu, 19 Oct 2023 01:43:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETbfgv/8+88fGni1xgnaMxsBgnNEdj2B+ZY0ZeQEa62JYNYio5HxIOk7eFGTP20cQ6OiiUgQ==
X-Received: by 2002:ad4:5fcd:0:b0:66c:ffe1:e244 with SMTP id jq13-20020ad45fcd000000b0066cffe1e244mr2186118qvb.62.1697705019902;
        Thu, 19 Oct 2023 01:43:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t6-20020a056214118600b0066d11c1f578sm625981qvv.97.2023.10.19.01.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 01:43:39 -0700 (PDT)
Message-ID: <48d09c9f-78d9-e5eb-d85a-e75a6df81396@redhat.com>
Date:   Thu, 19 Oct 2023 10:43:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Mark Brown <broonie@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
 <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
 <ZTBzAR1KsWuurob7@linux.dev>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <ZTBzAR1KsWuurob7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 10/19/23 02:06, Oliver Upton wrote:
> Hi Eric,
> 
> Thanks for reviewing the series.
> 
> On Wed, Oct 18, 2023 at 03:06:12PM +0200, Eric Auger wrote:
>> Hi Mark, Oliver,
>>
>> On 10/18/23 14:16, Mark Brown wrote:
>>> On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
>>>> On 10/11/23 21:57, Oliver Upton wrote:
>>>
>>>>>  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
>>>>>  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
>>>>>  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
>>>>> +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
>>>
>>>> could you comment on the *DIT* addictions, what is it for?
>>>
>>> DIT is data independent timing, this tells the processor to ensure that
>>> instructions take a constant time regardless of the data they are
>>> handling.
>>
>>>
>>> Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
>>> the main purpose here is to sync with the original.
>>
>> Ah thanks. that's helpful for me to understand where this gpr-num.h
>> comes from. This could be documented in the commit msg though.
>>
>> Something like:
>>
>> adding tools/arch/arm64/include/asm/gpr-num.h matching linux
>> arch/arm64/include/asm/gpr-num.h
>>
>> and syncing tools/arch/arm64/include/asm/sysreg.h with the fellow header
>> in the linux tree.
> 
> Yeah, I could've spelled it out a bit more. I already cracked this off
> of an even larger patch from before I picked up the series because the
> diff was massive.
> 
>> tbh I did not initially understand that all this diffstat was aimed to
>> match the linux arch/arm64/include/asm/sysreg.h. Now diffing both I have
>> some diffs. Doesn't it need a refresh?
> 
> I'm worried it is a fool's errand at this point to keep the two in sync,
> as I'm sure there will be more in -rc1. The tools copy of sysreg.h isn't
> a verbatim copy either, there are some deliberate deletions in there as
> well.
> 
> I've taken this as is, we can always come back and update the headers
> afterwards if we find a need for it

OK np. I did not notice you picked the series up and I jumped in too
late. Anyway that was worthwhile for my education ;-)

Eric
> 

