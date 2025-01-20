Return-Path: <kvm+bounces-36062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60431A172C1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 19:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA5471887C63
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799E51EF0AC;
	Mon, 20 Jan 2025 18:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwKsmMCI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51781E9B36
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737398848; cv=none; b=OzowPIwYK2Vi1+Zo8LB/tpm0Yzub5B4pqBzfiK/in2Db+h9Dq8ObGgJYF7189ORVEdQiadYCu0OowEfHMYlZ+f5acNifVF9zu+n6eDDZyjNnNGVdNRlRU9CTWkcJ8OefrRhihoJPqClrHz6u/FuvvZkER3lO4K9RvckHvFijFDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737398848; c=relaxed/simple;
	bh=1AglsEl4KBF49S2DZ8/NpgTpLLKx/q3HNDpd6SFixr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVj2M88Ko55dY7mZtHFxou7wrWFc60AmtVYxpv8srm7aOGTrsCkmppxZkr+6bz/GFlPvcCHCL9sT0mQFoNVkKL80UoYcI1MpusatZp8Rl0F3ZGoTC1oFWeT8fzNTEBzAteSh1TrP+h5uqqz1QFqy8wo6ruOD7fgzt1i0V+UFaXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwKsmMCI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737398845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J+iNXCU7mhQ3xjPD9HDDS+af++ea/Ik8vEVIaiKhR6c=;
	b=gwKsmMCIft8CFHq3UAMa3SJjTZPRSsu5CBBmWJL217zWLH9bD6eEOlOdW18DGP16vGfRts
	Spb8AkOp4MR+0CBu5Os4X3d9/4bqSE9mw3HLAfwOCC9aqfAU0kdvlv9ROFi/SSmtEQtuCE
	LpwCGTHm2jvD6L8vkWKL6qRzSbJftzc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-kJvYnx1sMMWc90WwjVbyxA-1; Mon, 20 Jan 2025 13:47:23 -0500
X-MC-Unique: kJvYnx1sMMWc90WwjVbyxA-1
X-Mimecast-MFC-AGG-ID: kJvYnx1sMMWc90WwjVbyxA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-436379713baso23351785e9.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737398842; x=1738003642;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J+iNXCU7mhQ3xjPD9HDDS+af++ea/Ik8vEVIaiKhR6c=;
        b=OICKDAXzljXFeqEoRmJ3lxMmsqIP6Z+wxFOJgVDzdWk4cDQ5i44lYEpZBEopAcrvko
         g4ENNTUT5aqOQuSFpBb/u2X6JCtmzBt6EJv8AR9k2Zl40GPohl6F6IXuVZ/9/PhuV4Fm
         qz/wcQ4aCL+Y4epmis//tcOzzdFikntLV9FxUXUIDWUsXhTAA6oNXNTaH+3UMUVNc4ji
         yTO5M1vUkOA+55l9W2trXkt2TiWyHSVs3bwLPKRvxopZscO7vunGwgltH3x6Gp/qj3gT
         BBwyXN8s3Q6iiko9Km4OrFn9YuFth64VlJ1tchW1ww3U6H026pOp9gr0Kmk+rXWCCuh6
         boyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfIpjDArj9L7EEVC+79Toa0nPfEHll7hGkGYK1xAXx2DOMOZoA6JH0AEw5g6PoOvF+Ozg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/Xxoh+PXl7mh/a80iXeZhgkM+9sjxJ5xLieXzvfk0rEmfOBz6
	XsX8pOM+mTdS0nga+6Yd4A5rheRfVY621KiuSCYXBnw2phIe4JN3Re2qj49SOX2NKx0psgQ8/c6
	/Mwq5W3cDgBxDtgN2NmfgREpq+R9UGfn0XenqicwC1fR0rd/hsw==
X-Gm-Gg: ASbGncuxmpNPu3evlnHHb0M4ctELo7luHVHCC+i4xxLpff3fyrbk3f6pnEu05YW1DJG
	ROs+IfL+fZoRoxd7bEVImv1hbZnRajSIFMuN5TwlsgzuIVcGHn7zhHFS1j4QxRTxJe0gY4hrEQ9
	D2fCV8lCMYv9RPNyemLWygEQuN/cekmh8yrz2PON07hCkKVmpKSRS2xUpgwjmqnhOQ018BxFqHd
	cZqjDiN4T+utNWZSLyVF+B7EQsa5RH38YB3mfnXRCGO4wQLVxT2sGhUHBXA6RisfxpccoKfaoRq
	i/lsJHxykfoWTkMqucszB1buOBgx9qsQ+xto1CzXU3MIQhAMjzgtndXs4Dme5HQDHPFF16rzvK6
	K5YatQP7tXX5+Kg+bUbLJuw==
X-Received: by 2002:a05:600c:511b:b0:432:d797:404a with SMTP id 5b1f17b1804b1-4389142e0e8mr122567155e9.22.1737398842519;
        Mon, 20 Jan 2025 10:47:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYdUvvaXrsYkkmoO7RHHHfsnFKi2DDg33h/i/ludctvzM1edekD48JDVnkM/arqHk4x0c4IA==
X-Received: by 2002:a05:600c:511b:b0:432:d797:404a with SMTP id 5b1f17b1804b1-4389142e0e8mr122566885e9.22.1737398842096;
        Mon, 20 Jan 2025 10:47:22 -0800 (PST)
Received: from ?IPV6:2003:cb:c72e:e400:431d:9c08:5611:693c? (p200300cbc72ee400431d9c085611693c.dip0.t-ipconnect.de. [2003:cb:c72e:e400:431d:9c08:5611:693c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499884sm214003645e9.5.2025.01.20.10.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 10:47:20 -0800 (PST)
Message-ID: <ba6ea305-fd04-4e88-8bdc-1d6c5dee95f8@redhat.com>
Date: Mon, 20 Jan 2025 19:47:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Peter Xu <peterx@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com> <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com> <Z46W7Ltk-CWjmCEj@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z46W7Ltk-CWjmCEj@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.01.25 19:33, Peter Xu wrote:
> On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
>> On 20.01.25 18:21, Peter Xu wrote:
>>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
>>>> Sorry, I was traveling end of last week. I wrote a mail on the train and
>>>> apparently it was swallowed somehow ...
>>>>
>>>>>> Not sure that's the right place. Isn't it the (cc) machine that controls
>>>>>> the state?
>>>>>
>>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
>>>>
>>>> Right; I consider KVM part of the machine.
>>>>
>>>>
>>>>>
>>>>>> It's not really the memory backend, that's just the memory provider.
>>>>>
>>>>> Sorry but is not "providing memory" the purpose of "memory backend"? :)
>>>>
>>>> Hehe, what I wanted to say is that a memory backend is just something to
>>>> create a RAMBlock. There are different ways to create a RAMBlock, even
>>>> guest_memfd ones.
>>>>
>>>> guest_memfd is stored per RAMBlock. I assume the state should be stored per
>>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
>>>>
>>>> Now, the question is, who is the manager?
>>>>
>>>> 1) The machine. KVM requests the machine to perform the transition, and the
>>>> machine takes care of updating the guest_memfd state and notifying any
>>>> listeners.
>>>>
>>>> 2) The RAMBlock. Then we need some other Object to trigger that. Maybe
>>>> RAMBlock would have to become an object, or we allocate separate objects.
>>>>
>>>> I'm leaning towards 1), but I might be missing something.
>>>
>>> A pure question: how do we process the bios gmemfds?  I assume they're
>>> shared when VM starts if QEMU needs to load the bios into it, but are they
>>> always shared, or can they be converted to private later?
>>
>> You're probably looking for memory_region_init_ram_guest_memfd().
> 
> Yes, but I didn't see whether such gmemfd needs conversions there.  I saw
> an answer though from Chenyi in another email:
> 
> https://lore.kernel.org/all/fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com/
> 
> So I suppose the BIOS region must support private / share conversions too,
> just like the rest part.
> 
> Though in that case, I'm not 100% sure whether that could also be done by
> reusing the major guest memfd with some specific offset regions.
> 
>>
>>>
>>> I wonder if it's possible (now, or in the future so it can be >2 fds) that
>>> a VM can contain multiple guest_memfds, meanwhile they request different
>>> security levels. Then it could be more future proof that such idea be
>>> managed per-fd / per-ramblock / .. rather than per-VM. For example, always
>>> shared gmemfds can avoid the manager but be treated like normal memories,
>>> while some gmemfds can still be confidential to install the manager.
>>
>> I think all of that is possible with whatever design we chose.
>>
>> The situation is:
>>
>> * guest_memfd is per RAMBlock (block->guest_memfd set in ram_block_add)
>> * Some RAMBlocks have a memory backend, others do not. In particular,
>>    the ones calling memory_region_init_ram_guest_memfd() do not.
>>
>> So the *guest_memfd information* (fd, bitmap) really must be stored per
>> RAMBlock.
>>
>> The question *which object* implements the RamDiscardManager interface to
>> manage the RAMBlocks that have a guest_memfd.
>>
>> We either need
>>
>> 1) Something attached to the RAMBlock or the RAMBlock itself. This
>>     series does it via a new object attached to the RAMBlock.
>> 2) A per-VM entity (e.g., machine, distinct management object)
>>
>> In case of 1) KVM looks up the RAMBlock->object to trigger the state change.
>> That object will inform all listeners.
>>
>> In case of 2) KVM calls the per-VM entity (e.g., guest_memfd manager), which
>> looks up the RAMBlock and triggers the state change. It will inform all
>> listeners.
> 
> (after I finished reading the whole discussion..)
> 
> Looks like Yilun raised another point, on how to reuse the same object for
> device TIO support here (conversions for device MMIOs):

I don't grasp the full picture, but I suspect it would not be RAM (no 
RAMBlock?)?

"memory_attribute_manager" is weird if it is not memory, but 
memory-mapped I/O ... :)

-- 
Cheers,

David / dhildenb


