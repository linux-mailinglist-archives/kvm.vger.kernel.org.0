Return-Path: <kvm+bounces-18605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE888D7D28
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422DF2827BE
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AE45A7A0;
	Mon,  3 Jun 2024 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwHNUQlA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101C5B68F
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717402677; cv=none; b=bf2wpxOo6kWUm/vJ26uVrIBJ4kjbuZRzhBObEHsl9MJ3EV5UCIrVT0rzFMZPLWR4MMNhthxJJ7Q+3ZNDsyqjCJ6SC9dp4Xsv3VgD8irwj9IE4jhS569klwIMPQc3ymrFSrQ3b5d4wbh3SsOubb8dEFSij5huZh7OcK+UN0ba5kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717402677; c=relaxed/simple;
	bh=lfkkvPTQjq9r+Q5lm7rlKMhY7ibjnTOtcw8D20xbEDg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=pBoNwewmiiMbOqs5jj/0Uw03Ezgaq0Jh2aRCEx1mXcjmWSkGfVZ4vR8nEEdq5wW80BXZqgHBA52VBRxIHc9S9SRQ1ZmDDhT54N8VOGWdPq3EE5zw1KR5hY+Rehjonu3MHemIZEarXLgEMITORXTsfTzM/kJWy6xCrNanmQS/X4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwHNUQlA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70255d5ddb8so1129188b3a.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 01:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717402675; x=1718007475; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6KHSvz0wAMB7eV+JSz+29l4e0PKn92WcnnxSBgKjT8=;
        b=hwHNUQlAR0uzXLS9UVgEo9HRXmgDo2EkWRlpZNQanPEMnraoDsPfw1bjKO4K1b1LBA
         6Unba3tJuCHVk0P876lK07Z6eYB/qIhzbm2OYp5BOrc5MQr7KVZhS/BZbE/4ZrtyFDvB
         rSTmwgz1+rgDBlbeao0OsDT0GybhVUeGttCvSfg/wXE9ir+MtICdoDjp7+Ze89JMO3qL
         bD9huaNgAClxxdLXZyyd3JjMbCvPqAwbdH5WPYaSsRz4cfguKQCw96Nm20TRx3Amf5pc
         OeVoyEr0febeFXrfK/LWcwhXZOWsDI6zYRG36bddo8Gwzmt9EwTw9CiRkbfQ2Kcq6Txi
         T42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717402675; x=1718007475;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x6KHSvz0wAMB7eV+JSz+29l4e0PKn92WcnnxSBgKjT8=;
        b=EOWDDIyYcQ8+NWsni+2fXiQLHKsh0z3qYaSEWDVyNda2cD9Gx9YsWrRTeqTLA0JlHZ
         x6xhO39Ju9+rSYExp1UqYwdafX6J3JzRH2SXh8iVmwyhBlvAEhURCoa+xJh009qtdH1c
         IPxuibuXkLAA9L5Y46OHW7tqSCtyMLxoIgyc+9vaKzPByiRO7TGTydZ+F5ZIRaYdVN9u
         Tlzyuilym/tvZ1tFASoKkN+ODVnDodluim8S5FMOfBvjyWX2gfHYgXI9ONj7UMPsqwk4
         wl4tKPPRrA92cb8PIbsD2OhGf6RNjcH6kdE+94pb9/DlbR60d29Dae4KatFZcAQOEVyZ
         /4ww==
X-Forwarded-Encrypted: i=1; AJvYcCWZiTP0wKIu2Xk0Z/59tcpLwv6XrSb9TNXTH5YmVZK2df87f8A9BwxmCAKL2hWx/AUTHktcOSRQbXpmcC2nXyr2vCzM
X-Gm-Message-State: AOJu0YwLe3XJcYbl1orfL9f7osAMTt6/2v5kX8uzHczD6NWWgDwOnnzo
	Yotg5xIonQV8E2/rxjecJ8g+DZxXWw6ldZSPgyJ04SRY4zLJNZbaMQop6A==
X-Google-Smtp-Source: AGHT+IH/iAEDtYueyaBmgQ2OL4NRGFESEKrtfFQZhf2/rw3mmH87zp+v4XXEC3Pr7PfonVfrcI7L3A==
X-Received: by 2002:a05:6a20:5616:b0:1ad:7ff5:cb38 with SMTP id adf61e73a8af0-1b26f30f254mr6729490637.60.1717402675185;
        Mon, 03 Jun 2024 01:17:55 -0700 (PDT)
Received: from localhost ([1.128.201.3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cb349sm5168519b3a.14.2024.06.03.01.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 01:17:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Jun 2024 18:17:50 +1000
Message-Id: <D1Q8FQUROKDG.3O77B66NIRKYY@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 4/4] gitlab-ci: Always save artifacts
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-5-npiggin@gmail.com>
 <5a2f4d2d-6e8e-4009-a9e3-e9f51cb8aa20@redhat.com>
In-Reply-To: <5a2f4d2d-6e8e-4009-a9e3-e9f51cb8aa20@redhat.com>

On Mon Jun 3, 2024 at 2:29 PM AEST, Thomas Huth wrote:
> On 02/06/2024 14.25, Nicholas Piggin wrote:
> > The unit test logs are important to have when a test fails so
> > mark these as always save.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   .gitlab-ci.yml | 5 +++++
> >   1 file changed, 5 insertions(+)
> >=20
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 23bb69e24..c58dcc46c 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -4,14 +4,19 @@ before_script:
> >    - dnf update -y
> >    - dnf install -y make python
> >  =20
> > +# Always save logs even for build failure, because the tests are actua=
lly
> > +# run as part of the test step (because there is little need for an
> > +# additional build step.

This wording is a bit scrambled too, I wrote it thinking CI was using
build step by default. It seems to be test so changing the words around
didn't work (also I'll fix the closing paren). I'll fix that up.

Thanks,
Nick

> >   .intree_template:
> >    artifacts:
> > +  when: always
> >     expire_in: 2 days
> >     paths:
> >      - logs
> >  =20
> >   .outoftree_template:
> >    artifacts:
> > +  when: always
> >     expire_in: 2 days
> >     paths:
> >      - build/logs
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>


