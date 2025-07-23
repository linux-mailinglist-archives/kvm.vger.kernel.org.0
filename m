Return-Path: <kvm+bounces-53254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F67B0F4F0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 716C6581F2A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D18C2F50B7;
	Wed, 23 Jul 2025 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Advi8hc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D48E290BA2
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753279726; cv=none; b=NmpgVLXVXf4nimIVLjAQ3sVDBeb0bnXfWej00hTeaRS3o0eMWUAHEZhTahoNC3iH2SY5UM9YPotWQASd7PfIGXPjF83qV/uFqN8OBkvehmVtc9BAxVDlVI/xyYfOuczD8tTtfoDYXXZ6nN8ifXGy7wURY4Kz0CS0jJVDpJxQnq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753279726; c=relaxed/simple;
	bh=tq5Kf8dwR7CYoLdEJRggmZPGMKe1UsIP7+oXnldstQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMOJixVwj4n0IIIvhVrKXwb3A7PMj/n/E1/28LwYN1tzzXYfX4kssaESdzhrkYGY8j2w6akGD0Y7N2zCZxH3i9c/WExjxeFT5xjkMsnesxBfUrbgl4n+BStRE32zYYONeyjpJxNL3fIAuN9y42QY6VGHTYGN6FIXF//Kv7JGnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Advi8hc; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235e389599fso219665ad.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753279723; x=1753884523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=3Advi8hcHpnm/Al4pmWaF4sOuPwCPxynCRVmkUrYSzJ8H8cSygecInNrVnh83YqAcQ
         VoxdjACmDWCRWH2rb79LTi8/6/ub3UXrUWngIitA/W/IlIFU7WAI9Ma3c+pCLQQAyD09
         q9PLi+ACkk/jQ5HOQ7YYXnyW/KVYVS8kIa8YwJHojN6HaEUHM0ytAu88KrOcZg8DKhny
         O1NhXI1ZjP/mvx+QITts4VKsc7lesVs9Ap6UtKmOb1xMGUYMvwWq4fpyK+FZh4HwaRKD
         s9sYrNP8U4OyTPf3ZpKQH/5B0SDfG0nixLZgQbpT511kAR7wgufL60R3TUfE48MhIWKK
         qDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279723; x=1753884523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=PKvV4mF7I0vRhc2UA7nU+kolbk3fur78aT24rIwBFuYE99X5e89cxUPym8r9DeVQCW
         goCqhy+Xgp/Vyi3IBfvBvlb/asA90mdQMkQxJxoa1jUVD3KnvBhNyMCGeFjJr61aZVjS
         p3QToSGowaiBD7V4S0HGRQTUj6UcNRHLJxc4BVtRl1/nFuVoovtD5/3s9tIX4L4kZ/IC
         IRImxReKs4eo6MFc/5F2DUWZR1UayfV86D6608ygcT4wOjqipY8uX0uPjxhjsW5odeXT
         Ov2w3TEdjlFNusC6Qiz1WOqLwFwv6PynX8l0OFOeKYsxAoD91YTgkqXHQOi2298G28NE
         cbqg==
X-Forwarded-Encrypted: i=1; AJvYcCXCsfUJMEoSE+Xx2YybykCecJiibi0D/XePBzTC1lfOa+9gJGU4IHsaJqHTdloBVkj77M8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxscuLJmwZnvGyzgBgIZuitYfJr6RmodUztQx4Y0UMFrSxWVw7S
	zsIHNaFwgk37x3oWqKA0A67rTykTjR528WF6Vn0m6fRp6zau0Rw4j8RlXdgVkyieSyHMEnn9NiF
	hrPUWAMmWMItOdKDiUNMGFbIQxn2+McRNB9MoazFA
X-Gm-Gg: ASbGncvI6o7vR/EpWHi038TmuVPPeBZGI/VByjVGGZEc3vKqojQf+HeJtMjXPTl2ief
	+MWwlfgERcWoBjmQhMhIr8quw4huMTe6IDayII85iY8I5eMCLslvacuZNhNMbghfSGsD5Ug0fm4
	slJyh1VPKY7Sa162rksYGZ/Px+iSOpUPTEMpY+34EOTid7jKoqDyEb15kcfaNGWuucp9tOPKVdR
	Atr0hrvRLkcifVPZm86VYwCqHcBLPqKArohDP4S
X-Google-Smtp-Source: AGHT+IGTqBd89Hz2FU5+XDL1Pa3oPTMlfNKSx7fc+kyEKrz2+R2DB3L/Vg2Q/bKXh/ftc4wQ1ninLLDh9ZPqaALt4Zs=
X-Received: by 2002:a17:903:1a2e:b0:235:e8da:8e1 with SMTP id
 d9443c01a7336-23f978e11f0mr3711085ad.18.1753279722891; Wed, 23 Jul 2025
 07:08:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com>
In-Reply-To: <aH-hxiD2DwovFpqg@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 23 Jul 2025 07:08:30 -0700
X-Gm-Features: Ac12FXwpJ1aG0BseZ1JbWyOGHq9d8eSgResVmgCZ2LYsmpKUxZNm4vyPGOyUMSQ
Message-ID: <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2025 at 7:35=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > > > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > >
> > > > > > > > 2) KVM fetches shared faults through userspace page tables =
and not
> > > > > > > > guest_memfd directly.
> > > > > > >
> > > > > > > This is also irrelevant.  KVM _already_ supports resolving sh=
ared faults through
> > > > > > > userspace page tables.  That support won't go away as KVM wil=
l always need/want
> > > > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the gue=
st (even for TDX).
> > > >
> > > > As a combination of [1] and [2], I believe we are saying that for
> > > > memslots backed by mappable guest_memfd files, KVM will always serv=
e
> > > > both shared/private faults using kvm_gmem_get_pfn().
> > >
> > > No, KVM can't guarantee that with taking and holding mmap_lock across=
 hva_to_pfn(),
> > > and as I mentioned earlier in the thread, that's a non-starter for me=
.
> >
> > I think what you mean is that if KVM wants to enforce the behavior
> > that VMAs passed by the userspace are backed by the same guest_memfd
> > file as passed in the memslot then KVM will need to hold mmap_lock
> > across hva_to_pfn() to verify that.
>
> No, I'm talking about the case where userspace creates a memslot *without=
*
> KVM_MEM_GUEST_MEMFD, but with userspace_addr pointing at a mmap()'d guest=
_memfd
> instance.  That is the scenario Xiaoyao brought up:
>
>  : Actually, QEMU can use gmem with mmap support as the normal memory eve=
n
>  : without passing the gmem fd to kvm_userspace_memory_region2.guest_memf=
d
>  : on KVM_SET_USER_MEMORY_REGION2.
>  :
>  : ...
>  :
>  : However, it fails actually, because the kvm_arch_suports_gmem_mmap()
>  : returns false for TDX VMs, which means userspace cannot allocate gmem
>  : with mmap just for shared memory for TDX.

Ok, yeah. I completely misjudged the usecase that Xiaoyao brought up.
You are right.

These are two different scenarios that I mixed up:
1) Userspace brings a non-mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2) : This is the legacy case that needs
separate memory to back userspace_addr. As Sean mentioned, userspace
should be able to bring VMAs backed by any mappable files including
guest_memfd except mappable guest_memfd is not supported for SNP/TDX
VMs today, that support will come in stage2. KVM doesn't need to
enforce anything here as we can be sure that VMAs and unmappable
guest_memfd are pointing to different physical ranges.

2) Userspace brings a mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
faults via guest_memfd so if userspace brings in VMAs that point to
different physical memory then there would be a discrepancy between
what guest and userspace/KVM (going through HVAs) sees for shared
memory ranges. I am not sure if KVM needs to enforce anything here,
IMO it's the problem between userspace and guest to resolve. One thing
we may need to resolve is that invalidations of KVM EPT/NPT tables for
shared ranges should be triggered only by guest_memfd invalidations
(This is something we need to resolve when conversions will be
supported on guest_memfd i.e. not for this series, but the next
stage).

