Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C5C4F623D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiDFOw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 10:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiDFOwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 10:52:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD2A34E1D1A
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 04:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649244452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czYEG2s79Hy9lOqd5LLDvlb+7Wd1zq0rVYS2W8uDgNg=;
        b=ChZBS4TJYROx3tC2sSHgWqZDnA/22Tk5WS6NDRJ9+pEft9s6mQ8BK53B8heRvOz7gumppA
        U3cdL72ueh0LXR6v+nHFDYzOVe+I52c/2McVZGCkcJ+8DOvJaYhNbbUEudBcNlRJ1t4V9p
        wb3MG08/2x8PQQ3gJKzJzOPgebMRh+0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-OQkGSQoiNCO7jrwhzq1IYQ-1; Wed, 06 Apr 2022 07:27:31 -0400
X-MC-Unique: OQkGSQoiNCO7jrwhzq1IYQ-1
Received: by mail-ed1-f72.google.com with SMTP id w8-20020a50d788000000b00418e6810364so1043604edi.13
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 04:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=czYEG2s79Hy9lOqd5LLDvlb+7Wd1zq0rVYS2W8uDgNg=;
        b=Fjhgs8nbKT6cI0mwyGeX+UWwKMiy5s7O+/4dLv0b7XyayDkH4R4u1j2UBxIELdDv3c
         NBs3bgbOzfwxeQcvucx2NQTogGihUdBf1Htv+aa9+NGg/mFNXqy6Q5ZA/DBSqMbXeqfN
         UconwPtumxkPd4Zgh/OzbDTo1kbmN7+i5rW1uJSns4qZWf87y2iueTVpzqcmLoJPmKBy
         RDjfDI7LCxKJcTnCzAhX2p3ZnbBoWnOp2XVaq6ozE1+3B/NWISFY3jgBZr14U+7bIRth
         domEhUYUlfmPTzUQ0Tw2V1uvJE3OLtD1k4OwDwzN8n3mfqrd3FML64Etk6o8AkBUIK2b
         Rr/w==
X-Gm-Message-State: AOAM530mAynx83dGQqJCqaxDWY5kj85U4Bh0yH9VvmYJ+aQMIz5QqiB1
        a/V0EPKhrmAX+KaJ+FrFZFpWuSIYSEd8rtV3CM31ineXPOxQs0CmDq+MJTjSIzA/So9CjvPUpvw
        QrN8ZvRbbJp0H
X-Received: by 2002:a17:907:9812:b0:6da:aaaf:7713 with SMTP id ji18-20020a170907981200b006daaaaf7713mr7711217ejc.163.1649244450529;
        Wed, 06 Apr 2022 04:27:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8HAC0KpxmXUr9bLApoRMWeOYc6NTMP+nuUIR4pCaODB25UIn0SgREcn3NFeWM8Zc4/BXArg==
X-Received: by 2002:a17:907:9812:b0:6da:aaaf:7713 with SMTP id ji18-20020a170907981200b006daaaaf7713mr7711198ejc.163.1649244450308;
        Wed, 06 Apr 2022 04:27:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s4-20020a170906a18400b006db0a78bde8sm6521509ejy.87.2022.04.06.04.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 04:27:29 -0700 (PDT)
Message-ID: <9cfd5d2f-55e4-f8fc-701b-5917941e0269@redhat.com>
Date:   Wed, 6 Apr 2022 13:27:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
 <6e370d39-fcb6-c158-e5fb-690cd3802150@redhat.com>
 <36df723c-4794-69a8-8d12-ea371a7865df@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <36df723c-4794-69a8-8d12-ea371a7865df@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/22 04:06, Xiaoyao Li wrote:
>>
>> Indeed, it would be easier to use the existing cpuid data in struct 
>> kvm_vcpu, because right now there is no way to ensure that they are 
>> consistent.
>>
>> Why is KVM_SET_CPUID2 not enough?  Are there any modifications done by 
>> KVM that affect the measurement?
> 
> Then we get the situation that KVM_TDX_INIT_VM must be called after 1 
> vcpu is created. It seems illogical that it has chance to fail the VM 
> scope initialization after 1 vcpu is successfully created.

I see.  Yeah, it makes sense to have the CPUID in KVM_TDX_INIT_VM then.

Paolo

