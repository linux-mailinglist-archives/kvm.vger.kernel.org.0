Return-Path: <kvm+bounces-38621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29A9A3CE50
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A6B73A6B73
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D023014A0BC;
	Thu, 20 Feb 2025 00:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="e8WDMlVf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD23214
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 00:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740013052; cv=none; b=O2teuSSleInWIhXZ926r5+mdN3sqVuBJEE9ZvKnh+PDxxk0p7fKeB9CVHNlxR28KTDpUTKO9PrrYACnF+JGQm4vVcYAy0Rz8XkKky/gDqyHgMN+p9sl/B4/kriZEqREL+GEe7XPV3gU4tBKWDBOcSuBMqYYGt7/So1EAIUnX0og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740013052; c=relaxed/simple;
	bh=Lnj8ZPF5lrE7Xc/uMpcIj9FkYaJnkbOF/02TZqJAndk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFouicNriPYfCuNab9zfHis7MGLQ48z9D/zCeDe9YOIAN63WJ1GRUokCoMKisMZEUs5iZwQzqwmKfWMaX/CpU1sCaVa6vNxkPY4c0H2CTcy5/LU03P+GJL+5QbLTzqE7s0s5DNGAaWruDwpEZhpvaQfvzASz9huE+AG84F+CN00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=e8WDMlVf; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-471963ae31bso4383021cf.3
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 16:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740013049; x=1740617849; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0/Q3pmbQgFaUMEz//cVYqBy+kD1niHA/UXy9NuQBpQc=;
        b=e8WDMlVfE5yxeWllC+GQsVY5Fcurb8PVVRLHcsL72GNWikAIAyXRdKLROdZjblWNlR
         wrcGOp99vmw0hE+MAEjtnkHQwpXYmsG6WMuRR/9L1MwFX9F0HitATK7ux72o08XVDR7h
         +l51hpxLMbptyGFfy6ln9NGior+w4ObgMcmDP88d60O8P2ByBv29QfgB7+Ay/bFR1Ydt
         P7bXM6RQcCwotY/6a1V55ZbmllEGtjRzC/I3pW3tzBFkh2xrha9uH2o1BbWRLjnGCQoJ
         YPxbnuMBnQoSM2qL4qGcRCYX6moS7UTTgzvshw6St5sKIr8Yw7CcxO197shj5vSY5xq0
         q3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740013049; x=1740617849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/Q3pmbQgFaUMEz//cVYqBy+kD1niHA/UXy9NuQBpQc=;
        b=gmOc7rXc7Gvi2c6DkQR7xLd8hERQKyY3WlEv0aF1wnfk02jeZUcjciX8CJ+aYIE3z4
         f23y0vU4nYxxjjYRWwUiQjtqR3oGU5nZrCMYlTxRh4bt9Csw8tjKsAMrYlseNH4fd/dJ
         w9nO86YMBp4LugZOBk0PZNs5rwMvtEYXMLkFqYZlAdRDBaiiwEgzuYjs5NKSt2CtJszF
         H4jMZlRSI9Nc2n9z0gXlUF/dJ2Uref9EHVsVCJGiNF8qfMCYAgQroWP6ra5FUsxCHSpN
         2SobtrhWTbN130kMOWbbA1RTAc12Kf+Pw8Tlqo1xjLub3CEqmAmBcOxjOysx3oexDWxp
         LAfA==
X-Forwarded-Encrypted: i=1; AJvYcCXarARCM7XkpEDEYW2AZmaA+2pevtxsnMU+jnxWjRTeV5gieNlSlU05dwCWcyhOvVCdyWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YycZpSsacXUgobQC2Fh2shZzQzgFjIslTIRM+tFCZNEO7hHxwgI
	RlHr34vrWYgvmeSBShRXVloSLX++preT+wfmDhCRF7K5pWFblMRBHhtUlklAebQ=
X-Gm-Gg: ASbGnctG2RVVAD1J4tfn3dKDfLbKWVSPCWLNRV5Kq4t5J2C5knN5fPfyGrBgswOrIv6
	5HixjXmHtqW6xSCVm0g4qf79Pv/hB9tzfzYUx/sMDca84DL6v72rP1QUKRGs9m9gLgcWXkIahvD
	rPXFoUjNL2rmM7LuzL8iIiIXIS1ltYTgnzKnESQeeKsJx2vBr4IDnoB1ziQAzuoFsRGDrEBc5oF
	FY2/gTMEtmGgTzKem7xKJbl8rS7/qcyTskMcehnx69v1tYJpfMtA2vQkWWuJAo1+FVbcCouO7Hy
	Iws2SP+iczte061KsXzx3JxKR2iavdx92XYKDy5D64B8OpnBGlrgeht542V8zyGH
X-Google-Smtp-Source: AGHT+IG5zCh9CoeLQY7rC+mk5ewFMnBFHyg7FBmH5U0ScrNRvZkI+aTZATrHIvB820rTi8JmR7A9wg==
X-Received: by 2002:a05:622a:1a02:b0:471:a2c7:b6be with SMTP id d75a77b69052e-471dbea0a25mr253348721cf.45.1740013049013;
        Wed, 19 Feb 2025 16:57:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f3f6e90bsm36101381cf.79.2025.02.19.16.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 16:57:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tkusZ-00000000D45-0QWL;
	Wed, 19 Feb 2025 20:57:27 -0400
Date: Wed, 19 Feb 2025 20:57:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Michael Roth <michael.roth@amd.com>
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
Subject: Re: [RFC PATCH v2 12/22] iommufd: Allow mapping from guest_memfd
Message-ID: <20250220005727.GP3696814@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
 <20250218141634.GI3696814@ziepe.ca>
 <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>
 <20250218235105.GK3696814@ziepe.ca>
 <06b850ab-5321-4134-9b24-a83aaab704bf@amd.com>
 <20250219133516.GL3696814@ziepe.ca>
 <20250219202324.uq2kq27kmpmptbwx@amd.com>
 <20250219203708.GO3696814@ziepe.ca>
 <20250219213037.ku2wi7oyd5kxtwiv@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219213037.ku2wi7oyd5kxtwiv@amd.com>

On Wed, Feb 19, 2025 at 03:30:37PM -0600, Michael Roth wrote:
> I think the documentation only mentioned 1G specifically since that's
> the next level up in host/nested page table mappings, and that more
> generally anything mapping at a higher granularity than 2MB would be
> broken down into individual checks on each 2MB range within. But it's
> quite possible things are handled differently for IOMMU so definitely
> worth confirming.

Hmm, well, I'd very much like it if we are all on the same page as to
why the new kernel parameters were needed. Joerg was definitely seeing
testing failures without them.

IMHO we should not require parameters like that, I expect the kernel
to fix this stuff on its own.

> But regardless, we'll still end up dealing with 4K RMP entries since
> we'll need to split 2MB RMP entries in response to private->conversions
> that aren't 2MB aligned/sized.

:( What is the point of even allowing < 2MP private/shared conversion?

> > Then the HW will not see IOPTEs that exceed the shared/private
> > granularity of the VM.
> 
> That sounds very interesting. It would allow us to use larger IOMMU
> mappings even for guest_memfd as it exists today, while still supporting
> shared memory discard and avoiding the additional host memory usage
> mentioned above. Are there patches available publicly?

https://patch.msgid.link/r/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com

I'm getting quite close to having something non-RFC that just does AMD
and the bare minimum. I will add you two to the CC

Jason

