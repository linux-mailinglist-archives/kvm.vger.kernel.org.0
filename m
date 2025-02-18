Return-Path: <kvm+bounces-38419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D958A3996D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 11:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 211B6188772D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C73235361;
	Tue, 18 Feb 2025 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRkd/s/d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5DC2309B5
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739875588; cv=none; b=Yx2xmIIAZIgsNoQsQupSLgUMCGqBLQonEVEu5pqdAzQN7o9fRXzJjFAs6UVGLhMB7SAN90e/MZ8ozcZ7jHj2vCRDX50akEBD92mINpvsfgCF4/3MxDqnLbzm4RAxLEbzO8sQ79cYVxh0/mF/h6jE9OuThEtrCCmtAwk9oWLgTAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739875588; c=relaxed/simple;
	bh=sHyePjWYdf+xMW3nyVaNaNus1kfnqSxtu1yySs4wEH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uI8xs6o+7RxOGEJnhl71Y9g3MwBuwGwl1+xxino/2fqdNe/XoFQV3nnmAwUhI+L4y9707IQ6PuWJmV+S9cvYwcH3baLrF3q7jCleA7oCt3dsfqcXWJpxSBCdn2LOJqHQt27cyRg8AW/Ji3wmoTzDJsNOom2r9ZQDudc+Q+bXr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRkd/s/d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739875585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A959PzUSW5eOj4GPBGmEAK66kpWU43NeHWzF7rtp1Gs=;
	b=MRkd/s/dQONJNuMuGsbrnMXddur7rCUMvXVCSLQ5Kn0oc4Pu/+B9mCXQFw2U7qJtoDwx3J
	SVgv5mGr6xdO8uUGKQpflURxrAWpFcmXtHKcrvboP5N1OcUJCfuknZeXhEH/VJfzZa7X0k
	EPR6blFhiKVLjAPtL0FM4rp5eG2Qirg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-u6w3DMX2PfuKIUp_PcQKMg-1; Tue, 18 Feb 2025 05:46:24 -0500
X-MC-Unique: u6w3DMX2PfuKIUp_PcQKMg-1
X-Mimecast-MFC-AGG-ID: u6w3DMX2PfuKIUp_PcQKMg_1739875583
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43947a0919aso42660085e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 02:46:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739875583; x=1740480383;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A959PzUSW5eOj4GPBGmEAK66kpWU43NeHWzF7rtp1Gs=;
        b=Gaf6KZi2Pg5EPr87sc9zILbJakQzekxDnvJPRyiu5PNR08XtzDlR+XFhjxeuKVy9gX
         mjNjKLp15mcJr0O/SCFxtV5ie9Io5wNx9d+uvjfG013bAtC+oOVMAlhYaSHsrtMiF9eK
         8FJUWen+eEQ0vbycBiIyOJtwFCGa3Db3FohunlyzdQ2t+jXlM/1zNWr5AxihrS4OXOpa
         j+/l6Svu5ucsFafhr6y58GMvN5NZxHVh+i3Nb9RsZY8jW6l0flDbo1CxQNrqheIEBqUF
         Qf26ABH89uuXTVpcWq5HXAWqzFv2B3sss4bJhv3/n4LawuwYdH20RR0T9zJvv8mFzhVs
         SBRg==
X-Forwarded-Encrypted: i=1; AJvYcCUckE3i51ixPNveQbUWhY8B7tg01CT/8CCJb6C7rJA7EZtCYGi9EKzJGqPjCsyHmb0UMs8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqdkfoaCGmgcLN5nzjCok3F0wZHEBc0X6gPHfnZs0Quh/9YyKe
	ibK7c4irg9HersxlKu3m0FpCEv6Cfz6H+plx/70l9BLeJfnETOlRRWFcV+HPPdhwPya91ErF9pK
	qAdJ9RBLSEc4zmy56VLSEzdUXrBkKgkKW5jem+yUwne4zxDTDxw==
X-Gm-Gg: ASbGnctjJiq1yO1XlVgukoHq5PF3r9ZdFrxUcqwPfe0iwx53xYIQhBT8t4VEs3cvfoM
	4o5/wk/YxZGjn4Bp6XeyFLZBI7L5FS4SrLdQ1OMx3xxuknC7E65BjOyG3ikO5iCI7FmV1haXvZb
	tKrbv9uS61zwkHVH1bp10KeFG/7idrpqKuNtnf8vvJGDAKu32UkJdqbSL0/05LGhAETqtD+D8hX
	ILHbAuE0HHTv1fyErtTCtBM8js43DgH5P8Oi1ALZys13sPGcct1qmZvSPd4f3SLPuV4La+lYxRs
	/ccXSidS3bqMCjj4erBYWg3B40MDKydxnM0x3CLjA5rb6SQUdp4TYiF7S59XEpMTlktXSS7duft
	xGDLOd9C4xeaC9+cq5LcEI5MuMo4sxnDV
X-Received: by 2002:a05:600c:4fce:b0:439:3d5c:8c19 with SMTP id 5b1f17b1804b1-4396e717094mr111636965e9.24.1739875582850;
        Tue, 18 Feb 2025 02:46:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1lG5mvmi5WhUs2+rkljpLbWUkz7DNrDKjsDhndt8X1Ma6VZxi9Bg1HMZYm3jRH0V2pJSmMQ==
X-Received: by 2002:a05:600c:4fce:b0:439:3d5c:8c19 with SMTP id 5b1f17b1804b1-4396e717094mr111636515e9.24.1739875582280;
        Tue, 18 Feb 2025 02:46:22 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af? (p200300cbc70dfb00d3ed5f441b2d12af.dip0.t-ipconnect.de. [2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43959d3d5f3sm178381635e9.0.2025.02.18.02.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 02:46:21 -0800 (PST)
Message-ID: <c33e4daf-0eb6-4e8c-8df7-be33c2807c6d@redhat.com>
Date: Tue, 18 Feb 2025 11:46:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-3-chenyi.qiang@intel.com>
 <10029ca9-a239-4d3f-9999-e1059bc17d85@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <10029ca9-a239-4d3f-9999-e1059bc17d85@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.02.25 10:19, Alexey Kardashevskiy wrote:
> 
> 
> On 17/2/25 19:18, Chenyi Qiang wrote:
>> Modify memory_region_set_ram_discard_manager() to return false if a
>> RamDiscardManager is already set in the MemoryRegion. The caller must
>> handle this failure, such as having virtio-mem undo its actions and fail
>> the realize() process. Opportunistically move the call earlier to avoid
>> complex error handling.
>>
>> This change is beneficial when introducing a new RamDiscardManager
>> instance besides virtio-mem. After
>> ram_block_coordinated_discard_require(true) unlocks all
>> RamDiscardManager instances, only one instance is allowed to be set for
>> a MemoryRegion at present.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v2:
>>       - newly added.
>> ---
>>    hw/virtio/virtio-mem.c | 30 +++++++++++++++++-------------
>>    include/exec/memory.h  |  6 +++---
>>    system/memory.c        | 11 ++++++++---
>>    3 files changed, 28 insertions(+), 19 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 21f16e4912..ef818a2cdf 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -1074,6 +1074,18 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>                            vmem->block_size;
>>        vmem->bitmap = bitmap_new(vmem->bitmap_size);
>>    
>> +    /*
>> +     * Set ourselves as RamDiscardManager before the plug handler maps the
>> +     * memory region and exposes it via an address space.
>> +     */
>> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> +                                              RAM_DISCARD_MANAGER(vmem))) {
>> +        error_setg(errp, "Failed to set RamDiscardManager");
>> +        g_free(vmem->bitmap);
>> +        ram_block_coordinated_discard_require(false);
>> +        return;
>> +    }
> 
> Looks like this can move before vmem->bitmap is allocated (or even
> before ram_block_coordinated_discard_require(true)?). Then you can drop
> g_free() and avoid having a stale pointer in vmem->bitmap (not that it
> matters here though).
> 
>> +
>>        virtio_init(vdev, VIRTIO_ID_MEM, sizeof(struct virtio_mem_config));
>>        vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
>>    vmem->bitmap
>> @@ -1124,13 +1136,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>        vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>>        vmem->system_reset->vmem = vmem;
>>        qemu_register_resettable(obj);
>> -
>> -    /*
>> -     * Set ourselves as RamDiscardManager before the plug handler maps the
>> -     * memory region and exposes it via an address space.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> -                                          RAM_DISCARD_MANAGER(vmem));
>>    }
>>    
>>    static void virtio_mem_device_unrealize(DeviceState *dev)
>> @@ -1138,12 +1143,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>>        VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>>        VirtIOMEM *vmem = VIRTIO_MEM(dev);
>>    
>> -    /*
>> -     * The unplug handler unmapped the memory region, it cannot be
>> -     * found via an address space anymore. Unset ourselves.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>> -
>>        qemu_unregister_resettable(OBJECT(vmem->system_reset));
>>        object_unref(OBJECT(vmem->system_reset));
>>    
>> @@ -1155,6 +1154,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>>        host_memory_backend_set_mapped(vmem->memdev, false);
>>        virtio_del_queue(vdev, 0);
>>        virtio_cleanup(vdev);
>> +    /*
>> +     * The unplug handler unmapped the memory region, it cannot be
>> +     * found via an address space anymore. Unset ourselves.
>> +     */
>> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>>        g_free(vmem->bitmap);
>>        ram_block_coordinated_discard_require(false);
>>    }
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 3bebc43d59..390477b588 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -2487,13 +2487,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>>     *
>>     * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>>     * that does not cover RAM, or a #MemoryRegion that already has a
>> - * #RamDiscardManager assigned.
>> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>>     *
>>     * @mr: the #MemoryRegion
>>     * @rdm: #RamDiscardManager to set
>>     */
>> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm);
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm);
>>    
>>    /**
>>     * memory_region_find: translate an address/size relative to a
>> diff --git a/system/memory.c b/system/memory.c
>> index b17b5538ff..297a3dbcd4 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2115,12 +2115,17 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>>        return mr->rdm;
>>    }
>>    
>> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm)
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm)
>>    {
>>        g_assert(memory_region_is_ram(mr));
>> -    g_assert(!rdm || !mr->rdm);
>> +    if (mr->rdm && rdm != NULL) {
> 
> Drop "!= NULL".
> 
>> +        return -1;
> 
> -EBUSY?
> 
>> +    }
>> +
>> +    /* !rdm || !mr->rdm */
> 
> See, like here - no "!= NULL" :) (and the comment is useless). Thanks,
> 
> 
>>        mr->rdm = rdm;
>> +    return 0;
>>    }
>>    
>>    uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
> 


Agreed to all, with that it LGTM, thanks!

-- 
Cheers,

David / dhildenb


