Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D5F7A9E64
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjIUUBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjIUUAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:00:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1A2D65
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwNdHTnGAsOSkRghTMU2fettnfW7luTA9H+gP/0MCjk=;
        b=CChK+5FaXKh5bvakHTGoZfPbojhIRZ1xspa1hja+REALqPZyeDnOD4tc0hpmsnKS0RGNc1
        5Bv2zIhAxmTm48ag/vbvK3I1Xk7urHescnHTYKw6NvdUlld+ZoE1MNTd0R6P8a7x900N1V
        zJ1XYtDgOKuR4apD4Z7Lyht6Rt++rI8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-KUO2gghhPVCZrARcoMCnmg-1; Thu, 21 Sep 2023 04:59:42 -0400
X-MC-Unique: KUO2gghhPVCZrARcoMCnmg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32153a4533eso475952f8f.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695286781; x=1695891581;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OwNdHTnGAsOSkRghTMU2fettnfW7luTA9H+gP/0MCjk=;
        b=FsUp2zA3nk4GO2uI5O2LgKDc3gVTXT/wF97WxCpkA2VM22Emy+V0Qj4KJdLFLO9IF5
         xyTlc1lKnmnuVITAqSKEGSq4eyLCfuGwNJb8lWKG2zszTCU15kzrHjGjP+3O5yP0UOdI
         3mCiBmO8tXj6p3I5GQybkxAQaSIAQaLG6axnMDdK0KUrxunQcx2Ry/NpllIrt0DMAT3e
         /C7dPd67T/ZNBjcrXxnh5swK293p5IP/o3s9fykrHlGKHG5G+OBXPJnDaaCpor6RNi9d
         mP+U7hsL9mLzqfAa44FqDEooWul51/+A+X9RQOWcq/VSovjQKb1y+EG7M3shTGHnMuWn
         65TA==
X-Gm-Message-State: AOJu0YzcLw2tMI8v6ACRfdXmqwfXaDAIoOemupuIdYstNc8pAxJiT6nr
        9HHM19fiVUhTyFpUW/SX57qU/b/vVEWKfw/6uAre427+UUVcRACCBtpGS4x6oV5YQrABIxlW/By
        +fF+AYlxHNSTU
X-Received: by 2002:adf:fe8e:0:b0:319:f9d6:a769 with SMTP id l14-20020adffe8e000000b00319f9d6a769mr4482692wrr.45.1695286780863;
        Thu, 21 Sep 2023 01:59:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEziUe1J4+dVh5+sqL7Z79Q8p6L47JpR6xiZOAY7lmymJAZ32eWWEWvamD4E+nv0Lei4fu7pA==
X-Received: by 2002:adf:fe8e:0:b0:319:f9d6:a769 with SMTP id l14-20020adffe8e000000b00319f9d6a769mr4482661wrr.45.1695286780389;
        Thu, 21 Sep 2023 01:59:40 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id m12-20020a056000008c00b0031f3b04e7cdsm1143623wrx.109.2023.09.21.01.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:59:39 -0700 (PDT)
Message-ID: <822f80df-9bde-3d98-8fd2-44895cee08aa@redhat.com>
Date:   Thu, 21 Sep 2023 10:59:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 00/21] QEMU gmem implemention
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <fe9f3d19-df01-01e6-a253-f7fe5bdea41f@redhat.com>
 <a8cf6824-4228-8de5-0727-96ea6c5bad36@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <a8cf6824-4228-8de5-0727-96ea6c5bad36@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>>
>>> This version still leave some opens to be discussed:
>>> 1. whether we need "private" propery to be user-settable?
>>>
>>>      It seems unnecessary because vm-type is determined. If the VM is
>>>      confidential-guest, then the RAM of the guest must be able to be
>>>      mapped as private, i.e., have kvm gmem backend. So QEMU can
>>>      determine the value of "private" property automatiacally based on vm
>>>      type.
>>>
>>>      This also aligns with the board internal MemoryRegion that needs to
>>>      have kvm gmem backend, e.g., TDX requires OVMF to act as private
>>>      memory so bios memory region needs to have kvm gmem fd associated.
>>>      QEMU no doubt will do it internally automatically.
>>
>> Would it make sense to have some regions without "pivate" semantics?
>> Like NVDIMMs?
> 
> Of course it can have regions without "private" semantics.

I meant "RAM memory regions on such a special VM". Does it make sense to 
have !private there? I assume "for now, not".

>>>
>>> 2. hugepage support.
>>>
>>>      KVM gmem can be allocated from hugetlbfs. How does QEMU determine
>>>      when to allocate KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE. The
>>>      easiest solution is create KVM gmem with
>>> KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
>>>      only when memory backend is HostMemoryBackendFile of hugetlbfs.
>>
>> Good question.
>>
>> Probably "if the memory backend uses huge pages, also use huge pages for
>> the private gmem" makes sense.
>>
>> ... but it becomes a mess with preallocation ... which is what people
>> should actually be using with hugetlb. Andeventual double
>> memory-consumption ... but maybe that's all been taken care of already?
>>
>> Probably it's best to leave hugetlb support as future work and start
>> with something minimal.
>>
> 
> As Sean replied, I had some misunderstanding of
> KVM_GUEST_MEMFD_ALLOW_HUGEPAGE. If it's for THP, I think we can allow it
> for every gmem.

Right, just like we do a MADV_HUGEPAGE rather blindly on all memory.

-- 
Cheers,

David / dhildenb

