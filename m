Return-Path: <kvm+bounces-59638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A393CBC4C27
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 14:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BED63B93EA
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 12:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193A822A7E6;
	Wed,  8 Oct 2025 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CE0wtmDP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F123D1F9F70
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759925976; cv=none; b=nlihXWEpfpYSzzR/RttzMw7ivqsyXCOe+0IOxDu5LF/VEOMYuxu0IbcHQD86lPs9m0ah6lTgEjVp9XKg9e/7LUQFfpEhxZt8/6ty+TlPVXFwtftOKvNmPr4xFHEAGpZ8G6gkhS3grTJalui6/MERYSlL5jLLU6XYgHlDPjIyqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759925976; c=relaxed/simple;
	bh=cl8k63xs7v+qt2gCL1vkZW1OPlRlPvg4Lj9UgRgsNM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsM1JQ4h7PkU2M5x1VlQYCUy90NQUexmkcWMqHyVZsdGEjBYdsyaCiOsFa+m+go0TAeGTmb3gSuyU3CiT7lpCPJ4PVBprUPtMTsc3CgYzQEqUFy4vKW5UwyC0Pw3Nc8b39Ri2xUScHFfvr6frDN6OGVMOQ6V43FMxE9DUTODmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=CE0wtmDP; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-858183680b4so904133785a.2
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 05:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759925973; x=1760530773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycb/q2bsvNzXQRATVSdf4qauXcR+Jqk3agguMylW6OY=;
        b=CE0wtmDP0v/zv+rh35z43vlnBZX4DFYbCdm+DDqfdwExwuL7IhkNXRAnRfGFRSr9nP
         LsXfBeQ5MOvr+rjtJRf9UXogv74xEJcbTJnNIKdyzlRgBkMoRNJs7sAFSfaUvOy8kxDu
         J2reBry4fma03t12djxUEsHEyqMt/qWik3yAIYtADxy9Iv3k4vzdq0qTnBMs071r2Uce
         VA6a42Ztso0qPVys/wbvROLgie8e5aQG3GuBIXjx0WtSQlTdTOKuyArJp2qBfTAaJLXa
         oJKeCQMEuNB6KsP89IlcbgCjSq8bqx5pieoocvldXAfkbWWlds3z4p/y2/g5Y3i+GxvF
         QMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759925973; x=1760530773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycb/q2bsvNzXQRATVSdf4qauXcR+Jqk3agguMylW6OY=;
        b=tltswwFJf88xs/3FW8zZDZVAh5KcGoL5Tv9PBv2XLTHYT6PL1iQoswSS274E8Lq+1u
         5PFSasN8jJqeeqGwfIETNzEjK8QydNrQsDpbgWiZiFKx3nxzXKka6fdJMyI5wkSIm8FN
         w4ML2ez+ge61wTh4HiOkjLNhjC1rsytqNntPVxoYAA5NNn+Wn8GwmbRDd+HrlQpGbYCS
         IVWPRsgKKmvqof4lG1LrbgUbApzGidjs84Ljpo5SlWEf0KWXkMORUkMGHUKv4xADfz/K
         rRQW0Z+SaA5A/7Bo1JWwEgdEX99TZQXUk8Qy2ZgGmbZrbyO3VD5M6VkjeUhHAlx0vyiJ
         tZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXawvsrzD+wrjfcJxcBuVRFw45RcK0hLbch0dB7FZAqhh2yOrN0sgKURG4H4DNcEXDu27E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOgDYEf8BwK7JGgA5EVZw2B5wuJLaRCE5m431DdlwfMO8NOryE
	poSe74Bj81+XHWK04xHuRoxHwXI4s89iZwo11AOx8GqQ0jWVjfVnGQfcI0lKW1JrgWc=
X-Gm-Gg: ASbGncvVjVFljgbBvxo4PDQ5XZJTBs0vkaEPitm1botHh8q5yRIMEbXE2KJsRd2Tr1b
	3b5XBG/oIKxMTZh7uWQhOgygeiVUu8oS5Ni+SsiDKdfnO0n1wNcPLNEebriwxKfMbb4cM0SHovv
	WKkmsCN4ksD2sDmcOZQSHFyqG5VfztEdgbulx/zuAdeTW+xRjnzLiMhvtT38zF/qbbCKlH8LBoS
	OvctKgZa78z9w1a2PR/hxCqtwKTjyO8TDisqki6+ocianebs/8JTUd1B/mBqyLd2DuMEPwJJpIO
	dYWlUn5QouSeujd6UqdD8bt4gy8yLSqD44AoXDN+LxGHKJl3Li0JI8FNrrnKw0gS4LrsiLoXQ1G
	2158GFLSxyBZo8wBNW5GUtQn0GBYq4iOQ
X-Google-Smtp-Source: AGHT+IHCTzg7bdE+/taaCGlaCVWcTsrxo72q3rTma8r6ACNCH9CQ1mgzy4PaB4MwzgfRMTMfOIxXpA==
X-Received: by 2002:a05:620a:488d:b0:85e:b7b6:81e2 with SMTP id af79cd13be357-883521dd1c7mr562408885a.50.1759925972728;
        Wed, 08 Oct 2025 05:19:32 -0700 (PDT)
Received: from ziepe.ca ([140.209.225.78])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-87778650910sm1707535585a.40.2025.10.08.05.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:19:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v6T8l-0000000FnKy-011C;
	Wed, 08 Oct 2025 09:19:31 -0300
Date: Wed, 8 Oct 2025 09:19:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vfio/type1: sanitize for overflow using
 check_*_overflow
Message-ID: <20251008121930.GA3734646@ziepe.ca>
References: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
 <20251007-fix-unmap-v2-1-759bceb9792e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007-fix-unmap-v2-1-759bceb9792e@fb.com>

On Tue, Oct 07, 2025 at 09:08:46PM -0700, Alex Mastro wrote:
> Adopt check_*_overflow functions to clearly express overflow check
> intent.
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 43 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index f8d68fe77b41..b510ef3f397b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -37,6 +37,7 @@
>  #include <linux/vfio.h>
>  #include <linux/workqueue.h>
>  #include <linux/notifier.h>
> +#include <linux/overflow.h>
>  #include "vfio.h"
>  
>  #define DRIVER_VERSION  "0.2"
> @@ -825,14 +826,25 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
> +	dma_addr_t iova_end;
> +	size_t iova_size;
>  
> -	if (!iommu || !pages)
> +	if (!iommu || !pages || npage < 0)
>  		return -EINVAL;
>  
>  	/* Supported for v2 version only */
>  	if (!iommu->v2)
>  		return -EACCES;
>  
> +	if (npage == 0)
> +		return 0;
> +
> +	if (check_mul_overflow(npage, PAGE_SIZE, &iova_size))
> +		return -EINVAL;

-EOVERFLOW and everywhere else

> +
> +	if (check_add_overflow(user_iova, iova_size - 1, &iova_end))
> +		return -EINVAL;

Let's be consistent with iommufd/etc, 'end' is start+size 'last' is start+size-1

Otherwise it is super confusing :(

Jason

