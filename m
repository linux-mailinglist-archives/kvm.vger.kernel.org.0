Return-Path: <kvm+bounces-10302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC13A86B86D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:40:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBA261C2541D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EB3163A86;
	Wed, 28 Feb 2024 19:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKGfXarC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FBB34CDE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149097; cv=none; b=Mry57ydAbOYMLoBXxzFTZZU6wm/uL8YEiNI66wadJ+2hQ5biMAp/nYVKGE2WoSqF+DB9pSTrdzYa3C99fs9belI1EW0QuqiBrAtywpOj/LGLpRAaB9U5hnLV5NWyB2BuPvoYhkmFeshKdq63bnmTPzku5M1EDkkFN5mdNi361uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149097; c=relaxed/simple;
	bh=CXacfLZxd/QfNk37caUzTH5lHopeOn500HrfDvKWa+8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsN1pz6OH5YehdajcyT1KrrdraCFelpTdKARP/pf1HZHfeRb1ngY6onod/UPnDwF+2GjkYRFnO/f4YJoq4odQJHq/BO1Cy0y1aHaQUbzXH4ersg1oqGsGh4Ps0G9LHqBR40afr1IXc53MGUOZstyv9RTgfedSbmVfP0TBEb/MfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKGfXarC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709149094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uA20CDAKsgM4Tx3YYjgPKLshZVqnm4Ew1QkRNRKLdZo=;
	b=UKGfXarCbhjUiw8A6FNfr9s/+beoA2N4i0ENGV759ABFU4BgXxeXit4ESFhIWdwRszpbSo
	b4rEtyZBJmGILtflQxg75QiKD9yayn8Dy8RMNlUcfOm5ThRco6n3vUi1DPD+FclT0wWH8w
	bPZXbASSFaROdHPTBkSIaM/eK2Ds5KY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-JAA9aklTO0Oo-4W1YzcxxA-1; Wed, 28 Feb 2024 14:38:13 -0500
X-MC-Unique: JAA9aklTO0Oo-4W1YzcxxA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c78505a39eso5175439f.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709149092; x=1709753892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uA20CDAKsgM4Tx3YYjgPKLshZVqnm4Ew1QkRNRKLdZo=;
        b=NJY07+yCcrUv70UWHtjkfvpCnqpkfDNGV8MU0TCLzLlsKBX2lH4NMVsq+A5Jl9ow+S
         Bu7+5FjTxe+fAeN3zJYeqeBUaHf5GFmUJVeDL9NlZFmmpx9hkD6xTTgQv/euJpwGYuQh
         HvNPgOJ2u6gU4LXwzz1eFDa/rwJ66uoLTZ6BNnpCOVgImuRzQeumYm2Un6fBsH5HwMdE
         ZXok9AlJYjV9nVwl5At2958+mDvCLf+jwEbUvzC4SkJmumdkaNQDmcRPenBYkyjc2RYO
         4ajdAPkMLrq1g5BqU4kUFsXilKUxUGE/NRqh1IfELnQk1z7H97jISyCHuE4NzzWqQ1rA
         YpMg==
X-Forwarded-Encrypted: i=1; AJvYcCVgR+n7LFYILO1B+0QibRECvjKHzay4uO+sYW+Wl9a6ZuaksfLrRLHvfQ0OUqMl7L4bPObdQCLpc3ZPBz7giJtJxhL5
X-Gm-Message-State: AOJu0YzNFWSYwxjaLwvVc6o1CacaEVwM7TWsT0lJTWFoAkRucsTcSY8h
	bYvc/nXU8GBwkXehUNbXkmzXmm3CjmWEFQLPrbp71dvJbLjTwiqsOGW3S3hb4QsNZX3UkxPs1if
	2xx7T0iBm589HtokafSOXBdZQjIhtFGIuMpwd8UxXNZdC757dPA==
X-Received: by 2002:a05:6602:734:b0:7c7:687e:41ba with SMTP id g20-20020a056602073400b007c7687e41bamr163492iox.9.1709149092239;
        Wed, 28 Feb 2024 11:38:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLbkc9moMLuoOGq7o7bm+s7c1gRZdMUmGNufsCw5nAB2hYAZNgiuYz111J6g0/Tgm8/E8rCg==
X-Received: by 2002:a05:6602:734:b0:7c7:687e:41ba with SMTP id g20-20020a056602073400b007c7687e41bamr163467iox.9.1709149091853;
        Wed, 28 Feb 2024 11:38:11 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id cl10-20020a0566383d0a00b004741d55e66asm7810jab.84.2024.02.28.11.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 11:38:11 -0800 (PST)
Date: Wed, 28 Feb 2024 12:38:10 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Peter Delevoryas <peter@pjd.dev>
Cc: qemu-devel <qemu-devel@nongnu.org>, suravee.suthikulpanit@amd.com,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [q&a] Status of IOMMU virtualization for nested virtualization
 (userspace PCI drivers in VMs)
Message-ID: <20240228123810.70663da2.alex.williamson@redhat.com>
In-Reply-To: <3D96D76D-85D2-47B5-B4C1-D6F95061D7D6@pjd.dev>
References: <3D96D76D-85D2-47B5-B4C1-D6F95061D7D6@pjd.dev>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Feb 2024 10:29:32 -0800
Peter Delevoryas <peter@pjd.dev> wrote:

> Hey guys,
>=20
> I=E2=80=99m having a little trouble reading between the lines on various
> docs, mailing list threads, KVM presentations, github forks, etc, so
> I figured I=E2=80=99d just ask:
>=20
> What is the status of IOMMU virtualization, like in the case where I
> want a VM guest to have a virtual IOMMU?

It works fine for simply nested assignment scenarios, ie. guest
userspace drivers or nested VMs.
=20
> I found this great presentation from KVM Forum 2021: [1]
>=20
> 1. I=E2=80=99m using -device intel-iommu right now. This has performance
> implications and large DMA transfers hit the vfio_iommu_type1
> dma_entry_limit on the host because of how the mappings are made.

Hugepages for the guest and mappings within the guest should help both
the mapping performance and DMA entry limit.  In general the type1 vfio
IOMMU backend is not optimized for dynamic mapping, so performance-wise
your best bet is still to design the userspace driver for static DMA
buffers.
=20
> 2. -device virtio-iommu is an improvement, but it doesn=E2=80=99t seem
> compatible with -device vfio-pci? I was only able to test this with
> cloud-hypervisor, and it has a better vfio mapping pattern (avoids
> hitting dma_entry_limit).

AFAIK it's just growing pains, it should work but it's working through
bugs.

> 3. -object iommufd [2] I haven=E2=80=99t tried this quite yet, planning t=
o:
> if it=E2=80=99s using iommufd, and I have all the right kernel features in
> the guest and host, I assume it=E2=80=99s implementing the passthrough mo=
de
> that AMD has described in their talk? Because I imagine that would be
> the best solution for me, I=E2=80=99m just having trouble understanding if
> it=E2=80=99s actually related or orthogonal.

For now iommufd provides a similar DMA mapping interface to type1, but
it does remove the DMA entry limit and improves locked page accounting.

To really see a performance improvement relative to dynamic mappings,
you'll need nesting support in the IOMMU, which is under active
development.  From this aspect you will want iommufd since similar
features will not be provided by type1.  Thanks,

Alex


