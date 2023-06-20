Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40658736AA8
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjFTLPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjFTLPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 07:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2247100
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687259681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mu3ZQzCMoDG/BdFJ4c8DVA27suqD5RiJoI5p+Cmymt4=;
        b=OWlVsml/39/YkE0agg5rZuZ8ZVgLCCqGV4k9xQBvrarcU61ErE0qfhhiaLQ8gf2SAuEvKi
        0oZpntp5XqXhUC5zQ+xWjse4OyXGvJ2YUm6uv58JyXNt8D7BzbIgndTlgAv27mBjuAvtG7
        U9LAU726B7o0aRYphEltmhBokKfuxi4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-BNf-Ai1fNBiJhj1aUATp6Q-1; Tue, 20 Jun 2023 07:14:39 -0400
X-MC-Unique: BNf-Ai1fNBiJhj1aUATp6Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f9b19cb170so10495425e9.3
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 04:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687259678; x=1689851678;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mu3ZQzCMoDG/BdFJ4c8DVA27suqD5RiJoI5p+Cmymt4=;
        b=Jr1PAjLxjGQqUdprwsC2Jp1WwEj+M5edzSI3cBoswpSKQWEz6kSvkJsgFpI8Z5VASE
         pjCbY2gb3QrKcGyYapCjsZhnSPo2pVefFEbNLLApPeaFkQlqvOGpzRYVPRwUFjaTFcxX
         yT9XRAgpInQs1PH9BbH3vUXAMhgn7OJL+hCoHZNt+rqw6//oQKcNsvnpZNm6WWwbKI4J
         uyK91V1CY6/V4AL8l6YgDdHiROTTWwt/B52O+6mDfwqPdaSx490ykouqwKxVV85u8z0z
         t+bCWGEF2TvUz8bo6viuU1fE4tS6Z5+LLifcqF+QE1Gi+AIGHN93v62rATYJrecu1yCD
         HlaQ==
X-Gm-Message-State: AC+VfDzRE54fHXrvrE26XQIeVUyF8PKbgHmwaLM1X8BV3tD3Ax6I9cir
        Qp4YRjwZLZSd3T4uMmuS8upWmsis6sNqzlzf0Rc0/pgQrycgLJ4RNIqAHj1q15bkQpXcEiMKeyS
        e3dxuS7yJSBk93zveCy/e
X-Received: by 2002:a05:600c:ad7:b0:3f9:991:61da with SMTP id c23-20020a05600c0ad700b003f9099161damr6086200wmr.39.1687259678527;
        Tue, 20 Jun 2023 04:14:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6u6jldeAOsB6wg1qa0UPiJcOns6sSKWJbgG0tPJvfJ3eO3oLpf80/A1fUaVkJjziN4kC9ERA==
X-Received: by 2002:a05:600c:ad7:b0:3f9:991:61da with SMTP id c23-20020a05600c0ad700b003f9099161damr6086174wmr.39.1687259678152;
        Tue, 20 Jun 2023 04:14:38 -0700 (PDT)
Received: from ?IPV6:2003:cb:c739:d200:8745:c520:8bf6:b587? (p200300cbc739d2008745c5208bf6b587.dip0.t-ipconnect.de. [2003:cb:c739:d200:8745:c520:8bf6:b587])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003f7f475c3bcsm22876375wmo.1.2023.06.20.04.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 04:14:37 -0700 (PDT)
Message-ID: <193d0e6d-27b6-b50e-8a3e-35c1816b20fc@redhat.com>
Date:   Tue, 20 Jun 2023 13:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
 <dfb59553-2777-15ed-d523-6a7cc5b68e53@redhat.com>
 <1cc1879691fcd077fed1a485de799594d751a8ec.camel@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <1cc1879691fcd077fed1a485de799594d751a8ec.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.06.23 12:39, Huang, Kai wrote:
> 
>>> @@ -33,12 +34,24 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>>>    				    struct tdx_module_output *out)
>>>    {
>>>    	int cpu, ret = 0;
>>> +	int retry;
>>>    	u64 sret;
>>>    
>>>    	/* Need a stable CPU id for printing error message */
>>>    	cpu = get_cpu();
>>>    
>>> -	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
>>> +	/*
>>> +	 * Certain SEAMCALL leaf functions may return error due to
>>> +	 * running out of entropy, in which case the SEAMCALL should
>>> +	 * be retried.  Handle this in SEAMCALL common function.
>>> +	 *
>>> +	 * Mimic the existing rdrand_long() to retry
>>> +	 * RDRAND_RETRY_LOOPS times.
>>> +	 */
>>> +	retry = RDRAND_RETRY_LOOPS;
>>
>> Nit: I'd just do a "int retry = RDRAND_RETRY_LOOPS" and simplify this
>> comment to "Mimic rdrand_long() retry behavior."
> 
> OK will do.
> 
> But I think you are talking about replacing the second paragraph but not the
> entire comment?
>

Yes.

-- 
Cheers,

David / dhildenb

