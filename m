Return-Path: <kvm+bounces-47891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E3DAC6D81
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC4134E2EC9
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0008128C867;
	Wed, 28 May 2025 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTP6sStv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9652C28C011
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448510; cv=none; b=YD0w7FO960JQN4avh7zsdSyP+UA97bbuEBPN4bXkLZKt5kCJt2gexivGTgOYZfjJEDLal31Bh8r8ytig9GTS4mSNut6CrMxo+eIg9RNbEb7fSdThzsTZU4Sgx0LSEU2gZ2oat4jhtYiXMfKGxBaQYKev6/Fs3CPtVDRUPElX3qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448510; c=relaxed/simple;
	bh=LibnRIxltzpbANK+z/ZCNtTGSZsFrtMBHyUPR93lW28=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZaAfV1OTAu1hQmyQI2BhwFRoHF21fYoT4f//JCx33En1Up744HVVqnPAmdvHSfJb8i4fGTKPbS3LgzguMgmvvDrXswPIo8YR9ZZacuOYAiGYnkAJ92QvXWxc2TcmCBuWfTVixoie0YWPjCzPgSkfphOZ11GZ/qnCRRlPLdJ4Oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTP6sStv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748448507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELCjKD+gxUuR3aRJg9A9JbOeDRYY9q3dgElqJB30ab4=;
	b=DTP6sStvhnHjYESwgyTmF0GG2suoJ3+RMxOQTNERnl+bzK/BONvH4ML3HpR7zqu4b//hBx
	zTmYt095F80Ywm+X7wjc7dnjJpssjlgmzjxCIKPSLNY/a9dHs2SQUDBxW2w2MuihwzATSD
	rlVx9I046oTc+bGKVqmpa0OHWW0Z5eg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-h2QocfjOMWaOdEvQjPydwg-1; Wed, 28 May 2025 12:08:26 -0400
X-MC-Unique: h2QocfjOMWaOdEvQjPydwg-1
X-Mimecast-MFC-AGG-ID: h2QocfjOMWaOdEvQjPydwg_1748448506
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c5f876bfe0so756570585a.3
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 09:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748448505; x=1749053305;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ELCjKD+gxUuR3aRJg9A9JbOeDRYY9q3dgElqJB30ab4=;
        b=te+6DApL7wrV1gpDyC/aSDVKdzEksY50K1xmznji0FJ5Lz8VZH/8H4kY7ZhyKDhNIR
         0nVQ0PhNhItJyRqa4eWeeXYLvIRcw4sIfhzEPWc5mp9snFoi7wwxcHsFRJShl6S8Q+l4
         kRTbaN1HdeT5EUYcu5hZyBbCzOV4zswC8TIv0isZwRfuajTwpa693pvFL2xCN8o5/sYL
         vJYnL2o7oRXBaSnKpObHeRchVXTJ6vHoBsU8vaZfYA2uv2uIg36iv8i/J3ILB93hFfEE
         9Z7Wll07ODCVMCtXYvYr5NAQ5HTLLADT2BQ3JvBJFe5bbP0ESRtsF22VPdTl2+UemQ4H
         Lvjw==
X-Forwarded-Encrypted: i=1; AJvYcCUH1ck2Y7m7kNo5HzDNRaK2ogtMT9u9JXSf+1xi0n+belyapulGXqru9yQNQJWvHBOL4Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAK4N103D4cFCAd+pbp1pvb9YXgwV/g5jR9XuAFC4h1BKlVJHB
	KFpSdVUVr6nTs7jvSBGp0EADjR7PDZTPcsPqTp9B3KM5tCuwFEsuZyIe2XW54uVGtFlmYMw+DHJ
	wugIuNl0Cw/907qouNZ1M7XwX1Tm31ETHJCdD+qrID67KpbD1JqXfgA==
X-Gm-Gg: ASbGncuhw93qbZY7o7t3CSffFICwfYGs3mHlymIP2a6hR/NyfgNJgtC7pys0Tx6pFih
	IZFBb1PzGRm0CE6IoAEZXPrzg/8Aa1fnyi6UQmaPcY3tsWp2ikngoqk0dnsnT1NxdpD6q0NYtIn
	bAeOe6OpW6j4DHX/mGHMhlEjpMk2mQ3Q2DRNZ7H1VQRfko1w0P1QZnxWKnOHRauaHH9muCB0YWX
	MszCSncb3/zKSNgRcOauNT1JHMbbw5v1c74PsE7xIZmQ+i/+TyUbgMtOM2A8V0/y4iWCRvdQGcL
	qAysrVOynu5u+jglZ9+Bjw2EVOhDmugzMh1+Yo8rJYiPbhTkjJ3bFvxxZ6s=
X-Received: by 2002:a05:620a:424d:b0:7c5:962b:e87c with SMTP id af79cd13be357-7ceecc296f9mr2823529485a.44.1748448505401;
        Wed, 28 May 2025 09:08:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwBg64uo0z4Bgibxmg+9R08YonGSy0ylNwRuFxVQIAkQT9OnjwXxcnU1GDcfo/I0jNy+NrwQ==
X-Received: by 2002:a05:620a:424d:b0:7c5:962b:e87c with SMTP id af79cd13be357-7ceecc296f9mr2823520385a.44.1748448504590;
        Wed, 28 May 2025 09:08:24 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cfb8210270sm87017585a.31.2025.05.28.09.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 09:08:24 -0700 (PDT)
Message-ID: <fadc8e044c3b18984b0ca4a88ef214feb779034d.camel@redhat.com>
Subject: Re: [PATCH] rust: add helper for mutex_trylock
From: mlevitsk@redhat.com
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, Stephen Rothwell
	 <sfr@canb.auug.org.au>
Date: Wed, 28 May 2025 12:08:23 -0400
In-Reply-To: <20250528083431.1875345-1-pbonzini@redhat.com>
References: <20250528083431.1875345-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-05-28 at 10:34 +0200, Paolo Bonzini wrote:
> After commit c5b6ababd21a ("locking/mutex: implement mutex_trylock_nested=
",
> currently in the KVM tree) mutex_trylock() will be a macro when lockdep i=
s
> enabled.=C2=A0 Rust therefore needs the corresponding helper.=C2=A0 Just =
add it and
> the rust/bindings/bindings_helpers_generated.rs Makefile rules will do
> their thing.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


Hi,
Sorry for that.=C2=A0

Next time I'll check rust bindings as well, I never had to deal with them b=
efore.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> ---
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Ok to apply to the KVM tree?
>=20
> =C2=A0rust/helpers/mutex.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 =
5 +++++
> =C2=A01 files changed, 5 insertions(+)
>=20
> diff a/rust/helpers/mutex.c b/rust/helpers/mutex.c
> index 06575553eda5,06575553eda5..9ab29104bee1
> --- a/rust/helpers/mutex.c
> +++ b/rust/helpers/mutex.c
> @@ -7,6 +7,11 @@ void rust_helper_mutex_lock(struct mute
> =C2=A0	mutex_lock(lock);
> =C2=A0}
> =C2=A0
> +int rust_helper_mutex_trylock(struct mutex *lock)
> +{
> +	return mutex_trylock(lock);
> +}
> +
> =C2=A0void rust_helper___mutex_init(struct mutex *mutex, const char *name=
,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct lock_class_key *key)
> =C2=A0{
>=20
>=20


