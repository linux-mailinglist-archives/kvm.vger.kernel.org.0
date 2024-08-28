Return-Path: <kvm+bounces-25276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30160962D92
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA1772868C8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFDD1A3BC3;
	Wed, 28 Aug 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K8bAVMqc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F175B216
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862213; cv=none; b=Ej+GklMOudfglAE2GpUgRuur5iSgo2GstlesFH8MGm8HeFRxIhvqpe8IXY3eoAEFoY+DrQ69+jm3gRC+r/GiIltVQrgpA+k7b0v0/UZG21Waw4/MaEBFyrPqat6l3fnErUptFHM6JiRGqjWFeE3U4n3E3IVlcAxaIGL4nmRFQ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862213; c=relaxed/simple;
	bh=gUrokFYyBvbk0rz8DHpV3k1PXvhH4YNF0Yg3lMPwUuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PFh6yv6ndFl0vX/yfZfFp8nZmW0n0Z1yUWBGxkYpCNlmt5msdA6ghqqyTJaYNaroHN0xdhBeP/bNUn87nLaQml/66PIs7wiWElY/WfxBSJaLomr4vhwhJoszedNq10UjCEj9sput92D2gxKTnk+f+xldUN8uW7PVhDqAPPIA5XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K8bAVMqc; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c07fb195b6so14581a12.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 09:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724862209; x=1725467009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EplfYsmUAm0zdExeIe5fWGrao4IvbEYZxsxFMCs2OwU=;
        b=K8bAVMqc9Ym0Vhm7iuamvDTVwx5YQ1Kj8YPRibJTxqjfhY9H0NtagsHdmNvwhCUObC
         b4ykCLOLM3BhdA6ncJJc5xmxmjFVpLRBtC9qJtDt0IEqDTY6g6gZKHmKLRZ/Tu63logR
         7//EkA9IfqAZRMUoSLRRCtnfglvoJ7kloJwwcMZ1+2q6PYi/cz+OH2bBCWOB0RL1DqyX
         s9sy54gjB7khAUwk+G4K0tQKqI3jiiCVQ/cQs5p5FEnw/vD+MVq1PlnK+Mh91zl90jdC
         WynbRBMERxkzGFUCmwUEQURk3nac+8oZ9GQ0jVxwL3DsFwPSumvXEGt+zvBe80w/JkJa
         EHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724862209; x=1725467009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EplfYsmUAm0zdExeIe5fWGrao4IvbEYZxsxFMCs2OwU=;
        b=djEDHfgWZCNEUTSUDLHpuXLkqkmA2i2ApAr75dRRf6+wdkVJnowANYCRMIBCClUx4l
         tfezxqfzE1QK1JKjQ+Xw1a+w9NZktYBVk5l1wQu/iIOi0YgunShpDSNNsSrsN1ueTGTl
         VdkEoMIyYY2IiOcTzXwdK1Clvv8fCRYhPdKD5FsoTL0Bo0rPhZIu3kVC700wDK2+ltQ/
         g1XAYPKaPyO/Gh4vWhp6PQQmSDnHRDK5KpTGu6csqV6B0RWtXpjxN4ISjtSdC7AHELrJ
         VbOTwXXUohEncJFhDpapj/tGzimIj8W/mVZ4HDqyZyEhqMoHQFWwV3IOHvh8vPemfJSZ
         0HJw==
X-Forwarded-Encrypted: i=1; AJvYcCVg0FgV3dbYqoSuU1dicL42WPWt7GkoEwGt1Gz2VAdAMdYyjyH79NYsYGvlnFDBa1u7ZlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC8fLW1T55Rm1a5DOI2DH6RcXOe9hANVStfIOrsaK6zc2uDbcY
	tyGl2r06Aip8uX+G7ol+3Skm4gC5XuHl6kXFernn5tOGQ3/rgz8wh9Fkuay42QGq6FCp3GFh9pq
	GJcSah3j3EgXoXcAYBKH3IVO/xaTJdUte7TxkQ79njmlFRbb8jILM
X-Google-Smtp-Source: AGHT+IEFE58yJznOImn4f1wAbYp3KJ+BFLhNMAUjzfmb8JyzlrbhncOsGjJEcI25K90biqzBn1CjhqA8SLI0gojL92o=
X-Received: by 2002:a05:6402:40ca:b0:5c0:aa37:660b with SMTP id
 4fb4d7f45d1cf-5c2117308cbmr198434a12.6.1724862208798; Wed, 28 Aug 2024
 09:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <Zs83JJhFY9S-Gxqc@x1n>
In-Reply-To: <Zs83JJhFY9S-Gxqc@x1n>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 28 Aug 2024 09:23:17 -0700
Message-ID: <CACw3F53kCBGzMcOzcum3waUtYNgpcMTxaEzMjBS_-W-gsYG05A@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Hildenbrand <david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 7:41=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:
> > On Tue, Aug 27, 2024 at 3:57=E2=80=AFPM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > On Tue, Aug 27, 2024 at 03:36:07PM -0700, Jiaqi Yan wrote:
> > > > Hi Peter,
> > >
> > > Hi, Jiaqi,
> > >
> > > > I am curious if there is any work needed for unmap_mapping_range? I=
f a
> > > > driver hugely remap_pfn_range()ed at 1G granularity, can the driver
> > > > unmap at PAGE_SIZE granularity? For example, when handling a PFN is
> > >
> > > Yes it can, but it'll invoke the split_huge_pud() which default route=
s to
> > > removal of the whole pud right now (currently only covers either DAX
> > > mappings or huge pfnmaps; it won't for anonymous if it comes, for exa=
mple).
> > >
> > > In that case it'll rely on the driver providing proper fault() /
> > > huge_fault() to refault things back with smaller sizes later when acc=
essed
> > > again.
> >
> > I see, so the driver needs to drive the recovery process, and code
> > needs to be in the driver.
> >
> > But it seems to me the recovery process will be more or less the same
> > to different drivers? In that case does it make sense that
> > memory_failure do the common things for all drivers?
> >
> > Instead of removing the whole pud, can driver or memory_failure do
> > something similar to non-struct-page-version of split_huge_page? So
> > driver doesn't need to re-fault good pages back?
>
> I think we can, it's just that we don't yet have a valid use case.
>
> DAX is definitely fault-able.
>
> While for the new huge pfnmap, currently vfio is the only user, and vfio
> only requires to either zap all or map all.  In that case there's no real
> need to ask for what you described yet.  Meanwhile it's also faultable, s=
o
> if / when needed it should hopefully still do the work properly.
>
> I believe it's not usual requirement too for most of the rest drivers, as
> most of them don't even support fault() afaiu. remap_pfn_range() can star=
t
> to use huge mappings, however I'd expect they're mostly not ready for
> random tearing down of any MMIO mappings.
>
> It sounds doable to me though when there's a need of what you're
> describing, but I don't think I know well on the use case yet.
>
> >
> >
> > >
> > > > poisoned in the 1G mapping, it would be great if the mapping can be
> > > > splitted to 2M mappings + 4k mappings, so only the single poisoned =
PFN
> > > > is lost. (Pretty much like the past proposal* to use HGM** to impro=
ve
> > > > hugetlb's memory failure handling).
> > >
> > > Note that we're only talking about MMIO mappings here, in which case =
the
> > > PFN doesn't even have a struct page, so the whole poison idea shouldn=
't
> > > apply, afaiu.
> >
> > Yes, there won't be any struct page. Ankit proposed this patchset* for
> > handling poisoning. I wonder if someday the vfio-nvgrace-gpu-pci
> > driver adopts your change via new remap_pfn_range (install PMD/PUD
> > instead of PTE), and memory_failure_pfn still
> > unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT, PAGE_SIZE,
> > 0), can it somehow just work and no re-fault needed?
> >
> > * https://lore.kernel.org/lkml/20231123003513.24292-2-ankita@nvidia.com=
/#t
>
> I see now, interesting.. Thanks for the link.
>
> In that case of nvgpu usage, one way is to do as what you said; we can
> enhance the pmd/pud split for pfnmap, but maybe that's an overkill.

Yeah, just want a poke to see if splitting pmd/pud is some low-hanging frui=
t.

>
> I saw that the nvgpu will need a fault() anyway so as to detect poisoned
> PFNs, then it's also feasible that in the new nvgrace_gpu_vfio_pci_fault(=
)
> when it supports huge pfnmaps it'll need to try to detect whether the who=
le
> faulting range contains any poisoned PFNs, then provide FALLBACK if so
> (rather than VM_FAULT_HWPOISON).
>
> E.g., when 4K of 2M is poisoned, we'll erase the 2M completely.  When
> access happens, as long as the accessed 4K is not on top of the poisoned
> 4k, huge_fault() should still detect that there's 4k range poisoned, then
> it'll not inject pmd but return FALLBACK, then in the fault() it'll see
> the accessed 4k range is not poisoned, then install a pte.

Thanks for illustrating the re-fault flow again. I think this should
work well for drivers (having large MMIO size) that care about memory
errors. We can put the pmd/pud split idea to backlog and see if it is
needed in future.

>
> Thanks,
>
> --
> Peter Xu
>

