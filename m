Return-Path: <kvm+bounces-8887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F568583A1
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BB09281F0C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CFF133294;
	Fri, 16 Feb 2024 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h957QmJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18942132C1F
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708103450; cv=none; b=TBJRYnKuSNcdLC65UzEzbP2/0b/VgCIq5c+8wNumr3xL/Yz6QYrZx5Wtu7BKgfNLJPLgDkv1mzLDb5a42kJd5rYfcpAt1dnJlVbqKPL+CG14tX38X7KpX0rvymn0oAylapX9E8kXKJZr2Sk1NTE+arPB52RgBznN70D5Op6PaS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708103450; c=relaxed/simple;
	bh=pgTDiq6ve8t51vcCTkPcdbVxXT7PbEdlzjJcC+OUwC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pEdkEr8KtL9+U7r8NbL71DgBF1S+yAWrJrWrv+pviOKovUO7Gw1b/VSbEnIS9nE4sykbrW6lbUQsJRkMU/4Wys2agYJKels7jaGWkUXqheQ+Tgl50KKMi/9LN5BlvKEPJGQ7HV/xcvgqEY/wdzPdSAhfUnFXXYVA3+KZ1Ofqujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h957QmJD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso907219a12.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 09:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708103448; x=1708708248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPLoHMDsqQNJdlKAI9HnWogN2mbo4uQRJ1gPPP9G92g=;
        b=h957QmJDQTstbymkqM9WcFdkbUdswfszidOrgHRgwnZJzDHt2keBGq59Fi3TSryCu/
         ZJWgvnNQlR7OSEybFxMGpaAINEJGf15n0g0BOJkJEkm0ifUVRh09EohfGkvZInTryJrG
         0E1Yfr7IOGoXCuCYSghBXSEP9GpUkEd93aRGSbl5zY+hQzHAs9xj1AKR5En5AiFNFPD1
         2IXKpde8H0HCatbVGxdyjthDusQDcT+xGx34mHTez5+kxrlqp3R/FVvoOxknfkV9BpLL
         b0rcyJWqdu/JvIy7SHOK9IzINzMxfegBRga5S82Rrwemvw3Bfy4Ky5B7UaWoTE67imXC
         zvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708103448; x=1708708248;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oPLoHMDsqQNJdlKAI9HnWogN2mbo4uQRJ1gPPP9G92g=;
        b=W2Mm36enPrYOEhY2aUpvps7EMaZQm91vkvXaR8cQ7Mmwt4NVfFoemHHIa1npaxSWz6
         etXxCV0/VpSgMh2b7yo2l8FFybYC/wGrPwgg44zaAbJpNzRo3rfC2VkwSn1SZLIgDSqF
         VMZkED4HypEvcsdNR8xDORs1VBGwEE3W3w7NDkMLMAvQ79WxTOPkGDfgV+EhS9eteXoj
         rHiZAnZuNp5acR9RIhl8iQtgWPvnSTEnbRUmR2v2mf3W188Eq7jWYnE3Db1rx5+PE1Id
         esH3ZBxUYRYeKQbRpqiEHFJwAQOBiQ6uaOo05bkebpqFhrCbnCnmzFdP9QBQ5R3TIZQg
         1aXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb3NHnMit63u34j9hyUksRzG4jN8KoEL9cvUqXw3AT60CxPpGX6Ecd1ev3EIvfc6a2A2lpwHykmGg5olK9SkACzh9U
X-Gm-Message-State: AOJu0YxUJuewOUZVcVwm6OkMBvEa8HjJWC2NCvhbsrJhTleXs84JC0n9
	NOrZnUlV21tFmxyz8L+pmGp6IXE2jcpj3dD9DnCeXKHa/s0mHGhWOGe8TDH+BcqIFEUn7tV+eMH
	7Pw==
X-Google-Smtp-Source: AGHT+IEuQ5X5Dpn+eXH2wSbOlk/tG1uJkrCn9KZXpp0zdqjHWxT9zYlxZR6bvTLZXI6JTpp/biSrSsP8MpM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d0d:0:b0:5cd:9ea4:c99 with SMTP id
 bf13-20020a656d0d000000b005cd9ea40c99mr64720pgb.6.1708103448433; Fri, 16 Feb
 2024 09:10:48 -0800 (PST)
Date: Fri, 16 Feb 2024 09:10:47 -0800
In-Reply-To: <Zc5bx4p6z8e3CmKK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-2-seanjc@google.com>
 <CALzav=c0MFB7UG7yaXB3bAFampYO_xN=5Pjao6La55wy4cwjSw@mail.gmail.com> <Zc5bx4p6z8e3CmKK@google.com>
Message-ID: <Zc-XF0yQp_dDUa6f@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Mark target gfn of emulated atomic
 instruction as dirty
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pasha Tatashin <tatashin@google.com>, Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024, Sean Christopherson wrote:
> On Thu, Feb 15, 2024, David Matlack wrote:
> > On Wed, Feb 14, 2024 at 5:00=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > When emulating an atomic access on behalf of the guest, mark the targ=
et
> > > gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
> > > fixes a bug where KVM effectively corrupts guest memory during live
> > > migration by writing to guest memory without informing userspace that=
 the
> > > page is dirty.
> > >
> > > Marking the page dirty got unintentionally dropped when KVM's emulate=
d
> > > CMPXCHG was converted to do a user access.  Before that, KVM explicit=
ly
> > > mapped the guest page into kernel memory, and marked the page dirty d=
uring
> > > the unmap phase.
> > >
> > > Mark the page dirty even if the CMPXCHG fails, as the old data is wri=
tten
> > > back on failure, i.e. the page is still written.  The value written i=
s
> > > guaranteed to be the same because the operation is atomic, but KVM's =
ABI
> > > is that all writes are dirty logged regardless of the value written. =
 And
> > > more importantly, that's what KVM did before the buggy commit.
> > >
> > > Huge kudos to the folks on the Cc list (and many others), who did all=
 the
> > > actual work of triaging and debugging.
> > >
> > > Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate a=
tomic accesses")
> >=20
> > I'm only half serious but... Should we just revert this commit?
>=20
> No.

David, any objection to this patch?  I'd like to get this on its way to Pao=
lo
asap, but also want to make sure we all agree this is the right solution be=
fore
doing so.

