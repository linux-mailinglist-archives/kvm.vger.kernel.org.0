Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940995351B0
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347380AbiEZPwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344062AbiEZPww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:52:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C44EDE31F
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653580370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSb/31fWao51fuvQhRU5QL5Gj3VrxjiuEBRl0z2YmX0=;
        b=hjsM2oWfR5zZGFHDRGdDm4blVAtUfWzyuXOTilSZPIRx/iWHCx5dNgcG9yse+eVJFEy/Cm
        U2U5jFla9h3SqzCJ0mcsqIBIMl/St2WQDyaJ3TaklYAcILDs+6gzmqpBpmFtyfSuMrB5eJ
        DSFqFZJR30VvGUuZZIsrXA9scokJxbM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-4gQUTZ4SNYq8hdCidDochQ-1; Thu, 26 May 2022 11:52:49 -0400
X-MC-Unique: 4gQUTZ4SNYq8hdCidDochQ-1
Received: by mail-ej1-f72.google.com with SMTP id p7-20020a170906614700b006f87f866117so1021821ejl.21
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rSb/31fWao51fuvQhRU5QL5Gj3VrxjiuEBRl0z2YmX0=;
        b=2JUQAjFlUZ3xAZrOMLuA8Lz/KcnJ0x4qd34Bl+3jUveaCt9yvTR+LaKulSmxADkpS5
         HCnjQOtE6yPBxoXHREMJlRhMyD8pBNWgClH6Kk9emXaYWeMvjPqV4VCYAhJPmrr7DFGG
         Ryei09IpqCYTBgCIJukXG4cUdDL6vS2nzszhiMxpNpQETTA1FCBa3Q6UznpT4g1lcMca
         4DrHo7BA9YY0wkGUEH8ne5M75gxCIFUSvS0qV53BSjFE8VC89y20bYhtH5q0Moq5/mRb
         3AGVG852ENrHfspilNunueIB8g6cT9tmS4EjmHxch6T4z6g/E5T0iPkf4nxF1nKykwJD
         s++A==
X-Gm-Message-State: AOAM530DpkSq3J4bMNuUqPzT9czMFpQ8FkcdOzsHCz5UAu+kwFzu7AVG
        8UWeqNTOnnP1MrWqB9MwLxiCc1Pb/u47B9UHhU4eQPFRcnJH8SARn2715luCQdxDuNictUPoZkI
        8XsXEKXwlW1oJ
X-Received: by 2002:a17:907:7b8f:b0:6fe:fcae:615a with SMTP id ne15-20020a1709077b8f00b006fefcae615amr15729285ejc.658.1653580367255;
        Thu, 26 May 2022 08:52:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYhN/upHIsj/j2UEamiuyv1JioyxHM/yRSgGRL8HEX8U32cH0n4xTzIeNkrc6lCiN/uK/20w==
X-Received: by 2002:a17:907:7b8f:b0:6fe:fcae:615a with SMTP id ne15-20020a1709077b8f00b006fefcae615amr15729271ejc.658.1653580367005;
        Thu, 26 May 2022 08:52:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w15-20020a17090652cf00b006fed8dfcf78sm619667ejn.225.2022.05.26.08.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 08:52:46 -0700 (PDT)
Message-ID: <a1fbab86-ece9-82e3-64fe-0a19a125513b@redhat.com>
Date:   Thu, 26 May 2022 17:52:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
 logging
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20220525230904.1584480-1-bgardon@google.com>
 <a3ea7446-901f-1d33-47a9-35755b4d86d5@redhat.com>
 <Yo+O6AqNNBTg7BMY@xz-m1.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yo+O6AqNNBTg7BMY@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/22 16:30, Peter Xu wrote:
> On Thu, May 26, 2022 at 02:01:43PM +0200, Paolo Bonzini wrote:
>> On 5/26/22 01:09, Ben Gardon wrote:
>>> +		WARN_ON(max_mapping_level < iter.level);
>>> +
>>> +		/*
>>> +		 * If this page is already mapped at the highest
>>> +		 * viable level, there's nothing more to do.
>>> +		 */
>>> +		if (max_mapping_level == iter.level)
>>> +			continue;
>>> +
>>> +		/*
>>> +		 * The page can be remapped at a higher level, so step
>>> +		 * up to zap the parent SPTE.
>>> +		 */
>>> +		while (max_mapping_level > iter.level)
>>> +			tdp_iter_step_up(&iter);
>>> +
>>>    		/* Note, a successful atomic zap also does a remote TLB flush. */
>>> -		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
>>> -			goto retry;
>>> +		tdp_mmu_zap_spte_atomic(kvm, &iter);
>>> +
>>
>> Can you make this a sparate function (for example
>> tdp_mmu_zap_collapsible_spte_atomic)?  Otherwise looks great!
> 
> There could be a tiny downside of using a helper in that it'll hide the
> step-up of the iterator, which might not be as obvious as keeping it in the
> loop?

That's true, my reasoning is that zapping at a higher level can only be 
done by first moving the iterator up.  Maybe 
tdp_mmu_zap_at_level_atomic() is a better Though, I can very well apply 
this patch as is.

Paolo

