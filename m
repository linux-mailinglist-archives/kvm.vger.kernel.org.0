Return-Path: <kvm+bounces-28083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E916E9938E1
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 23:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69BC4B22B1A
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 21:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8751DE8A6;
	Mon,  7 Oct 2024 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD0tHaXw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21884184551
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 21:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335804; cv=none; b=DGjdjjRXVWdt7REB54BxsRF2rX8FcYdK6uQuhCfU1GpPsmGRrkRIySsn++xjR7GvtO27FIfqWUcIHo1eQzBFxEmewW9YddBeQ2fX4aL7xUG0CcnWNydG415tC+mFN9EQS8QYxY5yic3D1VTMowbINFUjSO/A6J07bAn95jMmnxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335804; c=relaxed/simple;
	bh=T23NdLk7nLwLjMS2KpZEUNefYvsVCeD2ePe5V3texQI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tthmkOlsDak7pii/d6rXLkuPD9DBvfBARD9469EAKkqzCBlJ0b1bSesKJWIXWT7uc3t3vUoavM/1Sdz7xzalBsr1ZxZVrRGMQgT4omh8sMYQQ4jbsBqdBOo0AWWvW6UioJyjKwC9ByiFTKrBpkUgZrnfZV2d8tt2yU8O1AF0XL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD0tHaXw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728335800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gBzyWaEn/OK2cI5KVVYA0Y+sukKCzI9OslG4INiHzZU=;
	b=JD0tHaXwXjKBMkTAtIeLB/8FoImKvZk3yRVGSoYWcIIyfhoXBv8jNHodzelO3Qw1YcN0DP
	Rg+kGc1FFzOi+Q9CPLAzmf7DDyW1CF3Ok6sXfctphREeZmf1akTj7t2QvkS9vln96LbFMt
	Aq6JzVOC+8hss3MoXiGoTEZ1Im/anGA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-m1qTe49gPx-TC0kctSx_bw-1; Mon, 07 Oct 2024 17:16:39 -0400
X-MC-Unique: m1qTe49gPx-TC0kctSx_bw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a348d333fdso3650225ab.3
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 14:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728335798; x=1728940598;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gBzyWaEn/OK2cI5KVVYA0Y+sukKCzI9OslG4INiHzZU=;
        b=aJyKbGWzBobWMe4jPYgRoObuJYGKjAPfD4oDVnqskcRqTZgeC2B60kQBfHbVLuCsLF
         2oZeUBtAnCcSZO4CCG2RHmrsfUWRa497a0VdozQYObsjoCprLurV6iM0P8fFhaoi3M24
         XKerbX1i5JVDX9Jsyp1EhwDYGgC54rd5ZQv+k4KAw6XDvfFLAU91zVse76g+3wU3tXI+
         x5c5zhvfHqM3PYmbABf6j15UVzNDcztrQXDAhHuIlg8TbL452gaNSnOE2las4JjeD9GT
         Ou5BnlPE7D+klVIw6teZmWdMfcO71rTdBOm1LVV60nqofZjckfkz5e3lwOeys/ByLUqM
         FrRg==
X-Forwarded-Encrypted: i=1; AJvYcCUt2LakC7w6xYoHj9ioDCe8bny/hbmFtvybDEsSLf97ekeX92FlwH/4RPpFRsAzujc/KPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGpK17H0bFiClCx5NKlpJiL9kKhJRJcYbm+Chlug3enwasldVB
	Kx8KQwEbWP41eFD+224iaP/8KHhGLEyYOmMnWzPTzxmITooVP86j3/QPtzH4LKjfQ+NefrKDpNM
	eKB0LQ0J22At21PHST2r/1ifP7ihAhnpijc7X3bayZV4hHAc1yg==
X-Received: by 2002:a05:6e02:152f:b0:3a0:9cd5:9326 with SMTP id e9e14a558f8ab-3a3759882e8mr31325505ab.2.1728335798657;
        Mon, 07 Oct 2024 14:16:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdAY/Kd9sfwg64e4Ro90s+2tyY71jBLT8uvyJh2cFDgohe038sSTabpAcJxrFpMCcijXLcKA==
X-Received: by 2002:a05:6e02:152f:b0:3a0:9cd5:9326 with SMTP id e9e14a558f8ab-3a3759882e8mr31325415ab.2.1728335798292;
        Mon, 07 Oct 2024 14:16:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db7db303besm973958173.107.2024.10.07.14.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 14:16:37 -0700 (PDT)
Date: Mon, 7 Oct 2024 15:16:35 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
 <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)"
 <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Message-ID: <20241007151635.49d8bc30.alex.williamson@redhat.com>
In-Reply-To: <SA1PR12MB719900B3D33516703874CF11B07D2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
 <20241007081913.74b3deed.alex.williamson@redhat.com>
 <SA1PR12MB719900B3D33516703874CF11B07D2@SA1PR12MB7199.namprd12.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Oct 2024 16:37:12 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >>
> >> NVIDIA's recently introduced Grace Blackwell (GB) Superchip in
> >> continuation with the Grace Hopper (GH) superchip that provides a
> >> cache coherent access to CPU and GPU to each other's memory with
> >> an internal proprietary chip-to-chip (C2C) cache coherent interconnect.
> >> The in-tree nvgrace-gpu driver manages the GH devices. The intention
> >> is to extend the support to the new Grace Blackwell boards. =20
> >
> > Where do we stand on QEMU enablement of GH, or the GB support here?
> > IIRC, the nvgrace-gpu variant driver was initially proposed with QEMU
> > being the means through which the community could make use of this
> > driver, but there seem to be a number of pieces missing for that
> > support.=C2=A0 Thanks,
> >=20
> > Alex =20
>=20
> Hi Alex, the Qemu enablement changes for GH is already in Qemu 9.0.
> This is the Generic initiator change that got merged:
> https://lore.kernel.org/all/20240308145525.10886-1-ankita@nvidia.com/
>=20
> The missing pieces are actually in the kvm/kernel viz:
> 1. KVM need to map the device memory as Normal. The KVM patch was
> proposed here. This patch need refresh to address the suggestions:
> https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> 2. ECC handling series for the GPU device memory that is remap_pfn_range()
> mapped: https://lore.kernel.org/all/20231123003513.24292-1-ankita@nvidia.=
com/
>=20
> With those changes, the GH would be functional with the Qemu 9.0.

Sure, unless we note that those series were posted a year ago, which
makes it much harder to claim that we're actively enabling upstream
testing for this driver that we're now trying to extend to new
hardware.  Thanks,

Alex

> We discovered a separate Qemu issue while doing verification of Grace Bla=
ckwell,
> where the 512G of highmem proved short here:
> https://github.com/qemu/qemu/blob/v9.0.0/hw/arm/virt.c#L211
> We are planning to have a proposal for the fix floated for that.
>=20
> Thanks
> Ankit Agrawal
>=20


