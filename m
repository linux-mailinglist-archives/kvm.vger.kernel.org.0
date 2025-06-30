Return-Path: <kvm+bounces-51100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 906CFAEE077
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 16:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DDD2189DFD2
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AAA28C2AF;
	Mon, 30 Jun 2025 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="laGj0GqR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E3A28C2BC
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751293204; cv=none; b=mcgFJjm4lfq5vxpZeU3yNJ5QAfXERlDydaN7qkRELPcBcLgFjhz7arLR2zwIyvS9JebAh3yRJIqcy/DM+h3fV4sh8fzQiqBuMApekHIR2Tvb1uBybTmYAsuFnRB7ajvOMaHLLEQk4L1o4R0HCG1IHgTDxpeeb6aknbRBZI7E2Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751293204; c=relaxed/simple;
	bh=8p9Lu6GJRcIKPYRKLe8E7It0z/v4O/1xWIO8N0WUytM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pUeLQvhUa4Y3ZSsZgyp/6zfh1+6n6yd0Wx3BuL9aPCT7b5Kwf4stHt8W+9o4ODW13o4WVVGOIq99NkLGK3PxWXLIHhbWSA4RPQ4q1lVmZlQBK8apDjeaKlpKE7q+lVu7k7v1So3WwPdX/8jCmuldRnKBSXS/Qf0tXyYdW62mJ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=laGj0GqR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e389599fso328375ad.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751293202; x=1751898002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6BgpGI+izTDP23PbygNDraRvPegCbPWLha3s13/sL8=;
        b=laGj0GqR5yi8pDj2PiwhV6OGIhfhvr+n3Q/OHK8mSkZ++IfOHg/SK1DCU7KpMUGfuE
         DackhF0DrxvFZPXGmZUXkgXEhTlPzRksBbkMGxemAqFZug37/TrnsPRQ+xyonhoP829a
         0zgcMQ3aGG/VGqMp8X69rGIysSFjWiGf0aNDDsmXRRWo22W/ixvc+fp7+nHKSeOYyJZr
         netbfx4YwcqzTq9GZfRNNsT5FR6nNqVEa82q5mOpuYPA6J+tu2dqGcQoTkv2D4SzdgVK
         +a9mqgQQiL5grqkAIdrh7aaHA34fwxf7jd98Gs/jwbamsEc2iOKXNhCp0kIFG/ec8mJZ
         IJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751293202; x=1751898002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6BgpGI+izTDP23PbygNDraRvPegCbPWLha3s13/sL8=;
        b=puOU8PnNdx6lOdG7pLUk/dKfo1agcZDD2zDqCXlgHoiMFweTTuNIgjeCZ0oqJMuq1H
         1bIWwx0BZgp9x3s31fYAcRKJMNb/BUanngj5/7pCHtkk6Ve41uum3ShwnUcHjQswyJnf
         a19DxBKoCi+gL3nJcSc1L94uRSQfK4JzDE2k7oKYQS+hbjOwPxnWAJKMg2gsKYWeX+RE
         rXsqz2vqzcNVzzw5hUgnE2Q/3x50s2ENi1gixEXswmadA4zEhW7AN0pcLfatVholi/KN
         IZDyNUZyTVEIzSOuP1eaC/sllMeb7D5Tu4h+9vdMVXEwlQv1CAOUICSugcSSXyrWda4t
         2iPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSladChHdy0OWRH6w/59wlxjrHjbwHP1b+Stw6NUm/mX5ueLalz6A0cVvWDWODSY8S9/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0kWI5bMoQ12IfDaJV5yHN4nc/jp2zNS4cJB9DhJ5kQPjNylhL
	eeGH8q1e9mKan0Tnx9uuWPoQ8yIDz1DW+FB6XwEDFyXmpYyWqy62ohfHTQ3NMJaUk80cSiWVp9U
	GWJOTs0KBXn7E9TKX/ji4R5oywGbVaYLc+xh0LWwD
X-Gm-Gg: ASbGnctK19YoA05dGzJaQqdFsTCaP03I9X9D3VwVeY1ZWM0vt1f6LmUZ5Cy/8f9UkQR
	J89WpOYXukI8oBjCZlL2IpGiE0WELktM+p133vJ6fUnCick6NHrmvexD5UxtTOp/8UwBI7bIy0r
	/KYDx2LwLWeWQbVCSf6HRK5174Krt0xylE3b5+XUiKSK11TVcj/BOqxHqE19oTUEi60BWMOS7IT
	WFU
X-Google-Smtp-Source: AGHT+IE5AgZOIXEN2kYR+pPHATg3kKWBvA9NG7t3TRCU6UJnhNGR4z3nEopD8cR2TPGhUdKYcMbUvEi2+5nz92PWy1A=
X-Received: by 2002:a17:902:ecc1:b0:234:9f02:e937 with SMTP id
 d9443c01a7336-23ae9f7531dmr3497505ad.25.1751293200306; Mon, 30 Jun 2025
 07:20:00 -0700 (PDT)
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
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <31beeed3-b1be-439b-8a5b-db8c06dadc30@amd.com> <CAGtprH9gojp6hit2SZ0jJBJnzuRvpfRhSa334UhAMFYPZzp4PA@mail.gmail.com>
 <8f04f1df-d68d-4ef8-b176-595bbf00a9d1@amd.com>
In-Reply-To: <8f04f1df-d68d-4ef8-b176-595bbf00a9d1@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 30 Jun 2025 07:19:47 -0700
X-Gm-Features: Ac12FXwcrbDkWWpGm6EqP7Q9KESbZoaZfTZr5E9iZdm0C78qOvk6uq87JKmXh1E
Message-ID: <CAGtprH-KhEM6=zegq-36yomZ8PX22EmaZpMPkLnkyzn51EF25w@mail.gmail.com>
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

On Sun, Jun 29, 2025 at 5:19=E2=80=AFPM Alexey Kardashevskiy <aik@amd.com> =
wrote:
> ...
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>>
> >>> For IOMMU, could something like below work?
> >>>
> >>> * A new UAPI to bind IOMMU FDs with guest_memfd ranges
> >>
> >> Done that.
> >>
> >>> * VFIO_DMA_MAP/UNMAP operations modified to directly fetch pfns from
> >>> guest_memfd ranges using kvm_gmem_get_pfn()
> >>
> >> This API imho should drop the confusing kvm_ prefix.
> >>
> >>>       -> kvm invokes kvm_gmem_is_private() to check for the range
> >>> shareability, IOMMU could use the same or we could add an API in gmem
> >>> that takes in access type and checks the shareability before returnin=
g
> >>> the pfn.
> >>
> >> Right now I cutnpasted kvm_gmem_get_folio() (which essentially is file=
map_lock_folio()/filemap_alloc_folio()/__filemap_add_folio()) to avoid new =
links between iommufd.ko and kvm.ko. It is probably unavoidable though.
> >
> > I don't think that's the way to avoid links between iommufd.ko and
> > kvm.ko. Cleaner way probably is to have gmem logic built-in and allow
> > runtime registration of invalidation callbacks from KVM/IOMMU
> > backends. Need to think about this more.
>
> Yeah, otherwise iommufd.ko will have to install a hook in guest_memfd (=
=3D=3Dkvm.ko) in run time so more beloved symbol_get() :)
>
> >
> >>
> >>
> >>> * IOMMU stack exposes an invalidation callback that can be invoked by
> >>> guest_memfd.
> >>>
> >>> Private to Shared conversion via kvm_gmem_convert_range() -
> >>>       1) guest_memfd invokes kvm_gmem_invalidate_begin() for the rang=
es
> >>> on each bound memslot overlapping with the range
> >>>        2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> >>> actually unmaps the KVM SEPT/NPT entries.
> >>>              -> guest_memfd invokes IOMMU invalidation callback to za=
p
> >>> the secure IOMMU entries.
> >>>        3) guest_memfd invokes kvm_gmem_execute_work() which updates t=
he
> >>> shareability and then splits the folios if needed
> >>>        4) Userspace invokes IOMMU map operation to map the ranges in
> >>> non-secure IOMMU.
> >>>
> >>> Shared to private conversion via kvm_gmem_convert_range() -
> >>>       1) guest_memfd invokes kvm_gmem_invalidate_begin() for the rang=
es
> >>> on each bound memslot overlapping with the range
> >>>        2) guest_memfd invokes kvm_gmem_convert_should_proceed() which
> >>> actually unmaps the host mappings which will unmap the KVM non-seucur=
e
> >>> EPT/NPT entries.
> >>>            -> guest_memfd invokes IOMMU invalidation callback to zap =
the
> >>> non-secure IOMMU entries.
> >>>        3) guest_memfd invokes kvm_gmem_execute_work() which updates t=
he
> >>> shareability and then merges the folios if needed.
> >>>        4) Userspace invokes IOMMU map operation to map the ranges in =
secure IOMMU.
> >>
> >>
> >> Alright (although this zap+map is not necessary on the AMD hw).
> >
> > IMO guest_memfd ideally should not directly interact or cater to arch
> > specific needs, it should implement a mechanism that works for all
> > archs. KVM/IOMMU implement invalidation callbacks and have all the
> > architecture specific knowledge to take the right decisions.
>
>
> Every page conversion will go through:
>
> kvm-amd.ko -1-> guest_memfd (kvm.ko) -2-> iommufd.ko -3-> amd-iommu (buil=
d-in).
>
> Which one decides on IOMMU not needing (un)mapping? Got to be (1) but the=
n it need to propagate the decision to amd-iommu (and we do not have (3) at=
 the moment in that path).

If there is a need, guest_memfd can support two different callbacks:
1) Conversion notifier/callback invoked by guest_memfd during
conversion handling.
2) Invalidation notifier/callback invoked by guest_memfd during truncation.

Iommufd/kvm can handle conversion callback/notifier as per the needs
of underlying architecture. e.g. for TDX connect do the unmapping vs
for SEV Trusted IO skip the unmapping.

Invalidation callback/notifier will need to be handled by unmapping page ta=
bles.

>
> Or we just always do unmap+map (and trigger unwanted page huge page smash=
ing)? All is doable and neither particularly horrible, I'm trying to see wh=
ere the consensus is now. Thanks,
>

I assume when you say huge page smashing, it means huge page NPT
mapping getting split.

AFAIR, based on discussion with Michael during guest_memfd calls,
stage2 NPT entries need to be of the same granularity as RMP tables
for AMD SNP guests. i.e. huge page NPT mappings need to be smashed on
the KVM side during conversion. So today guest_memfd sends
invalidation notification to KVM for both conversion and truncation.
Doesn't the same constraint for keeping IOMMU page tables at the same
granularity as RMP tables hold for trusted IO?

