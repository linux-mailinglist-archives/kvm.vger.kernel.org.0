Return-Path: <kvm+bounces-36368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96012A1A5BD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 503111885AC1
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54EC2116F7;
	Thu, 23 Jan 2025 14:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcZC7bKa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACF813212A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642355; cv=none; b=fQiXbYnQRWFLpBkPQu1sZ59ZV5IWQQIe59Qu+ZdVwsTkJBq8UdqbMraI4YG9nOVWCkJB7bw5JYpJaHsPr9IOrHHGZ4fSatZ1lAAmhehDl5CkRrlf4p6T3W44HgU8Fmr4C8CQ50lrpQOl0JJaGS0d51PFMaxahwgGRzsgbJFQKkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642355; c=relaxed/simple;
	bh=wV+4Uci9wRBlIsx8M9x1/8PIrnM5ct0TWyz93clW00Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfqTXdrTH2fd2v3zRLxeHSGLn9yQypiQB3ET7VbRZ/CFVSJvi1xk+D8Pcgx72cMAlooK/8yTn00IY3XqfS06/AqSwwsQp3KFA/NEyYmr4cXTnZHK0ZjST6BXK1jhni5BQCKbTBOJESMEMsRFddLps+8EaqEdq88XjJAQN6t688k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcZC7bKa; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-467abce2ef9so257381cf.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 06:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737642352; x=1738247152; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O0unFcqpZTejthcGsFFqk813fv8vChmX6x5uhJ6+ENs=;
        b=DcZC7bKa3HhlXJAnMa0/8WBJuj9Sa+iniU73Te8p0HlwnvBRNqXgDVzEJROmsFVH8j
         frwQJJIkDY9QDuUqi9cY/+nU0D+ipDnRIZ4oRwYp/4jBVQJTDerXAzjR5iK9niH8xKgM
         H2U087R54Jg+nPh/ddV4cIj0CGlML7yUlwHAFtpm07A4h2BqrPSa3qlA7NX/JbCYqVOB
         HokpQf2VUfFpJs8ZJitVRSJdNJlJtbBJKRCYJA+1jffqTnwrI+4gf1mo1ca73WfysQmz
         FOUQryZARRLso+PstB6V17ATV3GOqMw0WsskgBloBRMbpEG9+QX5kJQIuq8VKi2cnrfn
         5RJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737642352; x=1738247152;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O0unFcqpZTejthcGsFFqk813fv8vChmX6x5uhJ6+ENs=;
        b=B5VROWNAea/f68Ix/v+Y8Jun1JEIRo8UublbfIUqOuqiRZzvtU6M+p8YlgFbzy9n3i
         eusdlTyhpkp2iMnsEuxImsF85hppsFAUEgH5MyapC0RxBrlWG2B7iLeOarEBWUdViaye
         3JFzKZaoy5x3dKhHabErWknzEfxS6tMc0oPyicR2DxrpyW9EG7BYpL333n9ORdBj06u2
         Ud0++y4A1eX9eD8o9+1B1D2zRTh+0Ggiq0GpcS+zI6jIxzcPEXiWpQL/zc1jzTpF9b88
         1r2YgFYxCVa1myyOTcjTWJi/4O1pP7Jq8IxTsaFbDnrmxW/r5mQ90TfSLNWFsE+UNQEp
         N4aw==
X-Forwarded-Encrypted: i=1; AJvYcCVKnCl1T0N+iN82ErQlM1oqQ8mc3l+UEyZNNsv4CbPiaQ/qCcfgZS8CLwxTnOFHMM3B5v4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu0G9X0AABKruFHdevzRqrMhJfYAYx62vZlDITQ15puKs2M84O
	XlusEuCrb8RLXamSphh75+uGK4ATBf4vCRQGBnXaVLgfBsyMYwOJ//FqRCC+kyy8m43Ue3Dyeeg
	GJoTyKZ05WHQE64FECZq8W6XzE+RU+LDAbY6c
X-Gm-Gg: ASbGncsUmIz2PHGEhlAGFVWu+oZyAU8O0b5Ec87jGXhe7vzjbaU8smZx/Lox2E6LixZ
	REJfXpNOuoOwIptbXyOsQoFVsOaZDSc0L8coBkanRmrPTawzDXWr+gaWBzPs96iYCmLDR/MT1eG
	Ea7dxKm761MyAtRvA=
X-Google-Smtp-Source: AGHT+IHwLdvO8jUAYw+ZBMsSB1pMW7qvcJFpHdLhe5NCuiwdFGJhHa+vxCZyGFrNn+6wnp2cDkISLQGNfay7DpOrLaY=
X-Received: by 2002:a05:622a:18a3:b0:46e:2769:a4b with SMTP id
 d75a77b69052e-46e5c1225c1mr3484851cf.12.1737642351989; Thu, 23 Jan 2025
 06:25:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com> <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com> <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
 <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com> <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
 <CA+EHjTxc0AwX2=htwC9to7+fYbFJsfVGT5d+BtEYVPncMgq1Mw@mail.gmail.com>
 <bc59a2ec-7467-4a4e-8d73-9c4126b1c98b@amazon.co.uk> <164e9d74-2f1f-4557-afda-06712e8415b0@redhat.com>
In-Reply-To: <164e9d74-2f1f-4557-afda-06712e8415b0@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 14:25:14 +0000
X-Gm-Features: AWEUYZlU5gjG70FmBSxfrrVHIoqMlts0zx6RtYRcoY0_rdwnFzhkEd9xFPpJokE
Message-ID: <CA+EHjTyKaqDDp=5eZH3Sfoha0KSv616x4NVNr=-h28AaXy1siw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
To: David Hildenbrand <david@redhat.com>
Cc: Patrick Roy <roypat@amazon.co.uk>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
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

On Thu, 23 Jan 2025 at 14:21, David Hildenbrand <david@redhat.com> wrote:
>
> On 23.01.25 14:57, Patrick Roy wrote:
> >
> >
> > On Thu, 2025-01-23 at 12:28 +0000, Fuad Tabba wrote:
> >> Hi Patrick,
> >>
> >> On Thu, 23 Jan 2025 at 11:57, Patrick Roy <roypat@amazon.co.uk> wrote:
> >>>
> >>>
> >>>
> >>> On Thu, 2025-01-23 at 11:39 +0000, David Hildenbrand wrote:
> >>>> On 23.01.25 10:48, Fuad Tabba wrote:
> >>>>> On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
> >>>>>>
> >>>>>> On 22.01.25 16:27, Fuad Tabba wrote:
> >>>>>>> Make kvm_(read|/write)_guest_page() capable of accessing guest
> >>>>>>> memory for slots that don't have a userspace address, but only if
> >>>>>>> the memory is mappable, which also indicates that it is
> >>>>>>> accessible by the host.
> >>>>>>
> >>>>>> Interesting. So far my assumption was that, for shared memory, user
> >>>>>> space would simply mmap() guest_memdd and pass it as userspace address
> >>>>>> to the same memslot that has this guest_memfd for private memory.
> >>>>>>
> >>>>>> Wouldn't that be easier in the first shot? (IOW, not require this patch
> >>>>>> with the cost of faulting the shared page into the page table on access)
> >>>>>
> >>>>
> >>>> In light of:
> >>>>
> >>>> https://lkml.kernel.org/r/20250117190938.93793-4-imbrenda@linux.ibm.com
> >>>>
> >>>> there can, in theory, be memslots that start at address 0 and have a
> >>>> "valid" mapping. This case is done from the kernel (and on special s390x
> >>>> hardware), though, so it does not apply here at all so far.
> >>>>
> >>>> In practice, getting address 0 as a valid address is unlikely, because
> >>>> the default:
> >>>>
> >>>> $ sysctl  vm.mmap_min_addr
> >>>> vm.mmap_min_addr = 65536
> >>>>
> >>>> usually prohibits it for good reason.
> >>>>
> >>>>> This has to do more with the ABI I had for pkvm and shared memory
> >>>>> implementations, in which you don't need to specify the userspace
> >>>>> address for memory in a guestmem memslot. The issue is there is no
> >>>>> obvious address to map it to. This would be the case in kvm:arm64 for
> >>>>> tracking paravirtualized time, which the userspace doesn't necessarily
> >>>>> need to interact with, but kvm does.
> >>>>
> >>>> So I understand correctly: userspace wouldn't have to mmap it because it
> >>>> is not interested in accessing it, but there is nothing speaking against
> >>>> mmaping it, at least in the first shot.
> >>>>
> >>>> I assume it would not be a private memslot (so far, my understanding is
> >>>> that internal memslots never have a guest_memfd attached).
> >>>> kvm_gmem_create() is only called via KVM_CREATE_GUEST_MEMFD, to be set
> >>>> on user-created memslots.
> >>>>
> >>>>>
> >>>>> That said, we could always have a userspace address dedicated to
> >>>>> mapping shared locations, and use that address when the necessity
> >>>>> arises. Or we could always require that memslots have a userspace
> >>>>> address, even if not used. I don't really have a strong preference.
> >>>>
> >>>> So, the simpler version where user space would simply mmap guest_memfd
> >>>> to provide the address via userspace_addr would at least work for the
> >>>> use case of paravirtualized time?
> >>>
> >>> fwiw, I'm currently prototyping something like this for x86 (although
> >>> not by putting the gmem address into userspace_addr, but by adding a new
> >>> field to memslots, so that memory attributes continue working), based on
> >>> what we talked about at the last guest_memfd sync meeting (the whole
> >>> "how to get MMIO emulation working for non-CoCo VMs in guest_memfd"
> >>> story). So I guess if we're going down this route for x86, maybe it
> >>> makes sense to do the same on ARM, for consistency?
> >>>
> >>>> It would get rid of the immediate need for this patch and patch #4 to
> >>>> get it flying.
> >>>>
> >>>>
> >>>> One interesting question is: when would you want shared memory in
> >>>> guest_memfd and *not* provide it as part of the same memslot.
> >>>
> >>> In my testing of non-CoCo gmem VMs on ARM, I've been able to get quite
> >>> far without giving KVM a way to internally access shared parts of gmem -
> >>> it's why I was probing Fuad for this simplified series, because
> >>> KVM_SW_PROTECTED_VM + mmap (for loading guest kernel) is enough to get a
> >>> working non-CoCo VM on ARM (although I admittedly never looked at clocks
> >>> inside the guest - maybe that's one thing that breaks if KVM can't
> >>> access gmem. How to guest and host agree on the guest memory range
> >>> used to exchange paravirtual timekeeping information? Could that exchange
> >>> be intercepted in userspace, and set to shared via memory attributes (e.g.
> >>> placed outside gmem)? That's the route I'm going down the paravirtual
> >>> time on x86).
> >>
> >> For an idea of what it looks like on arm64, here's how kvmtool handles it:
> >> https://github.com/kvmtool/kvmtool/blob/master/arm/aarch64/pvtime.c
> >>
> >> Cheers,
> >> /fuad
> >
> > Thanks! In that example, kvmtool actually allocates a separate memslot for
> > the pvclock stuff, so I guess it's always possible to simply put it into
> > a non-gmem memslot, which indeed sidesteps this issue as you mention in
> > your reply to David :D
>
> Does that work on CC where all memory defaults to private first, and the
> VM explicitly has to opt into marking it shared first, or how exactly
> would the flow of operations be in the cases of the non-gmem ("good
> old") memslot?

We use a normal memslot, without the KVM_MEM_GUEST_MEMFD flag, and
consider that kind of slot to be shared by default.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

