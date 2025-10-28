Return-Path: <kvm+bounces-61322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A26AEC16867
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 19:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 343981C2207F
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 18:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6692C34F256;
	Tue, 28 Oct 2025 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="IBcgLS0V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89B17A2E0
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761676952; cv=none; b=dNhvpQ/PHZuUf7hgVJ5FgRYRoUb0qwmk+WlXK7AOE05h6DK1IMdi4jffvvKBDYpcPSV5pTTouhP/ZDkS83pWFG4lR2wk0NqcDS8YARp+LwC67091Ov8y3Stv26/8nDAVS0FChtmsQFf5X8d5YjWfW8szGYiI2jXzQQLjbQoKmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761676952; c=relaxed/simple;
	bh=HL4Jsmiqq3qZinNDgEWhWXSE9m4WVT1UgDC8ewCAwvI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTsuqbR7Bjve+EU6unEcsfZRoUKSjrBn+EVtfpfTJw+NLgUEij8cjJOPzHk2IRKauI7K+cxC8UbCGCTfpkCsY6xjS0A/ki7eKLvUKFVWfstHlp72be6Z4pljyjSsyeQYQqjboKQZkpVIfpFmojM/HY21gQWZj5cdO1v4bP7uhe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=IBcgLS0V; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59SFfShj4115517
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 11:42:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=O0D22jbflGl1QZqxbJJ1
	lyaMPVaagUGQk+kZCnolltM=; b=IBcgLS0VKenZW7H8cSVqNHwonnmiclflTEMv
	3jaM+H3bmXl1sO+txvPwPozjFnVhcUWTOYV0x1/5g+ACVy82IsFrqtvoFBthK3sg
	ZnbU+oclh08BbfGRbnvIGKON3SfKUL7IdTiYKiuHN6AHF11KXe43zc3dFW0l4Zo6
	8maptMbFtInJ1ODUHuk+mm9qfuPKf0tlPkPgczFWgXFzxxkfYb6r+KMCCjGPLP/s
	yLuTkIvyhw/cvNI9yM2ERWT6r07OmHDBss+nkvdhzI+6B0zJdcNYwguEVg9yprkv
	3GnAZgKYv3sHHMY/L/vrI4pL0yqTGDQY6ygmzdEBBpVITTaQeQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a30pj213s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 11:42:29 -0700 (PDT)
Received: from twshared82436.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 28 Oct 2025 18:42:28 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 77C8E53948D; Tue, 28 Oct 2025 11:42:15 -0700 (PDT)
Date: Tue, 28 Oct 2025 11:42:15 -0700
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        David Matlack <dmatlack@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aQEOhyYQKW4unEfZ@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com>
 <20251027133904.GE760669@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251027133904.GE760669@ziepe.ca>
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE1OCBTYWx0ZWRfX56jEPFo8dutF
 j/TTSDFidtszFCRAdv7z4keuOc81VAQjjCMc7RmvN17d/9dN6PTIRB8un5KAzWW/LawQHOLoqQO
 pydACVudBO3V3HsdzuLICgF1rjqTFxJ3zA41yODPO9IvXFLF4URwixvZCV/CdZJP5YWxHIRjTCo
 Xt4c+woBJ95T3Vv2bx0kP0P6aioTohkGTumMkWKNARczf8S7YKpTG/nqTNMHq1aLaywZoUWNuIW
 1c+BYNPtocu6QmOuoFz9Tu81WSPm/wIcbKQSwgDSPE+WFThYz+VUG17mOFKC+Gg9DIA7LbWuOW5
 svFWDfRr5pZLUcj9uM/L+HK4QxA0gES/zKi1r7t/DYg/UD+6qlIYKmraxoJKbwLcrrlzd2GcNOe
 ttLAqDlFI32rgIpiek7NQP0m/A9Pzw==
X-Authority-Analysis: v=2.4 cv=T86BjvKQ c=1 sm=1 tr=0 ts=69010e95 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yJsSUgGDADgjvR2qnwgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: GnObRpS7g3_1xVqzntqdH5p-GynVtOXj
X-Proofpoint-GUID: GnObRpS7g3_1xVqzntqdH5p-GynVtOXj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_07,2025-10-22_01,2025-03-28_01

On Mon, Oct 27, 2025 at 10:39:04AM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 25, 2025 at 11:11:49AM -0700, Alex Mastro wrote:
> > Alex and Jason, during my testing, I found that the behavior of range-based
> > (!VFIO_DMA_UNMAP_FLAG_ALL) VFIO_IOMMU_UNMAP_DMA differs slightly when using
> > /dev/iommu as the container.
> > 
> > iommufd treats range-based unmap where there are no hits in the range as an
> > error, and the ioctl fails with ENOENT.
> 
> > vfio_iommu_type1.c treats this as a success and reports zero bytes unmapped in
> > vfio_iommu_type1_dma_unmap.size.
> 
> Oh, weird...
> 
> What do you think about this:
> 
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> index c0360c450880b8..1124f68ec9020d 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -707,7 +707,8 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
>  	struct iopt_area *area;
>  	unsigned long unmapped_bytes = 0;
>  	unsigned int tries = 0;
> -	int rc = -ENOENT;
> +	/* If there are no mapped entries then success */
> +	int rc = 0;
>  
>  	/*
>  	 * The domains_rwsem must be held in read mode any time any area->pages
> diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
> index 1542c5fd10a85c..ef5e56672dea56 100644
> --- a/drivers/iommu/iommufd/ioas.c
> +++ b/drivers/iommu/iommufd/ioas.c
> @@ -367,6 +367,8 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
>  				     &unmapped);
>  		if (rc)
>  			goto out_put;
> +		if (!unmapped)
> +			rc = -ENOENT;
>  	}
>  
>  	cmd->length = unmapped;

Seems reasonable to me. The only affected callers are 

drivers/iommu/iommufd/ioas.c
366:            rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length,

drivers/iommu/iommufd/vfio_compat.c
244:            rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size,

So your proposal should get vfio_compat.c into good shape.

I think these locations need more scrutiny after your change

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index c0360c450880..e271696f726f 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -777,6 +777,7 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 
 		down_write(&iopt->iova_rwsem);
 	}
+	// redundant?
 	if (unmapped_bytes)
 		rc = 0;
 
@@ -818,6 +819,7 @@ int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped)
 	int rc;
 
 	rc = iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
+	// intent still holds?
 	/* If the IOVAs are empty then unmap all succeeds */
 	if (rc == -ENOENT)
 		return 0;

