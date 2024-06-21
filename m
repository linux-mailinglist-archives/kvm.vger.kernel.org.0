Return-Path: <kvm+bounces-20287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE39912885
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6490E284450
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91323AC0C;
	Fri, 21 Jun 2024 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dpk/+NH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BB12D057
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718981535; cv=none; b=Lld/PI3aUqrmYmW3IZcSKhCEakWkb2Fg4cc77dtlTuyMnNL0SHIxx7b3Mg7DPNfeq1K0AZ8qpUMfSprwJpayIthIufD0PQuPTcoWlO0CTai2mr5htoRk29w8P34qXnlyIcHTu7fFN7RwIBeAFWQ/zyT/AG1FYbUhuIpIin3zEj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718981535; c=relaxed/simple;
	bh=JOzDKRfRyAYrmFpbQG5/eALwnos6jjvCy2uXdxhP3Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LgiC6dplOmMD2nChd5GrVx77+5ChhKNa20YO9GnyUc1BDPw87/UG2IRWReCv/3r8BhZRO0G0jIf4OY5YVr9K8NCqvWodx/Kuw26119KJ0C61f0NbjCQqd7wplx91SmTR06XpsvItckiyBPm7BgSWd1YTHQZdlYfTS75EKiV0rh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dpk/+NH1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4218008c613so18331845e9.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718981531; x=1719586331; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dY/74FpLsXRkkOHvC1PKdD9HRHfMWtcqzzHZbgsRq/Y=;
        b=dpk/+NH11/yM8DZ4kDdoUYLka+FEpKjtI/QcCBqEqfMrcKvCOHiwtoKLRh9oWdYVuy
         GPzQSnhDg8igm/W3SWt9uooRkxdAyLxHzxW4Wal9PilhCL/kO98x/8jvhTKfaQPKeMAQ
         8bdJ4bd32Qf/o+yqiCUSLs9O6Envr6Dz18bJ3VjkAr1p9uZPRJgRPfWfT4Htwx9MXy9w
         c/PklNDyNv/6zVg5c74BPu248LhjXRnrNPKKomrdvIpybh+Fe9Y4H7dDDJe6N3ZhFDMe
         DSO2u3RVu2Jtu4i2t7ivVfgpsRKUixdF8cNrN8Z30ImO1TkSXJX6LYa68mAf+z3oPZYF
         OXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718981531; x=1719586331;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dY/74FpLsXRkkOHvC1PKdD9HRHfMWtcqzzHZbgsRq/Y=;
        b=Hb544yagX5LzYNl2aVfeRXlsxcwN8u5Lb3huRoM4c5SiHcgtaUOQGbfIGfMzLXxuhF
         OrLeL38QwjuSnP9E5XPoHhAD9j/oqbONWAsw9mdDkO1Ne7pPmPbkihb3aZSNTb9PyMdP
         P4Rld5kbjchGjehluByEG/EHfY3xnO7vUhyYkXzWm+bEkv1t9etrgVfjrLNqgAjhftyg
         9sv38WRHFVt/A69vv3KOShZQ21pEqN/D8lF0B3ez4uvfxVienzVDwJ0x05c8aCA5/I+A
         n7ytoLQbQHMGKMYH7XOZDiDpJcPnuXSmfnPRRsDQW7YcjOGovzaY37bgUCFUwYaONzjR
         Hv+w==
X-Forwarded-Encrypted: i=1; AJvYcCXDXL0nY2zOoul8zx68ZyHv2Gzuh365ts2K+Cvbfn9gU9Xbrfdmhu8o2v76m8PJB6a6sROQF4rIgx9k2L47DC8D8u1o
X-Gm-Message-State: AOJu0YwRzqVS2fAZNWR7ODOZfzshBRA9xDw4FgwGKD6Fo6vxyGWR9HVu
	DMNwIJzXNx2S7dV5NEzIRjGZukG1CLJ9zFuJZN7M6EsqcImDv3MyiDBPr6e9E+o=
X-Google-Smtp-Source: AGHT+IFDyWfIf5nnHBOBzgfJ+unGgV6WY1zA4ehKaX0HVcYnLUrxaelLe8EK6XWmwNeLgZdxyEg9Og==
X-Received: by 2002:a05:6000:154c:b0:365:f52f:cd30 with SMTP id ffacd0b85a97d-365f52fce6bmr2382767f8f.53.1718981530889;
        Fri, 21 Jun 2024 07:52:10 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3664178f5f7sm1896905f8f.19.2024.06.21.07.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 07:52:10 -0700 (PDT)
Date: Fri, 21 Jun 2024 16:52:09 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Conor Dooley <conor@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, 
	Conor Dooley <conor.dooley@microchip.com>, Anup Patel <apatel@ventanamicro.com>, 
	Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-a56e848050ebbf1f7394e51f@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
 <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
 <20240621-9bf9365533a2f8f97cbf1f5e@orel>
 <20240621-glutton-platonic-2ec41021b81b@spud>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240621-glutton-platonic-2ec41021b81b@spud>

On Fri, Jun 21, 2024 at 03:04:47PM GMT, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 03:15:10PM +0200, Andrew Jones wrote:
> > On Fri, Jun 21, 2024 at 02:42:15PM GMT, Alexandre Ghiti wrote:
> > > 
> > > On 21/06/2024 12:17, Conor Dooley wrote:
> > > > On Fri, Jun 21, 2024 at 10:37:21AM +0200, Alexandre Ghiti wrote:
> > > > > On 20/06/2024 08:25, Anup Patel wrote:
> > > > > > On Wed, Jun 5, 2024 at 10:25 PM Conor Dooley <conor@kernel.org> wrote:
> > > > > > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > > > > > Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> > > > > > > > property.
> > > > > > > > 
> > > > > > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > > > > > ---
> > > > > > > >    .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
> > > > > > > >    1 file changed, 30 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > > index 468c646247aa..1e30988826b9 100644
> > > > > > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > > @@ -153,6 +153,36 @@ properties:
> > > > > > > >                ratified at commit 3f9ed34 ("Add ability to manually trigger
> > > > > > > >                workflow. (#2)") of riscv-time-compare.
> > > > > > > > 
> > > > > > > > +        - const: svade
> > > > > > > > +          description: |
> > > > > > > > +            The standard Svade supervisor-level extension for raising page-fault
> > > > > > > > +            exceptions when PTE A/D bits need be set as ratified in the 20240213
> > > > > > > > +            version of the privileged ISA specification.
> > > > > > > > +
> > > > > > > > +            Both Svade and Svadu extensions control the hardware behavior when
> > > > > > > > +            the PTE A/D bits need to be set. The default behavior for the four
> > > > > > > > +            possible combinations of these extensions in the device tree are:
> > > > > > > > +            1. Neither svade nor svadu in DT: default to svade.
> > > > > > > I think this needs to be expanded on, as to why nothing means svade.
> > > > > > Actually if both Svade and Svadu are not present in DT then
> > > > > > it is left to the platform and OpenSBI does nothing.
> > > > > > 
> > > > > > > > +            2. Only svade in DT: use svade.
> > > > > > > That's a statement of the obvious, right?
> > > > > > > 
> > > > > > > > +            3. Only svadu in DT: use svadu.
> > > > > > > This is not relevant for Svade.
> > > > > > > 
> > > > > > > > +            4. Both svade and svadu in DT: default to svade (Linux can switch to
> > > > > > > > +               svadu once the SBI FWFT extension is available).
> > > > > > > "The privilege level to which this devicetree has been provided can switch to
> > > > > > > Svadu if the SBI FWFT extension is available".
> > > > > > > 
> > > > > > > > +        - const: svadu
> > > > > > > > +          description: |
> > > > > > > > +            The standard Svadu supervisor-level extension for hardware updating
> > > > > > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
> > > > > > > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > > > > > > +
> > > > > > > > +            Both Svade and Svadu extensions control the hardware behavior when
> > > > > > > > +            the PTE A/D bits need to be set. The default behavior for the four
> > > > > > > > +            possible combinations of these extensions in the device tree are:
> > > > > > > @Anup/Drew/Alex, are we missing some wording in here about it only being
> > > > > > > valid to have Svadu in isolation if the provider of the devicetree has
> > > > > > > actually turned on Svadu? The binding says "the default behaviour", but
> > > > > > > it is not the "default" behaviour, the behaviour is a must AFAICT. If
> > > > > > > you set Svadu in isolation, you /must/ have turned it on. If you set
> > > > > > > Svadu and Svade, you must have Svadu turned off?
> > > > > > Yes, the wording should be more of requirement style using
> > > > > > must or may.
> > > > > > 
> > > > > > How about this ?
> > > > > > 1) Both Svade and Svadu not present in DT => Supervisor may
> > > > > >       assume Svade to be present and enabled or it can discover
> > > > > >       based on mvendorid, marchid, and mimpid.
> > > > > > 2) Only Svade present in DT => Supervisor must assume Svade
> > > > > >       to be always enabled. (Obvious)
> > > > > > 3) Only Svadu present in DT => Supervisor must assume Svadu
> > > > > >       to be always enabled. (Obvious)
> > > > > 
> > > > > I agree with all of that, but the problem is how can we guarantee that
> > > > > openSBI actually enabled svadu?
> > > > Conflation of an SBI implementation and OpenSBI aside, if the devicetree
> > > > property is defined to mean that "the supervisor must assume svadu to be
> > > > always enabled", then either it is, or the firmware's description of the
> > > > hardware is broken and it's not the supervisor's problem any more. It's
> > > > not the kernel's job to validate that the devicetree matches the
> > > > hardware.
> > > > 
> > > > > This is not the case for now.
> > > > What "is not the case for now"? My understanding was that, at the
> > > > moment, nothing happens with Svadu in OpenSBI. In turn, this means that
> > > > there should be no devicetrees containing Svadu (per this binding's
> > > > description) and therefore no problem?
> > > 
> > > 
> > > What prevents a dtb to be passed with svadu to an old version of opensbi
> > > which does not support the enablement of svadu? The svadu extension will end
> > > up being present in the kernel but not enabled right?
> 
> If you'll allow me use of my high horse, relying on undocumented
> (or deprecated I suppose in this case) devicetree properties is always
> going to leave people exposed to issues like this. If the property isn't
> documented, then you shouldn't be passing it to the kernel.
> 
> > I understand the concern; old SBI implementations will leave svadu in the
> > DT but not actually enable it. Then, since svade may not be in the DT if
> > the platform doesn't support it or it was left out on purpose, Linux will
> > only see svadu and get unexpected exceptions. This is something we could
> > force easily with QEMU and an SBI implementation which doesn't do anything
> > for svadu. I hope vendors of real platforms, which typically provide their
> > own firmware and DTs, would get this right, though, especially since Linux
> > should fail fast in their testing when they get it wrong.
> 
> I'll admit, I wasn't really thinking here about something like QEMU that
> puts extensions into the dtb before their exact meanings are decided
> upon. I almost only ever think about "real" systems, and in those cases
> I would expect that if you can update the representation of the hardware
> provided to (or by the firmware to Linux) with new properties, then updating
> the firmware itself should be possible.
> 
> Does QEMU have the this exact problem at the moment? I know it puts
> Svadu in the max cpu, but does it enable the behaviour by default, even
> without the SBI implementation asking for it?

Yes, because QEMU has done hardware A/D updating since it first started
supporting riscv, which means it did svadu when neither svadu nor svade
were in the DT. The "fix" for that was to ensure we have svadu and !svade
by default, which means we've perfectly realized Alexandre's concern...
We should be able to change the named cpu types that don't support svadu
to only have svade in their DTs, since that would actually be fixing those
cpu types, but we'll need to discuss how to proceed with the generic cpu
types like 'max'.

> 
> Sorta on a related note, I'm completely going head-in-sand here for ACPI,
> cos I have no idea how that is being dealt with - other than that Linux
> assumes that all ACPI properties have the same meaning as the DT ones. I
> don't really think that that is sustainable, but it is what we are doing
> at present. Maybe I should put that in boot.rst or in acpi.rst?

Yes, I think that's what we're doing right now and documenting that
assumption is a good idea.

> 
> Also on the ACPI side of things, and I am going an uber devil's advocate
> here, the version of the spec that we documented as defining our parsing
> rules never mentions svade or svadu, so is it even valid to use them on
> ACPI systems?

I think that ISA string format chapter implies that any extension name
that is in the specified format can be parsed, which implies it can be
interpreted as an available extension, even if it's not mentioned in
the spec. But maybe I'm just pushing a big foot into a small shoe since
I don't really want to try and figure out how to get that chapter
changed...

Thanks,
drew

