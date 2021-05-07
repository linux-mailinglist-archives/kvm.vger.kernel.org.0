Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52485376174
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhEGHvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:51:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235649AbhEGHvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MLkuRSzZa79r/jh4LUnA9iSS0QIvpenC9jHadUk+SM=;
        b=KmQug0c/y/RZGzx3anzZQMO7pZvk4fk/MJ73GFpDwnNliZEJIfm10IO//GQN6Lu46/Qlge
        ZNF0DTKK9WjpjDgtZe/MyiignMYCNjjPV3GlUcu9Pb+Wt8gg7YJdJBxXHh16HdyTieVFNa
        t2VwVvtgmO2MntiZs/tbhcEZ3qFg/oo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-DF6xv4MPNPiAWxmkyXONGg-1; Fri, 07 May 2021 03:50:35 -0400
X-MC-Unique: DF6xv4MPNPiAWxmkyXONGg-1
Received: by mail-wr1-f72.google.com with SMTP id j33-20020adf91240000b029010e4009d2ffso775250wrj.0
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/MLkuRSzZa79r/jh4LUnA9iSS0QIvpenC9jHadUk+SM=;
        b=SJE2wGfo+S5w80ZXzGTpH4FnYlEco8VacX7xeJqRV2GdzsI5uVm7hoTuPT+PlPjipi
         PB0J1EspSQjNt0708eRWIWEklTyQguLt0sBIpOsKe04s6uqA22jv4QtnUGEyeHqA+oxs
         ngo/IcHuGvIEYk5ZdRXkTydU7rKLhRcCzpjIPKUvbTn7pWHhrEw/Yln30VUlqL701CFT
         TRtqH398t6Ue6zIFqFcvb9BS1eU0m1G9nzbpsQkN3MH+HpgJPYzl10j/RftP+ob/9xAW
         EO02sDtimrDhn0mxqmuzLHSbd+DOIu93fl/qyvWfbtcZXkFIh0xo0ud0hNojc5xLqspw
         gePA==
X-Gm-Message-State: AOAM530j70jDSkwWYjIjfVSf5UHOvIDCN1NI7RunnuQzSt7R3XJN0OyD
        WkCUg/LGhX1TgPumvO406JNXrMepqv5FaeJhGYna6Rk2nmpZVCvX/dfSMqrENugHSGgV8N30PUH
        SOiTGsB/l2KgW
X-Received: by 2002:a1c:55ca:: with SMTP id j193mr19277931wmb.58.1620373832861;
        Fri, 07 May 2021 00:50:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxCnRshAj7tpewpbmOreXpvpcKBTwP6IHiJ0n2zPF8T3D2mFujI//9V2uu4vWU/BzHkuhqZg==
X-Received: by 2002:a1c:55ca:: with SMTP id j193mr19277904wmb.58.1620373832595;
        Fri, 07 May 2021 00:50:32 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id i11sm7271122wrp.56.2021.05.07.00.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:50:32 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap
 allocation
To:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-6-bgardon@google.com>
 <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <67c6af98-4e3b-fec5-9521-5288a10dce58@redhat.com>
Date:   Fri, 7 May 2021 09:50:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.05.21 01:44, Ben Gardon wrote:
> On Thu, May 6, 2021 at 11:43 AM Ben Gardon <bgardon@google.com> wrote:
>>
>> Add a field to control whether new memslots should have rmaps allocated
>> for them. As of this change, it's not safe to skip allocating rmaps, so
>> the field is always set to allocate rmaps. Future changes will make it
>> safe to operate without rmaps, using the TDP MMU. Then further changes
>> will allow the rmaps to be allocated lazily when needed for nested
>> oprtation.
>>
>> No functional change expected.
>>
>> Signed-off-by: Ben Gardon <bgardon@google.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  8 ++++++++
>>   arch/x86/kvm/mmu/mmu.c          |  2 ++
>>   arch/x86/kvm/x86.c              | 18 +++++++++++++-----
>>   3 files changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index ad22d4839bcc..00065f9bbc5e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1122,6 +1122,12 @@ struct kvm_arch {
>>           */
>>          spinlock_t tdp_mmu_pages_lock;
>>   #endif /* CONFIG_X86_64 */
>> +
>> +       /*
>> +        * If set, rmaps have been allocated for all memslots and should be
>> +        * allocated for any newly created or modified memslots.
>> +        */
>> +       bool memslots_have_rmaps;
>>   };
>>
>>   struct kvm_vm_stat {
>> @@ -1853,4 +1859,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>>
>>   int kvm_cpu_dirty_log_size(void);
>>
>> +inline bool kvm_memslots_have_rmaps(struct kvm *kvm);
> 
> Woops, this shouldn't be marked inline as it creates build problems
> for the next patch with some configs.

With that fixed

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

