Return-Path: <kvm+bounces-52007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80207AFF669
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC1217AF14D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E5527E1C6;
	Thu, 10 Jul 2025 01:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qt7vjTZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DFB1E50B
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 01:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752111039; cv=none; b=k1bCZUE9w5hbpzByYII+cimQQvZfnLsAgrJNHpc3OmVSd+M6RsUtN2Kwqk09+8HE4QmPrSVdApwMrCXKxX+jWUS59vnW0wQbdGJy94P4HJtGqHpb+bTX+cgpc1p7IdaMNyp081FWZO4dOlSgLmRAyY9jkn8hycswm4HK6piuIXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752111039; c=relaxed/simple;
	bh=cwlgChzOqSfKCiRvjUu84m9aH/2achBZS5mS3a+AbGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuhkrWxTagLGnlyZe77Rn/SujxjrTWAILqbPh+4CE6/M/BKvfvSX12lD9psDJ5k83BmwbAsF05Gy7XKJESdf7Lv6TzKzP+/cF62cimYBfpCURAFM0Vk18SJNQmFnenyxy2ae8Nnp1/FgS2dfD+nMRt3IAErB7XhdSenruk2N9Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qt7vjTZB; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23dd9ae5aacso56895ad.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 18:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752111037; x=1752715837; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Is04f/Bkm7gJJ/jV1LRjXX51WkiBnOdhDaBr6UaJT6Q=;
        b=qt7vjTZBOSl2e4TphPTy2W3hTeBjLXqu4dyqx5skISoVZdsGx5rcvZWEfc/9ROOEak
         249pd604w+dTfp4d06nv7e6Wwe0wfNPxdL4bAB8lMd3f6jqOiAP/IEUkFffrEQ5FO+RW
         e15/GHTSb64wK+HW9PHg7ntVM9Jc0eGBaaz1MsBdABW28+TQymyG9g++XDifdXgovA4A
         Ln24pXXh2uOutLtrbTsq+g81rT0Ltz5E+owZBpIeWVID+3HXQbiOklu8abQA3It2y0Uf
         6M0N4yap6vqyV9JCnJhkFTPh2fxitg+su+qlqkKKAKjpSCbjtRTMLZ5UEvy74emZ+fFW
         8J8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752111037; x=1752715837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Is04f/Bkm7gJJ/jV1LRjXX51WkiBnOdhDaBr6UaJT6Q=;
        b=PcjWmQKixQl9YKbt+njyIca+xZkSHy/0LFes/lM5gBxjPkuMzFGarGWn9MUJuSeoWi
         zXCSRTvPO9nsbmmr3Zcu89hY4dzJvPbelJmdpf9n74bcilp/IViumCXW9bK2xvxsxvwt
         FMzGeHzRxst/ogw0MZ/R/vwKh+5yp0kbEbruohTsSLg7efLusq5vanJRmvNP/Z9eGtaS
         N9uQgNQCLoNt9IqPLXmqE2nReA9Oc6Y6yULQOtp4ygWBfS/O6itdSEsLwy24KN2WSKD8
         j+6BZsqLFS0SBc4OmAmGnQ3AcRkxoPXnktWGNXcfbUVp+msJK5qzTT9DHOFSQxOlCcRO
         ur3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWL7aXUfctJl9l2Vcq2XnqUOsfNezMb6qZH1MYXb5pMJNlM0sjeupo+8CWwN5QIz9rpzsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/4l9GY8r1W3pgvSnAz03iC7pjVgBOgvdGjE7pwUiCBw12pjx
	ZYkw7QXQMJZWH256wybKTOQkf8AeR1WsSwGeE69MrW6MCO8S7A4ChXc76tOrlzsGXdRS2eoOrm2
	WMVFpOmiIadyj5859Q4PGuXWLZEDdV6E1FCY9needIR71+YCPhUFHRosIbY0HsQ==
X-Gm-Gg: ASbGncv5QOj5BN/Iza1V4eoUUDTG//HMuXFPCpEYrG5SLjFT+Qlx+pt8vF/tc8Fr50b
	S+IR9STNTUC5f13JDmRndRbX3RYc/i8MXP7dVGE+JSMA27GxX2IPvUA9bUmpuiXbJna9+tl3sLA
	wI8iTU0q5Q/PE0YjPAYNjTR5Puudu6hRPuVCuLRaqW4yPAkUfG0p1679cffa5pKxnO3u1tWFmqV
	g==
X-Google-Smtp-Source: AGHT+IHQRxLhKTVLkbXOo+VEMkswy/Fljlw0yFW5tZ5FbAGr3AvPtN+zX/l8wR12tsrz7uBXDg3nz5YzYaXHlJhS9FA=
X-Received: by 2002:a17:903:2350:b0:23c:7be2:59d0 with SMTP id
 d9443c01a7336-23de43709f4mr1099425ad.23.1752111036578; Wed, 09 Jul 2025
 18:30:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com>
 <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
 <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com>
 <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
 <aG1dbD2Xnpi_Cqf_@google.com> <5decd42b3239d665d5e6c5c23e58c16c86488ca8.camel@intel.com>
 <aG1ps4uC4jyr8ED1@google.com> <CAGtprH86N7XgEXq0UyOexjVRXYV1KdOguURVOYXTnQzsTHPrJQ@mail.gmail.com>
 <aG6D9NqG0r6iKPL0@google.com>
In-Reply-To: <aG6D9NqG0r6iKPL0@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 9 Jul 2025 18:30:23 -0700
X-Gm-Features: Ac12FXw12BTQ2UDgvxWfgcVv3vtRLhBXnJJTOmc7eonn3MPXMwv6b46DcRxjVuk
Message-ID: <CAGtprH_DY=Sjeh32NCc7Y3t2Vug8LKz+-=df4oSw09cRbb6QZw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pvorel@suse.cz" <pvorel@suse.cz>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	Jun Miao <jun.miao@intel.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"amoorthy@google.com" <amoorthy@google.com>, "tabba@google.com" <tabba@google.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, "maz@kernel.org" <maz@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Wei W Wang <wei.w.wang@intel.com>, 
	Fan Du <fan.du@intel.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, Dave Hansen <dave.hansen@intel.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "aik@amd.com" <aik@amd.com>, 
	"usama.arif@bytedance.com" <usama.arif@bytedance.com>, "fvdl@google.com" <fvdl@google.com>, 
	"jack@suse.cz" <jack@suse.cz>, "quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	Kirill Shutemov <kirill.shutemov@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "anup@brainfault.org" <anup@brainfault.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "keirf@google.com" <keirf@google.com>, 
	"mic@digikod.net" <mic@digikod.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nsaenz@amazon.es" <nsaenz@amazon.es>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	Zhiquan1 Li <zhiquan1.li@intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hughd@google.com" <hughd@google.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, Haibo1 Xu <haibo1.xu@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "steven.sistare@oracle.com" <steven.sistare@oracle.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, Chao P Peng <chao.p.peng@intel.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, Alexander Graf <graf@amazon.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, Yilun Xu <yilun.xu@intel.com>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Ira Weiny <ira.weiny@intel.com>, 
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

On Wed, Jul 9, 2025 at 8:00=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Jul 09, 2025, Vishal Annapurve wrote:
> > I think we can simplify the role of guest_memfd in line with discussion=
 [1]:
>
> I genuinely don't understand what you're trying to "simplify".  We need t=
o define
> an ABI that is flexible and robust, but beyond that most of these guideli=
nes boil
> down to "don't write bad code".

My goal for bringing this discussion up is to see if we can better
define the role of guest_memfd and how it interacts with other layers,
as I see some scenarios that can be improved like kvm_gmem_populate[1]
where guest_memfd is trying to fault in pages on behalf of KVM.

[1] https://lore.kernel.org/lkml/20250703062641.3247-1-yan.y.zhao@intel.com=
/

>
> > 1) guest_memfd is a memory provider for userspace, KVM, IOMMU.
>
> No, guest_memfd is a memory provider for KVM guests.  That memory *might*=
 be
> mapped by userspace and/or into IOMMU page tables in order out of functio=
nal
> necessity, but guest_memfd exists solely to serve memory to KVM guests, f=
ull stop.

I look at this as guest_memfd should serve memory to KVM guests and to
other users by following some KVM/Arch related guidelines e.g. for CC
VMs, guest_memfd can handle certain behavior differently.

>
> > 3) KVM should ideally associate the lifetime of backing
> > pagetables/protection tables/RMP tables with the lifetime of the
> > binding of memslots with guest_memfd.
>
> Again, please align your indentation.
>
> >          - Today KVM SNP logic ties RMP table entry lifetimes with how
> >            long the folios are mapped in guest_memfd, which I think sho=
uld be
> >            revisited.
>
> Why?  Memslots are ephemeral per-"struct kvm" mappings.  RMP entries and =
guest_memfd
> inodes are tied to the Virtual Machine, not to the "struct kvm" instance.

IIUC guest_memfd can only be accessed through the window of memslots
and if there are no memslots I don't see the reason for memory still
being associated with "virtual machine". Likely because I am yet to
completely wrap my head around 'guest_memfd inodes are tied to the
Virtual Machine, not to the "struct kvm" instance', I need to spend
more time on this one.

>
> > Some very early thoughts on how guest_memfd could be laid out for the l=
ong term:
> > 1) guest_memfd code ideally should be built-in to the kernel.
>
> Why?  How is this at all relevant?  If we need to bake some parts of gues=
t_memfd
> into the kernel in order to avoid nasty exports and/or ordering dependenc=
ies, then
> we can do so.  But that is 100% an implementation detail and in no way a =
design
> goal.

I agree, this is implementation detail and we need real code to
discuss this better.

