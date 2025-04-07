Return-Path: <kvm+bounces-42863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C99D4A7E712
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7B1018913BF
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2FF20E6FD;
	Mon,  7 Apr 2025 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C1e9a7Rl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC2C20E013
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744044014; cv=none; b=ZZNPGECPiUUA+Of+TSz3SwWNXan73p2ar5Ikm+2TGDqIdRrS2agM37Ta/O9PUBcpfctzGacivFPM3U6Vdqa14RvluyPOIR7Q8jy8b97oNS2YJSb78qhAoD++umVkslkJoYWYt4KtgTCT7jm0SvOhLwOpMDE6PbJFg9V27zL88y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744044014; c=relaxed/simple;
	bh=xekbj8Um5XwrEOGdzENZPa2iQeQhDeMvkZT0NVb5BK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaXo2itL94HSIvQAeL50NqOhl8+guccULxAbgyk/fgON6sGoHlQbrYLclAnnwXDvN/e4brrkkIqq95HUm550g+FoYek7EE1tGrQvrWFdUnxYmV3LzGm34f+01iXak4jhQvQEhWemIekrfJPcsMVRrRRYqE7bBmdAbgWl50tCoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C1e9a7Rl; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c592764e24so501352485a.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 09:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1744044011; x=1744648811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KVaiHAMacLy0yHf6meYzZ4WkOGggIQHdshTAyck4dh4=;
        b=C1e9a7RlDnHM1HSLQZ5q8CNKgVYLTqgByhvy9WMxUJRN581QJO0J+rvZli6pcgyuMe
         5x/L9DLnre5qvLPL5k5U9nmgJHaHr8q9l1/zwNTnFpGVRYulzqA8D4D/OXVoMOxkDgdz
         vNsIxXM2KegZvo48VvlijiqqbTA7Dfhy/dkzRA6yp2EAAnp6x16CF3JkwqsD44nLtG3o
         FsxD2OY/lGWRmlsYbVwcbPTKuAhsUyE10NIZ40gkK8l4dwIjH+fcSTybgCImC74fgk57
         rGIff4B4Vn0IHEYEv+B4NXhPIYkaPyW0kTvRsSciPf4oXRWlj0J7czCO8jjf45rgRLKh
         9wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744044011; x=1744648811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVaiHAMacLy0yHf6meYzZ4WkOGggIQHdshTAyck4dh4=;
        b=DOTqJBc1GkZY7ZyyvQGesZ1kncE8YzIgxXHXVN2L0xOV8KsZ0+NfMYe0F8ihLvve/w
         qPVJeGVWahg3rEGFeBQQQhl+0IIlV9tFwYc3fZvf4cbp3IzKFqgVaukuSgA6ptfYTaxF
         sG5PcL+oK8rNjeP0Db+LvMg2o/xCHFb8l5x9KNgRnpGK4IdNJlG7P5WmooWWoVdLpgtz
         w51l7bX1jS+oSBJME0pNY8hW/YAeG2DbrFXNi9ARpyrl4TAMXNTA6AylqXcKCegzwOED
         TordVd+MVsFoguBbqqndJ0Q/Q2V7kUOIz7P/xUgOe8ZGBZAqAFnIS3Hps4/ujXvCko2S
         2CYg==
X-Forwarded-Encrypted: i=1; AJvYcCUx0wRR3GYMXg6jPXnoMNfm+E5ICHYkve7bo+6yt/q1Bt2TgVrQxte2HyQibt6H8FZTs3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt7Vusdpx1J3xGKEUwddpOilltjtVYHSdlJ40xUg3nMSsskUSO
	3xE1gYE+V17Pqn/uyb77T+eaSpUJCcc+9WwV8n3RFcpvZsHceAaZFu86BvJzo08=
X-Gm-Gg: ASbGncsgzdRYEXbMFsGMZx4OmwI0M28wAisPl8AMXnN/nCCvM/vyMYrs9Sz+V0vwGSu
	2KjbJjI07LthVFPXF3a4HMFgp54idk1eWiDD/OjEUCUSl64Pq0d+hW2R4YpBK4JIaVx9KW+ISb0
	0h1NpPct++GwUOQiJLsC0czmxmoZuq2IDeBr4Ph+7AmqdfUoNY4Yql0+FJ3diqtDif6Wo4CGoF6
	1Qt/2lFr5TFN2w2OF8wYhp9hIYLccvvdqKGZpKqAq/NDhUPLNeldn22CVA3aqMszpkKroI81QTO
	nZPAn7c3bKHD0N7AR3Q0AiyNPlhX7ML98+yxifmXXNdLxOkWDNPnFZQGlChObW6vM7d3l+osyC+
	rKRY9HNpOyUdzt+zMS2CRcGU=
X-Google-Smtp-Source: AGHT+IEFf/klcawRT/DLAKNVY/s1kWSMw+u/XuSys5u9G30IOfriJNNXl5A9JC2j6VoZritBscM43A==
X-Received: by 2002:a05:620a:25c8:b0:7c0:ad47:db3d with SMTP id af79cd13be357-7c7940ba2a0mr22422685a.21.1744044010744;
        Mon, 07 Apr 2025 09:40:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e96e870sm618914485a.60.2025.04.07.09.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 09:40:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u1pW5-00000007DRV-3Cjz;
	Mon, 07 Apr 2025 13:40:09 -0300
Date: Mon, 7 Apr 2025 13:40:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
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
	Zhi Wang <zhiw@nvidia.com>, AXu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250407164009.GC1562048@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <yq5av7rt7mix.fsf@kernel.org>
 <20250401160340.GK186258@ziepe.ca>
 <yq5a4iz019oy.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a4iz019oy.fsf@kernel.org>

On Mon, Apr 07, 2025 at 05:10:29PM +0530, Aneesh Kumar K.V wrote:
> I was trying to prototype this using kvmtool and I have run into some
> issues. First i needed the below change for vIOMMU alloc to work
> 
> modified   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -4405,6 +4405,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
>  	if (FIELD_GET(IDR3_RIL, reg))
>  		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
> +	if (FIELD_GET(IDR3_FWB, reg))
> +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
>  
>  	/* IDR5 */
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);

Oh wow, I don't know what happened there that the IDR3 got dropped
maybe a rebase mistake? It was in earlier versions of the patch at
least :\ Please send a formal patch!!

> Also current code don't allow a Stage 1 bypass, Stage2 translation when
> allocating HWPT.
>
> arm_vsmmu_alloc_domain_nested -> arm_smmu_validate_vste -> 
> 
> 	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
> 	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
> 	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
> 		return -EIO;
> 
> This only allow a abort or bypass or stage1 translate/stage2 bypass config

The above is for the vSTE, the cfg is not copied as is to the host
STE. See how arm_smmu_make_nested_domain_ste() transforms it.

STRTAB_STE_0_CFG_ABORT blocks all DMA
STRTAB_STE_0_CFG_BYPASS "bypass" for the VM is S2 translation only
STRTAB_STE_0_CFG_S1_TRANS "s1 only" for the VM is S1 & S1 translation

> Also if we don't need stage1 table, what will
> iommufd_viommu_alloc_hwpt_nested() return?

A wrapper around whatever STE configuration that userspace requested
logically linked to the viommu.

Jason

