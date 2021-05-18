Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B82B387D4B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345891AbhERQYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343956AbhERQYU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621354982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5RJYPLqAYSF7PeEx+nR3RgNKQgQ5XhiMT8l2SDsZYU=;
        b=UjqXKH1yg402OXjry0WXkBV3CcjfR/LA4l/4YS71WykwjVqZbZfOVrqfGcRD8aAk6nV5Yf
        7VJRN3TiLSb1wXdk+xhaFFvTTF++teixgS85LffHC5rxD5ei4EhJoYv+M1etJ+KBCP2tb0
        +xocm+8pAY9DOp7TVaGm28tU2/otywA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-RweIdInJNd2HvXtsKa8f3g-1; Tue, 18 May 2021 12:22:44 -0400
X-MC-Unique: RweIdInJNd2HvXtsKa8f3g-1
Received: by mail-wr1-f69.google.com with SMTP id r12-20020adfc10c0000b029010d83323601so5769428wre.22
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 09:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=f5RJYPLqAYSF7PeEx+nR3RgNKQgQ5XhiMT8l2SDsZYU=;
        b=t2UB7dt3A1f9am0QZbQlaEj8liqT/gl6MyWQWQ3l7apfuyH8lW87ArD2519sVZTsyl
         1GtQ6xB76llWW+6pHpqeoyfh0Yp0HEXLy52CMRsChVZ3chBS+HFOuvpchpSx7D4556EE
         Hznmcxy/Cy/7wsDr6AR+kmDJCkQYVHyaPMNJl14JxWB2Dpv8Ly7AmaEpmIZi1JG60oGy
         opIHFZ6I3MaqJJD325mDm818UdmnmtEBHXVvIDamExQhH3KiBmJ1nlvkAbjMaJ3behmk
         ZO7rZNFL8gUcTl/CB9cZKDqv1jXCjvCEeGVhlT3YsmGdXuu+VRdNGT6d3AQYtr4b0lMn
         EnAw==
X-Gm-Message-State: AOAM533eroqu724+HskJ6DWcGzWv7XB8Qy2zYx2ZZ3nVLSyyN2WUVg6O
        ZMl/U6pVbKX0HMqQ50n1HoA/ZhDOzL1O5GC4fMskv93btbE/OkC7J3t6IG6xnxYom1m4iqWJ/B7
        msGr+KO24fsxo
X-Received: by 2002:a05:6000:1368:: with SMTP id q8mr8169216wrz.342.1621354963285;
        Tue, 18 May 2021 09:22:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJXTyLbbe+j8G/6H/hwqiNFjexjmfC5GXKyFTrPfr1NMUTkplW/NkFtTn2Aiu3BABVg2Cz+Q==
X-Received: by 2002:a05:6000:1368:: with SMTP id q8mr8169190wrz.342.1621354963029;
        Tue, 18 May 2021 09:22:43 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64fd.dip0.t-ipconnect.de. [91.12.100.253])
        by smtp.gmail.com with ESMTPSA id f7sm17857348wmq.30.2021.05.18.09.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 09:22:42 -0700 (PDT)
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210518170537.58b32ffe.cohuck@redhat.com> <20210518173624.13d043e3@ibm-vm>
 <20210518180411.4abf837d.cohuck@redhat.com> <20210518181922.52d04c61@ibm-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <a38192d5-0868-8e07-0a34-c1615e1997fc@redhat.com>
Date:   Tue, 18 May 2021 18:22:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518181922.52d04c61@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.05.21 18:19, Claudio Imbrenda wrote:
> On Tue, 18 May 2021 18:04:11 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Tue, 18 May 2021 17:36:24 +0200
>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>
>>> On Tue, 18 May 2021 17:05:37 +0200
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>    
>>>> On Mon, 17 May 2021 22:07:47 +0200
>>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>
>>>>> This means that the same address space can have memory
>>>>> belonging to more than one protected guest, although only one
>>>>> will be running, the others will in fact not even have any
>>>>> CPUs.
>>>>
>>>> Are those set-aside-but-not-yet-cleaned-up pages still possibly
>>>> accessible in any way? I would assume that they only belong to
>>>> the
>>>
>>> in case of reboot: yes, they are still in the address space of the
>>> guest, and can be swapped if needed
>>>    
>>>> 'zombie' guests, and any new or rebooted guest is a new entity
>>>> that needs to get new pages?
>>>
>>> the rebooted guest (normal or secure) will re-use the same pages of
>>> the old guest (before or after cleanup, which is the reason of
>>> patches 3 and 4)
>>
>> Took a look at those patches, makes sense.
>>
>>>
>>> the KVM guest is not affected in case of reboot, so the userspace
>>> address space is not touched.
>>
>> 'guest' is a bit ambiguous here -- do you mean the vm here, and the
>> actual guest above?
>>
> 
> yes this is tricky, because there is the guest OS, which terminates or
> reboots, then there is the "secure configuration" entity, handled by the
> Ultravisor, and then the KVM VM
> 
> when a secure guest reboots, the "secure configuration" is dismantled
> (in this case, in a deferred way), and the KVM VM (and its memory) is
> not directly affected
> 
> what happened before was that the secure configuration was dismantled
> synchronously, and then re-created.
> 
> now instead, a new secure configuration is created using the same KVM
> VM (and thus the same mm), before the old secure configuration has been
> completely dismantled. hence the same KVM VM can have multiple secure
> configurations associated, sharing the same address space.
> 
> of course, only the newest one is actually running, the other ones are
> "zombies", without CPUs.
> 

Can a guest trigger a DoS?

-- 
Thanks,

David / dhildenb

