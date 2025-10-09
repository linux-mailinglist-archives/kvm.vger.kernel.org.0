Return-Path: <kvm+bounces-59673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B46BC7004
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 02:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC3D83E1041
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 00:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A3D189906;
	Thu,  9 Oct 2025 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="ymJEhBwg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AB31096F
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 00:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759969538; cv=none; b=EOJrQBu89Mf7LbqIzA5W+zTcnEkPgo9Ing1osthCPg6Amz3XiZjPalStjaYttJZeEtcjN6q6GtW4lktLn3UagQ1H+ZEVYqhUjfqcZVyKNaaA7QCsRKVW4sZfx+8EduwWQkeWSIpltpOMvaBKVN2bZcAP/ew5XaOiJLd4SFetV3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759969538; c=relaxed/simple;
	bh=PcaR3ijNAGMyV1U/9vsbgZvxsZcIAbjvyWUQoBaddVU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owH9sccsWHEUetcifC0StsP1lGTBEk4LHfuIXnDhbfQqrrdb8B+QaD2Qv1ws9tXbDfMQ1O7j73JlPyMIWROFoxxHlzrtXXTvDjs0y4tJEcNfkMjC88vsGSHkJiMaRCLz9x6jkmuoefoQvL4z2f4Zps0OtyyoFkJRORUAK7ug8AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=ymJEhBwg; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 598JMwJL1765614
	for <kvm@vger.kernel.org>; Wed, 8 Oct 2025 17:25:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=7qHq98nLKQJlzb7f7C1C
	JcnNw/asTQ5NX1VF4pE3/i4=; b=ymJEhBwg5sfAZzur7mQKTXVFpanSPm/yRvhp
	rQ5ieQOwuisp/uS+lExM6ZRdx/SbWPqzu3TzZedsIAJyBnymcfnAXuJBthOi0q4Z
	qz4r9jExkXowB2GIFxXqku2k1qlSioBW4lFfJM4yazHWafRKztEm76eLveGD/o6M
	6OjJy26eJodEHiveprwfIKIOhOyVcMoQScvaC9kHBzGuAZHPKrw9dCbQKLuYd+QC
	zJQOAv6/SE4L0uQ1145SwfLXssxIifG3yQnFWn+YZIz6k/PfBiRaHU6NkRh/DmcE
	0E+OYzHVdkdB3AplfEpMzeA6JSnRL1ddOxq+cVKJe7P9qEfy3g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49nx2kj7tu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 17:25:35 -0700 (PDT)
Received: from twshared18070.28.prn2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 9 Oct 2025 00:25:34 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 9DDD1DBEADF; Wed,  8 Oct 2025 17:25:20 -0700 (PDT)
Date: Wed, 8 Oct 2025 17:25:20 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Message-ID: <aOcA8LhIoWZPNOA5@devgpu015.cco6.facebook.com>
References: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
 <20251007-fix-unmap-v2-3-759bceb9792e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251007-fix-unmap-v2-3-759bceb9792e@fb.com>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: ukbZdyG2XsBQGE_NaeBdFoxRdkphAgoT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA5MDAwMSBTYWx0ZWRfXxt10GmNwKYox
 tvqUf+4BGhH6oyjgsIbR6brFMm5zbR53qI4MmHpP4HLgjPqqMiisKhIfCpTyVnujkLofVx4M2ds
 buIRRgWVO8t3G9byApbf3b9Pi9fZLfcoXlq21Erj/ehM23Z1pWztTtBKdNQsi/7O5tIjVu9ScB6
 ofAxghiaigfvnKA/dnBHbgZM4A2SzEVk7BdOxrpSqHp9NMfaggUn/LCL0AQEmJ84sxcqbIEDK/J
 C0RvneupJnp1P43NRmv+M5QND5hZpgkKrl5r8AUI+4FYX0oUSKr0pY+24AtlipHGfUPR4kcFWQ+
 FRhT3F6DpyE6al064OH7PO2Ix/5UuMisGhEHB6ZNuzKKaeriOmHUQ8eCuUUz4GQxhgWQLNV2sjZ
 ujM4K7j5Df38kO+QNABpp21Bb6GGAA==
X-Authority-Analysis: v=2.4 cv=H4LWAuYi c=1 sm=1 tr=0 ts=68e700ff cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=ofdlg-NLLL_6ULEM8BEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ukbZdyG2XsBQGE_NaeBdFoxRdkphAgoT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_08,2025-10-06_01,2025-03-28_01

On Tue, Oct 07, 2025 at 09:08:48PM -0700, Alex Mastro wrote:
> @@ -1401,17 +1409,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma && dma->iova != iova)
>  			goto unlock;
>  
> -		dma = vfio_find_dma(iommu, iova_end, 0);
> -		if (dma && dma->iova + dma->size != iova + size)
> +		dma = vfio_find_dma(iommu, iova_end, 1);
> +		if (dma && dma->iova + dma->size - 1 != iova_end)
>  			goto unlock;
>  	}
>  
>  	ret = 0;
> -	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
> +	n = first_n = vfio_find_dma_first_node(iommu, iova, iova_end);

I missed updating iova_end to be consistent in the unmap_all case, which is
broken with this change. Currently, iova_end is only assigned by the
check_add_overflow call in the !unmap_all path. Will address in v3.
 

