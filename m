Return-Path: <kvm+bounces-47381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53550AC0F70
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D89BCA25A7B
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D27628FABB;
	Thu, 22 May 2025 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LrVyzu8H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A328FAA6
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926490; cv=none; b=JEaO+gEc+iaLiEMz+FTZs4y/WtBd6VhQtM8CtOLnfqv3xIhYPwmzFk4rFtp0pXaA55z4I+Io/H8gqTcMVsqXun9e/o0lXGiuRxWWUmLhEpMFRPFeCatskORdA7NIW+jAJO2DmFRCMR1eVPq/EOJw0+lefwgI8/0hNuZu8NnA594=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926490; c=relaxed/simple;
	bh=mS5GgND8UuontDSj6ihHGCoTUwpMjYc0hUM5E0VMdiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H4+z0cNyt+oeMOsQwKyNJ+NMHy+KfFsKCHMGWDl6Ei9qu9O6/koXDNd2NNijHOYUBsq/CMI+aLtr3j9TU8zZTYbBtALMXNo4/qulLJniETwWiahBglFG2IMlvGKLmcambzXfm25v7ulhU8+N8+9kHVJk2hhU/SjWpsh6OmV63JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LrVyzu8H; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-48b7747f881so1874541cf.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747926487; x=1748531287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qD45WleDxaKRfdFYJAyThj8STlU1fBlpeISFDoR8AxE=;
        b=LrVyzu8HKZceJUPRGikNvFqLtgrq3CtpXTZOnut4Ti2CSlZ7AW8x8ceV6svNQ34NR7
         Z5cK6UaaLQKvbCU/Va4oRUuK/9I0V5wfTvoS7AWWzRXBZF4QhNYYBumiLP2Khr9qIT2n
         TWTVPg3ujukyWTNMCasiVYTy0vQ1WB4b/rck+m/h+su5q7tg/GeLk4BMNeb0WnNzCt5D
         uccLY2HH+inF5bgXSWskxjX07U8UMegufT1dDEGwiXbridstBQO6gG43PaGGamqJakad
         FkHzdf1ft+WpxeQrZakbYXDMODodNstm7D1f5+5qXRDKri7yuJycSHgit6DEsbUQeLBK
         CT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747926487; x=1748531287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qD45WleDxaKRfdFYJAyThj8STlU1fBlpeISFDoR8AxE=;
        b=lexz57gIZDx5R6LmulO/jp6F6XaNzF0tgIhsNZLplIscYojzv2fTejRqM5Zlhx/wjX
         QNt4GMjxJ+92u9pnh2aScGxrZZnZ4MxPU5rodax6YmsXPy5G5kimXYkSuGv7M76aBt//
         1QJYhMBbI5trUB1dqqEWE9dKspdn88Lmp5Tr4anYN6WJtSrS7AO+EzzV+5jnaOhHeMtG
         jqwqs9Mf7uX/4fYl40IA8azu+xTon7I1ByASDfDEGq8BWLDLsUlpPfHIpDCRi3F0+gIw
         VcMKC6bL/JEFrMspjFl9Am+bY4Bb1C+deUiSfVuBiZyXFS5wqhjoTAqtGgn0MQNIWdSq
         cPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1uuZVe7iHezUaAdQJHGUvQkmm1dCZ41gAcPB6/VKHGJuc8wWl47o13blgSFQYtcy6NzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YylBv7PhBa5KHpQjB9w6aNHzaMBgTUYGwuNboUtXn7eJxC5a6fC
	02ZGaZ6JP/6MQs119jqU/t/EVUQ3lGIvyOpyIEJa7XIV6QfovWAYVJrsA3TorqO87MiHI+z9p5K
	3gtkqmy6vGAUDEa3z4j9bIi1Q6oUfygcAMK9/RgVU
X-Gm-Gg: ASbGncuu60pwFHBfRPbbWlryi0i5izu3tCCTH1T8efpXMlBiX7kuKPn5UtPugfZa0uh
	OC00BHloGLsKaxvLt9JlL1kEYqY8Beyy8LIgGPvBXd0aHE8A08CuB1j19ZNf95ivcsUgyJ0f6x+
	se5qCU1Se/AcqWyXUhF5kV19zfxJkvDIvUYe9cRZjcNhg=
X-Google-Smtp-Source: AGHT+IExWgZ/kprFJR2qUAmAvBSuiZQwIp3xVKHZZRhAngXGir6bXeq3t/Qwhx3C/I2QsXxLMQlJK+hvAoH5fIBVNiQ=
X-Received: by 2002:a05:622a:1356:b0:497:2f60:4ca4 with SMTP id
 d75a77b69052e-49cf05d4f7cmr3910441cf.15.1747926486878; Thu, 22 May 2025
 08:08:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <CA+EHjTy7iBNBb9DRdtgq8oYmvgykhSNvZL3FrRV4XF90t3XgBg@mail.gmail.com>
 <CAGtprH_7jSpwF77j1GW8rjSrbtZZ2OW2iGck5=Wk67+VnF9vjQ@mail.gmail.com>
 <CA+EHjTzMhKCoftfJUuL0WUZW4DdqOHgVDcn0Cmf-0r--8rBdbg@mail.gmail.com>
 <diqzecwjnk95.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTyY5C1QgkoAqvJ0kHM4nUvKc1e1nQ0Uq+BANtVEnZH90w@mail.gmail.com>
 <CAGtprH-fE=G923ctBAcq5zFna+2WULhmHDSbXUsZKUrin29b4g@mail.gmail.com>
 <CA+EHjTxvufYVA8LQWRKEX7zA0gWLQUHVO2LvwKc5JXVu-XAEEA@mail.gmail.com>
 <CAGtprH_TfKT3oRPCLbh-ojLGXSfOQ2XA39pVhr47gb3ikPtUkw@mail.gmail.com>
 <CA+EHjTxJZ_pb7+chRoZxvkxuib2YjbiHg=_+f4bpRt2xDFNCzQ@mail.gmail.com> <aC86OsU2HSFZkJP6@google.com>
In-Reply-To: <aC86OsU2HSFZkJP6@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 May 2025 16:07:29 +0100
X-Gm-Features: AX0GCFtxE_5yf3JaUaANLr_bOaaQ7-YRdImpBrNEqDFWm2pmOqea-YH30YgPCtI
Message-ID: <CA+EHjTxjt-mb_WbtVymaBvCb1EdJAVMV_uGb4xDs_ewg4k0C4g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
To: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-fsdevel@vger.kernel.org, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
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
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, thomas.lendacky@amd.com, 
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Thu, 22 May 2025 at 15:52, Sean Christopherson <seanjc@google.com> wrote=
:
>
> On Wed, May 21, 2025, Fuad Tabba wrote:
> > On Wed, 21 May 2025 at 16:51, Vishal Annapurve <vannapurve@google.com> =
wrote:
> > > On Wed, May 21, 2025 at 8:22=E2=80=AFAM Fuad Tabba <tabba@google.com>=
 wrote:
> > > > On Wed, 21 May 2025 at 15:42, Vishal Annapurve <vannapurve@google.c=
om> wrote:
> > > > > On Wed, May 21, 2025 at 5:36=E2=80=AFAM Fuad Tabba <tabba@google.=
com> wrote:
> > > > > There are a bunch of complexities here, reboot sequence on x86 ca=
n be
> > > > > triggered using multiple ways that I don't fully understand, but =
few
> > > > > of them include reading/writing to "reset register" in MMIO/PCI c=
onfig
> > > > > space that are emulated by the host userspace directly. Host has =
to
> > > > > know when the guest is shutting down to manage it's lifecycle.
> > > >
> > > > In that case, I think we need to fully understand these complexitie=
s
> > > > before adding new IOCTLs. It could be that once we understand these
> > > > issues, we find that we don't need these IOCTLs. It's hard to justi=
fy
> > > > adding an IOCTL for something we don't understand.
> > > >
> > >
> > > I don't understand all the ways x86 guest can trigger reboot but I do
> > > know that x86 CoCo linux guest kernel triggers reset using MMIO/PCI
> > > config register write that is emulated by host userspace.
> > >
> > > > > x86 CoCo VM firmwares don't support warm/soft reboot and even if =
it
> > > > > does in future, guest kernel can choose a different reboot mechan=
ism.
> > > > > So guest reboot needs to be emulated by always starting from scra=
tch.
> > > > > This sequence needs initial guest firmware payload to be installe=
d
> > > > > into private ranges of guest_memfd.
> > > > >
> > > > > >
> > > > > > Either the host doesn't (or cannot even) know that the guest is
> > > > > > rebooting, in which case I don't see how having an IOCTL would =
help.
> > > > >
> > > > > Host does know that the guest is rebooting.
> > > >
> > > > In that case, that (i.e., the host finding out that the guest is
> > > > rebooting) could trigger the conversion back to private. No need fo=
r an
> > > > IOCTL.
> > >
> > > In the reboot scenarios, it's the host userspace finding out that the=
 guest
> > > kernel wants to reboot.
> >
> > How does the host userspace find that out? If the host userspace is cap=
able
> > of finding that out, then surely KVM is also capable of finding out the=
 same.
>
> Nope, not on x86.  Well, not without userspace invoking a new ioctl, whic=
h would
> defeat the purpose of adding these ioctls.
>
> KVM is only responsible for emulating/virtualizing the "CPU".  The chipse=
t, e.g.
> the PCI config space, is fully owned by userspace.  KVM doesn't even know=
 whether
> or not PCI exists for the VM.  And reboot may be emulated by simply creat=
ing a
> new KVM instance, i.e. even if KVM was somehow aware of the reboot reques=
t, the
> change in state would happen in an entirely new struct kvm.
>
> That said, Vishal and Ackerley, this patch is a bit lacking on the docume=
ntation
> front.  The changelog asserts that:
>
>   A guest_memfd ioctl is used because shareability is a property of the m=
emory,
>   and this property should be modifiable independently of the attached st=
ruct kvm
>
> but then follows with a very weak and IMO largely irrelevant justificatio=
n of:
>
>   This allows shareability to be modified even if the memory is not yet b=
ound
>   using memslots.
>
> Allowing userspace to change shareability without memslots is one relativ=
ely minor
> flow in one very specific use case.
>
> The real justification for these ioctls is that fundamentally, shareabili=
ty for
> in-place conversions is a property of a guest_memfd instance and not a st=
ruct kvm
> instance, and so needs to owned by guest_memfd.

Thanks for the clarification Sean. I have a couple of followup
questions/comments that you might be able to help with:

From a conceptual point of view, I understand that the in-place
conversion is a property of guest_memfd. But that doesn't necessarily
mean that the interface between kvm <-> guest_memfd is a userspace
IOCTL. We already communicate directly between the two. Other, even
less related subsystems within the kernel also interact without going
through userspace. Why can't we do the same here? I'm not suggesting
it not be owned by guest_memfd, but that we communicate directly.

From a performance point of view, I would expect the common case to be
that when KVM gets an unshare request from the guest, it would be able
to unmap those pages from the (cooperative) host userspace, and return
back to the guest. In this scenario, the host userspace wouldn't even
need to be involved. Having a userspace IOCTL as part of this makes
that trip unnecessarily longer for the common case.

Cheers,
/fuad

> I.e. focus on justifying the change from a design and conceptual perspect=
ive,
> not from a mechanical perspective of a flow that likely's somewhat unique=
 to our
> specific environment.  Y'all are getting deep into the weeds on a random =
aspect
> of x86 platform architecture, instead of focusing on the overall design.
>
> The other issue that's likely making this more confusing than it needs to=
 be is
> that this series is actually two completely different series bundled into=
 one,
> with very little explanation.  Moving shared vs. private ownership into
> guest_memfd isn't a requirement for 1GiB support, it's a requirement for =
in-place
> shared/private conversion in guest_memfd.
>
> For the current guest_memfd implementation, shared vs. private is tracked=
 in the
> VM via memory attributes, because a guest_memfd instance is *only* privat=
e.  I.e.
> shared vs. private is a property of the VM, not of the guest_memfd instan=
ce.  But
> when in-place conversion support comes along, ownership of that particula=
r
> attribute needs to shift to the guest_memfd instance.
>
> I know I gave feedback on earlier posting about there being too series fl=
ying
> around, but shoving two distinct concepts into a single series is not the=
 answer.
> My complaints about too much noise wasn't that there were multiple series=
, it was
> that there was very little coordination and lots of chaos.
>
> If you split this series in two, which should be trivial since you've alr=
eady
> organized the patches as a split, then sans the selftests (thank you for =
those!),
> in-place conversion support will be its own (much smaller!) series that c=
an focus
> on that specific aspect of the design, and can provide a cover letter tha=
t
> expounds on the design goals and uAPI.
>
>   KVM: guest_memfd: Add CAP KVM_CAP_GMEM_CONVERSION
>   KVM: Query guest_memfd for private/shared status
>   KVM: guest_memfd: Skip LRU for guest_memfd folios
>   KVM: guest_memfd: Introduce KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
>   KVM: guest_memfd: Introduce and use shareability to guard faulting
>   KVM: guest_memfd: Make guest mem use guest mem inodes instead of anonym=
ous inodes
>
> And then you can post the 1GiB series separately.  So long as you provide=
 pointers
> to dependencies along with a link to a repo+branch with the kitchen sink,=
 I won't
> complain about things being too chaotic :-)

