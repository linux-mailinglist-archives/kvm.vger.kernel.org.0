Return-Path: <kvm+bounces-61244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14282C121E8
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1EDD1A25894
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7C0330B1C;
	Mon, 27 Oct 2025 23:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="ypygDytn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF25930AAA9
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761609512; cv=none; b=QjWEBZW0I7QnciODJ42Wbss+2GOyBbPAwmTWqsWBN4SsRrViZdwyDFNERddEtcLLbWXu4iVbahGQDfK6FeOP02fp43g1Sa3PkGS2kn8KXy9JniijJpN0sNwbBfXGTELArfkEIKK07v6EJcY6ZytLfYD84nNl97QrmY0jH7ghp5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761609512; c=relaxed/simple;
	bh=NkRPhIpUL0KWyN8WDV3xMQy976SyIF1Lzif54tBlA3c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urfjtP4GAcTIpRrscF52j4Gig8nXwPvO9EAcbwCqfYx0fUVLtkNIYKqlY52+qFU/r5Q68dnlnZDM5FraUbFWbORo3c80vsjsVjWPMQFd5K0AEcEFh480p1vHVj3UWsDa8O8NJEoYJRbJyprsG1OAxEa7mfuuqAd2AEBM2DNcigk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=ypygDytn; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RNCb9A638686
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:58:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=K64EqhXoumfbF6yiKLa3
	ujcAskeWcVn5aoQ4CYMOTJE=; b=ypygDytnJdRpsdaNmXklVNoq9zmgG+7h9Lwd
	s30WiwTI5bo+5Lk0wJQUnslvCLD/7z7dv9apxwbw0m1w4B0A+CZEBlS5bxBEKx6v
	2xkhRoF7EaPI+rDiJhG9bScanI620U0VQkSNL9mDAyKxqJzWPPYS53XNrYJPlIZY
	aQyHT4cSkWgmCJzh8U4LQXGQ2qoQGdZ32tP5FjblO6GEQpupt4dmBb71se3/KBPC
	WNFZK/ePOrAmUKizqLplb4l2gfFGflAVDLo5zrZpo0kaLQwvPnWwNgimFBVkqSyM
	15lM0U8iFSjBVOaAdke56kBpq5a744ibHF2/qk2IheVU244FTA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2j788870-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:58:29 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 27 Oct 2025 23:58:27 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 3B4A147C147; Mon, 27 Oct 2025 16:58:16 -0700 (PDT)
Date: Mon, 27 Oct 2025 16:58:16 -0700
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] vfio: selftests: update DMA map/unmap helpers to
 support more test kinds
Message-ID: <aQAHGCAF9Wj5oGUY@devgpu012.nha5.facebook.com>
References: <20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com>
 <20251027-fix-unmap-v5-4-4f0fcf8ffb7d@fb.com>
 <aQACJucKne4DRv06@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQACJucKne4DRv06@google.com>
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDIxOSBTYWx0ZWRfX3krWmBC+xt2Y
 r5XYm1WgN+JH+jFUjYZdVJalOTyQyQ2JmpMEnpYFBA5ioMFdntjaI1hJ9uQuSZLzArYB4xv1w2W
 Kap2MrvHhVx5Gd3ZwPWKg1+hHBjp4gRBy8zFIwPn/fUJrbT/cd3G6X60BOSWI1vGoeLL+TSywIW
 7beeT9YlT1NtD/j+5uWFuQn+XrqxpgHMMcrALclxGXEMC9uDjUFTBm5xNgIuzlpFjRIdBVAWWKk
 /XyIMIyDPAzNMOxEJ9RMcPnXraNq+TTheA8JcUqrjNQeCeEDQL7edLAwM+xx2g2QzK04cSiQGhV
 z1KoMbk/ecN/hN30vLb7+m8Z77j/2v7UAu7SkJIyptNiuwDrFQKB3n9qRgwEfj72NlGdXz+Q9ED
 tKaIBcu64MY+S5Kp8w7D0i9PIR72xQ==
X-Authority-Analysis: v=2.4 cv=S9HUAYsP c=1 sm=1 tr=0 ts=69000725 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=1XWaLZrsAAAA:8 a=qtSfAhGtrGOdXbEVq08A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: L2FM9bDkau7CNQjwMR2KiwRHaJyV6E-h
X-Proofpoint-GUID: L2FM9bDkau7CNQjwMR2KiwRHaJyV6E-h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_09,2025-10-22_01,2025-03-28_01

On Mon, Oct 27, 2025 at 11:37:10PM +0000, David Matlack wrote:
> On 2025-10-27 10:33 AM, Alex Mastro wrote:
> > Add __vfio_pci_dma_* helpers which return -errno from the underlying
> > ioctls.
> > 
> > Add __vfio_pci_dma_unmap_all to test more unmapping code paths. Add an
> > out unmapped arg to report the unmapped byte size.
> 
> nit: Please append () to function names in commit messages and comments
> (e.g. "Add __vfio_pci_dma_unmap_all() to test ..."). It helps make it
> obvious you are referring to a function.

Ack

> > The existing vfio_pci_dma_* functions, which are intended for happy-path
> > usage (assert on failure) are now thin wrappers on top of the
> > double-underscore helpers.
> > 
> > Signed-off-by: Alex Mastro <amastro@fb.com>
> 
> Aside from the commit message and the braces nits,

Thanks David. The nits are easy enough to fix.

>   Reviewed-by: David Matlack <dmatlack@google.com>
> 
> > @@ -152,10 +153,13 @@ static void vfio_iommu_dma_map(struct vfio_pci_device *device,
> >  		.size = region->size,
> >  	};
> >  
> > -	ioctl_assert(device->container_fd, VFIO_IOMMU_MAP_DMA, &args);
> > +	if (ioctl(device->container_fd, VFIO_IOMMU_MAP_DMA, &args))
> > +		return -errno;
> 
> Interesting. I was imagining this would would return whatever ioctl()
> returned and then the caller could check errno if it wanted to. But I
> actually like this better, since it simplifies the assertions at the
> caller (like in your next patch).

Yea, I was also worried about errno clobbering up the stack from the ioctl.
The reason for -errno was to keep error values out of band of >= 0 ioctl return
values (e.g. if we ever need to do similar for ioctls which return fds)

> > +int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)
> > +{
> > +	int ret;
> > +	struct vfio_dma_region *curr, *next;
> > +
> > +	if (device->iommufd)
> > +		ret = iommufd_dma_unmap(device->iommufd, 0, UINT64_MAX,
> > +					device->ioas_id, unmapped);
> 
> This reminds me, I need to get rid of INVALID_IOVA in vfio_util.h.
> 
> __to_iova() can just return int for success/error and pass the iova up
> to the caller via parameter.
> 
> > +	else
> > +		ret = vfio_iommu_dma_unmap(device->container_fd, 0, 0,
> > +					   VFIO_DMA_UNMAP_FLAG_ALL, unmapped);
> > +
> > +	if (ret)
> > +		return ret;
> > +
> > +	list_for_each_entry_safe(curr, next, &device->dma_regions, link) {
> > +		list_del_init(&curr->link);
> > +	}
> 
> nit: No need for {} for single-line loop.

Ack

