Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1EE7A8753
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbjITOlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjITOlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:41:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16391FE3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 07:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlq3VkBDAxx+UjHYCFzjOoTvzQT81SMPJV0LfgL/qPA=;
        b=Q0jzNGOiVU3NtukRcaVV+dBV+RtNPCs6CbpSc5HALH7HrbAktis7bGfiKPjIkTx+2uRU02
        snNWcr/SFB1XomVb2TEkrwt41bbY8zm8uefEnBOKwblK9ZrAqampc8mWjH/sHBpbRNX+gS
        j/dgc9K09ztEdQSPjsLT5+Q6oSwMSOI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-ZEDgWSxCPyyFbHTrs33R4g-1; Wed, 20 Sep 2023 10:37:40 -0400
X-MC-Unique: ZEDgWSxCPyyFbHTrs33R4g-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-321677c0c89so1327123f8f.0
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 07:37:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695220659; x=1695825459;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zlq3VkBDAxx+UjHYCFzjOoTvzQT81SMPJV0LfgL/qPA=;
        b=ikH5hwwxqh1W5pApoJIt2hqfMpaU7pdpyDPmHtxS+FbU6q52LNZZenn89tI9fvYuo9
         hifVkByGvZ0oDkr3QdM4I4Zu42JuEF4RHM+KyT498C52eJQj1IsyzOvxGABF6IRJazKN
         wuaDMlDnpO1pXEF8s6+fPI/GD1rO4u1l13GMQGNXLmALif74JRO/BO0Slbo+CuXV4hXN
         4/f5rcT9cSyB1zJmEJdwTG6fpJnunsvK+G3IP7dUxIuUwSO8Y9q4aZ3B1uB8oT2ajHP9
         26ur6ienF6dPY0eETf2d4ZfmgiGFyMcF7PiPTSOutVJ4yBS7gqTVWSeWHHmJOyRCianc
         EKog==
X-Gm-Message-State: AOJu0YxA4UeSZb4TxAOVXi8h1I8vwS5r5CKHRezmSzmxyRRS9EuBXoPx
        AnXjxHAXJSkGM2zBpv0ZA0+IDr1YrP7LACUPdHpS8wDUQmk+Eh8O8qAUfGhIS+vcZ6D/lLH0HDG
        qXTaiLO1CMnv5
X-Received: by 2002:adf:d0ca:0:b0:317:5d3d:c9df with SMTP id z10-20020adfd0ca000000b003175d3dc9dfmr2502563wrh.18.1695220659491;
        Wed, 20 Sep 2023 07:37:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFf+51aOLzrkPF34PeABVEpjaMEBK7fHn4+QjePH2TZCT8NykDAtUFDJp9i3G5so9YKLNfbEA==
X-Received: by 2002:adf:d0ca:0:b0:317:5d3d:c9df with SMTP id z10-20020adfd0ca000000b003175d3dc9dfmr2502535wrh.18.1695220659038;
        Wed, 20 Sep 2023 07:37:39 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:8600:dad5:13bb:38a9:3010? (p200300cbc70b8600dad513bb38a93010.dip0.t-ipconnect.de. [2003:cb:c70b:8600:dad5:13bb:38a9:3010])
        by smtp.gmail.com with ESMTPSA id v7-20020a5d6b07000000b0031f3780ce60sm18555247wrw.7.2023.09.20.07.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 07:37:38 -0700 (PDT)
Message-ID: <091a40cb-ec26-dd79-aa26-191dc59c03e6@redhat.com>
Date:   Wed, 20 Sep 2023 16:37:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 03/21] HostMem: Add private property and associate
 it with RAM_KVM_GMEM
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-4-xiaoyao.li@intel.com> <8734zazeag.fsf@pond.sub.org>
 <d0e7e2f8-581d-e708-5ddd-947f2fe9676a@intel.com>
 <878r91nvy4.fsf@pond.sub.org>
 <da598ffc-fa47-3c25-64ea-27ea90d712aa@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <da598ffc-fa47-3c25-64ea-27ea90d712aa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.09.23 16:35, Xiaoyao Li wrote:
> On 9/20/2023 3:30 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> On 9/19/2023 5:46 PM, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>
>>>>> Add a new property "private" to memory backends. When it's set to true,
>>>>> it indicates the RAMblock of the backend also requires kvm gmem.
>>>> Can you add a brief explanation why you need the property?
>>>
>>> It provides a mechanism for user to specify whether the memory can serve as private memory (need request kvm gmem).
>>
>> Yes, but why would a user want such memory?
>>
> 
> Because KVM demands it for confidential guest, e.g., TDX guest. KVM
> demands that the mem slot needs to have KVM_MEM_PRIVATE set and has
> valid gmem associated if the guest accesses it as private memory.

I think as long as there is no demand to have a TDX guest with this 
property be set to "off", then just don't add it.

With a TDX VM, it will can be implicitly active. If we ever have to 
disable it for selective memory backends, we can add the property and 
have something like on/off/auto. For now it would be "auto".

-- 
Cheers,

David / dhildenb

