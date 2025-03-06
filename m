Return-Path: <kvm+bounces-40269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDECBA554E9
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 19:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3735516850B
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44379263F5F;
	Thu,  6 Mar 2025 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nG6pM+Le"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A184926E179
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285579; cv=none; b=E+WeUCUmQ7EjHHcBxWxYMPB5ovwz9fZdXgHImw0pRVhLLAFzrJEA2lQWmUDB/YNJJfBRrgyAU/UVT6orcjQzafnTKP/Nld3nll31IP8FZ170IGAe//miBNwXtirSJyURBVZMkAW8klGSXobNUwR2+UPTFsUIq0bk1Rh+t+OI+pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285579; c=relaxed/simple;
	bh=A0wvu3n9vFC16f3qlUsNA6dfIvpISQcUDrHPkbUkZ+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiYyOSK+mlPkAn4C50Ilq8Me885yH+fmzwQupDHkpGleOfZDRv+ZQmQ+r2u0e9fOHAAbgsdy3C2ZvF4JPU62z5YjWGTfU8vyC2CSLS0cqzPyQLbTKbQ3zaO9adMgxeWRXjKIxmLV7LKgOamX6P2Mi0hwj/SLzs7abcFo/mVgh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nG6pM+Le; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6e8f8657f29so6225386d6.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 10:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1741285576; x=1741890376; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJmNeR7cBbicmXZ58VNFTx5zHy0Fy/985QYAD/du2Go=;
        b=nG6pM+Le+dA7yx4K76TErK7cKIwxirglTLAX04hH3hDNDA8cO9wuZpsL7sMorxgsOe
         Qv0UvNAxBlphErKEkHv8P4LDRP85oK8K/jgj+XsC3CBLCy9cT4znC/llySYS3extxW2x
         Ur13UqVfGcDRXiJbM8DH2rHSbtgqsT8vzs4fvw1rhKDqjJRMFKStH1vegah/CVVjwttc
         Qkt94OgjwpgcLJs14fKW4NYd+6J6ZMv/JuVIUXQg5b61JMsqXhzCKUWvGExH8Q0L0bpZ
         MzQCNoG6mUoHY3dKaPI19z6FyVSREYBteG41fVazwLX1f7QLdNaSmvR7K09OweJNVB4T
         ehOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741285576; x=1741890376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJmNeR7cBbicmXZ58VNFTx5zHy0Fy/985QYAD/du2Go=;
        b=Vmyr3SmkP04ot8W/eYlXd/GS4oAqKvSPAU3vzYpxGvj+XbozCf/oIrld0EO9YD4e1X
         NaQ7Mbw33qbnFI6q/7JNEsVQtakbTXyPQH97coGyLJtMXZ8Vi1Pbs6ZoHUWIB8pN0lPl
         fjxzvxDxCkIJpoYt/T9tvQCxdsaQ69LtPcUrg1EMZ7qe4+GqC98+TYwYa0/xJbDp74u3
         307qGAWKxQ2UjyzNwG5z+Nkuw9YCY5zlqsOD+jkBLPEjqd3clSlX4LUDKDk2DVcDRr4+
         0BPszr5CZH/V9+gnwgNS6K5ocrgTea9IBjhRh7n/LKD9p5vhgah78uMt/iLgJ3LtQNmX
         5HBw==
X-Forwarded-Encrypted: i=1; AJvYcCUCmkXhV+N7BDN+EkHaJkbg+5TfZzZWzECo9f06j53JBhYaJxUn/ih2vrFS15484E0VnYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2qd/tShoZHGc2429bwdVZFj2uJmA8G0xwq7ZRmQIr0PIpskmW
	Ib2u0eNnxVP4hhGEGo6y5Rw1z5Ip2SoBp3yXVXjWjZuFl9WkR6V+xXWXjro+7rE=
X-Gm-Gg: ASbGnctXaj8l0yMSXGz2P+btfTo55k0iNZWJ+iGT7fngAf9ks8Ks4khyZTQeYspfUP5
	mZfBMkt1bxyiDT2blqnYukQKxFnva/+p0zRYBfNs6qrWU0F5ZtxFGlDhj6l0GfiJnsCc88V08CZ
	QCO1Y598LujmOaAJHVKySW2J9Bduc094Qam9YHrs2O2Wkbi1jhhpMotRmr0HzvAHSMmuGSk4Ocx
	svvrPSmNg/S16pEHRaTZSS4Z9lOmeHmXqVE2MAUf/YK47qS6HKPqrZR5Syfzf0uLBVhvkH/gtna
	qHPm8C8bfzWF2vrj5TvUEEBkX2aHjTI2dbxNbmV5Y+7GGBPIq1xLuzKsFDKa1b9Ohi7RJjOBeTq
	TxYOBhZUmc6F5X9LA/A==
X-Google-Smtp-Source: AGHT+IHdLGu9+NkI+poSobXraQKM371I6DGk+LdkIPbK8ktXY1plTaVgGJ4wX3yHHMcP8NJrRnY4AQ==
X-Received: by 2002:a05:6214:76c:b0:6e8:fde9:5d07 with SMTP id 6a1803df08f44-6e90066a2e7mr783186d6.26.1741285576387;
        Thu, 06 Mar 2025 10:26:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8f7090c4csm9806836d6.33.2025.03.06.10.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 10:26:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tqFvC-00000001eHR-3E6L;
	Thu, 06 Mar 2025 14:26:14 -0400
Date: Thu, 6 Mar 2025 14:26:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-arch@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dionna Glaze <dionnaglaze@google.com>, Yi Liu <yi.l.liu@intel.com>,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250306182614.GF354403@ziepe.ca>
References: <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>
 <20250301003711.GR5011@ziepe.ca>
 <Z8U+/0IYyn7XX3ao@yilunxu-OptiPlex-7050>
 <20250305192842.GE354403@ziepe.ca>
 <Z8lE+5OpqZc746mT@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8lE+5OpqZc746mT@yilunxu-OptiPlex-7050>

On Thu, Mar 06, 2025 at 02:47:23PM +0800, Xu Yilun wrote:

> While for AMD:
>         ...
>         b.guest_device_id = guest_rid;  //TDI ID, it is the vBDF
>         b.gctx_paddr = gctx_paddr;      //AMDs CoCo-VM ID
> 
>         ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_BIND, &b, ...
> 
> 
> Neither of them use vIOMMU ID or any IOMMU info, so the only concern is
> vBDF.

I think that is enough, we should not be putting this in VFIO if it
cannot execute it for AMD :\

> > You could also issue the TSM bind against the idev on the iommufd
> > side..
> 
> But I cannot figure out how idev could ensure no mmap on VFIO, and how
> idev could call dma_buf_move_notify.

I suggest you start out this way from the VFIO. Put the device in a CC
mode which bans the mmap entirely and pass that CC capable as a flag
into iommufd when creating the idev.

If it really needs to be dyanmic a VFIO feature could change the CC
mode and that could call back to iommufd to synchronize if that is
allowed.

Jason

