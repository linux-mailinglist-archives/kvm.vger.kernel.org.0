Return-Path: <kvm+bounces-59193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B22CBAE18E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 276D67ABFCB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D09255248;
	Tue, 30 Sep 2025 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G02T/CxW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54023E23C
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759251177; cv=none; b=RiSKmwvxQzizag90qYLhckWs5v4egu2vI+R/wsmhYjVvKAVK2WNWsa3LeXlfcuzFGs+9YFMImES2x0OV8O69JCF+saveNtNJtv+35DxVjOTC59FIZNSqM+AwoAjkFNqeWFkwgpwjnN+7hKqFLwUa4zqY4ieSGimMq4Y5w+jKNFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759251177; c=relaxed/simple;
	bh=XRHExvG/tHB5daSSKAmQDIMiwtytKVKqlEgrmiHYtGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSyw7WXaPIFEJcOqCnIsV+OHTlcADybNFjcYdl4VpC6jk6+TQwedQx3xSjCPmYXHY0dTqy2zsY4DUA51HmLu/uRQlBhtU0lGFuXwTzfb7emp6MOPywg1uZI8W0eZbpE482nDLAPZqzcQ0TS8TW3sDnPCzU0scyVh04wbt5egAWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G02T/CxW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759251173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JryoONnZtvrch8iWe5kQa/bp3US7CnLH1VFoC2oPQRw=;
	b=G02T/CxWdFzdWNfhlIFwdrUzUnNBxZAHRXbim9H6o7KQF5KMS4DNUuK0/q0tS1t4VDHqf1
	GOfXb5jTCrqx4i4h3f5VwHtoD6hlai8QA77ya8Sck7zGbs4bYIpeUgCs+aMFoPl2guGAKD
	IxWFGeHTQKPEyMC6jJaM17C6FhYIod4=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-2dBizu50MB2RYTF_P2pWlg-1; Tue, 30 Sep 2025 12:52:51 -0400
X-MC-Unique: 2dBizu50MB2RYTF_P2pWlg-1
X-Mimecast-MFC-AGG-ID: 2dBizu50MB2RYTF_P2pWlg_1759251171
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7aba0808204so1557666a34.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759251171; x=1759855971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JryoONnZtvrch8iWe5kQa/bp3US7CnLH1VFoC2oPQRw=;
        b=GgIR/4wrNDbxApdCVT0GLXgRGCJDoAuluSQGabYhtVYR/G/c/Sei/5KuGSdxDaqC99
         7MxQ4ukhunFhsv9K9mfcuRkbE4clVZ5EmbrYFgtXN1pCf9tq9GkQtw2u85uQjvDKwILE
         v6e0/XXG3r08fUb7Hy8c+W9pxTCMqmGnn5BHKcV7S+Im26TN4kCUSqU60RRm0sg5SGzz
         7Xi4913q5dOeW8B1OaUnWJJLXasLSxG1NtYzaluGP7SSzJsslL6r9RUy240zomtu8Nn6
         peI6/ZRLbc3KmCuSMAw+ZxIrN8APxBfcLORjUDFtXZQsJObS6B9rsj9FQMN7mlpnqBeW
         sX7A==
X-Forwarded-Encrypted: i=1; AJvYcCVL4big/EjMcwWK6BXBBGVYKZpOv6EojryO6DscxzF/3XPN7EVTLvlt+XtcNhFpBOjRazs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB0FPNDxT8/Mqcy5aB/64Fqnofx2YwN9Zp6fO4xdm1Dll8h9ar
	J67uS5aZ4JWPN/OdtcFXyjzI6frvvM69XQ84+PpkaHxp7R4y7LN3P5NX3f3kH48lHLLobiyqKOI
	H8I9kepK9hW1B7r30NAQ72jjyofoe3MZdXmgea1ry9hwQEQNfL8TgMA==
X-Gm-Gg: ASbGncuh8TPPcLwi6mPPjfzF/jTXiV6Z3lxTh/M2e4xHY1PWqch02T951fizbGTRE0A
	l2T69fsRLtsLVVt9QgLHyxLa7v9JUjoaqtP0/0W3QXya28n0l3j/0Ns6M7hk2zHqP8gLs5Q4Y4Q
	4btyJU8iwbnRlVsfHvYGRIRXQeRecoxDdbwiVXlw6P7M1JP69f8JnkaO+FpCUSAlztMAlzcj+Bn
	5eBxSI0iMiy9laTtDSQFRSVa3BcfXjCyyxSaf7VFWdIFYuOKRhDA2SnIrafab8/bMlo3YYDxWaV
	UZ0xQmj9qKZj9pKs/qPBbyLAGwUK3vADSNAfLws/U+06E2sI
X-Received: by 2002:a05:6808:f86:b0:438:33fd:317c with SMTP id 5614622812f47-43fa41bd61fmr82474b6e.3.1759251171054;
        Tue, 30 Sep 2025 09:52:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwZ3/lKZz7Fdu2TvHNlTbKRk5qveSl6rvSejYaxAMAP02EZ6HQb/uugFp+9XcOcN4obhcZxg==
X-Received: by 2002:a05:6808:f86:b0:438:33fd:317c with SMTP id 5614622812f47-43fa41bd61fmr82463b6e.3.1759251170626;
        Tue, 30 Sep 2025 09:52:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-43f51238c63sm2746753b6e.22.2025.09.30.09.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 09:52:49 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:52:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shameer Kolothum <skolothumtho@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Logan Gunthorpe <logang@deltatee.com>, Marek
 Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250930105247.1935b553.alex.williamson@redhat.com>
In-Reply-To: <20250930143408.GI2942991@nvidia.com>
References: <cover.1759070796.git.leon@kernel.org>
	<53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
	<20250929151749.2007b192.alex.williamson@redhat.com>
	<20250930090048.GG324804@unreal>
	<CH3PR12MB754801DC65227CC39A3CB1F3AB1AA@CH3PR12MB7548.namprd12.prod.outlook.com>
	<20250930143408.GI2942991@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Sep 2025 11:34:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Sep 30, 2025 at 12:50:47PM +0000, Shameer Kolothum wrote:
> 
> > This is where hisi_acc reports a different BAR size as it tries to hide
> > the migration control region from Guest access.  
> 
> I think for now we should disable DMABUF for any PCI driver that
> implements a VFIO_DEVICE_GET_REGION_INFO
> 
> For a while I've wanted to further reduce the use of the ioctl
> multiplexer, so maybe this series:
> 
> https://github.com/jgunthorpe/linux/commits/vfio_get_region_info_op/
> 
> And then the dmabuf code can check if the ops are set to the generic
> or not and disable itself automatically.
> 
> Otherwise perhaps route the dmabuf through an op and deliberately omit
> it (with a comment!) from hisi, virtio, nvgrace.
> 
> We need to route it through an op anyhow as those three drivers will
> probably eventually want to implement their own version.

Can't we basically achieve the same by testing the ioctl is
vfio_pci_core_ioctl?  Your proposal would have better granularity, but
we'd probably want an ops callback that we can use without a userspace
buffer to get the advertised region size if we ever want to support a
device that both modifies the size of the region relative to the BAR
and supports p2p.  Thanks,

Alex


