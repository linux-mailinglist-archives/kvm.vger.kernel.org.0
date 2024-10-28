Return-Path: <kvm+bounces-29871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEB89B373F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C2642859ED
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60281DF252;
	Mon, 28 Oct 2024 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHabOiGP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C21A13AD11
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730134897; cv=none; b=lktRRz6wkieD64SqxFHxqsACO94ZIZAgIZMa+WkUV/O1oRJPOYIPf9i682QtC4yUkryNQFLJUEZ1QzsHtv9kjR2apwKtwQGRwEgt7j/dGH/+8EZj676dN+m+uDhxotV6OtA9ov5cpAm1oJewKO6ZlD+/XOcPRAbkd54w9x4ZQao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730134897; c=relaxed/simple;
	bh=Pi6FvMLZ+C2fSeEMtyS0gXQL3BBNEqvp1D1t6yA1ACM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uIC5Ao2uQaRbHdm/jY0g3RjqK/YMiolK7B4ouh10Hw8jCfWn+PJNgfZstY3uuK6we0AdWfk7N8EMJRR9s5LVbVBxYH+9ZiAkuRMIovYYiVPx/2wQwfGrkhA4ky7qcW9+MHbHoQ7rwS9ZPn8ds6Um9ECDsXzAA2H59p82ZW6C8P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHabOiGP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730134894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=knyVjinu2Mws85bdLGklnnsg+EFi+WIdDCzwpn7Dbgw=;
	b=gHabOiGPjD2gl7wESY6xqpEofhAUiCvcXf+bhiIy+T/aBIC2P/iYUJFtDE+V0on2h/QMHG
	ZvG1RJUqiE5eNvBRrLfik3WINZNV7aURCU9dAPbtD2mPyAprTEUhU/xhB4tJTtE43Rtrdd
	eEG0zxkcE0c9D9ctP5Od6yy01uK2d94=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-p9-NltxUNqeQvXkLDi87NA-1; Mon, 28 Oct 2024 13:01:33 -0400
X-MC-Unique: p9-NltxUNqeQvXkLDi87NA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d49887a2cso2371405f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 10:01:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730134892; x=1730739692;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=knyVjinu2Mws85bdLGklnnsg+EFi+WIdDCzwpn7Dbgw=;
        b=wHsABCL9Tug18XD74cxDPFoYi3Gn5E2R46uLhYTs1fF0Ma/fRGH2dRgk1YQ6tzuVfl
         ki9AVeBGrS9cgAFzSdJrw4jJvtVrhFUAZojbaiGLDRzOgus/14LymZZ/Le7aSn1KPoa2
         QxJPH+8G00CfJBYEpj3qBprBYicr9zCBFajQxuKaYBPKLz9K/xsN+xIsNm9VAJXPniV6
         lGEHgnuUUhtsJ+4vupOipx2O5mKaEe1hH1zlcNy60GghQxfSkqi80KYhUtKb5ADhJ+Qz
         LHuGtQ0oBkTU6e42abKC44e0exfg0q3NyhCvw3iQ16S+dvpnOXgv7ACfhhJvJDgmSSEz
         TvOw==
X-Forwarded-Encrypted: i=1; AJvYcCVqDMQxfbFAhO0RMUBVZ6YpMDfGzhPWPpvwkdzvy8BInKplFsxvyRiJXqDWlZA1ICJBALA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOpW1dd7LoX+qtquOsdKzgpaKz5ZdvphNA36rwpgi6pmWbu2zf
	d1YOriwvjKOG8scf2m2QxJwwtoHTm7y/lTHIT3DrmTvjK1sqTfTKSfS/i2pTuHUWO6KVzA4pMPm
	xx+xM4MNeyVv20cZ+cMNnRwYX1EqW9eoKDpddYtZTRP84I0QrfA==
X-Received: by 2002:adf:fc46:0:b0:37d:3b31:7a9d with SMTP id ffacd0b85a97d-3808142425cmr219966f8f.23.1730134891674;
        Mon, 28 Oct 2024 10:01:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR3gv8jkidQj+gd787+D8ARLSgdIXqgR3pT51uiNdGbuO/X8+aC6K5vGCFsapMMHJg+R+DcA==
X-Received: by 2002:adf:fc46:0:b0:37d:3b31:7a9d with SMTP id ffacd0b85a97d-3808142425cmr219916f8f.23.1730134891180;
        Mon, 28 Oct 2024 10:01:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c722:3c00:70fc:90a8:2c65:79b4? (p200300cbc7223c0070fc90a82c6579b4.dip0.t-ipconnect.de. [2003:cb:c722:3c00:70fc:90a8:2c65:79b4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b712bfsm10008386f8f.79.2024.10.28.10.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 10:01:30 -0700 (PDT)
Message-ID: <6cc00e04-6e38-4970-9d6b-52b56ee20a64@redhat.com>
Date: Mon, 28 Oct 2024 18:01:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] system/physmem: Largepage punch hole before reset
 of memory pages
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-4-william.roche@oracle.com>
 <0cda6b34-d62c-49c7-b30c-33f171985817@redhat.com>
 <e9f8e404-50db-4e0f-a5e1-749acad49325@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e9f8e404-50db-4e0f-a5e1-749acad49325@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.10.24 01:27, William Roche wrote:
> On 10/23/24 09:30, David Hildenbrand wrote:
> 
>> On 22.10.24 23:35, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>>
>>> When the VM reboots, a memory reset is performed calling
>>> qemu_ram_remap() on all hwpoisoned pages.
>>> While we take into account the recorded page sizes to repair the
>>> memory locations, a large page also needs to punch a hole in the
>>> backend file to regenerate a usable memory, cleaning the HW
>>> poisoned section. This is mandatory for hugetlbfs case for example.
>>>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>    system/physmem.c | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index 3757428336..3f6024a92d 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -2211,6 +2211,14 @@ void qemu_ram_remap(ram_addr_t addr,
>>> ram_addr_t length)
>>>                    prot = PROT_READ;
>>>                    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>>>                    if (block->fd >= 0) {
>>> +                    if (length > TARGET_PAGE_SIZE &&
>>> fallocate(block->fd,
>>> +                        FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
>>> +                        offset + block->fd_offset, length) != 0) {
>>> +                        error_report("Could not recreate the file
>>> hole for "
>>> +                                     "addr: " RAM_ADDR_FMT "@"
>>> RAM_ADDR_FMT "",
>>> +                                     length, addr);
>>> +                        exit(1);
>>> +                    }
>>>                        area = mmap(vaddr, length, prot, flags, block->fd,
>>>                                    offset + block->fd_offset);
>>>                    } else {
>>
>> Ah! Just what I commented to patch #3; we should be using
>> ram_discard_range(). It might be better to avoid the mmap() completely
>> if ram_discard_range() worked.
> 

Hi!

> 
> I think you are referring to ram_block_discard_range() here, as
> ram_discard_range() seems to relate to VM migrations, maybe not a VM reset.

Please take a look at the users of ram_block_discard_range(), including 
virtio-balloon to completely zap guest memory, so we will get fresh 
memory on next access. It takes care of process-private and file-backed 
(shared) memory.

> 
> Remapping the page is needed to get rid of the poison. So if we want to
> avoid the mmap(), we have to shrink the memory address space -- which
> can be a real problem if we imagine a VM with 1G large pages for
> example. qemu_ram_remap() is used to regenerate the lost memory and the
> mmap() call looks mandatory on the reset phase.

Why can't we use ram_block_discard_range() to zap the poisoned page 
(unmap from page tables + conditionallydrop from the page cache)? Is 
there anything important I am missing?

> 
> 
>>
>> And as raised, there is the problem with memory preallocation (where
>> we should fail if it doesn't work) and ram discards being disabled
>> because something relies on long-term page pinning ...
> 
> 
> Yes. Do you suggest that we add a call to qemu_prealloc_mem() for the
> remapped area in case of a backend->prealloc being true ?

Yes. Otherwise, with hugetlb, you might run out of hugetlb pages at 
runtime and SIGBUS QEMU :(

> 
> Or as we are running on posix machines for this piece of code (ifndef
> _WIN32) maybe we could simply add a MAP_POPULATE flag to the mmap call
> done in qemu_ram_remap() in the case where the backend requires a
> 'prealloc' ?  Can you confirm if this flag could be used on all systems
> running this code ?

Please use qemu_prealloc_mem(). MAP_POPULATE has no guarantees, it's 
really weird :/ mmap() might succeed even though MAP_POPULATE didn't 
work ... and it's problematic with NUMA policies because we essentially 
lose (overwrite) them.

And the whole mmap(MAP_FIXED) is an ugly hack. For example, we wouldn't 
reset the memory policy we apply in 
host_memory_backend_memory_complete() ... that code really needs a 
rewrite to do it properly.


Ideally, we'd do something high-level like


if (ram_block_discard_is_disabled()) {
	/*
	 * We cannot safely discard RAM,  ... for example we might have
	 * to remap all guest RAM into vfio after discarding the 	
	 * problematic pages ... TODO.
	 */
	exit(0);
}

/* Throw away the problematic (poisoned) page. *./
if (ram_block_discard_range()) {
	/* Conditionally fallback to MAP_FIXED workaround */
	...
}

/* If prealloction was requested, we really must re-preallcoate. */
if (prealloc && qemu_prealloc_mem()) {
	/* Preallocation failed .... */
	exit(0);
}

As you note the last part is tricky. See bwloe.

> 
> Unfortunately, I don't know how to get the MEMORY_BACKEND corresponding
> to a given memory block. I'm not sure that MEMORY_BACKEND(block->mr) is
> a valid way to retrieve the Backend object and its 'prealloc' property
> here. Could you please give me a direction here ?

We could add a RAM_PREALLOC flag to hint that this memory has "prealloc" 
semantics.

I once had an alternative approach: Similar to ram_block_notify_resize() 
we would implement ram_block_notify_remap().

That's where the backend could register and re-apply mmap properties 
like NUMA policies (in case we have to fallback to MAP_FIXED) and handle 
the preallocation.

So one would implement a ram_block_notify_remap() and maybe indicate if 
we had to do MAP_FIXED or if we only discarded the page.

I once had a prototype for that, let me dig ...

> 
> I can send a new version using ram_block_discard_range() as you
> suggested to replace the direct call to fallocate(), if you think it
> would be better.
> Please let me know what other enhancement(s) you'd like to see in this
> code change.

Something along the lines above. Please let me know if you see problems 
with that approach that I am missing.

-- 
Cheers,

David / dhildenb


