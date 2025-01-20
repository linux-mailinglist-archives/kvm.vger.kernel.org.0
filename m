Return-Path: <kvm+bounces-35932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27264A16592
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 04:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5254516626E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 03:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39861182BC;
	Mon, 20 Jan 2025 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1xSZA1u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858CE4D5AB
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 03:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737342761; cv=none; b=YGI/vl2UZSiYpSz8R4WyBkxS4Sjp8fBzydPyWJW9ig95A/axZqoBAZzKnsBEfXRn5xQlz1m2hBWqtlUWduA9EQ/7mSZxukFdEWoGapei3Q9Vs7yDc2jn4gYy/6sui2YUZuRuXGBBriYDa6MgWliZcC4NeV8zZ/aNVJmbs4+z0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737342761; c=relaxed/simple;
	bh=tq7myIfl3TcZgZZJ3sRivpjIxH2CZKY8mwVTxxhjyPk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zif6Ni8LU/dIAcIk3PM2rfLZKZXsm5kci76UYewM9pcw46wHYm/b7trnj+9/SoOMsQGro9ilV6iiqwwWKV0PISOCPewpUMS95YRZrzQKOU4qt4tT51iAE3u76rHKiiACgJSvDnnq/AwU8TpkFRbo5zeoLbdyTSM1lMhKZm9COns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1xSZA1u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737342758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SSz2m2UHXoywkbuHm0D2iZ3hzZMwymukCUceWBx0+g=;
	b=P1xSZA1uBBaOoLiQVSda1R/fI3zPrOJg3w6YsXwP7LEYu9iiXbel2utHzaxbSWg/N/9gdm
	ayNaww0f8ury+HRhux/5LIRQ3my3dsr/kq8BXGONUkWDogezYIENsBJrFJjsv0BxMZx3cJ
	ZNL1e10a3z0VAXgerNEqm0/UoNcOUKU=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-Fh1ei4fcPfSDY1UgV6OofQ-1; Sun, 19 Jan 2025 22:12:37 -0500
X-MC-Unique: Fh1ei4fcPfSDY1UgV6OofQ-1
X-Mimecast-MFC-AGG-ID: Fh1ei4fcPfSDY1UgV6OofQ
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ce865eff29so3674085ab.1
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 19:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737342756; x=1737947556;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SSz2m2UHXoywkbuHm0D2iZ3hzZMwymukCUceWBx0+g=;
        b=UYO3S1a57mYIsWuOfcOf8D1wapNtoBgYbi3uKkcUOV4oW5mKVf11uUcN5Hlcr9JZfj
         GUGE1aCERaNHFMfmqIuLW0PCNqdmxNfddzBBxGIznEZVU+HXaBsbFY3z8EqfaRhTGyZS
         XqsYrOVxxB7mJpjb4l2UDbPjW/4+BMcekTyNFzu9RxqtA1Np76sJw7k20Va1vvTeJoSB
         Gyt+8MpdjWdUOm/ik+QYJxYhP2QmKLUyei5bvpDmiPqQPXj0MBkzNYGJUP8AXZ1AXtS2
         6B+8FaCBZ63ZY1HBVWO2+p/27bB48yvbnVj1QPG4ZTMowohirbkbYkgHFrj+3L6OiTOm
         y3dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl0aUZYEJ3paI5tpctxF8nute2GAiHZeqg2peOnM5XoBko0G3H3FrSLbuVaufVTHMPYLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLk3Myydmw3mRbEsEDZ+5kO42CVgaZWB7Q2ZD78etGLIUxw0Ok
	upPrJ4zlOqoAcA9DV+Il1UgFtM9VPkYhMwNqShjpT2BWseK8FfYjBvKx+xN2v2ej1Vam+/CiIvU
	VvL7TZaZDBVNA7yJc1RVHA/WVkRp0M45mGBTNm/bH0smuxf3tyBs2sjiIGQ==
X-Gm-Gg: ASbGnctYiKcybDiJeQg7modvTlei/IHnaO9ADKG8lBRsMNrqCxYJhJoiX26TdOJw0Zh
	U2UWw0C5fpr3bUsx4PGf7gYjMtO0fXrPj/y7JTmTPPegF30tFEOd4O9zPCQjIw18Z4nYIcu3Cpz
	OwAL7Xu1KqTAujyM7uZa1jdFyxOGRpE8a5Tt4jFmRJ/Gc5UlUi1vBFmLTCrRcqzM9TzXs+SAHtp
	FlQq3fK9zf4BdqkwZQqrHzbpSVUyCFYOOL4QNFJBZgJtKrN+f3VuZ7QMAcAmjhvXsPlfgjpxg==
X-Received: by 2002:a05:6e02:3cc2:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3cf744be621mr24525685ab.5.1737342756130;
        Sun, 19 Jan 2025 19:12:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNTBZIaFLTE7PuNCZzva1bLy+WZP4NoUoy1CTG9U8NFfZDRhz1B2bCtRhjagGm2bC0t7ZdKg==
X-Received: by 2002:a05:6e02:3cc2:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3cf744be621mr24525545ab.5.1737342755869;
        Sun, 19 Jan 2025 19:12:35 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea7566e096sm2223384173.116.2025.01.19.19.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 19:12:35 -0800 (PST)
Date: Sun, 19 Jan 2025 20:12:32 -0700
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
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250119201232.04af85b2.alex.williamson@redhat.com>
In-Reply-To: <SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
	<20250117205232.37dbabe3.alex.williamson@redhat.com>
	<SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2025 02:24:14 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> +EXPORT_SYMBOL_GPL(vfio_pci_memory_lock_and_enable);
> >>
> >>=C2=A0 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_dev=
ice *vdev, u16 cmd)
> >>=C2=A0 {
> >>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_write_config_word(vdev->pdev, =
PCI_COMMAND, cmd);
> >>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&vdev->memory_lock);
> >>=C2=A0 }
> >> +EXPORT_SYMBOL_GPL(vfio_pci_memory_unlock_and_restore);
> >>
> >>=C2=A0 static unsigned long vma_to_pfn(struct vm_area_struct *vma)
> >>=C2=A0 { =20
> >
> > The access is happening before the device is exposed to the user, the
> > above are for handling conditions while there may be races with user
> > access, this is totally unnecessary. =20
>=20
> Right. What I could do to reuse the code is to take out the part
> related to locking/unlocking as new functions and export that.
> The current vfio_pci_memory_lock_and_enable() would take the lock
> and call the new function. Same for vfio_pci_memory_unlock_and_restore().
> The nvgrace module could also call that new function. Does that sound
> reasonable?

No, this is standard PCI driver stuff, everything you need is already
there.  Probably pci_enable_device() and some variant of
pci_request_regions().

> > Does this delay even need to happen in the probe function, or could it
> > happen in the open_device callback?=C2=A0 That would still be before us=
er
> > access, but if we expect it to generally work, it would allow the
> > training to happen in the background up until the user tries to open
> > the device.=C2=A0 Thanks,
> >
> > Alex =20
>=20
> The thought process is that since it is purely bare metal coming to proper
> state while boot, the nvgrace module should probably wait for the startup
> to complete during probe() instead of delaying until open() time.

If the driver is statically loaded, that might mean you're willing to
stall boot for up to 30s.  In practice is this ever actually going to
fail?  Thanks,

Alex


