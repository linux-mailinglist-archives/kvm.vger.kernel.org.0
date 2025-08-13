Return-Path: <kvm+bounces-54559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FD0B23D04
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 02:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F8747A4FE8
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 00:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB582AE6A;
	Wed, 13 Aug 2025 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xd8Hu6nW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF4322E
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755044346; cv=none; b=WaUKl9jo7xuYc9RMmqZmtixIkxLmOEN5G5USDc58NbZAemSBegM2ZczmG9DBtHb4TNX/FY3AKotWf8Hn9DWG6UKj6sE8BWxSVXsQlqZk5fxMivjUMCP81xYl3W5UmzKK/ybxmnU5ifDoACPGxabme0vpnVSCPlbVSpgUi9oL1EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755044346; c=relaxed/simple;
	bh=pJARVKcCUedtd7CK1Bh6kczqQ9W8RfiKpPJ4TG6cCgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f8rM1lukeNzLGEWrA/Z5eKDDvSnSCiebpUo1kgLGNm+AY99rpW9tigCdIJFX02oQWYWgiM4YcdZbjc6CAut3CPp6jrqS0gwtssljaSifmzlFLloVgD+8zWwJDuKBuZ1d0Rl1wVJY4EJIFK28Jo7Ze9ozEwNUekwgxaQ8QO7HyQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xd8Hu6nW; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-242d3be5bdfso45055ad.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755044344; x=1755649144; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJARVKcCUedtd7CK1Bh6kczqQ9W8RfiKpPJ4TG6cCgw=;
        b=xd8Hu6nWCLo34JORiTBKIWAFeGm/w152yVe/4YVLQCjzWYurKvQQnBOBE7qDLyvJx0
         hXQi1ufKhjMQ3uwHgyVn+ePSkC3pYJwszwZgrLmhhVmal8FVy7CBzr4r0WeVipZ/RQNP
         OvWthzptVBj8PIelro96Z+Atk2Vuo3M228h2SdHhTP7ibzhVNvYLgtJ4I1wwLNxJk/MY
         H34DL/VDSXFBsgl1XdQiywYrVt1biAoMiIVa0JKUAoTIyuTYfk4Gq4z7RTjQbSujSiL+
         Mu+PO24Dw5N7K5SVX9yTs+trpxllFspMrKp5LQWFzO+kZc2In/NQ6Mwc5fXAGHW2pIvT
         q2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755044344; x=1755649144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJARVKcCUedtd7CK1Bh6kczqQ9W8RfiKpPJ4TG6cCgw=;
        b=lnHh5ECzR993aSCkcp2vB/ktQlJJ1dMTzjGP5VxmuQSuqJdAzWTHMq9RH3eAER1aoX
         a2RPnRZ2GXlbvqTMkXcKwubyBE3+YUT9SYAHlxgYfsTS3o9Qm2N5+MYn+LsEOLn1PWJr
         +CtTEGjLnDrM6cv5gXJs5NDhFkvrWDWSMjqsW4qqpsDZkQK3vKnFv2KcOsqptbgkNxWb
         oMxJOFLp2jOLpSRKYrR09v/gteELo9yGv+La9ZknVTbF8HwRt6dZhyyy4KYyWwSSc7Q5
         CFy+imnyDYlc269qYYy38ed8Xo7rpXH++/qr/cRuvETeKI0dTwMqiA7Vu3ipMjO09Ibk
         ABlw==
X-Forwarded-Encrypted: i=1; AJvYcCUp2pgcC+ACtSwL8+3VVZAWdUOQP0h4dCZOL7xvgFC6a0nU/kUkzbvNfFFLMfbB+JZY/mE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlco2IbEQrUpYIE087rnjQX799E+IzhFkaWmVavra/H69oMoSp
	fb3Z7d8ox7hP93vSROYxrOl9wZzFsk1Q9l1fEqNBxvWdO8LIscDEjaoHdd0TZdg1mjhWYFgDnQ2
	imkV+OuWKnfTlcYjA9GwRbzALlwgAGyUn3qKUijMt
X-Gm-Gg: ASbGncv2FW1ONrw4JsrX5ZiNzWMTM30nlneCAAXQwD8L6G0Rz1oG6kAun0M0K84Tvx7
	uF2JtKV+J1gENoTBnwc9Zxb3SRZ7dF10sgNHyOjnTSFlFall02Jtcok6OyPfUB6Xphfbny19x0w
	2Zr45eHcXxHlqY9VaczKb0ybYFJaFiosM+hCncOcgZWmMpOrQZRFRK1qfp4BhpM00M4QN4K7FXx
	UJ2GVoZm00TW8OEgRC4E3QuOAr9RtRfjUmx
X-Google-Smtp-Source: AGHT+IHJqyzxyBLp/fNRzX0VvbZ2PjM1nmN1yNpjsisZAXnj67rfBRkyV3HvdXc1eB5IXQBBQWe7gVaCUBi239OhCHs=
X-Received: by 2002:a17:903:2281:b0:23d:eb0f:f49 with SMTP id
 d9443c01a7336-2430d22e961mr1599265ad.14.1755044343461; Tue, 12 Aug 2025
 17:19:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com> <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
 <aJtolM_59M5xVxcY@google.com> <6b7f14617ff20e9cbb304cc4014280b8ba385c2a.camel@intel.com>
 <CAGtprH9x8vATTX612ZUf-wJmAbn+=LUTP-SOnkh-GTUHmW3T-w@mail.gmail.com> <b5ce9dfe7277fa976da5b762545ca213e649fcbc.camel@intel.com>
In-Reply-To: <b5ce9dfe7277fa976da5b762545ca213e649fcbc.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 12 Aug 2025 17:18:50 -0700
X-Gm-Features: Ac12FXxPSxg1yJOw-7Iewn9Frs8_mGpjq5ATxWJ9uJCejooYNNBU4ZpCUOOrKNY
Message-ID: <CAGtprH8Mdgf_nx4qEN3eqp4KqmrW9OvxYHHDJDV2xa7nmBnGbA@mail.gmail.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 4:35=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-08-12 at 15:00 -0700, Vishal Annapurve wrote:
> > IMO, tieing lifetime of guest_memfd folios with that of KVM ownership
> > beyond the memslot lifetime is leaking more state into guest_memfd
> > than needed. e.g. This will prevent usecases where guest_memfd needs
> > to be reused while handling reboot of a confidential VM [1].
>
> How does it prevent this? If you really want to re-use guest memory in a =
fast
> way then I think you would want the DPAMT to remain in place actually. It=
 sounds
> like an argument to trigger the add/remove from guestmemfd actually.

With the reboot usecase, a new VM may start with it's own new HKID so
I don't think we can preserve any state that's specific to the
previous instance. We can only reduce the amount of state to be
maintained in SEPTs/DPAMTs by using hugepages wherever possible.

>
> But I really question with all the work to rebuild S-EPT, and if you prop=
ose
> DPAMT too, how much work is really gained by not needing to reallocate hu=
getlbfs
> pages. Do you see how it could be surprising? I'm currently assuming ther=
e is
> some missing context.

I would not limit the reboot usecase to just hugepage backing
scenario. guest_memfd folios (and ideally the guest_memfd files
themselves) simply should be reusable outside the VM lifecycle
irrespective of whether it's used to back CoCo VMs or not.

