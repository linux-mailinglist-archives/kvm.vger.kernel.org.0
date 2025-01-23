Return-Path: <kvm+bounces-36405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C45A1A814
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A300188B5F8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0E2145A0F;
	Thu, 23 Jan 2025 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3v3JM0B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCBA70817
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650846; cv=none; b=ipOsuTlOgUZaabzTZYxbR6k6PvHTjFwvkdFsR5pvq0yPIOw76PCmGiY8HgA5sthYAkrj1kCsuucJ4ZYNIEUGYT/CvLiLUA3MeOJruMQ6VEaEXACd3ImVgUI6DIXl4c+yQ112P/VqLy4VGSRbpUSudbV5XZcRuer0SigVjQUHTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650846; c=relaxed/simple;
	bh=FzU9DFCVDK/71tyWXlTbJ7ELrn0v6HnB8bLULB1AwSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgddNMcmgJywEJQ/HvOPaCRNhthUKcln3DEg0SRoNoSyDaLYlSnLmsFJCZ9OVQa2uYMFUv9XgOEP1Hlq/nh1fK04kVYxX03CYFTaEIJJUptqO4ctRvb3x577a2Z8GHwvjGrhJDdEw69y5ZFqHHlgPsE9GfGWQ/+yuTwSe7YZwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3v3JM0B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737650843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+x2h8ERaFW8p89LuZnTutbaxdGV9s6TZW3q0FaXNER0=;
	b=a3v3JM0BUoAEoN2+HZRZMoLRj9Br0+FmufHC6B0dkJZyv6+VQIZYcuJutvtBbHl3ft/F3D
	VHun/3KYaPPFTRtMNgvaeG3HTuPdF7mMzw6LC0NnNKbgQCA4elOQBXT4E59FqA2xaei6PQ
	aXEbMtI6kuMTlyUavqMeBg1/y45H8Z8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-Tg_oCZtbN1yn1MPvEwNoHw-1; Thu, 23 Jan 2025 11:47:22 -0500
X-MC-Unique: Tg_oCZtbN1yn1MPvEwNoHw-1
X-Mimecast-MFC-AGG-ID: Tg_oCZtbN1yn1MPvEwNoHw
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6f1595887so168637885a.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:47:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737650841; x=1738255641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+x2h8ERaFW8p89LuZnTutbaxdGV9s6TZW3q0FaXNER0=;
        b=YqubGBoYV8WSAi9WUjDjzbNrLMkt+p53jt3wznvigQb4/Vwhh9n48Jqm+sDdUma89g
         P4cHlRqUeywvIBIfLQgltCACePPUwSXIhiUtRACsn2yR3ma5gu9t171AtUfgud+bbqpk
         cLTLbTzZNAt7WbunJC3OsQXYugXE6z3AEW8th9Xe4LEQphSaLpT/0Z4y7cvqA1b9BN7L
         Dubv2wJrIkBb43kFrxqbbs/kijMiIl4CKGD2ILQYDQaT3BBGFZVV7q3hX6eVRVKSCzOo
         3RLkhOvZckV++4p/kEsILZvx2XJBJydVHtFk6IawyhWjpecZa8jSM0UDjD8gMfJn3kW1
         l/vw==
X-Forwarded-Encrypted: i=1; AJvYcCUjpKfpZXw0VlW2VNAvzqSyPIoLCaCjlhUheDASJhlEtbm/D1iYfLGlF26f8OTlKO1mKPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7SNTLqSjjDL5gxfkZHRF/6mLaBKREEggTym25HQVccRyehclY
	DLde+wcYgOovSChg9DMavxxNeWOLrqaACpLfWYXFCtUBOAYQCgaYp8pHgoOn6td1dcmuYBCjwc3
	5lRQQFk5Ituu5vk8JE0JY5xpYi8rBbNwmKdfYQdxQrdl5t7JPQayLq5C+2w==
X-Gm-Gg: ASbGncvEEQkwxaWpav8psUehApJXTOKTiHO8uyPcWRsjAvA5qjjIQTv/ZALZj76JyYS
	PPnGe0ncPerMZdj+GJc+UddV6C7wvCvI9r+Jw73ScvR/YQNFthQZF88qurqd3E10bg/yKgQVRNR
	MERr7I2M9nHu8FeaFIdkvo1B8ZQEc2fsPS7SGLL8YS2Q3KyjF4DYElqtPz30AjvT1R4qc0PU1Wc
	/by0vouCsoiv3ib8Tg/8MFTNcDRkczggME1o0ZEfiPpqDigoB3lhsyjiF9Yqgy3hK7RNGF3+VtU
	cg428S/Wrt2fOc4dFTDpgBGo20YoGrI=
X-Received: by 2002:ac8:7d50:0:b0:466:9bc4:578 with SMTP id d75a77b69052e-46e12a5eacfmr325293281cf.22.1737650841415;
        Thu, 23 Jan 2025 08:47:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZdgyatydQjnPIgqHbXi7K9pY0F2gta/w5TjMk6hnXXzDTtDY+5ejWIezOCpes/HsmGFvnXA==
X-Received: by 2002:ac8:7d50:0:b0:466:9bc4:578 with SMTP id d75a77b69052e-46e12a5eacfmr325292961cf.22.1737650840971;
        Thu, 23 Jan 2025 08:47:20 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e66b67951sm559541cf.58.2025.01.23.08.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 08:47:20 -0800 (PST)
Date: Thu, 23 Jan 2025 11:47:17 -0500
From: Peter Xu <peterx@redhat.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5Jylb73kDJ6HTEZ@x1n>
References: <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>

On Thu, Jan 23, 2025 at 05:33:53PM +0800, Xu Yilun wrote:
> On Wed, Jan 22, 2025 at 11:43:01AM -0500, Peter Xu wrote:
> > On Wed, Jan 22, 2025 at 05:41:31PM +0800, Xu Yilun wrote:
> > > On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> > > > 
> > > > 
> > > > On 22/1/25 02:18, Peter Xu wrote:
> > > > > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > > > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > > > > is the private MMIO would also create a memory region with
> > > > > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > > > > listener.
> > > > > > > > 
> > > > > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > > > > 
> > > > > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > > > > 
> > > > > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > > > > normal assigned MMIO is always set ram=true,
> > > > > > 
> > > > > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > > > > >                                         Object *owner,
> > > > > >                                         const char *name,
> > > > > >                                         uint64_t size,
> > > > > >                                         void *ptr)
> > 
> > [1]
> > 
> > > > > > {
> > > > > >      memory_region_init(mr, owner, name, size);
> > > > > >      mr->ram = true;
> > > > > > 
> > > > > > 
> > > > > > So I don't think ram=true is a problem here.
> > > > > 
> > > > > I see.  If there's always a host pointer then it looks valid.  So it means
> > > > > the device private MMIOs are always mappable since the start?
> > > > 
> > > > Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> > > > different at the moment. Thanks,
> > > 
> > > mm.. I'm actually expecting private MMIO not have a host pointer, just
> > > as private memory do.
> > > 
> > > But I'm not sure why having host pointer correlates mr->ram == true.
> > 
> > If there is no host pointer, what would you pass into "ptr" as referenced
> > at [1] above when creating the private MMIO memory region?
> 
> Sorry for confusion. I mean existing MMIO region use set mr->ram = true,
> and unmappable region (gmem) also set mr->ram = true. So don't know why
> mr->ram = true for private MMIO is hackish.

That's exactly what I had on the question in the previous email - please
have a look at what QEMU does right now with memory_access_is_direct().
I'm not 100% sure it'll work if the host pointer doesn't exist.

Let's take one user of it to be explicit: flatview_write_continue_step()
will try to access the ram pointer if it's direct:

    if (!memory_access_is_direct(mr, true)) {
        ...
    } else {
        /* RAM case */
        uint8_t *ram_ptr = qemu_ram_ptr_length(mr->ram_block, mr_addr, l,
                                               false, true);

        memmove(ram_ptr, buf, *l);
        invalidate_and_set_dirty(mr, mr_addr, *l);

        return MEMTX_OK;
    }

I don't see how QEMU could work yet if one MR set ram=true but without a
host pointer..

As discussed previously, IMHO it's okay that the pointer is not accessible,
but still I assume QEMU assumes the pointer at least existed for a ram=on
MR.  I don't know whether it's suitable to set ram=on if the pointer
doesn't ever exist.

> 
> I think We could add another helper to create memory region for private
> MMIO.
> 
> > 
> > OTOH, IIUC guest private memory finally can also have a host pointer (aka,
> > mmap()-able), it's just that even if it exists, accessing it may crash QEMU
> > if it's private.
> 
> Not sure if I get it correct: when memory will be converted to private, QEMU
> should firstly unmap the host ptr, which means host ptr doesn't alway exist.

At least current QEMU doesn't unmap it? 

kvm_convert_memory() does ram_block_discard_range() indeed, but that's hole
punches, not unmap.  So the host pointer can always be there.

Even if we could have in-place gmemfd conversions in the future for guest
mem, we should also need the host pointer to be around, in which case (per
my current understand) it will even avoid hole punching but instead make
the page accessible (by being able to be faulted in).

Thanks,

-- 
Peter Xu


