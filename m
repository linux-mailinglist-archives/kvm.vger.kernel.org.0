Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF464B2423
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349405AbiBKLSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:18:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239179AbiBKLSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29506FF
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644578291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7Yj/WHUmr9v6/YtpG86Ztj5f1af9VlUf1YMxG56kZI=;
        b=VtZ9uV7gdC4SGAAzB2ANnHjs7a/oFjTnbGrS4yGKe5YfEso1teKUy4OnEJ2KQWHpRwQUnq
        85HAZNkYECsdab3u6Hs85kaQ2YtQjT0yFBndi4vt9AAQeB+pgnmJlswXwBFzu//EcPOo2W
        kvVgRKKgUZQLHTm0uVQpHekHgpbViHs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-C8GWgDX8MQeFulOFYgHFbw-1; Fri, 11 Feb 2022 06:18:10 -0500
X-MC-Unique: C8GWgDX8MQeFulOFYgHFbw-1
Received: by mail-wr1-f72.google.com with SMTP id k3-20020adfb343000000b001e463e6af20so3728409wrd.8
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q7Yj/WHUmr9v6/YtpG86Ztj5f1af9VlUf1YMxG56kZI=;
        b=bNnG4CuTAdAso1cp5jB1B5iYLT54aKbxDqbHkC2Sx8yp5ro+4k12yH64rftyyJ6bc2
         cP0VkhXWY22dLSTcYwXUKTOUkLj4Aj6IKphmFhiEPXjQlImaF6SKmkYB0uT53tAt4UNZ
         vsqdyonWvDfDfLqzBDLN4EPegXdu/gHbGLRrGqCsbvgUCnb6AukKYbHypBYsoS0hLVjY
         idC86Vs2dhjBDMg+dC1xnoWONnvd4Xz3kV1I6IFL2iS/t92TNayxnXnsU1vGx1t7GgFi
         adTYfCVldZmbHxWt7DbIppQYLofaZf8kE1BU7va0vcFPyy3k5ZXXZLovK55KjCs+Zu/5
         WPcw==
X-Gm-Message-State: AOAM530SqehP9kPppWZPO6FB/oxDq2LLV7IKTZTYJ4SVOBBpPP5v9Nky
        SD2WiFkkdGVrLqQAjZGhJ44rC5enfqUnRDRQTd9Us+MJ9uwh1ujRa9hEhKUu0052mmBnNgIItom
        W8Y9nqoIWVpPL
X-Received: by 2002:a05:6000:16c5:: with SMTP id h5mr982881wrf.364.1644578288918;
        Fri, 11 Feb 2022 03:18:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDcgpMTGH6f6BVy2LLyhE/vujiSOoCqg6ifnUovFsPfT65EG9BHiOZVdUE59P/9kZOzEcMIw==
X-Received: by 2002:a05:6000:16c5:: with SMTP id h5mr982863wrf.364.1644578288694;
        Fri, 11 Feb 2022 03:18:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id r13sm9590084wro.89.2022.02.11.03.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 03:18:08 -0800 (PST)
Message-ID: <94cb12a0-ba01-57b0-0aeb-9b179d89c874@redhat.com>
Date:   Fri, 11 Feb 2022 12:18:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 04/12] KVM: MMU: WARN if PAE roots linger after
 kvm_mmu_unload
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-5-pbonzini@redhat.com> <YgWdyN3uarajuLdG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgWdyN3uarajuLdG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 00:20, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index e0c0f0bc2e8b..7b5765ced928 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5065,12 +5065,21 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>>   	return r;
>>   }
>>   
>> +static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>> +{
>> +	int i;
>> +	kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
>> +	WARN_ON(VALID_PAGE(mmu->root_hpa));
>> +	if (mmu->pae_root) {
>> +		for (i = 0; i < 4; ++i)
>> +			WARN_ON(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
>> +	}
> 
> I'm somewhat ambivalent, but if you're at all on the fence, I vote to drop this
> one.  I've always viewed the WARN on root_hpa as gratuitous.
> 
> But, if it helped during development, then why not...

Well, it was not really helping in that the WARN triggered, but rather 
it was ruling out the more blatant violations of invariants.  The one in 
patch 5 triggered a lot, though.

Paolo

