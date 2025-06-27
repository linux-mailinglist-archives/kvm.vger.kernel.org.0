Return-Path: <kvm+bounces-51034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21020AEC23C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 23:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 440EB175D17
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 21:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE1A257AF3;
	Fri, 27 Jun 2025 21:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAEutL0K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05AA17741
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 21:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751060742; cv=none; b=Cs+SAUiLwCoVhOcfZLEWuF7Ot0UNb2GcrKbldxbTGjB0tlatInfFzDfp0+hwB5UyZUzYLqZCqm0n0+1NJyYQzbzaazdKttbmSdl6lwXNJ96NNDgnbC/tEVnADCz37ioRkL24seUdRT9pmpMXnD31VfhD3ieUXFMsD/4oK2oPI2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751060742; c=relaxed/simple;
	bh=IqUPu+qg9sK5TF/ONuynkNsPXpFLxC7WTe9/O7FmF6o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INk5PlzFsQ+YNzWeT6cM3mhDwpzrNGvvBEDwf1DoZfgUVspkDX53p8vBPcrZjC/bk/AUYPwh9lSAzj9SYkUAn0776FL9Lv6HlQZd/1KgiVXO1ihpGClNORllj5k1Lmfu7j1FJvrgHNLna8IBrVeIDD99Z8A2U/iIemv06KtIUxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAEutL0K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751060738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0xGAel75XXbnqolX1Sol4ZBrPxTic65nLbHbUl0AD4=;
	b=aAEutL0KIRGralTPyCzGyNB1sYdhKOOxcMq6Txk5a5SmSpq+z+PLBIxoHCK0OoQ1B5KFxt
	i6UdVbOCXtkquW7QK9y+2x07DSM+f955AAeaEGoNdyG98ZC822hBtTnycXTgvuuNEHlGZf
	YWg2+piw+qaOrkK3B/v5pnYD2JUmCn4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-rnm1DxU-MYKvL87uxI89Tw-1; Fri, 27 Jun 2025 17:41:03 -0400
X-MC-Unique: rnm1DxU-MYKvL87uxI89Tw-1
X-Mimecast-MFC-AGG-ID: rnm1DxU-MYKvL87uxI89Tw_1751060463
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-876986fc4f4so781939f.0
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 14:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751060462; x=1751665262;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W0xGAel75XXbnqolX1Sol4ZBrPxTic65nLbHbUl0AD4=;
        b=j34FjTXm+iP7V2mQav4we7VZcCVOT1Zd0an1SOSFLf++ouUcJlPFdw2xIrnQU5vq/G
         A3grnPyqA1K+/+Zn08pWZS6E3OMgSL25sGF1bJFvi+eKBM4nFj0oz5EJEkC3Fs5ZRgH6
         eXNOEaOBVQuS+wjlvPLUvg8pRsXIYX9WNTeO8glLVp0oE3QevFjJOmN2aBHFvq630kNd
         Vx3KU5wWm5RXtJiRFak87k8u9bH9xvK/G0AVTEoTk0noSuBrkgdXfZpGrMQcJnsT014o
         fiCPYzBJ3ksfZcPiennthziyMohjb8qq04FKDP0vQXUNzuujTGnyQig00skz6Xhhu7Ks
         htZg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ92gNFpOILb/Q7ow0TS+pTZZZsW5vHpPXUWR8cLAAbP01qn/rOhgPZ5gDIJXF19dbxeM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6lyR/2W71AHApkYSdaAy6zpMuZp7Wn4KjcESm2J1Iglm+yRYz
	XUXUsOaq7Z7d9HBmeIUSbi8kk0yhvajal240DuNV1kMThsg1tiGhu3vJl5C6w8kDMEikNxSG6rH
	K9IXf3TapiwiSo457aoNd8Q5T4XrlWuhzUVOiDOpdzN2eeBtsLNn4UQ==
X-Gm-Gg: ASbGncvveXyszdn+UHFYJHxgZaTXnTK9gEd6mMkdwMEdnaA4Q8qptSjd4Vybeeb5gZG
	RrvFocHlOUnWGXngL/sSnKydt/eZ4U/PIGUT9i7IL7LG24xpUhhtxE+OHTTk4EXlY5nDbysQEdz
	uyHFinpJgttJhN6cBsGZckAAxU/fGJ8mrKo3rxdiZXxw9D/ev7E2y2jn9q288+E6jIer1W8OBir
	I4UGR3sfkEcNH/dSXDsE/rGZtdpUfyXQaRDJ5VvNMwBUfhSizl2C2b/WBiqj8QEjeA5hEHU6rnw
	js7zgEnNL1udoBAd+sg1GGUVXg==
X-Received: by 2002:a05:6602:3a13:b0:876:9870:92e8 with SMTP id ca18e2360f4ac-876987093aemr4618739f.1.1751060462578;
        Fri, 27 Jun 2025 14:41:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcc6o5L+EH5s3y9O32PFIOvsVsoPdfQruBa6++XvBeY6vYzanbj3YXtZkPOKwtPxVRDrxEdA==
X-Received: by 2002:a05:6602:3a13:b0:876:9870:92e8 with SMTP id ca18e2360f4ac-876987093aemr4618139f.1.1751060462175;
        Fri, 27 Jun 2025 14:41:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87687a18c14sm67333139f.15.2025.06.27.14.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 14:41:01 -0700 (PDT)
Date: Fri, 27 Jun 2025 15:40:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: jgg@ziepe.ca, david@redhat.com, peterx@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function
 vfio_unpin_pages_remote()
Message-ID: <20250627154059.0e134073.alex.williamson@redhat.com>
In-Reply-To: <20250620032344.13382-2-lizhe.67@bytedance.com>
References: <20250620032344.13382-1-lizhe.67@bytedance.com>
	<20250620032344.13382-2-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Jun 2025 11:23:42 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patch is based on patch 'vfio/type1: optimize
> vfio_pin_pages_remote() for large folios'[1].

The above and the below link are only necessary in the cover letter, or
below the --- marker below, they don't really make sense in the
committed log.

Anyway, aside from that and one nit on 2/ (sent separately), the series
looks ok to me and I hope David and Jason will chime in with A-b/R-b
give the previous discussions.

Given the build bot error[1] I'd suggest resending all your work in a
single series, the previous map optimization and the unmap optimization
here.  That way the dependency is already included, and it's a good
nudge for acks.  Thanks,

Alex


[1]https://lore.kernel.org/all/202506250037.VfdBAPP3-lkp@intel.com/

> 
> The function vpfn_pages() can help us determine the number of vpfn
> nodes on the vpfn rb tree within a specified range. This allows us
> to avoid searching for each vpfn individually in the function
> vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
> calls in function vfio_unpin_pages_remote().
> 
> [1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 28ee4b8d39ae..e952bf8bdfab 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    unsigned long pfn, unsigned long npage,
>  				    bool do_accounting)
>  {
> -	long unlocked = 0, locked = 0;
> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>  	long i;
>  
> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> -		if (put_pfn(pfn++, dma->prot)) {
> +	for (i = 0; i < npage; i++)
> +		if (put_pfn(pfn++, dma->prot))
>  			unlocked++;
> -			if (vfio_find_vpfn(dma, iova))
> -				locked++;
> -		}
> -	}
>  
>  	if (do_accounting)
>  		vfio_lock_acct(dma, locked - unlocked, true);


