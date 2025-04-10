Return-Path: <kvm+bounces-43085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CA8A84412
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 15:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 484E11B642FF
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 13:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299FF28CF41;
	Thu, 10 Apr 2025 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aJy//rsA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E1928C5BD
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744290335; cv=none; b=r+DDIRdOLCkIbhZz/ODCtV9smS4FB3Ff+Xvo2rjdg4TGu312wgEtByhG3deWF6XsU/Xg5vHzJFevfCx1qAKhBw9C9/EQLpRJKg5+Ojo80PlnlCBbHPAQvkKIVo2wBX0xhFl4/HPUMznrElOMbhSgz3nI6gvmDfPeFhJThEW2wl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744290335; c=relaxed/simple;
	bh=HMR9MCdcSh4ghNXN2PNjr8BtDW52Pk7L9AMhE1YOGEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NywDmE+0S4s0XRN92ZTLgZtgeplrJk4FMCHGtBms/jDxgxdPshEq1mjp6RmP3Rgh4oSEhDsgZN6m3Uy+l3nXbu0BJqYhMuGjeS5ZX6FGlx98g2yc/EVIikojB68mpmaFx4bXVWiQrsEQeAJqtEVTLoXCQj4RpqaQ4h1iKKm9h/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=aJy//rsA; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7c5e39d1e0eso73904985a.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 06:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1744290331; x=1744895131; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHIQ/++9W1bwFwjTR3scNHhBiiv2Oa9aNs8dRl0dl1I=;
        b=aJy//rsAtoRy5775PerRLX3+D2+pCuJyxisg7ZyE9JJYLwFmuXzWh0uOWqiuh4ieIh
         uF5/hijBp+w2Y69y4cKHvmmmNzsPrnf3ptfKescWhZy0OfRE4Mau09mf9U3DVcpknaBd
         scqtSn3UUbhYu5NqdefT+UxoQa6wSdPB88sdqekGPVsVMFf5sbx/ZB89Q2bnHThaL6VV
         meWCWqJJo1/EjSpF2Y3O3bQtNzBnbDoUz5Oe/PFWFf4974ejvqMaUWXFntUJsJ9wdVew
         Xrw4/IXqVIYGBd1hzY6ahSYkD8Z4CI9AYBK1xEyXhR+ImVHL5+sJiNL9uUl6xy129ULv
         jiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744290331; x=1744895131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHIQ/++9W1bwFwjTR3scNHhBiiv2Oa9aNs8dRl0dl1I=;
        b=QKZynTdpI2sC3b7PtW4TU+iNeZISa2SJAv1zIL8vfY/npc32szRl0ZqhLfruucbNFj
         X3SdG8rUvo1oyeSrQQQj8E88f7Alf9w1t3tfG5L3XDTBLc0AAcDG2Ya7KPSHiXgY7qVc
         5O+xJODj03xlBOog6UZq3B+hDodT3MBB2WCqvwktEqPU8hwV63NG2S0czp9HMQGPkBIk
         ujDlvEi1QgYtRg+J+GpLy0gzQZ2FSz0LoVgocHecxby/DcZAZXhUAFFSTQQY/etPgsCD
         ZIlvWC1FfyVGLSfwaRMKOJ+I9vbcwok0rMQVfc7NX0MXUsT7gwTIeWPogXN6Nc8vSByK
         0tmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIO5MZE/7098MzPmvSnzHMMJTsAkgK/Q6V36E3kWbt1h5vzNpuIkU1wnsf/UJHqrny5Bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWxSurbRZRlM4NDcG3AKTaL0ml1kYou2Cd1AIIZpBOc3Px77Ko
	ZdmYrqhIqhcszOH9h3TA3YyYKvd6kDxtdXKstAwYEWdaY/0/I5+MRIxbpNrzo+A=
X-Gm-Gg: ASbGncuwLrHqQ75nIE4QwDuasHkfQiRZgB2X1bn29bnlou5GKuvybZqC1RQNOPZFUI0
	5FsmFHF0y1XxNy+K+Wf0QZXhrryrY3kHIg9ZeFFBEYPKJ4CAdjDSL20g746JMH0jgX73kTB0LYw
	4xoyV0rFiWukxopkHKkW1IDvRRoth0aBm+Sk1FrGOv9W+M/CW3jP+LO7fLvq12rZpf8gvcORs2O
	+xHjdVy4QAdKywvkJqyUj+hQB5acSlSnssAeiFrByWlHGr5/gmiUh5P+KnB/ghnvSwDCFGrcsZi
	ZkBlEx08g2UPtGX3fWPkj9N+zzFUpC167hmIV91qoD99aN9hmpIXrnwLvi5Hu2MYc5oaf58Lq10
	jxTdnPWEWy/e6lqky7Fk=
X-Google-Smtp-Source: AGHT+IG4IzEnrtMNm0AmTZUaqXGTX04b5UW6VZBKQK8VGv14pbPLZJgnECNrc0NUhMe5YZKTD9kaag==
X-Received: by 2002:a05:620a:2445:b0:7c5:99f9:6ada with SMTP id af79cd13be357-7c7a76d3503mr365847885a.50.1744290330960;
        Thu, 10 Apr 2025 06:05:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c7a8969f1asm82420785a.59.2025.04.10.06.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 06:05:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u2raz-00000009aH7-1871;
	Thu, 10 Apr 2025 10:05:29 -0300
Date: Thu, 10 Apr 2025 10:05:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
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
	Zhi Wang <zhiw@nvidia.com>, AXu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 13/22] iommufd: amd-iommu: Add vdevice support
Message-ID: <20250410130529.GE1727154@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-14-aik@amd.com>
 <20250401161138.GL186258@ziepe.ca>
 <b051dcc8-58a5-4f24-8b06-e817e9762952@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b051dcc8-58a5-4f24-8b06-e817e9762952@amd.com>

On Thu, Apr 10, 2025 at 04:39:39PM +1000, Alexey Kardashevskiy wrote:
> > > @@ -2549,12 +2561,15 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
> > >   {
> > >   	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
> > >   	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > > +						IOMMU_HWPT_ALLOC_PASID |
> > > +						IOMMU_HWPT_ALLOC_NEST_PARENT;
> > > +	const u32 supported_flags2 = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > >   						IOMMU_HWPT_ALLOC_PASID;
> > 
> > Just ignore NEST_PARENT? That seems wrong, it should force a V1 page
> > table??
> 
> 
> Ahhh... This is because I still have troubles with what IOMMU_DOMAIN_NESTED
> means (and iommufd.rst does not help me). There is one device, one IOMMU
> table buuut 2 domains? Uh.

It means whatever you want it to mean, so long as it holds a reference
to a NEST_PARENT :)

> > You can get 1:1 domain objects linked to the viommu by creating the
> > 'S1' type domains, maybe that is what you want here. A special domain
> > type that is TSM that has a special DTE.
> 
> Should not IOMMU_DOMAIN_NESTED be that "S1" domain?

Yes that is how ARM is doing it.

Minimally IOMMU_DOMAIN_NESTED on AMD should refere to a partial DTE
fragment that sets the GCR3 information and other guest controlled
bits from the vDTE. It should hold a reference to the viommu and the
S2 NEST_PARENT.

From that basis then you'd try to fit in the CC stuff.

> > Though I'd really rather see the domain attach logic and DTE formation
> > in the AMD driver be fixed up before we made it more complex :\
> > 
> > It would be nice to see normal nesting and viommu support first too :\
> 
> It is in the works too. Thanks,

I think your work will be easier to understand when viewed on top of
working basic nesting support as it is just a special case of that

Jason

