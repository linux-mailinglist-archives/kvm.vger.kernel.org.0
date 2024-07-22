Return-Path: <kvm+bounces-22030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0F493877B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 04:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70ED5B20BA6
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 02:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA15F9D4;
	Mon, 22 Jul 2024 02:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="T3po7Ka4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF258D2FF
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 02:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721614464; cv=none; b=a76lSd/9BnXuEIo9c+vHqCFpr9uqiPPvQRunCbqVTPi2XfmGNBNOrPgRik8afEtH/qNIOLhqlApbziiaFHHCqbARYQfog7CpRY9kDYIB/Wkzpgj11gahnlHsCAzYO3ZJfsZGl4LEsfRWJQIEqAGzI/lXbdl3X+2YdMWh0AcdndU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721614464; c=relaxed/simple;
	bh=AJiaG+8x6Qhj7Wc27cG9Bf54PaCAqk9PdZsLZCJ5YBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EGYhLT9u6H8yUjWpuKNtykEfJaphpjWacVYh2BIuep31dvdedLyTykkwGMgfC+I9a5rxuSlfRoJ51Y1z2PAJwPSjQ7RbfxyXBf0yXs3DLsS2RWk1vpUrDN27Ze1MAs9uIc/r9NmmITW9LcqIP5xThaBaw1CzTguZZAmJ2IUF048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=T3po7Ka4; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-25dfb580d1fso1513621fac.2
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 19:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721614462; x=1722219262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kl/5HdiGOfFOfo04ZJqI2kOtj4nNd83dcFbNpwK/70I=;
        b=T3po7Ka4FkuG9TASaQl7cSeDfd107oKKu8ed8bpaeAqDuDaIrkcs1APMqclS/AZRss
         tCm6mrCIHLf4sWIw5mYAINM63oSbbo6wshaK22uigiY/ClLyVMhC8oSQJz4671zTQT68
         eDJCAfNCqyJbY0FXvLkGnyA8/XaDur5lS8UV/TTD7pu6OObld3DoLTqWIFHuCzM84fg8
         BYm0LBRnjzycpEfq29uGlYxZl9eQZCiSOLWHnIRJHY0qlfArj6zw7p4tYXEKobYKxn2T
         qkH8g4oX9RkZrHqhMakaFkeqV3UTwLdhHJO2NWpQNJLb23VKpCC6/oO0YpzIdvy+WJOx
         NnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721614462; x=1722219262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kl/5HdiGOfFOfo04ZJqI2kOtj4nNd83dcFbNpwK/70I=;
        b=kPY4hInD3KPTbse6++HxKllXgazX3ixqvL+qk7VeW6wSrP2YtzSz3/t7vg9+tBId+9
         owdZZcmPBb8X0NqQxuP7E+Eojb0mK664WyU04fYZBSLRHrkHJUxyvOm6QX1JV89yWJbz
         lHPG9RL6hHj0sLLQaCIwaFiKK8mCTh9qUxAqdmWyrgCmJsKAtVKvsN+4E25UqscTtYv1
         rrMDuhBzMnrLABXvhuUlPbaz/4A7LTd7GFYaqdwjOUMarMP3uvnrDQriQAri3ViNuKFT
         q8szDHNJ7RFyPDmQFrxQZytXW9ducz+HhrLYxM3xyoKojwtxjODDeRSbBbkh48y0YjK7
         PsCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu0rpvMqTRxs9TWpDXMJHidB9NKGOBone04qXS9VHbha/k0kfO1MXg2dipYdqnjePhJjLJhwq2o361g7aoPiUY8YAZ
X-Gm-Message-State: AOJu0YwlLjZHc2GH86G4nePH1TUdZpHwwOfer+KNcPbz2f8tIt8Yz4VR
	94acMu0SiPonSIno9L+5ITj8znLMxs6yoVeFfOJR5gZkeQWAhBbELKMzyuYvQgHdZsarTlGrZJi
	jW1r1GsEUlEKsfBD2qfJBmAYSBffBi01hnzuSKuHdcXGXkWp+
X-Google-Smtp-Source: AGHT+IHnB9IHVe+JUhN7+3oCZIPRki3xbro2mIHQOGvKQ+6goU1pu1Q9XgV6wLqCAmGxdb7cSYKKnOMLQd5vLv7Sn5A=
X-Received: by 2002:a05:6871:b28:b0:261:10b7:8c48 with SMTP id
 586e51a60fabf-2638df8951dmr5202348fac.27.1721614461869; Sun, 21 Jul 2024
 19:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com> <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
 <CAMWQL2g-peSYJQaxeJtyOzGdEmDQ6cnkRBdFQvLr2NQA1+mv2g@mail.gmail.com> <20240719-flatten-elixir-d4476977ab95@spud>
In-Reply-To: <20240719-flatten-elixir-d4476977ab95@spud>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Mon, 22 Jul 2024 10:14:11 +0800
Message-ID: <CAMWQL2iWsxLJZZ3H59csJ376Hdtq+ZKjD92BtM9zhdXm+fh2=A@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
To: Conor Dooley <conor@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Conor,

On Fri, Jul 19, 2024 at 9:17=E2=80=AFPM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Fri, Jul 19, 2024 at 02:58:59PM +0800, Yong-Xuan Wang wrote:
> > Hi Samuel,
> >
> > On Fri, Jul 19, 2024 at 7:38=E2=80=AFAM Samuel Holland
> > <samuel.holland@sifive.com> wrote:
> > >
> > > On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> > > > Add entries for the Svade and Svadu extensions to the riscv,isa-ext=
ensions
> > > > property.
> > > >
> > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > ---
> > > >  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++=
++++
> > > >  1 file changed, 28 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yam=
l b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > index 468c646247aa..e91a6f4ede38 100644
> > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > @@ -153,6 +153,34 @@ properties:
> > > >              ratified at commit 3f9ed34 ("Add ability to manually t=
rigger
> > > >              workflow. (#2)") of riscv-time-compare.
> > > >
> > > > +        - const: svade
> > > > +          description: |
> > > > +            The standard Svade supervisor-level extension for SW-m=
anaged PTE A/D
> > > > +            bit updates as ratified in the 20240213 version of the=
 privileged
> > > > +            ISA specification.
> > > > +
> > > > +            Both Svade and Svadu extensions control the hardware b=
ehavior when
> > > > +            the PTE A/D bits need to be set. The default behavior =
for the four
> > > > +            possible combinations of these extensions in the devic=
e tree are:
> > > > +            1) Neither Svade nor Svadu present in DT =3D> It is te=
chnically
> > > > +               unknown whether the platform uses Svade or Svadu. S=
upervisor
> > > > +               software should be prepared to handle either hardwa=
re updating
> > > > +               of the PTE A/D bits or page faults when they need u=
pdated.
> > > > +            2) Only Svade present in DT =3D> Supervisor must assum=
e Svade to be
> > > > +               always enabled.
> > > > +            3) Only Svadu present in DT =3D> Supervisor must assum=
e Svadu to be
> > > > +               always enabled.
> > > > +            4) Both Svade and Svadu present in DT =3D> Supervisor =
must assume
> > > > +               Svadu turned-off at boot time. To use Svadu, superv=
isor must
> > > > +               explicitly enable it using the SBI FWFT extension.
> > > > +
> > > > +        - const: svadu
> > > > +          description: |
> > > > +            The standard Svadu supervisor-level extension for hard=
ware updating
> > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge =
pull request
> > > > +            #25 from ved-rivos/ratified") of riscv-svadu. Please r=
efer to Svade
> > >
> > > Should we be referencing the archived riscv-svadu repository now that=
 Svadu has
> > > been merged to the main privileged ISA manual? Either way:
> > >
> > > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > >
> >
> > Yes, this commit is from the archived riscv-svadu repo. Or should I upd=
ate it to
> > "commit c1abccf ("Merge pull request  #25 from ved-rivos/ratified") of
> > riscvarchive/riscv-svadu."?
>
> I think Samuel was saying that we should use the commit where it was
> merged into riscv-isa-manual instead.

Got it. I will update the description in the next version. Thank you!

