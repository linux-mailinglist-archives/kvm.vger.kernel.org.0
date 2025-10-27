Return-Path: <kvm+bounces-61236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0316C12127
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C85A31A2216E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E1C32E74C;
	Mon, 27 Oct 2025 23:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m7JaOIIl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D31314A84
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608238; cv=none; b=Ou7tTlKI2jx9B366j/5GplBsnjnOignw7zwOmMliyr/yAFGaD88eBxLxhs9FdW7nxJtnJYHDy6R0UvV6q/QrOtp86LQuaSH4u4JNHOxmHtiBgIeIc+8Eadjvg8fCytSwD1uOXDP1IxiQVSF8nwhPScP6yVLodhb6bh1/iyM4L1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608238; c=relaxed/simple;
	bh=5fxdEJqLRN1tb+ss8xTO6a1FlGbLgSxQYup7sfAznOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfM6LE8FcUC2vRyXyCeOR68JH7kKTjmYtVzEZAmZp1jYr6BKsTFtfj+xKOf8KdiOf5TBk6kiaSegWHFUkU1GfIfjRPue0esS+bGRfwTS+MrhSmfx5XSLW5QSCRkqLsSkHqchKMwqM6Jc3luWwUWDN0uSiW94de78dRuOZ6jwcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m7JaOIIl; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33ff5149ae8so1894631a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761608236; x=1762213036; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y25RVEc5uqdT77E62cdiRIe7zTZsno+Zu/0KbIShg9A=;
        b=m7JaOIIlQm+eKJYwobgLwOcOTA0ZD7WCnE9bwrhCdmJDTZ9zga2Jy9w7UPHVwTGWIY
         swWt2dWlH6+XSnffAMJnNnsC0FNi57A4mwQheMPq4KqZEqLDP+QXPj075aUYBQa66vZE
         o7xRjOwaBJ3KcdmqwjPK3luN1t5m5eArnXISeiE78Gy9GTYv2/XQZIWaGTvYNKoksCva
         WtY/+sLfWH/ehuVOVulmlZxQPd9SWw1K+1Z6LAdo3Kz0F0joyyUG+eFIbT5SECxLxX1v
         DL/bHJfX+NBKfDq9hPJ200jBYBY5GNEMoJ0H1O2FODsldLDe87s4rjSUXEtV7aUitrhw
         HATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761608236; x=1762213036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y25RVEc5uqdT77E62cdiRIe7zTZsno+Zu/0KbIShg9A=;
        b=myIYR8c6npMIqFs+ahDTXHjLaXrSYw5gt3woE9pEjkrYIOsVGQyTIBCEiEAFYk/HMI
         1y99gH/2sCnvp/ahqGnnjum3WQ2MIG/bNCn3bK4R/McHTRVGdfkt3MiA+GUpnRtgAkv0
         4GGzqaYuDjQWIcMou3Z7hHxfFsil9Rfi/hxMx1KrqvrCZK1VdR12CXEFcpeuA+HYrP6y
         /6A7s+LUMj+ajrU2a8LeKMx7uiBO67id+CmD8ZQb0UF3R7edabcx63fitZBNCXKfWZvs
         6UhZ5lF29bszmBO+L9F1YD8AKUtDzo8dCXfkovFIGkLdQvQhUlsyqtwA0hVrzs+sn9TO
         C93g==
X-Forwarded-Encrypted: i=1; AJvYcCX7S1wRwp0hYLwe2Ebt8U2Udo8I5UhEKT4EV0kgCheq2c8NUP8kZquXZtr7IAckCxUprwY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhmfYbctZrXwZuMG1Z2JG7OKw45SCbpvzYuaR/IrjWq8pcbw2d
	VNSTsSVVjYBMYIs4+uYlHFPM9aQXmmczWtkPn9BGSHbrnsdsla5YvD9jCIqJWv6/Zg==
X-Gm-Gg: ASbGncsdfYPudlcnkgXPK8UjQ8fiL5U0/lwAXXpE+L2IgOfTzAIB71QiOYQIjr5mZNR
	eAID7SCc0MOZZUl3qbLG3rCFyvOtjCpwU5ZCsuRcb8OVGNnqrE0HRuXY21fOjwxox9ADsmRfqTH
	PXYcMoM0kuRJJpVCRfe54ziYR9KevXnzhgreYDsjRKxdtTDga/kCoXcUbwP83a3+A9qC+5J2Ntn
	nm2N7l4NiCDtRjIp2XAEjevnSiKlYF/nR3xFPSpwtZ9R+s94Wvijdhix/JltD2aIwM8SFd8CAK4
	0Y6156OmKnXzFUXusgU1eD63ujc3652EEcaOBxztIBwgQS9WM3riM2u3nQ9CEY/17DPjiAmVUfY
	bXO70IZ1KVFcdP1cwUfD3+uKwL+tZNWN3X/O9EJNBZXeQ7W7Yn2kS0cUUPVNbnGBnyd2BukikUr
	3Dy8APCaTZVHZfXgCUSMZ9qbDpLRGG6vuRRGm1N5urd5WI2nBTpE0AcFTwTLsxRKA=
X-Google-Smtp-Source: AGHT+IGmKX74epTI3A/iK0KHRQ0gJ5rV+oqAQAXmFZTOi70Jf1LkFq+8kZDCItWUYfvqvUNhL5cm4Q==
X-Received: by 2002:a17:90b:4d0c:b0:32b:9774:d340 with SMTP id 98e67ed59e1d1-34027ab36bcmr1685369a91.33.1761608235576;
        Mon, 27 Oct 2025 16:37:15 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed80aa48sm9919097a91.13.2025.10.27.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:37:14 -0700 (PDT)
Date: Mon, 27 Oct 2025 23:37:10 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/5] vfio: selftests: update DMA map/unmap helpers to
 support more test kinds
Message-ID: <aQACJucKne4DRv06@google.com>
References: <20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com>
 <20251027-fix-unmap-v5-4-4f0fcf8ffb7d@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027-fix-unmap-v5-4-4f0fcf8ffb7d@fb.com>

On 2025-10-27 10:33 AM, Alex Mastro wrote:
> Add __vfio_pci_dma_* helpers which return -errno from the underlying
> ioctls.
> 
> Add __vfio_pci_dma_unmap_all to test more unmapping code paths. Add an
> out unmapped arg to report the unmapped byte size.

nit: Please append () to function names in commit messages and comments
(e.g. "Add __vfio_pci_dma_unmap_all() to test ..."). It helps make it
obvious you are referring to a function.

> The existing vfio_pci_dma_* functions, which are intended for happy-path
> usage (assert on failure) are now thin wrappers on top of the
> double-underscore helpers.
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>

Aside from the commit message and the braces nits,

  Reviewed-by: David Matlack <dmatlack@google.com>

> @@ -152,10 +153,13 @@ static void vfio_iommu_dma_map(struct vfio_pci_device *device,
>  		.size = region->size,
>  	};
>  
> -	ioctl_assert(device->container_fd, VFIO_IOMMU_MAP_DMA, &args);
> +	if (ioctl(device->container_fd, VFIO_IOMMU_MAP_DMA, &args))
> +		return -errno;

Interesting. I was imagining this would would return whatever ioctl()
returned and then the caller could check errno if it wanted to. But I
actually like this better, since it simplifies the assertions at the
caller (like in your next patch).

> +int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)
> +{
> +	int ret;
> +	struct vfio_dma_region *curr, *next;
> +
> +	if (device->iommufd)
> +		ret = iommufd_dma_unmap(device->iommufd, 0, UINT64_MAX,
> +					device->ioas_id, unmapped);

This reminds me, I need to get rid of INVALID_IOVA in vfio_util.h.

__to_iova() can just return int for success/error and pass the iova up
to the caller via parameter.

> +	else
> +		ret = vfio_iommu_dma_unmap(device->container_fd, 0, 0,
> +					   VFIO_DMA_UNMAP_FLAG_ALL, unmapped);
> +
> +	if (ret)
> +		return ret;
> +
> +	list_for_each_entry_safe(curr, next, &device->dma_regions, link) {
> +		list_del_init(&curr->link);
> +	}

nit: No need for {} for single-line loop.

