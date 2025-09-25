Return-Path: <kvm+bounces-58827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F927BA1CC3
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 00:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655371C2750D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 22:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB7B321F2F;
	Thu, 25 Sep 2025 22:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+yZubRg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B0F272E67
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 22:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758839500; cv=none; b=jVfV+nrGXJ5RGH7cob+4zOMnzsyJUliaRJRy8nEQa+am4etaM2sOGf94QO9uA0N95LRZmm4BcbYvnA3SmKrBVh7sCbeY05OoMBUv6mSYju80tq/hAQY3XZfuXAoGZAbOqaZxhojQ0loRpLeBMbGE+Op1Xgf1xTus/omX3zddqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758839500; c=relaxed/simple;
	bh=0Alswmfe1zq7N80PnOB6XtFxyNuFoZwrMxHbgdTZfVk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rE2MQIIoy8/+VYjRVhK1BMrJTBX+/PyQXL2WQZfpx9XMJ4h4rBGoIxqRsKRi2pRhCe5QaPqo5Q/mjFyW2ydn3xzv/ksS8D/XpQ4mZXlW2Z4mN7478gEBY7EuGw2uDVyDlB8447BYDCh1ZBVdU9cOamXA/Cbp7FHyFj+cSoRiqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+yZubRg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758839497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pPGBYTkBK6lmMsctQg86rFzc+ubUYRnHqSeaFKAdA0w=;
	b=C+yZubRgK7Xuwq8ZYbAwrcRYC9QJmxmKZYhbFEgZZzGy0wcSpRtZdmQIn5cJi+4/kE7I0b
	H7LRxQ7lvfwPszHznmJsqnXlq31xtlX1UeKVoTth1DoVwhxeCom1E1069qr7z2twjZ/ElL
	OZg7vgVrWNEhfNV/vmzboGSLcCUVDtI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-SZ5Dm_wfM7GO-we7Tjtzaw-1; Thu, 25 Sep 2025 18:31:36 -0400
X-MC-Unique: SZ5Dm_wfM7GO-we7Tjtzaw-1
X-Mimecast-MFC-AGG-ID: SZ5Dm_wfM7GO-we7Tjtzaw_1758839495
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4248b4d6609so3761235ab.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 15:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758839495; x=1759444295;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pPGBYTkBK6lmMsctQg86rFzc+ubUYRnHqSeaFKAdA0w=;
        b=fScZtA6zjWTmnwE07Gzw2PLhLy+mhwoaSNPcxVxvKTLI4It5AIU0pvaCZ0BHFE7+6Z
         Joyv6rfMAldAb0zM55JrXx23lXWtAxUPm0hiIawEJ0bAe2vdJR1sDY0zwG0ooxDjYqpN
         aeWaLdtnLUmLZwmaHiR6xq0vejAHESVRAtNWNk8fniSGv68fCYtgN3U2R/33iI5HGNbn
         HjIp5q6WpaYV2CAgh6UVZeNm5r8lYRdMglN559wySPpwPTu1rRs0ggtaNqHgTaE1x7zg
         TOQF9POQVW71K+sT3gPIsSvfhOtcmrFUCsaEGH+3XnkMbprJxUhRmDuzX4bQLeDNwcN1
         zNxg==
X-Forwarded-Encrypted: i=1; AJvYcCXi6hQ7FTt6qDIYxHl6sQKLydWlhiH9LrK/hwTTsRg+G//W1XiY/rNTMoB625URMvPtTis=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfdwMoHxYD8aflw2wWMBawbJabuvRSUqPklyeHlVkmAhI+DPZw
	3XyvWj92sw7O6Rgcbo2h0a4T8o7V9QhCST5sh3GtNp5c3UUdzqBYbXhc18YBSCTWV7k9m3NVDNJ
	AUIoB4nq2wLwqqeJFvoEnAgQ9P5Pcqej/7ier3XK9Ub8yyr0PslZ6SQ==
X-Gm-Gg: ASbGnct7jscTe95UTOx9CLn4Z5lNG751mvonMidfA2Idu+ONNm6SWttbX5XolMzpdUZ
	q9SavY3jojn2dk9iRZAjvmnRx43ayhsxKcIsqDXfD7yeyorT8SsVm3T0A2QmxipHD9PItRtJRPv
	p8SqCRBTuCdxeiv0x+zCZfaojmjOzBuMZwJh8UyjDTnCcPODK1qeYkKJ0Suzv7uaY+Xy8XjUufK
	y0vraul8QIeAsTW5pwRfrVjvBcMXYOcGTzeW5tB3ygt/5Rd8g1zH9tHiIbXePYdfHvKcpgTBZMU
	RHUbPPqBYMTolmBINxM3Hw7oro/X9lbTIKNI1Itkom4=
X-Received: by 2002:a92:d987:0:b0:424:80e6:9e8b with SMTP id e9e14a558f8ab-42595661562mr24720345ab.7.1758839495387;
        Thu, 25 Sep 2025 15:31:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBjWzVlsd5kVvaGcIPZVt9Dy5vtGZ7X7lNybnyhnS6f36pgd3Q/xbJFuK0zszjvTKZaW8Iag==
X-Received: by 2002:a92:d987:0:b0:424:80e6:9e8b with SMTP id e9e14a558f8ab-42595661562mr24719995ab.7.1758839494991;
        Thu, 25 Sep 2025 15:31:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a69a1c574sm1211405173.40.2025.09.25.15.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 15:31:34 -0700 (PDT)
Date: Thu, 25 Sep 2025 16:31:31 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250925163131.22a2c09b.alex.williamson@redhat.com>
In-Reply-To: <20250925115308.GT2617119@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923150414.GA2608121@nvidia.com>
	<20250923113041.38bee711.alex.williamson@redhat.com>
	<20250923174333.GE2608121@nvidia.com>
	<20250923120932.47df57b2.alex.williamson@redhat.com>
	<20250925070314.GA12165@unreal>
	<20250925115308.GT2617119@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Sep 2025 08:53:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> 
> > > It would at least make sense to me then to store the provider on the
> > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > the inline #ifdefs.  
> > 
> > I'll change it now. If "enable" function goes to be "get" function, we
> > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"  
> 
> Not without some kind of locking change. I'd keep the
> priv->vdev->provider[priv->bar] because setup during probe doesn't
> need special locking.

Why do we need to store the provider on the vfio_pci_core_device at
probe though, we can get it later via pcim_p2pdma_provider().  Ideally
we'd take the opportunity to pull out the setup part of the _provider
function to give us an initialization interface to use at probe time
without an unnecessary BAR# arg.  Thanks,

Alex


