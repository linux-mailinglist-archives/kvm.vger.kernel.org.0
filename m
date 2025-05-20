Return-Path: <kvm+bounces-47127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01BE2ABD9D3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50F0018974B5
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 13:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D559461;
	Tue, 20 May 2025 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d34h7Nle"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C8D242910
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747748681; cv=none; b=LkEVLyh07W4T2/JnSqG1T7qAiLtn0HN0jWsaK4BNH3uPP9su7wsZdpq3cxRnZwIriAuyz6cV00ld5yA+44zOH9kaAjniORfZP+FXoW7W16ZhE/YgG4t0AqB9rGYqmEQ0MPBvATZl1Dfg1uCacc0yEt5NpUxuqNZ9FxVA/xNciKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747748681; c=relaxed/simple;
	bh=kk6tReGlKvouDQLn7VOkaPcVsOAkyHdY6G/LpjJo8Jc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SatqaxMj+TPaSWn8ENUG9ZmxbU9/ZfL4JGrCGEUvCRaUQSY7QcUl1q/HRv2Qm+7Zs+InsTBaRkKGNjklPscJZVdE95vWbddz8G+6y7bF9k1U6ZN0Zm0O1sUhwu6l7Nwf5dJpOVzw/qFSfYEdQ28p6o42XR2NEFu5xYSHX8NpBzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d34h7Nle; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4774611d40bso825941cf.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 06:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747748678; x=1748353478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDhxmEmBJCOi9C5FqDCLhfpR2mct4F/9MZxHaaQaBSU=;
        b=d34h7NlemwTg+iUmkzgcecAB4ra576i6C4r+CqeUWXvS/zx5VlS6rZWqJOHAd2JeLe
         ByZJeulJJnnljN1NzhbBZK2+34VOLFuflcwcpgY4/LnjfaWA4t28L6eHo6wTdzZEk27X
         BzMKT87McycfMTCJdQhQRYLFqPYgwu7OAOJNmHnuiGACa5YQqWLlqTqP/U/L5JHhyYyZ
         MBkFlZHLnDF5VfWOvF3NOKAquQJaUijhIfHDEl6GYKYnsW5q1UOxfq9EsN1vyGDKP006
         +EB0GaNFGCAlOMF1Y1Xttw2FhHpZdu24N0u7mttUP1CO61tNwRlJeizpdpYyCo5mnrIg
         6evg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747748678; x=1748353478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDhxmEmBJCOi9C5FqDCLhfpR2mct4F/9MZxHaaQaBSU=;
        b=hF/4T4SV6xLzuExUUX/mXjrSPKov8smnUjEogGZbBiVwtsb/raWnkFaaqntaOx9R+r
         g8Zb/AOdRjBk0WdT70Z0Q8RkTu2Tvf1XCvXCZrgd+q+QZdV7MomUhVYkaBei03C9PIa2
         RzXsAv9uNm9Xaf1cPiVbetaAWrw4d0x9WVHgorJlUDcdZxr6phHlJkoB6cLGSGFXnIjd
         1DzZPRiCCEQ/ImK2QEnBl09ZmSz71rJUzIpm7w4g8Pp0/WC6tJJ0+oNz72ciM9ZK4VFU
         pLvreNkFocxRMEsDOeQDJLRoeA3Bcrrn1hHENuqLjlpy0wTTBDynRhpnuIzKM0slMX/I
         7xeg==
X-Forwarded-Encrypted: i=1; AJvYcCX2YVLlLV0YAeMMsLxZj+WPoktWf1Bc/sy7+057kOks8ChtmeQKHTd5teImpecOL+78MnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYdJDkU6DxHcOLV0sLAri4xNeuJ9mP2ppIi5d14a0OHcMp2b0F
	8VdSlr5BfE6WGGRL29O3CHMOD16bZ1/1lU8CaMnPP3JEudyZb5ViVDVTfIltEY/4M6oYMeFrB3X
	9Xk97dx8M8rxqvggzwXig0ip6fVoMCRJECCarshGZlXQMWKYJZQAHs0B7U/axWw==
X-Gm-Gg: ASbGncv70Om2Gs9WO/Ai5DanDV+zqqW1hsjnkAkm95by4bXuTGE5G6zPFZe4PaDh9h4
	FTPhzklJLe+fbSGmz1ac60iGT/jTkyfLdZYHva8nZxd+EEJuB3H/Asoi0VWM+8MeJqnMepyWgnF
	WIsw2k2DxMZwDffAWnLN0Ld3kAjT1t1gqE5l4PvaHOvvvDX0lusVC+KUZBU2XiOyHy8IIeOw47
X-Google-Smtp-Source: AGHT+IEAGzEK7+d5dGC7An9XO9/rZB0x5A3JgqCt9w6LYMAXC3XXcq3MMbSTvuEFcQWlv7WLcC0Upx6iAuvLadbpsFQ=
X-Received: by 2002:a05:622a:593:b0:494:b06f:7495 with SMTP id
 d75a77b69052e-49595c5d6aamr12473781cf.24.1747748677631; Tue, 20 May 2025
 06:44:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com>
 <CA+EHjTxtHOgichL=UvAzczoqS1608RSUNn5HbmBw2NceO941ng@mail.gmail.com> <CAGtprH8eR_S50xDnnMLHNCuXrN2Lv_0mBRzA_pcTtNbnVvdv2A@mail.gmail.com>
In-Reply-To: <CAGtprH8eR_S50xDnnMLHNCuXrN2Lv_0mBRzA_pcTtNbnVvdv2A@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 May 2025 14:44:01 +0100
X-Gm-Features: AX0GCFtGXwIv4_HeLjwlHKE3QhTeg0Aqjxyqz2lDpW6dkrIiHWrsyt9QAdVgIJA
Message-ID: <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-fsdevel@vger.kernel.org, 
	aik@amd.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, bfoster@redhat.com, binbin.wu@linux.intel.com, 
	brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com, 
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, graf@amazon.com, haibo1.xu@intel.com, 
	hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
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
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, thomas.lendacky@amd.com, 
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vishal,

On Tue, 20 May 2025 at 14:02, Vishal Annapurve <vannapurve@google.com> wrot=
e:
>
> On Tue, May 20, 2025 at 2:23=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > Hi Ackerley,
> >
> > On Thu, 15 May 2025 at 00:43, Ackerley Tng <ackerleytng@google.com> wro=
te:
> > >
> > > The two new guest_memfd ioctls KVM_GMEM_CONVERT_SHARED and
> > > KVM_GMEM_CONVERT_PRIVATE convert the requested memory ranges to share=
d
> > > and private respectively.
> >
> > I have a high level question about this particular patch and this
> > approach for conversion: why do we need IOCTLs to manage conversion
> > between private and shared?
> >
> > In the presentations I gave at LPC [1, 2], and in my latest patch
> > series that performs in-place conversion [3] and the associated (by
> > now outdated) state diagram [4], I didn't see the need to have a
> > userspace-facing interface to manage that. KVM has all the information
> > it needs to handle conversions, which are triggered by the guest. To
> > me this seems like it adds additional complexity, as well as a user
> > facing interface that we would need to maintain.
> >
> > There are various ways we could handle conversion without explicit
> > interference from userspace. What I had in mind is the following (as
> > an example, details can vary according to VM type). I will use use the
> > case of conversion from shared to private because that is the more
> > complicated (interesting) case:
> >
> > - Guest issues a hypercall to request that a shared folio become privat=
e.
> >
> > - The hypervisor receives the call, and passes it to KVM.
> >
> > - KVM unmaps the folio from the guest stage-2 (EPT I think in x86
> > parlance), and unmaps it from the host. The host however, could still
> > have references (e.g., GUP).
> >
> > - KVM exits to the host (hypervisor call exit), with the information
> > that the folio has been unshared from it.
> >
> > - A well behaving host would now get rid of all of its references
> > (e.g., release GUPs), perform a VCPU run, and the guest continues
> > running as normal. I expect this to be the common case.
> >
> > But to handle the more interesting situation, let's say that the host
> > doesn't do it immediately, and for some reason it holds on to some
> > references to that folio.
> >
> > - Even if that's the case, the guest can still run *. If the guest
> > tries to access the folio, KVM detects that access when it tries to
> > fault it into the guest, sees that the host still has references to
> > that folio, and exits back to the host with a memory fault exit. At
> > this point, the VCPU that has tried to fault in that particular folio
> > cannot continue running as long as it cannot fault in that folio.
>
> Are you talking about the following scheme?
> 1) guest_memfd checks shareability on each get pfn and if there is a
> mismatch exit to the host.

I think we are not really on the same page here (no pun intended :) ).
I'll try to answer your questions anyway...

Which get_pfn? Are you referring to get_pfn when faulting the page
into the guest or into the host?

> 2) host user space has to guess whether it's a pending refcount or
> whether it's an actual mismatch.

No need to guess. VCPU run will let it know exactly why it's exiting.

> 3) guest_memfd will maintain a third state
> "pending_private_conversion" or equivalent which will transition to
> private upon the last refcount drop of each page.
>
> If conversion is triggered by userspace (in case of pKVM, it will be
> triggered from within the KVM (?)):

Why would conversion be triggered by userspace? As far as I know, it's
the guest that triggers the conversion.

> * Conversion will just fail if there are extra refcounts and userspace
> can try to get rid of extra refcounts on the range while it has enough
> context without hitting any ambiguity with memory fault exit.
> * guest_memfd will not have to deal with this extra state from 3 above
> and overall guest_memfd conversion handling becomes relatively
> simpler.

That's not really related. The extra state isn't necessary any more
once we agreed in the previous discussion that we will retry instead.

> Note that for x86 CoCo cases, memory conversion is already triggered
> by userspace using KVM ioctl, this series is proposing to use
> guest_memfd ioctl to do the same.

The reason why for x86 CoCo cases conversion is already triggered by
userspace using KVM ioctl is that it has to, since shared memory and
private memory are two separate pages, and userspace needs to manage
that. Sharing memory in place removes the need for that.

This series isn't using the same ioctl, it's introducing new ones to
perform a task that as far as I can tell so far, KVM can handle by
itself.

>  - Allows not having to keep track of separate shared/private range
> information in KVM.

This patch series is already tracking shared/private range information in K=
VM.

>  - Simpler handling of the conversion process done per guest_memfd
> rather than for full range.
>      - Userspace can handle the rollback as needed, simplifying error
> handling in guest_memfd.
>  - guest_memfd is single source of truth and notifies the users of
> shareability change.
>      - e.g. IOMMU, userspace, KVM MMU all can be registered for
> getting notifications from guest_memfd directly and will get notified
> for invalidation upon shareability attribute updates.

All of these can still be done without introducing a new ioctl.

Cheers,
/fuad

