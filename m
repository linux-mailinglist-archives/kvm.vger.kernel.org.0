Return-Path: <kvm+bounces-10219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA8986ABC4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED1F61F22D74
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A3A364AC;
	Wed, 28 Feb 2024 09:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kkcUVHEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B0F3612C
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709114275; cv=none; b=gHQeXvhQPjd2FYyQ7aUWi7mhTGLq4eBOMu1ZELDcSMbaam063rA1kXLKbjp00GcC6V2aootHi+MhXE/MQ2AYad4FMY0ugjpKC6kA9f29cMCxTeR2sLdKHENSJ7vnXbG8fdI44D3Ple5TIF5CV6NBZsaKiiQ0Vrt88XGi4+iGGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709114275; c=relaxed/simple;
	bh=QkO2zf7+QCCVxfW89ClH1qOCxSu2rzH4WO3ZNTBMRpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mM4bUeMkp/Eyip948WYANYC3/QWAYD+/o9ykADgtFVKJYCbAvgbodoPyM+vnWB9e7sjLh7N8aB0InCFqfYy8CnWjwGugVWiLyQxNfOMw10fHUe/MekiwqeRk+kFlxVNLTZ71MoKrIK6K7tZMFVySkccv/wercVz//45A2SkLIMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kkcUVHEO; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4706de5227aso850214137.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 01:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709114272; x=1709719072; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ae/h34M1RKWKdgDk/QRvMGO1Y6pQUzIdzZzD5IxPZg=;
        b=kkcUVHEOGTjvOwJQLnf6xIyTVHuz1RsfMv6edXNmu0V46BmQN6kr0kKYvxDlpg+lgA
         qxoh0UAHIEITUxzLF02CWVZ2jtxRnDg/+CSEn+OhO5zggnGrcwlat22yM/GNlCpU4hMC
         GqluIzzqb+QhcGguG8OIHXWHFmJ7r6gQf0O9Q6fgODgzpHrC4qK5L93ImrkMmb0Vh93h
         +8grc+xd7iUABMCQ9C1rMc69Zhit5UQBe4m5e5ByKSGCMDKjJIW4c9c1xU/aYH9LsjUk
         fJQ07NvfIx6bALAhcz97x4XkxdspEzjQOyz68/m0CdaYjurW7b1X7snFJGxg1eEcvbum
         cTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709114272; x=1709719072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ae/h34M1RKWKdgDk/QRvMGO1Y6pQUzIdzZzD5IxPZg=;
        b=QtQsDc94kS30fgUZAFnkQHio9HcITJHr+rl2CjZjQ17wnY9Vi4hvXVgUZegKsadtI+
         uQjwezYYGYnFsFKITUcWLBQhu4S7TY0hKuYo/inVdKHrpaNPngSB1/NuiElxpy3HJOQw
         28XhuuaHcP/q6DgOPkwo64uy4GpJkarOzHyrb5Cm6Uli+3iNoEx/ch5l5VyMoH8acO9n
         6UBmeb6w4SzFpLZ98bx+9Q2V232vuKqjUk8q1eOpthZgVVpwjUR2nPXj0kB4AOQSZlds
         4FfySkjHU0HNbIjli/8/9QBiWo/Te33qW8HtGmkYoAzq029DbZHo80iakcW+6I5am4Fw
         CIvQ==
X-Gm-Message-State: AOJu0YxzYWdG6VTqDksH84hi0ochNm1C6cyGdHetzL697PDkgSts3X9x
	p00iV3QrAoXtKUodAqdX7N6RcChiSi8438gX8En2Beuha0WvRPfstEFMgcqf4YgfU8djxRLmDmH
	dYZxFYJ37OiYqbhOJgLVRPRSXStcZZgcqVB7q
X-Google-Smtp-Source: AGHT+IEUCaumMzMCWHxK4rkW9OPCl7cmUhcgIZJpGO/uiJzkjDCx0cDqdeWTFo8t9uh8g/3ty7ZyznmgDXrBz8n8sFw=
X-Received: by 2002:a05:6102:212b:b0:472:58d6:af54 with SMTP id
 f11-20020a056102212b00b0047258d6af54mr3279361vsg.12.1709114271643; Wed, 28
 Feb 2024 01:57:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
 <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com> <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
In-Reply-To: <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 28 Feb 2024 09:57:14 +0000
Message-ID: <CA+EHjTxBOs3M7DNeUfq9EfpZ8wSw5Uh6SOr_fG_9V=xjTH2S_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, Feb 27, 2024 at 2:41=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> Hi,
>
> >> Can you elaborate (or point to a summary) why pKVM has to be special
> >> here? Why can't you use guest_memfd only for private memory and anothe=
r
> >> (ordinary) memfd for shared memory, like the other confidential
> >> computing technologies are planning to?
> >
> > Because the same memory location can switch back and forth between
> > being shared and private in-place. The host/vmm doesn't know
> > beforehand which parts of the guest's private memory might be shared
> > with it later, therefore, it cannot use guest_memfd() for the private
> > memory and anonymous memory for the shared memory without resorting to
>
> I don't remember the latest details about the guest_memfd incarnation in
> user space, but I though we'd be using guest_memfd for private memory
> and an ordinary memfd for shared memory. But maybe it also works with
> anon memory instead of the memfd and that was just an implementation
> detail :)
>
> > copying. Even if it did know beforehand, it wouldn't help much since
> > that memory can change back to being private later on. Other
> > confidential computing proposals like TDX and Arm CCA don't share in
> > place, and need to copy shared data between private and shared memory.
>
> Right.
>
> >
> > If you're interested, there was also a more detailed discussion about
> > this in an earlier guest_memfd() thread [1]
>
> Thanks for the pointer!
>
> >
> >> What's the main reason for that decision and can it be avoided?
> >> (s390x also shares in-place, but doesn't need any special-casing like
> >> guest_memfd provides)
> >
> > In our current implementation of pKVM, we use anonymous memory with a
> > long-term gup, and the host ends up with valid mappings. This isn't
> > just a problem for pKVM, but also for TDX and Gunyah [2, 3]. In TDX,
> > accessing guest private memory can be fatal to the host and the system
> > as a whole since it could result in a machine check. In arm64 it's not
> > necessarily fatal to the system as a whole if a userspace process were
> > to attempt the access. However, a userspace process could trick the
> > host kernel to try to access the protected guest memory, e.g., by
> > having a process A strace a malicious process B which passes protected
> > guest memory as argument to a syscall.
>
> Right.
>
> >
> > What makes pKVM and Gunyah special is that both can easily share
> > memory (and its contents) in place, since it's not encrypted, and
> > convert memory locations between shared/unshared. I'm not familiar
> > with how s390x handles sharing in place, or how it handles memory
> > donated to the guest. I assume it's by donating anonymous memory. I
> > would be also interested to know how it handles and recovers from
> > similar situations, i.e., host (userspace or kernel) trying to access
> > guest protected memory.
>
> I don't know all of the s390x "protected VM" details, but it is pretty
> similar. Take a look at arch/s390/kernel/uv.c if you are interested.
>
> There are "ultravisor" calls that can convert a page
> * from secure (inaccessible by the host) to non-secure (encrypted but
>    accessible by the host)
> * from non-secure to secure
>
> Once the host tries to access a "secure" page -- either from the kernel
> or from user space, the host gets a page fault and calls
> arch_make_page_accessible(). That will encrypt page content such that
> the host can access it (migrate/swapout/whatsoever).
>
> The host has to set aside some memory area for the ultravisor to
> "remember" page state.
>
> So you can swapout/migrate these pages, but the host will only read
> encrypted garbage. In contrast to disallowing access to these pages.
>
> So you don't need any guest_memfd games to protect from that -- and one
> doesn't have to travel back in time to have memory that isn't
> swappable/migratable and only comes in one page size.
>
> [I'm not up-to-date which obscure corner-cases CCA requirement the s390x
> implementation cannot fulfill -- like replacing pages in page tables and
> such; I suspect pKVM also cannot cover all these corner-cases]

Thanks for this. I'll do some more reading on how things work with s390x.

Right, and of course, one key difference of course is that pKVM
doesn't encrypt anything, and only relies on stage-2 protection to
protect the guest.

>
> Extending guest_memfd (the one that was promised initially to not be
> mmappable) to be mmappable just to avoid some crashes in corner cases is
> the right approach. But I'm pretty sure that has all been discussed
> before, that's why I am asking about some details :)

Thank you very much for your reviews and comments. They've already
been very helpful. I noticed the gmap.h in the s390 source, which
might also be something that we could learn from. So please do ask for
as much details as you like.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

