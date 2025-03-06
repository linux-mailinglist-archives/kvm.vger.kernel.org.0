Return-Path: <kvm+bounces-40286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0ACA55A5A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120EB176606
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0CC27CCC2;
	Thu,  6 Mar 2025 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="enXTYzIF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1994B27CB36
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301986; cv=none; b=guvsKNqGRt1Zyo8g7jpXMxGGd+k7L4MZyLnAdw3QL/9gDAMxIgQkHt/lvOHsUXwCbNrv/xDRnJn3uSr5ZNmEQxl6A4HW40bt6quTbThl2k6lzqr3BBiMf4+DO/rRctMryNoVeAiE1vtYWTsGQzN2rB/w6RcU0SG1MiNe6lyDC5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301986; c=relaxed/simple;
	bh=iT+WEJl6geel+Ij1katPwOGdQsgYwsOZ9ZhtvgZXO7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKplWzPbuL3m4IQvEov8/hKSre1vvbq+i7dmHRSXQGAQRRRqSUqdQlUMs3kmMQe7rqKpGaSF7mZTEKJ9fG+nOSHzp+T8z6+dToBXTBoCWTMyuq3tGSOxuCr8JnIjv97G8b4i3zmQFj0Juwott/D+Xg+wO/dVluuo/22aGI4X9UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=enXTYzIF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-224191d92e4so17759095ad.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741301983; x=1741906783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p8KBefIIXMpte5eJ7QvBmXbTJoAln2iE1nz6QXgw3LI=;
        b=enXTYzIFgYpmULzsRjbqDjAloDCEwBrA6ZGBnZTdgeyqQNZEn7w9bYA62YVQsreAGD
         ImqmUS3fIqG8Az0FZ9ZmXzRtRu6RPAmCx4GPRCv/WVBIW3LEk34YcjyrQffzlb19Y2GQ
         AYcXpn7CXKzxtLth6Z7zIRhBxlx2jS0nVkO7cvKmcskB8vcDWOs+8rEuRtqZglQbqwDT
         sW8XOTsKoMQiYV1R2S7oHvee1hEeIJVYkWDb3g4llgs8qfWKIpP2d6VM3FOEqbXWmB9T
         r2oyxeJs1jdFtqF37J8B/rC/7ewV/a0YgDyE7ZfYldw+QUUZkCxodv/Gqp7d9MbMvVq2
         J1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301983; x=1741906783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p8KBefIIXMpte5eJ7QvBmXbTJoAln2iE1nz6QXgw3LI=;
        b=bBnPxAer4AW9qkh7D68s0KQHWET+jHmrMM0z3zckzOBuC2/otNSL2wWAUUcJavCrHT
         CfsvRJt8mDIldl+QikCqrvXmDL0rRncbW6LcBA8Fcn+l9Pxd4g6n+9/tDF2XrZxQhvvc
         PxoPzXL+It9JmDfZ+6o3iDVMTAstcUhFJ/jPngPKqJLeb0QmqVBbyOJHe/3Njp3icdSb
         eRXrlEyyX23tRP0BZQYj/UkzrqfPZNIkF0xlAhXMWz5Lwpv0qpBsVXEq0VNHcZYUsaAv
         Ppmq2Wo/dN8hX1Ra4uJno1XODu+KK9igV456yEpVRKv7/QcKd/KEa5d5afUVe7QIlV05
         pslg==
X-Gm-Message-State: AOJu0Yw8hnrZazR3xag+ZLQ0N5MuT0TIGa/5eBcNq1EieWaUQP3mcgTX
	iKjn0HwATHOQGu5Nws8CLgETNd64FJCcXwE04eVheuDcJtdBu1u/nMjz3wTZ1SM=
X-Gm-Gg: ASbGnctXtBf4mM1ZBU7bhb1xtaBHOytfFvZLkqgio5wLGGXiu1chGqdDD+7PwND2iHP
	uyDq3ppgcAKNebX3OrNnUZG2OxjFnOQmKuMdhaeA5mBid83wRYfccAuWn71HXHhh3dLozx27GnQ
	CinxKPrhyoNcdJ+IiwYPcFaCYX7Re9wd/mGQepcuZYw+PM+Zvv99/t8h7PKR+0L8sCZK+f6CEab
	/HoW6LYHoBd0xxFj/8mtvFSyo49UM9klDi6QGzjxZQERIj37ZqrcCZ4KoZn5nceWzZYP3ldhm79
	ZEbZrCwt7fpnKYyDLDi8aiYN2TmLqhQz6BtJPm+bwkEZmHylI1BuZW0Qbg==
X-Google-Smtp-Source: AGHT+IEKZihSeTW0S6Q19SWxLJku2nuf9r5zJwrbdNHyLjau5lx6gDE+lq9l1J0pmUoDTr96SWb/KQ==
X-Received: by 2002:a17:902:da84:b0:224:10a2:cae7 with SMTP id d9443c01a7336-22428c057cemr16855885ad.40.1741301983257;
        Thu, 06 Mar 2025 14:59:43 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410aa5cdbsm17719985ad.230.2025.03.06.14.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 14:59:42 -0800 (PST)
Message-ID: <9ee1b0aa-27e3-47f9-8276-1158bfa5ad06@linaro.org>
Date: Thu, 6 Mar 2025 14:59:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] hw/hyperv/vmbus: common compilation unit
Content-Language: en-US
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kvm@vger.kernel.org, philmd@linaro.org, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 richard.henderson@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-4-pierrick.bouvier@linaro.org>
 <adadeb12-9eb7-4338-828e-62e77034b1dd@maciej.szmigiero.name>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <adadeb12-9eb7-4338-828e-62e77034b1dd@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Maciej,

we are currently working toward building a single QEMU binary able to 
emulate all architectures, and one prerequisite is to remove duplication 
of compilation units (some are duplicated per target now, because of 
compile time defines).

So the work here is to replace those compile time defines with runtime 
functions instead, so the same code can be used for various architectures.

Is it more clear for you?

On 3/6/25 12:29, Maciej S. Szmigiero wrote:
> On 6.03.2025 07:41, Pierrick Bouvier wrote:
>> Replace TARGET_PAGE.* by runtime calls.
> 
> Seems like this patch subject/title is not aligned
> well with its content, or a least incomplete.
> 
> Also, could you provide more detailed information
> why TARGET_PAGE_SIZE is getting replaced by
> qemu_target_page_size() please?
> 
> I don't see such information in the cover letter either.
> 
> Thanks,
> Maciej
>    
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    hw/hyperv/vmbus.c     | 50 +++++++++++++++++++++----------------------
>>    hw/hyperv/meson.build |  2 +-
>>    2 files changed, 26 insertions(+), 26 deletions(-)
>>
>> diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
>> index 12a7dc43128..109ac319caf 100644
>> --- a/hw/hyperv/vmbus.c
>> +++ b/hw/hyperv/vmbus.c
>> @@ -18,7 +18,7 @@
>>    #include "hw/hyperv/vmbus.h"
>>    #include "hw/hyperv/vmbus-bridge.h"
>>    #include "hw/sysbus.h"
>> -#include "cpu.h"
>> +#include "exec/target_page.h"
>>    #include "trace.h"
>>    
>>    enum {
>> @@ -309,7 +309,7 @@ void vmbus_put_gpadl(VMBusGpadl *gpadl)
>>    
>>    uint32_t vmbus_gpadl_len(VMBusGpadl *gpadl)
>>    {
>> -    return gpadl->num_gfns * TARGET_PAGE_SIZE;
>> +    return gpadl->num_gfns * qemu_target_page_size();
>>    }
>>    
>>    static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
>> @@ -323,14 +323,14 @@ static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
>>    
>>    static inline void gpadl_iter_cache_unmap(GpadlIter *iter)
>>    {
>> -    uint32_t map_start_in_page = (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
>> -    uint32_t io_end_in_page = ((iter->last_off - 1) & ~TARGET_PAGE_MASK) + 1;
>> +    uint32_t map_start_in_page = (uintptr_t)iter->map & ~qemu_target_page_mask();
>> +    uint32_t io_end_in_page = ((iter->last_off - 1) & ~qemu_target_page_mask()) + 1;
>>    
>>        /* mapping is only done to do non-zero amount of i/o */
>>        assert(iter->last_off > 0);
>>        assert(map_start_in_page < io_end_in_page);
>>    
>> -    dma_memory_unmap(iter->as, iter->map, TARGET_PAGE_SIZE - map_start_in_page,
>> +    dma_memory_unmap(iter->as, iter->map, qemu_target_page_size() - map_start_in_page,
>>                         iter->dir, io_end_in_page - map_start_in_page);
>>    }
>>    
>> @@ -348,17 +348,17 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>>        assert(iter->active);
>>    
>>        while (len) {
>> -        uint32_t off_in_page = iter->off & ~TARGET_PAGE_MASK;
>> -        uint32_t pgleft = TARGET_PAGE_SIZE - off_in_page;
>> +        uint32_t off_in_page = iter->off & ~qemu_target_page_mask();
>> +        uint32_t pgleft = qemu_target_page_size() - off_in_page;
>>            uint32_t cplen = MIN(pgleft, len);
>>            void *p;
>>    
>>            /* try to reuse the cached mapping */
>>            if (iter->map) {
>>                uint32_t map_start_in_page =
>> -                (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
>> -            uint32_t off_base = iter->off & ~TARGET_PAGE_MASK;
>> -            uint32_t mapped_base = (iter->last_off - 1) & ~TARGET_PAGE_MASK;
>> +                (uintptr_t)iter->map & ~qemu_target_page_mask();
>> +            uint32_t off_base = iter->off & ~qemu_target_page_mask();
>> +            uint32_t mapped_base = (iter->last_off - 1) & ~qemu_target_page_mask();
>>                if (off_base != mapped_base || off_in_page < map_start_in_page) {
>>                    gpadl_iter_cache_unmap(iter);
>>                    iter->map = NULL;
>> @@ -368,10 +368,10 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>>            if (!iter->map) {
>>                dma_addr_t maddr;
>>                dma_addr_t mlen = pgleft;
>> -            uint32_t idx = iter->off >> TARGET_PAGE_BITS;
>> +            uint32_t idx = iter->off >> qemu_target_page_bits();
>>                assert(idx < iter->gpadl->num_gfns);
>>    
>> -            maddr = (iter->gpadl->gfns[idx] << TARGET_PAGE_BITS) | off_in_page;
>> +            maddr = (iter->gpadl->gfns[idx] << qemu_target_page_bits()) | off_in_page;
>>    
>>                iter->map = dma_memory_map(iter->as, maddr, &mlen, iter->dir,
>>                                           MEMTXATTRS_UNSPECIFIED);
>> @@ -382,7 +382,7 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>>                }
>>            }
>>    
>> -        p = (void *)(uintptr_t)(((uintptr_t)iter->map & TARGET_PAGE_MASK) |
>> +        p = (void *)(uintptr_t)(((uintptr_t)iter->map & qemu_target_page_mask()) |
>>                    off_in_page);
>>            if (iter->dir == DMA_DIRECTION_FROM_DEVICE) {
>>                memcpy(p, buf, cplen);
>> @@ -591,9 +591,9 @@ static void ringbuf_init_common(VMBusRingBufCommon *ringbuf, VMBusGpadl *gpadl,
>>                                    uint32_t begin, uint32_t end)
>>    {
>>        ringbuf->as = as;
>> -    ringbuf->rb_addr = gpadl->gfns[begin] << TARGET_PAGE_BITS;
>> -    ringbuf->base = (begin + 1) << TARGET_PAGE_BITS;
>> -    ringbuf->len = (end - begin - 1) << TARGET_PAGE_BITS;
>> +    ringbuf->rb_addr = gpadl->gfns[begin] << qemu_target_page_bits();
>> +    ringbuf->base = (begin + 1) << qemu_target_page_bits();
>> +    ringbuf->len = (end - begin - 1) << qemu_target_page_bits();
>>        gpadl_iter_init(&ringbuf->iter, gpadl, as, dir);
>>    }
>>    
>> @@ -734,7 +734,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
>>        unsigned long *int_map, mask;
>>        unsigned idx;
>>        hwaddr addr = chan->vmbus->int_page_gpa;
>> -    hwaddr len = TARGET_PAGE_SIZE / 2, dirty = 0;
>> +    hwaddr len = qemu_target_page_size() / 2, dirty = 0;
>>    
>>        trace_vmbus_channel_notify_guest(chan->id);
>>    
>> @@ -743,7 +743,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
>>        }
>>    
>>        int_map = cpu_physical_memory_map(addr, &len, 1);
>> -    if (len != TARGET_PAGE_SIZE / 2) {
>> +    if (len != qemu_target_page_size() / 2) {
>>            res = -ENXIO;
>>            goto unmap;
>>        }
>> @@ -1038,14 +1038,14 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
>>            }
>>            len -= sizeof(range);
>>    
>> -        if (range.byte_offset & TARGET_PAGE_MASK) {
>> +        if (range.byte_offset & qemu_target_page_mask()) {
>>                goto eio;
>>            }
>>    
>>            for (; range.byte_count; range.byte_offset = 0) {
>>                uint64_t paddr;
>>                uint32_t plen = MIN(range.byte_count,
>> -                                TARGET_PAGE_SIZE - range.byte_offset);
>> +                                qemu_target_page_size() - range.byte_offset);
>>    
>>                if (len < sizeof(uint64_t)) {
>>                    goto eio;
>> @@ -1055,7 +1055,7 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
>>                    goto err;
>>                }
>>                len -= sizeof(uint64_t);
>> -            paddr <<= TARGET_PAGE_BITS;
>> +            paddr <<= qemu_target_page_bits();
>>                paddr |= range.byte_offset;
>>                range.byte_count -= plen;
>>    
>> @@ -1804,7 +1804,7 @@ static void handle_gpadl_header(VMBus *vmbus, vmbus_message_gpadl_header *msg,
>>         * anything else and simplify things greatly.
>>         */
>>        if (msg->rangecount != 1 || msg->range[0].byte_offset ||
>> -        (msg->range[0].byte_count != (num_gfns << TARGET_PAGE_BITS))) {
>> +        (msg->range[0].byte_count != (num_gfns << qemu_target_page_bits()))) {
>>            return;
>>        }
>>    
>> @@ -2240,10 +2240,10 @@ static void vmbus_signal_event(EventNotifier *e)
>>            return;
>>        }
>>    
>> -    addr = vmbus->int_page_gpa + TARGET_PAGE_SIZE / 2;
>> -    len = TARGET_PAGE_SIZE / 2;
>> +    addr = vmbus->int_page_gpa + qemu_target_page_size() / 2;
>> +    len = qemu_target_page_size() / 2;
>>        int_map = cpu_physical_memory_map(addr, &len, 1);
>> -    if (len != TARGET_PAGE_SIZE / 2) {
>> +    if (len != qemu_target_page_size() / 2) {
>>            goto unmap;
>>        }
>>    
>> diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
>> index f4aa0a5ada9..c855fdcf04c 100644
>> --- a/hw/hyperv/meson.build
>> +++ b/hw/hyperv/meson.build
>> @@ -1,6 +1,6 @@
>>    specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
>>    specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
>> -specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
>> +system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
>>    specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
>>    specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
>>    system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
> 


