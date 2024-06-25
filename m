Return-Path: <kvm+bounces-20462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8ABC916509
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 12:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82C1C2823F7
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 10:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0D114A0B6;
	Tue, 25 Jun 2024 10:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="R+7/Me23"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089ED11CA0
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 10:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719310553; cv=none; b=Rr8GRoc0FhOXkbQCyIGGsds4KOzntarrOn0Ns+JdYGqnmffdAA3qOFDoS6Ek41scp9oo2OXNvI4qGUcw5GT8k+IFLYyKLQQ5sSIXKSswumDzeL9TxRZdx7F/Z83y555XGvQ+EGdHYTNQTf2GAhbDxTLvSiim/EjXiPSrsTNaaA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719310553; c=relaxed/simple;
	bh=FtJYuNRCDykwAb6CpLYPt+xx6IOhdHG/dTfV7HrvJC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BbplV90031ZVmjhemnTEMYwPLh2lu3lYV/UVpj30UH0EUHkGS4ficVsL1xVIKj1pm8nTu8f15kx9SDM4ChQ/lwWFETuTVTzounZOraCh/JMJWO37zDS/ZbmmoeyM6DM1NOfnMYnejUEiMZ/B4D7zbI9Jxgun1y2FwQnz6ESn/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=R+7/Me23; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-25c95299166so2711759fac.3
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 03:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719310551; x=1719915351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BktDRqnPMFELB/prBTikpiW5DTpaK+CgtgFHB2p1S0w=;
        b=R+7/Me23kQzX8uN2ERTqEZ8BuW3YDAvFCq4pii/7s9nz1l82ipZOXcp5ECxTt4hJT1
         mPjiCShxsT4II7paG5YoVksy95f46Ozk4RdTrtLTiPdWnbVaJOKLi1NEGsaxoCf8PT9o
         zTOg73iXt+WarRMrcHerWjTEHCmlhskxSuGS4b6tYLKtWXxoAtivpf3MK5NjW9s+PYAs
         eusdsPbAZB3NWBFPUJp7sAxwF/WVjK4ibvmwyuPm4jMGmIxhZGYQZBtb5vgPuP7cOvSA
         uhVow5drNvVnu2GMTOVp1Wip8ta/DPnPEBptp5c1RJ/HSAC5/8G1sJ8UsHE0MqSfKPLC
         UitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719310551; x=1719915351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BktDRqnPMFELB/prBTikpiW5DTpaK+CgtgFHB2p1S0w=;
        b=uiygydqJX3bTqu72aiTiMlY+tWtWgqR+LD14eYr5GMNFEixNsURlvbbSRJCCNnV0tM
         DK7iAVpcmHfQ4dOJpURLMIoTPlYlgU4TcF4D1Y8gCexp/wi5Kx/u7mNhk8m1t+IBTFMp
         D6FMx/1AhzIEAsoK3jUnG3+j/joYD4dEHL4UZaBAXfpc0xTZjd6ZTxL7R5t5WllOOzBR
         CZBGrQOvw/YPO5jCi8GM8GwKzWZF5/f/v5DB5gjBbmKH7iVPc/nHa5FwNOap/Wh7+eFn
         5T53YdwZQIlLLM2Y7dqyUeO5DOjJuHm7CaRW4FAV88fIPqTq5//CvfkbmX+GencT6kr9
         Fy+g==
X-Forwarded-Encrypted: i=1; AJvYcCUfUJjYdhNRbN/GHwI2vucpPfkUPZ28J5V0MwxslB3NQG7rL8bev/REI1ffBvFzKSg+jdhZNXTnXUQzXHeQSfVrt2jN
X-Gm-Message-State: AOJu0YyOzFzscqThfwA2C3i9HEnLk6sB5atN/Zfxd3ZQNxT8nu9xB8Wj
	b8irCkqHM5GhGhwu62h+Pjoz7UqxgNOBFNZQKEtlXXXePB/jyfQ7lEOLfEhkrE6EuHU6TOKcLBx
	A0OR0bhiU6mdPJ3ecpbQJTXkxnSHDnpu68yekMQ==
X-Google-Smtp-Source: AGHT+IHdQg0dChXalsihdVM0gzMAZlwgRB+W6UlnBn8/daYZeHmLyMfFupx8YsHVo6AIVJIsqQvv/HsqJ6VBzCA/IqE=
X-Received: by 2002:a05:6870:d69c:b0:254:e4a0:4d9c with SMTP id
 586e51a60fabf-25cfcfa117amr8027802fac.58.1719310551082; Tue, 25 Jun 2024
 03:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com> <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com> <20240621-10d503a9a2e7d54e67db102c@orel>
In-Reply-To: <20240621-10d503a9a2e7d54e67db102c@orel>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Tue, 25 Jun 2024 18:15:40 +0800
Message-ID: <CAMWQL2gGfpotAR_YmU05bciGV98r80PZ1GWDSk6A03YRxD8wug@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, alex@ghiti.fr, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup/Andrew/Alexandre,

Thanks a lot! So the description of dt-binding of Svade would be:

The standard Svade supervisor-level extension for SW-managed PTE A/D
bit updates as ratified in the 20240213 version of the privileged
ISA specification.
1) Neither Svade nor Svadu present in DT =3D> It is technically
    unknown whether the platform uses Svade or Svadu. Supervisor may
    assume Svade to be present and enabled or it can discover based
    on mvendorid, marchid, and mimpid.
2) Only Svade present in DT =3D> Supervisor must assume Svade
    to be always enabled. (Obvious)
3) Only Svadu present in DT =3D> Supervisor must assume Svadu
    to be always enabled. (Obvious)
4) Both Svade and Svadu present in DT =3D> Supervisor must
    assume Svadu turned-off at boot time. To use Svadu, supervisor
    must explicitly enable it using the SBI FWFT extension.

Would you mind providing a Co-developed-by for this patch?

Regards,
Yong-Xuan


On Fri, Jun 21, 2024 at 4:33=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Jun 20, 2024 at 11:55:44AM GMT, Anup Patel wrote:
> > On Wed, Jun 5, 2024 at 10:25=E2=80=AFPM Conor Dooley <conor@kernel.org>=
 wrote:
> > >
> > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > Add entries for the Svade and Svadu extensions to the riscv,isa-ext=
ensions
> > > > property.
> > > >
> > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > ---
> > > >  .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++=
++++
> > > >  1 file changed, 30 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yam=
l b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > index 468c646247aa..1e30988826b9 100644
> > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > @@ -153,6 +153,36 @@ properties:
> > > >              ratified at commit 3f9ed34 ("Add ability to manually t=
rigger
> > > >              workflow. (#2)") of riscv-time-compare.
> > > >
> > > > +        - const: svade
> > > > +          description: |
> > > > +            The standard Svade supervisor-level extension for rais=
ing page-fault
> > > > +            exceptions when PTE A/D bits need be set as ratified i=
n the 20240213
> > > > +            version of the privileged ISA specification.
> > > > +
> > > > +            Both Svade and Svadu extensions control the hardware b=
ehavior when
> > > > +            the PTE A/D bits need to be set. The default behavior =
for the four
> > > > +            possible combinations of these extensions in the devic=
e tree are:
> > > > +            1. Neither svade nor svadu in DT: default to svade.
> > >
> > > I think this needs to be expanded on, as to why nothing means svade.
> >
> > Actually if both Svade and Svadu are not present in DT then
> > it is left to the platform and OpenSBI does nothing.
>
> This is a good point, and maybe it's worth integrating something that
> states this case is technically unknown into the final text. (Even though
> historically this has been assumed to mean svade.)
>
> >
> > >
> > > > +            2. Only svade in DT: use svade.
> > >
> > > That's a statement of the obvious, right?
> > >
> > > > +            3. Only svadu in DT: use svadu.
> > >
> > > This is not relevant for Svade.
> > >
> > > > +            4. Both svade and svadu in DT: default to svade (Linux=
 can switch to
> > > > +               svadu once the SBI FWFT extension is available).
> > >
> > > "The privilege level to which this devicetree has been provided can s=
witch to
> > > Svadu if the SBI FWFT extension is available".
> > >
> > > > +        - const: svadu
> > > > +          description: |
> > > > +            The standard Svadu supervisor-level extension for hard=
ware updating
> > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge =
pull request
> > > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > > +
> > > > +            Both Svade and Svadu extensions control the hardware b=
ehavior when
> > > > +            the PTE A/D bits need to be set. The default behavior =
for the four
> > > > +            possible combinations of these extensions in the devic=
e tree are:
> > >
> > > @Anup/Drew/Alex, are we missing some wording in here about it only be=
ing
> > > valid to have Svadu in isolation if the provider of the devicetree ha=
s
> > > actually turned on Svadu? The binding says "the default behaviour", b=
ut
> > > it is not the "default" behaviour, the behaviour is a must AFAICT. If
> > > you set Svadu in isolation, you /must/ have turned it on. If you set
> > > Svadu and Svade, you must have Svadu turned off?
> >
> > Yes, the wording should be more of requirement style using
> > must or may.
> >
> > How about this ?
>
> I'm mostly just +1'ing everything below, but with a minor wording change
> suggestion
>
> > 1) Both Svade and Svadu not present in DT =3D> Supervisor may
>
> Neither Svade nor Svadu present...
>
> >     assume Svade to be present and enabled or it can discover
> >     based on mvendorid, marchid, and mimpid.
> > 2) Only Svade present in DT =3D> Supervisor must assume Svade
> >     to be always enabled. (Obvious)
> > 3) Only Svadu present in DT =3D> Supervisor must assume Svadu
> >     to be always enabled. (Obvious)
> > 4) Both Svade and Svadu present in DT =3D> Supervisor must
> >     assume Svadu turned-off at boot time. To use Svadu, supervisor
> >     must explicitly enable it using the SBI FWFT extension.
> >
> > IMO, the #2 and #3 are definitely obvious but still worth mentioning.
>
> Thanks,
> drew

