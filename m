Return-Path: <kvm+bounces-22823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5DA94372A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 22:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6140C1C21069
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 20:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967221684AB;
	Wed, 31 Jul 2024 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WeyhuXd7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FE3B1BC
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458189; cv=none; b=QjIW76KTkT2pUmzkiZlEXapMn4MrUNXcMGVeuRnAQFq0mH+kL+jlJjAD9uGhE0RVEPVB4l1NNRUQHa+zS0HzsFbTFhubZvhE80UibkAfvPdc1FcPZ7XYa2LhzalpmQgchzTtJmxBQHe9b+W9tKf6tw3deEBturOvsp+qvjCeTG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458189; c=relaxed/simple;
	bh=z1aLVeNoBym3Qjn/r9ThqGkDG4AOjTwKh0lTuQS/B+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gkj/4Res8kV9+mxm2wSw1qV4uMG41ANRZXNErHgkrIo/kyGqyeUkSYOGCYbfYF3XNs3NiF8T08lRWcDFsvazg7c+PDuf7Fv+R11dj0RdzTWgfezx7t4DeBBes1NbdHQAhZvVruaHDbc02PNpENN5jZuLthIergDvj9r2NC1YS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WeyhuXd7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bb206570aso2959887276.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 13:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722458186; x=1723062986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kd/mYHbPzOSIwsUM5m5UMPqJkKyWoklOLcVSOqbILGs=;
        b=WeyhuXd7I/9HsccEAdIat5gekMhyyetArz33y71PyOc1qGoQJ6ZwTwBU03VoYXUnjD
         nleVvSHuWKdvCA3G7jTW+JyMb9C8y1Cqbm6qVrQshdRN5ZLI/gBd6RMO81liQzZstVYW
         bfIMboSjdr0bh9YSPItGecdUGm+i01vFy5gNWEn0w0xs4c+z9FTe19ekN+/YwDyMTYrr
         dIa7LEg8wKXE3iDFHkisRRFDSpV74+q8hahraJeruURji5PC1E9eVja5XUcycN+yD+MK
         6OT5iaX53wAvq9jSvmzfrAAdqXPgADCq50O7SFCAyFR+mpH8ndIPYZuW9/woaDSIR6N7
         HblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458186; x=1723062986;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Kd/mYHbPzOSIwsUM5m5UMPqJkKyWoklOLcVSOqbILGs=;
        b=FzE/JQpDbsnv79XDpfd3iyId+nKSpQRQrPAyiytVhqkqVB1aEQFtsrGV92NRUGwqSC
         LsjDGiORqT1hmtHjLFb4vb+1m/b27CwIebvOqrw9UDLUuBpcS43w2wMa+UuyRUmx94Bv
         ESOL1upo6h1p6RlElpd+NOo1+tGkXexPJb9lzpKrpP4t4pNOId5mvqR1yKmXbqFc7shR
         cZ4iFc43ao5b3caj6wVp6o19yKRym//vuTjTv91xLBGjOQj3W2hpcK8VqrEiO2yapojN
         a3bagZj/SSjk086CJN6z0pp/DdulKQC3T5Y0J6SK5KfdT49uvOYDwOY7jNbxAw3KxuNd
         tXdA==
X-Forwarded-Encrypted: i=1; AJvYcCXCHS+tGKQbI7w4t0KGFc/4WZPS3b7Rz86NuK8/Bn0qS360h+dpvttB9xIO2izgS6PWdiSx20c5+zjdpXdSlfjcf6/T
X-Gm-Message-State: AOJu0Ywgzxn82Fu13Fz6Vui52xtNtORRHmh6/o+59mleLR9xbc7zWglY
	Wz7wJPyUeKDdA3qm7cih8WCgFHJWuNDUxW4b+DusiKl8jEDRTsgM1lsMHiEjZzLLQfiyCeBJs0n
	G+A==
X-Google-Smtp-Source: AGHT+IH0DRpeCdEjd5+EVXte2iiNPB7q7dTvECq86U0Z8nMo4fguKYduL9RXt42ZsXAM2SH8mq6gA4JZJ0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d2:b0:e0b:bf20:4ff8 with SMTP id
 3f1490d57ef6-e0bccf7b434mr932276.0.1722458186501; Wed, 31 Jul 2024 13:36:26
 -0700 (PDT)
Date: Wed, 31 Jul 2024 13:36:25 -0700
In-Reply-To: <87a5hxfs3d.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-2-seanjc@google.com>
 <87a5hxfs3d.fsf@draig.linaro.org>
Message-ID: <ZqqgSW1Z07aBGwQh@google.com>
Subject: Re: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if
 copying MTE tags hits ZONE_DEVICE
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > Put the page reference acquired by gfn_to_pfn_prot() if
> > kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
> > than-stellar heuristics for dealing with pfn-mapped memory means that K=
VM
> > can get a page reference to ZONE_DEVICE memory.
> >
> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a gu=
est")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/kvm/guest.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 11098eb7eb44..e1f0ff08836a 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >  		page =3D pfn_to_online_page(pfn);
> >  		if (!page) {
> >  			/* Reject ZONE_DEVICE memory */
> > +			kvm_release_pfn_clean(pfn);
>=20
> I guess this gets renamed later in the series.
>=20
> However my main comment is does lack of page always mean a ZONE_DEVICE?

Nope.

> Looking at pfn_to_online_page() I see a bunch of other checks first. Why
> isn't it that functions responsibility to clean up after itself if its
> returning NULLs?

pfn_to_online_page() is more strict than gfn_to_pfn_prot().  At least in th=
eory,
gfn_to_pfn_prot() could return a pfn that has an associated "struct page", =
with
a reference held to said page.  But for that same pfn, pfn_to_online_page()=
 could
return NULL, in which case KVM needs to put the reference it acquired via
gfn_to_pfn_prot().

