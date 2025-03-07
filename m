Return-Path: <kvm+bounces-40319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D276DA5630A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C257A3A973E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDDA1E1DED;
	Fri,  7 Mar 2025 08:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GILUOuB1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F21AC891
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741337780; cv=none; b=CBIJiltkqmQ3yFbudrV9FA1QeQwGhD4s4t+YnFHk/XhSM9kXIjQvb+65DvQEaXu179YyPCYIAznjZvjA8rsBpxie06NWwm7OMOmlM3crCwthRbJPakuCr1iRc7R1IYxyAqpugUvTzow1H7YzDKW5zN7OpmI6gAIOA/uyiTLyUfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741337780; c=relaxed/simple;
	bh=e1cmm4lk2rGmkDSn74gLD2WK+nX77RKJ17yafcd0/fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXGygrkrdBuF5EEg0906E37/1fpIHs+28ZxF+GgPnY/Oyj+n9OYNG8x1j1vMzBgyI1MNF1X76bMLanTyfzCBFWBbsJ8ekcQ5d98r8FvWYWUrAIlskt0SlaV3w5OH9SqGHsv50ST4ryVHg3vWjoVQPk6AEpnlV8H4DQoFYS4+cwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GILUOuB1; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-474fdb3212aso246191cf.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 00:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741337778; x=1741942578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GQHEoLTAFzBsO3pOwwB5OGgq8AJN92/UyqNILH3AQQ=;
        b=GILUOuB19hLahU1rTBddaWGMeB5VvD8dyt83a+xxxmoGJYhBwFmMmti9/8ysRaUyPA
         MEeT2Ta3lYoXh3W+F4NJLNeg+2wwTevk1mfmSsXIM/nZyfPG8RgUgV/I4TBkpQ75ualL
         ZyyJwgXiViVvddFCzIc6HJzjHOYoifnA4NS+sAUwZVxaEokIyeqTv1VIRtgdEBqoMML5
         2uVs4ckR1YAnWLJTri9GoVjHoHJz2La84m+jMQCX3tF6GxAHZQi1ZuGvOE/dzmyhg8p2
         UvA93ZAxRCwRZR0/8Is2vntu17eozmU3xxSgz35y51Ds42ss4SBcI+gk0nVdK4h3zg8W
         m4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741337778; x=1741942578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GQHEoLTAFzBsO3pOwwB5OGgq8AJN92/UyqNILH3AQQ=;
        b=WdrCmYYzjKopZZJRpNW4KBTyxtZMaUYVgtU8oa4vd91veWTaI9kA4cSymHbrof3gki
         uHFDJXxP/HetfaAt23O17s8z93KNdtmGfewWxJ6e3kzXYSpc06AHg+VzzM82QmkZW3hR
         bs4c8XroJMCSr/bWcDvnbF7i0y3HwsNw66RZybru/MziCRUAiLR15gmuG2hQTZ4shFaB
         t+GxnBhuzTAwr0F+1na8QW3xm4GSke1OU4Px6iac5c6mOOdJcwBpQwnDJbXV8XsDFEho
         VXB2p2MReB9Au5rpwDcUs0k5h9L8LMIoLhCxVCdUaR7ufPOa9SqVZ2WG4qTEAu8mOW87
         S8AA==
X-Gm-Message-State: AOJu0YzYydJqHbjLCvuy/T/c2LAzLCisWTAhtzHnQ7lrGLgY2TvFOWE9
	M2ahnlFo6h0bF2Fh60YaH0HO2hXRn+/HI9V3/UREmo3nuFvW1oEv8PJhLS1mdjdDPhvjOnSV9TQ
	USoToktdu55yrf1ArNioBrGpGig2H8/xGuJ82
X-Gm-Gg: ASbGncvkVa2DpQiWD3njWpzDukbdKUPMXos3FaHjCcs5nh8/8wxRvPAFe6MOci7Ko7R
	7/S6hLQyDAYTyi0scUBVCKyM2uA5ewJzlvqjzRupNS9LtkPVPeZrP7qCAUTGcx+JNoB0YeHHk1S
	+rGR703/lE0mwROFMdx/0tgQmE
X-Google-Smtp-Source: AGHT+IHw1oZaKmPCBs1ISB2portW8h1kNWaRUIgS0f9qwa4t2kBctwVH/B3jDuvDQd+jXMJiIAtCMYUSHhWqq2waroU=
X-Received: by 2002:a05:622a:1388:b0:472:8e8:fe07 with SMTP id
 d75a77b69052e-47652083b39mr1890261cf.3.1741337777664; Fri, 07 Mar 2025
 00:56:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com> <20250303171013.3548775-4-tabba@google.com>
 <CADrL8HUAkzUdZEunCXgdECD+cNZi_O+HBdQZdN=EGiX_OuQJOg@mail.gmail.com>
In-Reply-To: <CADrL8HUAkzUdZEunCXgdECD+cNZi_O+HBdQZdN=EGiX_OuQJOg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 7 Mar 2025 08:55:40 +0000
X-Gm-Features: AQ5f1JoSEOn1B-_DQf2o7NWVh2Tb849yIB-2Usp-jM7lK4TSgCDQQhyJIBItfd0
Message-ID: <CA+EHjTy9cyYd4U6ghqGjg6f3fBxzvJvNSzP5nCCc0ZK7F7jazQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 7 Mar 2025 at 01:53, James Houghton <jthoughton@google.com> wrote:
>
> On Mon, Mar 3, 2025 at 9:10=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> > +       struct folio *folio;
> > +       vm_fault_t ret =3D VM_FAULT_LOCKED;
> > +
> > +       filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +       folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);
> > +       if (IS_ERR(folio)) {
> > +               switch (PTR_ERR(folio)) {
> > +               case -EAGAIN:
> > +                       ret =3D VM_FAULT_RETRY;
> > +                       break;
> > +               case -ENOMEM:
> > +                       ret =3D VM_FAULT_OOM;
> > +                       break;
> > +               default:
> > +                       ret =3D VM_FAULT_SIGBUS;
> > +                       break;
>
> Tiny nit-pick: This smells almost like an open-coded vmf_error(). For
> the non-EAGAIN case, can we just call vmf_error()?

I wasn't aware of that. I will fix this on the respin, thanks for
pointing it out.

That said, any idea why vmf_error() doesn't convert -EAGAIN to VM_FAULT_RET=
RY?

Cheers,
/fuad

> > +               }
> > +               goto out_filemap;
> > +       }
> > +
> > +       if (folio_test_hwpoison(folio)) {
> > +               ret =3D VM_FAULT_HWPOISON;
> > +               goto out_folio;
> > +       }
> > +
> > +       /* Must be called with folio lock held, i.e., after kvm_gmem_ge=
t_folio() */
> > +       if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) =
{
> > +               ret =3D VM_FAULT_SIGBUS;
> > +               goto out_folio;
> > +       }

