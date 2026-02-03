Return-Path: <kvm+bounces-70088-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sD4JISNmgmlOTgMAu9opvQ
	(envelope-from <kvm+bounces-70088-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:18:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB23DEC77
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E383E307CEA4
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 21:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9518D35A92D;
	Tue,  3 Feb 2026 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oot8xxCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711462EB10
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 21:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770153448; cv=none; b=g8cGjDdzutgsMikQuLnDrgY4RMr/NpDPsVKZiE4AG2RFrD3tB7Vy3T3U8tF+qwkY6QMbe1Y5R5z1ivUx2C2yDBZk1K2Bv3OPkNHjRD8Aynbh76Uremjw9JPJzyiXa5euvgGUtLXGwZvzN3zQFWPBr37i9+fCTSUDK8rlbHtmbJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770153448; c=relaxed/simple;
	bh=q7TBmmYy5zKha9UWOs8VX5s4nynivNQu/jxFVFMQUSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGTWFPbXKs/GaVWwZFUhh8++AilKy+bOpWFCnV/sSMdEkjUrpLfGduB7HcmVaQrCxCCf8rGfBF/b88FJ9Ir/jCoZktZrsQg4IK1txQMXFkmrq/K4BFsoVIXytkHPzNIJcVKW4IWzHx3EEKHuPAgf72oo9iqH63nekjmFcwdMObI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oot8xxCJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0f47c0e60so32261155ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 13:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770153447; x=1770758247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D0/+kZSHM7M0m1jLitFGSeKA06Tacic7vjEUioHDGHc=;
        b=oot8xxCJ5H/UYfFnBsuOI9/d6jPgxb5rLuBe+pEi2KfIvirZAXQ7fMbJTUrBH+LsNH
         GI5gasAFU31j5AtGnWS+MkbW+dpqRGjvMgCwAlWJGuVyxmGavxuU/fo4pF99OFrJ/r3o
         /i6Kc/Jpa2H/f2QUtTFnuH5pzSMceu5MliKMw3mWQ7lo6OZPbS3A+OYRPaV+6bZbs/eW
         EXzbU/ZgszvsXzOLyojnoVUgp+gBMFLJdP8sEMAMt73MMfSInycd+7xs+hXUkIkGlUXg
         c4/3abUxgyhPJH20ZxbLhaOZKmZpNt47CMZ8d64QBn/rFqtdlWS8kMpP5ffK7eTWECFm
         nW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770153447; x=1770758247;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D0/+kZSHM7M0m1jLitFGSeKA06Tacic7vjEUioHDGHc=;
        b=E62G8nRmXB4W0BYH5Lj6jIY8UCJIcp4hoYPc0lJPiHx3n4rPF9CAyITVGqLbLUxMOa
         o7mqbMTPmbPE8z4YwTXwnPtGTPHulo8u/VT1JdqCRrLnVZ+Vdn1VPtGRxChPgEb7mCD8
         1DX4rE/y2z+xvTMKG11CRHsyNEZLIhMm+4Pk0pjO3w5++3yhFo+U8bfEd61FHb+SRltw
         srMr1cpMLnzt3YROnbSkVSQD3VVQ1pojNjrlouSThW7dka1sx1aI+IDvSIEhE7LnxLiq
         Oo05jUHP7XdyhnyO8urNwfQbQJeRJcWZp3sBcYuVVj3hh4qfeCGI1R7cAtxXGBbfYcuJ
         J/Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXHEQQIziFiNFqf1q5UzltpLwj7xYG49C6einkaDAdwNxRlK0L30bejqHn4bYrV1KMDw6U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/JQi2ZLSU9z5yiPgGPUAFIub+jhQTcPPem0Sd2KhGIlbznP/H
	iIhQr07Rv/QGHnZAdOgHlSx9n8hV+1KF0rPlxwo/1N3sFW435bs9do8dI3bL9Lbrm1r3gDd9iOZ
	Y8mQAkA==
X-Received: from plrq7.prod.google.com ([2002:a17:902:b107:b0:2a0:c92e:a37a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8cd:b0:2a7:683c:afc6
 with SMTP id d9443c01a7336-2a933fbc24emr6884695ad.39.1770153446865; Tue, 03
 Feb 2026 13:17:26 -0800 (PST)
Date: Tue, 3 Feb 2026 13:17:25 -0800
In-Reply-To: <c01b2f81e025dd38be90d3820260c488c7eb22ce.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-20-seanjc@google.com>
 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
 <aYJWvKagesT3FPfI@google.com> <c01b2f81e025dd38be90d3820260c488c7eb22ce.camel@intel.com>
Message-ID: <aYJl5XoQw5In9DOr@google.com>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>, Vishal Annapurve <vannapurve@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70088-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DBB23DEC77
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Rick P Edgecombe wrote:
> On Tue, 2026-02-03 at 12:12 -0800, Sean Christopherson wrote:
> > > E.g., I thought we might be able to use it to allocate a structure wh=
ich has
> > > "pair of DPAMT pages" so it could be assigned to 'struct kvm_mmu_page=
'.=C2=A0 But
> > > it seems you abandoned this idea.=C2=A0 May I ask why?=C2=A0 Just wan=
t to understand
> > > the reasoning here.
> >=20
> > Because that requires more complexity and there's no known use case, an=
d I
> > don't see an obvious way for a use case to come along.=C2=A0 All of the
> > motiviations for a custom allocation scheme that I can think of apply o=
nly to
> > full pages, or fit nicely in a kmem_cache.
> >=20
> > Specifically, the "cache" logic is already bifurcated between "kmem_cac=
he' and
> > "page" usage.=C2=A0 Further splitting the "page" case doesn't require m=
odifications
> > to the "kmem_cache" case, whereas providing a fully generic solution wo=
uld
> > require additional changes, e.g. to handle this code:
> >=20
> > 	page =3D (void *)__get_free_page(gfp_flags);
> > 	if (page && mc->init_value)
> > 		memset64(page, mc->init_value, PAGE_SIZE / sizeof(u64));
> >=20
> > It certainly wouldn't be much complexity, but this code is already a bi=
t
> > awkward, so I don't think it makes sense to add support for something t=
hat
> > will probably never be used.
>=20
> The thing that the design needlessly works around is that we can rely on =
that
> there are only two DPAMT pages per 2MB range. We don't need the dynamic p=
age
> count allocations.
>=20
> This means we don't need to pass around the list of pages that lets arch/=
x86
> take as many pages as it needs. We can maybe just pass in a struct like K=
ai was
> suggesting to the get/put helpers. So I was in the process of trying to m=
orph
> this series in that direction to get rid of the complexity resulting from=
 the
> dynamic assumption.=20
>=20
> This was what I had done in response to v4 discussions, so now retrofitti=
ng it
> into this new ops scheme. Care to warn me off of this before I have somet=
hing to
> show?

That's largely orthogonal to this change.  This change is about preparing t=
he
DPAMT when S-EPT page is allocated versus being installed.  The fact that D=
PAMT
requires at most two pages versus a more dynamic maximum is irrelevant.

The caches aren't about dynamic sizes (though they play nicely with them), =
they're
about:

  (a) not having to deal with allocating under spinlock
  (b) not having to free memory that goes unused (for a single page fault)
  (c) batching allocations for performance reasons (with the caveat that I =
doubt
      anyone has measured the performance impact in many, many years).

None of those talking points change at all if KVM needs to provide 2 pages =
versus
N pages.  The max number of pages needed for page tables is pretty much the=
 same
thing as DPAMT, just with a higher max (4/5 vs. 2).  In both cases, the all=
ocated
pages may or may not be consumed for any given fault.

For the leaf pages (including the hugepage splitting cases), which don't ut=
ilize
KVM's kvm_mmu_memory_cache, I wouldn't expect the KVM details to change all=
 that
much.  In fact, they shouldn't change at all, because tracking 2 pages vers=
us N
pages in "struct tdx_pamt_cache" is a detail that is 100% buried in the TDX=
 subsystem
(which was pretty much the entire goal of my design).

Though maybe I'm misunderstanding what you have in mind?

