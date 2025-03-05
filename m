Return-Path: <kvm+bounces-40177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3E1A50B7D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2314617088D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 19:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC31253357;
	Wed,  5 Mar 2025 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HlX6kVPC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89B2253343
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741202926; cv=none; b=g6uGTVVj/8QnH+SJAOIuQsf+peUWRaFdvKfS1scsbbYE20j7yrMMjFvsFjrkwMEeDc5nvY0NYylc4efQBzM+k3tN5pW9x5KrwdHAui2IkORaxCJDAuXYbhkfn44HaflyMzL7PRkYjVBLC7tVN6PFuP0MRR2ihLQGZOvzDIcIeOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741202926; c=relaxed/simple;
	bh=yags00HimzcK4ADiEl0X3eL1vhGMGirpJlRolnATCxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8wZe6WO9THhvmXKl16qDfY5gF+r2Vd2nkE5I2jaHYqDowWLb8qqH1EVLM4tY8E26FpKrRmqJIq3dzk+d/XTCkYJieYOgwYDAGRaXknTONObbiurDxEvm7lGaro9CLm5MUycL/AC4RAmb/9SnbNChMTmiKHEA2eXnD64IJWu7zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HlX6kVPC; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c089b2e239so109666185a.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 11:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1741202924; x=1741807724; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTrOJMautZJ74CE8chK1zIyRNkTfUPScJmXz0FQll+Y=;
        b=HlX6kVPCcDWX2J8jzIl6Kp+Bc2+epQmkuUJ99tAWx6cGtWThzWCWCHp+m/fUib/pVs
         joW9oxp998DtgTv35UdPDxS4R3zWy3/tnlp6KqfCBNNkv0vB2c3pfb6/QCoSCR/4ArNC
         ICe5Hn3Ml26/nzOUj58mQsT6Pe+Wiuasn9vSKOmsy8nqIhSq/f2yy7ZVN7Dd6gjPHuEu
         uhz0E9XJIH9fUmiFi4sYjsAAFhHue6x5/Vy/OF+bKVHhaFbfZYkEFn3KY1UGOIwr2FQH
         m9DB8zWuv0CoqtHSQQgIHGdT8m0JSOQUzQAJ+6LgpCDxKd75sn8mCpiXS/WmqYWzwCI2
         kweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741202924; x=1741807724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTrOJMautZJ74CE8chK1zIyRNkTfUPScJmXz0FQll+Y=;
        b=KrbIlaPGe/Sa7GIT9BzPew5/UrlZv8bBMH9euYGRO7/EYItEe113STLE3f0jmHgHvA
         H2vC9XAuOPliHNE9ETzxt902706UgTWPlXLNZG887G2cixK2sBI9+kGu5a/QkYjVL3Dy
         3U21xXmJ5gnqOaHztisPYgzzf2jS7UDDM9h7kK9spn0qMt9t7bdug7DzczTH66mzLrcE
         J98ayQHWBm8bgZ9thhHaSV98p/q/BJ1p9z067B2ZNb8cfIIttWqPlC900IZkdwt3Ftz0
         CKUdcqUVV/TkHT3PwAoJqTYf6Ay32vNYOgwHErcoNCoj6J9OwzZs8q9l1kuj7k/cNaIK
         CXfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWG4BHSj741N9KH7iBrgQdTXf1gj/kcX5d84iZ2MojEB2sgIGO3RrPknk+dpHA3zU5Bwc0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMr/N1lfI737txzA3TbGrGhjZognp4GjwgQf9Uz/bkpkJw39gI
	O5H8ktBVVBxI0pWXFZuen0JJYIo14m0//hjN7wDVmev5UCpwGmGC/wiWxgcmK5Y=
X-Gm-Gg: ASbGncvC4N45efqfo9s0V/SUYdlveGxX2tpbGU85gkPoesEg9xnY62L+Q5FlL277Zbc
	Jw3l0Ohvy1IMvKu5XdrqbZ4x2h+HLBC0Qu+MIgLXBExQFVgejmYpTEQRShCp3TY8ALBSu3tS1Yn
	9kicgHcdHvyTAyq6KrWkbgFKNrjchMW9V1mUtb1RyXWO3Jcok8h8EWChQHF3+JA99whawU/3A+q
	Y+NyGR4K01FISb3MnTdMQTkFaDcJM6zlU5OviEp6DfxgSUHN7vmH339X/4z/pFTsdhXAC231Dz9
	FwGk542LW9wxb7mw9+v5PnWuMOdL1UHfE5DuBC6VFeMxHENe8upvluaqBWThSgbsY8XxO9VEW9c
	RpHA1UraKZxllxJ6PWg==
X-Google-Smtp-Source: AGHT+IEHx2UVGeNJCjdCHNzkys/fqlsDci1nQ/1m9GKN7AMZGI83uk7z1IQe+K7jbrNiF4r725P/BQ==
X-Received: by 2002:a05:620a:6285:b0:7c0:b350:820 with SMTP id af79cd13be357-7c3e39b1392mr81853985a.5.1741202923780;
        Wed, 05 Mar 2025 11:28:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3c9f640cbsm324838085a.108.2025.03.05.11.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 11:28:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tpuQ6-00000001VBp-37wk;
	Wed, 05 Mar 2025 15:28:42 -0400
Date: Wed, 5 Mar 2025 15:28:42 -0400
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
Message-ID: <20250305192842.GE354403@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>
 <20250301003711.GR5011@ziepe.ca>
 <Z8U+/0IYyn7XX3ao@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8U+/0IYyn7XX3ao@yilunxu-OptiPlex-7050>

On Mon, Mar 03, 2025 at 01:32:47PM +0800, Xu Yilun wrote:
> All these settings cannot really take function until guest verifies them
> and does TDISP start. Guest verification does not (should not) need host
> awareness.
> 
> Our solution is, separate the secure DMA setting and secure device setting
> in different components, iommufd & vfio.
> 
> Guest require bind:
>   - ioctl(iommufd, IOMMU_VIOMMU_ALLOC, {.type = IOMMU_VIOMMU_TYPE_KVM_VALID,
> 					.kvm_fd = kvm_fd,
> 					.out_viommu_id = &viommu_id});
>   - ioctl(iommufd, IOMMU_HWPT_ALLOC, {.flag = IOMMU_HWPT_ALLOC_TRUSTED,
> 				      .pt_id = viommu_id,
> 				      .out_hwpt_id = &hwpt_id});
>   - ioctl(vfio_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, {.pt_id = hwpt_id})
>     - do secure DMA setting in Intel iommu driver.
> 
>   - ioctl(vfio_fd, VFIO_DEVICE_TSM_BIND, ...)
>     - do bind in Intel TSM driver.

Except what do command do you issue to the secure world for TSM_BIND
and what are it's argument? Again you can't include the vBDF or vIOMMU
ID here.

vfio also can't validate that the hwpt is in the right state when it
executes this function.

You could also issue the TSM bind against the idev on the iommufd
side..

Part of my problem here is I don't see anyone who seems to have read
all three specs and is trying to mush them together. Everyone is
focused on their own spec. I know there are subtle differences :\

Jason

