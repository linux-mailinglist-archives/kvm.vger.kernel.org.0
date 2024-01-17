Return-Path: <kvm+bounces-6366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA8282FE20
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 258FAB222C7
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 00:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBD84404;
	Wed, 17 Jan 2024 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E64mj0od"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BFE1864;
	Wed, 17 Jan 2024 00:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453023; cv=none; b=kWf7Mphq2AwAg14/8O0mq7R+U8YjjLNgllCU53HCOChaMLNVp6Af7mwBP7voGTu20/ljn2pYzaisMsPBPR1ExQCjBchVP+L16xBWsjZKVPgBRVulGijwyNT6Gn4Sh38FN9ugjDC4Hn4mFOUyfJ/G7dlwfMZ/s50TnMXV1ntl46M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453023; c=relaxed/simple;
	bh=7UnTX34HgoTW8uGNTwh9hFEKB90kOA7xqoZPARdreAs=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=IXk3SPeE29CpdgYnVzmzo8CMwgn7MVnNnNE6uEcmNyLP78UwO4Y3zJl23rPEffHBb63KneqeK4JOeHFBdnoTPsvsKv7wUIezwtiUef5ExurfAIGtfysNy/6uZX0WGIni2T4vWqMTyGgu6kt9W+IdAyhGNEZHcFeJYH3JlW4ivy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E64mj0od; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-5ff45c65e60so16507697b3.0;
        Tue, 16 Jan 2024 16:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453020; x=1706057820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVfHRGPq7HAXiyMA7XV/TGLk0DnxIq01kbXRuv/O/ow=;
        b=E64mj0odq9ZBqTkTh8TQMf68Xyo6yDo7sVGvvmTCgTNQNtgVDEIfb3T7KuIaXEmAXd
         zdO9jAEqhb5eC2Qmx6QFBYT4IcW5/WhedTStI9KBA/KrDZvFd1rBfBMqm6Ncv6z/+769
         einTNwQKUCKoFSxahCzYjkAJbudM9AwNVNdoi1IV1KB5ovb2LVmlj3b4SUc3szxX8hmy
         ciCRBIvI1jAFHMVLlByy/tg/fbG/ADsEmEU+ADkkXsmt70zI8GVyf8ysI5zlNHimIGzk
         0EGbkWXeasqWt6eTRyUTKiDMTsts65w60agbmz77KdMpxjtJl6y97he1yi7xcGqcKvrt
         h8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453020; x=1706057820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVfHRGPq7HAXiyMA7XV/TGLk0DnxIq01kbXRuv/O/ow=;
        b=CFyURjkLnaeK2r/MPqRFquQrRj9iR4p3/ER7bDEiktdNDzJh1ijm6zvwcr6IoE8h0o
         Ofyn6ONUOjrnNpNTfUpAjnyYRaYGZL5qB6DKYPHXJ6HAMNrMoyz+QJcZNxao2z1IuhC9
         XC7GdRZXHnrsBRruGZsFkGq6JF4x2+YgQ24FtaXyIAvrB/rvk0MT/lC3aUba4NfckkAN
         eA1CD01DCqcdrsDmfgqghr8/LDhWOfLWxZj1WxgXcdawnrOgkP5aOKyNzrnnylo8f76y
         vf4+q+z6GneMV4HkWnR9rKT2wl4qbsTV+H9fd5Id5UZtaMIt9+OkfFGbDzkN8PvFfRMl
         pLnQ==
X-Gm-Message-State: AOJu0YxFeKHZWghbxUG7+t2yFx8KwoabjwRHQGXcNhIDZBGx+Nj9yG59
	xVpFJGPgyyENDzh+1QZWKOTNRFkA1gyvyvECKhc=
X-Google-Smtp-Source: AGHT+IGigEhBpdfQpWMLnXZuKaV0ImQrIyAxLwoEGhEwLq+Lx9fsG0/tSS2wEL2dcx7AgQau4oPFzlb0JKuXXrhP7q4=
X-Received: by 2002:a05:690c:fd5:b0:5f8:420e:468b with SMTP id
 dg21-20020a05690c0fd500b005f8420e468bmr5417368ywb.45.1705453020659; Tue, 16
 Jan 2024 16:57:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112091128.3868059-1-foxywang@tencent.com>
 <ZaFor2Lvdm4O2NWa@google.com> <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
 <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com> <Zaa1omCaDQOxxy2j@google.com>
In-Reply-To: <Zaa1omCaDQOxxy2j@google.com>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 17 Jan 2024 08:56:49 +0800
Message-ID: <CAN35MuRKMW+-qrf0Sv-tsiZ71_-C_DJAMhu=HhtP8RnTVW-PsA@mail.gmail.com>
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
To: Sean Christopherson <seanjc@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 12:58=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Jan 16, 2024, Christian Borntraeger wrote:
> >
> >

....

> >
> > I would be fine with wasted memory.
>
> +1.  If we really, really want to avoid the negligible memory overhead, w=
e could
> pre-configure a static global table and directly use that as the dummy ta=
ble (and
> exempt it from being freed by free_irq_routing_table()).

Thanks for the suggestion! Well, in my opinion it may be better to fix
the current issue
and I'm glad to send another patch to optimize this.

> > The only question is does it have a functional impact or can we simply =
ignore
> > the dummy routing.
>
> Given the lack of sanity checks on kvm->irq_routing, I'm pretty sure the =
only way
> for there to be functional impact is if there's a latent NULL pointer der=
ef hiding
> somewhere.


--=20
---
Best wishes
Yi Wang

