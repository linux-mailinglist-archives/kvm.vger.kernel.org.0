Return-Path: <kvm+bounces-27761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B12FF98B88F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03BE6B2324D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 09:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E1619F469;
	Tue,  1 Oct 2024 09:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4QkkBCtL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3165019D09A
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727775868; cv=none; b=VNMfjyJVV8Ki9Rqr3Ih0xaE0fKx+RTc1K0RzsXQGBsW/Pkb0gJ7nY4Zcl/EaSK/n/s4u1o09fJMcGdTvg/vKOymc8rTjOIAp/fu58hlUhp6YrxiAAgRaZxgJpMMULbR0nDIF1Eust1/mUf58KWMLNx3DYd87Rz6aWRI9zcoCXwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727775868; c=relaxed/simple;
	bh=hT6Va8n00QYvhUMGDGcyawhunV6nIzrr0jRTKYg5JW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LzkGAijx8H4PCUN76EtYjl4Gv4tQh14hOP/I4SLTcDuCZJrdbOEDP05AlwMcx67XwlxSsmfZwyxChiZJBzeUv18BBfL9847y7sTuPbsVhNMqszwUggWEHpPvbtFJB2gOMszjx922/5Gaa6+zf2Z7YJGibg/VXKvSVmXUgDZLLpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4QkkBCtL; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4582a5b495cso174481cf.1
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 02:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727775866; x=1728380666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hT6Va8n00QYvhUMGDGcyawhunV6nIzrr0jRTKYg5JW4=;
        b=4QkkBCtL+q/Ruw1n+ZpFURpSGAIwdwZbG/MK+Ay2rHi423KDiqQvi/hmR4KdeXUvYZ
         z3CC74lOroZR/k7KtwFDJx+C7J9621oU5zR1R1NKmvjIBn3/AE+CuDhq4CdjqINCeS8J
         Mv+x8+iMeRWBaM205mi5zyWcfG9GRYlXu5FwqLMlPCNd+E9AAdIfYB8ljCnPWyM/tzB0
         3XhfT+QV43ayDSLGLPCqwXKg8pGVuFlgVXK/bZ3T2bWJZ1NI6ZJwEN2YqdRgOrbagvcF
         EQclLweAbjgZHfPmNTojgaeEBvNYA6NgDoiZhfIj9/pHXgntmBV5BSBRaYDusmH6mvm/
         DjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727775866; x=1728380666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hT6Va8n00QYvhUMGDGcyawhunV6nIzrr0jRTKYg5JW4=;
        b=Yvlxl3igaDHQAN5UuPI2h91ao/5Imy62c8gDmhboPjnZwwFT8GW6tS2iJ/J1p5USAE
         Qu459J7meEWEwwk8MqyMaWPaRqZJMR7uLDBIdcgeFyv9wzJjobceSf11N0llAxTfXaeu
         6/SvCy2XTH5+UeUe5ILDHlo3xKFbyWXV0+SQjgkwc2CGJavnc/lIPsPOj65aidHNVVem
         CwbNHVCM9P0zLxjjQqai9IhUful1QRfr5EK0gmAkT98sel9CRaEvep35lFzTK2sy0ZSc
         DkA9olgyDwE27CSPzpzTZn6fvki3W/lrUhSSY2vSdSYlbpc3bmuUprl8Obv90hXgbn4U
         83XQ==
X-Gm-Message-State: AOJu0YxazUrmDsKrydkKXt54zNApDbkMfYgvVFDh/PbBLaZQjFt68zjW
	Qx+J9BJfmMMQDnWKOa103mevMszxxkDcAYg9x12drzmOWUa3F86XI39CJ+T2WTdA8O28hjnNlhs
	GL+7LYZHU/JljxYGm/6XUepIYj1TUo4KktWKN
X-Google-Smtp-Source: AGHT+IFvBm2NLBsFvPAGSXZxpOfyRxHAJr6hVtUV9A7z9SjmTIFRbZiZcXUhtG22XnGwcN1QHaE17CidxApFXSLj+5E=
X-Received: by 2002:a05:622a:46cb:b0:44f:e2c1:cc75 with SMTP id
 d75a77b69052e-45d7488f11dmr3351531cf.8.1727775865855; Tue, 01 Oct 2024
 02:44:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
 <0e87a96a-98ed-48ad-9235-900d46fe5400@redhat.com>
In-Reply-To: <0e87a96a-98ed-48ad-9235-900d46fe5400@redhat.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 1 Oct 2024 10:44:14 +0100
Message-ID: <CAFgf54pAeUeinO6XfQ5tYSSkHmcHVncEnpA2+n9MMwQmEW4ucg@mail.gmail.com>
Subject: Re: [RFC] Simple device assignment with VFIO platform
To: eric.auger@redhat.com
Cc: kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, kwankhede@nvidia.com, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 2:05=E2=80=AFPM Eric Auger <eric.auger@redhat.com> =
wrote:
>
> Hi Mostafa,
>
> On 9/27/24 18:17, Mostafa Saleh wrote:
> > Hi All,
> >
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > I have been looking into assigning simple devices which are not DMA
> > capable to VMs on Android using VFIO platform.
> >
> > I have been mainly looking with respect to Protected KVM (pKVM), which
> > would need some extra modifications mostly to KVM-VFIO, that is quite
> > early under prototyping at the moment, which have core pending pKVM
> > dependencies upstream as guest memfd[1] and IOMMUs support[2].
> >
> > However, this problem is not pKVM(or KVM) specific, and about the
> > design of VFIO.
> >
> > [1] https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.c=
om/
> > [2] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philip=
pe@linaro.org/
> >
> > Problem
> > =3D=3D=3D=3D=3D=3D=3D
> > At the moment, VFIO platform will deny a device from probing (through
> > vfio_group_find_or_alloc()), if it=E2=80=99s not part of an IOMMU group=
,
> > unless (CONFIG_VFIO_NOIOMMU is configured)
> >
> > As far as I understand the current solutions to pass through platform
> > devices that are not DMA capable are:
> > - Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
> > taints the kernel and this doesn=E2=80=99t actually fit the device desc=
ription
> > as the device doesn=E2=80=99t only have an IOMMU, but it=E2=80=99s not =
DMA capable at
> > all, so the kernel should be safe with assigning the device without
> > DMA isolation.
> >
> > - Use VFIO mdev with an emulated IOMMU, this seems it could work. But
> > many of the code would be duplicate with the VFIO platform code as the
> > device is a platform device.
> >
> > - Use UIO: Can map MMIO to userspace which seems to be focused for
> > userspace drivers rather than VM passthrough and I can=E2=80=99t find i=
ts
> > support in Qemu.
> In case you did not have this reference, you may have a look at Alex'
> reply in
> https://patchew.org/QEMU/1518189456-2873-1-git-send-email-geert+renesas@g=
lider.be/1518189456-2873-5-git-send-email-geert+renesas@glider.be/

Sorry I missed that in the last reply, I see, it seems VFIO-platform
is not the right place for this.

Thanks,
Mostafa

> >
> > One other benefit from supporting this in VFIO platform, that we can
> > use the existing UAPI for platform devices (and support in VMMs)
> >
> > Proposal
> > =3D=3D=3D=3D=3D=3D=3D=3D
> > Extend VFIO platform to allow assigning devices without an IOMMU, this
> > can be possibly done by
> > - Checking device capability from the platform bus (would be something
> > ACPI/OF specific similar to how it configures DMA from
> > platform_dma_configure(), we can add a new function something like
> > platfrom_dma_capable())
> >
> > - Using emulated IOMMU for such devices
> > (vfio_register_emulated_iommu_dev()), instead of having intrusive
> > changes about IOMMUs existence.
> >
> > If that makes sense I can work on RFC(I don=E2=80=99t have any code at =
the moment)
> So if I understand correctly, assuming you are able to safely detect the
> device is not DMA capable you would use the
>
> vfio_register_emulated_iommu_dev() trick. Is that correct?
>
> Thanks
>
> Eric
>
> >
> > Thanks,
> > Mostafa
> >
>

