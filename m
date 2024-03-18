Return-Path: <kvm+bounces-12042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0963187F3CC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B1C281F09
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6485C61E;
	Mon, 18 Mar 2024 23:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UWCuF22k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189A1D522
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803255; cv=none; b=P1VqCbdQ676Wsz22qn2VUlMIb9oz7DeYdJrvVd+s+DN6j8UmOcwm1PZTmWiW76UhE9o5tewQQ8D2AWdi2dzjZ4Y3tU2lSFhwu5bAfI9uNF+6LgdnwgKjeM8bWjC6O2bcRiJOOcdxtWoSuiD/eh7Mfp6u0Mbu1mIk5T+binmToSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803255; c=relaxed/simple;
	bh=XUmpAfX/w1ZQy6clKR8DOYl5lGv4Q4a63T94QWBwBoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rfcC+bubSeTpO1xyM7Bh9OzzIQDRfTnmyjlYSpYmnTV829I+DD2U16BLQ2U55q5NZHw5VhlUsvWGEmzGHhQbHrGQ6AA0n7XqEJHPwqxLYMR5GMUYv4yWR+nDWZgtxY2mZYiFXgikL11yMH9rI8UnG2vMHbpiwhaMbXuHsdBpwJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UWCuF22k; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-430acd766beso19940841cf.1
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 16:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710803250; x=1711408050; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtoRdxoafB+izb75r+ENF2jJrhZLgMd/wrxfQtY2ZiQ=;
        b=UWCuF22kI15Cyit8IuzlpzMELDTmj4ujgr5K/0/PHhfA7ToPH5DV+qKKFowXBYOKuD
         cJ3muinctFOuYiicHboch8MHbhLPyLZGRd1gXeMVNc0GgTs7Kyi0mZKdqDWXcdCQmBVP
         fnbZ1mut+kFD79X917fvyQ/IeTlcf2+bMxj009+7loT/3vz3GhNkq3ovOVC2YlNYEM7p
         Q4SeoMC8nJxogta6kfgLBAbAbdzFobwC5wtwjp6tl/r8Z+ZdNk0veLWyA2CSDMtjb/wS
         8Y9GhDc8UTa773DLzSyW8M6TeGWszzREcCq9M+dtD9dFTbmdXeS3VkfNOoQ7hCdUkGcO
         0A2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710803250; x=1711408050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtoRdxoafB+izb75r+ENF2jJrhZLgMd/wrxfQtY2ZiQ=;
        b=fx/52JPIVW1DFRJ5A0MzlX4mXOv/R36AEXBvdswCMrmUfuLZLl0HoGbdnFkkbrYj/5
         ZEWxGBkCdlTwIwZT1sBjKNPCXBEEoldIIovkBdx4YDkXT3J9H2oq8aZa2dA4MgmPF+0P
         2ayS3uyA583nqNlfCUmiyp339zbubq0oTzdzgU5jPHTuRRXB+bVlqTIbAyBhATVlHman
         wFm6dAUXUPTJQ3Y43P9nWuELVB11gQ0op5Q2pKp/eIiLkrC9iCLoPwIb/ulwbSs614df
         cKXBxo3VKnD0T8YJdO9ScfhlmSvtj7C57HA5rxZ3QkPcTSFHpQZUHhX5+mQPjqicsq2H
         FUUg==
X-Forwarded-Encrypted: i=1; AJvYcCWWlcIYjccfr5ogBRVDxP+qenYMIxkYaB+Sg/Kf5VDSPbpLWJwwDXdbYiuA8spmMVxPithBRXk6XUB3lXSqNeaHQrd5
X-Gm-Message-State: AOJu0YxQrUMGVxCkrJMrrOJ28SWQLFjEZGaBGy0B4uicJnF510DsvEt0
	rEO0L8Wegj4iBiJuPmf0i2947vikP4rlk5HAYImx0io/rBL2e3H2NkcY1vk2STjhuMLjh48Ds+Y
	zext1wOwouT9SFdiHT9IpWQMg/qW13vB5lrKE
X-Google-Smtp-Source: AGHT+IH9yJI/i6oqN/ivT8exgGUckpYT00y2kBtIzCdk9KZ4pICJwRpD3sqFxltbt691NQS+UUMns+tMe64zO1I63ac=
X-Received: by 2002:a05:6214:4c0f:b0:690:a707:8857 with SMTP id
 qh15-20020a0562144c0f00b00690a7078857mr12564306qvb.62.1710803249486; Mon, 18
 Mar 2024 16:07:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com> <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com> <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com> <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com> <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com> <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com> <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
In-Reply-To: <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 18 Mar 2024 16:07:16 -0700
Message-ID: <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
Subject: Re: folio_mmapped
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 3:02=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 18.03.24 18:06, Vishal Annapurve wrote:
> > On Mon, Mar 4, 2024 at 12:17=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 04.03.24 20:04, Sean Christopherson wrote:
> >>> On Mon, Mar 04, 2024, Quentin Perret wrote:
> >>>>> As discussed in the sub-thread, that might still be required.
> >>>>>
> >>>>> One could think about completely forbidding GUP on these mmap'ed
> >>>>> guest-memfds. But likely, there might be use cases in the future wh=
ere you
> >>>>> want to use GUP on shared memory inside a guest_memfd.
> >>>>>
> >>>>> (the iouring example I gave might currently not work because
> >>>>> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> >>>>> guest_memfd will likely not be detected as shmem; 8ac268436e6d cont=
ains some
> >>>>> details)
> >>>>
> >>>> Perhaps it would be wise to start with GUP being forbidden if the
> >>>> current users do not need it (not sure if that is the case in Androi=
d,
> >>>> I'll check) ? We can always relax this constraint later when/if the
> >>>> use-cases arise, which is obviously much harder to do the other way
> >>>> around.
> >>>
> >>> +1000.  At least on the KVM side, I would like to be as conservative =
as possible
> >>> when it comes to letting anything other than the guest access guest_m=
emfd.
> >>
> >> So we'll have to do it similar to any occurrences of "secretmem" in
> >> gup.c. We'll have to see how to marry KVM guest_memfd with core-mm cod=
e
> >> similar to e.g., folio_is_secretmem().
> >>
> >> IIRC, we might not be able to de-reference the actual mapping because =
it
> >> could get free concurrently ...
> >>
> >> That will then prohibit any kind of GUP access to these pages, includi=
ng
> >> reading/writing for ptrace/debugging purposes, for core dumping purpos=
es
> >> etc. But at least, you know that nobody was able to optain page
> >> references using GUP that might be used for reading/writing later.
> >>
> >
> > There has been little discussion about supporting 1G pages with
> > guest_memfd for TDX/SNP or pKVM. I would like to restart this
> > discussion [1]. 1G pages should be a very important usecase for guest
> > memfd, especially considering large VM sizes supporting confidential
> > GPU/TPU workloads.
> >
> > Using separate backing stores for private and shared memory ranges is
> > not going to work effectively when using 1G pages. Consider the
> > following scenario of memory conversion when using 1G pages to back
> > private memory:
> > * Guest requests conversion of 4KB range from private to shared, host
> > in response ideally does following steps:
> >      a) Updates the guest memory attributes
> >      b) Unbacks the corresponding private memory
> >      c) Allocates corresponding shared memory or let it be faulted in
> > when guest accesses it
> >
> > Step b above can't be skipped here, otherwise we would have two
> > physical pages (1 backing private memory, another backing the shared
> > memory) for the same GPA range causing "double allocation".
> >
> > With 1G pages, it would be difficult to punch KBs or even MBs sized
> > hole since to support that:
> > 1G page would need to be split (which hugetlbfs doesn't support today
> > because of right reasons), causing -
> >          - loss of vmemmap optimization [3]
> >          - losing ability to reconstitute the huge page again,
> > especially as private pages in CVMs are not relocatable today,
> > increasing overall fragmentation over time.
> >                - unless a smarter algorithm is devised for memory
> > reclaim to reconstitute large pages for unmovable memory.
> >
> > With the above limitations in place, best thing could be to allow:
> >   - single backing store for both shared and private memory ranges
> >   - host userspace to mmap the guest memfd (as this series is trying to=
 do)
> >   - allow userspace to fault in memfd file ranges that correspond to
> > shared GPA ranges
> >       - pagetable mappings will need to be restricted to shared memory
> > ranges causing higher granularity mappings (somewhat similar to what
> > HGM series from James [2] was trying to do) than 1G.
> >   - Allow IOMMU also to map those pages (pfns would be requested using
> > get_user_pages* APIs) to allow devices to access shared memory. IOMMU
> > management code would have to be enlightened or somehow restricted to
> > map only shared regions of guest memfd.
> >   - Upon conversion from shared to private, host will have to ensure
> > that there are no mappings/references present for the memory ranges
> > being converted to private.
> >
> > If the above usecase sounds reasonable, GUP access to guest memfd
> > pages should be allowed.
>
> To say it with nice words: "Not a fan".
>
> First, I don't think only 1 GiB will be problematic. Already 2 MiB ones
> will be problematic and so far it is even unclear how guest_memfd will
> consume them in a way acceptable to upstream MM. Likely not using
> hugetlb from what I recall after the previous discussions with Mike.
>

Agree, the support for 1G pages with guest memfd is yet to be figured
out, but it remains a scenario to be considered here.

> Second, we should find better ways to let an IOMMU map these pages,
> *not* using GUP. There were already discussions on providing a similar
> fd+offset-style interface instead. GUP really sounds like the wrong
> approach here. Maybe we should look into passing not only guest_memfd,
> but also "ordinary" memfds.

I need to dig into past discussions around this, but agree that
passing guest memfds to VFIO drivers in addition to HVAs seems worth
exploring. This may be required anyways for devices supporting TDX
connect [1].

If we are talking about the same file catering to both private and
shared memory, there has to be some way to keep track of references on
the shared memory from both host userspace and IOMMU.

>
> Third, I don't think we should be using huge pages where huge pages
> don't make any sense. Using a 1 GiB page so the VM will convert some
> pieces to map it using PTEs will destroy the whole purpose of using 1
> GiB pages. It doesn't make any sense.

I had started a discussion for this [2] using an RFC series. Main
challenge here remain:
1) Unifying all the conversions under one layer
2) Ensuring shared memory allocations are huge page aligned at boot
time and runtime.

Using any kind of unified shared memory allocator (today this part is
played by SWIOTLB) will need to support huge page aligned dynamic
increments, which can be only guaranteed by carving out enough memory
at boot time for CMA area and using CMA area for allocation at
runtime.
   - Since it's hard to come up with a maximum amount of shared memory
needed by VM, especially with GPUs/TPUs around, it's difficult to come
up with CMA area size at boot time.

I think it's arguable that even if a VM converts 10 % of its memory to
shared using 4k granularity, we still have fewer page table walks on
the rest of the memory when using 1G/2M pages, which is a significant
portion.

>
> A direction that might make sense is either (A) enlighting the VM about
> the granularity in which memory can be converted (but also problematic
> for 1 GiB pages) and/or (B) physically restricting the memory that can
> be converted.

Physically restricting the memory will still need a safe maximum bound
to be calculated based on all the shared memory usecases that VM can
encounter.

>
> For example, one could create a GPA layout where some regions are backed
> by gigantic pages that cannot be converted/can only be converted as a
> whole, and some are backed by 4k pages that can be converted back and
> forth. We'd use multiple guest_memfds for that. I recall that physically
> restricting such conversions/locations (e.g., for bounce buffers) in
> Linux was already discussed somewhere, but I don't recall the details.
>
> It's all not trivial and not easy to get "clean".

Yeah, agree with this point, it's difficult to get a clean solution
here, but the host side solution might be easier to deploy (not
necessarily easier to implement) and possibly cleaner than attempts to
regulate the guest side.

>
> Concluding that individual pieces of a 1 GiB / 2 MiB huge page should
> not be converted back and forth might be a reasonable. Although I'm sure
> people will argue the opposite and develop hackish solutions in
> desperate ways to make it work somehow.
>
> Huge pages, and especially gigantic pages, are simply a bad fit if the
> VM will convert individual 4k pages.
>
>
> But to answer your last question: we might be able to avoid GUP by using
> a different mapping API, similar to the once KVM now provides.
>
> --
> Cheers,
>
> David / dhildenb
>

[1] -> https://cdrdv2.intel.com/v1/dl/getContent/773614
[2] https://lore.kernel.org/lkml/20240112055251.36101-2-vannapurve@google.c=
om/

