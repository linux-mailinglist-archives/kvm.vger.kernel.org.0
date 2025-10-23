Return-Path: <kvm+bounces-60923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36441C03746
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4BEF3B5E8C
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA529280A5C;
	Thu, 23 Oct 2025 20:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="6qO79VKQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355AA26F2BD
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 20:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761252740; cv=none; b=FVK+gzFsISu/NNs3almPd7THGIaHKP6XeRCLrwwpXuJhAe3yJUhmNUoMOEMuStFhdAqoQxc6aNnLdacb+uiM5exLAyIfkYdpJoTuaJWQcUUA1fTB8+MfuAfp+jugRMlM3q8sCAvKE1kM6wy370AuZLYeTgUYFvzKjG1e+7VCt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761252740; c=relaxed/simple;
	bh=Y0ghMmSRlBnRBNnP6sWrVTt2Vnuy3f0n2nTNALKNFX8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQOfrjsMAn9DDkyVkKT5zfNM9s8KqDOCYDDVtsdHj+bnSVwy5/ffnjt3Akp9u9Y9cx6Ngv5lJeMpizQngkfFBBbs0Efm+AvQle+rQXht0n4YbtS8lLUUhdQDgkV47m+n0VPxXWu8SM5vg9zJrnC7Vg0j+yZV5EEBT0LaKvjH7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=6qO79VKQ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59NJSPOL2199286
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 13:52:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=5BTw0dteahU9kWyz5zYz
	xzqs6ncqPTxI2RXvfgSYzz0=; b=6qO79VKQ9qGwCshB8X6vfPSWDZf3lHHEm56/
	/2nnul/jlhzyXkWvBzc8+vPmyvBIIQwhvfTBv7tVCL3MiODJp9nOlREPgQ/HhXAJ
	DxiKPpODDmeOHtSh6mkJq5G8ikvpZvmGKsVNY4pbA0A5ZDAeZo6w50+WEkyAB9DU
	9p92jxuU+6LXHaZhpojhE8FZLgxg2/4QX5w4ZsX7U4orncHWDdWBqN+O3sOP6f/N
	h3FABrllJoV/ueSrwqY9H2Zt+ZcAMoJ5dvz/i+Xo5/m/6tzOryqB9/SHUSbQFKyD
	QHShAbhf0Jk2od7bIMHblNuiIOZ9h9UbdZWDvXIf/RKr2JQJjg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 49ytj4rk39-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 13:52:15 -0700 (PDT)
Received: from twshared7571.34.frc3.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 23 Oct 2025 20:52:14 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id A3D9A14A0E3; Thu, 23 Oct 2025 13:52:04 -0700 (PDT)
Date: Thu, 23 Oct 2025 13:52:04 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David
 Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aPqVdAB9F9Go5X3n@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
 <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org>
 <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org>
 <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: 6xRK36eFfN2Lu0lmbWZwLgKYV1g8cJm6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIzMDE5MSBTYWx0ZWRfX6P5ecndKKgp3
 z+tToxuEhrpok2XKBexHArpZmW5f7G/Q74LlddJqHEx+CmheJkCJPGMzibQYjMUmlRVYBoBsc2q
 8fEnXXg0PrYZQjWPbT2B5pUNpvy/qySoN441xSyb6huUI21f9R/iJ8mpxVbOzWddf4RqbMDs74l
 D720MX6p/5oAGYM9Dgm7WvDnwVSS1HYpySYu681EILT7yP0uSZrPrh762GS9EnIaEuKsDJ6kPFW
 fFm8sOdBOaj25uzhvt+6bRMYpGOv8ZGtCP7Z/+x6XYOkMWf7v2GJTqBUkF1QHV3GTKRr6NiDsDC
 V+7SS8gQWOFPknLEnQ3MdkzN2oJ015A64uODNvxNm5k9mz+DEvTJ3WUBR9C49wpYfja+wexxjcl
 CDFBPWAegVHnEWt1kt0+X1nlPvhpDg==
X-Authority-Analysis: v=2.4 cv=DvZbOW/+ c=1 sm=1 tr=0 ts=68fa957f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uBoCfNncoQk3cw2uPvAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 6xRK36eFfN2Lu0lmbWZwLgKYV1g8cJm6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01

One point to clarify

> On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> > Along with the tag, it would probably be useful in that same commit to
> > expand on the scope of the issue in the commit log.  I believe we allow
> > mappings to be created at the top of the address space that cannot be
> > removed via ioctl,

True

> > but such inconsistency should result in an application error due to the
> > failed ioctl

Actually, the ioctl does not fail in the sense that the caller gets an errno.
Attempting to unmap a range ending at the end of address space succeeds (returns
zero), but unmaps zero bytes. An application would only detect this if it
explicitly checked the out size field of vfio_iommu_type1_dma_unmap. Or
attempted to create another overlapping mapping on top of the ranges it expected
to be unmapped.

Annotated below:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 916cad80941c..039cba5a38ca 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -165,19 +165,27 @@ vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 				      dma_addr_t start, size_t size)
 {
+	// start == ~(dma_addr_t)0
+	// size == 0
 	struct rb_node *node = iommu->dma_list.rb_node;
 
 	while (node) {
 		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
 
+		// never true because all dma->iova < ~(dma_addr_t)0
 		if (start + size <= dma->iova)
 			node = node->rb_left;
+		// traverses right until we get to the end of address space
+		// dma, then we walk off the end because
+		// ~(dma_addr_t)0 >= 0 == true
+		// node = NULL
 		else if (start >= dma->iova + dma->size)
 			node = node->rb_right;
 		else
 			return dma;
 	}
 
+	// This happens
 	return NULL;
 }
 
@@ -201,6 +209,8 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
 			node = node->rb_right;
 		}
 	}
+	// iova >= start + size == true, due to overflow to zero => no first
+	// node found
 	if (res && size && dma_res->iova >= start + size)
 		res = NULL;
 	return res;
@@ -1397,6 +1407,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (iova || size)
 			goto unlock;
 		size = U64_MAX;
+	// end of address space unmap passes these checks
 	} else if (!size || size & (pgsize - 1) ||
 		   iova + size - 1 < iova || size > SIZE_MAX) {
 		goto unlock;
@@ -1442,18 +1453,23 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * mappings within the range.
 	 */
 	if (iommu->v2 && !unmap_all) {
+		// passes this check as long as the unmap start doesn't split an
+		// existing dma
 		dma = vfio_find_dma(iommu, iova, 1);
 		if (dma && dma->iova != iova)
 			goto unlock;
 
+		// dma = NULL, we pass this check
 		dma = vfio_find_dma(iommu, iova + size - 1, 0);
 		if (dma && dma->iova + dma->size != iova + size)
 			goto unlock;
 	}
 
 	ret = 0;
+	// n = NULL
 	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
 
+	// loop body never entered
 	while (n) {
 		dma = rb_entry(n, struct vfio_dma, node);
 		if (dma->iova >= iova + size)
@@ -1513,6 +1529,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	/* Report how much was unmapped */
 	unmap->size = unmapped;
 
+	// return 0
 	return ret;
 }
 

