Return-Path: <kvm+bounces-10849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D355D871371
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B3ED1F22E8C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFE618045;
	Tue,  5 Mar 2024 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3HrDaDi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443D1B80C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709604851; cv=none; b=SmE19wIgd/qBoSS4x9Q0miMUUZwIJBUuu8ctKT8Tcq1fDdSR3S+fkxs5vq18OEXB01v47DTy8znmFFSRz3IOnq10daisR6N9yHD3cDWT4iKdr7ITugL++yk0FOJr21W5yGsWZBm+8sVoSjl0BVVKAjIdak6tfu9LgXFJGWhSdJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709604851; c=relaxed/simple;
	bh=NGORBfQGakzTw2n5rZpNhCKaibGxdsY1OsEfYqfpgS8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=fGoRAbJjjAMDfyWVrnvKqYhBmXcmEqkvH/43JliiMMoaISv/FNag4gt/hkT01yysJwu3UBD2eFoaXG0f1Km7XCuwM0cGCpC3jNnt9x7pv05LcfV6AAwKcuGYQYY3rzooNa0XwT8VQ0GruvUpW4Vqq6TZZhSEaB8UtIGIv7JPG60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3HrDaDi; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d7232dcb3eso37754195ad.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709604849; x=1710209649; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIaItcpq60SwRZMvgghKHJmefoIzj4K3zJYvKv5MwnU=;
        b=k3HrDaDiAt0KRIfLI3Ctw5RcAmOVu/rcNY3VanVfiIo8HcKyojMq+u/RQJn5T0qwel
         9mv4h3tv5QfRiNlsskSWSycIK+DnC38Iz3OBLfQj+TFEnhFx68UjQzFBjJcq0rCAJohc
         tgFwnSpsNBb7QhvpyG+it+zfXMlcgGyg1dtdYXBbnKNHi+arrWeTgJtFI/C04Vhth30I
         HgErKm3PXBdH1WxyBy96PG+m/DaZHwCMkqI/gl8lgrWC2sjldI3L1IoJz67QOcvNicEM
         83YV1CzsSbyQNzobJqUWwQyTtK2LfOGEb0mOi6GVEV8b19c1rICtQ/MWKWdcRt54Z9uA
         p0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709604849; x=1710209649;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kIaItcpq60SwRZMvgghKHJmefoIzj4K3zJYvKv5MwnU=;
        b=OwBKYX0r07tpUghR2++ApjSPooMdWACp1s9PCqWQI7pf7CVHNy8diSlA5OfkPBq+3a
         s/nB0SPfvM5qYsNnYuK1gJohCW8xL0oZq8kon+gqWkS8FxOnzQoGEfjuY4TUNbLo2adI
         rO1FMwZ7LmO9moYGdwIdkuRE6WevFoUrQeV4Vt2/rUchxweGJkqW0qX77N8B/ZgPRRdm
         Nm8Eu81Vnlq3T0QD3yGZs9jX7+AWp6g2Qoq49zB+33i2h+agwdXmjdE/Ddv7gLaFpvdb
         li93qzzFv/ke5cTneQrH89hQk4hGWOCJojAmRX1vM7dwFfDsuYDLtXxaL2MiDAij0gbt
         JQgA==
X-Forwarded-Encrypted: i=1; AJvYcCVE49KM7ac6aufCEoGo1bxQdpy/+vZ8rEgc8HMozbktPkVzmrmVXwCsDVxRsjmwEi/jgHhP4t4JPA4uG/UCuENV7ucH
X-Gm-Message-State: AOJu0YwGi0f7ATqfRqyxlrcEqf9vjaJL2t2e8UvLDHUgdLppKVDkeRbz
	drumwyIeO1zpPJ8yvkKteBFgSFk+dkGbAQdVc6HcWtng4Wy7xcAn
X-Google-Smtp-Source: AGHT+IG0V/GYWcPSWzwDoq0twoJCNiOyb5mCYu5x71ATX4Oxr438p6feAW+dsfRoTqy5fVI//PezDw==
X-Received: by 2002:a17:902:eec3:b0:1db:f389:2deb with SMTP id h3-20020a170902eec300b001dbf3892debmr511078plb.17.1709604849064;
        Mon, 04 Mar 2024 18:14:09 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id mq12-20020a170902fd4c00b001dc8f1e06eesm9213195plb.291.2024.03.04.18.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:14:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:14:03 +1000
Message-Id: <CZLGC6S6YUQU.3FJKWH2MQ0NO5@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 07/32] powerpc/sprs: Don't fail changed
 SPRs that are used by the test harness
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-8-npiggin@gmail.com>
 <04e976cc-0239-4ee9-b0d2-cfdebbc4c3d9@redhat.com>
In-Reply-To: <04e976cc-0239-4ee9-b0d2-cfdebbc4c3d9@redhat.com>

On Fri Mar 1, 2024 at 9:15 PM AEST, Thomas Huth wrote:
> On 26/02/2024 11.11, Nicholas Piggin wrote:
> > SPRs annotated with SPR_HARNESS can change between consecutive reads
> > because the test harness code has changed them. Avoid failing the
> > test in this case.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/sprs.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 8253ea971..44edd0d7b 100644
> > --- a/powerpc/sprs.c
> > +++ b/powerpc/sprs.c
> > @@ -563,7 +563,7 @@ int main(int argc, char **argv)
> >   			if (before[i] >> 32)
> >   				pass =3D false;
> >   		}
> > -		if (!(sprs[i].type & SPR_ASYNC) && (before[i] !=3D after[i]))
> > +		if (!(sprs[i].type & (SPR_HARNESS|SPR_ASYNC)) && (before[i] !=3D aft=
er[i]))
> >   			pass =3D false;
> >  =20
> >   		if (sprs[i].width =3D=3D 32 && !(before[i] >> 32) && !(after[i] >> =
32))
>
> I guess you could also squash this into the previous patch (to avoid=20
> problems with bisecting later?) ...

Yeah, I guess it doesn't make much sense to split out since lots of
other stuff changes in the previous patch too.

>
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks,
Nick

