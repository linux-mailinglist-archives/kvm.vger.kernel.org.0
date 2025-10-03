Return-Path: <kvm+bounces-59467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D3CE4BB7805
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 18:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF5DF4E7C17
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 16:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B91F2BDC33;
	Fri,  3 Oct 2025 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSVl+qmC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FA14A8B
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759508009; cv=none; b=CnOfhfBM6rDEeivqQW24saivKrC+EfnqEJ6KD8iHNS2oibgyhJYOujaEY58FmsITu2vgKbX709PPlx0DPdyvtxsihV9hFRfEDtWbGDMA32tghEeRbEv+awQuPWWzsbXl2l1UJMJbngCYZti2EEQE69Za9qUHJfYqqeQ7Q+1jJzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759508009; c=relaxed/simple;
	bh=YST8ZF3CcYfjTEJjqYRKNJnCudGeZXmyFr2oVhiwg2c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RDZg1oiASlApon5WwM/M+c9xu+skDlPVa4vAhKVk0bEEWb+kfBsV5cW/wl7zrHAkDl71NNzTokTxSBJI++DjwKnQ2cZwx+yu9z3OTrmcn5u/0IZvjoonsZN26MReZ8Ff+RN0ra5LRkal0vQbPnCdasZzt+XW/QGY2a2I6us0Ytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eSVl+qmC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-78105c10afdso2364075b3a.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 09:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759508007; x=1760112807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmfo6BfSj1vijjHYWbexLj1tiKT+0K4lqvnwt2mSWyo=;
        b=eSVl+qmCuoJOZllp0tfhLGnX8cM47fY35j8urvgCGfPROS3mpPVzCO8FzAvv4Tkpvl
         umi9kjk8RJT6qyZZyiWSQqzntUwBaNukU74V+Ft6qdlN6M69Fb5UzJQslowojasgExgl
         yJCu9x3v6h6BYOTV1KQo5YpHmlOQCpmU3BNqwp2qptuLnyS+1I6DDOsDPctTBI9ajNZ9
         ajdeiXauDREizMn2e0m6XGKu1mz2tq5Ym7MHykcXpwfuvqX0b/c5wBIs8FKUkHF74sgD
         sGxr7nnky5t9lb078mFj+ME3u6kvX3LoIZBPtZantwMJDfM4JXUD81XncIl5hNgph1b1
         UgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759508007; x=1760112807;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tmfo6BfSj1vijjHYWbexLj1tiKT+0K4lqvnwt2mSWyo=;
        b=deMm9Wl3XF66ghi6sCGafiP33ujeRIdei7QRiEWdcJD/TcPBG6T+1I69Jh6McCR9DH
         /Xn4cu4YVCLDrLmstXmzNf9s/pIzEZDZ22IBdPVMgA2wJtaPOTnum1cBGh6qhSaW0wrl
         RrauRe22OpC+MuQtU//MkD2Km6lnAORcWvIq5KRfTTn1j2FLHq/s14TkuKX8Iy4P1mRq
         O2wfkRfk+7kaVax7g/UOt6DlRBEvSqZdwkhCmTlPshgPNPqRUCHRbe69UmImL3rSfPKH
         CHlnNSpj9YIg29bqzgw5dTE/7QLnXqbr/ZknccwetJxyzv+LBI6YDC3GDrIjjHygDy6K
         THrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu/G+oljyFuuIjH2/ukYFSHD1Ufmi3jA0vBo+bcd0u7lt4+84yg5FUrhF4uF3DAw1Pof0=@vger.kernel.org
X-Gm-Message-State: AOJu0YymaYipnd0DfVve+/u6cjVFVp1j1oiENQU+emSzC4XD5ekBvsar
	wPqymmrr05VN+eKvkG9KPfF+qXVMAAzHkVcjlOYcBztpkynDliLPFLe+ZpS4Sf6fNVr8Fm4tybd
	2JTBrdQ==
X-Google-Smtp-Source: AGHT+IGckT+FYIKyF0u496NCKfZhFFbReLIlmMVt60Vecws/DHOYXpXuGQnDznnvpoOwwtW65OfuIzp1Y8U=
X-Received: from pgbcv13.prod.google.com ([2002:a05:6a02:420d:b0:b62:de94:990d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a10:b0:2cd:a43f:78fb
 with SMTP id adf61e73a8af0-32b620db8b0mr4716222637.48.1759508007117; Fri, 03
 Oct 2025 09:13:27 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:13:25 -0700
In-Reply-To: <CAGtprH9N=974HZiqfdaO9DK9nycDD9NeiPeHC49P-DkgTaWtTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aNshILzpjAS-bUL5@google.com> <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com> <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
 <aN3BhKZkCC4-iphM@google.com> <CAGtprH_evo=nyk1B6ZRdKJXX2s7g1W8dhwJhEPJkG=o2ORU48g@mail.gmail.com>
 <aN8U2c8KMXTy6h9Q@google.com> <CAGtprH9N=974HZiqfdaO9DK9nycDD9NeiPeHC49P-DkgTaWtTw@mail.gmail.com>
Message-ID: <aN_2JaorgERIkpW4@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, Shivank Garg <shivankg@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2025, Vishal Annapurve wrote:
> On Thu, Oct 2, 2025, 5:12=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> >
> > > >
> > > > If the _only_ user-visible asset that is added is a KVM_CREATE_GUES=
T_MEMFD flag,
> > > > a CAP is gross overkill.  Even if there are other assets that accom=
pany the new
> > > > flag, there's no reason we couldn't say "this feature exist if XYZ =
flag is
> > > > supported".
> > > >
> > > > E.g. it's functionally no different than KVM_CAP_VM_TYPES reporting=
 support for
> > > > KVM_X86_TDX_VM also effectively reporting support for a _huge_ numb=
er of things
> > > > far beyond being able to create a VM of type KVM_X86_TDX_VM.
> > > >
> > >
> > > What's your opinion about having KVM_CAP_GUEST_MEMFD_MMAP part of
> > > KVM_CAP_GUEST_MEMFD_CAPS i.e. having a KVM cap covering all features
> > > of guest_memfd?
> >
> > I'd much prefer to have both.  Describing flags for an ioctl via a bitm=
ask that
> > doesn't *exactly* match the flags is asking for problems.  At best, it =
will be
> > confusing.  E.g. we'll probably end up with code like this:
> >
> >         gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
> >
> >         if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
> >                 gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
> >         if (gmem_caps & KVM_CAP_GUEST_MEMFD_INIT_SHARED)
> >                 gmem_flags |=3D KVM_CAP_GUEST_MEMFD_INIT_SHARED;
> >
>=20
> No, I actually meant the userspace can just rely on the cap to assume
> right flags to be available (not necessarily the same flags as cap
> bits).
>=20
> i.e. Userspace will do something like:
> gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
>=20
> if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
>         gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
> if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB)
>         gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB | GUEST_MEMFD_FLAG_HUGET=
LB_2MB;

Yes, that's exactly what I said.  But I goofed when copy+pasted and failed =
to
do s/KVM_CAP_GUEST_MEMFD_INIT_SHARED/GUEST_MEMFD_FLAG_INIT_SHARED, which is=
 the
type of bug that ideally just can't happen.

Side topic, I'm not at all convinced that this is what we want for KVM's uA=
PI:

	if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB)                              =
   =20
		gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB | GUEST_MEMFD_FLAG_HUGETLB_2MB;

See https://lore.kernel.org/all/aN_fJEZXo6wkcHOh@google.com.

> Userspace has to anyways assume flag values, userspace just needs to
> know if a particular feature is available.

I don't understand what you mean by "assume flag values".

