Return-Path: <kvm+bounces-7861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5615384734C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E54651F2137A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D151A1468EA;
	Fri,  2 Feb 2024 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="It4UgSvK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48D14690F
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706888193; cv=none; b=MJ8BmaP+YDqrk7WypopoNTv5b06v6lO48+kZzNeb1s8EhsdfXV/kBbnKmyo15WoKQl7lGTzTlC7Bl2Uuyy2JJPf+N4/rc4LPvW0bZW+dpjwhHSLqqoisn7XL3YG4jrUmVOMds+ziB7Ry1NpRFAyXCL2qf6/MES580J7BaVCx9dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706888193; c=relaxed/simple;
	bh=Fg0vF/DKGnFKdPAxtNJWEsCiIanMISLov5rth1azicY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuYh+gwsS1Ha1N1QnLZN0QB8vKfwa69qxzTomvFE1nX2W7Ehv0xEsP/VEHid6A5JXEzf1JUoELErDCeF6UtV1U6JZz753LUX54Xa1KYVLx691T06elvZddh9twHdC42RdjMMS6Z9LPRfq4A/15nYgKT9udr7JoENTnHHfZ5G0j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=It4UgSvK; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-783ef8ae70aso163627085a.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 07:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1706888185; x=1707492985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRSa4TT8HVH8576bDhqIPmdbLRM9nyjGP0P+K9geus8=;
        b=It4UgSvKLEpxOMpS7xqSJijhPsH5kq6d3Z3PfOt64xfqKYUDQc7S7XNMYqrlf28Ssu
         e+tGq/2S4bUWfo+1XQlYrbDhpA8WkOOsfyTnY1m8hEogjNSGCIQBfXAKjK5btJ8E6SQ5
         ObGCy93QhPdj8VXDJL5TKrU2NCdFk8xkyLcbkRtBk5ij7GOrxU6WLdaJ7HECiFAr4A/4
         tDTzJvc+SyfUhnyqrb2JUf3kIAEzvcwcb6VOvIg705tsAHtW6aGXGYh4PYBaGSBwdzNC
         zhrhSCEP9iJjXygGv12cK3f4Dc1ZaEgaty/QsSTeOqnaeYk9IQCjPE3SLKk2Q/hLnFMw
         vnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706888185; x=1707492985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRSa4TT8HVH8576bDhqIPmdbLRM9nyjGP0P+K9geus8=;
        b=az9F5m7xsa9uOGtWDPbolwkyY7rcgC3TgYVdZiW8JXGXXDTaetEBbnDCcxtxYahxlM
         bTA0vpcD5mXFGZ1IMgDubhAqwl2S8DHlrK3Oz4SW/ew5XxYgXqqpMrq9msPkIRcLJhDT
         2EOEa6DnFRwfLuyX9DddY+OKNOHXRd3daNuOBKHuLlOJytknP/6E3rwKiypXiqqZOKOz
         ez8CXVfoO4UOXfxyW7PILImaoihyKmgXtIRW6WVdpyQSq7lbJIf3r3LEw6JCJmkOeTNY
         cMloG8QIoVbMs3O0z/l80L658gyKtFDY3m91vN57dStaLDLuTDxocRDquvgCaHSTF87a
         j2Hw==
X-Gm-Message-State: AOJu0YzWFq3mzbKJLTm9uohHxdnyjwWsixRnoHxZdHWZE5zrB8N3qbt/
	3XZZTBV/v7wwr9g8DvQZ/SKc5Kaw+1i95XHBHSAEtCnIQCRD+lWzindyvDyxs4g=
X-Google-Smtp-Source: AGHT+IHgoLTjDGqcVBJHeDO/+4xepghxs6zy3yXbqAEo9+eksg5MPspO+NnPRp35JWUiTkmwcplNIA==
X-Received: by 2002:a05:620a:1447:b0:785:43d7:cd0d with SMTP id i7-20020a05620a144700b0078543d7cd0dmr5503107qkl.27.1706888185060;
        Fri, 02 Feb 2024 07:36:25 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUFwKseQX4Qsq/U7oliva32huh0WpnlP9H2RmmN32JeZGOlrWJLaJZWLc9ppObbDwYDQV4sN7pUUZMCsO8tSFXSQJmcRGn+0ufquLHbJD1n5fzINj6sjjJv3dkjJOrN1QEsZiBVWFkYzeqnXqMwOqEHyIymkSi3B0oCOc5x9B6RE9X0hh8jrCLAS/PANjfoSo/rRgMRJGBcFJUCufODDCXB9jPLvby/TOw6PDi/PiXXaNWf6dsKiH+LDw3kiKrGVwerK4/DkUHol9QZWPHWp5Omyx0ca2rOvsUYk+OUWtuGlc7B0eOG3a6RzgWhdK8dYHm0gscYJwdfLAiXXgZ7SzzLyziu3DsqSb/YsxwTsJLPwdREaYfhXn96czeFqnVrIVcsWxSSIWpVfPCraGXpvS0VTC8bFw6Xzg4VBcDrwgor7MFt03tk
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id vu21-20020a05620a561500b0078552f53b85sm724769qkn.86.2024.02.02.07.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Feb 2024 07:36:24 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rVvaZ-00AwH2-RL;
	Fri, 02 Feb 2024 11:36:23 -0400
Date: Fri, 2 Feb 2024 11:36:23 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 15/16] iommu: Make iopf_group_response() return void
Message-ID: <20240202153623.GA50608@ziepe.ca>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-16-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122054308.23901-16-baolu.lu@linux.intel.com>

On Mon, Jan 22, 2024 at 01:43:07PM +0800, Lu Baolu wrote:
> The iopf_group_response() should return void, as nothing can do anything
> with the failure. This implies that ops->page_response() must also return
> void; this is consistent with what the drivers do. The failure paths,
> which are all integrity validations of the fault, should be WARN_ON'd,
> not return codes.
> 
> If the iommu core fails to enqueue the fault, it should respond the fault
> directly by calling ops->page_response() instead of returning an error
> number and relying on the iommu drivers to do so. Consolidate the error
> fault handling code in the core.
> 
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h                       |  14 +--
>  drivers/iommu/intel/iommu.h                 |   4 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  50 +++-----
>  drivers/iommu/intel/svm.c                   |  18 +--
>  drivers/iommu/io-pgfault.c                  | 132 +++++++++++---------
>  5 files changed, 99 insertions(+), 119 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

>  
> +static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
> +					   struct iopf_fault *evt,
> +					   struct iopf_group *abort_group)
> +{
> +	struct iopf_fault *iopf, *next;
> +	struct iopf_group *group;
> +
> +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> +	if (!group) {
> +		/*
> +		 * We always need to construct the group as we need it to abort
> +		 * the request at the driver if it cfan't be handled.
                                                  ^^^^^^ can't


Jason

