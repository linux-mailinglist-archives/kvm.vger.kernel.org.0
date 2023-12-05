Return-Path: <kvm+bounces-3423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7651D804304
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31E9A2813A2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53CF15C0;
	Tue,  5 Dec 2023 00:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijYd1VfJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAEB107
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 16:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701734486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlbvQ38xyZhR1pva7q+q80Q02GqbyPEePCP4ft47vxs=;
	b=ijYd1VfJdepXQSCAXdcFh/StrSEQYYetEu5np7LrI2Cz6QjNtIB2UqiBO359TOok+OUkZX
	k2LNHI9Kj6MXgFdHU96GcC151giJ3mDiEKENT92GKDAtBr8YR2hdJcBc9ugj2BThDo52xJ
	qZ1E2D17qPjtJ4Nb9cA63k2LE2OXZf8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-5VVtQgnzM-6tD5l80tGRew-1; Mon, 04 Dec 2023 19:01:20 -0500
X-MC-Unique: 5VVtQgnzM-6tD5l80tGRew-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7b37a634935so341372239f.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 16:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701734478; x=1702339278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OlbvQ38xyZhR1pva7q+q80Q02GqbyPEePCP4ft47vxs=;
        b=X5kfAsq9Gc9pMYlu+TgIZe9CT+Uj1fWXmsuQg0ndJIXdxOVsAkVhqtWwokoN4q72Gp
         8nF9stZhKHl1aPlrr9VXjW5/4tBNN8/azT8bRg1mqYbaT9n3FT6bblD09EOqAbi9YYAl
         TWkSTJFhn/oWSC85Bm03u37i9DKA+iihodbI5UxbH2/fgQqjkMSbO34+SjMoc5yT0oh9
         0M30xATQ0vNhWtmjOrMOdluE6APMVX3z81yM/gjrNmEbUeofYuS9/xCPNTnv4Udin/WJ
         H/9nqN7JbjkR1Ai9zkbCQQ7kdfsptRiZ03kSLlYzogGATfbC3zEBlO2vXNvmp3Z3bb3M
         229Q==
X-Gm-Message-State: AOJu0Yx018cHcedmYaTbxEBjFL6TF/VJ3nlJEE+04FGizH2xCvrmv2Z/
	6Qv1CBt6L6NmjJQuosbrRnXL821OGXT/F3toao/DmL8NfztsDnuPRmX1xTda4ttF2ewv6q84w64
	OiCGD+wN4fh6tniQQUGXi
X-Received: by 2002:a6b:c541:0:b0:7b4:5ac5:9f15 with SMTP id v62-20020a6bc541000000b007b45ac59f15mr395517iof.11.1701734478703;
        Mon, 04 Dec 2023 16:01:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQnBPyeFdxlh2Qtw8/h7pN3+b1wM0h4O+feXPktnwOGXI46QpvUpfZTg/d5w35S03RXV2UDA==
X-Received: by 2002:a6b:c541:0:b0:7b4:5ac5:9f15 with SMTP id v62-20020a6bc541000000b007b45ac59f15mr395512iof.11.1701734478445;
        Mon, 04 Dec 2023 16:01:18 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id 22-20020a5d9c56000000b007b35043225fsm3092323iof.32.2023.12.04.16.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 16:01:16 -0800 (PST)
Date: Mon, 4 Dec 2023 17:00:52 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: account iommu allocations
Message-ID: <20231204170052.5967e9cd.alex.williamson@redhat.com>
In-Reply-To: <20231130200900.2320829-1-pasha.tatashin@soleen.com>
References: <20231130200900.2320829-1-pasha.tatashin@soleen.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Nov 2023 20:09:00 +0000
Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> iommu allocations should be accounted in order to allow admins to
> monitor and limit the amount of iommu memory.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> This patch is spinned of from the series:
> https://lore.kernel.org/all/20231128204938.1453583-1-pasha.tatashin@soleen.com
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index eacd6ec04de5..b2854d7939ce 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1436,7 +1436,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
>  	list_for_each_entry(d, &iommu->domain_list, next) {
>  		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
>  				npage << PAGE_SHIFT, prot | IOMMU_CACHE,
> -				GFP_KERNEL);
> +				GFP_KERNEL_ACCOUNT);
>  		if (ret)
>  			goto unwind;
>  
> @@ -1750,7 +1750,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  			}
>  
>  			ret = iommu_map(domain->domain, iova, phys, size,
> -					dma->prot | IOMMU_CACHE, GFP_KERNEL);
> +					dma->prot | IOMMU_CACHE,
> +					GFP_KERNEL_ACCOUNT);
>  			if (ret) {
>  				if (!dma->iommu_mapped) {
>  					vfio_unpin_pages_remote(dma, iova,
> @@ -1845,7 +1846,8 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
>  			continue;
>  
>  		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
> -				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE, GFP_KERNEL);
> +				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE,
> +				GFP_KERNEL_ACCOUNT);
>  		if (!ret) {
>  			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
>  

Applied to vfio next branch for v6.8.  Thanks,

Alex


