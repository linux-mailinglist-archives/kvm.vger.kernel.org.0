Return-Path: <kvm+bounces-36152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B44F0A1820B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0040168BED
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CDB1F471A;
	Tue, 21 Jan 2025 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I8nMmVZJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB541741D2
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737477316; cv=none; b=PUVFcT6zQlaQdNZbzpaXTIF+2Pevm838LCi2/DnMv2lvSUj2GMVkuaTz8fK7RW3u5qSaR7pSkQq7o10ht+vXvwwGARfMd2ZIBTC+7bdVr9NGKnugtAAiKEY0n55+vc2sNQ1C4x/mKIRKpmbneLrOm8YkQZcwaVRR182IBH4ISck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737477316; c=relaxed/simple;
	bh=O4Pr2rODAgw/vZkbGYv6BlgHcfBvkW9pRTVuaaZ8zeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X05aXNWawBUJyFLOPrqb5Uer7ho+tn3WWQXQMaq9N1lXdQdYpWqZed6CcJ/lnt2ste0w1QKm2Xa1nL9aDoC4RMIL2BZIJtw6E1Uq/I1mHAKNax9wUNXIKO17FfWTeIGGX8GwnLEUi3s3weVlETgn5njcICOyBrAkg4r1A9fR570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I8nMmVZJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737477313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IicrbX29/PlrHURDmORDtKf+izW4RsJs/gkYLbWILo=;
	b=I8nMmVZJ8HRAnLxmDlgaeCR9bdjEmc2nWUT44R3oyKOHr1HsRBlFkkx0gLq5cJcGNtV0bm
	x/djbJZyLbdPwQ0G0819Iylm6eJVIVdUKVZixOhbAGeNOIzt55FukETt+vkdXjH+L2f2Iv
	4JIt5MoR2g6TjOwCUHsh3k+37jibGaM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-Ge8yOqZwMduWOyKGumQ0Cg-1; Tue, 21 Jan 2025 11:35:12 -0500
X-MC-Unique: Ge8yOqZwMduWOyKGumQ0Cg-1
X-Mimecast-MFC-AGG-ID: Ge8yOqZwMduWOyKGumQ0Cg
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-46798d74f0cso109091121cf.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:35:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737477311; x=1738082111;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5IicrbX29/PlrHURDmORDtKf+izW4RsJs/gkYLbWILo=;
        b=UBbchYjpVYHrZQ9ZZM0HO6u+HfUyn6oyalH9N6FWTO4GPnkgeg0sXr8YEC2hlbZ1uC
         AOxCJgavjnXxVcdlgi9elXeoMLkg2N26tLzDSKCgsw7kQBKjWIBuget5KvwG29XVCuov
         MWMlpl07pe1QHF2tYspBgZnrWuFVxr/NUNXet30QnkdVGE+9WlLiIDM722S7pOwwSY1Y
         W06/emQzS2Xf3iFXOBgnk6ikYYRdmkVfSMg69J5VCy95vBkAZmlJK9AbbrOllFHY3Xl4
         vdLWzFOmtm/dd9yprze8uH6Z2uhWRaDbJyyVFErF76HSmAmb8Cr5MQrUYvLQR0eYtjBO
         FMjA==
X-Forwarded-Encrypted: i=1; AJvYcCXTi9RFdhxoDtxf0RAHJ6avi3jEZH49skLHiW0jmqzahLfKRaVaWRvKoafQQVCMxr0zNZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYpkVq0jROhXOJeRfYVujKGYAvCuSuDCWcr9KAeKjjR/M9APs/
	WGyQU3r19Yg/3Gkx6iaQ/3YKaBTAwfqp4NlcbNXjHPuKXPJDCDKKS6cp9VNSmu0LneGTInCEk4w
	X05IhW7ZoWjmG3Fi1cqR8O3pjNfW67ZNOWJIy0BYkBiQ0URBcyA==
X-Gm-Gg: ASbGncvo5WyVh+cyt3F9NDSrSfmUovAPOghIOuw/QQqz95CzcY5hoy+aHyK50Xbm4cO
	QZ95/jKtRlxyKbiuXHy/aR2ZdOO4+xuZozbIUNvCrx/NuiRaUUO3BfT9u99kJKRIwFjevGnp4GQ
	t9xn85owJxjf1iwctQiTCoqEF0A0+djyUw11FcikiiYUD64qMSMYYzSf/iUvoDvC51cQHxoLp2M
	6pIzN1vkFn3JUi1DSZgzpeypwYo6J4Ip6AD6jAAyuuB130A22beb0xmyiaLaiHbsokRDXfe6IZO
	NMKqiMWY1OQzcV9Dg33En9oTdpiTkgk=
X-Received: by 2002:ac8:7f89:0:b0:46c:782f:5f6c with SMTP id d75a77b69052e-46e12b20fbamr274079471cf.14.1737477311533;
        Tue, 21 Jan 2025 08:35:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEDpP3v3NvNnq0mrgQd+4/LqRJpg4iDbCa/9Y9xWB0RMJdvo/z2nBzTqrMy4G/8FCeBpRGtw==
X-Received: by 2002:ac8:7f89:0:b0:46c:782f:5f6c with SMTP id d75a77b69052e-46e12b20fbamr274078981cf.14.1737477311163;
        Tue, 21 Jan 2025 08:35:11 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614ef236sm569680685a.108.2025.01.21.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 08:35:10 -0800 (PST)
Date: Tue, 21 Jan 2025 11:35:08 -0500
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z4_MvGSq2B4zptGB@x1n>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
 <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>
 <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com>

On Tue, Jan 21, 2025 at 09:35:26AM +0800, Chenyi Qiang wrote:
> 
> 
> On 1/21/2025 2:33 AM, Peter Xu wrote:
> > On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
> >> On 20.01.25 18:21, Peter Xu wrote:
> >>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
> >>>> Sorry, I was traveling end of last week. I wrote a mail on the train and
> >>>> apparently it was swallowed somehow ...
> >>>>
> >>>>>> Not sure that's the right place. Isn't it the (cc) machine that controls
> >>>>>> the state?
> >>>>>
> >>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
> >>>>
> >>>> Right; I consider KVM part of the machine.
> >>>>
> >>>>
> >>>>>
> >>>>>> It's not really the memory backend, that's just the memory provider.
> >>>>>
> >>>>> Sorry but is not "providing memory" the purpose of "memory backend"? :)
> >>>>
> >>>> Hehe, what I wanted to say is that a memory backend is just something to
> >>>> create a RAMBlock. There are different ways to create a RAMBlock, even
> >>>> guest_memfd ones.
> >>>>
> >>>> guest_memfd is stored per RAMBlock. I assume the state should be stored per
> >>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
> >>>>
> >>>> Now, the question is, who is the manager?
> >>>>
> >>>> 1) The machine. KVM requests the machine to perform the transition, and the
> >>>> machine takes care of updating the guest_memfd state and notifying any
> >>>> listeners.
> >>>>
> >>>> 2) The RAMBlock. Then we need some other Object to trigger that. Maybe
> >>>> RAMBlock would have to become an object, or we allocate separate objects.
> >>>>
> >>>> I'm leaning towards 1), but I might be missing something.
> >>>
> >>> A pure question: how do we process the bios gmemfds?  I assume they're
> >>> shared when VM starts if QEMU needs to load the bios into it, but are they
> >>> always shared, or can they be converted to private later?
> >>
> >> You're probably looking for memory_region_init_ram_guest_memfd().
> > 
> > Yes, but I didn't see whether such gmemfd needs conversions there.  I saw
> > an answer though from Chenyi in another email:
> > 
> > https://lore.kernel.org/all/fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com/
> > 
> > So I suppose the BIOS region must support private / share conversions too,
> > just like the rest part.
> 
> Yes, the BIOS region can support conversion as well. I think guest_memfd
> backed memory regions all follow the same sequence during setup time:
> 
> guest_memfd is shared when the guest_memfd fd is created by
> kvm_create_guest_memfd() in ram_block_add(), But it will sooner be
> converted to private just after kvm_set_user_memory_region() in
> kvm_set_phys_mem(). So at the boot time of cc VM, the default attribute
> is private. During runtime, the vBIOS can also do the conversion if it
> wants.

I see.

> 
> > 
> > Though in that case, I'm not 100% sure whether that could also be done by
> > reusing the major guest memfd with some specific offset regions.
> 
> Not sure if I understand you clearly. guest_memfd is per-Ramblock. It
> will have its own slot. So the vBIOS can use its own guest_memfd to get
> the specific offset regions.

Sorry to be confusing, please feel free to ignore my previous comment.
That came from a very limited mindset that maybe one confidential VM should
only have one gmemfd..

Now I see it looks like it's by design open to multiple gmemfds for each
VM, then it's definitely ok that bios has its own.

Do you know why the bios needs to be convertable?  I wonder whether the VM
can copy it over to a private region and do whatever it wants, e.g.  attest
the bios being valid.  However this is also more of a pure question.. and
it can be offtopic to this series, so feel free to ignore.

Thanks,

-- 
Peter Xu


