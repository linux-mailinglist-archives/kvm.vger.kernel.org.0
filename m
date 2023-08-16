Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2001877D8E7
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbjHPDPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbjHPDOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:14:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F3A1FC8;
        Tue, 15 Aug 2023 20:14:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-688787570ccso556240b3a.2;
        Tue, 15 Aug 2023 20:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692155691; x=1692760491;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JSYxFxoCtFaYHq5tDU35/I/PKWW/aYx+DXVUemb6C8=;
        b=IVIOClPljq34fr21uTeNphPBEvAoJLU/liAPxCBuJmyUK9k41dnPmVJfq/AhruOP6+
         mj2oa6spfJfGtV4628IAPxNYK+g/FM3BLrOH/K+NJi9pDO8LH1R29jUwR7XDOY9HMTsg
         ZgFwWwsmQ7lqUS++CpU59fmiqj5tZtJi8/nKLKYPA6Dv2MZ047/xGP0+45nFEr3CDUFs
         kaoaURMfFyxiwjVnJBxRJfz7YMKpVWrHGXTwoobBd9v4VDflFE0sRgUmD5EtFlBd6K7w
         GK8qRVg2RVqb5+WkcAIYyjW6OaYPzNPmDYDiRZ432rFV4Ux/gpVVJhZcWgG3OAyiUbLt
         RaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692155691; x=1692760491;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JSYxFxoCtFaYHq5tDU35/I/PKWW/aYx+DXVUemb6C8=;
        b=TJXc+Tt4XDoN5PcxluflpHtRe7XQX8p9GxZnOwj1thrxv/9RGh3h5sjG0rYDWNuxuG
         CsjcFQ535b/n4vTFUZRp6aB2qCTEIump2csV7fehWTBwo3XJKJAuwVqytAv82eUUI9cK
         H9PZqoiH0trd0KPdbvCYifYepgN//cqSChxRPJtkTVlhNGePkOiwpMye0CSvo12J5NxW
         1eN8KrrZk4TLH9/w+6Hx2OQzpSfM5Qo6ZhtBoFe/apoIumhnBeMGQ11ckG+IjcoF1STF
         nSmrYeDYnvVKSYS/2zcHvNa0Xzihat5nuiNxvJ3Id3V3OBNpLrd9xHell+xg2RRmJOfj
         tn0w==
X-Gm-Message-State: AOJu0YyGLvGZ43363/sG2vBVtVoJNWgxO32i7HUmqzJ5MCjvwUnCxAp7
        pezuBTZ8OEAEVNrNw+dGlvw=
X-Google-Smtp-Source: AGHT+IEAlXG+94dueZdgF8qUiyf6p18xZm8TZWLHkpOLwdvpWUDRBxCs7nQ4NLKP2AEo3HiDAEA0Jg==
X-Received: by 2002:a05:6a00:189c:b0:686:5e0d:bd4f with SMTP id x28-20020a056a00189c00b006865e0dbd4fmr749285pfh.0.1692155691323;
        Tue, 15 Aug 2023 20:14:51 -0700 (PDT)
Received: from localhost.localdomain ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id q18-20020a62e112000000b006874a6e74b4sm10048422pfh.151.2023.08.15.20.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:14:50 -0700 (PDT)
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, mikey@neuling.org,
        paulus@ozlabs.org, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
        amachhiw@linux.vnet.ibm.com
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
 <CUS477NDPEQI.27SBUCRNYD0XG@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <7e1df0da-77e4-eca7-e487-f51fc0968c14@gmail.com>
Date:   Wed, 16 Aug 2023 13:14:45 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CUS477NDPEQI.27SBUCRNYD0XG@wheely>
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



On 14/8/23 6:12 pm, Nicholas Piggin wrote:
> On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
>> The LPID register is 32 bits long. The host keeps the lpids for each
>> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
>> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>>
>> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
>> for each L2 guest. This value is used as an lpid, e.g. it is the
>> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
>> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>>
>> This means that struct kvm_arch::lpid is too small so prepare for this
>> and make it an unsigned long. This is not a problem for the KVM-HV and
>> nestedv1 cases as their lpid values are already limited to valid ranges
>> so in those contexts the lpid can be used as an unsigned word safely as
>> needed.
>>
>> In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
>> specified as an unsigned long so change pseries_rpt_invalidate() to
>> match that.  Update the callers of pseries_rpt_invalidate() to also take
>> an unsigned long if they take an lpid value.
> 
> I don't suppose it would be worth having an lpid_t.

I actually introduced that when I was developing for the purpose of 
doing the conversion, but I felt like it was unnecessary in the end, it 
is just a wider integer and it is simpler to treat it that way imho.

> 
>> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
>> index 4adff4f1896d..229f0a1ffdd4 100644
>> --- a/arch/powerpc/kvm/book3s_xive.c
>> +++ b/arch/powerpc/kvm/book3s_xive.c
>> @@ -886,10 +886,10 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
>>   
>>   	if (single_escalation)
>>   		name = kasprintf(GFP_KERNEL, "kvm-%d-%d",
>> -				 vcpu->kvm->arch.lpid, xc->server_num);
>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num);
>>   	else
>>   		name = kasprintf(GFP_KERNEL, "kvm-%d-%d-%d",
>> -				 vcpu->kvm->arch.lpid, xc->server_num, prio);
>> +				 (unsigned int)vcpu->kvm->arch.lpid, xc->server_num, prio);
>>   	if (!name) {
>>   		pr_err("Failed to allocate escalation irq name for queue %d of VCPU %d\n",
>>   		       prio, xc->server_num);
> 
> I would have thought you'd keep the type and change the format.

yeah, I will do that.

> 
> Otherwise seems okay too.

Thanks.

> 
> Thanks,
> Nick
> 
