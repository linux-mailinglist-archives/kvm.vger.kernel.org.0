Return-Path: <kvm+bounces-36557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7620FA1BAD4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 907B616E7DD
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD6419CC2A;
	Fri, 24 Jan 2025 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAhrACfC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB78E552
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737169; cv=none; b=RLfKWSWZ++j0BmnCh6wvGYd4EKqS4xcTxfPrOJyC5OkpqNPVXSVO7cdTDkOAR5ZyvTlKHAsppjQIPerqqbEBFNgQgUBnecRgculbCBYagow4MnAykx4KDL1SzJredKAXGkJ1oJfl+E3ES972yWY3Ey3aW/SNXuNt0AFW0/YEaVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737169; c=relaxed/simple;
	bh=N+Mt+qTUKw/SH0UsKSJGSrCqq616EtMGkgJ8Ljk0Dww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNpcy0lf27fQVG/R55gqX1W8/U0hOcjLwJLPC4wsGgtDCVPIykGDyldRr57AGwL50t/DtdBdwlTazcIyDi5CVJygQcE2TUIk9kDg+UXTwaSsCXGQpDtfyyT+slFl6ABBpWxVe0b+bDORod70yRoyX+kLvYSYodyx7VqzvZ6g1PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WAhrACfC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737737166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=51dnXDvsNcSCF08xduw6b/Qmzvzq46UpLQCneaoBf8Y=;
	b=WAhrACfCIwSwzcHBuIi9L5+s8gqNBpSYffsZGK0W2QY/wBMUDO7wVkhxi51Rsu6E7xLT/r
	cCRN6h2obgpRdzgBkMw6UF/c4cwYgL+teMgCDAB0V1wLWt5qqdSGrrb3mIVzobkQ6Oog7y
	bPwmGr7ggXKzrOtl+Xjifioxnvphy8I=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-b72-HId4OiKgxywCaGNAQA-1; Fri, 24 Jan 2025 11:46:05 -0500
X-MC-Unique: b72-HId4OiKgxywCaGNAQA-1
X-Mimecast-MFC-AGG-ID: b72-HId4OiKgxywCaGNAQA
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-2acd587d640so1758720fac.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:46:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737737164; x=1738341964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51dnXDvsNcSCF08xduw6b/Qmzvzq46UpLQCneaoBf8Y=;
        b=ZzCsg1FbNCCLkJ/2ikyLD004jsAu501edAsiup+xL7citMFQbPcnKS9niWc19yZ25G
         SgI0eHZ8Vewcoz7lbWiFaHpYeddMxy7Ju1kNjcWhoA6LPKOBUyza+cmqarTbkB+ETxvo
         pwFuiZh06HC29kEPUyxtr31pBJBq5edexPY3YR5isURC0+70UsR1kPn204mPnn4jKcaz
         zOgUuD9Q3W36ku+RnbC/5/nElu3E8r2oJZF1ArXdSEhxRnAYvH/d/UOJB89tFP4sEqf8
         Wr1qmIDBeT5chIFL8G3p2SWL2vM4BmmJBcw0YkUG2id61UB0wHiEE5vhUij0yAbCY7Kh
         +M5g==
X-Forwarded-Encrypted: i=1; AJvYcCXVk1Y4ewc1XSraMmh4Y7Z96tMqKZG0UDephFuJAXcxh04YTbikY/VNfQcXjrvSjVYK188=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPyE2Q/v+sPjhNvk4QP02eiKrU/hvxixXJ0Vkt1ekReWQmgDiW
	Qb/RnZEtHsMTF1WmBs+Re3a29GSm6hrwS6u+YrVlSJ93zCOqrbhLHQnhEHKLhxw3l6TM1tQBEnI
	C1P0TNnUdBFqSN+aUFi0EI1Z1rvxQ4DtyoFGSNSVMwlBr9nHgPw==
X-Gm-Gg: ASbGncssEGpOTrEIazIazPQ3OQic/wz5clS+pnycS/oPtX4xIh/NgB54vAP2Tkk7XKC
	Sdqy87KnQwPvumLqFknsn1smgBAZEDE0q9K77zQvh3Im0TBGAmHrO9bYGOFPkPx1Ih8ZBi1FcQT
	bUCshj+O6RNhRDR+McMbRrDQ4EJ3FT0DBa/cXUXoHpmzP+yxNNwkSKLG1bGF6GZstGd00vq9M5i
	idm0Wt2yQ9Ek94wdAJEE+QxQm+YbwWJIYsU79E8FWugWUJinXoY8pzlOWY2q11yOVlH3AGOlF77
	v+KRQugdLgzYBe0NyqYKLKBhqRd6qNI=
X-Received: by 2002:a05:6214:19c8:b0:6d8:cff9:f373 with SMTP id 6a1803df08f44-6e1b21c4106mr427082996d6.30.1737734153271;
        Fri, 24 Jan 2025 07:55:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz9G2Pe5z23hXavPMrogrJhKCVJEtNpCmuOw2NH/cjb1ms5gHZUdf8IgcLgtK64ImsjBm57w==
X-Received: by 2002:a05:6214:19c8:b0:6d8:cff9:f373 with SMTP id 6a1803df08f44-6e1b21c4106mr427082656d6.30.1737734152916;
        Fri, 24 Jan 2025 07:55:52 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e20525abf0sm9759386d6.54.2025.01.24.07.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 07:55:52 -0800 (PST)
Date: Fri, 24 Jan 2025 10:55:49 -0500
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
Message-ID: <Z5O4BSCjlhhu4rrw@x1n>
References: <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
 <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>

On Fri, Jan 24, 2025 at 05:47:45PM +0800, Xu Yilun wrote:
> On Thu, Jan 23, 2025 at 11:47:17AM -0500, Peter Xu wrote:
> > On Thu, Jan 23, 2025 at 05:33:53PM +0800, Xu Yilun wrote:
> > > On Wed, Jan 22, 2025 at 11:43:01AM -0500, Peter Xu wrote:
> > > > On Wed, Jan 22, 2025 at 05:41:31PM +0800, Xu Yilun wrote:
> > > > > On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> > > > > > 
> > > > > > 
> > > > > > On 22/1/25 02:18, Peter Xu wrote:
> > > > > > > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > > > > > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > > > > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > > > > > > is the private MMIO would also create a memory region with
> > > > > > > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > > > > > > listener.
> > > > > > > > > > 
> > > > > > > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > > > > > > 
> > > > > > > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > > > > > > 
> > > > > > > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > > > > > > normal assigned MMIO is always set ram=true,
> > > > > > > > 
> > > > > > > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > > > > > > >                                         Object *owner,
> > > > > > > >                                         const char *name,
> > > > > > > >                                         uint64_t size,
> > > > > > > >                                         void *ptr)
> > > > 
> > > > [1]
> > > > 
> > > > > > > > {
> > > > > > > >      memory_region_init(mr, owner, name, size);
> > > > > > > >      mr->ram = true;
> > > > > > > > 
> > > > > > > > 
> > > > > > > > So I don't think ram=true is a problem here.
> > > > > > > 
> > > > > > > I see.  If there's always a host pointer then it looks valid.  So it means
> > > > > > > the device private MMIOs are always mappable since the start?
> > > > > > 
> > > > > > Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> > > > > > different at the moment. Thanks,
> > > > > 
> > > > > mm.. I'm actually expecting private MMIO not have a host pointer, just
> > > > > as private memory do.
> > > > > 
> > > > > But I'm not sure why having host pointer correlates mr->ram == true.
> > > > 
> > > > If there is no host pointer, what would you pass into "ptr" as referenced
> > > > at [1] above when creating the private MMIO memory region?
> > > 
> > > Sorry for confusion. I mean existing MMIO region use set mr->ram = true,
> > > and unmappable region (gmem) also set mr->ram = true. So don't know why
> > > mr->ram = true for private MMIO is hackish.
> > 
> > That's exactly what I had on the question in the previous email - please
> > have a look at what QEMU does right now with memory_access_is_direct().
> 
> I see memory_access_is_direct() should exclude mr->ram_device == true, which
> is the case for normal assigned MMIO and for private assigned MMIO. So
> this func is not a problem.

I'm not sure even if so.

VFIO's current use case is pretty special - it still has a host pointer,
it's just that things like memcpy() might not be always suitable to be
applied on MMIO mapped regions.  Alex explained the rational in commit
4a2e242bbb3.  I mean, the host pointer is valid even if ram_device=true in
this case.  Even if no direct access allowed (memcpy, etc.) it still
operates on the host address using ram_device_mem_ops.

> 
> But I think flatview_access_allowed() is a problem that it doesn't filter
> out the private memory. When memory is converted to private, the result
> of host access can't be what you want and should be errored out. IOW,
> the host ptr is sometimes invalid.
> 
> > I'm not 100% sure it'll work if the host pointer doesn't exist.
> > 
> > Let's take one user of it to be explicit: flatview_write_continue_step()
> > will try to access the ram pointer if it's direct:
> > 
> >     if (!memory_access_is_direct(mr, true)) {
> >         ...
> >     } else {
> >         /* RAM case */
> >         uint8_t *ram_ptr = qemu_ram_ptr_length(mr->ram_block, mr_addr, l,
> >                                                false, true);
> > 
> >         memmove(ram_ptr, buf, *l);
> >         invalidate_and_set_dirty(mr, mr_addr, *l);
> > 
> >         return MEMTX_OK;
> >     }
> > 
> > I don't see how QEMU could work yet if one MR set ram=true but without a
> > host pointer..
> > 
> > As discussed previously, IMHO it's okay that the pointer is not accessible,
> 
> Maybe I missed something in previous discussion, I assume it is OK cause
> no address_space_rw is happening on this host ptr when memory is
> private, is it?

Yes, and when there is a mapped host address and someone tries to access an
address that is bound to a private page, QEMU should get a SIGBUS.  This
code is not ready yet for gmem, but I believe it'll work like that when
in-place gmem folio conversions will be ready.  So far QEMU's gmem works by
providing two layers of memory backends, which is IMHO pretty tricky.

> 
> > but still I assume QEMU assumes the pointer at least existed for a ram=on
> > MR.  I don't know whether it's suitable to set ram=on if the pointer
> > doesn't ever exist.
> 
> In theory, any code logic should not depends on an invalid pointer. I
> think a NULL pointer would be much better than a invalid pointer, at
> least you can check whether to access. So if you think an invalid
> pointer is OK, a NULL pointer should be also OK.

Definitely not suggesting to install an invalid pointer anywhere.  The
mapped pointer will still be valid for gmem for example, but the fault
isn't.  We need to differenciate two things (1) virtual address mapping,
then (2) permission and accesses on the folios / pages of the mapping.
Here I think it's okay if the host pointer is correctly mapped.

For your private MMIO use case, my question is if there's no host pointer
to be mapped anyway, then what's the benefit to make the MR to be ram=on?
Can we simply make it a normal IO memory region?  The only benefit of a
ram=on MR is, IMHO, being able to be accessed as RAM-like.  If there's no
host pointer at all, I don't yet understand how that helps private MMIO
from working.

Thanks,

-- 
Peter Xu


