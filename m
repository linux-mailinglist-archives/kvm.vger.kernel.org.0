Return-Path: <kvm+bounces-42343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7519EA77FF8
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBD2F3B08D5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FE62165E4;
	Tue,  1 Apr 2025 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lDnUmh5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58521A440
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523903; cv=none; b=hwSfPMyPmNEo30uNbbUaZQNxF1MfMFepzqw3vOPFD02cr93e62wehtLMXZy9vJALmPUtleEO01Wri1xR7A6WC1eCuheLKX3x/A6I5Dw8NnBeuZc/Xz6nh4QtjmNcOBGd2oCkHtp5zugF2DWQsopYvymoz5k/AM3/HwymRh0u2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523903; c=relaxed/simple;
	bh=0bfnfRwxd83qT6YHXSQ35/Sc5Ii17MOf/lTvNc4Gkxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usPSkiF9Yj7slfS/BU+IfB+oAxGeu8uDB4wJa6DWY/MqYGUHKqQKad+nIigRed1NtgYbhdaRo74AZH75Ror11vgLo4x3xkmn2CsAYaRVzUpjJxTd31cteZ1aDbOjGTeofwIK/WVe/xeB6eqFmmUffq28Uo9W3axq3/dijkUGYBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lDnUmh5L; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-476ac73c76fso62271511cf.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743523900; x=1744128700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ht+/cjgqGqzgXcB/qQp4vlm60uUPBRIV+JZ12u7d0fU=;
        b=lDnUmh5L+0rCze4HHaOY0fInhE2/g4OqB70O4lroUA66m4berrddssMHgXIfslNESy
         C4hfoVX0sS0Ze4HunAg/LvTPqunpMT1UZOLYuOXxRI40B1VjlFIOHheEFEtAtiMQAJY8
         2jvJlMZ9GF/WJn7VoTDSlhBdM210lL0c2n9LdArDdhYtf48EvNbgvb19vva8SFzBCxOE
         Iqkd6NI5Ae489ogm6T5ittm5N2Y9bHE+jdnh/7iSPprDhI18kSDd7h/yl2DiOXOYf/GX
         qy2NlTBZDOzWV1KtmR3NlYhkSac5+1sQsNKsqHMaYb5ADqRT9eb1LH2fFjLywbm+CWhP
         ipRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523900; x=1744128700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht+/cjgqGqzgXcB/qQp4vlm60uUPBRIV+JZ12u7d0fU=;
        b=QPpmnFkjlMvLfhYyUqiHaUlZl5h5YrCiDbi86ZPCmDwG8VAGrMDOEYrI+8eC6Tmq/A
         t54GNjOhCBCpcui605eQ3FJq0Dm61DxzlZe0mXIFvBKlV3irLVnmhyp1xYIO/dX+JVzx
         ocMlvdSsbSGSy06lfPST7Df2S0dUL5Ys938cVqZh8NYDCjz+JyIDgPaHvd75N+ZdduJq
         zr4d8twGWYIzLRwloovJQPlhXpyq7LepRNQ8wNNGR9L/Ino3pw/lqXyjFDbKIcoKNb55
         GBTG7GEAqKbjIBoipy9pFRcT31EdKTGwvK3ZuvdOB95Kh2YR5CYyfElNBz5bOwXuyEa6
         eOoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDYPMzShfeCNaC+bQ5HBAp4KozPv0yCxDU3LDrcm6/zEGrDT7muv0wvT4V7STztRdsMWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRi5rDYxg6UUaR5bNsnIU7KgI77tITvurhvqLDP0UwKe9u8lV/
	kD6giNAW7s09xa4btgoqxPqeIIouGgmIEE5MAiM4A3i7hCpX/M0zXUcjhk7t6DM=
X-Gm-Gg: ASbGncvDwKblSYNWIc1a6+gr20EPmwyZju0VTRIz+mCmlhEaOrk0Eo4Xrj9R1Mu9Ee1
	gc9RbaOIjPb/vMQWFxv4wbUUbP5AITow1Mn7AwbaMQrAeldlVq0QBxpY+Sb0OM6H2xvNMmX5xCP
	yrAmWqg6ao93EqaKkf0Wsb7lcKw6fIuSmv+Ns+KtUtwioSLctrnbtowB/FDf5B0ML1LUfJ8Aiov
	mEOZd0dM+viqJHD5EuFnOGWZyDTR5Lhx7eB5+mhviWav1Ojfu6PAcVQkadDw2KO6iKtc/Oubaag
	iebVqqTTxBVtBTTl8TCcJ0ZSU3ay4deCLYO9n8p9LltmSJjK5TnUTJZpd+VAcfNko5pw/Fwt2mj
	dk4J6EkxXGpSJg2wRS3Jf+Ao=
X-Google-Smtp-Source: AGHT+IGqQTmKBPGxEDnar5cvqd0kVzoGqHi3v/f2hQrPfOnvCsqaEdb1Xw9stjow0mGeS+auqOd8Yw==
X-Received: by 2002:a05:622a:13d4:b0:476:ae71:eabe with SMTP id d75a77b69052e-477ed779bf5mr236227621cf.50.1743523900002;
        Tue, 01 Apr 2025 09:11:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47790ef0976sm57062041cf.59.2025.04.01.09.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tzeDC-00000001ML9-3rkm;
	Tue, 01 Apr 2025 13:11:38 -0300
Date: Tue, 1 Apr 2025 13:11:38 -0300
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
Message-ID: <20250401161138.GL186258@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-14-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218111017.491719-14-aik@amd.com>

On Tue, Feb 18, 2025 at 10:10:00PM +1100, Alexey Kardashevskiy wrote:
> @@ -939,6 +939,7 @@ struct iommu_fault_alloc {
>  enum iommu_viommu_type {
>  	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
>  	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
> +	IOMMU_VIOMMU_TYPE_TSM = 2,

This should probably be some kind of AMD_TSM and the driver data blob
should carry any additional data needed to create the vIOMMU that is
visible to the guest.

> @@ -2068,7 +2069,18 @@ static void set_dte_entry(struct amd_iommu *iommu,
>  		new.data[1] |= DTE_FLAG_IOTLB;
>  
>  	old_domid = READ_ONCE(dte->data[1]) & DEV_DOMID_MASK;
> -	new.data[1] |= domid;
> +
> +	if (domain->aviommu) {

AMD should be implementing viommu natively without CC as well, try to
structure things so it fits together better. This should only trigger
for the CC viommu type..

> +		/*
> +		 * This runs when VFIO is bound to a device but TDI is not yet.
> +		 * Ideally TSM should change DTE only when TDI is bound.
> +		 */
> +		dev_info(dev_data->dev, "Skip DomainID=%x and set bit96\n", domid);
> +		new.data[1] |= 1ULL << (96 - 64);
> +	} else {
> +		dev_info(dev_data->dev, "Not skip DomainID=%x and not set bit96\n", domid);
> +		new.data[1] |= domid;
> +	}
>  
>  	/*
>  	 * Restore cached persistent DTE bits, which can be set by information
> @@ -2549,12 +2561,15 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
>  {
>  	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
>  	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +						IOMMU_HWPT_ALLOC_PASID |
> +						IOMMU_HWPT_ALLOC_NEST_PARENT;
> +	const u32 supported_flags2 = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
>  						IOMMU_HWPT_ALLOC_PASID;

Just ignore NEST_PARENT? That seems wrong, it should force a V1 page
table??

> +static struct iommufd_viommu *amd_viommu_alloc(struct device *dev,
> +					       struct iommu_domain *parent,
> +					       struct iommufd_ctx *ictx,
> +					       unsigned int viommu_type)
> +{
> +	struct amd_viommu *aviommu;
> +	struct protection_domain *domain = to_pdomain(parent);
> +
> +	if (viommu_type != IOMMU_VIOMMU_TYPE_TSM)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	aviommu = iommufd_viommu_alloc(ictx, struct amd_viommu, core, &amd_viommu_ops);
> +	if (IS_ERR(aviommu))
> +		return ERR_CAST(aviommu);
> +
> +	aviommu->domain = domain;

This is not OK, the parent domain of the viommu can be used with
multiple viommu objects, it can't just have a naked back reference
like this.

You can get 1:1 domain objects linked to the viommu by creating the
'S1' type domains, maybe that is what you want here. A special domain
type that is TSM that has a special DTE.

Though I'd really rather see the domain attach logic and DTE formation
in the AMD driver be fixed up before we made it more complex :\

It would be nice to see normal nesting and viommu support first too :\

Jason

