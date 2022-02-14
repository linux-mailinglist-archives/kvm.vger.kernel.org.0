Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774CD4B564A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356410AbiBNQcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiBNQcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:32:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D0D4B85D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644856329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zbjp4EoPUVr+XpeuhFNTpQtAmtutDQ9QIqPvVEgDCA=;
        b=L8jOTMlYoHQV/OgKgOudVri02temdw3ibHTJ6VKZBsF5YGmp/bow1tsUnZghOelhilkjBU
        KU6KGQc27fzaGsjLmhpBxMxsZNEZp8A2d3JScXCEykHo84yWrXOK3ulCNSMiwJWGIIXeyn
        nHe2akgIj5qCZCS+ZANLQpa7hmfYjGg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-9SLfs1omNBC9Vh1jpj07Gg-1; Mon, 14 Feb 2022 11:32:07 -0500
X-MC-Unique: 9SLfs1omNBC9Vh1jpj07Gg-1
Received: by mail-wm1-f70.google.com with SMTP id i188-20020a1c3bc5000000b0037bb9f6feeeso3572710wma.5
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=2zbjp4EoPUVr+XpeuhFNTpQtAmtutDQ9QIqPvVEgDCA=;
        b=WmPUHo+s99NsSAxGUPuki0Hfrl/xowREPCJ9J8z7R73KOUZRfGn/SAd4tQu8Om8BPS
         /xKbwRw0nL7JG0oFrXr5Y/Pqerd++sUdEhnp/1jd2LMalgNRe9aD/YDXMksNNOBC9h0b
         1vM6tWB02Yq9IBndAtze0E6mnIHmtxDiU4KUlLdAkHi+uECtqqKGI+TTkwDx5bTaQ3N6
         4VDkN8onOQUm7kbKnSGo94L8uUgQQzxB5ddiwjXbd/vV+hVG43c7wlqgtYxP13/C+5aG
         SGrS9N8E0wDwGBqPGQYx/iEch6DvrKUOct03Qu3Nni086NAMGcQAZB+geHUPdTFzSMpk
         DGzw==
X-Gm-Message-State: AOAM532hCf6Br5LYPQGuIb4GPM4rt2vWs9Up95IWRPaJ9Lj7ATwLvdua
        gmBis61Qz/l2AU4Ud2SwuY1c2JDZ0Jyg4mVLP1MGbV3U3G3/MW/q6u0cg3rzSuiBy/ZCUgAVMfW
        olnXeulbMsvbd
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr133682wmg.3.1644856325995;
        Mon, 14 Feb 2022 08:32:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNqQekQHEpWPSjnIk8qAR9HJzoLsSqG3czYQnv4XY0+vcQA9+siecLZVMV8XQ6tFZn6++xYg==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr133663wmg.3.1644856325742;
        Mon, 14 Feb 2022 08:32:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:5400:d8a3:8885:3275:4529? (p200300cbc7075400d8a3888532754529.dip0.t-ipconnect.de. [2003:cb:c707:5400:d8a3:8885:3275:4529])
        by smtp.gmail.com with ESMTPSA id c5sm22809753wrq.102.2022.02.14.08.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 08:32:05 -0800 (PST)
Message-ID: <2743ef0f-c73c-5a55-067b-6068c23334f3@redhat.com>
Date:   Mon, 14 Feb 2022 17:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Ani Sinha <ani@anisinha.ca>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <alpine.DEB.2.22.394.2202141048390.13781@anisinha-lenovo>
 <20220214133634.248d7de0@redhat.com>
 <b9771171-8d28-b46b-4474-687a8fed0abd@redhat.com>
 <20220214165515.226a1955@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: 9 TiB vm memory creation
In-Reply-To: <20220214165515.226a1955@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>>
>>> With KVM enabled it bails out with:
>>>    qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGION failed, slot=1, start=0x100000000, size=0x8ff40000000: Invalid argument
>>>
>>> all of that on a host with 32G of RAM/no swap.
>>>
>>>   
>>
>> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>>
>> ~8 TiB (7,999999)
> 
> so essentially that's the our max for initial RAM
> (ignoring initial RAM slots before 4Gb)
> 
> Are you aware of any attempts to make it larger?

Not really, I think for now only s390x had applicable machines where
you'd have that much memory on a single NUMA node.

> 
> But can we use extra pc-dimm devices for additional memory (with 8TiB limit)
> as that will use another memslot?

I remember that was the workaround for now for some extremely large VMs
where you'd want a single NUMA node or a lot of memory for a single NUMA
node.

> 
> 
>>
>> In QEMU, we have
>>
>> static hwaddr kvm_max_slot_size = ~0;
>>
>> And only s390x sets
>>
>> kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
>>
>> with
>>
>> #define KVM_SLOT_MAX_BYTES (4UL * TiB)
> in QEMU default value is:
>   static hwaddr kvm_max_slot_size = ~0
> it is kernel side that's failing

... and kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES) works around the
kernel limitation for s390x in user space.

I feel like the right thing would be to look into increasing the limit
in the kernel, and bail out if the kernel doesn't support it. Would
require a new kernel for starting gigantic VMs with a single large
memory backend, but then, it's a new use case.

-- 
Thanks,

David / dhildenb

