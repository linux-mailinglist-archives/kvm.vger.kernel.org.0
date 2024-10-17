Return-Path: <kvm+bounces-29085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F17F59A25CC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20FBA1C20F66
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5BD1DE8AC;
	Thu, 17 Oct 2024 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9XKfRqi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A251DE894
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 14:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729177118; cv=none; b=reY1jCRyFT1zfv0k7LtHWcgJQn17juYlJH8LQ2dVKRBIZ67aPF85n9+bbuEfrQB/khhoiL4CvVxpYN4cmM6fZ8qvMwMoF/aeMkeQ3ilC6YPoopuddr5mcUp05/HiHaPqtbcfwPfqb02OM65AqGg4h/IwNtsoqoFv03vZdTbslbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729177118; c=relaxed/simple;
	bh=cTfpSWPvtLN/e0p/+/g3EwaPmnW8/HF+Jz7l/jqvOO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXfiXUGIihGGC4IrbU80sYNqy3mmqx5B1jTegDFs0N7d1aeULaivJe/4hHJkz0BxV2Pgv3tX15SsZTzdpo6+KiO4brnMht5RjNF5TOn79bJI3rVBbrn8LAcKPkcGJNjNN9NQF6YbIBli9RjExUvQxQxvnJ6eyflQSnIRyZn0rTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9XKfRqi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729177116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YeuRkHE7ropmdcbR4Cq1Ya+ydc0Cmu/su/zFW+YnyjY=;
	b=Y9XKfRqihOZQsq3Kh9NHpSrhGVveMTjYPiaWWDWX8q4Ejqs7vDDATHKsLVlhpjDAcGOQv+
	4uDI6qGIBg4pzhpWxbzYis66X5QDyfA8mFQcM4iWkYub4TXd++kfFkw6bMB8pzWLvKEumT
	4ZsgMDTFW1Ln0YIlk5qyBg1YFdux2SI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-5_XMcqqINxCl2AJny5KdoA-1; Thu, 17 Oct 2024 10:58:35 -0400
X-MC-Unique: 5_XMcqqINxCl2AJny5KdoA-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-716a7c1cd30so795811a34.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 07:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729177114; x=1729781914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeuRkHE7ropmdcbR4Cq1Ya+ydc0Cmu/su/zFW+YnyjY=;
        b=K345O6NJ5nlSuweQN0w+UXrehpLX6YWsZZDl5YY2DJ1kZx+dpNYIQvFTXsX/baH/0g
         uWQdeAFmYt11MzWo8iPO1tlcrECEVL3548McSugTFXulF8Slf4fXncZrz+AWn8YuPW6K
         +sNUZ5OQjuUayLNrwG77iAzynwLpYnuTaBkeevcoNiwNKc8WSNMgIS3TxasoPS09DEpw
         bZVfUMnDLEZYg3ffEc38pp7Y8ET9DGMKZtwkSAaaLmVRwdT9qdksUIN1GURAKAZOrXg+
         BEEaRJIwgLE8Ya21/QKWDMwEJPwba4g4AY9nHsx72qaehefWC0oCek7Pgc/B2P8JG3Fy
         YQSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDvIQuOOoDsOO4AOzGegnMzOAa60PFS4I+hpMw1w/RJRoCSbi0Q4mrWWpABSyzjV2RzUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YySZsGDUOr2yy8DSxcINiSofdW4+x2zR5B0aHll+n6Xsmc4z5hg
	PiuxAG+YC6BZ035sON54wv1PZhazKJoT/hb3Hkh4phuyoNrrfY72U9es62kFQsTEARgPd585cDo
	DguYKbTusVJIvtkRRwHseZsNQugoNLLcq/PsgTxRqpbtK87aNaA==
X-Received: by 2002:a05:6359:8004:b0:1c3:8643:7f05 with SMTP id e5c5f4694b2df-1c386438253mr210465455d.28.1729177114346;
        Thu, 17 Oct 2024 07:58:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuZSic+RIPKM1fxR2iF8bnthSep4CnGMyoY4sLA5CNzt7oJ7XBOHxPnKDiMbmM7UyruxT0DA==
X-Received: by 2002:a05:6359:8004:b0:1c3:8643:7f05 with SMTP id e5c5f4694b2df-1c386438253mr210461955d.28.1729177113968;
        Thu, 17 Oct 2024 07:58:33 -0700 (PDT)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cc22911c5bsm28610376d6.28.2024.10.17.07.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 07:58:33 -0700 (PDT)
Date: Thu, 17 Oct 2024 10:58:29 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>, tabba@google.com,
	quic_eberman@quicinc.com, roypat@amazon.co.uk, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com,
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org,
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev,
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com,
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com,
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com,
	pgonda@google.com, oliver.upton@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
Message-ID: <ZxEmFY1FcrRtylJW@x1n>
References: <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>
 <Zwf7k1wmPqEEaRxz@x1n>
 <diqz8quunrlw.fsf@ackerleytng-ctop.c.googlers.com>
 <Zw7f3YrzqnH-iWwf@x1n>
 <diqz1q0hndb3.fsf@ackerleytng-ctop.c.googlers.com>
 <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com>
 <ZxAfET87vwVwuUfJ@x1n>
 <20241016225157.GQ3559746@nvidia.com>
 <ZxBRC-v9w7xS0xgk@x1n>
 <20241016235424.GU3559746@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241016235424.GU3559746@nvidia.com>

On Wed, Oct 16, 2024 at 08:54:24PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 16, 2024 at 07:49:31PM -0400, Peter Xu wrote:
> > On Wed, Oct 16, 2024 at 07:51:57PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Oct 16, 2024 at 04:16:17PM -0400, Peter Xu wrote:
> > > > 
> > > > Is there chance that when !CoCo will be supported, then external modules
> > > > (e.g. VFIO) can reuse the old user mappings, just like before gmemfd?
> > > > 
> > > > To support CoCo, I understand gmem+offset is required all over the places.
> > > > However in a non-CoCo context, I wonder whether the other modules are
> > > > required to stick with gmem+offset, or they can reuse the old VA ways,
> > > > because how it works can fundamentally be the same as before, except that
> > > > the folios now will be managed by gmemfd.
> > > 
> > > My intention with iommufd was to see fd + offest as the "new" way
> > > to refer to all guest memory and discourage people from using VMA
> > > handles.
> > 
> > Does it mean anonymous memory guests will not be supported at all for
> > iommufd?
> 
> No, they can use the "old" way with normal VMA's still, or they can
> use an anonymous memfd with the new way..
> 
> I just don't expect to have new complex stuff built on the VMA
> interface - I don't expect guestmemfd VMAs to work.

Yes, if with guestmemfd already we probably don't need to bother on the VA
interface.

It's the same when guestmemfd supports KVM_SET_USER_MEMORY_REGION2 already,
then it's not a problem at all to use fd+offset for this KVM API.

My question was more torwards whether gmemfd could still expose the
possibility to be used in VA forms to other modules that may not support
fd+offsets yet.  And I assume your reference on the word "VMA" means "VA
ranges", while "gmemfd VMA" on its own is probably OK?  Which is proposed
in this series with the fault handler.

It may not be a problem to many cloud providers, but if QEMU is involved,
it's still pretty flexible and QEMU will need to add fd+offset support for
many of the existing interfaces that is mostly based on VA or VA ranges.  I
believe that includes QEMU itself, aka, the user hypervisor (which is about
how user app should access shared pages that KVM is fault-allowed),
vhost-kernel (more GUP oriented), vhost-user (similar to userapp side),
etc.

I think as long as we can provide gmemfd VMAs like what this series
provides, it sounds possible to reuse the old VA interfaces before the CoCo
interfaces are ready, so that people can already start leveraging gmemfd
backing pages.

The idea is in general nice to me - QEMU used to have a requirement where
we want to have strict vIOMMU semantics between QEMU and another process
that runs the device emulation (aka, vhost-user).  We didn't want to map
all guest RAM all the time because OVS bug can corrupt QEMU memory until
now even if vIOMMU is present (which should be able to prevent this, only
logically..).  We used to have the idea that we can have one fd sent to
vhost-user process that we can have control of what is mapped and what can
be zapped.

In this case of gmemfd that is mostly what we used to persue already
before, that:

  - It allows mmap() of a guest memory region (without yet the capability
    to access all of them... otherwise it can bypass protection, no matter
    it's for CoCo or a vIOMMU in this case)

  - It allows the main process (in this case, it can be QEMU/KVM or
    anything/KVM) to control how to fault in the pages, in this case gmemfd
    lazily faults in the pages only if they're falutable / shared

  - It allows remote tearing down of pages that were not faultable / shared
    anymore, which guarantees the safety measure that the other process
    cannot access any page that was not authorized

I wonder if it's good enough even for CoCo's use case, where if anyone
wants to illegally access some page, it'll simply crash.

Besides that, we definitely can also have good use of non-CoCo 1G pages on
either postcopy solution (that James used to work on for HGM), or
hwpoisoning (where currently at least the latter one is, I believe, still a
common issue for all of us, to make hwpoison work for hugetlbfs with
PAGE_SIZE granule [1]).  The former issue will be still required at least
for QEMU to leverage the split-abliity of gmemfd huge folios.

Then even if both KVM ioctls + iommufd ioctls will only support fd+offsets,
as long as it's allowed to be faultable and gupped on the shared portion of
the gmemfd folios, they can start to be considered using to replace hugetlb
to overcome those difficulties even before CoCo is supported all over the
places.  There's also a question on whether all the known modules would
finally support fd+offsets, which I'm not sure.  If some module won't
support it, maybe it can still work with gmemfd in VA ranges so that it can
still benefit from what gmemfd can provide.

So in short, not sure if the use case can use a combination of (fd, offset)
interfacing on some modules like KVM/iommufd, but VA ranges like before on
some others.

Thanks,

[1] https://lore.kernel.org/all/20240924043924.3562257-1-jiaqiyan@google.com/

-- 
Peter Xu


