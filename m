Return-Path: <kvm+bounces-22497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C78C993F4A2
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7CC2813FA
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3413F14659B;
	Mon, 29 Jul 2024 11:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y71S7jnf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B4C146015
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722254100; cv=none; b=Z4ggTEoXRWILgdiys74n/6ILUKIGKgr336s27JZRNY5uiudVD9hJHwFaSMAtTq2lY4468BxUnqtK5U16PrRO66p1TXOeLKyrcYYGmDxIQ6PZ192XO+VGqkNQh6BnB5D9mFOzJnMEdxZncu0AsRfMsFCa+VnfFyhqyMxI7G+mkpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722254100; c=relaxed/simple;
	bh=7eldeZkEgm0otGTT3gjl279nF2ADl7Z7G+t6q2HR/CA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d1FGmTccI3bwZ/PkBhF1pupbiIP/CMJ8hlpMC/gUDkWPXfxNYlPl9zam58+yCD/HlmQ1NlUIPLPvDhoy9Gz1FYxbeKZ1am2Qn5YuiEzSwSL/EQlNowkiDlZRdkVkkWrGt2KMg+VWGlkbjvKmnRf79u3d/sb8cBMa1/tzNDBKta0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y71S7jnf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722254097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a4NZQE0a01E7gkys5wMB3DntjcYY2NgIlYja4WDLw5Q=;
	b=Y71S7jnffmLdAPZhkzP5xyw6mEJXAwl0H8UjxhiKh1+Vrbh7yOl0N/VFvVJDZQJr5tNrBk
	epH/OujWB8Vur9OfC8L+UG+/l1pLCctbH5t+SMbKAQzFjUvmbz9nwQfhcnbLP8G7ZtL4v3
	HlDMlA4nydnkqGm1+XmpP+hqBDWBN0E=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-Q06iPVBDPrmEy95XXh8Nkw-1; Mon, 29 Jul 2024 07:54:56 -0400
X-MC-Unique: Q06iPVBDPrmEy95XXh8Nkw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-654d96c2bb5so47589177b3.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 04:54:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722254095; x=1722858895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4NZQE0a01E7gkys5wMB3DntjcYY2NgIlYja4WDLw5Q=;
        b=f1h1o0wA8Fj0iI6z0MW1n4UHPtciTlM6jCzrvVBUkwK2pFVX4SlEqPkaRxvUCnPpsS
         KvV2flxCCHgE3NImoE/FTD6Rbjl0E9MwWNjUTn78DI3jYvnm/CVG2sbjFEtS98N9c7CK
         VqR1XZfcpcWDz/FyX7oRSfJJHTl8b5/vN2jME++SkVyYREg0/pfVwS0UIHhW448OAPJp
         hrKJumvMylXYHqQSb95/LYD6Ox+/NZnzIKIUrJ9l1VZBocoTY2ZzvOOrjyg28GzQ0szK
         lFW8VVkgukBMQL4T2+30+F+JSrs63C4AuysdSHyeYJlliFeZzk19Vip3fSgyS5dxc2CX
         j6/A==
X-Forwarded-Encrypted: i=1; AJvYcCWrA5CD+zu2s+Sbr0tAxg1ISvOFsjsl+N6+3C540696FyPvMCYX1sgPiPQw9RCNT3ors4sei+U5RtQYlRZFA9DhOZLv
X-Gm-Message-State: AOJu0YwEViIj+pZN4pYhWtq+LlwgXOE2VA5a6CnKFvYjbtP7XN2wZ13e
	rQYRRTMac1Syi6PJV/hln2wf5qbF6ZCSLyX1CBk0B6qtQ9SeDNG49z85RX+AKY1qk7u8XZ7CAwF
	9a/OogKvCeLNXlPYs+IamFpp1/6JMXcdJJcmN4mY2zvVUGVfUqlWfvLxKIMXnKhsHf+ZI3SKEoe
	oquMA+V5IO9pI5LOdZvDmvX3NN
X-Received: by 2002:a0d:cd45:0:b0:66a:843c:4c38 with SMTP id 00721157ae682-67a09b7279cmr66399297b3.37.1722254095620;
        Mon, 29 Jul 2024 04:54:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErfrRTDiSJvI5t7sMOIhqCoRowoqwYj4meCPwD0Afc+x3c9S/BATACl3L0a2odQpmfXnY0yF5dkB0GXDcn7Fc=
X-Received: by 2002:a0d:cd45:0:b0:66a:843c:4c38 with SMTP id
 00721157ae682-67a09b7279cmr66399057b3.37.1722254095312; Mon, 29 Jul 2024
 04:54:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-6-crosa@redhat.com>
 <ZqdwJRRBjj5DsWh8@redhat.com>
In-Reply-To: <ZqdwJRRBjj5DsWh8@redhat.com>
From: Cleber Rosa <crosa@redhat.com>
Date: Mon, 29 Jul 2024 07:54:40 -0400
Message-ID: <CA+bd_6Jj-DgpkouznuDC-ViOhi4zLu-SxnyrnyV6ceycHhEBiA@mail.gmail.com>
Subject: Re: [PATCH 05/13] tests/avocado: machine aarch64: standardize
 location and RO access
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 6:34=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Fri, Jul 26, 2024 at 09:44:30AM -0400, Cleber Rosa wrote:
> > The tests under machine_aarch64_virt.py and machine_aarch64_sbsaref.py
> > should not be writing to the ISO files.  By adding "media=3Dcdrom" the
> > "ro" is autmatically set.
> >
> > While at it, let's use a single code style and hash for the ISO url.
> >
> > Signed-off-by: Cleber Rosa <crosa@redhat.com>
> > ---
> >  tests/avocado/machine_aarch64_sbsaref.py |  6 +++++-
> >  tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
> >  2 files changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/m=
achine_aarch64_sbsaref.py
> > index e920bbf08c..1275f24532 100644
> > --- a/tests/avocado/machine_aarch64_sbsaref.py
> > +++ b/tests/avocado/machine_aarch64_sbsaref.py
> > @@ -129,7 +129,11 @@ def boot_alpine_linux(self, cpu):
> >              "-cpu",
> >              cpu,
> >              "-drive",
> > -            f"file=3D{iso_path},format=3Draw",
> > +            f"file=3D{iso_path},media=3Dcdrom,format=3Draw",
> > +            "-device",
> > +            "virtio-rng-pci,rng=3Drng0",
> > +            "-object",
> > +            "rng-random,id=3Drng0,filename=3D/dev/urandom",
> >          )
>
> The commit message doesn't say anything about adding virtio-rng.
> If that's needed for some reason, do it as a separate commit
> with an explanation of the bug its fixing.
>

This is actually a rebase mistake.  virtio-rng was removed in 21f123f3c.

I'll fix it in a v2.

Thanks for spotting it,
- Cleber.


