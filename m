Return-Path: <kvm+bounces-21917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE72A937423
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 08:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CF2B1C214CF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 06:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBFE4EB51;
	Fri, 19 Jul 2024 06:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="bg0pG5ms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5436D42076
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 06:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721372352; cv=none; b=Jgw4JA899hrElMHGSakoSntAH8HekVChNPc395mThGq7I7hcELUooI/L47GLK5wJzJzB4QQG580SVEm79MgixMJ2jSnsMe/MHXi8YfnUZvwBeFiUyOQ2TjW+NFOtwXc+wvxtgOqNN6HxrKEjqsGKhGVHEswEJmI1+hWNGzwxcLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721372352; c=relaxed/simple;
	bh=TjI2uSaMbuSUIz0tRhWklSuLq91xEZst2t4mS5dEQSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EHJCr34q7jGncK4hiKm1x7e2BMpr/CJ5zaYMlrJftlIlXfHyHPgix6TtxK/aNKawDn3P3IxsAztzxxHZFkbSSg1tPv1UR3XiIyTguZcCK5+vtvKFdEUe4X5kzlGLPhynv//yqg3+4ByBH/ng/nCOntRQg/fWSGFBYbbzfx+GXdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=bg0pG5ms; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d9dbbaa731so926066b6e.3
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 23:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721372350; x=1721977150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Weu/42V7gECXMih3fbVRqu0U+HL7dgFNDXvO7croHQU=;
        b=bg0pG5msWt4EASmUrJ9Oi8+KlvPvlnO16G7rYtsZ/dtkK5zqlAHex1ZMIB9Wb/Erat
         1bsMndyvd9kFBwIossBLqFJVTa0DSsD8aaAPcGG6Ok/SKKX0UIRdqIjqNxqMTFr/WPAD
         1LFhFpTzCwEbaZudmI+DAIy/hNpnnOm68OKjs0RKoupiklkOfFboFMnnYpVSHIr1gmRN
         x5KgD03MQLuTpwIeEUmLgik4eIamhg3D/mSYUlKwDNzpN4KG5HSkv2YYT710X1iMKOta
         rHuCcZU+V6hLdcuJut25F+BKjFbM3tmVxZk6Y/pQfZ2eM+pD9pycpj1ggIaDT4dBIKXa
         V23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721372350; x=1721977150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Weu/42V7gECXMih3fbVRqu0U+HL7dgFNDXvO7croHQU=;
        b=Z85/EMltKIgfILCqa2zoC+rIiP3dSSUlL+VeJ2DJm3jglQD5TglY3taCYAreGwVy3D
         mDwWxEECXTID9BjueslEwd+dsT9YtERbguQyYZAV5sqIlGEFiVlJtAigA88/5yppBEX/
         UF2dXK98/kVfXHtT12HvOJ3t3tNc8bNz33WPFgbJNLWVSG1BYkuAny0PyQXd2DYYJJ+E
         y1xGaULel8vbfOL7cTsRIkM+11XAv4iM9Q32ZfDNWFrwm/wtlBmDQ+RvQWeFy8O2RsZ0
         FmfiJ8RBP6RhoJupI51nBzga3ppOxlx4TPGbgKStRAxtfENHQ7Yn3XcV06y76QMsKNOd
         i0KA==
X-Forwarded-Encrypted: i=1; AJvYcCXSNrjkWDzKBpaJjHESXbuQ63xQ5/89dWCMfX1FREI/EGtDGf0r+MWUoToH7Vu/An/uIHFEvwTN7D3mRaYIX3D7iXXb
X-Gm-Message-State: AOJu0YyukyL5Q3emHouD44+GRKiStL1Mw8iyW28tAs0v0hIWltPlN4pT
	+kkBLmRAqmTUNH6nBpptLKJ3HI91BaPPPgTO9jDy9hncty7PFOk+65avGkkYRPVluZ+5V1taK0F
	noRIncnuKvW7LnQqigI+kJNLAf5U1JidCOBHnxA==
X-Google-Smtp-Source: AGHT+IG9ze+TAPgWUR4nBh2DXYtPskGwtSbGl8cv6Jg7P0RUvU2chBzq3BE4fSR2DgpzMlQ7F8+KPBWwQXlhETkveQ4=
X-Received: by 2002:a05:6808:13c7:b0:3d5:5e18:cf32 with SMTP id
 5614622812f47-3dad1f999a9mr8556178b6e.48.1721372350441; Thu, 18 Jul 2024
 23:59:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com> <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
In-Reply-To: <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Fri, 19 Jul 2024 14:58:59 +0800
Message-ID: <CAMWQL2g-peSYJQaxeJtyOzGdEmDQ6cnkRBdFQvLr2NQA1+mv2g@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Conor Dooley <conor@kernel.org>, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Fri, Jul 19, 2024 at 7:38=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> > Add entries for the Svade and Svadu extensions to the riscv,isa-extensi=
ons
> > property.
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > ---
> >  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/=
Documentation/devicetree/bindings/riscv/extensions.yaml
> > index 468c646247aa..e91a6f4ede38 100644
> > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > @@ -153,6 +153,34 @@ properties:
> >              ratified at commit 3f9ed34 ("Add ability to manually trigg=
er
> >              workflow. (#2)") of riscv-time-compare.
> >
> > +        - const: svade
> > +          description: |
> > +            The standard Svade supervisor-level extension for SW-manag=
ed PTE A/D
> > +            bit updates as ratified in the 20240213 version of the pri=
vileged
> > +            ISA specification.
> > +
> > +            Both Svade and Svadu extensions control the hardware behav=
ior when
> > +            the PTE A/D bits need to be set. The default behavior for =
the four
> > +            possible combinations of these extensions in the device tr=
ee are:
> > +            1) Neither Svade nor Svadu present in DT =3D> It is techni=
cally
> > +               unknown whether the platform uses Svade or Svadu. Super=
visor
> > +               software should be prepared to handle either hardware u=
pdating
> > +               of the PTE A/D bits or page faults when they need updat=
ed.
> > +            2) Only Svade present in DT =3D> Supervisor must assume Sv=
ade to be
> > +               always enabled.
> > +            3) Only Svadu present in DT =3D> Supervisor must assume Sv=
adu to be
> > +               always enabled.
> > +            4) Both Svade and Svadu present in DT =3D> Supervisor must=
 assume
> > +               Svadu turned-off at boot time. To use Svadu, supervisor=
 must
> > +               explicitly enable it using the SBI FWFT extension.
> > +
> > +        - const: svadu
> > +          description: |
> > +            The standard Svadu supervisor-level extension for hardware=
 updating
> > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull=
 request
> > +            #25 from ved-rivos/ratified") of riscv-svadu. Please refer=
 to Svade
>
> Should we be referencing the archived riscv-svadu repository now that Sva=
du has
> been merged to the main privileged ISA manual? Either way:
>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
>

Yes, this commit is from the archived riscv-svadu repo. Or should I update =
it to
"commit c1abccf ("Merge pull request  #25 from ved-rivos/ratified") of
riscvarchive/riscv-svadu."?

Regards,
Yong-Xuan

> > +            dt-binding description for more details.
> > +
> >          - const: svinval
> >            description:
> >              The standard Svinval supervisor-level extension for fine-g=
rained
>

