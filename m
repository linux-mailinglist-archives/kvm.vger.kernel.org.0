Return-Path: <kvm+bounces-29866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF729B36DB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD40B1F21A2B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE371DEFE3;
	Mon, 28 Oct 2024 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2Vh8dY6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAFF186E27
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133738; cv=none; b=Mi0skVxkajtC1luR69Of7ErhEClgN3AGYD6b+en7vYk6/nqFREutKl31pTY8o5fZygDK8YrfQ1kN9N+vAE+cMnpgRfEEj4NQuunGfjdNx9aOMKd1ck3BFU2fSYJ4ElGF0R1uYqEURpv/AowSOpVlfkVLUauX+3qkSPrBoSoWB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133738; c=relaxed/simple;
	bh=gtDU3Zk/9KeyeKM9oi//Mw9PoYgZ2wDzl+5iv5WDJ58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+RYLqmnoh08iQzyxaLoVAekjeB8gAXbXKHjHbBLasXw/e+WLZzTIvaYFjmx2cOqo9pd82Fye1t6TPtng22Bg24k3xOVmlDsgA44+ylS7tkArypddlrISY/eQCFsUCxjLMh8e4Md2+jSNWtFunPFYee/MNVVGu/JJcC+n6y6e/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y2Vh8dY6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730133735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T0UAX23+37ZRrHea98bsMhwQ80Lb1MZgJknkx7BqqeA=;
	b=Y2Vh8dY691G7jmQKyjtRF0hXJ5JBtqX5IfTfkwIef4/eVT12MsR3uCXAnxnPDcZI/ionv9
	M9xMfXcZtwLvuv8ZN78QQE3s2RzzNukkTT+ArGgKhxiU8+7FBzMX97yJVRp/sQJimX1cp7
	pVOgiwDSDqUBEpyaY2NxYOoRp4WY6yw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-OGNcBieINGuCpUkI5dahJg-1; Mon, 28 Oct 2024 12:42:13 -0400
X-MC-Unique: OGNcBieINGuCpUkI5dahJg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315e8e9b1cso24996175e9.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730133732; x=1730738532;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T0UAX23+37ZRrHea98bsMhwQ80Lb1MZgJknkx7BqqeA=;
        b=GSUdCz1fNkYhqg5zNfq8X9UIKu+GZnpQRWDANXFXrjm+FyXBhf+yonsANdsakd9sVe
         aKyPtYfbc4XJlOE2YKS8mI8BtjHJYzcv6QP92zkUpb3d7eej2YmC2qIYgRrXj/3iNz7b
         Ziu/42nSsQ7NO5ogvloLZdliuO/2X1eyCV9/8wrYWy7tOzonswgnmtyOI4nFypzrZA7w
         nzn/ayHsOpTiw8t8ZOgMYkrbJfhep/TP7muSHgHSpJx6GNI8OLyjEj4w+H3ESrf5i29/
         Af8F5IWFFgs3Ltt/4qZR4DLJzBjYUvNAZP35aqZwctJNj885mWpm0KOL2L6CUffqIoY+
         eCBg==
X-Forwarded-Encrypted: i=1; AJvYcCXN2RUOGwL8tliVUMaYr7jOTG/CW71/n3gDeUkPDm5itxR5GyFYmIE6taV237JT0kvVbQo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp43z7RTLCSToQ/MidhPDVxpBxNEVSrXZmg4EqEOcBviENkacu
	nv6Lq/UKueN0yux7YNAymU+MRfsg4TP+/ZG3y8lkORDpnxTh4pFjY83QqY5wQ/zLk4/hQmvEfDj
	XX7Mvp5a/pPQ1rLES/3BB41jVGsYB9LzoZJ31wEKtHL+xRC42jA==
X-Received: by 2002:a05:600c:450f:b0:431:7ccd:ff8a with SMTP id 5b1f17b1804b1-431b2f326c8mr2055605e9.14.1730133731985;
        Mon, 28 Oct 2024 09:42:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGBesCrSu0q4i2SZfeVQIYSHgqs3Pn9F5uTcLGHdCRZm3VZfc0mDe/6YB2p/qzRtKR5IbJeA==
X-Received: by 2002:a05:600c:450f:b0:431:7ccd:ff8a with SMTP id 5b1f17b1804b1-431b2f326c8mr2055315e9.14.1730133731552;
        Mon, 28 Oct 2024 09:42:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c722:3c00:70fc:90a8:2c65:79b4? (p200300cbc7223c0070fc90a82c6579b4.dip0.t-ipconnect.de. [2003:cb:c722:3c00:70fc:90a8:2c65:79b4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43193573551sm115340055e9.6.2024.10.28.09.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 09:42:11 -0700 (PDT)
Message-ID: <9a49fc5f-bf9e-4e72-bd3e-13975d4913bd@redhat.com>
Date: Mon, 28 Oct 2024 17:42:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-3-william.roche@oracle.com>
 <a0fda9e7-d55b-455b-aeaa-27162b6cdc65@redhat.com>
 <9b17600d-4473-4bb6-841f-00f93d86f720@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <9b17600d-4473-4bb6-841f-00f93d86f720@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.10.24 01:27, William Roche wrote:
> On 10/23/24 09:28, David Hildenbrand wrote:
> 
>> On 22.10.24 23:35, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>>
>>> Add the page size information to the hwpoison_page_list elements.
>>> As the kernel doesn't always report the actual poisoned page size,
>>> we adjust this size from the backend real page size.
>>> We take into account the recorded page size to adjust the size
>>> and location of the memory hole.
>>>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>   accel/kvm/kvm-all.c       | 14 ++++++++++----
>>>   include/exec/cpu-common.h |  1 +
>>>   include/sysemu/kvm.h      |  3 ++-
>>>   include/sysemu/kvm_int.h  |  3 ++-
>>>   system/physmem.c          | 20 ++++++++++++++++++++
>>>   target/arm/kvm.c          |  8 ++++++--
>>>   target/i386/kvm/kvm.c     |  8 ++++++--
>>>   7 files changed, 47 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 2adc4d9c24..40117eefa7 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, 
>>> unsigned int extension)
>>>    */
>>>   typedef struct HWPoisonPage {
>>>       ram_addr_t ram_addr;
>>> +    size_t     page_size;
>>>       QLIST_ENTRY(HWPoisonPage) list;
>>>   } HWPoisonPage;
>>>   @@ -1278,15 +1279,18 @@ static void kvm_unpoison_all(void *param)
>>>         QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>>           QLIST_REMOVE(page, list);
>>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>>> +        qemu_ram_remap(page->ram_addr, page->page_size);
>>
>> Can't we just use the page size from the RAMBlock in qemu_ram_remap? 
>> There we lookup the RAMBlock, and all pages in a RAMBlock have the 
>> same size.
> 
> 
> Yes, we could use the page size from the RAMBlock in qemu_ram_remap() 
> that is called when the VM is resetting. I think that knowing the 
> information about the size of poisoned chunk of memory when the poison 
> is created is useful to give a trace of what is going on, before seeing 
> maybe other pages being reported as poisoned. That's the 4th patch goal 
> to give an information as soon as we get it.
> It also helps to filter the new errors reported and only create an entry 
> in the hwpoison_page_list for new large pages.
> Now we could delay the page size retrieval until we are resetting and 
> present the information (post mortem). I do think that having the 
> information earlier is better in this case.

If it is not required for this patch, then please move the other stuff 
to patch #4.

Here, we really only have to discard a large page, which we can derive 
from the QEMU RAMBlock page size.

> 
> 
>>
>> I'll note that qemu_ram_remap() is rather stupid and optimized only 
>> for private memory (not shmem etc).
>>
>> mmap(MAP_FIXED|MAP_SHARED, fd) will give you the same poisoned page 
>> from the pagecache; you'd have to punch a hole instead.
>>
>> It might be better to use ram_block_discard_range() in the long run. 
>> Memory preallocation + page pinning is tricky, but we could simply 
>> bail out in these cases (preallocation failing, ram discard being 
>> disabled).
> 
> 
> I see that ram_block_discard_range() adds more control before discarding 
> the RAM region and can also call madvise() in addition to the fallocate 
> punch hole for standard sized memory pages. Now as the range is supposed 
> to be recreated, I'm not convinced that these madvise calls are necessary.

They are the proper replacement for the mmap(MAP_FIXED) + fallocate.

That function handles all cases of properly discarding guest RAM.

> 
> But we can also notice that this function will report the following 
> warning in all cases of not shared file backends:
> "ram_block_discard_range: Discarding RAM in private file mappings is 
> possibly dangerous, because it will modify the underlying file and will 
> affect other users of the file"

Yes, because it's a clear warning sign that something weird is 
happening. You might be throwing away data that some other process might 
be relying on.

How are you making QEMU consume hugetlbs?

We could suppress these warnings, but let's first see how you are able 
to trigger it.

> Which means that hugetlbfs configurations do see this new cryptic 
> warning message on reboot if it is impacted by a memory poisoning.
> So I would prefer to leave the fallocate call in the qemu_ram_remap() 
> function. Or would you prefer to enhance ram_block_discard_range()code 
> to avoid the message in a reset situation (when called from qemu_ram_remap)?

Please try reusing the mechanism to discard guest RAM instead of 
open-coding this. We still have to use mmap(MAP_FIXED) as a backup, but 
otherwise this function should mostly do+check what you need.

(-warnings we might want to report differently / suppress)

If you want, I can start a quick prototype of what it could look like 
when using ram_block_discard_range() + ram_block_discard_is_disabled() + 
fallback to existing mmap(MAP_FIXED).

> 
> 
>>
>> qemu_ram_remap() might be problematic with page pinning (vfio) as is 
>> in any way :(
> 
> I agree. If qemu_ram_remap() fails, Qemu is ended either abort() or 
> exit(1). Do you say that memory pinning could be detected by 
> ram_block_discard_range() or maybe mmap call for the impacted region and 
> make one of them fail ? This would be an additional reason to call 
> ram_block_discard_range() from qemu_ram_remap().   Is it what you are 
> suggesting ?

ram_block_discard_is_disabled() might be the right test. If discarding 
is disabled, then rebooting might create an inconsistency with 
e.g.,vfio, resulting in the issues we know from memory ballooning where 
the state vfio sees will be different from the state the guest kernel 
sees. It's tricky ... and we much rather quit the VM early instead of 
corrupting data later :/

-- 
Cheers,

David / dhildenb


