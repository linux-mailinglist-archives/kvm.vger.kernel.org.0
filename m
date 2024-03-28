Return-Path: <kvm+bounces-12988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0714988FAB8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54A9BB23E33
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB0E4E1D1;
	Thu, 28 Mar 2024 09:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJlF9DHt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4626519F
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 09:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711616822; cv=none; b=uYqlErc9tAdnOmlrpNBUm3QbDIoQx1S1CRAESRHUWs5eDlkNvST4Dfwm+EdlHoCTS5dY00+V682u9kBJuZOdKUDoq0ua49go3qfl+49nHLe8cXsYezSzQLk1P87w2wdhcNC5uFrIPvCyX+jTokMy9ijDZ6MbcMhi6LOIowMvViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711616822; c=relaxed/simple;
	bh=Z3+R7mukkGUVwTzJZBKSI4n4BHVs1sENaXXd5/cnVI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P9YkgYfKaeY6YuxiOdp9jtP40nEZOL/+YQqjal3uAsctK+Dt0eN4VXkcSI3tsLZjeEx7IqVc1w5DN+o3cfSIg0TMEFyLl08wu8uJ34GBT2msm0DYj2T3ji+HtrqgM34j8TWMgO0KgIrYUc4nxJp6AMPd/ugnrB5V4TSb3yLbCj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJlF9DHt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711616819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kbbXbY9boTjSy31Os/orS3iUeVt1pQN6gPCQBXp42Bo=;
	b=AJlF9DHtXVXTOHX3fcpQCkWpJyRPpSK9ce3Gp3qbAWkSg6fxyf9fbg5jGCM4QKlP1HMDft
	/7L2sa2kvbJLdx4XrC3FJBP3FiUJWMzA36awArrLK2s6xnaoocfogGxx7n6lV4gV+fo2DL
	amtxEN83DXcLRxsS6IBc6SyoyZ7gUZ0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-l9-170zxO7mdD_j0AYaAFA-1; Thu, 28 Mar 2024 05:06:58 -0400
X-MC-Unique: l9-170zxO7mdD_j0AYaAFA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-515bd3d89c9so466528e87.3
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711616816; x=1712221616;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kbbXbY9boTjSy31Os/orS3iUeVt1pQN6gPCQBXp42Bo=;
        b=DN2O0tauHTSeUjSgxEs83NgrOYkfqQvT8JMnTSb7OKWmjSepwx5H2gzqyzfvLXY0WY
         7pT3WBcIhv77asjeG9BIFbgDIVsSrxXNukXHngeZjHG+jMPYoCONw689paRFpqXV2fgl
         q0lCKM8wpmdKBz41YVSMleExGSfEXmyPz4s0jW4/C6xG/HG0C9Nc29e2RXrw9u7Ja8QD
         /GAV6+mZ1VWzEyAQ7zxA3wgL3Cz/fEMNjT8erzNYBt3noa2LrGn+7JSXRqNlOPK7R50T
         tN5FEO+Qcnoa9NejnKMWsomvcn7FyWfuq16MmwwfOp8H52cMu8HiHZc4L+w8K/Yhp8Rb
         hanQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZifdEEq02lXnngoW0yuREeB4h7h+WMRiMGyP0ZoTmA5rUn/iCKmoMjsnPBYggccv0C8SzfY5onaDX/Hg4gTwbajRL
X-Gm-Message-State: AOJu0Yx4HK0xneAa7+sdGJBR5/zIx/CpszoJ2ciha0lNN8WVhxnAc0Vg
	u/qCvB8+Ga+hRGoJaibNFVwwUrJoNDdFHfJ8d0UIRmRbad7brlkmp5YoC4dq7sAtWHsK96a0IoD
	zzYR1JK6jvw1dw4cU40AOfAmSuVYTj2t1Bm7OzykoJCIjtNlAjg==
X-Received: by 2002:a19:e043:0:b0:513:da4d:a9a6 with SMTP id g3-20020a19e043000000b00513da4da9a6mr1334959lfj.46.1711616816546;
        Thu, 28 Mar 2024 02:06:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkMlQBTRxWcDfJgOAf4yw1fei2yFJiKWkwI0R9YVETCl/MK8NoFKttmescL0wQv4e2N8c/xQ==
X-Received: by 2002:a19:e043:0:b0:513:da4d:a9a6 with SMTP id g3-20020a19e043000000b00513da4da9a6mr1334911lfj.46.1711616815849;
        Thu, 28 Mar 2024 02:06:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:3600:8033:4189:6bd4:ea29? (p200300cbc7143600803341896bd4ea29.dip0.t-ipconnect.de. [2003:cb:c714:3600:8033:4189:6bd4:ea29])
        by smtp.gmail.com with ESMTPSA id dd7-20020a0560001e8700b00341c6440c36sm1190593wrb.74.2024.03.28.02.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 02:06:55 -0700 (PDT)
Message-ID: <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>
Date: Thu, 28 Mar 2024 10:06:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Will Deacon <will@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
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
References: <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240327193454.GB11880@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.03.24 20:34, Will Deacon wrote:
> Hi again, David,
> 
> On Fri, Mar 22, 2024 at 06:52:14PM +0100, David Hildenbrand wrote:
>> On 19.03.24 15:31, Will Deacon wrote:
>> sorry for the late reply!
> 
> Bah, you and me both!

This time I'm faster! :)

> 
>>> On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
>>>> On 19.03.24 01:10, Sean Christopherson wrote:
>>>>> On Mon, Mar 18, 2024, Vishal Annapurve wrote:
>>>>>> On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
>>>   From the pKVM side, we're working on guest_memfd primarily to avoid
>>> diverging from what other CoCo solutions end up using, but if it gets
>>> de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
>>> today with anonymous memory, then it's a really hard sell to switch over
>>> from what we have in production. We're also hoping that, over time,
>>> guest_memfd will become more closely integrated with the mm subsystem to
>>> enable things like hypervisor-assisted page migration, which we would
>>> love to have.
>>
>> Reading Sean's reply, he has a different view on that. And I think that's
>> the main issue: there are too many different use cases and too many
>> different requirements that could turn guest_memfd into something that maybe
>> it really shouldn't be.
> 
> No argument there, and we're certainly not tied to any specific
> mechanism on the pKVM side. Maybe Sean can chime in, but we've
> definitely spoken about migration being a goal in the past, so I guess
> something changed since then on the guest_memfd side.
> 
> Regardless, from our point of view, we just need to make sure that
> whatever we settle on for pKVM does the things we need it to do (or can
> at least be extended to do them) and we're happy to implement that in
> whatever way works best for upstream, guest_memfd or otherwise.
> 
>>> We're happy to pursue alternative approaches using anonymous memory if
>>> you'd prefer to keep guest_memfd limited in functionality (e.g.
>>> preventing GUP of private pages by extending mapping_flags as per [1]),
>>> but we're equally willing to contribute to guest_memfd if extensions are
>>> welcome.
>>>
>>> What do you prefer?
>>
>> Let me summarize the history:
> 
> First off, thanks for piecing together the archaeology...
> 
>> AMD had its thing running and it worked for them (but I recall it was hacky
>> :) ).
>>
>> TDX made it possible to crash the machine when accessing secure memory from
>> user space (MCE).
>>
>> So secure memory must not be mapped into user space -- no page tables.
>> Prototypes with anonymous memory existed (and I didn't hate them, although
>> hacky), but one of the other selling points of guest_memfd was that we could
>> create VMs that wouldn't need any page tables at all, which I found
>> interesting.
> 
> Are the prototypes you refer to here based on the old stuff from Kirill?

Yes.

> We followed that work at the time, thinking we were going to be using
> that before guest_memfd came along, so we've sadly been collecting
> out-of-tree patches for a little while :/

:/

> 
>> There was a bit more to that (easier conversion, avoiding GUP, specifying on
>> allocation that the memory was unmovable ...), but I'll get to that later.
>>
>> The design principle was: nasty private memory (unmovable, unswappable,
>> inaccessible, un-GUPable) is allocated from guest_memfd, ordinary "shared"
>> memory is allocated from an ordinary memfd.
>>
>> This makes sense: shared memory is neither nasty nor special. You can
>> migrate it, swap it out, map it into page tables, GUP it, ... without any
>> issues.
> 
> Slight aside and not wanting to derail the discussion, but we have a few
> different types of sharing which we'll have to consider:

Thanks for sharing!

> 
>    * Memory shared from the host to the guest. This remains owned by the
>      host and the normal mm stuff can be made to work with it.

Okay, host and guest can access it. We can jut migrate memory around, 
swap it out ... like ordinary guest memory today.

> 
>    * Memory shared from the guest to the host. This remains owned by the
>      guest, so there's a pin on the pages and the normal mm stuff can't
>      work without co-operation from the guest (see next point).

Okay, host and guest can access it, but we cannot migrate memory around 
or swap it out ... like ordinary guest memory today that is longterm pinned.

> 
>    * Memory relinquished from the guest to the host. This actually unmaps
>      the pages from the host and transfers ownership back to the host,
>      after which the pin is dropped and the normal mm stuff can work. We
>      use this to implement ballooning.
> 

Okay, so this is essentially just a state transition between the two above.


> I suppose the main thing is that the architecture backend can deal with
> these states, so the core code shouldn't really care as long as it's
> aware that shared memory may be pinned.

So IIUC, the states are:

(1) Private: inaccesible by the host, accessible by the guest, "owned by
     the guest"

(2) Host Shared: accessible by the host + guest, "owned by the host"

(3) Guest Shared: accessible by the host, "owned by the guest"


Memory ballooning is simply transitioning from (3) to (2), and then 
discarding the memory.

Any state I am missing?


Which transitions are possible?

(1) <-> (2) ? Not sure if the direct transition is possible.

(2) <-> (3) ? IIUC yes.

(1) <-> (3) ? IIUC yes.



There is ongoing work on longterm-pinning memory from a memfd/shmem. So 
thinking in terms of my vague "fd guest_memfd + fd pair", that approach 
could look like the following:

(1) guest_memfd (could be "with longterm pin")

(2) memfd

(3) memfd with a longterm pin

But again, just some possible idea to make it work with guest_memfd.

> 
>> So if I would describe some key characteristics of guest_memfd as of today,
>> it would probably be:
>>
>> 1) Memory is unmovable and unswappable. Right from the beginning, it is
>>     allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
>> 2) Memory is inaccessible. It cannot be read from user space, the
>>     kernel, it cannot be GUP'ed ... only some mechanisms might end up
>>     touching that memory (e.g., hibernation, /proc/kcore) might end up
>>     touching it "by accident", and we usually can handle these cases.
>> 3) Memory can be discarded in page granularity. There should be no cases
>>     where you cannot discard memory to over-allocate memory for private
>>     pages that have been replaced by shared pages otherwise.
>> 4) Page tables are not required (well, it's an memfd), and the fd could
>>     in theory be passed to other processes.
>>
>> Having "ordinary shared" memory in there implies that 1) and 2) will have to
>> be adjusted for them, which kind-of turns it "partially" into ordinary shmem
>> again.
> 
> Yes, and we'd also need a way to establish hugepages (where possible)
> even for the *private* memory so as to reduce the depth of the guest's
> stage-2 walk.
> 

Understood, and as discussed, that's a bit more "hairy".

>> Going back to the beginning: with pKVM, we likely want the following
>>
>> 1) Convert pages private<->shared in-place
>> 2) Stop user space + kernel from accessing private memory in process
>>     context. Likely for pKVM we would only crash the process, which
>>     would be acceptable.
>> 3) Prevent GUP to private memory. Otherwise we could crash the kernel.
>> 4) Prevent private pages from swapout+migration until supported.
>>
>>
>> I suspect your current solution with anonymous memory gets all but 3) sorted
>> out, correct?
> 
> I agree on all of these and, yes, (3) is the problem for us. We've also
> been thinking a bit about CoW recently and I suspect the use of
> vm_normal_page() in do_wp_page() could lead to issues similar to those
> we hit with GUP. There are various ways to approach that, but I'm not
> sure what's best.

Would COW be required or is that just the nasty side-effect of trying to 
use anonymous memory?

> 
>> I'm curious, may there be a requirement in the future that shared memory
>> could be mapped into other processes? (thinking vhost-user and such things).
> 
> It's not impossible. We use crosvm as our VMM, and that has a
> multi-process sandbox mode which I think relies on just that...
> 

Okay, so basing the design on anonymous memory might not be the best 
choice ... :/

> Cheers,
> 
> Will
> 
> (btw: I'm getting some time away from the computer over Easter, so I'll be
>   a little slow on email again. Nothing personal!).

Sure, no worries! Enjoy!

-- 
Cheers,

David / dhildenb


