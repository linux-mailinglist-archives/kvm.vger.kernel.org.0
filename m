Return-Path: <kvm+bounces-61182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C5BC0F3C2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7694442520B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D325A30C37A;
	Mon, 27 Oct 2025 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q7jVh1hI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B03830BF60
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581015; cv=none; b=u8rtFLCnie4bIRdD1U4F7oLgGJnoPASs3QxbiMLDbnitickObYowK1szZ30LmwN3PogiXscJVIyuqmLcW3NHDHP3YtoM8ig+O2lqmnflX+Rw6IHOsjGlsF3nXWRbPVMBVfQe5DJ0SXm6Ya4+gQOdP8EoE3/h9Rl4AntqAcU9SPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581015; c=relaxed/simple;
	bh=ZVvaHiYxclFoP0ltljuT+zJ+LK5kjIQ4V1Qoeu7vlhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jydas8wzT+TsEWOyo3Im6Wcy6KWPBd7+S3IzZJ3+moHckxMdsQBevvHMNPUG8AVn4GWtEo5tZ6Y2nc6cMrxud6+VvKB0vG4Di2rcJ2GHvaaNKYrP2N2bfEuScAw4aDxlfaZQwVZhw/toxWOq1BSyRDwXLkxM9hfiSv4ZKyRLvPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q7jVh1hI; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63e17c0fefbso5202624d50.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761581012; x=1762185812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RR5BznuAUZ5//5K4fKsbv/PX3i2neLhRixVpX04AB5M=;
        b=Q7jVh1hI5kWY6RECPSudlgRLBj1xNQy5pZMKZpS1C+Q+UtRYWK+76GxuicYAHa/CZ3
         gWImCbQcET/LArfrRAMxJM9s14slYgk3ShgelSG4aLK980Y6QsQa6S682zhS8ARAhKdJ
         Q+I/4NQLVBybFVLDlgSEhOrG3439+BjmVNOlgTetoRQTAxPWbQku9PA+iAPgquiXgCx1
         79CdhRkzLPASKezHY04Wg0LpeTDnJfSNn3jRTDCoi5sIGRNK3uwcmw+g67MwUG6wLxyu
         ox+bo1Wplv8h5PtSQi+NK+RO1aH2n/dzRmpPqaMHuVLreuu3kC8Npc0PurteV6waf1Lb
         yeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581012; x=1762185812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RR5BznuAUZ5//5K4fKsbv/PX3i2neLhRixVpX04AB5M=;
        b=WY/Hk2pnJN+Iy3M+BSiKx+Alv9DetTQH3bto89rHhNiY3huMpP8cToP1kZ75hN7VJ8
         9O4OsSIGnjmFDKZuu2pvoPvQXy4jtRMMYQXVnOtJHQIhoVIxzSxMeiTGGfHR/gkumoBF
         IZ+PYgke5lWdv5DPdw3GRl2NHeqKjybIrXMQbYyRwUx7zaEyTXvX22pIL/8Uj1QFHMa8
         d8QLaP+L85ToRbb9bOUBQgFoM4nNBlQFM+mcK1IN/1CYjyzAwAW94ggeuhDGBGyZp46J
         mzU89zm60vjNXaQto4zTvfZlW/2M805rnoNPgmYI3aBZflTddRXBMs+asrrGcQV27f3q
         y8sw==
X-Forwarded-Encrypted: i=1; AJvYcCV2nblEuvN1zniOsHXhgdaecvNyIMpYf+40WcbZIYAHvcpKl1plRbb9XfmQnmJ3B5tDpC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAP6wXi3kPQABrh7mAB/OaPKj7A5En2diQVcDdf0AsuPnxGP+4
	Xjm1q7qUmTHpk+8CQ7X6z6ZUk7Dknolyx7zXRl0vrrOgCjs9lqhaTJz0RXEn6BWn/on7aISdG1P
	K35T+6u9gdnzs724MKRC9/OLSdGagLaWQsWjx1zSO3A==
X-Gm-Gg: ASbGnct6d76WmyD3tt6fhvSRaCZpbwfYnK64cKs6EV8yQClEFyRWIbqmC1rtfh8nH0d
	T8griC25FoDQgBXzhRD0dHpxTNTQSlFchUefCvPaTVMnicue+2TyjfP8xabtLwfJPoOvBKA6fFM
	5jkoECwR9GGpXEL8RK2K3u01yltSTxA8fE8I+2Dj5E55TT7EXbjwaTMu71g1WfBcsvJqHdqldA+
	UKJ871GHfyqNMxAtIss58afshe5oTYrTZiaMnVVNpXVI6weqeWz20UB9lwtGOVoVybkg8aK
X-Google-Smtp-Source: AGHT+IEUrN/EysgI2nB2F9WdFzaJ1hhJHQ7VjfW/gyaI669aRQl1+Q6hp6c/yY+VSNAPuRW0/bPat1D3KnOCnNmBZY0=
X-Received: by 2002:a05:690e:c4f:b0:612:891a:9ecc with SMTP id
 956f58d0204a3-63f6b9b05b7mr479893d50.9.1761581011690; Mon, 27 Oct 2025
 09:03:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-4-mohamed@unpredictable.fr> <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
 <29E39B1C-40D3-4BBA-8B0B-C39594BA9B29@unpredictable.fr>
In-Reply-To: <29E39B1C-40D3-4BBA-8B0B-C39594BA9B29@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2025 16:03:19 +0000
X-Gm-Features: AWmQ_bky_gDkaMRbeQ688zuYHzvCneYcGVItHtc3zS3XRWMV3shJhZg-0iZCeos
Message-ID: <CAFEAcA93e6GL9agaCBZ2AabB21JrS6KS6MsbRHGPwdc_vj7xDQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/23] hw/arm: virt: add GICv2m for the case when ITS
 is not available
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Shannon Zhao <shannon.zhaosl@gmail.com>, 
	Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Mads Ynddal <mads@ynddal.dk>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Pedro Barbuda <pbarbuda@microsoft.com>, 
	Alexander Graf <agraf@csgraf.de>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Oct 2025 at 05:30, Mohamed Mediouni <mohamed@unpredictable.fr> wr=
ote:
>
>
>
> > On 25. Sep 2025, at 18:24, Peter Maydell <peter.maydell@linaro.org> wro=
te:
> >
> > On Sat, 20 Sept 2025 at 15:02, Mohamed Mediouni
> > <mohamed@unpredictable.fr> wrote:
> >>
> >> On Hypervisor.framework for macOS and WHPX for Windows, the provided e=
nvironment is a GICv3 without ITS.
> >>
> >> As such, support a GICv3 w/ GICv2m for that scenario.
> >>
> >> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> >>
> >> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> >> ---
> >> hw/arm/virt-acpi-build.c | 4 +++-
> >> hw/arm/virt.c            | 8 ++++++++
> >> include/hw/arm/virt.h    | 2 ++
> >> 3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > Looking at this I find myself wondering whether we need the
> > old-version back compat handling. The cases I think we have
> > at the moment are:
> >
> > (1) TCG, virt-6.1 and earlier: no_tcg_its is set
> >   -- you can have a gicv2 (always with a gicv2m)
> >   -- if you specify gic-version=3D3 you get a GICv3 without ITS
> > (2) TCG, virt-6.2 and later:
> >   -- gic-version=3D2 still has gicv2m
> >   -- gic-version=3D3 by default gives you an ITS; if you also
> >      say its=3Doff you get GICv3 with no ITS
> >   -- there is no case where we provide a GICv3 and are
> >      unable to provide an ITS for it
> > (3) KVM (any version):
> >   -- gic-version=3D2 has a gicv2m
> >   -- gic-version=3D3 gives you an ITS by default; its=3Doff
> >      will remove it
> >   -- there is no case where we provide a GICv3 and are
> >      unable to provide an ITS for it
> > (4) HVF:
> >   -- only gic-version=3D2 works, you get a gicv2m
> >
> > and I think what we want is:
> > (a) if you explicitly disable the ITS (with its=3Doff or via
> >     no_tcg_its) you get no ITS (and no gicv2m)
> > (b) if you explicitly enable the ITS you should get an
> >     actual ITS or an error message
> > (c) the default should be its=3Dauto which gives
> >     you "ITS if we can, gicv2m if we can't".
> >     This is repurposing the its=3D property as "message signaled
> >     interrupt support", which is a little bit of a hack
> >     but I think OK if we're clear about it in the docs.
> >     (We could rename the property to "msi=3D(off,its,gicv2m,auto)"
> >     with back-compat support for "its=3D" but I don't know if
> >     that's worth the effort.)
> >
> > And then that doesn't need any back-compat handling for pre-10.2
> > machine types or a "no_gicv3_with_gicv2m" flag, because for
> > 10.1 and earlier there is no case that currently works and
> > which falls into category (c) and which doesn't give you an ITS.
> > (because we don't yet have hvf gicv3 implemented: that's a new
> > feature that never worked in 10.1.)
> >
> > What do you think?
>
> Would it be wanted to provide MSI-X support in all scenarios
> even with its=3Doff?

We should prefer to provide MSI-X support. If the user
explicitly asks for a config that doesn't give MSI-X
support, that's their choice to make.

> And there=E2=80=99s the consequence of that making GICv3 + GICv2m only
> testable with auto and not with TCG or kvm, which doesn=E2=80=99t sound i=
deal.

I guess that would be an argument for the "give the property
the right name so we can say "msi=3D(off,its,gicv2m,auto)". Then
you could say
 -accel tcg -machine gic-version=3D3,msi=3Dgicv2m

to test that setup.

thanks
-- PMM

