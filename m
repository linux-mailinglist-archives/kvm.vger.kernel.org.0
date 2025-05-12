Return-Path: <kvm+bounces-46186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36382AB3BEB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7ECD863208
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA371E1E00;
	Mon, 12 May 2025 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bf6jcUby"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F882356C3
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063356; cv=none; b=OCp5Ph1uigkjB0A8upWFqekvqCUsGFrIZ7ND5z8n+HlsDMBTy93Q21el6FJyyPJmSCq9asPTAVcgKs9vsm8KCjfUvA7jPha+xmFbDWgb3fkK+MyqEQyw7L28aYJLFgm59HEJ+mJQMXwL38hYSzji6ZWZVOKGBZ1Sia1Nkm7QF9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063356; c=relaxed/simple;
	bh=ZLutuZ31sDh170vy+Jlj34Ncf3BEZ+c9dIbvFrsjNGk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNQDIsDpX+sz1aVIfMcXt+IUMC1X3jNT342gs5pj5jhfKUGdyZR5BZJQlO9n+oodRMMwwWY9CqeeHuAv5IKsGhOi8XyPq9iF8RWrWE2B2HqYRbq4zlmZN55cOVax28kGmhLGu2iMXKuWusK1rXgpUlTewuIeMyIcvMO4c3WmmP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bf6jcUby; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747063353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fDbveoy634fX30HQGWyRUGP5YagE3FENcZZx4UjSE4=;
	b=Bf6jcUby7njrVX8s/a01LBYJ9k/WsQZHoCAyFPBt5DBT0Ar2uBS6oRCkCILQF5DZTzetPy
	dE86pgwQdOQ0bnO13EqMMPJ6WiHXNBs8m2C6UHtYS+weFeQdwmiW2BjkQeg+lOHjR1ic/f
	z5tZDyFlzn3+sWDMcA8sG2Vivqc8RZw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-t4jirGzFP6CU6h-SC-csSQ-1; Mon, 12 May 2025 11:22:32 -0400
X-MC-Unique: t4jirGzFP6CU6h-SC-csSQ-1
X-Mimecast-MFC-AGG-ID: t4jirGzFP6CU6h-SC-csSQ_1747063351
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43f251dc364so28142655e9.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 08:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747063351; x=1747668151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fDbveoy634fX30HQGWyRUGP5YagE3FENcZZx4UjSE4=;
        b=ig3K49nX8JPPA8vPVBf/+2BdVktznCCF9z+IdnaV6RtijES6AUv1iHqAgj/uEbBJvE
         9ehwH4jN4wgmDBAA8+iWDyVPjywLJXBA3fxiRFPRJ2iXrFHciuRBfyyrEQ3hUTh2J6xc
         KYA3/OXRiCMr7B5ZzxBi+VhonqWUWae0NcE1ydXbcwoeIQs1uQw2X3pF2LAvxGNeOyRi
         4ca2UO6f3XJxvmLorLL22ReenPpbb3N0qj0s+4VR1tYUUKMAGmCQzW0t8w5rG2OXUnnI
         vseKQdFPC1GF3jttlyw/RcIHrYBhMfNXMDO1Sk90N7SgI5NgZMBY0McuaroHYbK1SVDR
         dfRg==
X-Forwarded-Encrypted: i=1; AJvYcCW8ksdUknRN8HlD2c69XCj7NBTxrGWK6lcO4FDSHdflyknVNRZ5AnGUVyY8Nm+UVTJgjUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZLh9O/f9K6Mu4KOpZAaMl2jM/IcN8jus+zTLU40HASnTuoFj
	uzT0tN6pHgMN/hlXLOmL7DglArZHawGVYudDkbfR9pGZzKDUfB+w9wJubNMpjx9hvBMHoZV0F3z
	MMMTlIvGvBgMf+1UsA+G0TVQix0qPlLpapOv9jEvtWaN1j1lnNw==
X-Gm-Gg: ASbGncsKBQG8A+XrQ3mM2z1Lo6Z6JmU+AvPikTG5K4H87nIPcWTkSZf+Z3kb2hAZ+5g
	sM81LTmSR3DCx/fHOxd46uDbVNu4RGCRZMBrRGXNMic6/ufPDQFt2l2GXfb9r266qhAsc7qyBTm
	TkX4H8LlmFA8LOn3wXri0HHWJX3yqsqClEs7w8a2AV9ADxBzTBZ+I7lebALckjWI6XABnP4+FOx
	P26hpQ0SMNHNcbaThKrz+OLMAShZteZrs5SReFSQtXsXehTv/Bdzol9FFpB1ZevHGyjVrH29cJ0
	zxQH7eDYhmUWVPK0SQ/GiLsc/Oi2yBOZ
X-Received: by 2002:a5d:64cb:0:b0:3a2:56f:e931 with SMTP id ffacd0b85a97d-3a2056fea7bmr4650568f8f.19.1747063351042;
        Mon, 12 May 2025 08:22:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpfuYUF3ZtquPfDbtUbsIXdvtVrYdxS4GjvinNAdEoeVjZYWPtRk7OTMzvGsodv9XiY0XPiA==
X-Received: by 2002:a5d:64cb:0:b0:3a2:56f:e931 with SMTP id ffacd0b85a97d-3a2056fea7bmr4650532f8f.19.1747063350573;
        Mon, 12 May 2025 08:22:30 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67ed1bcsm127891875e9.18.2025.05.12.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 08:22:30 -0700 (PDT)
Date: Mon, 12 May 2025 17:22:26 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, Zhao
 Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Philippe
 =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, qemu-devel@nongnu.org, Richard Henderson
 <richard.henderson@linaro.org>, kvm@vger.kernel.org, Gerd Hoffmann
 <kraxel@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Alistair Francis
 <alistair.francis@wdc.com>, Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-riscv@nongnu.org, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>, qemu-arm@nongnu.org, =?UTF-8?B?TWFy?=
 =?UTF-8?B?Yy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
Message-ID: <20250512172226.433900f8@imammedo.users.ipa.redhat.com>
In-Reply-To: <87jz6mqeu5.fsf@pond.sub.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-13-philmd@linaro.org>
	<23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com>
	<aB2vjuT07EuO6JSQ@intel.com>
	<2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
	<CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
	<aCG6MuDLrQpoTqpg@redhat.com>
	<87jz6mqeu5.fsf@pond.sub.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 May 2025 12:54:26 +0200
Markus Armbruster <armbru@redhat.com> wrote:

> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>=20
> > On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote: =20
> >> On Fri, 9 May 2025 at 11:04, Thomas Huth <thuth@redhat.com> wrote: =20
> >> > Thanks for your clarifications, Zhao! But I think this shows again t=
he
> >> > problem that we have hit a couple of times in the past already: Prop=
erties
> >> > are currently used for both, config knobs for the users and internal
> >> > switches for configuration of the machine. We lack a proper way to s=
ay "this
> >> > property is usable for the user" and "this property is meant for int=
ernal
> >> > configuration only".
> >> >
> >> > I wonder whether we could maybe come up with a naming scheme to bett=
er
> >> > distinguish the two sets, e.g. by using a prefix similar to the "x-"=
 prefix
> >> > for experimental properties? We could e.g. say that all properties s=
tarting
> >> > with a "q-" are meant for QEMU-internal configuration only or someth=
ing
> >> > similar (and maybe even hide those from the default help output when=
 running
> >> > "-device xyz,help" ?)? Anybody any opinions or better ideas on this?=
 =20
> >>=20
> >> I think a q-prefix is potentially a bit clunky unless we also have
> >> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
> >> and have it auto-add the prefix, and to have the C APIs for
> >> setting properties search for both "foo" and "q-foo" so you
> >> don't have to write qdev_prop_set_bit(dev, "q-foo", ...). =20
>=20
> If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
> intent in the name useful?

While we are inventing a new API, I'd say that _INTERNAL_ is not the only t=
hing
on my wish-list wrt properties.
It would be also nice to know when a property is set by internal or externa=
l user
or if it still has default value.

Basically we are looking at different flags for properties and INERNAL being
one of them.

Maybe instead of specialized macro, we should have a more generic
   DEFINE_PROP_WITH_FLAGS_FOO(...,flags)
So we won't have to rewrite it again when we think of another flag to turn =
on/off.


=46rom previous uses of x- flag, some of such properties are created as
temporary | developer-only and occasionally as a crutch (still no intended =
for end user).
But then sometimes such properties get promoted to ABI with fat warnings
not to touch them. Having stable|unstable flag could help here without
need to rename property (and prevent breaking users who (ab)used it if we c=
are).


