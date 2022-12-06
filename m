Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A4F644566
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbiLFOQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiLFOQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:16:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9921B1C8
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670336118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mF6pe5WgyqMBJAsstm52pNWRjhJXeQNAiL5IirkD1UE=;
        b=QxlTE/H9xjV8kf1oDTtVGlv8nFenNSv661Iz+NCYkO37lW4/2YZytJmJQcR4qXyHAETJqZ
        yEBTDhj08DW5Ceo7xbjEa3mxi6Yxc/zb3mMFI6hi/KZQC3jiSGg6kowfJEODHVJ3DRGrrg
        6Go3uaDEc436QZP5XrEfHseLVOFkYZY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-Qx0yRiaaM7WbqJcgxYT4hA-1; Tue, 06 Dec 2022 09:15:17 -0500
X-MC-Unique: Qx0yRiaaM7WbqJcgxYT4hA-1
Received: by mail-wm1-f69.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso8480753wma.6
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 06:15:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mF6pe5WgyqMBJAsstm52pNWRjhJXeQNAiL5IirkD1UE=;
        b=oNszlSu/RsAOvJboP3m3wEwWGAoMgUuY/5WqHhieCqI8XhTNso5PXdMjIlZwn2L/UC
         qlDRj+G0A/s2GqeV/N1ECBxef0wvae/XYhHhCgqGR+zBY60S/+17TjlKx6LNYrWvivxi
         kDst9KBm1+UJVsQAwHw2nedPpbYwnfso/MSgmj0JMbwqlKKAcoAMye3Je8kwUFSP3+yu
         iPJ68CLWrwrRymVDSTpp6MHwATlUpmy9gDbIvTL39PLvwRR0tv+S1NJKx9GXFjWu7w7s
         AhjTFv53mVMpuZMGJG6gt9SGgHYnDQN2mFGoU5eE04cqGGiRxa6ZJLYmtewvoHHjklqJ
         gYDQ==
X-Gm-Message-State: ANoB5plSQUpS27/eqFtIktv8M1FOz7BVqgEsqwMSDj/3MKOdzaQnLUDT
        veCxSH0Ae1HwX4JQwIpqu42I3Sp+/bids/qkMnsBwYygsEs8x5g3ByxTCHyee7NpjPiv12mFkDC
        /NUtYPfeGYALB
X-Received: by 2002:a5d:5e89:0:b0:242:739d:7f85 with SMTP id ck9-20020a5d5e89000000b00242739d7f85mr2602723wrb.407.1670336116143;
        Tue, 06 Dec 2022 06:15:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Qv+lpTMl5ePfg/MhOHz10q6yW5Z0zXMYUQDR5cWOKWfIqjTkhSbM7G4EW0qcopma+ziWldg==
X-Received: by 2002:a5d:5e89:0:b0:242:739d:7f85 with SMTP id ck9-20020a5d5e89000000b00242739d7f85mr2602706wrb.407.1670336115890;
        Tue, 06 Dec 2022 06:15:15 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id co16-20020a0560000a1000b00241b6d27ef1sm17447135wrb.104.2022.12.06.06.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 06:15:15 -0800 (PST)
Message-ID: <c4bcbfc1-3f43-a146-de53-e98a4fff8cfe@redhat.com>
Date:   Tue, 6 Dec 2022 15:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 01/27] x86: replace
 irq_{enable|disable}() with sti()/cli()
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-2-mlevitsk@redhat.com>
 <332e7d94-4a3b-40d1-dc66-fa296e8d322e@redhat.com>
 <82ff8b2d6e2036c3fab19e103f4b90144ba1176e.camel@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <82ff8b2d6e2036c3fab19e103f4b90144ba1176e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 06/12/2022 um 14:55 schrieb Maxim Levitsky:
> On Thu, 2022-12-01 at 14:46 +0100, Emanuele Giuseppe Esposito wrote:
>>
>> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
>>> This removes a layer of indirection which is strictly
>>> speaking not needed since its x86 code anyway.
>>>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>  lib/x86/processor.h       | 19 +++++-----------
>>>  lib/x86/smp.c             |  2 +-
>>>  x86/apic.c                |  2 +-
>>>  x86/asyncpf.c             |  6 ++---
>>>  x86/eventinj.c            | 22 +++++++++---------
>>>  x86/hyperv_connections.c  |  2 +-
>>>  x86/hyperv_stimer.c       |  4 ++--
>>>  x86/hyperv_synic.c        |  6 ++---
>>>  x86/intel-iommu.c         |  2 +-
>>>  x86/ioapic.c              | 14 ++++++------
>>>  x86/pmu.c                 |  4 ++--
>>>  x86/svm.c                 |  4 ++--
>>>  x86/svm_tests.c           | 48 +++++++++++++++++++--------------------
>>>  x86/taskswitch2.c         |  4 ++--
>>>  x86/tscdeadline_latency.c |  4 ++--
>>>  x86/vmexit.c              | 18 +++++++--------
>>>  x86/vmx_tests.c           | 42 +++++++++++++++++-----------------
>>>  17 files changed, 98 insertions(+), 105 deletions(-)
>>>
>>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>>> index 7a9e8c82..b89f6a7c 100644
>>> --- a/lib/x86/processor.h
>>> +++ b/lib/x86/processor.h
>>> @@ -653,11 +653,17 @@ static inline void pause(void)
>>>  	asm volatile ("pause");
>>>  }
>>>  
>>> +/* Disable interrupts as per x86 spec */
>>>  static inline void cli(void)
>>>  {
>>>  	asm volatile ("cli");
>>>  }
>>>  
>>> +/*
>>> + * Enable interrupts.
>>> + * Note that next instruction after sti will not have interrupts
>>> + * evaluated due to concept of 'interrupt shadow'
>>> + */
>>>  static inline void sti(void)
>>>  {
>>>  	asm volatile ("sti");
>>> @@ -732,19 +738,6 @@ static inline void wrtsc(u64 tsc)
>>>  	wrmsr(MSR_IA32_TSC, tsc);
>>>  }
>>>  
>>> -static inline void irq_disable(void)
>>> -{
>>> -	asm volatile("cli");
>>> -}
>>> -
>>> -/* Note that irq_enable() does not ensure an interrupt shadow due
>>> - * to the vagaries of compiler optimizations.  If you need the
>>> - * shadow, use a single asm with "sti" and the instruction after it.
>> Minor nitpick: instead of a new doc comment, why not use this same
>> above? Looks clearer to me.
>>
>> Regardless,
>> Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>>
> 
> I am not 100% sure what you mean.
> Note that cli() doesn't have the same interrupt window thing as sti().
> 

I mean replacing

>>> +/*
>>> + * Enable interrupts.
>>> + * Note that next instruction after sti will not have interrupts
>>> + * evaluated due to concept of 'interrupt shadow'
>>> + */

with

>>> -/* Note that irq_enable() does not ensure an interrupt shadow due
>>> - * to the vagaries of compiler optimizations.  If you need the
>>> - * shadow, use a single asm with "sti" and the instruction after it.

Emanuele

