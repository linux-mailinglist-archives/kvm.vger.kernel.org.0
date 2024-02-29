Return-Path: <kvm+bounces-10350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B45586BFA7
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:53:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35D212853BC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43257381D1;
	Thu, 29 Feb 2024 03:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfeQ9d5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0C2376E0
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 03:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709178774; cv=none; b=Qyz9a9p/N/kgJkCw2FHAvWwppq3Dprt88Vtlf8zpv+WGMrkPvqxXyzhfrPX5vWA+7rMQrBVgcD9Un2nCTOBxkqjCqekiimuDEgvSQ/Qav2OvCwjoVjSYyDU94QGBm+DFt5YSVrpbBy5wsqqYQ1e9KCZMyXeQayCALyvV7YMr6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709178774; c=relaxed/simple;
	bh=iYs1GVx/6fOEeuOXek63hSPWzoQFoDaetlc7ATYkEX0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=X2AZW5pC3lrFOiW1OJJdOh5M729qzWO6tWMcAGm+vmZ2VIt9k51EU7TLM0mBGcE8o+yzubEVN/apW65CP63MiwEisuDowXN7NJf/FJ5Uv2aKSPncmDlCYkBiUjx7tVy3kljwik4plwpHS2omIOYE5WKZecyWa5oM3Z2X1cqJNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfeQ9d5M; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-365aff1fa8dso2091435ab.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709178772; x=1709783572; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GE8HlfcNsFFEiu7txF0WkDnaFjS/axbXg3f2FUFn/bg=;
        b=LfeQ9d5MI7FjjTIWmmkbv5q2sNBAKc/3E7si48nO/ftgy1dcPCtNVeID0hhsqsCVCz
         C2eEoLvnyjZM6mqk/U7AgLhPwsSj36vxLYSHSzLV6Ju2aDueHWdxrhnBwp4JKDBOM4oy
         AdwnH0+X4ArFWYlWJsGXNGX0xS9uV97bl+e81T28jkAZxCczVZWjsAUHXauDozAIQAYi
         TVz3tlPUgHcaMgTWDM6ApI8A1Dlzy3J+GdTA3ymlbJqG4ZzhCEvDnn54IJosCYeu/fuZ
         HudW0uTVS3kwZRUax+wSa+rjht4cFbi1WBb069fRkIpdhYOH3seVFTYXFBfRIF1ZTrHq
         6nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709178772; x=1709783572;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GE8HlfcNsFFEiu7txF0WkDnaFjS/axbXg3f2FUFn/bg=;
        b=jA/NiALY+vUKFBXlfEIlvuRRxQeC2zhIKnqpKegMbYKFMLuXL0drCK+5DJs6ss9g4B
         0hH2ywugl2GNOe8XtZHuuiFNEfjCBT4YRvN3MS+egDUnoVSb4ORB9xC4uuq8/ADeDkkN
         mUhY9uG7yKr9KBRibusoYTv8lWlvlDfKSoa494RAho+vXiEjWvJ7vhy9UqHQcz5nNejm
         Fj+sM6q8s9DCTBv3JN/wgecWanb4Nsjt/jjPFEfoyh9kSTno6ao4aEEjQ6rRN8B/p15g
         Ssa5bvcF82kP1w6S4E2u5VOgGVVaAuiuONT7dljZRG4TvMyX1TU30qV7PWp1xA+ofS+z
         werA==
X-Forwarded-Encrypted: i=1; AJvYcCUIuWfDpi2RMHfiKaPwBgsU/yw/h/bdu58vjy4p2FYnOP8CLy7oWc2m/S99oMfxkcqt8RW/RUygo99lxiLPk14RtCKp
X-Gm-Message-State: AOJu0YwxiYI29lClS5pM2uN/tP4AxgGNcL3Au4ccLuDKeweOcTQRtdlq
	0TjM3V4J587xnDyjGWhhcVFixNnRXEV9ZZ+cXgGRxuaVco4F9TGG
X-Google-Smtp-Source: AGHT+IF2sCHOGIDu81WosmY/mHd2F1QEFCJeLxZ9sG77D1aTATrp5oOMhRYDapBFD1jxZ9C3lI9ZfQ==
X-Received: by 2002:a92:c684:0:b0:365:1dd9:ee6b with SMTP id o4-20020a92c684000000b003651dd9ee6bmr1394815ilg.25.1709178772085;
        Wed, 28 Feb 2024 19:52:52 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902c38500b001dc78455383sm236299plg.223.2024.02.28.19.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:52:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:52:46 +1000
Message-Id: <CZH9B1R365G4.2Z2OICA7Z7OY9@wheely>
Cc: "Thomas Huth" <thuth@redhat.com>, "Laurent Vivier" <lvivier@redhat.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Joel Stanley" <joel@jms.id.au>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 09/32] scripts: allow machine option to
 be specified in unittests.cfg
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-10-npiggin@gmail.com>
 <20240228-386d106a6ef0bc0430edad1a@orel>
In-Reply-To: <20240228-386d106a6ef0bc0430edad1a@orel>

On Wed Feb 28, 2024 at 9:47 PM AEST, Andrew Jones wrote:
> On Mon, Feb 26, 2024 at 08:11:55PM +1000, Nicholas Piggin wrote:
> > This allows different machines with different requirements to be
> > supported by run_tests.sh, similarly to how different accelerators
> > are handled.
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/common.bash  |  8 ++++++--
> >  scripts/runtime.bash | 16 ++++++++++++----
> >  2 files changed, 18 insertions(+), 6 deletions(-)
>
> Please also update the unittests.cfg documentation.

Yeah good catch, I will do.

> Currently that
> documentation lives in the header of each unittests.cfg file, but
> we could maybe change each file to have a single line which points
> at a single document.

I'll take a look and do something if it's simple enough,
otherwise I'll just update the unittests.cfg.

Thanks,
Nick

