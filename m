Return-Path: <kvm+bounces-47823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1800AAC5AF4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 21:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BF163B7918
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 19:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A9D1EB5E1;
	Tue, 27 May 2025 19:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cO7/wLco"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28591D6DDD
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375387; cv=none; b=bhpgPIchysZB4EPDxoEiadeEC7qdCz89RQzkea868VwcCmUHMyU0QC5c2mHs43mmkH65OP6d4A5QCm6PduSqd+KHAxDwEIq1GBu9uFU8bbaYVB6RhNQEkieJwjQ8f5+H9QG/wUAy0rI+UDeASvlqKiOKaIWh7pKVr6MZ16OJgh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375387; c=relaxed/simple;
	bh=YsjX3bcN0YX2ehzopkrqwDQV5us4P1djbal5yVeF0qQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p4uBrWN7IjXjRoUb3s+Ir6mDMqrAxEmqj+QV0oR74Enqf00FI2b6rubVBDDGdjw5VoJ48U5ZVjvUHYVoIagtNaK0j5vQusCSgoCyJ2+9kQfg8ysG/8ny86+YGsB/Fp9XcM9ZpoQkUtl1RYkEDn3FENxUGsqmYHRzot+/dkxcguY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cO7/wLco; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7425efba1a3so175373b3a.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 12:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748375385; x=1748980185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPRm7zOCQTnMDLJxSagbT3wHkG31wqIoLSG9SxZ+g6s=;
        b=cO7/wLco0fLbsCtXyYw3EFSabt4a2p4X4HnucwapFr/4+s55MhT9t0E6TMpwj+JA4x
         Lx+CIIIz8vKq3E/F5lfXckK0ns40JEYXemxfi/3v86KFJs8GhT8BsqxbTIZAb6hfP7MQ
         V3co+gcptyQG+YIRkg1fGDAHkiawxrZ80VLWo+H9sq9u2QBTlE4NSNwZrFvre7u6yuyS
         kV5VtlsNiXnILE7TFL1sQ2CVP341gQ7Sn5d8mKNbtVfrCajyDw4wphE6M7Rt3hDguqOM
         /nmr8ZihuBaNLJmOFBpILiqe0nexMydxbJKJ/hclLxLohN5H7JpX0rJobJsblpw7eG8B
         Fbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748375385; x=1748980185;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HPRm7zOCQTnMDLJxSagbT3wHkG31wqIoLSG9SxZ+g6s=;
        b=NqbSpS+dl1DAcVvGFh8JuXdQ0rVjRM/yrfZ+p1PzDxklDuJZeTih2u4qjDZTwVPfSD
         G/ligmo9xGFuLAj0OfBX7F02Qgn2OdqnukwMa/6vH6flyViV1Dg4/TFOTabx2tjPnS6X
         ek6+OTGvYnCMxfCEvvVgUnly1VRMWycV1T4NHb2qKmX6R/+mULEr+IveiduJEQbyA54Y
         7b/8iOLiAk3KdcC5zhnx2V201uVVZbiHFQK+II5WIrGdn9DTKl7fiXY/jHRUFboqOLHK
         nDSIroHUg0F081NBhBS0IaH5lqE7FSYnVdQRTijU7gybgc6bPp8s0hH+DanrE1CVsnNT
         3YOA==
X-Forwarded-Encrypted: i=1; AJvYcCXzBnjLesxgwZiMQ9begdOLJAHXDbB3wi/k0S6ezsV+PAhvL814+qNlaOV8gDzCGlZxmL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzluHL4v2OkRrs+J0YVcEwSIhyOc8rZ6dVEYlBGiqxU94ATEV3Q
	SqFe0nyjO/aq662RD4UEbdOOqjWtiotpHyDXqP9nQa28nLUAIgCZg7m9fODsr7a55ZzGGDme9p/
	kEWa8IQ==
X-Google-Smtp-Source: AGHT+IGcUWh7R9GA5AW9ML6xvAg5vcChqjH5j+QDAMi4jmlbY7oLuIno/JLIYnsTk/045OLRIxyTzY7wmxY=
X-Received: from pfch8.prod.google.com ([2002:a05:6a00:1708:b0:746:247f:7384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:929a:b0:736:4e14:8ec5
 with SMTP id d2e1a72fcca58-7462eba4eb5mr2608237b3a.11.1748375385010; Tue, 27
 May 2025 12:49:45 -0700 (PDT)
Date: Tue, 27 May 2025 12:49:43 -0700
In-Reply-To: <dc0fd831ac82f313ce9bf8bc3180b7beef565821.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250526204523.562665-1-pbonzini@redhat.com> <aDXEG5tXRfsSO0Hf@google.com>
 <dc0fd831ac82f313ce9bf8bc3180b7beef565821.camel@intel.com>
Message-ID: <aDYXV-sggmWmaUyJ@google.com>
Subject: Re: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lkp <lkp@intel.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-05-27 at 13:54 +0000, Sean Christopherson wrote:
> > The "standard" kernel way of handling this it to mark the offending hel=
per
> > __always_inline, i.e. tag tdx_tdvpr_pa() __always_inline.
> >=20
>=20
> It looks like __flatten was added after a very similar situation:
> https://lore.kernel.org/lkml/CAK8P3a2ZWfNeXKSm8K_SUhhwkor17jFo3xApLXjzfPq=
X0eUDUA@mail.gmail.com/#t
>=20
> Since flatten gives the inline decision to the caller instead of the call=
ee,
> clang could have the option to keep a non-inline version of tdx_tdvpr_pa(=
) for
> whatever reasoning it has. The non-standard behavior around recursive inl=
ining
> is unfortunate, but we don't need it here.
>=20
> The downside is that we would not learn if some code changed in page_to_p=
hys()
> and we ended up pulling in some big piece of code for the recursive behav=
ior.

It's not just recursive behavior, it's any new code that comes along.  It's=
 not
likely to happen in this scenario, but in general it's not at all uncommon =
for a
noinstr function to gain new code.
=20
It's also quite weird to "flatten" a function with an explicit call to asse=
mbly.

> Overall I like the flatten version, but this works too:

I'm not a fan of "flatten", IMO it's too big of a hammer for general use.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 5699dfe500d9..371b4423a639 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1501,7 +1501,7 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
>         return page_to_phys(td->tdr_page);
>  }
> =20
> -static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
> +static __always_inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
>  {
>         return page_to_phys(td->tdvpr_page);
>  }
>=20
>=20
> > =C2=A0 Ditto for tdx_tdr_pa().
> > Especially since they're already "inline".
>=20
> I don't see why tdx_tdr_pa() is required to be inlined. Why force the com=
piler?

Because tagging a local static function with "inline" is pointless, and loo=
ks
weird next a similar __always_inline version.  Either drop the "inline" or =
make
it __always_inline.  Modern compilers don't need an "inline" hint for somet=
hing
like this (or pretty much anything).

