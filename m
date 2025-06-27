Return-Path: <kvm+bounces-51033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3632AAEC228
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 23:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 938FC6E0691
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 21:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EFE28A1E3;
	Fri, 27 Jun 2025 21:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvxktNPJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE3128A1CE
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751060414; cv=none; b=f/Hv2JgbkqXkRQKY/gcmZsgtMv8UYi6HXswQ/VT+YSmt34L/WZOmuMkGuaIQHoinMiLbI4ZazoNPQF5fHjBmQxMWZ+ig3nOCG8uHAwU6XdhD10n9VfvEGzU11bvo3Bd7M9UOfOn35wE3ho1czqhNxHFbNFyoQ/3j0X+1lgQQOFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751060414; c=relaxed/simple;
	bh=PSw7YUvWQ511vtCso1nhryBLXwAKE0/7I3Ocjek5sbg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhYXppPUm5izYmeGzR2kY1hAR00lUKNXxcuaRBHYoh4FXzqvm0yfCCHK3Dv01mKQqnaRF03iLB17KRnLR2my48Li70tVKHUWpyil/ShiH9cFJ0oqKdaJP2b082ShBi1s+Haa5b1xxiaNqXuzt/egYDFUHJDsCBFPuenTmmhxzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvxktNPJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751060411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDjE0Jm2Bp/JA1Dp+nDAFKb5/t9DkPnadkmyEIXEj6A=;
	b=CvxktNPJuCvDqWOeJd70Ol6VBcInBXnnMlO/WGe9JTFuaHI/sMz2bppu9mDa31tYNFlb0h
	ATWdFID7lj+mPIoWdP272NNVGSNzZA+RWQYrLiABj44s30gYAGlMkpuSSmOrO7uW1ri8zW
	xswC4qgKlaJjU0AApj6pek4SEpIY+7I=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-Q-X-XS-VOa6m7tgUWysA8A-1; Fri, 27 Jun 2025 17:40:09 -0400
X-MC-Unique: Q-X-XS-VOa6m7tgUWysA8A-1
X-Mimecast-MFC-AGG-ID: Q-X-XS-VOa6m7tgUWysA8A_1751060409
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-875fff4d6afso57256039f.1
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 14:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751060409; x=1751665209;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDjE0Jm2Bp/JA1Dp+nDAFKb5/t9DkPnadkmyEIXEj6A=;
        b=q1n/m0SKvMgkh/YtzCtZZenvcJRAa+L1hrU5qcC+HWbvvp091N2oM+yV9j91lWjGj+
         Phu+iqCKQg3v438OUOchZ3Frzix9wyKessQ4Y053e90FOz1ikiiAJGl+6Fd8zEddoaRQ
         iWGH54gh+dhIyk3ohQpMX8fZy5vc/flVr79DrTYkJHrj8oBKGiD8ShhFNJZksvmBGuNZ
         mlg8LLV0UgIealpfqoOVU2OXmCw2b1UuoNPxZcupszLftsPha6cEi/MWrXrNovdLghi/
         /c9I7f+A5H0WGZcyH5Wz8cTYXlE4Ns3kMRpTflnnzDmFr6UTut8dpZ2+nbvrHNZXePjs
         EKMA==
X-Forwarded-Encrypted: i=1; AJvYcCVZXfU/YXOqQN0hEPoJ0cuTaRFRUTmMKb0D97Wfa3vWVl79MlKeNZBcs8KKSUIcm2v/Wkw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnprtX4dAPYrmWccAOXTtA34TCjxNkGH5qEVT7pkKKNpowdTem
	pMda5DpUNlgjlllNUxJfm9zrPLpeoWzoYzA4nFr+d6yOKupSPkJgaeULvFUAW+SzBU9k/edk2n+
	uiIzQgZZ3JubEGhFUtkOZnPaTpvaM80B780H+zJO5+oE2vj9LbgN7Vg==
X-Gm-Gg: ASbGncsC94miex2pkan9rjolWnkf+4wgsE2iyYhWTmfAZH5Of9PBTozKoCN52/1FoXz
	bwYXq5Ny7+jwBmxNgm1k/fRJyfYYxkRkGyk9LkJjxvTEdA7WX/Bm5021424k01yQHmqjxhfMP88
	VxfbyFwIZgdei6riTgOASb/ZUFpe5+gZg4AneJTFe88BWoMrSuiqBaKRxjKR5nFEWsIWA8EwKzv
	oPmTe/ZJ16moyHinh3jetTZflkPJgyqNf5OGhB+SkLmyTyQpreLSn8cp3kfVGGiyys7RJRDUr16
	Hj5jlRI1D9ev+kMQVkysbviFQw==
X-Received: by 2002:a05:6602:6b06:b0:86c:f806:37a3 with SMTP id ca18e2360f4ac-8769653c05cmr27735339f.3.1751060408656;
        Fri, 27 Jun 2025 14:40:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGc5oHxFgpr5XzaS4ACG0vI5/HTTlrKCZnLrhk6AbDfKukH/RckMxcnZs/SWEE2JDvGko58GA==
X-Received: by 2002:a05:6602:6b06:b0:86c:f806:37a3 with SMTP id ca18e2360f4ac-8769653c05cmr27734539f.3.1751060408141;
        Fri, 27 Jun 2025 14:40:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5020489907esm716965173.37.2025.06.27.14.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 14:40:06 -0700 (PDT)
Date: Fri, 27 Jun 2025 15:40:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: jgg@ziepe.ca, david@redhat.com, peterx@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] vfio/type1: introduce a new member has_rsvd for
 struct vfio_dma
Message-ID: <20250627154003.6cbd5e53.alex.williamson@redhat.com>
In-Reply-To: <20250620032344.13382-3-lizhe.67@bytedance.com>
References: <20250620032344.13382-1-lizhe.67@bytedance.com>
	<20250620032344.13382-3-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Jun 2025 11:23:43 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Introduce a new member has_rsvd for struct vfio_dma. This member is
> used to indicate whether there are any reserved or invalid pfns in
> the region represented by this vfio_dma. If it is true, it indicates
> that there is at least one pfn in this region that is either reserved
> or invalid.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e952bf8bdfab..8827e315e3d8 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -93,6 +93,10 @@ struct vfio_dma {
>  	bool			iommu_mapped;
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>  	bool			vaddr_invalid;
> +	/*
> +	 * Any reserved or invalid pfns within this range?
> +	 */
> +	bool			has_rsvd;

Nit, the topic isn't so complex to make a brief comment:

	bool			has_rsvd;	/* has 1 or more rsvd pfns */

Thanks,
Alex

>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> @@ -785,6 +789,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  	}
>  
>  out:
> +	dma->has_rsvd |= rsvd;
>  	ret = vfio_lock_acct(dma, lock_acct, false);
>  
>  unpin_out:


