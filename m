Return-Path: <kvm+bounces-13102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3786A892372
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 19:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDB42286AFC
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 18:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCBA3B1AC;
	Fri, 29 Mar 2024 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFelVSIg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA7722075
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711737546; cv=none; b=ucJh49T0Y9FnOkJMRpJJXc+dGII4EsVhqY5FJWsocxSHyq0MgLWP5Y/Gwu6lTkra0Y95cHDPgeRylsZ6mn9fV47XX0eiieG7lBeTQde8TOY14noxXGKIxhHKHJMPY+9uvumXIGgrGJ4YALNIkUPMiQ2HpPXW95YSB/obA/QrLDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711737546; c=relaxed/simple;
	bh=5ibrp1oeF0vrPYyOhZOAc9lDini/4uj3SGxdDGuzUEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XM9Hpciul9TqYCnxFkvkDAH4uyjJEjhdmW+pyJjRv1GUGQz4dO0cvTWVx4bwbzYbUH2OkVIeR6Dq5KaU4GOXoTh6KFK+YB3GW/k9A1jdtOMGjhbGZGuspnAxMpI8F4BCFEYOBm9wWDGSxXOlbEYHUJXsV1Bao+0Z3RkPx5NzLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFelVSIg; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-69185f093f5so14523956d6.3
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 11:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711737543; x=1712342343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfjikohpzOAjLlRqO+6UBB6wPr/KvkMvVqtQCBtLFjM=;
        b=NFelVSIgCnhtm/WeduxadIDtZs/2b5hMQImNaMEw1lJ8BnIyeGttLhTUXgLRYnNUe/
         DuRldVf8yzp3aWinyz9OEE7A0IwgYBEUO+7Hs0L4hs5qNo8fK5rySuezhisIdCxXUX8J
         s4Lr8YVdoHKZETJE56lRzjXI1iQxNB7DMCHdzq72AeoSLNyXQusTmohyMqiDvbkenFWj
         zdiJv7rY9M3oCCu3f9oYMXAq4PYBMYp+IZrM6ytfY2mR7/fhtxFVsit7XyH7RUUxADu6
         CLxR38QE+FnXak9aQs/xQKko7z2O+2KDShh5lCxxSjYEE+65PChnjoMt+y13e6N0OpQu
         gZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711737543; x=1712342343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfjikohpzOAjLlRqO+6UBB6wPr/KvkMvVqtQCBtLFjM=;
        b=wkgfZzi2V2Blg3ic+fY6rzQMfqrZyMJdG50+XAqAfia/+3H34UgKbyvIpqU1CnMC2/
         7/iAj5C5RKZWxLGmesmW+FVFR3x4reqeEpBDYmXdzPOEQvzKxNkE6jSXK5Nnu2iNuQQr
         HiWnvJDkdGICTC/v5z6jCrm5NtMbgOJSFXvMHy4jSmp5X5Pdeg7RzcGDsjJoFDioN7Qf
         M21Qzmg6RZD4HjvFOnem0OZcbmzmlNmwu4ufr4MApdOZa8QfXR2Thh06Yst76zzmIBPp
         1lgGsY8xAMBnOtsFPQmy0u5bLnWTLXJnDxxCBqrq9bQ/k4J/CDQsWD8r0r4sSsow7vgf
         kmUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeQbrX3e3FxtRtLflaULzEiPKMQ99FoffybKSAGFMql6jU4V14gZ2sem6dAzHckTmdZL++4CDgCzgntKLFRHkeB6aw
X-Gm-Message-State: AOJu0YwygvGHNJFcevOQgw3ZTAqnzGDjX22LhLUv0gY+KmwEFwhC0FTr
	d9t1y6n1hmR+4c+grF/B0s4ImMNURybJ8g599BeVtohYwg0kudqcNoo/O7eVlN2LWwAltHINIyv
	yzWqf9mr1RXueuIC7Kea3rgOAx/hd2NIadN/+
X-Google-Smtp-Source: AGHT+IEGZkO07vUNWHTkATHpD6cSAfR3qyRiodjl+lF3pDCMbKLcZEvPgUlbFDmsNYBTPFujyi00g9r2gwkWpfIbMD0=
X-Received: by 2002:a0c:f547:0:b0:696:2e0c:8b82 with SMTP id
 p7-20020a0cf547000000b006962e0c8b82mr3021116qvm.15.1711737543030; Fri, 29 Mar
 2024 11:39:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com> <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck> <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck> <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>
 <ZgVCDPoQbbXjTBQp@google.com> <5cec1f98-17a5-4120-bbf4-b487c2caf92c@redhat.com>
 <ZgVNXpUS8Ku37BLp@google.com> <3448a9d6-58a8-475f-aff6-a39a62eee8c1@redhat.com>
In-Reply-To: <3448a9d6-58a8-475f-aff6-a39a62eee8c1@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 29 Mar 2024 11:38:49 -0700
Message-ID: <CAGtprH_cFxK3Wb0KVKMkVef8G=52aPiRonxee6+kqhmBqQbXYA@mail.gmail.com>
Subject: Re: folio_mmapped
To: David Hildenbrand <david@redhat.com>
Cc: Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com, 
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, keirf@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 4:41=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> ....
> >
> >> The whole reason I brought up the guest_memfd+memfd pair idea is that =
you
> >> would similarly be able to do the conversion in the kernel, BUT, you'd=
 never
> >> be able to mmap+GUP encrypted pages.
> >>
> >> Essentially you're using guest_memfd for what it was designed for: pri=
vate
> >> memory that is inaccessible.
> >
> > Ack, that sounds pretty reasonable to me. But I think we'd still want t=
o
> > make sure the other users of guest_memfd have the _desire_ to support
> > huge pages,  migration, swap (probably longer term), and related
> > features, otherwise I don't think a guest_memfd-based option will
> > really work for us :-)
>
> *Probably* some easy way to get hugetlb pages into a guest_memfd would
> be by allocating them for an memfd and then converting/moving them into
> the guest_memfd part of the "fd pair" on conversion to private :)
>
> (but the "partial shared, partial private" case is and remains the ugly
> thing that is hard and I still don't think it makes sense. Maybe it
> could be handles somehow in such a dual approach with some enlightment
> in the fds ... hard to find solutions for things that don't make any
> sense :P )
>

I would again emphasize that this usecase exists for Confidential VMs,
whether we like it or not.

1) TDX hardware allows usage of 1G pages to back guest memory.
2) Larger VM sizes benefit more with 1G page sizes, which would be a
norm with VMs exposing GPU/TPU devices.
3) Confidential VMs will need to share host resources with
non-confidential VMs using 1G pages.
4) When using normal shmem/hugetlbfs files to back guest memory, this
usecase was achievable by just manipulating guest page tables
(although at the cost of host safety which led to invention of guest
memfd). Something equivalent "might be possible" with guest memfd.

Without handling "partial shared, partial private", it is impractical
to support 1G pages for Confidential VMs (discounting any long term
efforts to tame the guest VMs to play nice).

Maybe to handle this usecase, all the host side shared memory usage of
guest memfd (userspace, IOMMU etc) should be associated with (or
tracked via) file ranges rather than offsets within huge pages (like
it's done for faulting in private memory pages when populating guest
EPTs/NPTs). Given the current guest behavior, host MMU and IOMMU may
have to be forced to map shared memory regions always via 4KB
mappings.




> I also do strongly believe that we want to see some HW-assisted
> migration support for guest_memfd pages. Swap, as you say, maybe in the
> long-term. After all, we're not interested in having MM features for
> backing memory that you could similarly find under Windows 95. Wait,
> that one did support swapping! :P
>
> But unfortunately, that's what the shiny new CoCo world currently
> offers. Well, excluding s390x secure execution, as discussed.
>
> --
> Cheers,
>
> David / dhildenb
>

