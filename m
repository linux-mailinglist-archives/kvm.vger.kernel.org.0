Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B070777DEE6
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 12:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbjHPKhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 06:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243567AbjHPJtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:49:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78376D1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 02:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692179348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OFZQ+OXvyBmwhhAQyMup8CjhNg5bEgDX0bYoSJ7Q74=;
        b=dC2SrTETPC+oOgeVRPeIzXwzqLIzbkq6QXNqm8toAMvB0hCjyLLDns/9sA1+6oPPqXgseA
        dN9Zx6jh/2PWD+JPjS3EifHdr2uQDyS4u2Ne9XJ/D6Zr79jvH06cJf+lCDFLJfjIhTKabe
        kmCn+PQdB86qBvEGZINY/ux5qwFJLJE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-VMwDrvtQMpSqgcfg-j-MuA-1; Wed, 16 Aug 2023 05:49:07 -0400
X-MC-Unique: VMwDrvtQMpSqgcfg-j-MuA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b9c548bc66so63189091fa.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 02:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692179346; x=1692784146;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0OFZQ+OXvyBmwhhAQyMup8CjhNg5bEgDX0bYoSJ7Q74=;
        b=MVt49aOeEgktAp5nVYT4IF6uKkBvn1y+En2QaIz6GZ2QFueBe/4X7j0A62fAKzoVoK
         FxA8fP8F9l1BjaBuvIY6k1mkAi7SSo612lpUvvt1AwcGKfFNLoJy9DGvZtSFE776Yjv+
         LbobqVG5a60ajZb36rA61gosnzkLhoXhXxrJw0eCXD9vIk4houB6kMYyWMntB9rxrhib
         v7MuQhF5mt+5D0f4QS0pbv60AU7i/xrAOG0NV1swaVeblR9IjmAdnfl5db7pLc/CPFX7
         yg5lis09gyFvOZQx9Zw2kXaVZBtL7zHMQ0yXEHNJRTFsLUztWyba4pC86Elij6kVO9aO
         B2/w==
X-Gm-Message-State: AOJu0YwQB3s5LWzjv76IOuZe06nJraTNVnAv7P/u10Rr3oJFeccoFXB4
        y9nsm2r5CMNMchquwoVTU4UaRxtHFNF+kAKo5pZsofedCQ/yxJ5suv15XmlER94FKwkrNRqGbd3
        4Y4Phd8VlCSlF
X-Received: by 2002:a2e:b285:0:b0:2b4:5cad:f246 with SMTP id 5-20020a2eb285000000b002b45cadf246mr1107446ljx.7.1692179345765;
        Wed, 16 Aug 2023 02:49:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAcVWmuJNfrQc1yoLpfalLlUny5Yyp2MgsmtGtaEdKirncc0n7pb9TlVylBlmWwHsFeOVlgw==
X-Received: by 2002:a2e:b285:0:b0:2b4:5cad:f246 with SMTP id 5-20020a2eb285000000b002b45cadf246mr1107428ljx.7.1692179345278;
        Wed, 16 Aug 2023 02:49:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id o13-20020a05600c378d00b003fe2de3f94fsm20525323wmr.12.2023.08.16.02.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 02:49:04 -0700 (PDT)
Message-ID: <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
Date:   Wed, 16 Aug 2023 11:49:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Mel Gorman <mgorman@techsingularity.net>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
In-Reply-To: <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.08.23 11:06, Yan Zhao wrote:
> On Wed, Aug 16, 2023 at 09:43:40AM +0200, David Hildenbrand wrote:
>> On 15.08.23 04:34, John Hubbard wrote:
>>> On 8/14/23 02:09, Yan Zhao wrote:
>>> ...
>>>>> hmm_range_fault()-based memory management in particular might benefit
>>>>> from having NUMA balancing disabled entirely for the memremap_pages()
>>>>> region, come to think of it. That seems relatively easy and clean at
>>>>> first glance anyway.
>>>>>
>>>>> For other regions (allocated by the device driver), a per-VMA flag
>>>>> seems about right: VM_NO_NUMA_BALANCING ?
>>>>>
>>>> Thanks a lot for those good suggestions!
>>>> For VMs, when could a per-VMA flag be set?
>>>> Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
>>>> after it's mapped into VFIO.
>>>> Then, should VFIO set this flag on after it maps a range?
>>>> Could this flag be unset after device hot-unplug?
>>>>
>>>
>>> I'm hoping someone who thinks about VMs and VFIO often can chime in.
>>
>> At least QEMU could just set it on the applicable VMAs (as said by Yuan Yao,
>> using madvise).
>>
>> BUT, I do wonder what value there would be for autonuma to still be active
> Currently MADV_* is up to 25
> 	#define MADV_COLLAPSE   25,
> while madvise behavior is of type "int". So it's ok.
> 
> But vma->vm_flags is of "unsigned long", so it's full at least on 32bit platform.

I remember there were discussions to increase it also for 32bit. If 
that's required, we might want to go down that path.

But do 32bit architectures even care about NUMA hinting? If not, just 
ignore them ...

> 
>> for the remainder of the hypervisor. If there is none, a prctl() would be
>> better.
> Add a new field in "struct vma_numab_state" in vma, and use prctl() to
> update this field?

Rather a global toggle per MM, no need to update individual VMAs -- if 
we go down that prctl() path.

No need to consume more memory for VMAs.

[...]

>> We already do have a mechanism in QEMU to get notified when longterm-pinning
>> in the kernel might happen (and, therefore, MADV_DONTNEED must not be used):
>> * ram_block_discard_disable()
>> * ram_block_uncoordinated_discard_disable()
> Looks this ram_block_discard allow/disallow state is global rather than per-VMA
> in QEMU.

Yes. Once you transition into "discard of any kind disabled", you can go 
over all guest memory VMAs (RAMBlock) and issue an madvise() for them. 
(or alternatively, do the prctl() once )

We'll also have to handle new guest memory being created afterwards, but 
that is easy.

Once we transition to "no discarding disabled", you can go over all 
guest memory VMAs (RAMBlock) and issue an madvise() for them again (or 
alternatively, do the prctl() once).

> So, do you mean that let kernel provide a per-VMA allow/disallow mechanism, and
> it's up to the user space to choose between per-VMA and complex way or
> global and simpler way?

QEMU could do either way. The question would be if a per-vma settings 
makes sense for NUMA hinting.

-- 
Cheers,

David / dhildenb

