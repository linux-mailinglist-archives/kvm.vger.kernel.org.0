Return-Path: <kvm+bounces-36351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D98A1A439
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38AB0163549
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E7C20F083;
	Thu, 23 Jan 2025 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O4JJ9UzA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A708020E32A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737635359; cv=none; b=Ly0OpSdDeReou94ZOAq8zJPwTSkHiKwOmzAv0ze9X9lTzD3armZ9Cs3jeaxGUqbg+Nuz+OPYUpySjB9BiTpmBSsjDXM8xv063u7g4214dvt3HLyIDccLczu8UOVqNS6gEYeZT1wQ2FPJjQTWQ7OcMAEPW6vWUaNmyJd2hkslQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737635359; c=relaxed/simple;
	bh=TKIc+BSqUxTWDRXQBflfAo2GLT0I+z93EFcFnisGVl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftuDnHk5DVyIydxWiuEoN12gPtel5ZlgzQmWWCb2dF2e2EC7JmufVPjoaR3PYshGpLBjepw2XdmrUiy0r1IAmQxlPovuM9X+vJ46c3AAzKspm1MoRvxrvW/MgVTlIoXI10w59zKshkFpf3OYRJ5xhZ8MO6glRqYQZw7Q031h6Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O4JJ9UzA; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4679b5c66d0so180711cf.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 04:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737635356; x=1738240156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j5Uvwp8iLFnxoJglCUJNCQCFMuDYn+JUgCWP0ESBOZs=;
        b=O4JJ9UzAY1qyj/+zFqeNn8PsNxTBNbs9EGXdDSh9kmzuks5w83jEW7A7GjswifPIT1
         FodIVNCS1DFX8Ytb0R9eYSEM2x46/BxdUqhJY5E+3jD/F5+qWw+vRJ9fScHwkwT7fljF
         6uQOm5u3DUa6OZJv3NpDHTOfM3zvn27BePwwfaKxgnuC44xxcsfyOMnjvCgWKhT8PxOC
         NDaJIXKjXiB5RkYyFjvFEjFgezZ769z7dTMzsH0ptBVoHRgHKdswOa1OEgCtsf/kXRsY
         xwo8BUEgPjrDASdXc/6X8xT5FIORo/7PGAjoU55TUedcuTEGqsAerGx3gEEJXXGm3NiO
         xz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737635356; x=1738240156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5Uvwp8iLFnxoJglCUJNCQCFMuDYn+JUgCWP0ESBOZs=;
        b=M4/prn0jX6eoNFIr+4Ke10nr8pElnEK06Nm8CxNe+QZCuizIkdWTFmOMju+JGdbI9V
         g0oYYgd8F+bmAckTKpx5m+Mizozb2NypE8ZNLJUlq3pjDxZo/Xj6/StOK7V9WPXFQGvh
         LQSJqx6DL/6kIV9w2qjGog+85+5f7GksVVXPi7ujmo0S/ZIqyY6P3jr4bbI2q0P1mkrD
         ROgbgtZWD7ahq/odqrsteo5or8M8zjwN/3Mp/5jvoo+fygZzYihBD+LbPYC3tDkmQJry
         6rgrTKcdCdMfyMV3pcy59OZFfanqQvbq1QZED+MjOH/DLGZmKPESwM0KO31AoadhFbDN
         3fnw==
X-Forwarded-Encrypted: i=1; AJvYcCUTIVqkx+i3VbpmQaAlaT3nXgtzyxKKt4zGqdM2zd17g18aiL2UtPM7oVpAjMKjSGoe2EY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiYBpUCYbsW4lsgxMnL4tGamSgK9Kq7NXoBAYDOQEVMehJ88j9
	SdWiP7CVxP0gH5tsFr9yGSuSdAmYX2AjhNlkZ7RH1jFAm4cv3IVn1iAD2rdfy00n/gYNlVjq+RL
	3Bj2CrLonPZXHkEZr2kNaqSyDaCSoW5jhITvO6BP91DZ5NuLh4wik
X-Gm-Gg: ASbGnctND5ufHJcEmUEWEgZRK1F5VeXBLo2CuLDeug/v6mx46EGH36rB/kRU75aHwh7
	6UIOnmFZhexlj6CgfJmGqu6dVqLIqy3RzdUMJTPcbHIew9IxTv4FXvLLJPV3nbsiVA5xNV7xYcG
	bj2yWt7d+ZntPUlg==
X-Google-Smtp-Source: AGHT+IFo7gHEqkSt24ROLr+rcgOB4gwt3zbzIxCW0GBek3MCCfZMWVQPp/KG8PZ3z3viNEVgM3hoDHsXK0zFnQOGj2c=
X-Received: by 2002:a05:622a:1342:b0:466:9af1:5a35 with SMTP id
 d75a77b69052e-46e5c11b2fdmr3773451cf.10.1737635356102; Thu, 23 Jan 2025
 04:29:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com> <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com> <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
 <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com> <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
In-Reply-To: <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 12:28:38 +0000
X-Gm-Features: AWEUYZlk27iu21ce658i7eF8nK3E5OgorA0dDMLJ2rxkwcmmmUKAFqWMqXFFLV8
Message-ID: <CA+EHjTxc0AwX2=htwC9to7+fYbFJsfVGT5d+BtEYVPncMgq1Mw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
To: Patrick Roy <roypat@amazon.co.uk>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
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
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Thu, 23 Jan 2025 at 11:57, Patrick Roy <roypat@amazon.co.uk> wrote:
>
>
>
> On Thu, 2025-01-23 at 11:39 +0000, David Hildenbrand wrote:
> > On 23.01.25 10:48, Fuad Tabba wrote:
> >> On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
> >>>
> >>> On 22.01.25 16:27, Fuad Tabba wrote:
> >>>> Make kvm_(read|/write)_guest_page() capable of accessing guest
> >>>> memory for slots that don't have a userspace address, but only if
> >>>> the memory is mappable, which also indicates that it is
> >>>> accessible by the host.
> >>>
> >>> Interesting. So far my assumption was that, for shared memory, user
> >>> space would simply mmap() guest_memdd and pass it as userspace address
> >>> to the same memslot that has this guest_memfd for private memory.
> >>>
> >>> Wouldn't that be easier in the first shot? (IOW, not require this patch
> >>> with the cost of faulting the shared page into the page table on access)
> >>
> >
> > In light of:
> >
> > https://lkml.kernel.org/r/20250117190938.93793-4-imbrenda@linux.ibm.com
> >
> > there can, in theory, be memslots that start at address 0 and have a
> > "valid" mapping. This case is done from the kernel (and on special s390x
> > hardware), though, so it does not apply here at all so far.
> >
> > In practice, getting address 0 as a valid address is unlikely, because
> > the default:
> >
> > $ sysctl  vm.mmap_min_addr
> > vm.mmap_min_addr = 65536
> >
> > usually prohibits it for good reason.
> >
> >> This has to do more with the ABI I had for pkvm and shared memory
> >> implementations, in which you don't need to specify the userspace
> >> address for memory in a guestmem memslot. The issue is there is no
> >> obvious address to map it to. This would be the case in kvm:arm64 for
> >> tracking paravirtualized time, which the userspace doesn't necessarily
> >> need to interact with, but kvm does.
> >
> > So I understand correctly: userspace wouldn't have to mmap it because it
> > is not interested in accessing it, but there is nothing speaking against
> > mmaping it, at least in the first shot.
> >
> > I assume it would not be a private memslot (so far, my understanding is
> > that internal memslots never have a guest_memfd attached).
> > kvm_gmem_create() is only called via KVM_CREATE_GUEST_MEMFD, to be set
> > on user-created memslots.
> >
> >>
> >> That said, we could always have a userspace address dedicated to
> >> mapping shared locations, and use that address when the necessity
> >> arises. Or we could always require that memslots have a userspace
> >> address, even if not used. I don't really have a strong preference.
> >
> > So, the simpler version where user space would simply mmap guest_memfd
> > to provide the address via userspace_addr would at least work for the
> > use case of paravirtualized time?
>
> fwiw, I'm currently prototyping something like this for x86 (although
> not by putting the gmem address into userspace_addr, but by adding a new
> field to memslots, so that memory attributes continue working), based on
> what we talked about at the last guest_memfd sync meeting (the whole
> "how to get MMIO emulation working for non-CoCo VMs in guest_memfd"
> story). So I guess if we're going down this route for x86, maybe it
> makes sense to do the same on ARM, for consistency?
>
> > It would get rid of the immediate need for this patch and patch #4 to
> > get it flying.
> >
> >
> > One interesting question is: when would you want shared memory in
> > guest_memfd and *not* provide it as part of the same memslot.
>
> In my testing of non-CoCo gmem VMs on ARM, I've been able to get quite
> far without giving KVM a way to internally access shared parts of gmem -
> it's why I was probing Fuad for this simplified series, because
> KVM_SW_PROTECTED_VM + mmap (for loading guest kernel) is enough to get a
> working non-CoCo VM on ARM (although I admittedly never looked at clocks
> inside the guest - maybe that's one thing that breaks if KVM can't
> access gmem. How to guest and host agree on the guest memory range
> used to exchange paravirtual timekeeping information? Could that exchange
> be intercepted in userspace, and set to shared via memory attributes (e.g.
> placed outside gmem)? That's the route I'm going down the paravirtual
> time on x86).

For an idea of what it looks like on arm64, here's how kvmtool handles it:
https://github.com/kvmtool/kvmtool/blob/master/arm/aarch64/pvtime.c

Cheers,
/fuad





> > One nice thing about the mmap might be that access go via user-space
> > page tables: E.g., __kvm_read_guest_page can just access the memory
> > without requiring the folio lock and an additional temporary folio
> > reference on every access -- it's handled implicitly via the mapcount.
> >
> > (of course, to map the page we still need that once on the fault path)
>
> Doing a direct map access in kvm_{read,write}_guest() and friends will
> also get tricky if guest_memfd folios ever don't have direct map
> entries. On-demand restoration is painful, both complexity and
> performance wise [1], while going through a userspace mapping of
> guest_memfd would "just work".
>
> > --
> > Cheers,
> >
> > David / dhildenb
> >

