Return-Path: <kvm+bounces-67453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0F7D05890
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F16930C1A5B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AD1317709;
	Thu,  8 Jan 2026 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H6Ok2PmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B69314A82
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767896691; cv=none; b=YFJjFog9O4Zv8KBaIxiKaRXNUPTyaxs9GQeew7Mh77dkrWwyI0cKUSLAwzo+DuPVdeOOx2XGGnT3PSiNcLswfdUJ1B0erVgsFIiwjP34fwAPFyjbDpEEGVsSwGQ7Yo6txW/xz3HCouQqfgbi2t3qp9o1A1pV0s1HT195VaRmlRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767896691; c=relaxed/simple;
	bh=Yp1h0ShDtcp2z0mVyzIJRFEUAtO9kdhPaqPpEWqAtrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fy2HmFZoC4P1JieR5fD2HTPuy0nF2QOmfrfaYiuyYGsuQI5Kxorbz0LUDJigubHfmSwYzhcLkfMqmgnwfGgZ7gcrc/SJf+lJyKbdshHjueWOp6rm5pYuUUMAFFRcMunnaWFK5eLBZRN3jgz7Tqg9uWT4xcOSTF7+Xgn89VFLI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H6Ok2PmZ; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b6c13b68dso1789814e87.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 10:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767896688; x=1768501488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEaeafC3oyzxJQrMc13kCHPb+WuLGIIxoGgEqXi6BFw=;
        b=H6Ok2PmZ6u1oLSeNBgS9vKkOSl+qiUDrxXkdl9dfNSL/+GRXsK06ZLmBGZPUIdd3TG
         hgNGulKbj8u6EosI8SumHD61OmlDJ6Zylb86rRaWj6JGkvPWB2n3EpKpm6GOVzA1a8+P
         LEMFvhXh/ILGC4O6+mU4yJyx5uRtgs4A3hl2ZurDhnFDzBZ5zpzu9LRtIVx8fb0g3p4Z
         9NByFEA5kehf/p2jQbdkAc4hAhy8m7T4C3BrPQLUqzs4SPaIvh8cPmiPpLUctd7l6Kqm
         tLb71iFHezrfv5uC3NdoDKbgp9Qo1iU+5XGKhdYPYsYA/HRceWI6Qwd5A4TIm4/Ov+RP
         KhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767896688; x=1768501488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MEaeafC3oyzxJQrMc13kCHPb+WuLGIIxoGgEqXi6BFw=;
        b=eOY7txxHV2OD49KixXDsqbz8iGNAvLd2zOwhBoSwaBI8ZaXES55oOykl1ig6wUYSGr
         6iODZXCaVoSAMUtqKL/48d0Ywis77TpXWyrm9VlGYuUa/q/CB+4dMDlsCD5ucH8eVIrZ
         kctItx074H99efeiFs4q7fCCUjGg5ggqU1heSO2vKS+OmBr8Q1ag0CNnnuMcRqALmvm/
         8qD/ZkqPyeoFbICKO0rvgyWafcxuRfCRMSuJdjLjXn+wE2XtVwVCSoWgv3PjBhKHc8oq
         X2U2BD/op9MvBA2OLvPYi2OvIlOZaPLmUENF/nNeQsSpT0I01wLyf7Pbo64JqW8DVrew
         XkQw==
X-Forwarded-Encrypted: i=1; AJvYcCUhiD318/JmPHPfujndrTOERkXxrOLZw3rzDs7KGqkdKF0dyWN8tRHc+NFbkjFPiT8YrOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8P6F+RHgx4ilCb9zwti6r9n3HdQ43sy71r60HpfaogrvY0eRF
	60PQoWjwEU/opafhKB0RSqoHO7s2r86YgVwnupXJNGV6HoLN3ON3PpB1pSTmolzofb4uMEBWNLA
	KoDmMVJ+iVwJExSlBVB5ZsZg/NARRhViNWgL9vdU3
X-Gm-Gg: AY/fxX7xsJKRny5nGFebQwPuJK4p8q7hdYECwoHkebfetSIJqyMZpAdDn6BCQdZEEZ3
	gyZhervvuj6g8QgpuudNDQGwu2Wpe996LgwhpFK37o3pF73C7m4kBxqJyPjU+LGqL/B4R9y/kK6
	Hf8lf71o8LAVuiGABao1LoPiC0yUfdXG4moRhxNUPRw5W4rWmCFUPrvg4c89TyQD/CGd6g19Yqz
	3e69HxZuphkqsc8LExjub23SA7rkOHUQH+1Trac2gjiB2CjfaS9xNG5xhsUeYZFXr8mB+1C
X-Google-Smtp-Source: AGHT+IFtMz6GROOKtW9V1iTBDgix+z99mKh9kThC0ibIi//b6X45bMcaqCLXOawEVpN0roGzuqsJrJ3dGuOMoWOS/cA=
X-Received: by 2002:a05:6512:3ba7:b0:595:9195:338f with SMTP id
 2adb3069b0e04-59b6eb6b29dmr2258176e87.23.1767896687563; Thu, 08 Jan 2026
 10:24:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com> <20260108005406.GA545276@ziepe.ca>
 <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com> <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org>
In-Reply-To: <20260108084514.1d5e3ee3@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Thu, 8 Jan 2026 10:24:19 -0800
X-Gm-Features: AQt7F2rl1aiP8y-Yssi9VxM__CrmPHsLRpNi7eWG5qSqXK_YQL01rHTPKU4a2KE
Message-ID: <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
To: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Alex Mastro <amastro@fb.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 7:45=E2=80=AFAM Alex Williamson <alex@shazbot.org> w=
rote:
>
> On Thu, 8 Jan 2026 10:10:44 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> > On Wed, Jan 07, 2026 at 06:41:10PM -0800, Alex Mastro wrote:
> > > On Wed, Jan 07, 2026 at 08:54:06PM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Jan 07, 2026 at 11:54:09PM +0000, David Matlack wrote:
> > > > > On 2026-01-07 02:13 PM, Alex Mastro wrote:
> > > > > > Test MMIO-backed DMA mappings by iommu_map()-ing mmap'ed BAR re=
gions.
> > > > >
> > > > > Thanks for adding this!
> > > > >
> > > > > > Also update vfio_pci_bar_map() to align BAR mmaps for efficient=
 huge
> > > > > > page mappings.
> > > > > >
> > > > > > Only vfio_type1 variants are tested; iommufd variants can be ad=
ded
> > > > > > once kernel support lands.
> > > > >
> > > > > Are there plans to support mapping BARs via virtual address in io=
mmufd?
> > > > > I thought the plan was only to support via dma-bufs. Maybe Jason =
can
> > > > > confirm.
> > > >
> > > > Only dmabuf.
> > >
> > > Ack. I got confused. I had thought iommufd's vfio container compatibi=
lity mode
> > > was going to support this, but realized that doesn't make sense given=
 past
> > > discussions about the pitfalls of achieving these mappings the legacy=
 way.
> >
> > Oh, I was thinking about a compatability only flow only in the type 1
> > emulation that internally magically converts a VMA to a dmabuf, but I
> > haven't written anything.. It is a bit tricky and the type 1 emulation
> > has not been as popular as I expected??
>
> In part because of this gap, I'd guess.  Thanks,

Lack of huge mappings in the IOMMU when using VFIO_TYPE1_IOMMU is
another gap I'm aware of.
vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
fails when IOMMUFD_VFIO_CONTAINER is enabled.

Is the plan to address all the gaps so IOMMUFD_VFIO_CONTAINER can be
made the default and the type1 code can be dropped from the upstream
kernel?

