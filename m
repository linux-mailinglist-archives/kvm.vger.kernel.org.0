Return-Path: <kvm+bounces-48611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19247ACF98C
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E83A3AF77F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076E227FB3C;
	Thu,  5 Jun 2025 22:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gOBqwyDy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063527FB3A
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161533; cv=none; b=dt/5PkLqd/lntDghvL81UYSnAyj3BRGnsVTQPQc6KHQqRHuwSogp/hhsne6+uI4vjW9OyB3ZVU1zKLmU+HvcJx5k1m6Oc30Xh52bFBjT61KF0E6Xnk/AQUTl+zM2mqDnvxGU1EJfH6qvvXeXekBt83n3wb/Jt9ElQq3Wy+RYqTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161533; c=relaxed/simple;
	bh=PANd58hPjbNPTHa4l705McN2EG5oD6B2hiBJ/vJO2es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tae9317L6GiJdCvyrnvhGfgI80EKRNewvgM59jP284BRE+9VWDudG7brTjJF+hH+eOdDVFEE4xinWdypeW5FCssYpVe9l9dngiUk52tg3M8Ug/hcY0b+tdNBjx6wDHb3bDTsNBlhCDCuoKhxgD+QnvE5uY1otIhFJ/gERvk4AHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gOBqwyDy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73e0094706bso1986371b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749161531; x=1749766331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+jOw1rIAPgLJUVWv/cCmbdBlNLRTe06PSJ8KQ26TsDA=;
        b=gOBqwyDy0XMh19JHWtrKpvKfEgU1Vr5JyfvTe68stSFhYqyuCtJWY0qPTj0zX04PGx
         z6n8XkdWmiGFstKJRN4eCi/tE/SYEHAEZ7s4r+/gpWpS9Y2fu0Csrb0cgrfgUbGoYCxP
         HKMuOkCSc77xHagBoOC4bUw8+pK5ocgV0q0n5xoBUYsoijMsaK9VdgBzAz8+lO83hGOr
         kwzO1axjH/irxSJFYk3OGFWwj+tJWKwOdSuIKZoYWUo8lhsltiURPAEyvAXP/MZF5dtu
         UslHPE1W8HufRLuy62czJyQIgOPadmxL4QJQCQaerOkNjlT4Z3E9+ITeSgaAOZf9B6Bl
         ijnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749161531; x=1749766331;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+jOw1rIAPgLJUVWv/cCmbdBlNLRTe06PSJ8KQ26TsDA=;
        b=UmiBRTtXg94w4E0ms3OqLNLuBSkUjNnfP5kzdojPIyVvNXeErAJ8JFCobMlswfr9t3
         BIhUxSx8wiSITTmjjAIp1yFAk7QawRopC+hbyfNbsoHCRMtHsIgK+L7pEE6WyLgfqJV1
         /WVKlMks1hOrtzjndyAwR8iY7hzj1PXrQhaHNGb4KxcSQtW9WMo/eG0k6KACoKvJFku0
         GdN8bOtuvzBX3XxJ7bQKsVcvx84qJEQeY0heqoHPP122I8j1F2Tbrp19OKK06p2YOGt9
         gsWOhEPHUhqHeMdZ6xM8TkHashkcxnhBBhZB9Nd0X+Bix2IwRMXLzHepMM5xMViM7bCc
         hUEA==
X-Forwarded-Encrypted: i=1; AJvYcCX8+BDtMKxByurchIYY+LSxqPSdtUzV6i+jk2d0m8a0/l6Q1HtyOcYdeE8uCOGFr9/8Cd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYlgfaRam7SM/1rqk7RveMczcNYxENnuhUjY+k9Y10zMNTzVY9
	7+Db9AcgQlb4F3XXo9DN+gBXNjHUvrNFmRvWGkI3TBBMJFN0b81dCkgnrytOiZaobYxJHN6qx8I
	GoIdk9g==
X-Google-Smtp-Source: AGHT+IG6LzfASe3puScn/Qv3ruREwfR064s8V+HL6PEjTR9Oas02f/m6vRYzgkbGrD2ayUhiXQ3k4vsZIjY=
X-Received: from pfbli4.prod.google.com ([2002:a05:6a00:7184:b0:746:301b:10ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431f:b0:21a:da01:e0cf
 with SMTP id adf61e73a8af0-21ee261054cmr1284527637.22.1749161530718; Thu, 05
 Jun 2025 15:12:10 -0700 (PDT)
Date: Thu, 5 Jun 2025 15:12:09 -0700
In-Reply-To: <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
Message-ID: <aEIWOSyFADsfXZnZ@google.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2025, James Houghton wrote:
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> >                     "pwrite on a guest_mem fd should fail");
> >  }
> >
> > -static void test_mmap(int fd, size_t page_size)
> > +static void test_mmap_supported(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       const char val =3D 0xaa;
> > +       char *mem;
>=20
> This must be `volatile char *` to ensure that the compiler doesn't
> elide the accesses you have written.
>=20
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIV=
ATE, fd, 0);
> > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed b=
y guest_memfd.");
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       memset(mem, val, total_size);
>=20
> Now unfortunately, `memset` and `munmap` will complain about the
> volatile qualification. So...
>=20
> memset((char *)mem, val, total_size);
>=20
> Eh... wish they just wouldn't complain, but this is a small price to
> pay for correctness. :)
>=20
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
>=20
> The compiler is allowed to[1] elide the read of `mem[i]` and just
> assume that it is `val`.

I don't think "volatile" is needed.  Won't READ_ONCE(mem[i]) do the trick? =
 That
in turn will force the compiler to emit the stores as well.

> [1]: https://godbolt.org/z/Wora54bP6
>=20
> Feel free to add `volatile` to that snippet to see how the code changes.

