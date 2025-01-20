Return-Path: <kvm+bounces-36060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7ECA172B0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 19:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 992AB3A8441
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CAB1EE03B;
	Mon, 20 Jan 2025 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAFREQ6U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E515C14B
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737398004; cv=none; b=N46veqHiJN3L81lCo0mac+S4EccHQSZO7WBd+N+d5vHQnv5arQyzCt4FhvJVrJ/DUpIeV21lE8++SuXv76l3CKOVxNkK+OkdFasizMInX8D1VQQFolWRXpSym9UyuowHvDbQ6bp0oVgvMN4ztc+sjQ0OHnf2YgHZh5TAUTczdlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737398004; c=relaxed/simple;
	bh=q8bdC3Hu9NTJkw8LDkLlYIzjxCHdZOdxl6KVm2p/nx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWNvKpXFNS4UMPkKilofoCa2G4mQfneVVyHHXr2VmG3Y2RcBJAv9N4ZwQcHGIiwhWQrT5gMFhSj7fi3hXOSWl85A/mZg+R2DrTmEqgS3QNnPWclm8VkWd0ckmEQLcUQOTFKrxrnS8BVPzwfJKweN4ZD3kgiom7lQmOnjNIb/2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAFREQ6U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737398001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aM4yh0+VbSepU7uunJEpWr7/he49rP8M1CCdvoDaS84=;
	b=RAFREQ6U7vC2nG9lqbjAb0giMTdK58VChALQCdAHJsxTcz50csPJl5Mg5OsimHwfDxdOZZ
	NQX+EmmLWnX/Slyuhj0ysiKnSoQtLkbzy6xW4AmTUvij1Y3bndSzsrknf1HfRMu9HWxb9Y
	xslYNxhG0Sius+4QU4DwymxFZ2OSZRk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-MCM8_WxVM9iP27iJFEbZAw-1; Mon, 20 Jan 2025 13:33:20 -0500
X-MC-Unique: MCM8_WxVM9iP27iJFEbZAw-1
X-Mimecast-MFC-AGG-ID: MCM8_WxVM9iP27iJFEbZAw
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e1b8065ed4so60731016d6.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737397999; x=1738002799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aM4yh0+VbSepU7uunJEpWr7/he49rP8M1CCdvoDaS84=;
        b=SKHgOvfvlPZ3Re+QS6o8zOGSwSS8UcCsRmfvT2bfve0sbMQ4G6lqn1XJcWDhy8KKHy
         3DmtJnLMnaeCCT2LUKyebOqurJdtJbynHZAb5LvtDieyI7j2GEWlRPPz3VDpM2SqVN75
         FmUckFSNnwx/q+v9Q0aOdx9oEfnfBFV3D4M8vmHDOvOFipKPinQfj77N6P18lqQouzDR
         k89F5rM7B7nTYqO5l9vl+bD8Ge6dtKvmYgltosLlJLxXDqZ9IfIJQGU5QjzrECIqQPAC
         3bsS5esjcWbi7ipPQwmRmbvOgBfTqQLi4zwq1POuQsnHIFvWkGQQDd15IeQNyqg+Mycu
         JB7w==
X-Forwarded-Encrypted: i=1; AJvYcCWNHtRZ38xaYunm4SbjplwBbZJ361XAXugMoVwEkdbse3UTPCkYGf4Gv4JXryKn7iDXmC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzXlC5cgj7jD8jCXtc1rnbKnYqebvVp4O853s3gPe3ojmSlLGx
	0aZ+v63l1w3lPrYnseZuNaCviYmia9OkL/y3ijH7HBv81Wf0JVP3yG1+EOWa14ImbwicHdKvc4C
	U3J4ZC5bXD4W4LzOnjLBfJn8rIy6SQ5t5uHKDW/qWxg31cKIDJg==
X-Gm-Gg: ASbGnctkAcpK0zdUGyl/FMFyKNExzRb9DtuKgyu7h/WIovNHHKm8J+RFpPFWcCSe8MO
	fLoEwvkUnQFhxkQEebPDsYp0cHHIndHZOtx5IKE9NdZPq8GBdpRZvwMlYl7SX6iammLw5mpBMCN
	L88ZeVi+B4vTRnvar9K+NmfPdFTC14Rlf4fLX7Si15IIUhnnPIyWnEVF4ZPXFRkf5iSMg4IJ4P4
	pFF3jlh0s22spmLKmI5YA4wO9cTXPwfDvfzctLreJyAgkSwSlD3CADLC47ODiLDKpp+dqXDFBmK
	btJ1Su07Zmjy+ouenVdomphaKWx+8dE=
X-Received: by 2002:a05:6214:e4d:b0:6d3:65ad:af2f with SMTP id 6a1803df08f44-6e1b217a5e7mr174103036d6.16.1737397999639;
        Mon, 20 Jan 2025 10:33:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBSfqBz0nwd7lGheZJNvjpjuH55KhUHRvq1O+paABvGDhjd4N4YWtUHv11+y5PvvRoIZ8ogw==
X-Received: by 2002:a05:6214:e4d:b0:6d3:65ad:af2f with SMTP id 6a1803df08f44-6e1b217a5e7mr174102756d6.16.1737397999325;
        Mon, 20 Jan 2025 10:33:19 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1cc9e8b54sm20246006d6.86.2025.01.20.10.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 10:33:18 -0800 (PST)
Date: Mon, 20 Jan 2025 13:33:16 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z46W7Ltk-CWjmCEj@x1n>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
 <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>

On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
> On 20.01.25 18:21, Peter Xu wrote:
> > On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
> > > Sorry, I was traveling end of last week. I wrote a mail on the train and
> > > apparently it was swallowed somehow ...
> > > 
> > > > > Not sure that's the right place. Isn't it the (cc) machine that controls
> > > > > the state?
> > > > 
> > > > KVM does, via MemoryRegion->RAMBlock->guest_memfd.
> > > 
> > > Right; I consider KVM part of the machine.
> > > 
> > > 
> > > > 
> > > > > It's not really the memory backend, that's just the memory provider.
> > > > 
> > > > Sorry but is not "providing memory" the purpose of "memory backend"? :)
> > > 
> > > Hehe, what I wanted to say is that a memory backend is just something to
> > > create a RAMBlock. There are different ways to create a RAMBlock, even
> > > guest_memfd ones.
> > > 
> > > guest_memfd is stored per RAMBlock. I assume the state should be stored per
> > > RAMBlock as well, maybe as part of a "guest_memfd state" thing.
> > > 
> > > Now, the question is, who is the manager?
> > > 
> > > 1) The machine. KVM requests the machine to perform the transition, and the
> > > machine takes care of updating the guest_memfd state and notifying any
> > > listeners.
> > > 
> > > 2) The RAMBlock. Then we need some other Object to trigger that. Maybe
> > > RAMBlock would have to become an object, or we allocate separate objects.
> > > 
> > > I'm leaning towards 1), but I might be missing something.
> > 
> > A pure question: how do we process the bios gmemfds?  I assume they're
> > shared when VM starts if QEMU needs to load the bios into it, but are they
> > always shared, or can they be converted to private later?
> 
> You're probably looking for memory_region_init_ram_guest_memfd().

Yes, but I didn't see whether such gmemfd needs conversions there.  I saw
an answer though from Chenyi in another email:

https://lore.kernel.org/all/fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com/

So I suppose the BIOS region must support private / share conversions too,
just like the rest part.

Though in that case, I'm not 100% sure whether that could also be done by
reusing the major guest memfd with some specific offset regions.

> 
> > 
> > I wonder if it's possible (now, or in the future so it can be >2 fds) that
> > a VM can contain multiple guest_memfds, meanwhile they request different
> > security levels. Then it could be more future proof that such idea be
> > managed per-fd / per-ramblock / .. rather than per-VM. For example, always
> > shared gmemfds can avoid the manager but be treated like normal memories,
> > while some gmemfds can still be confidential to install the manager.
> 
> I think all of that is possible with whatever design we chose.
> 
> The situation is:
> 
> * guest_memfd is per RAMBlock (block->guest_memfd set in ram_block_add)
> * Some RAMBlocks have a memory backend, others do not. In particular,
>   the ones calling memory_region_init_ram_guest_memfd() do not.
> 
> So the *guest_memfd information* (fd, bitmap) really must be stored per
> RAMBlock.
> 
> The question *which object* implements the RamDiscardManager interface to
> manage the RAMBlocks that have a guest_memfd.
> 
> We either need
> 
> 1) Something attached to the RAMBlock or the RAMBlock itself. This
>    series does it via a new object attached to the RAMBlock.
> 2) A per-VM entity (e.g., machine, distinct management object)
> 
> In case of 1) KVM looks up the RAMBlock->object to trigger the state change.
> That object will inform all listeners.
> 
> In case of 2) KVM calls the per-VM entity (e.g., guest_memfd manager), which
> looks up the RAMBlock and triggers the state change. It will inform all
> listeners.

(after I finished reading the whole discussion..)

Looks like Yilun raised another point, on how to reuse the same object for
device TIO support here (conversions for device MMIOs):

https://lore.kernel.org/r/https://lore.kernel.org/all/Z4RA1vMGFECmYNXp@yilunxu-OptiPlex-7050/

Thanks,

-- 
Peter Xu


