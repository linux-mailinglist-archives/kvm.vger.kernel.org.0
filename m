Return-Path: <kvm+bounces-53447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C92B11F9D
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 15:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FD9C1CE2869
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 13:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910FA1E5701;
	Fri, 25 Jul 2025 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b1UeBBQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497891D88AC
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753451586; cv=none; b=nctrErWP1aL9Q1YIi+qrVPnlr/70jzdu3dm72r/TUCAAWczN6bCTdXlmM8cxdPVPYAXX2uK7vQM4QFAsLBImN4rL7ONGzQgm+cQyIdS0PVgaZ/mA8msBcdaM3Eplp2q/ZopTc7wH8v4aSD30BNI3hcy+CcpaTWYo67RdTYjGASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753451586; c=relaxed/simple;
	bh=N87jvq3BUY2gPXiuHgKyY6u8QFonP5K7Oiq3uLPHJa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ebWdjn/r8WP1aL+Hp+2PKH3sTNlPGSu9xcQ+2m46BDURZ50Z1M0YCg+YYYqK3HWdSTRAkm1mOyqWYCsTd7eRRqWsa6jY+sPN1PBV739EyV5ekeZTWYeIUESt28lPXGr20gMzWPpQMZNR8go3+MvV4spO1JZD5pMiWyT4YvoGltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b1UeBBQ2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso2524145a91.1
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 06:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753451584; x=1754056384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=b1UeBBQ2CWeb3ihttbBMCVPLh4eQYLH7n5cSQDfQlTwnmz7znraryDdcYellm6Cxnh
         Vja2/Zm61hz3jQ4MJ1Uw19HCXnAbOSTsUMSRpLzmdsFRc9pxRhevGRRiA03ziF2G8Ehg
         nRqKQIcEP8Cxkr8RVIhSx3BoEpeiZ+09yj0yiEQmpNNv9g2xT1WyOsavPvncZDvZT5tN
         J7i/Hc+jDywesaVRDi3/8DXtOwRieyuhrPEYnchmKRPTQQwU0R6Hfgk/te2Sx2LoK/xq
         QBFb9joMAULbu2cRe3UX6k1dZYJKsQfigdAe5eptd5LK6whE80c4WFwLteRrLMLxjf4s
         +uHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753451585; x=1754056385;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=VEYjHQsxstCK1qaE0jzUMMb+DmyjEwXUmX7TRk+zLrG8SV0y2VVJvVjZZxt9Ks2/fU
         ZfoNuwMPZxMxBHduaV4pgc+CV6umCAWAGMH9bbBkqZdjDiwHGnNepd9oDJUCKC7N2gBe
         084QbHgTBPBn5MGxgJzjAYf5Tjf+FweDaNPtENHE30HeBKNmalbpStzTxvLNlP8/z0y6
         /tnwGLrIwzsCOnONqWQldGvFK/VcT+eAkuNVQIN/TWaREZTExWGL5cCASEOWx16B5NjL
         HlDwoaVcNgC3ujQu8R5Mx0+rLNxHHOB3trVqvFxfJcWHoXB73ACx05Y0YqLMIhUgweTX
         y7bw==
X-Forwarded-Encrypted: i=1; AJvYcCXkUlhKhLY2o7RlK+JHJxCiA6yzs16PTKjo4o/Ol2AxbTqr2E/E5Qq+Aq58wZpIYPG9UJk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4yX5BHGtgKslby6EXVrxkwJQW/PKXwWNVHxCoJ1cjkaChGUzV
	apwrZvvvkYAgEx91g65Ug3igTsAwdx6KBzDdNLFjfwJZWQr26PCHBUvU7+nyuC8mJ7E0u9Dp8DJ
	AEeDJHA==
X-Google-Smtp-Source: AGHT+IFjGdSbLTJQeXBeF3KPsF2x5fp/wtnoZ2iNYJbBIB/HYs8Zqa8zIKSNCWliwPnicno1k0gnFATv6p4=
X-Received: from pjbsp12.prod.google.com ([2002:a17:90b:52cc:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5804:b0:311:f99e:7f4e
 with SMTP id 98e67ed59e1d1-31e779fa061mr2853030a91.16.1753451584187; Fri, 25
 Jul 2025 06:53:04 -0700 (PDT)
Date: Fri, 25 Jul 2025 06:53:02 -0700
In-Reply-To: <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOMPpTWKWoM_O5J@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *=
fault,
> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, st=
ruct kvm_page_fault *fault,
> >  	if (max_level =3D=3D PG_LEVEL_4K)
> >  		return PG_LEVEL_4K;
> > =20
> > -	if (is_private)
> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> > +							is_private);
> >  	else
> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>=20
> No change required now, would like to point out that in this change
> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
> shared pages, guest_memfd will be the only source of truth.

It's not an assumption, it's a hard requirement.

> This holds now because shared pages are always split to 4K, but if
> shared pages become larger, might mapping in the host actually turn out
> to be smaller?

Yes, the host userspace mappens could be smaller, and supporting that scena=
rio is
very explicitly one of the design goals of guest_memfd.  From commit a7800a=
a80ea4
("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory=
"):

 : A guest-first memory subsystem allows for optimizations and enhancements
 : that are kludgy or outright infeasible to implement/support in a generic
 : memory subsystem.  With guest_memfd, guest protections and mapping sizes
 : are fully decoupled from host userspace mappings.   E.g. KVM currently
 : doesn't support mapping memory as writable in the guest without it also
 : being writable in host userspace, as KVM's ABI uses VMA protections to
 : define the allow guest protection.  Userspace can fudge this by
 : establishing two mappings, a writable mapping for the guest and readable
 : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
 :=20
 : Similarly, KVM currently requires the guest mapping size to be a strict
 : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t supp=
ort
 : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
 : mapping.  Decoupling the mappings sizes would allow userspace to precise=
ly
 : map only what is needed without impacting guest performance, e.g. to
 : harden against unintentional accesses to guest memory.

