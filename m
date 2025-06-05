Return-Path: <kvm+bounces-48612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FD9ACF9A2
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79838189CDC4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3394E280002;
	Thu,  5 Jun 2025 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dtG+mKOu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9470B27FD53
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161886; cv=none; b=KLFmMdsuxErlHf7d89zTBeQk7TGzov3TaozNX81NziPeCgSsXJ9lLtQ0kJOlTyWGldytV91skM4xml0KXbWu8LDb2jcjRfDwn73QnIMf+AQdlwxxFgMFwH0MYR96JRWcAPSUGGdalaXAgBn4Y7q3h9cgZ/zdBF4pYGRnTeF1jh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161886; c=relaxed/simple;
	bh=yMhu9sPuYCqwJcCgHx9xGE7CfhUndVPmqZ3Gefo96po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ciHVt1zG7MCVJSr7H7wXpOkgTAGvCDcoBQwKFSncPNndCvQ9TNSwKLzG/DpwvHJTUyiw5+EFChYpVWzPRO4UCHl/8KoH+WqFA8rc/DYjUyQ3upn7BsxAUSz3GFAztbn3s1sekeNhRdqPXPm+Fvr01Yc31fmElHodxR+OJX5ZfOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dtG+mKOu; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e7db6aaef22so1252495276.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749161882; x=1749766682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQ/uGyCTZOS6KpI/fI0NUJbZvrpPuXcuakWk65q+Vo0=;
        b=dtG+mKOufhO9JWZH6zJo/unpbvieNvL4HnOLAIrT2vlapLDazEh+vvf/6RGSAAc5Hg
         8gwV73gxayeDzWSvDM67znuJpZkwmOleDllPxhWIH8CZkMc2Mri494IucEe3njq5CvaP
         ovPMAghon45caU6Fywi2SKqPynZ57jVHgk3CRsJvf2gnNtkf/Uo+r0DNOw+jOsPGudai
         SIIlTkMG3DY306d5NxCWvWzA2xQT0qIxygJmpEDATFC0wMbFGb3qq9a8vJ/aF6HZiLQ/
         gA2XWUU93jlgkhI+zpGXGQfS/oCT8JL5OcGg4IrslL36iFnmErEUw1X3QtYT0Qh4rlqO
         F7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749161882; x=1749766682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ/uGyCTZOS6KpI/fI0NUJbZvrpPuXcuakWk65q+Vo0=;
        b=T2GgEpwhmB3oBY9knVU4dCv+JRf6PukymtM/r3VK1q4N9mlOX76BXCrzZpLB325fjR
         VtjCpMYlZdu0d56rES28ONAMT3aBqvQ0XMCqQ6jz/TUrI8Y7y07xAQCwQ5WdlLtSS4Br
         29+XhVJgYLEcXmc1aq/ief4Fn1O5gZVme8J/HDP1EDK+dZD3u/3MLIyTVqiyOQ3pwqBG
         /VlT15P5ei0Jk3FdTwxaGYwRTgdmeSOnM21Y1GdmfbzBbLdFY2kPRZZ5a+o7IVol7fjc
         hzvPQn6VJIb1C8ZhMXiL9v1YIIWpCg6Kew8Y9B7KyepvMO6yi1vnnco0LzznQGPFCe6O
         mpCw==
X-Forwarded-Encrypted: i=1; AJvYcCVy1cM0rhPak7tqJHlKagFBWT/4EWkYGAeIeEfbHN+BYCBbkJ/IunWShlzgNzinuSU0B90=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF2tHvJpIlS0L5c1pA2YNK2DwKFZ7cUptzRkpyx76f+qhc9W1o
	591i9BdZb8c32cF0qwOYF/6t7iLI6o+JWMbezDoHQQ4ZDJtTG+V6iLB3FC35rMfpnjxGHBjOHay
	II5AA8CktE5rjRjWsfHTDUnaRhJRu2JO4L5mNSA/x
X-Gm-Gg: ASbGncsERRhi4ID/sBQ9nVqzQ2UPOsrxTgvhB33QYpr47XFDrscarWuevno6ekg0fqP
	XllCtMy6vjh7frH+zphB9T9DAkjzMcePYZTWp+Hc/hWmNOGJLF4CDA3WuwpIxWSOkcY15YdK6AD
	4rwGN4VwEfXzcs11XelN22rk8AWKaJkeO0W8Z4I0NP2w6/jZADt98jiFqMWBrQKncQvUkVfVhH
X-Google-Smtp-Source: AGHT+IEp6IGPuzz6J/+BpJ6aDeMRiVbGyP9uhXLN3ZH8ojjYUdl2R1SNFOG6TloGaR9kARIO3zOdCXd1Ty9ye/gS72k=
X-Received: by 2002:a05:6902:1881:b0:e81:5197:3dd5 with SMTP id
 3f1490d57ef6-e81a2276cfdmr2085466276.1.1749161882078; Thu, 05 Jun 2025
 15:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com> <aEIWOSyFADsfXZnZ@google.com>
In-Reply-To: <aEIWOSyFADsfXZnZ@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 15:17:26 -0700
X-Gm-Features: AX0GCFusmx5LnqBezumi2CBPX3jBsMOV_ncGvRUPGLV-0hofjeATZJ_DcmP1Prc
Message-ID: <CADrL8HV86-8cODX7Qn7U2ULCG8Gm0ym9c30NAnf5sqZo_GD1iA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 3:12=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jun 05, 2025, James Houghton wrote:
> > On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wr=
ote:
> > > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> > >                     "pwrite on a guest_mem fd should fail");
> > >  }
> > >
> > > -static void test_mmap(int fd, size_t page_size)
> > > +static void test_mmap_supported(int fd, size_t page_size, size_t tot=
al_size)
> > > +{
> > > +       const char val =3D 0xaa;
> > > +       char *mem;
> >
> > This must be `volatile char *` to ensure that the compiler doesn't
> > elide the accesses you have written.
> >
> > > +       size_t i;
> > > +       int ret;
> > > +
> > > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PR=
IVATE, fd, 0);
> > > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed=
 by guest_memfd.");
> > > +
> > > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SH=
ARED, fd, 0);
> > > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest mem=
ory should succeed.");
> > > +
> > > +       memset(mem, val, total_size);
> >
> > Now unfortunately, `memset` and `munmap` will complain about the
> > volatile qualification. So...
> >
> > memset((char *)mem, val, total_size);
> >
> > Eh... wish they just wouldn't complain, but this is a small price to
> > pay for correctness. :)
> >
> > > +       for (i =3D 0; i < total_size; i++)
> > > +               TEST_ASSERT_EQ(mem[i], val);
> >
> > The compiler is allowed to[1] elide the read of `mem[i]` and just
> > assume that it is `val`.
>
> I don't think "volatile" is needed.  Won't READ_ONCE(mem[i]) do the trick=
?  That
> in turn will force the compiler to emit the stores as well.

Yeah `volatile` is only needed on the reads. READ_ONCE() implies a
`volatile` read, so if you want to write it that way, that's fine too.

I prefer my original suggestion though; it's less likely for there to
be a bug. :)

> > [1]: https://godbolt.org/z/Wora54bP6
> >
> > Feel free to add `volatile` to that snippet to see how the code changes=
.

