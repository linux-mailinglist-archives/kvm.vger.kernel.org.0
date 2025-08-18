Return-Path: <kvm+bounces-54905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A70CEB2B1C2
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96261520C5B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A88E25485F;
	Mon, 18 Aug 2025 19:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2fRt1zA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219CC3451DE
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 19:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755545851; cv=none; b=oyFx5TbRxKH0OKYJHMKbN7B0Bf5dpO1qdgjrvDQg4z1UFel+kFhKAoSG0w8hbDQo3YSNjE4ZBrY3539uJ2OTGXSylYF7hMC8p80YOPqsRqyYWqsPsNdVu3eszPurTRw2m517+ajhmKyXmwm6C/hNAhN0uCjgHHATiQQPCsUA8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755545851; c=relaxed/simple;
	bh=rhg2NJxJ5mO43ntv4w9E2cki3Mo3N/wwdWjKgaxcaDs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6pXkqCi1aKpAOPQAk5KtYVvdipHRIRf1gH2Uqj8b6aBgEqXVcvjUQP1DY6naTHh7Vq04ttIDESv5oiGp0k1dd505gOnCmipeJM//KVow6dQi2A9gD9PY7dHYtKePQqH4XYL5GkM3gHM2QyUX2biTIBjrGxiXMWJDskDfoDVjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y2fRt1zA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755545849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRwGIPM9YzpcmpC8C5YaTku6MLYLm0Rnqq0blqhQqmA=;
	b=Y2fRt1zAv+ocrtG3+q8+zh/wP2TTjoBiAns+jGcE5N1FAQ0SEib9OIlOTlhZiO0riYyqKC
	GFGpN7LDsVTpIFTIEyVOsZzb0lrJtFjwrAO2/8u5q6LMQW8AKCvDBiS5Uzzw82ahdJ1SE2
	j/rk52vrdd80ooKOXyfX1IIbF3BfguE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-PLqJVqowOkSSwJRK2sMU3Q-1; Mon, 18 Aug 2025 15:37:28 -0400
X-MC-Unique: PLqJVqowOkSSwJRK2sMU3Q-1
X-Mimecast-MFC-AGG-ID: PLqJVqowOkSSwJRK2sMU3Q_1755545847
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e5766e4e8bso4764065ab.0
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 12:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755545846; x=1756150646;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRwGIPM9YzpcmpC8C5YaTku6MLYLm0Rnqq0blqhQqmA=;
        b=o3OJ/UkFvBVXhzx7zwqVi8qbF+/Qo0gWIIv51MX10f2gQqQRpUaEgTPLowv9C2UzhK
         qlx9vg5L0M8v0dflghGOJd1GmsHCUhD6W4GnyoDvSIyp8jsx3igWiJ0tLe0rYX9oXkIm
         W1GMIiGLfuu5EHWQ/IOlwWv9amo5+z7jRHkLEHbeVpuajWO7HGCEyZQRWe0jm9YXCVvE
         Ih0p4n9h5WU59Aj3ekl33454hlxqXYgZvt+Vx22uWTDhJRypv0pkTW8cAmtQDZhKCtki
         I70lgN7vBiOs2E2lstM5ngjNTiDvxhof42m60flax1rpHFbi/7ubxH3CNaLaxMNDRp8F
         r0zg==
X-Forwarded-Encrypted: i=1; AJvYcCX5zHrqRY/LTMCeYdR09bODOfF+sy4uaJnBVKojvpnVNvpRZVib4OI+roUQaSaFBvtL1kk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+e+w76OuDewf1Zj3Ty/rKMwYilLyhKCyvIUSIXJLUY9FCgeAM
	Mcc61Y3zSv4hs17MUM1DKwcfwQ4p3lfDjeYvfQVKZGDE8iFjPc+yzd3QmvXmd8qbONQ5P2ttbE+
	54nT++aQCWOWTidWBL47VuVCtc4rsMx37PoaSl7/DTxHpEM3wu6Etb1nMIziNWg==
X-Gm-Gg: ASbGncvXRYsKLjdZh6zI3RtLr6g0lJQbueJldgJ1J/dwXz2xf5v+QpsLciD5cvOvazs
	xnF5bz3WEY5NzX9mOTvAdGU2frQhAaQtmfieVvXFqWFZgVHGG2yo09siEpMQuQ/hdSkGAoViHN2
	f2zv3BHJRbNiR4XiB6X7yV+0FwbLS+LboPHRiSv91PSsU4uYLGE6pbLD/FfPF2nXbtCxm62gTUy
	1BAJQqnsZB/n4FyhUs2JmLkterJXpQuj1iY97fv82YfyHvkTfLg/N1RT/j3WbpMQ8qq1NMGa2Gj
	uuEgVTcxOLB3Y6pdYXsR0cuSgyipUkmQkn6IXI6SpfQ=
X-Received: by 2002:a05:6e02:1521:b0:3e5:4179:18b2 with SMTP id e9e14a558f8ab-3e57e8a8e98mr63386675ab.4.1755545846384;
        Mon, 18 Aug 2025 12:37:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHzFV1UPl2Y8JCpvPx/xfIN66wYffY/ldAH7toTC04NV+nIb9zz1vQqgnyiqn5i3OMYn4z4Q==
X-Received: by 2002:a05:6e02:1521:b0:3e5:4179:18b2 with SMTP id e9e14a558f8ab-3e57e8a8e98mr63386505ab.4.1755545845871;
        Mon, 18 Aug 2025 12:37:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94993da8sm2746061173.52.2025.08.18.12.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 12:37:25 -0700 (PDT)
Date: Mon, 18 Aug 2025 13:37:21 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Aaron Lewis <aaronlewis@google.com>,
 Adhemerval Zanella <adhemerval.zanella@linaro.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, Ard
 Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
 Bibo Mao <maobibo@loongson.cn>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 dmaengine@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>, James
 Houghton <jthoughton@google.com>, Joel Granados <joel.granados@kernel.org>,
 Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, "Mike Rapoport
 (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat"
 <prsampat@amd.com>, Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Vinicius Costa Gomes
 <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, Wei Yang
 <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: Re: [PATCH 00/33] vfio: Introduce selftests for VFIO
Message-ID: <20250818133721.32b660e3.alex.williamson@redhat.com>
In-Reply-To: <CALzav=fdT+NJDO+jWyty+tKqxqum4RVkHZmUocz4MDQkPgG4Bg@mail.gmail.com>
References: <20250620232031.2705638-1-dmatlack@google.com>
	<CALzav=dVYqS8oQNbygVjgA69EQMBBP4CyzydyUoAjnN2mb_yUQ@mail.gmail.com>
	<20250728102737.5b51e9da.alex.williamson@redhat.com>
	<20250729222635.GU36037@nvidia.com>
	<CALzav=d0vPMw26f-vzCJnjRFL+Uc6sObihqJ0jnJRpi-SxtSSw@mail.gmail.com>
	<CALzav=fdT+NJDO+jWyty+tKqxqum4RVkHZmUocz4MDQkPgG4Bg@mail.gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2025 11:59:39 -0700
David Matlack <dmatlack@google.com> wrote:

> On Thu, Jul 31, 2025 at 1:55=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Tue, Jul 29, 2025 at 3:26=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com=
> wrote: =20
> > >
> > > On Mon, Jul 28, 2025 at 10:27:37AM -0600, Alex Williamson wrote: =20
> > > > On Fri, 25 Jul 2025 09:47:48 -0700
> > > > David Matlack <dmatlack@google.com> wrote: =20
> > > > > I also was curious about your thoughts on maintenance of VFIO
> > > > > selftests, since I don't think we discussed that in the RFC. I am
> > > > > happy to help maintain VFIO selftests in whatever way makes the m=
ost
> > > > > sense. For now I added tools/testing/selftests/vfio under the
> > > > > top-level VFIO section in MAINTAINERS (so you would be the mainta=
iner)
> > > > > and then also added a separate section for VFIO selftests with my=
self
> > > > > as a Reviewer (see PATCH 01). Reviewer felt like a better choice =
than
> > > > > Maintainer for myself since I am new to VFIO upstream (I've prima=
rily
> > > > > worked on KVM in the past). =20
> > > >
> > > > Hi David,
> > > >
> > > > There's a lot of potential here and I'd like to see it proceed. =20
> > >
> > > +1 too, I really lack time at the moment to do much with this but I'm
> > > half inclined to suggest Alex should say it should be merged in 6
> > > weeks (to motivate any reviewing) and we can continue to work on it
> > > in-tree.
> > >
> > > As they are self tests I think there is alot more value in having the
> > > tests than having perfect tests. =20
> >
> > They have been quite useful already within Google. Internally we have
> > something almost identical to the RFC and have been using that for
> > testing our 6.6-based kernel continuously since March. Already they
> > have caught one (self-inflicted) regression where 1GiB HugeTLB pages
> > started getting mapped with 2MiB mappings in the IOMMU, and have been
> > very helpful with new development (e.g. Aaron's work, and Live Update
> > support).
> >
> > So I agree, it's probably net positive to merge early and then iterate
> > in-tree. Especially since these are only tests and not e.g.
> > load-bearing kernel code (although I still want to hold a high bar for
> > the selftests code).
> >
> > The only patches to hold off merging would be 31-33, since those
> > should probably go through the KVM tree? And of course we need Acks
> > for the drivers/dma/{ioat,idxd} changes, but the changes there are
> > pretty minor. =20
>=20
> Alex, how would you like to proceed?

I think we need an ack from Shuah for the overall inclusion in
tools/testing/selftests/

AFAICT the tools include files don't seem to have any central
authority, so maybe we just need to chase those ioat/idxd acks, along
with Shuah's and we can get this rolling and follow-up with the latter
KVM patches once the base is merged.  Thanks,

Alex


