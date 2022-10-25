Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D1060C7B5
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 11:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiJYJPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 05:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiJYJOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 05:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0659917C146
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 02:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666688886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51wCy9Fe30GS1woan/cFvei0lT2z2Oszyf3hLy2bkoU=;
        b=JGtAQ71Uiv4kw63vL8xM50kL5UYYDMGwz4QerJ0ub7kcBId4rVsFLM+b8nzfYX34Pxn/ol
        JeQu/zUV5cxhZ2vUrgenS5AYD7J9ZjVNUctCL9SyvaspViSB7Hk+/gsngu8bTD1Bnq+t0z
        7tC3rcEseUCDjt5TK5WapkVsJiSTptc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-272-Awih_q8kNxOwlGiQSDhN-g-1; Tue, 25 Oct 2022 05:08:04 -0400
X-MC-Unique: Awih_q8kNxOwlGiQSDhN-g-1
Received: by mail-wm1-f70.google.com with SMTP id z10-20020a05600c220a00b003c6ecad1decso2240331wml.2
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 02:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51wCy9Fe30GS1woan/cFvei0lT2z2Oszyf3hLy2bkoU=;
        b=SYLZet7u4kiUcWj9RG+W/RPIh6G1HfF9IhbDhQQxle3LfwK0oenH2z1Cqw2xox0+XO
         IGhuJ3EQyeaK/7cR+Gx4xPER+wXCcUB67vQpVWHQU7h0HMAlrN/JIrXkiwH5mUrabYUB
         dIFuwyan7zR6K3cG06R/BAm1+R89B2g8jTC+YRu2WL3WdRVT7GvX35n61r51FPQ8kYT7
         cZ/6thlLwdKnTtn5iYfANf1gnzvIJtk1FzvFd6DnlONAFfg99OeN1X9veG+nyyd2XAvG
         z5AmfPRmrqQRmmVPWKUhkK6P0rZ/3O/eEbBv/mIQiuvNl2fkNeHb3gdWDC4gNVnn0U+Z
         iA0g==
X-Gm-Message-State: ACrzQf3L1bORtkAbKJr7VmBcL4fJPhw8CuHYZt4nIsi58I0V/RmqJEgT
        KL12ghy6OTGaBccgG4ec0rVqdOk42EYz6HXyrrkp9//+Ay3XdLzXY0S009NyD29qMQ7BCJ09Upx
        lh86ykYQ5Zls1
X-Received: by 2002:a05:600c:4ed2:b0:3c6:c1ff:222 with SMTP id g18-20020a05600c4ed200b003c6c1ff0222mr24782648wmq.163.1666688882931;
        Tue, 25 Oct 2022 02:08:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7JQLW6+yNeS5/lhYm/6JYreInxHXtKVSSuIpJAQdDe+qm/rJDmcaNrsz6O3m0QEq/65dg+hA==
X-Received: by 2002:a05:600c:4ed2:b0:3c6:c1ff:222 with SMTP id g18-20020a05600c4ed200b003c6c1ff0222mr24782622wmq.163.1666688882655;
        Tue, 25 Oct 2022 02:08:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:4e00:3efc:1c60:bc60:f557? (p200300cbc70b4e003efc1c60bc60f557.dip0.t-ipconnect.de. [2003:cb:c70b:4e00:3efc:1c60:bc60:f557])
        by smtp.gmail.com with ESMTPSA id j9-20020adfe509000000b0023647841c5bsm1985818wrm.60.2022.10.25.02.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 02:08:02 -0700 (PDT)
Message-ID: <1b122f2f-a22c-e03b-bc9f-d27c74769aac@redhat.com>
Date:   Tue, 25 Oct 2022 11:08:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [v2 1/1] KVM: s390: VSIE: sort out virtual/physical address in
 pin_guest_page
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221025082039.117372-1-nrb@linux.ibm.com>
 <20221025082039.117372-2-nrb@linux.ibm.com>
 <27590367-1667-f21b-44b7-70b0301366ed@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <27590367-1667-f21b-44b7-70b0301366ed@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.22 10:34, Christian Borntraeger wrote:
> 
> 
> Am 25.10.22 um 10:20 schrieb Nico Boehr:
>> pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
>> page. This currently works, because virtual and physical addresses are
>> the same. Use page_to_phys() instead to resolve the virtual-real address
>> confusion.
>>
>> One caller of pin_guest_page() actually expected the hpa to be a hva, so
>> add the missing phys_to_virt() conversion here.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> 
> Looks good.
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> 
> Adding David CC.
> 
>> ---
>>    arch/s390/kvm/vsie.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 94138f8f0c1c..0e9d020d7093 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
>>    	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
>>    	if (is_error_page(page))
>>    		return -EINVAL;
>> -	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
>> +	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
>>    	return 0;
>>    }
>>    
>> @@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>>    		WARN_ON_ONCE(rc);
>>    		return 1;
>>    	}
>> -	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
>> +	vsie_page->scb_o = phys_to_virt(hpa);
>>    	return 0;

Right, we don't provide the scb to the SIE, but only read/write manually 
from it.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

