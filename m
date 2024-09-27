Return-Path: <kvm+bounces-27635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AFE9888EB
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 18:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 401E01F214AF
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 16:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AE21C2420;
	Fri, 27 Sep 2024 16:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r7UAltnm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDE11C1AC9
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727453836; cv=none; b=Oh06v13ioxDA1r7+noosExBcTx2ORdPZvtv3uGHHBy1nuaDNQbMQjOx+VbwUGFwwHSaAwWse8TT7a9AGpU4j/PCkxQF6bVM1IihAs1JeoxO6VEUnZmah3kIEOb+l+L5gKVFinOjCcpeOIHAIs2xqoowAkeUr80NsHMb3wRIw1oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727453836; c=relaxed/simple;
	bh=IrmsNWrvHiijIwgsOGZldHTBszQqR9KLkth8sn+BUF4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=E8GgRzyoein/lQA9f99inHh5lIkOa2L6LeAlBnjvRr69XoLXfp7YJpuVpqdIrGfuzit3W3vBzfyrcYR/oxFetmgVd7ofPSO8Vj3tP4vfQ52Q/RZ0lWJbJ1oPKL19Jt1oPVyKrlltCnAvZ0yOoE47apGXG0ckVLbz7kgp5d+yZEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r7UAltnm; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4582a5b495cso253451cf.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 09:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727453834; x=1728058634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IrmsNWrvHiijIwgsOGZldHTBszQqR9KLkth8sn+BUF4=;
        b=r7UAltnmtQc+ee/E0uc69/TIZUWMsbnzTrHclz4ZoXcIwIzd+C8swIb4N5JuCArb89
         nwLj03ez5jxP1Ro2BPv7PU/1w4bAaJmy62tiMR4FgLiqvhixlgvF9sEKeVz3ywxfBR+0
         UJ/IldGTjydB38P/1Qq7A1F5NtjMeLOPsflGYPNPWbFREbTNHQnpmLT1AGdpVBjVViSE
         TukUDxtWDKdubWbfmEzk/hi/Oi2n/XKFo3SIhyr/724D5ym3o9rrXGGMiazFFmfwFqYT
         N/oEH/MiN6wdcoRRoqansg7H+D8d65O3j68rZ21za6qoqVUhR3a+AwaXdROUYZhofS+5
         Y5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727453834; x=1728058634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrmsNWrvHiijIwgsOGZldHTBszQqR9KLkth8sn+BUF4=;
        b=nYbpy5WUflktBd/KYO4iVIWKt0+8CdCkbzwRFBhqNNvKXDggkBt07qhgUhNRAjVzYP
         U53YHNPaRKYwFVcy4uH87qVUghB1YxV0NSaoaZXbQRANh9f2VLS2l9kmueqA+yZtOxtC
         JxToSjJOwwpDqNleYTlObb1rkG2OV52Vimuvme+cKWzvHOlNJ3VqQkqrGiRaXuI578X2
         X+eGH+9Vy5ztlRlTWLnzCNklP1krjq7MbrbiVCWuUbFe28ycJmL9xXzkh1FAFsQz0cMi
         AvMaYiSUPgPkLVjFi6KUSKH6XyQ9jTyfyxwJo3gr+IRlfXIWqv73nYfK9aSISEBVODf+
         FcgQ==
X-Gm-Message-State: AOJu0YzNwWRvZ14KWD3kuPvUG+Vh78MPPFLRq9Q5ifTbuNBHw5J3Zf5m
	JJqJNHj1MtCLP5bRt3Cgua3UygAckENHL17pUvhCYQM0p10UJb4eqdQPmQcIIW5UrvLFuhHRDRm
	9scUVNrvQki1NzDN++RqvNsHRF4KPVLleGqMNsWQp87OcQm6lPRTV
X-Google-Smtp-Source: AGHT+IF/EHyONOm6DGsdDw/xeeoLCpy0uibL0MWQ+Y2vArC8Yk7URe7f5FuII2AVFIYcDABJ9AomaCSbLH4fMYBcyag=
X-Received: by 2002:a05:622a:7913:b0:453:62ee:3fe with SMTP id
 d75a77b69052e-45ca1ad8c37mr2635581cf.17.1727453833916; Fri, 27 Sep 2024
 09:17:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 27 Sep 2024 17:17:02 +0100
Message-ID: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
Subject: [RFC] Simple device assignment with VFIO platform
To: kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	kwankhede@nvidia.com, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi All,

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I have been looking into assigning simple devices which are not DMA
capable to VMs on Android using VFIO platform.

I have been mainly looking with respect to Protected KVM (pKVM), which
would need some extra modifications mostly to KVM-VFIO, that is quite
early under prototyping at the moment, which have core pending pKVM
dependencies upstream as guest memfd[1] and IOMMUs support[2].

However, this problem is not pKVM(or KVM) specific, and about the
design of VFIO.

[1] https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.com/
[2] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@l=
inaro.org/

Problem
=3D=3D=3D=3D=3D=3D=3D
At the moment, VFIO platform will deny a device from probing (through
vfio_group_find_or_alloc()), if it=E2=80=99s not part of an IOMMU group,
unless (CONFIG_VFIO_NOIOMMU is configured)

As far as I understand the current solutions to pass through platform
devices that are not DMA capable are:
- Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
taints the kernel and this doesn=E2=80=99t actually fit the device descript=
ion
as the device doesn=E2=80=99t only have an IOMMU, but it=E2=80=99s not DMA =
capable at
all, so the kernel should be safe with assigning the device without
DMA isolation.

- Use VFIO mdev with an emulated IOMMU, this seems it could work. But
many of the code would be duplicate with the VFIO platform code as the
device is a platform device.

- Use UIO: Can map MMIO to userspace which seems to be focused for
userspace drivers rather than VM passthrough and I can=E2=80=99t find its
support in Qemu.

One other benefit from supporting this in VFIO platform, that we can
use the existing UAPI for platform devices (and support in VMMs)

Proposal
=3D=3D=3D=3D=3D=3D=3D=3D
Extend VFIO platform to allow assigning devices without an IOMMU, this
can be possibly done by
- Checking device capability from the platform bus (would be something
ACPI/OF specific similar to how it configures DMA from
platform_dma_configure(), we can add a new function something like
platfrom_dma_capable())

- Using emulated IOMMU for such devices
(vfio_register_emulated_iommu_dev()), instead of having intrusive
changes about IOMMUs existence.

If that makes sense I can work on RFC(I don=E2=80=99t have any code at the =
moment)

Thanks,
Mostafa

