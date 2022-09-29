Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC685EF856
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbiI2PHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiI2PHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:07:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0F91166E7
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664464041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGdnN2Y2CEduI2udMkp9UJyXzBOPpQyA7MhhZbQEIv8=;
        b=WeCtUOBLXDBZTVzjC/3hSTNR2wcWAEjXndcEs1Ke0o4ieUlP4S3FWszuzek9rwE4l9xeKk
        2yQpYvuVHB8nDfvqOf4qDWULk375e2TRwLdaLJl8IHD87mKPxnp/Va37TrfZpErDYOGpL9
        E7gwx/oMuX2NAyniy7yEK9SwzbXkWO8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-IZrwEpzlOPip4jKGBhUwAQ-1; Thu, 29 Sep 2022 11:07:10 -0400
X-MC-Unique: IZrwEpzlOPip4jKGBhUwAQ-1
Received: by mail-ed1-f70.google.com with SMTP id y9-20020a056402270900b00451dfbbc9b2so1493286edd.12
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OGdnN2Y2CEduI2udMkp9UJyXzBOPpQyA7MhhZbQEIv8=;
        b=6T1ZywGx+t4nhp6w7GGC8N6QlhRHMoUio8WTuBnFOdv0qNEJ3W3+mQoC4MVKOjxdHA
         8SSpS/gq3/5feKhLTrIosedPyVsdNa0j39cIsHe5SbT8B5x6b1mqpx7tjf2VeMNezNKR
         rOCmX3k2koGhEzvq6Q8dkJWGFQe7gEhQBEG2S61AiRkUo6H8NqmCmrxBnuIpUheZdXZH
         qxaRNG+4/3TVd6kLgT6elJzbW9LjodBg3Pq4Cj0AQiAidmiQlsHAos+WnWs0Fgc9dlaz
         WAILQqfVNpECWobQNhNdrY4lYONJN8PcEFWDvKlgsMdHa50GKBqi+mlAw610mZAVWHrS
         y8lQ==
X-Gm-Message-State: ACrzQf1H13EgBQy/ddgmBSH4X7X1WnlYpYmdvpvFC5xwC4s8UdIV6216
        hqeYyeES9TA4K1DBNw/+nO7vLWbl1o1glFHEY3fi5z1Ms5D7PkEjmg5+z7HKbX7Vnyj98dThBIp
        sg48908Kyz3Pl
X-Received: by 2002:a05:6402:50ca:b0:451:a711:1389 with SMTP id h10-20020a05640250ca00b00451a7111389mr3687650edb.239.1664464029034;
        Thu, 29 Sep 2022 08:07:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ISURrSfTuSflltACTcSX5Z6C3i1L6pHsD0+urKfUK+e9R4Ev1pnbTSa08jsymair1cZluhw==
X-Received: by 2002:a05:6402:50ca:b0:451:a711:1389 with SMTP id h10-20020a05640250ca00b00451a7111389mr3687628edb.239.1664464028760;
        Thu, 29 Sep 2022 08:07:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id ch15-20020a0564021bcf00b004585a21df62sm507478edb.0.2022.09.29.08.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 08:07:08 -0700 (PDT)
Message-ID: <205b4d01-db86-6662-7906-24a8ca765e4f@redhat.com>
Date:   Thu, 29 Sep 2022 17:07:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220926165112.603078-1-pbonzini@redhat.com>
 <YzMt24/14n1BVdnI@google.com>
 <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
 <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
 <YzRycXDnWgMDgbD7@google.com>
 <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
 <YzSKhUEg3L1eMKOR@google.com>
 <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
 <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
In-Reply-To: <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 15:52, Maxim Levitsky wrote:
> On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
>> On 9/28/22 19:55, Sean Christopherson wrote:
>>>> As far as my opinion goes I do volunteer to test this code more often,
>>>> and I do not want to see the 32 bit KVM support be removed*yet*.
>>>
>>> Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
>>> coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
>>> BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
>>
>> Yeah, maybe EXPERT is better but I'm not sure of the equivalent test
>> coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but
>> what's wrong with booting an older guest?
> 
> From my point of view, using the same kernel source for host and the guest
> is easier because you know that both kernels behave the same.

It is certainly easier, but it is less correct.  You don't cover 
anything that KVM doesn't use.

> About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
> one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
> these days compiles a 32 bit kernel, knows what they are doing.
> 
> I personally would wait few more releases when there is a pressing reason to remove
> this support.
> 
> AFAIK, it is not really possible to remove most of the legacy direct mmu
> because shadowing mmu still can use it (I think Sean told me that once).

Yeah, it won't let us remove a lot of code but there are several logic 
cleanups that become possible if the TDP case can just assume the TDP 
MMU is there.  For example, there is no reason to have a cpu_role (as 
opposed to an mmu_page_role for the root) if you are building HPA->GPA 
page tables.

(Which reminds me that toggling CR0.WP is still a hog with the TDP MMU).

Paolo

