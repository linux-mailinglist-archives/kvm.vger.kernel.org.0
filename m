Return-Path: <kvm+bounces-36182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49998A18610
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC6D3AC396
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5061F7071;
	Tue, 21 Jan 2025 20:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inKIVjfK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D94594A
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737490919; cv=none; b=tTHDDZ06q0HGBxL+19SPrF6xnkWfPLnSBMbsArKhfLgc3UR60pmtb0NEZtHJkHN++tNOcUCtbajSBVqgYkIrVKgr8JQZPZFYGAFICJDFkI8ValyB4qK+0pE0u9YrP1fYX0Y7YQMzkdhIOc06w50nhOQYADH5OavI6IWmZBv/6aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737490919; c=relaxed/simple;
	bh=wwhBJrieHVQ9hn8Ti3aCGQKSKhy/3rKh10YhOEOsrEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5Q24MA5Hh5JyMwibpMY68U9DB/xTdEQEteeFOXpg97HANEy0/OHsD3aHYGWFgFvmHK3lj65sJkx5UiMplRAG+AZM/Mg+7au+YjpNiXxIs4agN0+HCAo+MQ8o4X792IVsa/y1TxcIiMqKPmXP626D2rqOgsnVI6CXcveKIQ+sWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inKIVjfK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737490915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mt99Q6PTtiVRyEYeMJowEAmD8Ow8/OY0SKvysNI4H7s=;
	b=inKIVjfKdymgmZYkd0h48BVw15meCsXAWvgDAZYRNKXs2aVmZ5eHnW461VmNcGhr5ZprhO
	/GtG6jn9HF2RlD5zp8ns5iHZjo2DJnGklwTdcANnmRPAoPrlPRHBLpX5UBizZVEELV5bon
	C45pp2C/1+nCkd8dzitLIXszjYg4QdQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-5cpbMIZlPwGnXeAsvGuM1g-1; Tue, 21 Jan 2025 15:21:53 -0500
X-MC-Unique: 5cpbMIZlPwGnXeAsvGuM1g-1
X-Mimecast-MFC-AGG-ID: 5cpbMIZlPwGnXeAsvGuM1g
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-46796f4d7c8so103629171cf.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737490913; x=1738095713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mt99Q6PTtiVRyEYeMJowEAmD8Ow8/OY0SKvysNI4H7s=;
        b=BgG8sNUTHyPHFXDDsnM7Io0tsilz75/8hEx2/zB/JtcCMfgZ28dM+Jv7/gsNH7LywC
         IZMEy7Oxi8cIFF+yRfA23yTIpuEzAKlhFt1y2U++PT9zBvrO1SMZ4JYRrYFhBQvVWcaH
         O5LQFIYJ7/9PUCnhpnQYPYtcrVVUBkOsUaaUuqc9lmCdKuLcWuDH1Tmzob+msNQMCXVy
         insZ3xGvgXNr7ERF6Fz4U2e+aWeFY1VrAhf0uL+A4NGQCnkUFwGredynsv4rEtrZRWRk
         Vp6vKRLH3v24/n8grCe9hkF7570VUeTRe9ESe8oYIemYopRr/qyje9hN1BldYw6JICx1
         RIPA==
X-Forwarded-Encrypted: i=1; AJvYcCUeZc5u5NwftGfFUJm22aK5rR7meLdAMygP2zLyhLpHg0qhb79zqEDlkhruBpE6N+hLVak=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsenUPf2iXm83j87oCajj0XrLol1Aj4IOqsFWpW1hnn8iOiHlR
	TonXVNJq2yhL4c1rlqJafSNwE8T4Zjkn4s0cDCt1ymqP0f+duKILbKy7X4dmbnzZ/Yrj2HyIJge
	L0Ymj3TzQ0EIAnzVorKGrjzuBLvuBiWsLdwntr2utga/J+MfO0g==
X-Gm-Gg: ASbGnct2QYtfabLhzvHFOTuyll/lCwf2bRErFubwvLZlbSSSwNvw2N74B2FIEuHHTi2
	AEEe06OtFoXwjjHwafUKPrp2J13TWnK9iBl+7eOM2fkR1IubS3ziDOcm+8W3mL88KKibW2/bicD
	dR+FZ9VrhA4gHVgaPoxBjT8I4zpO6V4221BGgVBg2SUjunyTUPlXqzbJyqHvwpoErBV2CjaQ6Zr
	3HBn55kDr6a+jRu6iCYCmtuOU1hUFhp2fp70iroeEuPrBxW4Lo197ZBbaSbaDiCvNKpkfaXQhLF
	80mKBUOUuUDUh3yHwtWoTRTDOBT2S2g=
X-Received: by 2002:a05:622a:1116:b0:467:59f6:3e56 with SMTP id d75a77b69052e-46e12b56ef7mr286167171cf.36.1737490913036;
        Tue, 21 Jan 2025 12:21:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhKqh/niV03ikVCafvYgoRQT21WqQAnCgYjazIyuuJxjrOz+2e+gwnsOhhs8U6ygSh0qOixw==
X-Received: by 2002:a05:622a:1116:b0:467:59f6:3e56 with SMTP id d75a77b69052e-46e12b56ef7mr286166701cf.36.1737490912642;
        Tue, 21 Jan 2025 12:21:52 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e102eeafcsm56434351cf.16.2025.01.21.12.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 12:21:51 -0800 (PST)
Date: Tue, 21 Jan 2025 15:21:49 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest
 memfd via MachineState
Message-ID: <Z5AB3SlwRYo19dOa@x1n>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com>
 <Z4_b3Lrpbnyzyros@x1n>
 <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com>

On Tue, Jan 21, 2025 at 07:24:29PM +0100, David Hildenbrand wrote:
> On 21.01.25 18:39, Peter Xu wrote:
> > On Wed, Mar 20, 2024 at 03:39:03AM -0500, Michael Roth wrote:
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > 
> > > Add a new member "guest_memfd" to memory backends. When it's set
> > > to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
> > > guest_memfd will be allocated during RAMBlock allocation.
> > > 
> > > Memory backend's @guest_memfd is wired with @require_guest_memfd
> > > field of MachineState. It avoid looking up the machine in phymem.c.
> > > 
> > > MachineState::require_guest_memfd is supposed to be set by any VMs
> > > that requires KVM guest memfd as private memory, e.g., TDX VM.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > ---
> > > Changes in v4:
> > >   - rename "require_guest_memfd" to "guest_memfd" in struct
> > >     HostMemoryBackend;	(David Hildenbrand)
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >   backends/hostmem-file.c  | 1 +
> > >   backends/hostmem-memfd.c | 1 +
> > >   backends/hostmem-ram.c   | 1 +
> > >   backends/hostmem.c       | 1 +
> > >   hw/core/machine.c        | 5 +++++
> > >   include/hw/boards.h      | 2 ++
> > >   include/sysemu/hostmem.h | 1 +
> > >   7 files changed, 12 insertions(+)
> > > 
> > > diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
> > > index ac3e433cbd..3c69db7946 100644
> > > --- a/backends/hostmem-file.c
> > > +++ b/backends/hostmem-file.c
> > > @@ -85,6 +85,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
> > >       ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
> > >       ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
> > >       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> > > +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
> > >       ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
> > >       ram_flags |= RAM_NAMED_FILE;
> > >       return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
> > > diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
> > > index 3923ea9364..745ead0034 100644
> > > --- a/backends/hostmem-memfd.c
> > > +++ b/backends/hostmem-memfd.c
> > > @@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
> > >       name = host_memory_backend_get_name(backend);
> > >       ram_flags = backend->share ? RAM_SHARED : 0;
> > >       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> > > +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
> > >       return memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
> > >                                             backend->size, ram_flags, fd, 0, errp);
> > >   }
> > > diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
> > > index d121249f0f..f7d81af783 100644
> > > --- a/backends/hostmem-ram.c
> > > +++ b/backends/hostmem-ram.c
> > > @@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
> > >       name = host_memory_backend_get_name(backend);
> > >       ram_flags = backend->share ? RAM_SHARED : 0;
> > >       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> > > +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
> > >       return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
> > >                                                     name, backend->size,
> > >                                                     ram_flags, errp);
> > 
> > These change look a bit confusing to me, as I don't see how gmemfd can be
> > used with either file or ram typed memory backends..
> 
> I recall that the following should work:
> 
> "private" memory will come from guest_memfd, "shared" (as in, accessible by
> the host) will come from anonymous memory.
> 
> This "anon" memory cannot be "shared" with other processes, but
> virtio-kernel etc. can just use it.
> 
> To "share" the memory with other processes, we'd need memfd/file.

Ah OK, thanks David.  Is this the planned long term solution for
vhost-kernel?

I wonder what happens if vhost tries to DMA to a region that is private
with this setup.

AFAIU, it'll try to DMA to the fake address of ramblock->host that is
pointing to by the memory backend (either anon, shmem, file, etc.).  The
ideal case IIUC is it should crash QEMU because it's trying to access an
illegal page which is private. But if with this model, it won't crash but
silently populate some page in the non-gmemfd backend.

Is that expected?

> 
> > 
> > When specified gmemfd=on with those, IIUC it'll allocate both the memory
> > (ramblock->host) and gmemfd, but without using ->host.  Meanwhile AFAIU the
> > ramblock->host will start to conflict with gmemfd in the future when it
> > might be able to be mapp-able (having valid ->host).
> 
> These will require a new guest_memfd memory backend (I recall that was
> discussed a couple of times).

Do you know if anyone is working on this one?

> 
> > 
> > I have a local fix for this (and actually more than below.. but starting
> > from it), I'm not sure whether I overlooked something, but from reading the
> > cover letter it's only using memfd backend which makes perfect sense to me
> > so far.
> 
> Does the anon+guest_memfd combination not work or are you speculating about
> the usability (which I hopefully addressed above).

IIUC, if with above solution and with how QEMU interacts memory convertions
right now, at least hugetlb pages will suffer from double allocation, as
kvm_convert_memory() won't free hugetlb pages even if converted to private.

It sounds like also doable (and also preferrable..) that for each of the VM
we always stich with pages in the gmemfd page cache, no matter if it's
shared or private.  For private, we could zap all pgtables and sigbus any
faults afterwards.  I thought that was always the plan, but I could lose
many latest informations..

Thanks,

-- 
Peter Xu


