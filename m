Return-Path: <kvm+bounces-32152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E529D3CD4
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCF28282594
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 13:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599EC1AAE18;
	Wed, 20 Nov 2024 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="YNwXFNyz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D220ED
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732110933; cv=none; b=EK6mtme9B40V5nf2EPTXJN/hjAqH6KOJTa0ovgLvwsPCmF3RmWpo3rppcS5psW1I7GEkf3Uf7U+n/Z8hkLiWgw34kkkU01nM824riEg8ZTOHA5mpke5JLswmyuYviF3/2URoiF4y1j8vz7FhVwYG/ghAYljMiokjTqtQqt2No34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732110933; c=relaxed/simple;
	bh=tLTJIeTUN5uWQmgMsBit449rE3QnNGMc1ry3N72Be2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k5i5OfZFUkzhx9HGFpJHJsTFpn/mBO4NAu9PNPtBJINIcJWKNqF9WZNzeI2ej7JhtO3WsPD12R3nw2cVupjXInKPGc1Cl4YmhkMDdfDSr+Gt2O0Ec3pm08B4ydPiBCUWuZNg5dBsSEqqLH+OH6Q8WnHgALSJpH4RWv9ukQyTo3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=YNwXFNyz; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f2b95775so5295273e87.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 05:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1732110930; x=1732715730; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWo6MmMAnTgakCcBn1+jc6Kn4Hq1VkFACaiDY+zPG/w=;
        b=YNwXFNyzrgqp9LxzV6kKwcsqDrGZZQAL3IhkfWcLkKRu6tdfgU8K5qj9052ueNVrIc
         jg8O0r9n7Dn6OgDPC6s70mDljgrU62LfO2NroNu1yFpt04HGvO3T5goBAdK2TpHjJ1Qc
         sAQJCUbrW7T9luJ5/JEL2JgvYGERD70FeB45k9emEI7S6IU54yGztocMIBzI3HSch5aB
         3MUd3JlMobVNXsUVYMaKSMq/2FM9zxRTopbgXE+cgAlueRYKO6Y+gjo9AaN78/6DH41Q
         spGX2dfQNZ29U1Y+YCODaBUwmcMQ8OFvHi29/Eg/UBLKnlJwW6XUD6H9tglwOureotct
         kMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732110930; x=1732715730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YWo6MmMAnTgakCcBn1+jc6Kn4Hq1VkFACaiDY+zPG/w=;
        b=b8JhUdQSuRPQ5I3MPsy4mbSc/2Q6jf1cl4FJL4iPYQSAQ/Ih8TexgKu3M6hfQ/KvNE
         8o/nR7soCdYkWzp4CEStlvvygytYx8i2cQVq1y0VVBzD0NI7TnPOckRRHGblvrAihCZw
         CViCkHC1J0DTu8qwvdckuFeiGcCqgOPuy3q1QHtWTxB9Tab7Oto2uT4eCH7nHQ93a/MW
         KuvDiialM9KxxNAknLI/tm46kKihr8VUlnpKi/3SXJQJ5ebJgp/9FTZmaSz1pDQTYaR2
         lMyxPY1vg+ppmatjm1oo2fsR5mjFJjCx1JVqGlD+zA3XVXQymvmwqFqy7PeekKV+YCqD
         qKMA==
X-Forwarded-Encrypted: i=1; AJvYcCVEF2z7vOCrCn+i6s1LkL61Ic94HbLiBQKuEnhVdSFv0d7BzsCKPu07H8YSWZYtvDTeEOo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8AfxdNoucnTjqNHo0iHveZyV2muc7E6EnppWrVJJzCF5dLwlM
	fjR+y1NrJif1zc4KOKVGzNcgvydGdbuxu7BKKlpS3zA6zKN09g6SbnhUb6ujZHYYJTJvv2QNhzT
	oHWqpfDKprcjlmbEf4cWfIpX43vgZ6GGybLE8uQ==
X-Google-Smtp-Source: AGHT+IGnkwgpl/fVHCnAI2JHFf0JszP0Rs1/hN3/HwVKLTkM8QFYKEB3KFhIrGPtwJ8EIhrJTpbnn92x9rsPQMasFgw=
X-Received: by 2002:a05:6512:3c97:b0:53b:163a:f279 with SMTP id
 2adb3069b0e04-53dc136b9ffmr2010773e87.53.1732110929980; Wed, 20 Nov 2024
 05:55:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
 <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com> <eb8f399b-fa09-47fd-8102-9b65b0839dd5@ghiti.fr>
In-Reply-To: <eb8f399b-fa09-47fd-8102-9b65b0839dd5@ghiti.fr>
From: Max Hsu <max.hsu@sifive.com>
Date: Wed, 20 Nov 2024 21:55:18 +0800
Message-ID: <CAHibDyzOWrKwEZ_7K2f2MY9DFn4sD5QjDEQ42u8DTaftN6Fuvw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] dt-bindings: riscv: Add Svukte entry
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Samuel Holland <samuel.holland@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

Thanks for the suggestion.
I will send a typo fix in the RFC v3 patches

Best regards,
Max Hsu

On Thu, Nov 14, 2024 at 12:15=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> Hi Max,
>
> On 20/09/2024 09:39, Max Hsu wrote:
> > Add an entry for the Svukte extension to the riscv,isa-extensions
> > property.
> >
> > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > Signed-off-by: Max Hsu <max.hsu@sifive.com>
> > ---
> >   Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/=
Documentation/devicetree/bindings/riscv/extensions.yaml
> > index a06dbc6b4928958704855c8993291b036e3d1a63..df96aea5e53a70b0cb89053=
32464a42a264e56e6 100644
> > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > @@ -171,6 +171,13 @@ properties:
> >               memory types as ratified in the 20191213 version of the p=
rivileged
> >               ISA specification.
> >
> > +        - const: svukte
> > +          description:
> > +            The standard Svukte supervisor-level extensions for making=
 user-mode
>
>
> s/extensions/extension
>
>
> > +            accesses to supervisor memory raise page faults in constan=
t time,
> > +            mitigating attacks that attempt to discover the supervisor
> > +            software's address-space layout, as PR#1564 of riscv-isa-m=
anual.
> > +
> >           - const: zacas
> >             description: |
> >               The Zacas extension for Atomic Compare-and-Swap (CAS) ins=
tructions
> >
>
> You'll need a new version for the proper commit sha1 once it gets
> ratified anyway, so with the typo fixed, you can add:
>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>
> Thanks,
>
> Alex
>

