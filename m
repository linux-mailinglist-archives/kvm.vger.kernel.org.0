Return-Path: <kvm+bounces-25065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C40D695F83D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B72A282BBA
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 17:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7491991B0;
	Mon, 26 Aug 2024 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7J4EQRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9231990C3
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724693834; cv=none; b=OeKXaJID6SNFPVhes4aAdTaHKOjw08hPwI65xC95C1nsog9Xgc6/C8W2VPHGtX0ky8xfW6NiwdCe4a5vokHOPx0NG8I1y6Xjfz5H5hOFR+rxYmpLdMiBOehzXl/D9oRhXCrAE8ONJC4de8zWVkFB0VvFwDVech2wggcBaroq/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724693834; c=relaxed/simple;
	bh=xHmiRNhRRt9eYiRt79QCeyN/h+W2Ra8rJ3ocE5z49V4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLHDdHP8BNWhOZ3fkdRIm5EwKSCGAZu3XGA8PUaNw0DTP3ovcc+s6zetvLUPjH/x+dAwywGyPhR+yrABPbNF8f/mYtxlierfP+Qt3xTN4R1/ziCC50hbtqXzZGtCf2ck0CgZ13Q9BpbasGISgDYe1OhQm7TwAIfJE8UFh4HdqnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7J4EQRO; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39d2a107aebso15965ab.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724693832; x=1725298632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oh0j8JVhDYlydZMkUx8RVg1JAsfs2sLF6/GwVKf9xvs=;
        b=s7J4EQROjtzIKlFOPp601TI4tIz9wUO/Ch7CDGRUItLsBt9AS08almsAY0r/A4D7IV
         uiz6BjY0bqVo/ZWiYedH2rNFoU4Wzp2bEUNtNsCk6OqZK2JJ074qIYo+4AisRPTyaZDA
         yv2yDeuGtkVkPZI6+GAYthvDNKntr09K6T+QGOy4OREEFnEsfuVnzBRQxNFzbEKXhkiJ
         RTvWf+z2YREl8LCYmNd/SEtm6PEn3PPtYIsJA22ga/ECpiRh634TSi2on6/Y6+kKHpLO
         Nr2PhVjv7NuhP8LU9aoWtpxvQjRsM+1kdB9+HcGrnbSTqd2HZygzU9C0Mxooqn8gLWzO
         PVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724693832; x=1725298632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oh0j8JVhDYlydZMkUx8RVg1JAsfs2sLF6/GwVKf9xvs=;
        b=M+ePdn5yes6/IfoukmSCKTUc8vw52My7Xggp2hjowNZ2rYea+shVjvmHufMQCiGGMz
         BSLJxBAowL9/05xpWROWBufql9zvSInibSpZhoxkOtnJHMyVlPyPnCjLSXo2E9Q8Vkto
         s6uDHmLI80oaKD3bdPod+1pJ4oxVKMv4ggt5hCdFbMaOS+NpvikMlJ+pAgfT/svczBYp
         Ik7HzB5kBTL1DJzrQ44fFoJWrZpGORLTc6cYNA3T5CsEW+Xa9vuyCjia2YrpxksBQjsS
         L4LiNDOfBinhpB+OmEJ/NBDQrlCaKgwXpmhJyiNagqelo3VCUL+/LdZOKLQdsW/KMCN+
         +7+g==
X-Forwarded-Encrypted: i=1; AJvYcCU+E6eTKlmMbkixSvBIbEfaODjHUJ3duW0kb/Y1X4qUxxn16ZDl6BogvDXPLFu67l5oqx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbwlRX4CBnazmsiy3zcwQPf/OLDPHspfVJHFPFpJDUwj9GuyT
	x+5dw4edhos7Vc5KbAM+0zacvRyC9ESfuiS6Rp5DvIPjCkCYGH7B7QgZaqG89LRERw3INwjDVpv
	tckT+Dqa2ijf2Zqkg9Fax8wJUqpHX1IFFZ91d
X-Google-Smtp-Source: AGHT+IHDJn2W5sA7BZSuEiAztVMwpsekZ9JYmxVAxVceAMBd/f24sCJ4Q/dzJtDHxuQfgyQ6VwJ8096tyWLH+0vkxGw=
X-Received: by 2002:a92:c24d:0:b0:39a:f2f4:7ec1 with SMTP id
 e9e14a558f8ab-39e64de00d4mr36645ab.20.1724693831406; Mon, 26 Aug 2024
 10:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com> <20240826110447.6522e0a7.alex.williamson@redhat.com>
In-Reply-To: <20240826110447.6522e0a7.alex.williamson@redhat.com>
From: Manoj Vishwanathan <manojvishy@google.com>
Date: Mon, 26 Aug 2024 10:36:58 -0700
Message-ID: <CA+M8utOvUr3LrWhTNtcBhRAsOB-ST8kKWJN4u_0eNCcWLihH4w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] vfio/iommu: Flag to allow userspace to set DMA
 buffers system cacheable
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 10:04=E2=80=AFAM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Mon, 26 Aug 2024 07:16:37 +0000
> Manoj Vishwanathan <manojvishy@google.com> wrote:
>
> > Hi maintainers,
> >
> > This RFC patch introduces the ability for userspace to control whether
> > device (DMA) buffers are marked as cacheable, enabling them to utilize
> > the system-level cache.
> >
> > The specific changes made in this patch are:
> >
> > * Introduce a new flag in `include/linux/iommu.h`:
> >     * `IOMMU_SYS_CACHE` -  Indicates if the associated page should be c=
ached in the system's cache hierarchy.
> > * Add `VFIO_DMA_MAP_FLAG_SYS_CACHE` to `include/uapi/linux/vfio.h`:
> >     * Allows userspace to set the cacheable attribute to PTE when mappi=
ng DMA regions using the VFIO interface.
> > * Update `vfio_iommu_type1.c`:
> >     * Handle the `VFIO_DMA_MAP_FLAG_SYS_CACHE` flag during DMA mapping =
operations.
> >     * Set the `IOMMU_SYS_CACHE` flag in the IOMMU page table entry if
> > the `VFIO_DMA_MAP_FLAG_SYS_CACHE` is set.
>
> We intend to eventually drop vfio type1 in favor of using IOMMUFD,
> therefore all new type1 features need to first be available in IOMMUFD.
> Once there we may consider use cases for providing the feature in the
> legacy type1 interface and the IOMMUFD compatibility interface.  Thanks,
>
> Alex
Thank You, Alex! I will redirect this patch to iommufd in the next version.
> > * arm/smmu/io-pgtable-arm: Set the MAIR for SYS_CACHE
> >
> > The reasoning behind these changes is to provide userspace with
> > finer-grained control over memory access patterns for devices,
> > potentially improving performance in scenarios where caching is
> > beneficial. We saw in some of the use cases where the buffers were
> > for transient data ( in and out without processing).
> >
> > I have tested this patch on certain arm64 machines and observed the
> > following:
> >
> > * There is 14-21% improvement in jitter measurements, where the
> > buffer on System Level Cache vs DDR buffers
> > * There was not much of an improvement in latency in the diration of
> > the tests that I have tried.
> >
> > I am open to feedback and suggestions for further improvements.
> > Please let me know if you have any questions or concerns. Also, I am
> > working on adding a check in the VFIO layer to ensure that if there
> > is no architecture supported implementation for sys cache, if should
> > not apply them.
> >
> > Thanks,
> > Manoj Vishwanathan
> >
> > Manoj Vishwanathan (4):
> >   iommu: Add IOMMU_SYS_CACHE flag for system cache control
> >   iommu/io-pgtable-arm: Force outer cache for page-level MAIR via user
> >     flag
> >   vfio: Add VFIO_DMA_MAP_FLAG_SYS_CACHE to control device access to
> >     system cache
> >   vfio/type1: Add support for VFIO_DMA_MAP_FLAG_SYS_CACHE
> >
> >  drivers/iommu/io-pgtable-arm.c  | 3 +++
> >  drivers/vfio/vfio_iommu_type1.c | 5 +++--
> >  include/linux/iommu.h           | 6 ++++++
> >  include/uapi/linux/vfio.h       | 1 +
> >  4 files changed, 13 insertions(+), 2 deletions(-)
> >
>

