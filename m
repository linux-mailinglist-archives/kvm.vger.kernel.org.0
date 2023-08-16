Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC84077D8F9
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbjHPDV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241618AbjHPDVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:21:48 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6546C26A9;
        Tue, 15 Aug 2023 20:21:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-565334377d0so4516603a12.2;
        Tue, 15 Aug 2023 20:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692156102; x=1692760902;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLgZ/fh5M5NltE3AWQwyfXy2dGWq1QEmZxlklznfsAg=;
        b=NQFRZ5iVj7FHi2JAjM2ygQ/W2FNrRIAPpcJgrHNOIdu23BM2e1PWYrzXPLCMlkXoeB
         Sf8XkZl/yFuuDhv/8MPHV8BGzMMo1LgyIk5B3/B5IbljKG6EgFumXyz/UAdjFWq1hN9x
         nE9wE/zWw1/HrQ9ApB7NMcZSu+5VEXU3T3BqIopMBwwJxCORVe8qgPUvH11nADoaTuJh
         BsLwhXwLsx0DAAqvSP4rAy0TOGPIRU/pcw8vmxPe2bgLnEIhsgT29b+JwmA5qW6yHWyM
         LX3qM3OlVYWbYx+sUGsI3YeR4R6F82MBTE73GZZslXBeDuYGP7w0zrd6C9wBild41vcw
         0wMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692156102; x=1692760902;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLgZ/fh5M5NltE3AWQwyfXy2dGWq1QEmZxlklznfsAg=;
        b=YfFePqgU9y7rAjGx4eYw9Ss12HNuggA6hSZLYlGwnIr2iJg3TYI+7ZrV8p8f7qFYpd
         S100EidgP8NdFUD+pIAMxLdEfN1BIhGhMIStFTklWQm6j+kbN8EvdvKkWSBt6tEYfXYD
         j9pVFXoHskZco7P4sP+V6w5uPc4Y1GQP2Rzufdf6j8mBJx1+D49UPzHZZfp5vb5FxTKy
         zg9/J5kECp3xmiUc+JvpYJ0B1Nu3zw+FOk4E0lk4x9P9lDvqtPGmP05tPMWAG8Kdk2KL
         KE6Q1WW8hV/AYmnfef2h3OnzbKQ5siwhmIpZ9IOnKYDOgmagSWmpnml2JWlYYrcLayjY
         KWSw==
X-Gm-Message-State: AOJu0YxAePxZzB0t6JqREHtsLcIOgveazP0bR0PCOM97Vpc2Yqp9PPLc
        ujn3RN0zJiYp3GOPIQPDrHQ=
X-Google-Smtp-Source: AGHT+IE7yVdS0kMwy4HCS9A43/hjpM+6g1vzheq8U3+lI6mnkuv35ezpapXAmiqsRXd/mnIEFHG+sQ==
X-Received: by 2002:a17:90b:3809:b0:268:5c3b:6f37 with SMTP id mq9-20020a17090b380900b002685c3b6f37mr407598pjb.0.1692156101753;
        Tue, 15 Aug 2023 20:21:41 -0700 (PDT)
Received: from localhost.localdomain ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b001b892aac5c9sm11786337plf.298.2023.08.15.20.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:21:41 -0700 (PDT)
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, mikey@neuling.org,
        paulus@ozlabs.org, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
        amachhiw@linux.vnet.ibm.com
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
 <CUS477NDPEQI.27SBUCRNYD0XG@wheely> <87ttt0d1ol.fsf@mail.lhotse>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <473611e9-5831-cc6f-ba75-86964fe71b6e@gmail.com>
Date:   Wed, 16 Aug 2023 13:21:36 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87ttt0d1ol.fsf@mail.lhotse>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/8/23 8:45 pm, Michael Ellerman wrote:
> "Nicholas Piggin" <npiggin@gmail.com> writes:
>> On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
>>> The LPID register is 32 bits long. The host keeps the lpids for each
>>> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
>>> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>>>
>>> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
>>> for each L2 guest. This value is used as an lpid, e.g. it is the
>>> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
>>> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>>>
>>> This means that struct kvm_arch::lpid is too small so prepare for this
>>> and make it an unsigned long. This is not a problem for the KVM-HV and
>>> nestedv1 cases as their lpid values are already limited to valid ranges
>>> so in those contexts the lpid can be used as an unsigned word safely as
>>> needed.
>>>
>>> In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
>>> specified as an unsigned long so change pseries_rpt_invalidate() to
>>> match that.  Update the callers of pseries_rpt_invalidate() to also take
>>> an unsigned long if they take an lpid value.
>>
>> I don't suppose it would be worth having an lpid_t.
>>
>>> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
>>> index 4adff4f1896d..229f0a1ffdd4 100644
>>> --- a/arch/powerpc/kvm/book3s_xive.c
>>> +++ b/arch/powerpc/kvm/book3s_xive.c
>>> @@ -886,10 +886,10 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
>>>   
>>>   	if (single_escalation)
>>>   		name = kasprintf(GFP_KERNEL, "kvm-%d-%d",
>>> -				 vcpu->kvm->arch.lpid, xc->server_num);
>>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num);
>>>   	else
>>>   		name = kasprintf(GFP_KERNEL, "kvm-%d-%d-%d",
>>> -				 vcpu->kvm->arch.lpid, xc->server_num, prio);
>>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num, prio);
>>>   	if (!name) {
>>>   		pr_err("Failed to allocate escalation irq name for queue %d of VCPU %d\n",
>>>   		       prio, xc->server_num);
>>
>> I would have thought you'd keep the type and change the format.
> 
> Yeah. Don't we risk having ambigious names by discarding the high bits?
> Not sure that would be a bug per se, but it could be confusing.

In this context is would always be constrained be the number of LPID 
bits so wouldn't be ambiguous, but I'm going to change the format.

> 
> cheers
> 
