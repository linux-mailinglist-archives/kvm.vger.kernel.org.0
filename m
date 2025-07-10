Return-Path: <kvm+bounces-52012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A538AFF7A9
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 05:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD83D1887961
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8870283FDD;
	Thu, 10 Jul 2025 03:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PK4EnXIu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D7F281368
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 03:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752118792; cv=none; b=fRzOz3D2SszRHE5+beQ+x0/UCQuDqBFTl2Z17RcMLUmcG9v4clAGMk+61YOPi/J61QhHsn+YZaJ/kplXKChFWMarcCzGOrEoBx+GyhDyX7FpP4bihXa+H8UZwzoemOen0PxgY3Uh7pPzB4XKtwSV5biY348qGXG0Vvl9vG5xKUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752118792; c=relaxed/simple;
	bh=ltuIyEGsYKAVkUC8bI6NbuIrfZ6n2CS6dG1w/GUIO1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ij4QuHQbpiwVm9cOjtyi+UXLvsfRYeQwwmljoKzWtavs0HNLuX/5PDFydrPYfZ9DpqoocHWOTmJR9WRaTlS9psB2crvT5I4RUmPQjheddyooLbfptPoxRJmEVvxcazB5yCXteR6ZZowT2lj324bcwOH+tkHISmftnJu7ElNfMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PK4EnXIu; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2357c61cda7so60995ad.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 20:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752118790; x=1752723590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRlQ79ljXXr6mSwltdgFEe59EkK6pS6NPipORQRa7q4=;
        b=PK4EnXIugTaCkLILbQR23ljaZ70cbRK7yDJLqBV25pv2DGAsklGLRirjxi/b96naEm
         zVck4NAy1lbGXakYhfKMgW9KGPXBrXtw3Qv3/kQ8S2m05KPj6UNQ65Tc6rexKkUrqvvg
         cK/VkeoOM2z8g2NnDhH1YM2HvvOMbged0AJf+0BudW6Ysfs2+Cj1BhzZ47J+JbuuAu/w
         8DstFQdjcFsU/SAoZ5YI4NdWXohacMYH3v+jz9PSPd/+odSN+jgolOKNXewAcZf0vJ8h
         o6IFgrZ/T2xOoi9wA+qDO2etf9fpuVdT26kBKrW24nQotsSsu6t6br89CjYF/om/ThGI
         NeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752118790; x=1752723590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRlQ79ljXXr6mSwltdgFEe59EkK6pS6NPipORQRa7q4=;
        b=Pf53itwmvCxeTky98Y4bmXUvXE3Aj+M22Jy1sV3gIsxX3ruSqPkBvRcmDU3RxpPUYL
         6IdGnUHQyQ7wE7mXLNldbExONZQCws7D90DXJ0fH/ZmkREDBf9GDqTGwsiwbOKslDdsP
         OhHJnl+jpJ7g0hK1+U0H0pqo86iQ0mWhxREGyHeNAtvAaINAsHVP++UiLm7hR0w3BD0g
         oyFrT8CcIAZOOprXu5Nf5qiO4v2tvnDi6IF9Rqh1ZG809w9ExB+OlR31k178DzioHKKl
         ix7KaE/HCRy8tVORNmOh9GooZM9vpxCTgzY1r8y9dGI/prvB5ZLxlXLZjs9zseigqRuk
         9Jwg==
X-Forwarded-Encrypted: i=1; AJvYcCVh+vHvguI9AM5VnKML2qQHOtfczYr6aMg0a2qW51XgCa1EJEJjFdukubTdrXHgi+gR7fY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2f5qxh6AOzHZduv+/037/sYUvhl/kyTv4k1EvlSuXQoEA7RIT
	p8rrXL6sp3MM8Qcut79RdgKHV7u9Gv8ggKi29ttjQlyX/594CBBXeFsaIK3fkX0yPJlh+sfrpe9
	8LHpLapU0KNGTULU4+Ua5TYi96wGy6d4+q0zpm2sbWLELXBvFwsabutH83NI=
X-Gm-Gg: ASbGncuygYU2e1yqFGx7z0+P7dLLQUiCJmxikWmrcNazdtPbe9azT82I8jAqOxG1AMl
	CA1EihtVcQfRU260I0boIiGlImX9KtTc13RTD1QXdqD79EmAYmYAuDS0v4Ewbt2k3lwwU/I0vMg
	vjVyvsXW3WCWWn1yZNRvESnXYP1IABI1DeoKP3LC9UJ9lSAAu1EDeO2onnoBBG1vZNFf4Ez9Ea6
	w==
X-Google-Smtp-Source: AGHT+IFNdXMLLMHzYyYMCLYInTnZ0FqKDLOyiXEeczMGTqoYZAimdGifr5hKh7FXeaefcn7hZsZlz0Q2uZ9bsaSqKBg=
X-Received: by 2002:a17:902:cec8:b0:231:d0ef:e8ff with SMTP id
 d9443c01a7336-23de372b919mr1790925ad.8.1752118789639; Wed, 09 Jul 2025
 20:39:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGtprH_57HN4Psxr5MzAZ6k+mLEON2jVzrLH4Tk+Ws29JJuL4Q@mail.gmail.com>
 <006899ccedf93f45082390460620753090c01914.camel@intel.com>
 <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com>
 <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
 <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com>
 <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
 <aG1dbD2Xnpi_Cqf_@google.com> <5decd42b3239d665d5e6c5c23e58c16c86488ca8.camel@intel.com>
 <aG1ps4uC4jyr8ED1@google.com> <CAGtprH86N7XgEXq0UyOexjVRXYV1KdOguURVOYXTnQzsTHPrJQ@mail.gmail.com>
 <c9bf0d3eca32026fae58c6d0ce3298ec01629d33.camel@intel.com>
In-Reply-To: <c9bf0d3eca32026fae58c6d0ce3298ec01629d33.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 9 Jul 2025 20:39:36 -0700
X-Gm-Features: Ac12FXzLm-0HLY-D-VuCf-_kpUdqDwZmo7Dl0JNusIPodOTsjQNE_6ODLGzw0B4
Message-ID: <CAGtprH9v=bw2q7ogo0Z46icsVWMUhm1ryyxdRFuiMkcGgxrw2w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pvorel@suse.cz" <pvorel@suse.cz>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"Miao, Jun" <jun.miao@intel.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"amoorthy@google.com" <amoorthy@google.com>, "tabba@google.com" <tabba@google.com>, 
	"maz@kernel.org" <maz@kernel.org>, "quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, "jack@suse.cz" <jack@suse.cz>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Wang, Wei W" <wei.w.wang@intel.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "willy@infradead.org" <willy@infradead.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"aik@amd.com" <aik@amd.com>, "usama.arif@bytedance.com" <usama.arif@bytedance.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "fvdl@google.com" <fvdl@google.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"nsaenz@amazon.es" <nsaenz@amazon.es>, "anup@brainfault.org" <anup@brainfault.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mic@digikod.net" <mic@digikod.net>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "Du, Fan" <fan.du@intel.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "steven.price@arm.com" <steven.price@arm.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hughd@google.com" <hughd@google.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "Xu, Haibo1" <haibo1.xu@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"steven.sistare@oracle.com" <steven.sistare@oracle.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"Huang, Kai" <kai.huang@intel.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"bfoster@redhat.com" <bfoster@redhat.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"Graf, Alexander" <graf@amazon.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "jgowans@amazon.com" <jgowans@amazon.com>, 
	"Xu, Yilun" <yilun.xu@intel.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"Weiny, Ira" <ira.weiny@intel.com>, 
	"richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pgonda@google.com" <pgonda@google.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, "roypat@amazon.co.uk" <roypat@amazon.co.uk>, 
	"hch@infradead.org" <hch@infradead.org>, "will@kernel.org" <will@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 8:17=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Wed, 2025-07-09 at 07:28 -0700, Vishal Annapurve wrote:
> > I think we can simplify the role of guest_memfd in line with discussion=
 [1]:
> > 1) guest_memfd is a memory provider for userspace, KVM, IOMMU.
> >          - It allows fallocate to populate/deallocate memory
> > 2) guest_memfd supports the notion of private/shared faults.
> > 3) guest_memfd supports memory access control:
> >          - It allows shared faults from userspace, KVM, IOMMU
> >          - It allows private faults from KVM, IOMMU
> > 4) guest_memfd supports changing access control on its ranges between
> > shared/private.
> >          - It notifies the users to invalidate their mappings for the
> > ranges getting converted/truncated.
>
> KVM needs to know if a GFN is private/shared. I think it is also intended=
 to now
> be a repository for this information, right? Besides invalidations, it ne=
eds to
> be queryable.

Yeah, that interface can be added as well. Though, if possible KVM can
just directly pass the fault type to guest_memfd and it can return an
error if the fault type doesn't match the permission. Additionally KVM
does query the mapping order for a certain pfn/gfn which will need to
be supported as well.

>
> >
> > Responsibilities that ideally should not be taken up by guest_memfd:
> > 1) guest_memfd can not initiate pre-faulting on behalf of it's users.
> > 2) guest_memfd should not be directly communicating with the
> > underlying architecture layers.
> >          - All communication should go via KVM/IOMMU.
>
> Maybe stronger, there should be generic gmem behaviors. Not any special
> if (vm_type =3D=3D tdx) type logic.
>
> > 3) KVM should ideally associate the lifetime of backing
> > pagetables/protection tables/RMP tables with the lifetime of the
> > binding of memslots with guest_memfd.
> >          - Today KVM SNP logic ties RMP table entry lifetimes with how
> > long the folios are mapped in guest_memfd, which I think should be
> > revisited.
>
> I don't understand the problem. KVM needs to respond to user accessible
> invalidations, but how long it keeps other resources around could be usef=
ul for
> various optimizations. Like deferring work to a work queue or something.

I don't think it could be deferred to a work queue as the RMP table
entries will need to be removed synchronously once the last reference
on the guest_memfd drops, unless memory itself is kept around after
filemap eviction. I can see benefits of this approach for handling
scenarios like intrahost-migration.

>
> I think it would help to just target the ackerly series goals. We should =
get
> that code into shape and this kind of stuff will fall out of it.
>
> >
> > Some very early thoughts on how guest_memfd could be laid out for the l=
ong term:
> > 1) guest_memfd code ideally should be built-in to the kernel.
> > 2) guest_memfd instances should still be created using KVM IOCTLs that
> > carry specific capabilities/restrictions for its users based on the
> > backing VM/arch.
> > 3) Any outgoing communication from guest_memfd to it's users like
> > userspace/KVM/IOMMU should be via notifiers to invalidate similar to
> > how MMU notifiers work.
> > 4) KVM and IOMMU can implement intermediate layers to handle
> > interaction with guest_memfd.
> >      - e.g. there could be a layer within kvm that handles:
> >              - creating guest_memfd files and associating a
> > kvm_gmem_context with those files.
> >              - memslot binding
> >                        - kvm_gmem_context will be used to bind kvm
> > memslots with the context ranges.
> >              - invalidate notifier handling
> >                         - kvm_gmem_context will be used to intercept
> > guest_memfd callbacks and
> >                           translate them to the right GPA ranges.
> >              - linking
> >                         - kvm_gmem_context can be linked to different
> > KVM instances.
>
> We can probably look at the code to decide these.
>

Agree.

