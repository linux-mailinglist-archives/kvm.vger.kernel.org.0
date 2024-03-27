Return-Path: <kvm+bounces-12897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9084A88ED56
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9C328BBCB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A293C1534EC;
	Wed, 27 Mar 2024 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jP92ELXV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D191C1534EB
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561811; cv=none; b=lQkGCUjW8c/Wu56EaCfFzFGZ0ESrFFsDHEsAt3asutJ0oYjFSaL8T1pDnRQG9vbkUp3bvri/2frLZlXGtY6aePbeXldWEBR04mHNGd7XJ7gxowUwldZJioFK+YNjlrWR4b+tEzOdegSBmCHoB1r21exzVCkLIVw+IPyh4Yjhgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561811; c=relaxed/simple;
	bh=LZvaINt9HJrHcAY/JwhxjZU6utSuUqCnqmtGfgruM6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X5N2jfKtZiTHKADWrur0Otyp8D76ALU+NznKAcQwq2INy/a1rGr3bdeZz8pAcZ7Y73zNSviBuL6KTxyB9YQKplCdGCK2ONpPYvZjdkcAaaQYRldJeMT75AEomtVtoSvehaV8It1xsIIkGhB2DkQhC9iAScFwDo3qyoD2gqBG6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jP92ELXV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711561808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ykjG4P12sR/HO7m6DFNkA+xEDV1yFQqhHTqRvEEB0Mg=;
	b=jP92ELXVwTKLUqOhYSxBp9o5kjoucBcmOPVUSsJkVwPnggShfZfRW51rp98jwhMC1P8q2e
	aihqs227poVx/ldbr8w/b13ES5LL7aHkFDcVUhhIkmnWsjaxBaDxxy0irr9+vnPpkwnC05
	2WMLDGHJ7OE7L/AcQPDoPdNw5ttk6CU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-QvBohwppNPqDLnEb-lpTlA-1; Wed, 27 Mar 2024 13:50:07 -0400
X-MC-Unique: QvBohwppNPqDLnEb-lpTlA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ed489edcaso1766f8f.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561806; x=1712166606;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykjG4P12sR/HO7m6DFNkA+xEDV1yFQqhHTqRvEEB0Mg=;
        b=lHe0BtttIDMmjtD94nJdx7OUx3rtd8qlaMdSYoSbj2A5VpluQ+907XoYfM3SFyc/gb
         fwHkXQI9f/v8wxdow1Y4y9SRwsJkrjbx9ZeLtw1dhivsaDraP+JHB3Zqz3xzVt7JGz6F
         K6zp5M7LtaYqrh2EnQdlY8frY0Yt94UCtUmfzLYSga9AhCa3YBDtN6fmgrvGWE4CVcnw
         JZdsjTTJPZTAl23j1VunxAbWOeoBHJnsSkCn2nQ2P/x3dVqkKCCI3Gk23FIw63Hj96//
         UE+H+n8HYTNyPYyeKHnWN/cAe/kiJTVLNMAOjQkkZwjmop0gCmOpKkDHM1OISmRlQBO9
         t+6g==
X-Forwarded-Encrypted: i=1; AJvYcCXlwtKWCqpzPD/cKGho/MGPmmwoWXSf0vHU01gL4uvuQprJUZU9rkvw7kPvGzyJdwYXTciQaMChpMU5mOAUUP2qoGls
X-Gm-Message-State: AOJu0YzI7iou15ilM5G53VtEy8xHGH9ndRxKgg9jBr60DWhQgXf+XL9l
	ElvC3XikOMb9zCKLtPxhDXHspMYCeKqWifXzoAJa2X+lARcmN6AeIQ3c6AryUhNjHR1xpvB/Gtf
	0g0ZAVRyXPTW9pGICCL6F2pd5GG0TS7JyrFqzTU6vvrpw2T+TZw==
X-Received: by 2002:a05:6000:1087:b0:33d:365a:64ce with SMTP id y7-20020a056000108700b0033d365a64cemr468845wrw.34.1711561806122;
        Wed, 27 Mar 2024 10:50:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1g5QYuV5NXFxwNAwyAkrGKwVtG/Ckqp6BnezeALNRzzAajs7QtXbeRYyFEi2shQbVPZyqiQ==
X-Received: by 2002:a05:6000:1087:b0:33d:365a:64ce with SMTP id y7-20020a056000108700b0033d365a64cemr468778wrw.34.1711561805620;
        Wed, 27 Mar 2024 10:50:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:8a00:362b:7e34:a3bc:9ddf? (p200300cbc7088a00362b7e34a3bc9ddf.dip0.t-ipconnect.de. [2003:cb:c708:8a00:362b:7e34:a3bc:9ddf])
        by smtp.gmail.com with ESMTPSA id bf10-20020a0560001cca00b0033ec81ec4aesm15535818wrb.78.2024.03.27.10.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 10:50:05 -0700 (PDT)
Message-ID: <beff9a7c-479e-4a32-a9a3-e071e1ffdf56@redhat.com>
Date: Wed, 27 Mar 2024 18:50:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
To: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>, Quentin Perret
 <qperret@google.com>, Matthew Wilcox <willy@infradead.org>,
 Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <f8a8c432-728a-4a79-8200-4c3f282ba415@redhat.com>
 <20240326102616728-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240326102616728-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.03.24 23:04, Elliot Berman wrote:
> On Fri, Mar 22, 2024 at 10:21:09PM +0100, David Hildenbrand wrote:
>> On 22.03.24 18:52, David Hildenbrand wrote:
>>> On 19.03.24 15:31, Will Deacon wrote:
>>>> Hi David,
>>>
>>> Hi Will,
>>>
>>> sorry for the late reply!
>>>
>>>>
>>>> On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
>>>>> On 19.03.24 01:10, Sean Christopherson wrote:
>>>>>> On Mon, Mar 18, 2024, Vishal Annapurve wrote:
>>>>>>> On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
>>>>>>>> Second, we should find better ways to let an IOMMU map these pages,
>>>>>>>> *not* using GUP. There were already discussions on providing a similar
>>>>>>>> fd+offset-style interface instead. GUP really sounds like the wrong
>>>>>>>> approach here. Maybe we should look into passing not only guest_memfd,
>>>>>>>> but also "ordinary" memfds.
>>>>>>
>>>>>> +1.  I am not completely opposed to letting SNP and TDX effectively convert
>>>>>> pages between private and shared, but I also completely agree that letting
>>>>>> anything gup() guest_memfd memory is likely to end in tears.
>>>>>
>>>>> Yes. Avoid it right from the start, if possible.
>>>>>
>>>>> People wanted guest_memfd to *not* have to mmap guest memory ("even for
>>>>> ordinary VMs"). Now people are saying we have to be able to mmap it in order
>>>>> to GUP it. It's getting tiring, really.
>>>>
>>>>    From the pKVM side, we're working on guest_memfd primarily to avoid
>>>> diverging from what other CoCo solutions end up using, but if it gets
>>>> de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
>>>> today with anonymous memory, then it's a really hard sell to switch over
>>>> from what we have in production. We're also hoping that, over time,
>>>> guest_memfd will become more closely integrated with the mm subsystem to
>>>> enable things like hypervisor-assisted page migration, which we would
>>>> love to have.
>>>
>>> Reading Sean's reply, he has a different view on that. And I think
>>> that's the main issue: there are too many different use cases and too
>>> many different requirements that could turn guest_memfd into something
>>> that maybe it really shouldn't be.
>>>
>>>>
>>>> Today, we use the existing KVM interfaces (i.e. based on anonymous
>>>> memory) and it mostly works with the one significant exception that
>>>> accessing private memory via a GUP pin will crash the host kernel. If
>>>> all guest_memfd() can offer to solve that problem is preventing GUP
>>>> altogether, then I'd sooner just add that same restriction to what we
>>>> currently have instead of overhauling the user ABI in favour of
>>>> something which offers us very little in return.
>>>>
>>>> On the mmap() side of things for guest_memfd, a simpler option for us
>>>> than what has currently been proposed might be to enforce that the VMM
>>>> has unmapped all private pages on vCPU run, failing the ioctl if that's
>>>> not the case. It needs a little more tracking in guest_memfd but I think
>>>> GUP will then fall out in the wash because only shared pages will be
>>>> mapped by userspace and so GUP will fail by construction for private
>>>> pages.
>>>>
>>>> We're happy to pursue alternative approaches using anonymous memory if
>>>> you'd prefer to keep guest_memfd limited in functionality (e.g.
>>>> preventing GUP of private pages by extending mapping_flags as per [1]),
>>>> but we're equally willing to contribute to guest_memfd if extensions are
>>>> welcome.
>>>>
>>>> What do you prefer?
>>>
>>> Let me summarize the history:
>>>
>>> AMD had its thing running and it worked for them (but I recall it was
>>> hacky :) ).
>>>
>>> TDX made it possible to crash the machine when accessing secure memory
>>> from user space (MCE).
>>>
>>> So secure memory must not be mapped into user space -- no page tables.
>>> Prototypes with anonymous memory existed (and I didn't hate them,
>>> although hacky), but one of the other selling points of guest_memfd was
>>> that we could create VMs that wouldn't need any page tables at all,
>>> which I found interesting.
>>>
>>> There was a bit more to that (easier conversion, avoiding GUP,
>>> specifying on allocation that the memory was unmovable ...), but I'll
>>> get to that later.
>>>
>>> The design principle was: nasty private memory (unmovable, unswappable,
>>> inaccessible, un-GUPable) is allocated from guest_memfd, ordinary
>>> "shared" memory is allocated from an ordinary memfd.
>>>
>>> This makes sense: shared memory is neither nasty nor special. You can
>>> migrate it, swap it out, map it into page tables, GUP it, ... without
>>> any issues.
>>>
>>>
>>> So if I would describe some key characteristics of guest_memfd as of
>>> today, it would probably be:
>>>
>>> 1) Memory is unmovable and unswappable. Right from the beginning, it is
>>>       allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
>>> 2) Memory is inaccessible. It cannot be read from user space, the
>>>       kernel, it cannot be GUP'ed ... only some mechanisms might end up
>>>       touching that memory (e.g., hibernation, /proc/kcore) might end up
>>>       touching it "by accident", and we usually can handle these cases.
>>> 3) Memory can be discarded in page granularity. There should be no cases
>>>       where you cannot discard memory to over-allocate memory for private
>>>       pages that have been replaced by shared pages otherwise.
>>> 4) Page tables are not required (well, it's an memfd), and the fd could
>>>       in theory be passed to other processes.
>>>
>>> Having "ordinary shared" memory in there implies that 1) and 2) will
>>> have to be adjusted for them, which kind-of turns it "partially" into
>>> ordinary shmem again.
>>>
>>>
>>> Going back to the beginning: with pKVM, we likely want the following
>>>
>>> 1) Convert pages private<->shared in-place
>>> 2) Stop user space + kernel from accessing private memory in process
>>>       context. Likely for pKVM we would only crash the process, which
>>>       would be acceptable.
>>> 3) Prevent GUP to private memory. Otherwise we could crash the kernel.
>>> 4) Prevent private pages from swapout+migration until supported.
>>>
>>>
>>> I suspect your current solution with anonymous memory gets all but 3)
>>> sorted out, correct?
>>>
>>> I'm curious, may there be a requirement in the future that shared memory
>>> could be mapped into other processes? (thinking vhost-user and such
>>> things). Of course that's impossible with anonymous memory; teaching
>>> shmem to contain private memory would kind-of lead to ... guest_memfd,
>>> just that we don't have shared memory there.
>>>
>>
>> I was just thinking of something stupid, not sure if it makes any sense.
>> I'll raise it here before I forget over the weekend.
>>
>> ... what if we glued one guest_memfd and a memfd (shmem) together in the
>> kernel somehow?
>>
>> (1) A to-shared conversion moves a page from the guest_memfd to the memfd.
>>
>> (2) A to-private conversion moves a page from the memfd to the guest_memfd.
>>
>> Only the memfd can be mmap'ed/read/written/GUP'ed. Pages in the memfd behave
>> like any shmem pages: migratable, swappable etc.
>>
>>
>> Of course, (2) is only possible if the page is not pinned, not mapped (we
>> can unmap it). AND, the page must not reside on ZONE_MOVABLE / MIGRATE_CMA.
>>
> 
> Quentin gave idea offline of using splice to achieve the conversions.
> I'd want to use the in-kernel APIs on page-fault to do the conversion;
> not requiring userspace to make the splice() syscall.  One thing splice
> currently requires is the source (in) file; KVM UAPI today only gives
> userspace address. We could resolve that by for_each_vma_range(). I've
> just started looking into splice(), but I believe it takes care of not
> pinned and not mapped. guest_memfd would have to migrate the page out of
> ZONE_MOVABLE / MIGRATE_CMA.

I don't think we want to involve splice. Conceptually, I think KVM 
should create a pair of FDs: guest_memfd for private memory and 
"ordinary shmem/memfd" for shared memory.

Conversion back and forth can either be triggered using a KVM API (TDX 
use case), or internally from KVM (pkvm use case). Maybe it does 
something internally that splice would do that we can reuse, otherwise 
we have to do the plumbing.

Then, we have some logic on how to handle access to unbacked regions 
(SIGBUS instead of allocating memory) inside both memfds, and allow to 
allocate memory for parts of the fds explicitly.

No offset in the fd's can be populated the same time. That is, pages can 
be moved back and forth, but allocating a fresh page in an fd is only 
possible if there is nothing at that location in the other fd. No memory 
over-allocation.

Coming up with a KVM API for that should be possible.

> 
> Does this seem like a good path to pursue further or any other ideas for
> doing the conversion?
> 
>> We'd have to decide what to do when we access a "hole" in the memfd --
>> instead of allocating a fresh page and filling the hole, we'd want to
>> SIGBUS.
> 
> Since the KVM UAPI is based on userspace addresses and not fds for the
> shared memory part, maybe we could add a mmu_notifier_ops that allows
> KVM to intercept and reject faults if we couldn't reclaim the memory. I
> think it would be conceptually similar to userfaultfd except in the
> kernel; not sure if re-using userfaultfd makes sense?

Or if KVM exposes this other fd as well, we extend the UAPI to consume 
for the shared part also fd+offset.

-- 
Cheers,

David / dhildenb


