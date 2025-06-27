Return-Path: <kvm+bounces-51005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05203AEBB79
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F40E616C6C2
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169C82E92B0;
	Fri, 27 Jun 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bC5xhPrn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795DF2E8DE8
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751037470; cv=none; b=qSXu3VrwzGLgXy77gvFnfIBcQc9R80EVLOb8wm9UD3RKoUG9Bp8bXpUVLnwfSZnU5WyewZfZZmWnNq9LcIWwg24l2eNERDeMX1k8ORJce20g9cLSWPxqWvcSsNouqWBLF6fdBIQhpluGE+fd3YEPDQjM32vZTWbfCvL9O8/9I9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751037470; c=relaxed/simple;
	bh=duqGKW964qjNwuxPqetVf/TrjZYvTw13+ovFDc1dkxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XgMsTRYZg2HEwzEBxhk5ErZJGXyzNkWJwT59nG0n0S6CsD4uGa5/1EOpIEawENLd7LaZqYqRlEWVhQ0pcNCeWiBffgRY8P61B6YUgpeYPJDOIG6DzoKYh3dPxTKOC1M6stxvcgIh7swS12MPKmuvCO9FJkzbW6QoJ1hXV9ZwRMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bC5xhPrn; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3de210e6076so150445ab.1
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 08:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751037467; x=1751642267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ctaq7Efseld3m3PwMhLwojtbJNBExDIWVuNO2ad89Gw=;
        b=bC5xhPrnk30A6esUoF1tTDyw8qSDGKl8ap9F2fK5g2uVMAnXFKB9dj9syGpwhpUto3
         4OVTElAwBjz2T0ZZyALwTVglQ/GRkm8GLjGm0sUOkGbQROAxTs3eFtB/5KppOdhQRhiS
         /7EmQwDS9ZPPY8U78NNfFjctlC9XIB5jURJkQOHmN8EscagB48g3M1j3RWlfIFBKP1LJ
         gdkKI1y9cZLOVnhsMjM6SIHoMDQGhONPeB8y+rngKhEQwskIBGfht9gXFWbPStBL4Xpa
         J/cxRkdk6V50pr4jQA64PusxOBIfL/OLBt/1BMgyQo8r5UQj4ECUxXqSKCDL/GwHS5Mx
         JPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751037467; x=1751642267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ctaq7Efseld3m3PwMhLwojtbJNBExDIWVuNO2ad89Gw=;
        b=oNwHOdsEI9xd62rVHSaKNrmeHvI862kjAMYcdVAs1I3njFNA9i+OIeI+1wmk1rmMsT
         59khtvwXWuYFenC+kEqVfyO+EE688CZUHAcAmaDWuJEwhgIHZ7wmgQTegqBUaPqZUjQ4
         tZHyYPWMkMGHFMJmF/v/7qAKS5CGWgY7UPlpTVrxECU8LCjCiPjDoQ8wfPaMQ3bBBZr0
         KtuVQUjVT6aPnqSjhb78cXxvxeE1NyZPUpujqr29HYhuVd2r+IuAgW4aQlmCXyBqT4j5
         tX1Mwx1AsXmOCLO4IR6CVuZ9+iSzQj0vsyeE71G98U4pSfVx+Kc4JN0Cx+vsbyqy/SG0
         R06w==
X-Forwarded-Encrypted: i=1; AJvYcCUBSTQxsEY+Md/RK5FOOmk1rTKC7H2kZQ7zGEcEyn6xtpJAg+vxEvDMQg4Jx0yULP0h+58=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPhHOwQaa8fv++UoaDkX/bTP5e4OshwEJEbLsYUv88jFYoMMJD
	5Jjb/Yhnoyu8+5JS//Sjr/8jJwoglSb0gQbaONwjJkhnfbAKvbWsT55dPUPjuODFog0ymGGwBzu
	bAcL8X6KymErQMCHKqrT2tH5+E/58WjVAK8mEYLc9q+a4rdw33kE5aDrtwOY=
X-Gm-Gg: ASbGncs46E85xTk80txDUOEA9VPm8v9lhIq6T3XR9LTSdSIqgayC+4l1q3uojkJ94le
	bii8FfN0ywopkcoaqHVw4JVqEYyQUSXRRj2nPKYlJQbn/2r0zbKlp8g6FkS9dmWaSI7qNbj36x4
	fldOE6HbY0F8/kxFqLaRBm3AAy4NIUvZ/ig4PIHOHOSwrTA/efu2ij0UJymYprsVMg/giEwx0b7
	c5PeFSN0OjfqQ0=
X-Google-Smtp-Source: AGHT+IEb+xxzVEl4IYeZdvYpF90TB/n7ds2F+wk1b/UN6A6zXnHR6Y9V2ll0YmyvEsQKpdZrsBliB1gS8siVMNUIbc0=
X-Received: by 2002:a17:902:c94f:b0:234:a469:62ef with SMTP id
 d9443c01a7336-23ae4da691bmr146245ad.3.1751037466544; Fri, 27 Jun 2025
 08:17:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com>
 <CA+EHjTxtHOgichL=UvAzczoqS1608RSUNn5HbmBw2NceO941ng@mail.gmail.com>
 <CAGtprH8eR_S50xDnnMLHNCuXrN2Lv_0mBRzA_pcTtNbnVvdv2A@mail.gmail.com>
 <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
 <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com> <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com> <31beeed3-b1be-439b-8a5b-db8c06dadc30@amd.com>
In-Reply-To: <31beeed3-b1be-439b-8a5b-db8c06dadc30@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 27 Jun 2025 08:17:34 -0700
X-Gm-Features: Ac12FXyPZKiqBA6vQz47UeBICglaWzMRTynZ4wc-OUKHNtdWirkqG5VqjYk0knQ
Message-ID: <CAGtprH9gojp6hit2SZ0jJBJnzuRvpfRhSa334UhAMFYPZzp4PA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-fsdevel@vger.kernel.org, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, thomas.lendacky@amd.com, 
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 9:50=E2=80=AFPM Alexey Kardashevskiy <aik@amd.com> =
wrote:
>
>
>
> On 25/6/25 00:10, Vishal Annapurve wrote:
> > On Tue, Jun 24, 2025 at 6:08=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> >>
> >> On Tue, Jun 24, 2025 at 06:23:54PM +1000, Alexey Kardashevskiy wrote:
> >>
> >>> Now, I am rebasing my RFC on top of this patchset and it fails in
> >>> kvm_gmem_has_safe_refcount() as IOMMU holds references to all these
> >>> folios in my RFC.
> >>>
> >>> So what is the expected sequence here? The userspace unmaps a DMA
> >>> page and maps it back right away, all from the userspace? The end
> >>> result will be the exactly same which seems useless. And IOMMU TLB
> >
> >   As Jason described, ideally IOMMU just like KVM, should just:
> > 1) Directly rely on guest_memfd for pinning -> no page refcounts taken
> > by IOMMU stack
> > 2) Directly query pfns from guest_memfd for both shared/private ranges
> > 3) Implement an invalidation callback that guest_memfd can invoke on
> > conversions.

Conversions and truncations both.

> >
> > Current flow:
> > Private to Shared conversion via kvm_gmem_convert_range() -
> >      1) guest_memfd invokes kvm_gmem_invalidate_begin() for the ranges
> > on each bound memslot overlapping with the range
> >           -> KVM has the concept of invalidation_begin() and end(),
> > which effectively ensures that between these function calls, no new
> > EPT/NPT entries can be added for the range.
> >       2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> > actually unmaps the KVM SEPT/NPT entries.
> >       3) guest_memfd invokes kvm_gmem_execute_work() which updates the
> > shareability and then splits the folios if needed
> >
> > Shared to private conversion via kvm_gmem_convert_range() -
> >      1) guest_memfd invokes kvm_gmem_invalidate_begin() for the ranges
> > on each bound memslot overlapping with the range
> >       2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> > actually unmaps the host mappings which will unmap the KVM non-seucure
> > EPT/NPT entries.
> >       3) guest_memfd invokes kvm_gmem_execute_work() which updates the
> > shareability and then merges the folios if needed.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > For IOMMU, could something like below work?
> >
> > * A new UAPI to bind IOMMU FDs with guest_memfd ranges
>
> Done that.
>
> > * VFIO_DMA_MAP/UNMAP operations modified to directly fetch pfns from
> > guest_memfd ranges using kvm_gmem_get_pfn()
>
> This API imho should drop the confusing kvm_ prefix.
>
> >      -> kvm invokes kvm_gmem_is_private() to check for the range
> > shareability, IOMMU could use the same or we could add an API in gmem
> > that takes in access type and checks the shareability before returning
> > the pfn.
>
> Right now I cutnpasted kvm_gmem_get_folio() (which essentially is filemap=
_lock_folio()/filemap_alloc_folio()/__filemap_add_folio()) to avoid new lin=
ks between iommufd.ko and kvm.ko. It is probably unavoidable though.

I don't think that's the way to avoid links between iommufd.ko and
kvm.ko. Cleaner way probably is to have gmem logic built-in and allow
runtime registration of invalidation callbacks from KVM/IOMMU
backends. Need to think about this more.

>
>
> > * IOMMU stack exposes an invalidation callback that can be invoked by
> > guest_memfd.
> >
> > Private to Shared conversion via kvm_gmem_convert_range() -
> >      1) guest_memfd invokes kvm_gmem_invalidate_begin() for the ranges
> > on each bound memslot overlapping with the range
> >       2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> > actually unmaps the KVM SEPT/NPT entries.
> >             -> guest_memfd invokes IOMMU invalidation callback to zap
> > the secure IOMMU entries.
> >       3) guest_memfd invokes kvm_gmem_execute_work() which updates the
> > shareability and then splits the folios if needed
> >       4) Userspace invokes IOMMU map operation to map the ranges in
> > non-secure IOMMU.
> >
> > Shared to private conversion via kvm_gmem_convert_range() -
> >      1) guest_memfd invokes kvm_gmem_invalidate_begin() for the ranges
> > on each bound memslot overlapping with the range
> >       2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> > actually unmaps the host mappings which will unmap the KVM non-seucure
> > EPT/NPT entries.
> >           -> guest_memfd invokes IOMMU invalidation callback to zap the
> > non-secure IOMMU entries.
> >       3) guest_memfd invokes kvm_gmem_execute_work() which updates the
> > shareability and then merges the folios if needed.
> >       4) Userspace invokes IOMMU map operation to map the ranges in sec=
ure IOMMU.
>
>
> Alright (although this zap+map is not necessary on the AMD hw).

IMO guest_memfd ideally should not directly interact or cater to arch
specific needs, it should implement a mechanism that works for all
archs. KVM/IOMMU implement invalidation callbacks and have all the
architecture specific knowledge to take the right decisions.

>
>
> > There should be a way to block external IOMMU pagetable updates while
> > guest_memfd is performing conversion e.g. something like
> > kvm_invalidate_begin()/end().
> >
> >>> is going to be flushed on a page conversion anyway (the RMPUPDATE
> >>> instruction does that). All this is about AMD's x86 though.
> >>
> >> The iommu should not be using the VMA to manage the mapping. It should
> >
> > +1.
>
> Yeah, not doing this already, because I physically cannot map gmemfd's me=
mory in IOMMU via VMA (which allocates memory via gup() so wrong memory is =
mapped in IOMMU). Thanks,
>
>
> >> be directly linked to the guestmemfd in some way that does not disturb
> >> its operations. I imagine there would be some kind of invalidation
> >> callback directly to the iommu.
> >>
> >> Presumably that invalidation call back can include a reason for the
> >> invalidation (addr change, shared/private conversion, etc)
> >>
> >> I'm not sure how we will figure out which case is which but guestmemfd
> >> should allow the iommu to plug in either invalidation scheme..
> >>
> >> Probably invalidation should be a global to the FD thing, I imagine
> >> that once invalidation is established the iommu will not be
> >> incrementing page refcounts.
> >
> > +1.
>
> Alright. Thanks for the comments.
>
> >
> >>
> >> Jason
>
> --
> Alexey
>

