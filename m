Return-Path: <kvm+bounces-59470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C66BBB81B5
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 22:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9522B4EF02E
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 20:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E532023D281;
	Fri,  3 Oct 2025 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PtvW/RSp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AC8225788
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 20:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759523418; cv=none; b=bht8Bd1GK326a5CCYElqbwMhmCnp+cK1igQnRr4fcAK9i0MDYzL/dvS1MZQ1hwHsnkV28f8shtE4fERf6VDlJBQoqQ1s02T1KjeFw2wQtsi/19/mVgYup0BMsIu4G2PJBhVaRbhLO65wJFbdzh3t0U9G+YM946ix2jp42qi/MaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759523418; c=relaxed/simple;
	bh=8c912eY1UEEgVwBhK9alWqGDDsyKRZobEz+Fu9lJIhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJL6pCH1Awrvo+6nyeKhDdr6Y0s5qeFP++W/1HEneGPgPJIxXETSDxSuLThRxRWn9DG5+gOQDOuJqoryFtjqm1sFuceulpVoMi4Y9G1BiLC5D4Y1wTkZ8VoxityDxpoqRLLmK5WlznpAZZkapxJjCtiWaoWoA+gIf2sl48pkgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PtvW/RSp; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27eeafd4882so51895ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 13:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759523416; x=1760128216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/0L3YZsGlZPOGFIT/xNUCPnxRniP3fT1sUMkDCiDzQ=;
        b=PtvW/RSp7Ja8otztNd4E91+3BmxwGZFf+KCSje90C0EunVUJrX5DNG1SQSOTbKU1S8
         e79CZHTVE0FZEPeIQyFN7RzRG2pjw59AwnWycjYZuDILFaBx2QqRDuRATPOw/7+IChss
         G96B+bAg0UErBg2KSdm+WH5DL27er3Sdo5FnlJRvV8g/bn1IfWBLAYKFv8IS4gEqEaWI
         5F2aJxigzClJXKRPh0RscOpIpn7zOh/cWk5Sj2iOr2lo9DRHExFhG7f/VNeiyRuaimt/
         oKnfjpdPzZOhZqaE7pq8cV9XZHeQKSllKOCsbCFEYQbrxgbx2CucVXzSGLFUzNshvhI1
         Rd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759523416; x=1760128216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/0L3YZsGlZPOGFIT/xNUCPnxRniP3fT1sUMkDCiDzQ=;
        b=J3SUyPxjH6qPPj1vHK15o3yGZNY1Th68pe4mpasQyxF6ZFskcSnwNx+hp9fH8+gefN
         HoW8vOnfRkXJOjNDcxAxPMFajoUrIV7Eus5UmDu9bldAEry0C0Z9+WxLZP+jCWk0iRdK
         kZJ2R/4qgmNTeie2e1suW3nDYFQmxvt5+zPkYhczDCRQPF+bMplM1qYyCy2N15hX2aT1
         dKbDxgwxdYvHRHvyqEj+WSVnTE6o4q2FNf5keW3WVSOBIJBruqFpDAnpfjdMT+b2nkKO
         wqU4G1R60UESaFxsoI9jhvkZ5/WeTf9D/dp6JTz9a6GGvuQROvarMjcEoyP5OLLhKodc
         BiQw==
X-Forwarded-Encrypted: i=1; AJvYcCUXikxUsX1KOAJnd91NY7hT3j7zGclxwhLdU2pG43FG0YXp8MPWvNt3spx2MO5Tg9Dqqi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIzCWKpVchUYRI1/aw0Sb5g3CZqepTo4K9tW3DNOZZTFpnBM/A
	hH57Pb3ruGSlwz1OB18Geq+YGjnk/xkRkJOWEBPOrVJpN2ATJWVB0yPxxeEWM5RT3YtTetGR+B+
	D/9HkR0OnwvTaWhuU6/wnG/3VOklUXsQrDimFZg3F
X-Gm-Gg: ASbGncuuQVC/F0I+sELNax0cFn4C+Cw5ztzNMYEG/+yHGNJzlmM3lrn/86gUkZE6QQP
	TqAIY/lIoktkFXz8cebY5hqEz1zS3OO/wEQVmmxacCXy4la+HDw5oT8+B4VtxzLgeBB9WL8BuxE
	meaIcKAn4Ei5jlOlsP3Z+aqTcyAizdvn2HBY00kRyNo2qVjyWUZ4hysXqVh+972xuBSv+tVky14
	qAHkPpJTvmlrIowBo2niocICOGaL6pEom++xjuL5EKP9fZTMM2t58Z8lBBbbv3XDxQO
X-Google-Smtp-Source: AGHT+IHyUpiBlEGtx1ZWxN1upFN31zq9jqARbqfv4Hz2Xb4ggiQ+FOCdH3M199iB+zFMTMni4io379S7xpZOgTQnrMU=
X-Received: by 2002:a17:903:2383:b0:240:6076:20cd with SMTP id
 d9443c01a7336-28ea80c8c6bmr924255ad.15.1759523415313; Fri, 03 Oct 2025
 13:30:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aNshILzpjAS-bUL5@google.com> <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com> <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
 <aN3BhKZkCC4-iphM@google.com> <CAGtprH_evo=nyk1B6ZRdKJXX2s7g1W8dhwJhEPJkG=o2ORU48g@mail.gmail.com>
 <aN8U2c8KMXTy6h9Q@google.com> <CAGtprH9N=974HZiqfdaO9DK9nycDD9NeiPeHC49P-DkgTaWtTw@mail.gmail.com>
 <aN_2JaorgERIkpW4@google.com>
In-Reply-To: <aN_2JaorgERIkpW4@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 3 Oct 2025 13:30:02 -0700
X-Gm-Features: AS18NWCcLkRWY4ao1VCj7qy0k_ytrZZdsE8Fa7TimWaUhu8L01CyT8ya4dms5AE
Message-ID: <CAGtprH-CUMpGqN_68Q_+voJzMpsWnfKKBPmgBGgMgoeTt0E-aw@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, Shivank Garg <shivankg@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 9:13=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Oct 02, 2025, Vishal Annapurve wrote:
> > On Thu, Oct 2, 2025, 5:12=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > >
> > > > >
> > > > > If the _only_ user-visible asset that is added is a KVM_CREATE_GU=
EST_MEMFD flag,
> > > > > a CAP is gross overkill.  Even if there are other assets that acc=
ompany the new
> > > > > flag, there's no reason we couldn't say "this feature exist if XY=
Z flag is
> > > > > supported".
> > > > >
> > > > > E.g. it's functionally no different than KVM_CAP_VM_TYPES reporti=
ng support for
> > > > > KVM_X86_TDX_VM also effectively reporting support for a _huge_ nu=
mber of things
> > > > > far beyond being able to create a VM of type KVM_X86_TDX_VM.
> > > > >
> > > >
> > > > What's your opinion about having KVM_CAP_GUEST_MEMFD_MMAP part of
> > > > KVM_CAP_GUEST_MEMFD_CAPS i.e. having a KVM cap covering all feature=
s
> > > > of guest_memfd?
> > >
> > > I'd much prefer to have both.  Describing flags for an ioctl via a bi=
tmask that
> > > doesn't *exactly* match the flags is asking for problems.  At best, i=
t will be
> > > confusing.  E.g. we'll probably end up with code like this:
> > >
> > >         gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
> > >
> > >         if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
> > >                 gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
> > >         if (gmem_caps & KVM_CAP_GUEST_MEMFD_INIT_SHARED)
> > >                 gmem_flags |=3D KVM_CAP_GUEST_MEMFD_INIT_SHARED;
> > >
> >
> > No, I actually meant the userspace can just rely on the cap to assume
> > right flags to be available (not necessarily the same flags as cap
> > bits).
> >
> > i.e. Userspace will do something like:
> > gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
> >
> > if (gmem_caps & KVM_CAP_GUEST_MEMFD_MMAP)
> >         gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
> > if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB)
> >         gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB | GUEST_MEMFD_FLAG_HUG=
ETLB_2MB;
>
> Yes, that's exactly what I said.  But I goofed when copy+pasted and faile=
d to
> do s/KVM_CAP_GUEST_MEMFD_INIT_SHARED/GUEST_MEMFD_FLAG_INIT_SHARED, which =
is the
> type of bug that ideally just can't happen.
>
> Side topic, I'm not at all convinced that this is what we want for KVM's =
uAPI:
>
>         if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB)
>                 gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB | GUEST_MEMFD_FL=
AG_HUGETLB_2MB;
>
> See https://lore.kernel.org/all/aN_fJEZXo6wkcHOh@google.com.

Ack, that makes sense to me.

>
> > Userspace has to anyways assume flag values, userspace just needs to
> > know if a particular feature is available.
>
> I don't understand what you mean by "assume flag values".

Ok, I think you covered the explanation of why you would prefer to
have KVM_CAP_GUEST_MEMFD_FLAGS around and I misinterpreted some of it.

One more example with KVM_CAP_GUEST_MEMFD_FLAGS around:

gmem_caps =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_CAPS);
valid_flags =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS);

if (gmem_caps & KVM_CAP_GUEST_MEMFD_CONVERSION) {
               // Use single memory backing paths for 4K backing
              if (valid_flags & GUEST_MEMFD_FLAG_MMAP)
                          gmem_flags |=3D GUEST_MEMFD_FLAG_MMAP;
              else
                        // error out;
}
if (gmem_caps & KVM_CAP_GUEST_MEMFD_HUGETLB_CONVERSION) {
               // Use single memory backing paths for hugetlb memory backin=
g
               if (valid_flags & GUEST_MEMFD_FLAG_HUGETLB) {
                          gmem_flags |=3D GUEST_MEMFD_FLAG_HUGETLB;
                          kvm_create_guest_memfd.huge_page_size_log2 =3D ..=
.;
               } else
                        // error out;
}

Userspace will have to rely on a combination of flags and caps to
decide it's control flow instead of just caps. Thinking more about
this, I don't have a strong preference between two scenarios i.e. with
or without KVM_CAP_GUEST_MEMFD_FLAGS.

