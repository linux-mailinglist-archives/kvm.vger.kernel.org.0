Return-Path: <kvm+bounces-67183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE384CFB1CC
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3832304D874
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B55322537;
	Tue,  6 Jan 2026 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yXj/DqNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732B530B509
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 21:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767735522; cv=none; b=UjLbiJs/Vxm7CiLhegtZXrgvRwlI7WqBqa1uCM3xH9CeqcxaKmZ8uVdYRKClNZ+a5217QFq0vx2DRgZ8dvineeS/Wf3XyqU7p+BkoVW9PPQrzLtJj4i+0cp3kOHXLh5WPwe6sVkmiKmfwg9zsi6Hdi4xOcHwP9cqz3t/1tOafHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767735522; c=relaxed/simple;
	bh=J7kkeY+hAmd8ZJE+y/yQQSRW9C3r05g/nEqKrrOm59o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ExewvrzJIg7O4JwfsYsMRyWow/o5V8L4dLZR+G5NgcUI6oKQ0bQW0YdLLlH3J4ZBXVNpwIKJ2hqJHzBG4B+9IowlPf5bOwSGd7lhkp9CWQAOBbY9Gmu2K/jqs/zxkmu1rY/VnCxlSLdBOdvdZrKIo/CtCv3bUCNVfY8fjG1WTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yXj/DqNJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7bb2303fe94so1443126b3a.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 13:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767735521; x=1768340321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=50uasNaeRc9hCyxVG7sj5DtGwxMSQDJAHl63m0HDP5g=;
        b=yXj/DqNJI2Wj9SlKVesykbuJPGt6GXfomAdgRu2lW1k0pPppc753bHXTC/TN33dOaF
         UpXhiD9O3wsTiCkEyZI8acK3OXJfLxtcFGBDqgFIDoiSypRsb0gEBgtXu2AtE6JxL9xu
         PxRx1gfjyiQspVMaaGUitMVoT5VfaVmWNsZ7lVQiDpaXZeTTFOFQvm0rreEd3GmHoM+b
         /Phy2FJdNpUW+yKk+ufdnQ0L4wKH92m+ZWD4+HWbmvOUj8rG8btwieAJQZeHJfxB0gK8
         cWwEptFcsJ2veG94Udhm1RACs22CXYk4zdesJVE/9OphUReyyIi0RTODJDVoLEzLIGuN
         ilqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767735521; x=1768340321;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=50uasNaeRc9hCyxVG7sj5DtGwxMSQDJAHl63m0HDP5g=;
        b=VeRuwQNQxw+z4KtE6DKuHjm5gCuV3NMs6/rgRwOTFBV33ABUajuDOqmczVEkz8B/ZB
         yckmGdklOQPrDGu8IXvMk5kG+R9naqwjF8xqvM1wx13ouMQTWYaC8gi8rVBGAsFUi2kp
         MRUYHd33hkzfxxgShT/kOiJ+mNPTt75xb9IZVqjRRbr6cEpNEfSBVryr1646GSo+LWfV
         moYrw2pq5doRTvvCGDII0KlMM3Dfbzbx8z5vwL6Zpo+rCObd0FaWfPwv9N96fZ6mPrLe
         mpbEF62z7DoUbwUJmeyfZ9GozA/FoaCSHZoRXBRSeL/MU3QVUQKwhQ3qcpPWy0ofsET8
         Cn3A==
X-Forwarded-Encrypted: i=1; AJvYcCVMhxTvHHuJav+fVSV2QlFWThK+dUMeGy27HbnkylnYL3AANMRThPpZ+0gS+8yUSgnnJX4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3pv6Re6Fk0+XF12T+DQHbV89//8UMCCUHNfQ7O7ewd4/5UWPm
	HnLYkGr9PC9OjRcll1/YL23ZtMcoCfQBXjQr8UqwkPQ+ENk6QW9P4jnkoPDLlG1a1IbqKABb0RC
	//XWQ/A==
X-Google-Smtp-Source: AGHT+IF+J0Gou9Jb6Tj1TDLI/Yg74+cghYLKcJ8f4D9z+OGLD50JSyYPIIKIVG/K1dduNczGyWLQlIfl6fw=
X-Received: from pfnx22.prod.google.com ([2002:aa7:84d6:0:b0:812:1701:e769])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a111:b0:7e8:4471:8d4
 with SMTP id d2e1a72fcca58-81b7f6e4fe6mr422971b3a.53.1767735520683; Tue, 06
 Jan 2026 13:38:40 -0800 (PST)
Date: Tue, 6 Jan 2026 13:38:39 -0800
In-Reply-To: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
Message-ID: <aV2A39fXgzuM4Toa@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026, Ackerley Tng wrote:
> Vishal Annapurve <vannapurve@google.com> writes:
>=20
> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> >>
> >> - EPT mapping size and folio size
> >>
> >>   This series is built upon the rule in KVM that the mapping size in t=
he
> >>   KVM-managed secondary MMU is no larger than the backend folio size.
> >>
>=20
> I'm not familiar with this rule and would like to find out more. Why is
> this rule imposed?=20

Because it's the only sane way to safely map memory into the guest? :-D

> Is this rule there just because traditionally folio sizes also define the
> limit of contiguity, and so the mapping size must not be greater than fol=
io
> size in case the block of memory represented by the folio is not contiguo=
us?

Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (and=
 still
is) strictly bound by the host mapping size.  That's handles contiguous add=
resses,
but it _also_ handles contiguous protections (e.g. RWX) and other attribute=
s.

> In guest_memfd's case, even if the folio is split (just for refcount
> tracking purposese on private to shared conversion), the memory is still
> contiguous up to the original folio's size. Will the contiguity address
> the concerns?

Not really?  Why would the folio be split if the memory _and its attributes=
_ are
fully contiguous?  If the attributes are mixed, KVM must not create a mappi=
ng
spanning mixed ranges, i.e. with multiple folios.

