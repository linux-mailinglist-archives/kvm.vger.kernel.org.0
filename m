Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95BA3B22B4
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFWVrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWVrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624484734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VFhSgomzeVbLhtKZrv0JDwPRrK50qS0eUPXJlcvMMI=;
        b=K8pIN5VWgQxr4DD2wnv1uQ/mfvYg/vdaBAJ2ZcN2QpU8x0LYfr0ywiidrkeuELEZx7BF8T
        OmMqYb0KiBAPnXKVM9UV6ZvaKQM+N81PKbrTZrdG+aWjqdzGg18VCiA+425tfTm4cIgnL2
        DcXH/NvR+T5VutaV5oZcNSPFgoXsx3k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-uPbhiHPiPdK-3q_KFpzXMA-1; Wed, 23 Jun 2021 17:45:33 -0400
X-MC-Unique: uPbhiHPiPdK-3q_KFpzXMA-1
Received: by mail-wm1-f69.google.com with SMTP id t187-20020a1cc3c40000b02901e46e4d52c0so1029800wmf.6
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8VFhSgomzeVbLhtKZrv0JDwPRrK50qS0eUPXJlcvMMI=;
        b=tuMQJJdg3hFxCMdnJAv3A4SJ+kaRizU/MfkKW3YMKXcOdyyoZ0W5RywcNI078ld/yN
         +/cBBCSmvszMAz0UReusc8pnyPunshHJbKTLj1My5m9za6jCQcwoNLqhV5pBOGaB7gpu
         A0O9n3QwiNHqZBlFXzpo1GQeodYBPjpuG6BFvR8IoUujscIfbFohKR/E1Dynk7iPrGDT
         /a7sv1I2gSggjMvj42Ayl5b5c5h8t/v8T/P7eAZpXIrE4haQkC9aB5KnOZmd+Elmlx9B
         nqp8gD0z4g+gJqiIKQwpycpexTusphZwgU4T2KADqptbUSWXf8F0b60u/fcp3erv0DO7
         DI0g==
X-Gm-Message-State: AOAM531g48CdRTo7owtYoEMNKDleL+L2aqHmqCv3+J5MVLqPmgqrOjsa
        2t6JR7KvFhD0H4SBw05spxzL0Y3hP/OuIwNfLAyEYPxCvZk7ZGh2N0zHwPCpz5Qu+x1PmPANZh6
        nYEEP0DkzjwdA
X-Received: by 2002:adf:e38c:: with SMTP id e12mr266438wrm.404.1624484732197;
        Wed, 23 Jun 2021 14:45:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7QeUfOhA6Glym8/pNOgX8KdbWWlcMsZF1ybxmwmhOWFvZLPcbBiLW7eMXz978W2pJyIwdbg==
X-Received: by 2002:adf:e38c:: with SMTP id e12mr266421wrm.404.1624484732043;
        Wed, 23 Jun 2021 14:45:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm7154187wmj.23.2021.06.23.14.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:45:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Speed up set_memory_region_test
To:     Zenghui Yu <yuzenghui@huawei.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        linux-kernel@vger.kernel.org, wanghaibin.wang@huawei.com
References: <20210426130121.758229-1-vkuznets@redhat.com>
 <91a2d145-fd3c-6e8d-6478-60f62dff07fe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3dc9bd69-f38a-daed-4ac3-84b280ef5901@redhat.com>
Date:   Wed, 23 Jun 2021 23:45:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <91a2d145-fd3c-6e8d-6478-60f62dff07fe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 11:03, Zenghui Yu wrote:
> On 2021/4/26 21:01, Vitaly Kuznetsov wrote:
>> After commit 4fc096a99e01 ("KVM: Raise the maximum number of user 
>> memslots")
>> set_memory_region_test may take too long, reports are that the default
>> timeout value we have (120s) may not be enough even on a physical host.
>>
>> Speed things up a bit by throwing away vm_userspace_mem_region_add() 
>> usage
>> from test_add_max_memory_regions(), we don't really need to do the 
>> majority
>> of the stuff it does for the sake of this test.
>>
>> On my AMD EPYC 7401P, # time ./set_memory_region_test
>> pre-patch:
>>  Testing KVM_RUN with zero added memory regions
>>  Allowed number of memory slots: 32764
>>  Adding slots 0..32763, each memory region with 2048K size
>>  Testing MOVE of in-use region, 10 loops
>>  Testing DELETE of in-use region, 10 loops
>>
>>  real    0m44.917s
>>  user    0m7.416s
>>  sys    0m34.601s
>>
>> post-patch:
>>  Testing KVM_RUN with zero added memory regions
>>  Allowed number of memory slots: 32764
>>  Adding slots 0..32763, each memory region with 2048K size
>>  Testing MOVE of in-use region, 10 loops
>>  Testing DELETE of in-use region, 10 loops
>>
>>  real    0m20.714s
>>  user    0m0.109s
>>  sys    0m18.359s
>>
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I've seen the failure on my arm64 server, # ./set_memory_region_test
> 
> Allowed number of memory slots: 32767
> Adding slots 0..32766, each memory region with 2048K size
> ==== Test Assertion Failure ====
>    set_memory_region_test.c:391: ret == 0
>    pid=42696 tid=42696 errno=22 - Invalid argument
>       1    0x00000000004015a7: test_add_max_memory_regions at 
> set_memory_region_test.c:389
>       2     (inlined by) main at set_memory_region_test.c:426
>       3    0x0000ffffb7c63bdf: ?? ??:0
>       4    0x00000000004016db: _start at :?
>    KVM_SET_USER_MEMORY_REGION IOCTL failed,
>    rc: -1 errno: 22 slot: 2624
> 
>> +    mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,
> 
> The problem is that max_mem_slots is declared as uint32_t, the result
> of (MEM_REGION_SIZE * max_mem_slots) is unexpectedly truncated to be
> 0xffe00000.
> 
>> +           PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> +    TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
>> +    mem_aligned = (void *)(((size_t) mem + alignment - 1) & 
>> ~(alignment - 1));
>> +
>>      for (slot = 0; slot < max_mem_slots; slot++) {
>> -        vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
>> -                        guest_addr, slot, mem_reg_npages,
>> -                        0);
>> -        guest_addr += MEM_REGION_SIZE;
>> +        ret = test_memory_region_add(vm, mem_aligned +
>> +                         ((uint64_t)slot * MEM_REGION_SIZE),
> 
> These unmapped VAs got caught by access_ok() checker in
> __kvm_set_memory_region() as they happen to go beyond the task's
> address space on arm64. Casting max_mem_slots to size_t in both
> mmap() and munmap() fixes the issue for me.

Can you provide a patch for both?

Paolo

