Return-Path: <kvm+bounces-61092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6426BC09E31
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 20:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ABB83ADF99
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0602FF664;
	Sat, 25 Oct 2025 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="l85FGJiq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F12C11FB
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761415925; cv=none; b=sfy9khtycJErrcM2jEwes56TvZJ9/EBF5vr2jwRaXak4FMw8nvlR654MQ2BSlGn5H7jXWXbS1XZxLuhq20lw5O6DUgXW0CnMsikYvM/1iFLMVO/i6TOOX4LDVsfAo/OitrsN57F2kIkB7ftZljjxGCVaDYkuNyVCzonvgBcZoxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761415925; c=relaxed/simple;
	bh=/IKhcuNSgMpOamjayHWURydjiZtD6SnaLDkZZFe/CQc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSoyv3JHsy3vMeqRc50WEsuvxzj7oJjqFTG4KTJM85VNjE71kXHs6VVDXpWX5QnCHj3gXFCaS5b0WWLOrmkjvPQwxOwd4gTp3TsJLKR3I9+0CBMVNRaq1ZKJ0/4wZHsgR4TWRPIhtIxQ60LVsahFkExaznnymtvgJuPi03fveh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=l85FGJiq; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59PBcnxS3544507
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 11:12:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=/IKhcuNSgMpOamjayHWU
	RydjiZtD6SnaLDkZZFe/CQc=; b=l85FGJiqEcritGHcf9G+yxkzcFt4CeUBBQ67
	s99qh3h81IVudvTTM2oeiI2ymRAt0ye1gk56yX1iHO0KtwdM1FLjxSjRwgc/m34o
	38t26I4CMiXbvuyzDnjytG5bQnxubaiV5pAbJ6hQntctt6SWqdZhQogrp0iTwiE9
	XqpBTrZad0fxhCKLqcMggO8qj/8h8vIZxLyN7JwWtJlvrVAwUf7JCrX7Aa5A57f7
	1u0jEwcsqlh5XC5vB5cfyXRdUfTatUlADmv0eHE+tTgzJzlddSrWqJrV7tUMtEgR
	EW2ViE+NA3mBHhcydsLq2LRqL+idxRX9Jht3nxP5260wsuSpaw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a0wuhh46f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 11:12:02 -0700 (PDT)
Received: from twshared10560.01.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Sat, 25 Oct 2025 18:11:59 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 399052AE426; Sat, 25 Oct 2025 11:11:49 -0700 (PDT)
Date: Sat, 25 Oct 2025 11:11:49 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        David Matlack <dmatlack@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: xWl3vAX8T00zP_XVvQCAKQcnEQ08MME4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDE2NiBTYWx0ZWRfX77NkQfNBDjW6
 5EUGAw6BeZlVssg9lAKuJELZ1FwnDQ/+LzZoWOl/VQlMtCLVXsH1Yuag4Pe3Y8cybHJVCza4kC8
 +wBCgdMwnmdZvhhSIBF2Th/P4S3I1AJNEh0qsh3Jj4zPS5+xp0yk9Nsr7CY/E4ouZIx0RDwg4zp
 W5fmKqumk4OurPBvID8yuaLdfdDNofJBUWxhSEu4sGTdswzLFUGW3Scr47wymayBXXUkA+f/oG1
 18KsqS44gbE1AxeuwG2obZKcUMjx7fW5Q82wkPFud8Cyd/xZtbKHuqABTChq6W/7THNMU0FaN+3
 AIIGVm0FJs86+AC3z6rUG7Dc0ISgyx40axsOo383Qv8eOcsv8F5NeMJZ+E/F5U3fjyVUhHMUXgd
 /9GvvPcuXPL+wPzrq7q7LfNkTV9O0w==
X-Authority-Analysis: v=2.4 cv=dMqrWeZb c=1 sm=1 tr=0 ts=68fd12f2 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=dzLN2TX3shYeVDC5Iz4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: xWl3vAX8T00zP_XVvQCAKQcnEQ08MME4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-25_06,2025-10-22_01,2025-03-28_01

Alex and Jason, during my testing, I found that the behavior of range-based
(!VFIO_DMA_UNMAP_FLAG_ALL) VFIO_IOMMU_UNMAP_DMA differs slightly when using
/dev/iommu as the container.

iommufd treats range-based unmap where there are no hits in the range as an
error, and the ioctl fails with ENOENT.

vfio_iommu_type1.c treats this as a success and reports zero bytes unmapped in
vfio_iommu_type1_dma_unmap.size.

It implies to me that we may need some more shimming in
drivers/iommu/iommufd/vfio_compat.c to iron out observable differences in UAPI
usage.

Addressing it would be outside the scope of this patch series, so this mail is
just to make note of my findings.

