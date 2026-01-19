Return-Path: <kvm+bounces-68527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 015F1D3B40D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43B703120C8D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 17:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D32D31280D;
	Mon, 19 Jan 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PcdR0EK4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3992C15A2
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841996; cv=none; b=o5PZ6L9i+leiffXydWqDZpmFWGaH/KxXSubZrP7x+noiYz9EKeM3xwMIqm6uI3Rq7swb9O4RqD8Am/qx6HbI4SYZtQAzZlTmM9hWHBXe/qcVi4EdN1Y/JYFWtnOaucv6vx9AOV6F1LRxKux61JJKe5gQad0vnkTBZ3sgk41/egA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841996; c=relaxed/simple;
	bh=bhDzKe3hBaMep6hb4Ruwhdat9qUjuZInlAgPSftgqs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzF4oXG7GEP7SUx+kBKCMXwz8s6sZIy9rPOiEc3oOsG+OprUXQDiIzRfudc/C2ifcoX+rI+LtRvw9DDlgPt0UprdH7Zq0sYCsVHTu3anY6tPmP4O7JmTtbqazd334n63B971UGUOc6xxP0DSmkBEG4kWHewAF4Y5ex1C7VA3SBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PcdR0EK4; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-502a407dabaso27990401cf.0
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768841992; x=1769446792; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TPsA7s1a/5IQbuetD0KLnhoW9jbCMPzN3lJpfuVRncw=;
        b=PcdR0EK43JTx60gis7CFG3xkG/NxLT5THwvgfbiJvSZZ5OLMwewfa5seKHPFfJ59W6
         ++EalUij4O7QvK7DVAsbqXikrhQnP54gv4aD9zMUy70Mwiqwvwg/S1guw9n/L+ORoBqa
         cFSQYnafWkvrpgiMFogqwcqDgIwtX8qk/jjG0oMFehi4NAEC6Nc0ahhq907bxw09MwGY
         s5yrqryAgTqoErepfDtJA7QvdEzqu6gio4mVCC5X+M292/Vsu/OYK+MZv3hcRsvGjKLk
         kvOEh5eTxnR+68YNdRvNq1mZCqAEoCk+mW63/bYvN/K5sO+eA9WfQn42b1+DRxQ076d2
         WtNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841992; x=1769446792;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TPsA7s1a/5IQbuetD0KLnhoW9jbCMPzN3lJpfuVRncw=;
        b=fqKjXg7aIQiS0ZSythcYCf84tgyaNhs36g0U3gyBRqRvzqTRNW4+9OOvTf9QonC60P
         XSLwJ5bRg4NvrEn5ibsxCcbgWvH6hp8Tm7mE40OkKh0uNAwGTB/QkqRNfcmUHMZ9xaF9
         4RWli9dRPv1ffw9pxTbNMgBgEPVQ9NjLLyzp3WW2rK2YimQI6AJyJPlX45PThYSgKXBH
         ljAOh+itVE1X8ltAAKZ9hNMFZbDntdJ1qdieOtW9ru78XqFQ/TUw1dfTY7lL4i7akdcE
         0FOJtChGqSu32J2cA89XBKsNCXSXWbusVHvhrKe78zD/df1r7JFvSmTm7otvF8jSqmr1
         MoVw==
X-Forwarded-Encrypted: i=1; AJvYcCXXC8RonIa+Tmf6NkNVPgSB5gxJ0qadud7Iy4HzfG86cQMESFElsvE2gsflxpn5ZhhDk2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxgTJPgmX6fLXXQL2V7DYU7rsc9vgQP6H7dpWQp5ElHiN3WJ0S
	deCg8DsVBNo8t7wLPsZvpamCU2J4c2vM9OhtTueH6DUuO2jgj/+JMPOUbPU3M+eDDsc=
X-Gm-Gg: AY/fxX6I7gB0tMCVutNEaG5qQFbcEWtOx1p5k8Rja751adBAzh6pFY2WNr94Gh+kKb/
	nQLGsCsALcZh/42J1sRE5F2kNC6GcjPmLM4v/72s+QCxGv/4PP2g6QuFZdJQSp0mxMt27oOTTTP
	CfXrMPjfrLbcJBNdZUeQLor7RUEOf3pbwsOoiKzuRIMzAavie7Ts/wFvqq/YY2xcMnvmhOA4+Zb
	zZBNHf2WSweUf8+OlN0XsEp5Q8bZdC6t3awiz+X6t1fO+QRTkJIOKYirTrZjwkHFaj/9f9dbD3C
	2kiF239HQ8ICqvKH5/9EIAJlysjl8MKaCqK709jwq0tuQ+74PHsxKbQYSCQhMR+9sKNPwHnaMqi
	8Jy7QysgD7eMCtTHLaRXESJZvU2C/FzCT3RqdioC+YSA8WWc7Ix2ZDoyZ0mD7tKLNKySfZ3hSI/
	5uHt5FXCeFWpbrjLP0j8z3DpgmAdLDfniv2cUAkwhZbX+0brCJoupH00fL6fweFMHhLsA=
X-Received: by 2002:ac8:7f56:0:b0:501:50cd:cd3a with SMTP id d75a77b69052e-502a16b363amr184663241cf.43.1768841992288;
        Mon, 19 Jan 2026 08:59:52 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e5e4d79sm93947786d6.2.2026.01.19.08.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:59:51 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhsbX-00000005IQz-1QSu;
	Mon, 19 Jan 2026 12:59:51 -0400
Date: Mon, 19 Jan 2026 12:59:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] iommufd: Require DMABUF revoke semantics
Message-ID: <20260119165951.GI961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>

On Sun, Jan 18, 2026 at 02:08:47PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> IOMMUFD does not support page fault handling, and after a call to
> .invalidate_mappings() all mappings become invalid. Ensure that
> the IOMMUFD DMABUF importer is bound to a revoke‑aware DMABUF exporter
> (for example, VFIO).
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/iommufd/pages.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> index 76f900fa1687..a5eb2bc4ef48 100644
> --- a/drivers/iommu/iommufd/pages.c
> +++ b/drivers/iommu/iommufd/pages.c
> @@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
>  		mutex_unlock(&pages->mutex);
>  	}
>  
> -	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> +	rc = dma_buf_pin(attach);
>  	if (rc)
>  		goto err_detach;
>  
> +	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> +	if (rc)
> +		goto err_unpin;
> +
>  	dma_resv_unlock(dmabuf->resv);
>  
>  	/* On success iopt_release_pages() will detach and put the dmabuf. */
>  	pages->dmabuf.attach = attach;
>  	return 0;

Don't we need an explicit unpin after unmapping?

Jason

