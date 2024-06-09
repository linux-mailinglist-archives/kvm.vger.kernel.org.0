Return-Path: <kvm+bounces-19124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BD390167D
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 17:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDC3FB210E5
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 15:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445EB46544;
	Sun,  9 Jun 2024 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s+j8k3X0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8BE3FB87
	for <kvm@vger.kernel.org>; Sun,  9 Jun 2024 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717947199; cv=none; b=lRSOUWP/c/0sdQeFh5Fy6JAFktELhqQiIN/1OwAUNB1eYWuXIJd9+xItmD7k9jN2QDdO2V5i9TKS598Co5x7epmvbEJI1LP3iUPWlq6+S3UJAWsrSkyE04cCWJpSsYYGCWViBn+VZFCxeEGBTx/t4c3ZZlbeBbQrn/aONReFegQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717947199; c=relaxed/simple;
	bh=r4v/UAXdtaVQkhy3RY4WN1zXyyz8Oiobysf6yxbLWck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEr5LSM1TxPZ+Yn0hdeBUrdylUJVocErX8xj7YNdqFZBPlL0ZJbQiRV/OZUlqOsPi23FClyPLiZ6tNWoR4nHGOQazPo1CegUEyDM4D8uAy50OqzI7jZUW5i8MJtTZdqU5EnnHBwflxB/f2d1cv3okuqA/YoZF2DYBDXZLaHBST4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s+j8k3X0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42172ab4b60so14580585e9.0
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 08:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717947195; x=1718551995; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dvLb4EQePzdCw1JidNRQOd0lUeEVij5wud7SriP9HXs=;
        b=s+j8k3X03tydr5dzTCiWG/szBtN2dnnYY1oI99tPUTgJS1+5q5idKpXsfJPZvf98Gm
         udxSMh38XDJuegRTX5ac2j1BppV/UkNEn7HTp1y5CUjCBejDDxR6kHaWv9VkGaDarq/5
         qf+V+B/TZSwM5b39zSp4OG6bC897Of+bt3vC4/Ms6o1gV2kSiIvhcOrMftwaSHAeXVpZ
         5uqm41bwPW0bw7nvgmDedI4rcMR9TiNB7o+8MY5kIJMyBicRCC0cEKdM+SuXoULrPhFz
         QyclpCH9O6ufltIWptXfkOm1aDtqRheTt2FwZfDde70D3RT7dBoeIdUNayTVhhvyN8mH
         bgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717947195; x=1718551995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvLb4EQePzdCw1JidNRQOd0lUeEVij5wud7SriP9HXs=;
        b=WN87PC4+Bq2725QUfzxHs05r9UIXkSt2JXceZmf3VwJuryr23IksmLbIGTknSyHHyT
         RDZE37IhV/igSzhYpjfviZSOE23VqOwVc+ogUjBBfPPlIl9DqKUJJq2xq4TOOQzWYWKi
         Vsmwa6c172oIFRP3FPNyQWC0ccwgy1y8XyMr/6XBFWzruBPHwFBqxPVd/oGIBznpz5Lz
         GTc6YgVGjPa4IM+sS3sowiaQNRM6paOvqMzmn086K3kOhMCPY8Vu/2PbvMSPOWedD0Gq
         RVEokRDxo/VwsJ6no5uCf8lbsAJ8JGH1BNaxEnNnk1XKyx0/zMVYXvLHB+qw/uWNq2Ni
         2ggA==
X-Forwarded-Encrypted: i=1; AJvYcCU7ne5Svaot6IDrsfbU6QL8GCqcWta6q6CQ2HuSDLTjq+EX7mn25bzoTSndtLsK6O2pxbQaAE+kpd1wBApHDfcDU1lq
X-Gm-Message-State: AOJu0YxLIbb3W0hHUNHf/qf4fZpIUQ6/7Q50PFFa+y8lVJZpStt2CfPK
	9qMRfqve4d65Z2fOTmvHT2JSpzQPE+s1K7lsCR/VjUKrRzu/L9GE5UUhYpveDDo=
X-Google-Smtp-Source: AGHT+IFm2QG2Dc0gqMxwmCkOPINESWV60cY/tnsvGA5b6O3SaTzlM4NQ1WMs+ajiXNmXKiIgssrQ+w==
X-Received: by 2002:a05:600c:1f8b:b0:421:7983:f1c4 with SMTP id 5b1f17b1804b1-4217983f41cmr39632065e9.6.1717947194928;
        Sun, 09 Jun 2024 08:33:14 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215c2c7e8fsm114725415e9.38.2024.06.09.08.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jun 2024 08:33:14 -0700 (PDT)
Date: Sun, 9 Jun 2024 18:33:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: griffoul@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
Message-ID: <1855e4d2-02da-4ea1-94b3-8daf044b1243@moroto.mountain>
References: <20240607190955.15376-1-fgriffo@amazon.co.uk>
 <20240607190955.15376-3-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607190955.15376-3-fgriffo@amazon.co.uk>

On Fri, Jun 07, 2024 at 07:09:49PM +0000, Fred Griffoul wrote:
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e97d796a54fb..e87131d45059 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1505,23 +1505,28 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
>  		size = 0;
>  		break;
>  	case VFIO_IRQ_SET_DATA_BOOL:
> -		size = sizeof(uint8_t);
> +		size = hdr->count * sizeof(uint8_t);
>  		break;
>  	case VFIO_IRQ_SET_DATA_EVENTFD:
> -		size = sizeof(int32_t);
> +		size = hdr->count * sizeof(int32_t);

Not related to your patch, but this multiply can integer overflow on
32bit systems.  Better to use size_mul().

regards,
dan carpenter

> +		break;
> +	case VFIO_IRQ_SET_DATA_AFFINITY:
> +		size = hdr->argsz - minsz;
> +		if (size > cpumask_size())
> +			size = cpumask_size();
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
>  
>  	if (size) {
> -		if (hdr->argsz - minsz < hdr->count * size)
> +		if (hdr->argsz - minsz < size)
>  			return -EINVAL;
>  
>  		if (!data_size)
>  			return -EINVAL;
>  
> -		*data_size = hdr->count * size;
> +		*data_size = size;
>  	}
>  
>  	return 0;


