Return-Path: <kvm+bounces-12519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D382A88722C
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030851C2100D
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5A960863;
	Fri, 22 Mar 2024 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1HW8Qqi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1417605C6
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129943; cv=none; b=P7oWKXInIbGOPSIia8HTmek23muJ4BZ9fHVr6inxnCZOqwzgsvKfU/18z0QmGjngUgy3/gHmwPUHE38q4cFpr4qHImTF4YCcF9UJEze/R9fWyqj9zDXgx2nHRyUSo7kc/shGq4qm5R5k2rE2nSAfAjHKXkAkhK3Nx59C7AaaGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129943; c=relaxed/simple;
	bh=Ps/2zmED4V/4Mugj19V5O+VRXCAuSuCB45zhIkms8Fs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ot15ZkMeE4zGyL6RGdOUQAaex/djUwyHKhh3MRA99PyHRSpS/TaElARNQzAj/etZv/HDoO3/YHD7zanofFvjm51igWeN/4Z15KF5oAa85w/gDofOMbaBWBb7WWIzoYyTWFS53XiVE63Dt3ZvRU50aa4Jb5K6yoQre8s27IsqnlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1HW8Qqi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711129940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Gb9Qa2HC9PUpp7JrzETLi4Q7+02gJGK5TZHjydmjtS0=;
	b=R1HW8QqiOukJmQSguZbsa5hxS5q18/FhC1o7aDlr8/Ak66/fsSN8VL/P7tvrUKQSuvQXfd
	+z2Sw3h0yIUzKELgFWURO03s9CTnLX1ClX9GsaZpHDfY5tEtr49VMy1JGrWvmb2ovNKbRN
	Rt7aYUCTcc5BFWGMDTk4njUB/yDWLDs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-U_QUnruSPAq2omnqVLSbXQ-1; Fri, 22 Mar 2024 13:52:19 -0400
X-MC-Unique: U_QUnruSPAq2omnqVLSbXQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33ed489edcaso1102909f8f.3
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 10:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711129938; x=1711734738;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gb9Qa2HC9PUpp7JrzETLi4Q7+02gJGK5TZHjydmjtS0=;
        b=Nrq/3KoM7ucyi05WQXCkbYTnA3KM+K2OBg3x7Ri+0i/BqD479/w2C2SfDnMx3Pqzcl
         m3o+rigOWgv1vBer74AA64sD88Wi5s2XmKkC7aDt5Oko6MXVEcXl3IBBchEpwxbjBM3Z
         gPkQylgUmr02YV3KKEDZk7DmVpp68Q0J+toY1oWQoprmDF/5EgWYt6UHsIk2TFrBx7SD
         j0b+500YOzW/a1Owwo35kJkNm6m1sreU/qlQdO88j0pB+YC0Z8G+9NseN7b43l7//TWt
         m04I4x1+Oq8c+sH3pMbK70+KF/HMgCEgrZQfCEQIxdK88iAj9GbLaJWDGMPG7ANE7TLH
         1PeA==
X-Forwarded-Encrypted: i=1; AJvYcCWQmalFWRh0vpbLAjq+W5L0OGQ+Cfnhebq7sNBaIZMA6NKJyU/MzYnmLvCoylFOj/z5Pek3O+z1wmy3rogMRZFhwh4m
X-Gm-Message-State: AOJu0YzvYoysyJH4Xi9pCjKdO6r+mJ58IlwTBiIAm7AhEnDp3evNRFI3
	CKZ8cRQtGU2YviPY2dURZM3CAze/cSmN9iDGIi8jaPhPuR4QZ/hqOEFmYByA0/nU7mncQIDjiAw
	ZYOxE/8YHwt97h0fbP6pTDpNiaWxH3s/vPsVRaPAtInEZxpWN6Q==
X-Received: by 2002:adf:e7c5:0:b0:33e:7b2d:7419 with SMTP id e5-20020adfe7c5000000b0033e7b2d7419mr70047wrn.15.1711129937955;
        Fri, 22 Mar 2024 10:52:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNYbeWlc5wQeQXdFbbaLRwiJJvNBai7rukIfba3St2pQT4smTvMpf+YFXpFMLEBtq2T62Osg==
X-Received: by 2002:adf:e7c5:0:b0:33e:7b2d:7419 with SMTP id e5-20020adfe7c5000000b0033e7b2d7419mr70003wrn.15.1711129937431;
        Fri, 22 Mar 2024 10:52:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7e00:9339:4017:7111:82d0? (p200300cbc71b7e0093394017711182d0.dip0.t-ipconnect.de. [2003:cb:c71b:7e00:9339:4017:7111:82d0])
        by smtp.gmail.com with ESMTPSA id x16-20020a5d6b50000000b0033e93e00f68sm2544543wrw.61.2024.03.22.10.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 10:52:16 -0700 (PDT)
Message-ID: <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
Date: Fri, 22 Mar 2024 18:52:14 +0100
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
References: <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240319143119.GA2736@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19.03.24 15:31, Will Deacon wrote:
> Hi David,

Hi Will,

sorry for the late reply!

> 
> On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
>> On 19.03.24 01:10, Sean Christopherson wrote:
>>> On Mon, Mar 18, 2024, Vishal Annapurve wrote:
>>>> On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
>>>>> Second, we should find better ways to let an IOMMU map these pages,
>>>>> *not* using GUP. There were already discussions on providing a similar
>>>>> fd+offset-style interface instead. GUP really sounds like the wrong
>>>>> approach here. Maybe we should look into passing not only guest_memfd,
>>>>> but also "ordinary" memfds.
>>>
>>> +1.  I am not completely opposed to letting SNP and TDX effectively convert
>>> pages between private and shared, but I also completely agree that letting
>>> anything gup() guest_memfd memory is likely to end in tears.
>>
>> Yes. Avoid it right from the start, if possible.
>>
>> People wanted guest_memfd to *not* have to mmap guest memory ("even for
>> ordinary VMs"). Now people are saying we have to be able to mmap it in order
>> to GUP it. It's getting tiring, really.
> 
>  From the pKVM side, we're working on guest_memfd primarily to avoid
> diverging from what other CoCo solutions end up using, but if it gets
> de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> today with anonymous memory, then it's a really hard sell to switch over
> from what we have in production. We're also hoping that, over time,
> guest_memfd will become more closely integrated with the mm subsystem to
> enable things like hypervisor-assisted page migration, which we would
> love to have.

Reading Sean's reply, he has a different view on that. And I think 
that's the main issue: there are too many different use cases and too 
many different requirements that could turn guest_memfd into something 
that maybe it really shouldn't be.

> 
> Today, we use the existing KVM interfaces (i.e. based on anonymous
> memory) and it mostly works with the one significant exception that
> accessing private memory via a GUP pin will crash the host kernel. If
> all guest_memfd() can offer to solve that problem is preventing GUP
> altogether, then I'd sooner just add that same restriction to what we
> currently have instead of overhauling the user ABI in favour of
> something which offers us very little in return.
> 
> On the mmap() side of things for guest_memfd, a simpler option for us
> than what has currently been proposed might be to enforce that the VMM
> has unmapped all private pages on vCPU run, failing the ioctl if that's
> not the case. It needs a little more tracking in guest_memfd but I think
> GUP will then fall out in the wash because only shared pages will be
> mapped by userspace and so GUP will fail by construction for private
> pages.
> 
> We're happy to pursue alternative approaches using anonymous memory if
> you'd prefer to keep guest_memfd limited in functionality (e.g.
> preventing GUP of private pages by extending mapping_flags as per [1]),
> but we're equally willing to contribute to guest_memfd if extensions are
> welcome.
> 
> What do you prefer?

Let me summarize the history:

AMD had its thing running and it worked for them (but I recall it was 
hacky :) ).

TDX made it possible to crash the machine when accessing secure memory 
from user space (MCE).

So secure memory must not be mapped into user space -- no page tables. 
Prototypes with anonymous memory existed (and I didn't hate them, 
although hacky), but one of the other selling points of guest_memfd was 
that we could create VMs that wouldn't need any page tables at all, 
which I found interesting.

There was a bit more to that (easier conversion, avoiding GUP, 
specifying on allocation that the memory was unmovable ...), but I'll 
get to that later.

The design principle was: nasty private memory (unmovable, unswappable, 
inaccessible, un-GUPable) is allocated from guest_memfd, ordinary 
"shared" memory is allocated from an ordinary memfd.

This makes sense: shared memory is neither nasty nor special. You can 
migrate it, swap it out, map it into page tables, GUP it, ... without 
any issues.


So if I would describe some key characteristics of guest_memfd as of 
today, it would probably be:

1) Memory is unmovable and unswappable. Right from the beginning, it is
    allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
2) Memory is inaccessible. It cannot be read from user space, the
    kernel, it cannot be GUP'ed ... only some mechanisms might end up
    touching that memory (e.g., hibernation, /proc/kcore) might end up
    touching it "by accident", and we usually can handle these cases.
3) Memory can be discarded in page granularity. There should be no cases
    where you cannot discard memory to over-allocate memory for private
    pages that have been replaced by shared pages otherwise.
4) Page tables are not required (well, it's an memfd), and the fd could
    in theory be passed to other processes.

Having "ordinary shared" memory in there implies that 1) and 2) will 
have to be adjusted for them, which kind-of turns it "partially" into 
ordinary shmem again.


Going back to the beginning: with pKVM, we likely want the following

1) Convert pages private<->shared in-place
2) Stop user space + kernel from accessing private memory in process
    context. Likely for pKVM we would only crash the process, which
    would be acceptable.
3) Prevent GUP to private memory. Otherwise we could crash the kernel.
4) Prevent private pages from swapout+migration until supported.


I suspect your current solution with anonymous memory gets all but 3) 
sorted out, correct?

I'm curious, may there be a requirement in the future that shared memory 
could be mapped into other processes? (thinking vhost-user and such 
things). Of course that's impossible with anonymous memory; teaching 
shmem to contain private memory would kind-of lead to ... guest_memfd, 
just that we don't have shared memory there.

-- 
Cheers,

David / dhildenb


