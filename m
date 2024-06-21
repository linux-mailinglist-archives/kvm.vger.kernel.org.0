Return-Path: <kvm+bounces-20275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDEE91267B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B8241F21E65
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9726722094;
	Fri, 21 Jun 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Gwxa6YpY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C17F2E622
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718975715; cv=none; b=Ck7Wun52CNl4w7KUU4hlE380B31WaqXiGboHRTh1MlwFb7D/pte/4+IJV0wD6nRtKiAc3mu7MtEVFzz9gVpaQm6m0vZzj5P2FO7vd7zJ8nuinTyemYKukq4LPxsp45fiyG0ca0DjXyrC4sTN8pC5deA8d1uHjlXm3WLyZI5MMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718975715; c=relaxed/simple;
	bh=mQ7wmAolxTUXR3TDySGFFEBFu0+G4nfni9DtqD1DkcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alSWdyjgRZoZB9uElWwTVYV2m0hMG9wAQLYvMvXlbcehptu7CrbVvjvgZ0Bv0SAnNiaZDcZh5fx0XFoQBvEW1sZ2lJdo2sfkxGsIj4kEbuQcpjngxQIVVArDAC5YKfwAa0s0F5fJHzhW2gVftWMVz1psQu8z/4Fxa1+2O7bFbdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Gwxa6YpY; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57d331cc9feso574694a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 06:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718975712; x=1719580512; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cD16Eg0jMB1tLt142Rk+A9t4pdlm9NDQxO24pzXHIlI=;
        b=Gwxa6YpYwPnU1fvJaYdvEg7BG1HarfT1uE81qaTj1WKttIAWtOET+UuSJ25JcJQqLP
         BaYuPv7MdDuVL7KmpbEqpMAsGzx4smSWbgivSU76eVE4PX8//+7vMit8/YH1hnSOQ2mB
         Zxs2J83sE7FWhqzAvhdF8UVgZP8RX8dg3muaqIxHC+v/QgkeNPeasCChZPxZhlL43oPl
         Pqvq/sHmQMibi6nqXZ7+uD1cdcOovc2guF9nS1Z9w8pa13rMmHUV2Vll+1Ew+De3QxlR
         P11HfywhKHbQGDxZ4zfBbFa4U1m4cQm/f6zVHS5lq+Ep3gCbfK8kuMkkaFeSRYTrURIO
         p6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718975712; x=1719580512;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cD16Eg0jMB1tLt142Rk+A9t4pdlm9NDQxO24pzXHIlI=;
        b=cGkgHmh8gUhtbtDMuUjeqjMGA4txKCKRAiG8mSdXLEvNGbnRuik0MeCXKSo0ZzLkrQ
         IIDZib8RDBkiVIZ6e+x1qusvpkxF3qj2W2suuezrHjbLBK5ZyddhXI2T79mzL+2EeGnz
         WCaz6qOqp/TkVRQ6o97c8gMNkJqc9U29KW+aQuFJHNmLQTanXKJ/2Osce53cJvS+YCXZ
         GjvHJBRJK2hfzNTQRRsxUiPt04+hAy3wRE3VgjzsJA7ZUzaKBtSNuv4NVHzZYTsKPEu5
         aEHKCjuQjE+nJ2RAupeh2we9Do8PmyaAxegwAKsLgUnNr7rdb6AtRGOycPl/7GPmZKwT
         pWHg==
X-Forwarded-Encrypted: i=1; AJvYcCUZH7HpNOgFuMz4w5A3CjYhpsfhx1hK64JO3CR9koJR1vngAoLnacgOwub0s1MocsZwEb6m4wZE+js4HSxd7+14lD+L
X-Gm-Message-State: AOJu0YyP2jH0of2ru41jbrXQNr0HedjinxvqhY4tVYQrVNvdUJKcK8Zn
	XrgTinkIzgWb5fQK0SuYX00Ano8MII+6yZR2V1yfI7xW9aA6bNTSMQVkEgwW6r0=
X-Google-Smtp-Source: AGHT+IEHzhMsJ0Rmre1Op5vsKrU4YAx88gVFBKQkrx9xQgMhlCsZix0dkICFq5gGjvtBpIaF8RFzng==
X-Received: by 2002:a50:8719:0:b0:57c:571f:e52d with SMTP id 4fb4d7f45d1cf-57d07ebeaaamr5721984a12.36.1718975712142;
        Fri, 21 Jun 2024 06:15:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d3042fd72sm954912a12.48.2024.06.21.06.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 06:15:11 -0700 (PDT)
Date: Fri, 21 Jun 2024 15:15:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Conor Dooley <conor.dooley@microchip.com>, 
	Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>, 
	Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-9bf9365533a2f8f97cbf1f5e@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
 <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>

On Fri, Jun 21, 2024 at 02:42:15PM GMT, Alexandre Ghiti wrote:
> 
> On 21/06/2024 12:17, Conor Dooley wrote:
> > On Fri, Jun 21, 2024 at 10:37:21AM +0200, Alexandre Ghiti wrote:
> > > On 20/06/2024 08:25, Anup Patel wrote:
> > > > On Wed, Jun 5, 2024 at 10:25 PM Conor Dooley <conor@kernel.org> wrote:
> > > > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > > > Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> > > > > > property.
> > > > > > 
> > > > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > > > ---
> > > > > >    .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
> > > > > >    1 file changed, 30 insertions(+)
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > index 468c646247aa..1e30988826b9 100644
> > > > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > @@ -153,6 +153,36 @@ properties:
> > > > > >                ratified at commit 3f9ed34 ("Add ability to manually trigger
> > > > > >                workflow. (#2)") of riscv-time-compare.
> > > > > > 
> > > > > > +        - const: svade
> > > > > > +          description: |
> > > > > > +            The standard Svade supervisor-level extension for raising page-fault
> > > > > > +            exceptions when PTE A/D bits need be set as ratified in the 20240213
> > > > > > +            version of the privileged ISA specification.
> > > > > > +
> > > > > > +            Both Svade and Svadu extensions control the hardware behavior when
> > > > > > +            the PTE A/D bits need to be set. The default behavior for the four
> > > > > > +            possible combinations of these extensions in the device tree are:
> > > > > > +            1. Neither svade nor svadu in DT: default to svade.
> > > > > I think this needs to be expanded on, as to why nothing means svade.
> > > > Actually if both Svade and Svadu are not present in DT then
> > > > it is left to the platform and OpenSBI does nothing.
> > > > 
> > > > > > +            2. Only svade in DT: use svade.
> > > > > That's a statement of the obvious, right?
> > > > > 
> > > > > > +            3. Only svadu in DT: use svadu.
> > > > > This is not relevant for Svade.
> > > > > 
> > > > > > +            4. Both svade and svadu in DT: default to svade (Linux can switch to
> > > > > > +               svadu once the SBI FWFT extension is available).
> > > > > "The privilege level to which this devicetree has been provided can switch to
> > > > > Svadu if the SBI FWFT extension is available".
> > > > > 
> > > > > > +        - const: svadu
> > > > > > +          description: |
> > > > > > +            The standard Svadu supervisor-level extension for hardware updating
> > > > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
> > > > > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > > > > +
> > > > > > +            Both Svade and Svadu extensions control the hardware behavior when
> > > > > > +            the PTE A/D bits need to be set. The default behavior for the four
> > > > > > +            possible combinations of these extensions in the device tree are:
> > > > > @Anup/Drew/Alex, are we missing some wording in here about it only being
> > > > > valid to have Svadu in isolation if the provider of the devicetree has
> > > > > actually turned on Svadu? The binding says "the default behaviour", but
> > > > > it is not the "default" behaviour, the behaviour is a must AFAICT. If
> > > > > you set Svadu in isolation, you /must/ have turned it on. If you set
> > > > > Svadu and Svade, you must have Svadu turned off?
> > > > Yes, the wording should be more of requirement style using
> > > > must or may.
> > > > 
> > > > How about this ?
> > > > 1) Both Svade and Svadu not present in DT => Supervisor may
> > > >       assume Svade to be present and enabled or it can discover
> > > >       based on mvendorid, marchid, and mimpid.
> > > > 2) Only Svade present in DT => Supervisor must assume Svade
> > > >       to be always enabled. (Obvious)
> > > > 3) Only Svadu present in DT => Supervisor must assume Svadu
> > > >       to be always enabled. (Obvious)
> > > 
> > > I agree with all of that, but the problem is how can we guarantee that
> > > openSBI actually enabled svadu?
> > Conflation of an SBI implementation and OpenSBI aside, if the devicetree
> > property is defined to mean that "the supervisor must assume svadu to be
> > always enabled", then either it is, or the firmware's description of the
> > hardware is broken and it's not the supervisor's problem any more. It's
> > not the kernel's job to validate that the devicetree matches the
> > hardware.
> > 
> > > This is not the case for now.
> > What "is not the case for now"? My understanding was that, at the
> > moment, nothing happens with Svadu in OpenSBI. In turn, this means that
> > there should be no devicetrees containing Svadu (per this binding's
> > description) and therefore no problem?
> 
> 
> What prevents a dtb to be passed with svadu to an old version of opensbi
> which does not support the enablement of svadu? The svadu extension will end
> up being present in the kernel but not enabled right?
>

I understand the concern; old SBI implementations will leave svadu in the
DT but not actually enable it. Then, since svade may not be in the DT if
the platform doesn't support it or it was left out on purpose, Linux will
only see svadu and get unexpected exceptions. This is something we could
force easily with QEMU and an SBI implementation which doesn't do anything
for svadu. I hope vendors of real platforms, which typically provide their
own firmware and DTs, would get this right, though, especially since Linux
should fail fast in their testing when they get it wrong.

Thanks,
drew

