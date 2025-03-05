Return-Path: <kvm+bounces-40109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF02A4F38B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B308D3A43C1
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC9413F434;
	Wed,  5 Mar 2025 01:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SgxjJSnG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2D311185
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137880; cv=none; b=BpB7SZtiah7/akepnmEuicvmdWZo3N7bMwNXJWfFXbPt/CdYW7o66o5nqmcLciLwn6ho9YG1ORC4Yf/bb+WOp3BoAsK8BfnXsSUqzqwT3cmhF3yFyNvMGA7yWsaUhyREyiQ8kvlpaChRsBHuUvbxvntbWFCdVM5MSfOBqp3fk8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137880; c=relaxed/simple;
	bh=8ydct3KMoxMe98UJFHOhZoOShOwXxlJ/9YgDjWZk75M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Te4ddJ4XDecyIxGt1rq9+QtDGnLjRDOuhL00J0UOCh0pB0bF/EFh5ouK8WbIhjCN5PuHhnuUQcc4AVlfIXJCEyP5NicMuMJnJ+By1xH4pZ/cLRozxmx5VHm8Jvu6xavjfjoHkKEYGOkwMttLSqUsK2y4cXFUFMD8Ufn0UmZUd3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SgxjJSnG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741137877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nL7IXd7cWI9sQPKv48ILfgyDbX0MLRczDX4w1id2CAk=;
	b=SgxjJSnGILKjnS/zFyVFC6gCYH0moXHjxJKPCOTN2ooqrlz+juXd/+qJ57f/s/xHZwkuqM
	l9ZHLS04NpMBQbY3loDWptTVAzg84Vg0yjQmJ4Yj5s41/cMCgqTZfuuOSrjBBk2B3cOwiv
	GTmF4mJdq4o4Q6tR0wJHTQ/in/Zgz5w=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-fh4hMZHEP7S2hyDdlrvTUQ-1; Tue, 04 Mar 2025 20:24:31 -0500
X-MC-Unique: fh4hMZHEP7S2hyDdlrvTUQ-1
X-Mimecast-MFC-AGG-ID: fh4hMZHEP7S2hyDdlrvTUQ_1741137870
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d42a91fc6dso948615ab.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741137870; x=1741742670;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nL7IXd7cWI9sQPKv48ILfgyDbX0MLRczDX4w1id2CAk=;
        b=Gut8iPUnv7uPiH4m/xHS1Ilft3E0tXL7y3rr50E75n9PjtZFHzoAPUtEQhGaNrQbgF
         m12urWX9xCa9gM6eXHeEWsIq1FGhUdofGFxEV0BD+1nEaCEDjvUFRMxpzd424UIeZB3P
         CfaW8gXoaVeD6NPvYGaB1mYJxlnhkS+e3TJ6EmSkaT+Z9+LLCFikAXSa2CUv0MIwTt4G
         Oxm57ZRNxIYYp74F1TgE9YCBlyua1dehEWJALW1aJFwt7bi+YW+ylXySvREQZ+u8ABpz
         XtazL7lOD8eiWikDiWX1SFwNLMy/PQ8YpL0lX2nk15np6aCeAhcLafZfhYOY18LA8xw+
         F+GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXq6PFoKmKGkILID/EXrBMQdBfUIA8PRyDVjjGJUJgq4KFgzsU0Jy+XpN0X2PfScf1gOXM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1L8qTiQ7NZApFakAi/VwMMb1quyQspIuAx43naFVVswpbSNAK
	DfvXYbg1sLUpy/LZxvs2Tft3FFKNsFZAMDkt2u/g1wNcWqvLl049T89fcS2wdhfHo8TOr/FGFlp
	nYmFBp5zwDK4jY6/DJIIiOry1Lq8p0WQKOP+Toq0ACWoc+nWvjw==
X-Gm-Gg: ASbGncuzBXvxzV9FdfLJFbWmEi1u6qYcbhx+7JppDcsVpqYT2/TGvWdKIPV0on9fA+k
	sNN8t9tZN2FisuVG9M3fHCNi23mKVNoN5Cz6D9O20Vjkh+nqrPbevvxXWwwZ3mCIoIKw2wp53wB
	xk6WndVU8RyLO2HL5OcMPAI5tU7UTQRqrvrnxI26itfqrVd7Xlmb5tzM2gwKh/oPGu/5aP0uIKk
	pjdmv9uDdDz33jBI4wOfxjTJervE0mpSxFvy/P0jorRJws29oKUz73V75ihWCaLZMY4ohWQ3ZNT
	ul77SLnQXKJ7bdQsPa8=
X-Received: by 2002:a05:6602:6417:b0:85a:f3db:7cce with SMTP id ca18e2360f4ac-85affbcefccmr47623739f.4.1741137870389;
        Tue, 04 Mar 2025 17:24:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYQ3AelGPFLAWqjO7y5Qjys4d3FF4GK+6yty1mnFya+6E+1J53wcEvdPZwSXUMBOy0C81s7g==
X-Received: by 2002:a05:6602:6417:b0:85a:f3db:7cce with SMTP id ca18e2360f4ac-85affbcefccmr47622439f.4.1741137870083;
        Tue, 04 Mar 2025 17:24:30 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f09170a821sm1688541173.144.2025.03.04.17.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 17:24:29 -0800 (PST)
Date: Tue, 4 Mar 2025 18:24:21 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Kevin Tian
 <kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
 <Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250304182421.05b6a12f.alex.williamson@redhat.com>
In-Reply-To: <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Mar 2025 22:38:16 +0000
Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com> wrote:

> > > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
> > > direct cache injection. As described in the relevant patch set [1],
> > > direct cache injection in supported hardware allows optimal platform
> > > resource utilization for specific requests on the PCIe bus. This feature
> > > is currently available only for kernel device drivers. However,
> > > user space applications, especially those whose performance is sensitive
> > > to the latency of inbound writes as seen by a CPU core, may benefit from
> > > using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> > > application running in a VM).
> > >
> > > This patch enables configuring of TPH from the user space via
> > > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> > > drivers and VMMs to enable/disable the TPH feature on PCIe devices and
> > > set steering tags in MSI-X or steering-tag table entries using
> > > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel using
> > > VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.  
> > 
> > What level of protection do we expect to have here? Is it OK for
> > userspace to make up any old tag value or is there some security
> > concern with that?
> >   
> Shouldn't be allowed from within a container.
> A hypervisor should have its own STs and map them to platform STs for
> the cores the VM is pinned to and verify any old ST is not written to the
> device MSI-X, ST table or device specific locations.

And how exactly are we mediating device specific steering tags when we
don't know where/how they're written to the device.  An API that
returns a valid ST to userspace doesn't provide any guarantees relative
to what userspace later writes.  MSI-X tables are also writable by
userspace.  I could have missed it, but I also didn't note any pinning
requirement in this proposal.  Thanks,

Alex


