Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0942931A511
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhBLTJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:09:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9944 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhBLTJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 14:09:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026d24b0000>; Fri, 12 Feb 2021 11:08:59 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 19:08:55 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 19:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpJYHJezCNwG5EKuGKh17MO5ALV+Ga79GnLs1fkmARiGKZP1f6TN8V5icYfZ+v0pO72uy4ykxpEwdsfwQkp0RgvhYGIVpql1NwLUvzg4TmeoJD7byU8vKt9wgkLlWi9zTYh6VRFnF9USekVAd+VxFF4z75dmTSom8yda/jqHZBntB1GhRG1eOY3iRaw2ZL812F8JiJqHjT1F7KTpk5Q8U2LmiX73x5TuESIbfcLE2XqdXeUCUQLBSffWfEKUpOxIkcJ0ZOg75ShGujagY1F8agorbZFhMWMvuJmA2eVj/0CANfNPtPugEhyhG9HBn/nYkQa/UNtpBtQZRQyo/cSpgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXWVZMJ2ML1FpMAfUgjvBax3HnVKJanK1iPNIvf5ZJc=;
 b=kcged9XzneGWDFbPZreTKNHbKATpNRoVzWi1xwX6jnbdbpHJC1l1veHTcA4/prT3GVJF4deu7eXAjmRnS8sDDsYvvQp69PaINar0C0wly/yDwlZyhgio98GzWdRF0smqQQx65UNxY2THhXUODom0CUvWPZiCahTY6p72S7SYBSl/fuPR6THgm+d/fmEaY27qg+1XAP0UszRdLFzEodwb6fz6P0OLZRTNbIsQ6MD9ms5QSHA2sxgGAa5xJYvnw4SwA1BZ19rjjqCYwHsFPctxUBySeCmj4CqNXMg+ypg0JLts/Ib5ngTQB1ThemvZtltaHRKivDX9vFMNF4Oh3OBSjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 19:08:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 19:08:54 +0000
Date:   Fri, 12 Feb 2021 15:08:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <peterx@redhat.com>
Subject: Re: [PATCH] vfio/type1: Use follow_pte()
Message-ID: <20210212190851.GT4247@nvidia.com>
References: <161315649533.7249.11715726297751446001.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161315649533.7249.11715726297751446001.stgit@gimli.home>
X-ClientProxiedBy: MN2PR01CA0035.prod.exchangelabs.com (2603:10b6:208:10c::48)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0035.prod.exchangelabs.com (2603:10b6:208:10c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:08:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAdoB-007WEG-V6; Fri, 12 Feb 2021 15:08:51 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613156939; bh=MXWVZMJ2ML1FpMAfUgjvBax3HnVKJanK1iPNIvf5ZJc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=CXavsW0PjnQNeADlGVdeUoj8/Uto+drj/IUzRGMKLfW+D8MsDDE3S8Hl5SCkCnhs8
         2gx9C9KmPuayyQckuk6piGc8jWARvOAvvuF43u5oqXm8YtgpYTmyOPwGSNsj8naaFF
         nqyAPUSkPQ3QAgCqOS66XXG19QaTrykvGsbhyMRYXoUlOaSx/zKJZN1Zj7ZsaenfHB
         dCXG60Bsur1VrPlN07ccOrZaII2GmQfAIQroUyx9Yvk5/QkDcVCLl0HLw/mvqxXf6l
         oPsBB9XX+NiskSzHHFSnJIHXZbrLyaUz85ap6LccyBYwzT0xwl7Nug0LJk3g2Z3gMo
         BZDOeuMt4KOdw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 12:01:50PM -0700, Alex Williamson wrote:
> follow_pfn() doesn't make sure that we're using the correct page
> protections, get the pte with follow_pte() so that we can test
> protections and get the pfn from the pte.
> 
> Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ec9fd95a138b..90715413c3d9 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -463,9 +463,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			    unsigned long vaddr, unsigned long *pfn,
>  			    bool write_fault)
>  {
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>  	int ret;
>  
> -	ret = follow_pfn(vma, vaddr, pfn);
> +	ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);
>  	if (ret) {
>  		bool unlocked = false;
>  
> @@ -479,9 +481,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  		if (ret)
>  			return ret;
>  
> -		ret = follow_pfn(vma, vaddr, pfn);
> +		ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);

commit 9fd6dad1261a541b3f5fa7dc5b152222306e6702 in linux-next is what
export's follow_pte and it uses a different signature:

+int follow_pte(struct mm_struct *mm, unsigned long address,
+              pte_t **ptepp, spinlock_t **ptlp)

Recommend you send this patch for rc1 once the right stuff lands in
Linus's tree

Otherwise it looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
