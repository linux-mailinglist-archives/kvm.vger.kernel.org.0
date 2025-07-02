Return-Path: <kvm+bounces-51322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E550AF614B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABEC7173B2B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862AA2E49AB;
	Wed,  2 Jul 2025 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Pwkh4neE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B382E4990
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751480884; cv=none; b=iZN5DD37SFpfejXE2zUOcMJc0g7Tph+EKtwrTXpJRDdOHtc82fNqce3lX5HtQ5OU6nJcWNEm/bAaosmbAxdEehS4ZEp3g3OqwOHDcSjVZ4AOPMTcOsVQ5zFTXtO0dGblz3/UW7FaKqMcoHYeBAxPbi1Cx26We+ZHLtz+cL7NYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751480884; c=relaxed/simple;
	bh=iP5w1PMpBk76Rr3cMYHswVuigC9uaxVExDoGsxa+F3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTQuYsTB9stEV+/K194iMahDvSrZKoXDH0jNs3k6aJuD55vRYCdrfYW6uUOmPFpaLV8jRxbCUqd7mtyshYPwa9NyjjGgWm7g+OqBTMBdKPJR1TymGuR3pqxXB76B9+YbrXdSrnkrU57qkzOqy9r774Ww2/oBmwWYhW4k1RX4AAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Pwkh4neE; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23694cec0feso71611425ad.2
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1751480881; x=1752085681; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rmBw0FwZ2YTZy+oq5MGfO9a+hy7B74rrrKnCKDkET7g=;
        b=Pwkh4neEuoQFSlBmcYtgh/rmjMsTFJNz+tAvQfgLYDCsdXFAzfbuz61FrK2nOnuTC0
         66T9UC8ha1zUMuR4H9rOY/5UXJQTRcDsqYmW4W4E3ppIpHGyxtA/CCTYRfYlJ43WYQ3l
         E4j4cNKBJy8y+0JXy5yYbOWaeBeFb2kJ6udaRvKbaFFKeCt/waEcJC5/mjvhQ9TBiUVQ
         +F6WBGIfU0sitJ1OoXuvKRj4yOxE/HLThNbfncgspS37ifu733CdIW091WvdUb0TYBuZ
         QCdVAfub/WLV5XPOldxGY1ZImOJBLpeZ5cRpcCU/6DDg7japlo4texHpk+818U9R7NZZ
         r4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751480881; x=1752085681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmBw0FwZ2YTZy+oq5MGfO9a+hy7B74rrrKnCKDkET7g=;
        b=ldDQPGKfEIj6utUHmwMGrieNcKOriOroRMGA3L+R8LQkKVN3IDnrZmqPN6QVJbsDVN
         l9DRH01v8onzUSVgdHy4taltvInTHv7qy7dv/fA+0wbX/XNbhDrhHcuXirS3AzVs52SA
         M/MpeKurxwhNr5bmBcmeeJLdhTdVGiL3Lkl0QwaKcbH1XKMRQw/zoIt7wMxXfw1sP6ev
         BC+GkPENqrtDsowJEdYPOB9RV94yBj6sBJ7VQ99cEgV09DbcANdK/YWZZoutZR8bma8R
         HxjKXg6k+Jw18yvD4av+lmucggB8qJ3B/zMlE8HkQhUWTBmLkcjxL+3/7k+FO2UnHtgW
         5lPA==
X-Forwarded-Encrypted: i=1; AJvYcCXi/gJ7V4oxmLTqb//iEeG0O9OQ9QY59cSWK2aLksvRF6ucodSRDb5rgjt6fumslH+4bLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8xmE6Rpn0P61gHVy1QZnQY8eUw6yAIcC/kq4s8IS3GWADRUkr
	kkivVc0HpAzsx5Ym2F+kDERSF8ax35CKjK+3Q6qfXoguK9oT22d43cRX9rTLsmwDB6Y=
X-Gm-Gg: ASbGncuTKUNpQ87+/d7ZbtxKa/VtrOR3lnR43KAPsJrHv6KJnBBWb2E1yY9Za3GgLTp
	tReSr2KEYAP5HnXWZcRFiy8xQrcolx3rCIgo+cbw6JEe3JbD2yqYWQC49LRwZrEnR2mQAWY2hiX
	fEXli4TB5PqdLheBIhRGiDpIkqyZ8fOW26KNpxUyabcqS/JiJATKqFgNvIu42rcayJ2+WKoFKJm
	Uym0g11DxHrNBcKuSQWF95CpLQD8jAKI/QprV0cRKDVVETuK2//4nEEJfX3lUrRrYGrHtlooaTE
	24L/QtDLydEXRHMeYHMAjOOQzM4bxyfWwD2M7/+cEy08WZE=
X-Google-Smtp-Source: AGHT+IHRud1650CV6t7XmPGb5CJK0erzfO/DvwwwzByFP8LtNAphgKfboGyxgWUiZX6QKOCKR6whKQ==
X-Received: by 2002:a17:902:e884:b0:236:93cb:48b with SMTP id d9443c01a7336-23c6e5c5a1amr65584895ad.44.1751480881046;
        Wed, 02 Jul 2025 11:28:01 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3b7986sm142781775ad.164.2025.07.02.11.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:28:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uX2Bb-000000051lx-10Sm;
	Wed, 02 Jul 2025 15:27:59 -0300
Date: Wed, 2 Jul 2025 15:27:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, david@redhat.com, peterx@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio/type1: batch vfio_find_vpfn() in function
 vfio_unpin_pages_remote()
Message-ID: <20250702182759.GD904431@ziepe.ca>
References: <20250630072518.31846-1-lizhe.67@bytedance.com>
 <20250630072518.31846-3-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630072518.31846-3-lizhe.67@bytedance.com>

On Mon, Jun 30, 2025 at 03:25:16PM +0800, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> The function vpfn_pages() can help us determine the number of vpfn
> nodes on the vpfn rb tree within a specified range. This allows us
> to avoid searching for each vpfn individually in the function
> vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
> calls in function vfio_unpin_pages_remote().
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a2d7abd4f2c2..330fff4fe96d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -804,16 +804,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    unsigned long pfn, unsigned long npage,
>  				    bool do_accounting)
>  {
> -	long unlocked = 0, locked = 0;
> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>  	long i;

The logic in vpfn_pages?() doesn't seem quite right? Don't we want  to
count the number of pages within the range that fall within the rb
tree?

vpfn_pages() looks like it is only counting the number of RB tree
nodes within the range?

Jason

