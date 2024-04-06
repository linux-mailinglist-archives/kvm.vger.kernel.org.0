Return-Path: <kvm+bounces-13790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED1F89A96A
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 08:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 590462832E6
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53862209B;
	Sat,  6 Apr 2024 06:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M743mml2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA38816;
	Sat,  6 Apr 2024 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385685; cv=none; b=uJ9De60DV2N7Vb/H8xNX9m8OJdzSG2UnTUhJwDD7VPl4reh2UW2yBfTXfchsgQeN9Xe5JjwOSrEpQVY9ZpjioIa1LmikBqRUvBdfjib/R89qJHoAxKJsszNtBOpvFedhWWHBiVpApZNS30vTGoVvt86V5BQxBoqBiapSwUmyyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385685; c=relaxed/simple;
	bh=Y4myA46EG/4i4dFaAu7Ev5ZT2oGDovwCLjemmigFZOI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=u7KZuW5zNXeHX9Ufz8Tv1GQ6KJ3b7QSnkfWhQedMlL8fWRNonGe4CVn7Rzu5Zw2aPMPmL+dArF7/VyhQyCPPppciwvAvpzUnZRPlQBdQzkXkg2RHolMn3f0gXETiKQ9X1qknd8ZHWWTvxse6fenJ6fFu8491e206WeJnBAArHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M743mml2; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2a3095907ffso1099493a91.0;
        Fri, 05 Apr 2024 23:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385683; x=1712990483; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOBsUw970qmuGR/nEFMV7OyuXkGlmB6mY4yq9LvFZhQ=;
        b=M743mml2D5JBRoONqXniUksUQ8fqAsfthbdjx8ISuS0uM2WciNML5PzpPooUdiPViD
         bMjdiVc68Rs3YFk2p/Z1VXViHPcbH8hpn9qWOCYNrPxsoF7bNEC/XrlvHJxvT2UaeQzD
         lB9dxozAzY4qwDY/nt7JNby9dTY9gggq4TpF0xYAxSmh3okOKS2WCRWBFlIyGbIWRTu2
         0qR7JEYUnEf+EffQRT4UwCQwvYOxhh+sY3zzrjLh6RWHneZU3lxbhc4eT+Q5qRB5ePnM
         3d7F0pTGR+FWWAmVi+B9i9gd16onHPszqNkr5DVEo4MHtI+tM2FjG1ZUP5vWNhHy4puZ
         6wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385683; x=1712990483;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HOBsUw970qmuGR/nEFMV7OyuXkGlmB6mY4yq9LvFZhQ=;
        b=nZn1cuCzZNFWn5Hk1M3dfVPcnTcU6+Ab8C9zQUUA0EoDJ0AJ9KqZrmjKgSP4sg460l
         Cdr0lu/f7eqOGy5MelEEt1h8VrUenzSDfN2GvZhNYLf9oYbDkq5PA+5k8vGL2L7rVNr3
         1Q83qboywAsH6XRzc9bvnj6BpRMWStlVBNNR8qJOIsCoGvyY7jDOGMpbXLf8vnQR+dLf
         VA6ApFtRiV6JH5qwffQJ+yjRoChKhevoUp1Huxl1OAhJHAfnQ9NR9PbBW01gGYaB+OaS
         GOHYLCY53izxY9ohtlmI9BDppO43683GaFS6Oh5Mu6i4Yzql/ff8nPfQKF5rFpfjv/EJ
         pJJA==
X-Forwarded-Encrypted: i=1; AJvYcCWLxU+ATC7aIwM8qPavFouFJu32ihg7NTM2zGsmMTPUB/dXVVe1sYbOdBvjvcqE6hDTX+ASMR+nSsd49oJK6i/WZZfKF5+T2CN3EUzysjvZtzZSdv3I48vwr/ma/alX9A==
X-Gm-Message-State: AOJu0Yym51yVeV61XmhO7lFP1o/UzVfZp5U5qLkbpZanREFpFx4m4YuC
	I7rT8eqZNtFbO3KvNTdKbIKZ0Bc+P5Xl/V0TWhkrj8yXSPDkAglR
X-Google-Smtp-Source: AGHT+IECgMT1sUsB4ORarMAQ68oanRLeoWItfNujPbS4ONFWnZwwkfklDBXxjBwIn7/t2lERNjsJuA==
X-Received: by 2002:a17:90b:1890:b0:2a2:a7be:3b5c with SMTP id mn16-20020a17090b189000b002a2a7be3b5cmr3049173pjb.6.1712385682917;
        Fri, 05 Apr 2024 23:41:22 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nh1-20020a17090b364100b002a076b6cc69sm2560825pjb.23.2024.04.05.23.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:41:12 +1000
Message-Id: <D0CU26801BXH.1ZO7Z28QAJ0V1@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 07/17] shellcheck: Fix SC2235
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-8-npiggin@gmail.com>
 <20240405-a578a48a6cad5c42abe5943c@orel>
In-Reply-To: <20240405-a578a48a6cad5c42abe5943c@orel>

On Sat Apr 6, 2024 at 12:24 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:39PM +1000, Nicholas Piggin wrote:
> >   SC2235 (style): Use { ..; } instead of (..) to avoid subshell
> >   overhead.
> >=20
> > No bug identified. Overhead is pretty irrelevant.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/arch-run.bash | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index ae4b06679..d1edd1d69 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -580,15 +580,15 @@ kvm_available ()
> >  		return 1
> > =20
> >  	[ "$HOST" =3D "$ARCH_NAME" ] ||
> > -		( [ "$HOST" =3D aarch64 ] && [ "$ARCH" =3D arm ] ) ||
> > -		( [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] )
> > +		{ [ "$HOST" =3D aarch64 ] && [ "$ARCH" =3D arm ] ; } ||
> > +		{ [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] ; }
> >  }
> > =20
> >  hvf_available ()
> >  {
> >  	[ "$(sysctl -n kern.hv_support 2>/dev/null)" =3D "1" ] || return 1
> >  	[ "$HOST" =3D "$ARCH_NAME" ] ||
> > -		( [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] )
> > +		{ [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] ; }
> >  }
>
> This one is a bit ugly. Most developers are used to seeing expressions
> like
>
>   a || (b && c)
>
> not=20
>
>  a || { b && c ; }
>
> I'm inclined to add SC2235 to the ignore list...

I'm sure it's a good warning for bash scripts that do a lot of
computation and have these in hot loops. But I _think_ none of
our scripts are like that so I would be okay with disabling
the warning. I'll do that unless someone disagrees.

Thanks,
Nick

