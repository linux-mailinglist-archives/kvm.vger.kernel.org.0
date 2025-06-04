Return-Path: <kvm+bounces-48447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6857ACE56B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 22:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 725DE3A8B83
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839FD212B28;
	Wed,  4 Jun 2025 20:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K9kWW8zC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFF7081F
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 20:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067378; cv=none; b=n2Upuck22ygdGLVqmKS1zADv+aJg+BTXbREzB+Cff1QSIeaMboyWL0X42UaM1I6vrXbqnrT5tUDOobZVbZDcnrEGKk6s0gKPZc0fJqxWKEHhHkVrGi6MAOvVdp0oGXLTgF2x/6dTEiJJ+FHkiBY2hM1JOS5PV03E6xP8Kg3m6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067378; c=relaxed/simple;
	bh=/oXjNoKaFi18wBBbxc9lgVKRoAl/TFTCl19ADf/MD9Y=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SXf1J0ToHrzXm0y+ocO7Rv+DiSk4qub69tjyfzpFD+HscvTtG9SHNdIVAdp75aYt4KluJzSQFY6BVTJecBKgeChV2GguNIdZSdKExiuzkOToALuHof8zNWDTVLcYKfUSb8Smq6kH6gbFCQYCuf4FoVDEUJ+Lweg8Bm2qo2KzuMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K9kWW8zC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26cdc70befso108794a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 13:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749067375; x=1749672175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rAeDnAu1iVfkSNw+hN1Znk4oNapfaoWsxLiV+G+rVq0=;
        b=K9kWW8zCeCT7temqWrVBOXV/ysZCklnHS2/pxFum+Kr501szPjvwbinJ4DiVbR99Sr
         Z6D/DXMz29Q1k73RTZsK9oYyI/NvoJXm63OATf6NY/Jym/f/LhoN/9JclfucZpTTEyIr
         QrCB5/5DEHlRM8C+oQIy4czumlw0qVN3V0yLbQja91u/DFV6yklsbeFwXfIEGWH9aVBP
         3kK1dUB7rHESQf/5WIxR6w3OswRsGiNAip/ktKxAMvIYVr+dMeUjdBUL2GGnWEbmwAxl
         PDw1QnCOxba0Li0HvgRzojDx2KcH7JA2Sj0TaYSuQMZzcgOk7ePMR2QRaCKwy63xMePm
         n65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749067375; x=1749672175;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rAeDnAu1iVfkSNw+hN1Znk4oNapfaoWsxLiV+G+rVq0=;
        b=N4Or45bWtKKJTZ7AYR+GFlVMqBDaMkgXMX/POO4OSJAGiBWoutbRKEYcSWKYN87VRx
         FqrOFQ7JaDxLrn8ddkJgKHh1A/MrBqUQEDkVvm/GvSFZO4AFlST/hNPqDCw15PTU7r16
         4iYgIsrEQtxL8A4IcZNqlfdECcCWBz7ZOALUAJaI5rrJJvvLp5YHYubewIZi7ewgVA/r
         iZl2jBeR2Zkk7Mq+DQ4j5s6/Q67zt/39TyF8JeHl2xyd6uwC5bNSJVur7/Qfr+8F577o
         6kxvxPFBaPHgP6RGJYeCjK41fHCiN+roBZkrqiU3tUx9tOezD4NgW5MBrF3ELPEwTr/o
         fT3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtvBRC2d30OGX2r8BnXhStM4T1EVFu1W5JNf7qiBvEek+HDCIQHqJ/yXPlAbEmywUjlCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYGQxP5X1qKdcBR5HIYLIL0CEjBLXTf88Jdbq072Pd1zDcx5Y3
	ClDsFMJRAtFaFonqVtdYdVwjvaVY9U+jluiLj7A9nrhxSzVdJyhX8K2kARk9LC22b3/JdVExvzk
	Ms4U8PRixFG3kG1HlKVoxfjn/pA==
X-Google-Smtp-Source: AGHT+IHvSBac0jCGR1FiacSK6OdMWzNXgSQTh3CUYf5rb2MhrPDIBfnu+6/ydort/RxPDaciSeVY0tnlh77F1rVwpQ==
X-Received: from pfwp6.prod.google.com ([2002:a05:6a00:26c6:b0:747:b608:3d8e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9985:b0:215:eac9:1ab2 with SMTP id adf61e73a8af0-21d22d0ed2cmr6424202637.28.1749067375374;
 Wed, 04 Jun 2025 13:02:55 -0700 (PDT)
Date: Wed, 04 Jun 2025 13:02:54 -0700
In-Reply-To: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> (message from Yan
 Zhao on Thu, 15 May 2025 11:01:54 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: vannapurve@google.com, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, May 12, 2025 at 09:53:43AM -0700, Vishal Annapurve wrote:
>> On Sun, May 11, 2025 at 7:18=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
>> > ...
>> > >
>> > > I might be wrongly throwing out some terminologies here then.
>> > > VM_PFNMAP flag can be set for memory backed by folios/page structs.
>> > > udmabuf seems to be working with pinned "folios" in the backend.
>> > >
>> > > The goal is to get to a stage where guest_memfd is backed by pfn
>> > > ranges unmanaged by kernel that guest_memfd owns and distributes to
>> > > userspace, KVM, IOMMU subject to shareability attributes. if the
>> > OK. So from point of the reset part of kernel, those pfns are not rega=
rded as
>> > memory.
>> >
>> > > shareability changes, the users will get notified and will have to
>> > > invalidate their mappings. guest_memfd will allow mmaping such range=
s
>> > > with VM_PFNMAP flag set by default in the VMAs to indicate the need =
of
>> > > special handling/lack of page structs.
>> > My concern is a failable invalidation notifer may not be ideal.
>> > Instead of relying on ref counts (or other mechanisms) to determine wh=
ether to
>> > start shareabilitiy changes, with a failable invalidation notifier, so=
me users
>> > may fail the invalidation and the shareability change, even after othe=
r users
>> > have successfully unmapped a range.
>>
>> Even if one user fails to invalidate its mappings, I don't see a
>> reason to go ahead with shareability change. Shareability should not
>> change unless all existing users let go of their soon-to-be-invalid
>> view of memory.

Hi Yan,

While working on the 1G (aka HugeTLB) page support for guest_memfd
series [1], we took into account conversion failures too. The steps are
in kvm_gmem_convert_range(). (It might be easier to pull the entire
series from GitHub [2] because the steps for conversion changed in two
separate patches.)

We do need to handle errors across ranges to be converted, possibly from
different memslots. The goal is to either have the entire conversion
happen (including page split/merge) or nothing at all when the ioctl
returns.

We try to undo the restructuring (whether split or merge) and undo any
shareability changes on error (barring ENOMEM, in which case we leave a
WARNing).

The part we don't restore is the presence of the pages in the host or
guest page tables. For that, our idea is that if unmapped, the next
access will just map it in, so there's no issue there.

> My thinking is that:
>
> 1. guest_memfd starts shared-to-private conversion
> 2. guest_memfd sends invalidation notifications
>    2.1 invalidate notification --> A --> Unmap and return success
>    2.2 invalidate notification --> B --> Unmap and return success
>    2.3 invalidate notification --> C --> return failure
> 3. guest_memfd finds 2.3 fails, fails shared-to-private conversion and ke=
eps
>    shareability as shared
>
> Though the GFN remains shared after 3, it's unmapped in user A and B in 2=
.1 and
> 2.2. Even if additional notifications could be sent to A and B to ask for
> mapping the GFN back, the map operation might fail. Consequently, A and B=
 might
> not be able to restore the mapped status of the GFN.

For conversion we don't attempt to restore mappings anywhere (whether in
guest or host page tables). What do you think of not restoring the
mappings?

> For IOMMU mappings, this
> could result in DMAR failure following a failed attempt to do shared-to-p=
rivate
> conversion.

I believe the current conversion setup guards against this because after
unmapping from the host, we check for any unexpected refcounts.

(This unmapping is not the unmapping we're concerned about, since this is
shared memory, and unmapping doesn't go through TDX.)

Coming back to the refcounts, if the IOMMU had mappings, these refcounts
are "unexpected". The conversion ioctl will return to userspace with an
error.

IO can continue to happen, since the memory is still mapped in the
IOMMU. The memory state is still shared. No issue there.

In RFCv2 [1], we expect userspace to see the error, then try and remove
the memory from the IOMMU, and then try conversion again.

The part in concern here is unmapping failures of private pages, for
private-to-shared conversions, since that part goes through TDX and
might fail.

One other thing about taking refcounts is that in RFCv2,
private-to-shared conversions assume that there are no refcounts on the
private pages at all. (See filemap_remove_folio_for_restructuring() in
[3])

Haven't had a chance to think about all the edge cases, but for now I
think on unmapping failure, in addition to taking a refcount, we should
return an error at least up to guest_memfd, so that guest_memfd could
perhaps keep the refcount on that page, but drop the page from the
filemap. Another option could be to track messed up addresses and always
check that on conversion or something - not sure yet.

Either way, guest_memfd must know. If guest_memfd is not informed, on a
next conversion request, the conversion will just spin in
filemap_remove_folio_for_restructuring().

What do you think of this part about informing guest_memfd of the
failure to unmap?

>
> I noticed Ackerley has posted the series. Will check there later.
>

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com=
/T/
[2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-=
rfc-v2
[3] https://lore.kernel.org/all/7753dc66229663fecea2498cf442a768cb7191ba.17=
47264138.git.ackerleytng@google.com/

>> >
>> > Auditing whether multiple users of shared memory correctly perform unm=
apping is
>> > harder than auditing reference counts.
>> >
>> > > private memory backed by page structs and use a special "filemap" to
>> > > map file offsets to these private memory ranges. This step will also
>> > > need similar contract with users -
>> > >    1) memory is pinned by guest_memfd
>> > >    2) users will get invalidation notifiers on shareability changes
>> > >
>> > > I am sure there is a lot of work here and many quirks to be addresse=
d,
>> > > let's discuss this more with better context around. A few related RF=
C
>> > > series are planned to be posted in the near future.
>> > Ok. Thanks for your time and discussions :)
>> > ...

