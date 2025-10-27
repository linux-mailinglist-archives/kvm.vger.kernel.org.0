Return-Path: <kvm+bounces-61181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4EAC0F246
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 117A9341DEB
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C333101B7;
	Mon, 27 Oct 2025 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="X/D86aVm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D781D30F532
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761580990; cv=none; b=eQkcSZtJtyYg8i9NvZ7EiFTz1MfEeBIpWDt4pWisMjjsprXmqlvyLOogQnYnATgZjQktuiH42kMtP8AIqBVtGYfMboUywbpnXUbsaMjX+Vwa7P4S8ZR/7w2uOb/B3oFo3j5C7BEGmIb9QajL0WkuAcEiDLs0xyFUYRofV8/PvQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761580990; c=relaxed/simple;
	bh=05oV4QgWlrICz8v8LWqrCddNcBhrbTFx9f/clrOypts=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scE7pHVDZSclMYPFmTNQr9OO3e6vW3emxs3y/pFSNRcav47GEocui+gnCzSe1ek1ZNX+AACSgi+9jCYizG50v/Y+dgrTCOkEOy+5F0eQkPRQtEz9AxVOnR3ElVHWATV2QWV47VvmkC5wiKbiwBm0hrBIc1o3JvO9zgDYTAphE7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=X/D86aVm; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RBhuc71218971
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:03:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Nq/Ni+MDbBxIJTDqDTi0
	lg+krZJe34pBBkitBlxWWts=; b=X/D86aVms8Om9gwJhnL5NvmUlZfNIhJzF1hC
	nkrcV8Yb85VjHS07HAg2Rb1Y1sEeC5U6/M9uV7zFx7hHARxkF15sDhGXI2zqWoRt
	PLiYv8OqMniCUhZQElpBXZMZgofeTPMxYbej/4rTGq9igC3NIQ9s0vXeF7OkYOCi
	LrrFwk/vUXYmKGcpmtiW0nPOFHTNNIlp2O4D/O3SU8mwkW0cpwoMjtWtIIHuh+eb
	LtDz6Gj1IE1J6b4oR/8UQZpZKubVPrHRwdkNg0R+Ot+BTJhs+val3NroEefBZxt/
	Vc2fGVb4EVkt5H4nz78Pmz9HDvjELf/f/ntJGal5qD/clCMxCA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a284et1fn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:03:05 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 27 Oct 2025 16:03:03 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 91AE442FC2D; Mon, 27 Oct 2025 09:02:55 -0700 (PDT)
Date: Mon, 27 Oct 2025 09:02:55 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David
 Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aP+Xr1DrNM7gYD8v@devgpu012.nha5.facebook.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE0OSBTYWx0ZWRfX25HVSvrPP9Y2
 t72MzycnCUCDmRoAtTSYCOsBhmVCueu/JTvpBxJPMDkNWJGtRI7zouLhqZcUMycNU2JSN19a1On
 u1ufO8w9LZqsZ82IjjDU2pV/JlKFuvbFS4mZry8tdSkEfNu2TEb3T4mZZAVZvy5Q3YDk7hNxlI8
 7+dE+joWlQV+IufSNKYFzYU0qWfxTaDbpGUk8SUM7yhQg/T4Cmx5z1J8haGvozoWiTdE1WrTw9S
 cgDOiChyVp6mvyGyrvISR76WTizantBMefyy5p7K+A6FaMIlpIaEeLAP8sxIiS6sH97keelbiRw
 VcjLTJ30dugs52lWPyRpykbQFR42Fn8UyrUficQhLFxr27wzsGJEsRhfi5BSXausTCZvdaLBsZ2
 Ufqd8htIwHtlZRPzqaawGmI0unfC3w==
X-Proofpoint-ORIG-GUID: NNbcj6IC09jubSPvJKSdz7-dDTtzF1lD
X-Proofpoint-GUID: NNbcj6IC09jubSPvJKSdz7-dDTtzF1lD
X-Authority-Analysis: v=2.4 cv=OaWVzxTY c=1 sm=1 tr=0 ts=68ff97b9 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=g2ih4RM_o3xvLBDMwOgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_06,2025-10-22_01,2025-03-28_01

On Tue, Oct 21, 2025 at 09:25:55AM -0700, Alex Mastro wrote:
> On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> > I do note that we're missing a Fixes: tag.  I think we've had hints of
> > this issue all the way back to the original implementation, so perhaps
> > the last commit should include:
> > 
> > Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> 
> SGTM
> 
> > Unless you've identified a more specific target.
> 
> I have not.
> 
> > Along with the tag, it would probably be useful in that same commit to
> > expand on the scope of the issue in the commit log.  I believe we allow
> > mappings to be created at the top of the address space that cannot be
> > removed via ioctl, but such inconsistency should result in an
> > application error due to the failed ioctl and does not affect cleanup
> > on release.

I want to make sure I understand the cleanup on release path. Is my supposition
below correct?

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 916cad80941c..7f8d23b06680 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1127,6 +1127,7 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
 static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			     bool do_accounting)
 {
+	// end == 0 due to overflow
 	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
 	struct vfio_domain *domain, *d;
 	LIST_HEAD(unmapped_region_list);
@@ -1156,6 +1157,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	iommu_iotlb_gather_init(&iotlb_gather);
+	// doesn't enter the loop, never calls iommu_unmap
 	while (iova < end) {
 		size_t unmapped, len;
 		phys_addr_t phys, next;
@@ -1210,6 +1212,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
+	// go here
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
@@ -2394,6 +2397,8 @@ static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
 	struct rb_node *node;
 
 	while ((node = rb_first(&iommu->dma_list)))
+		// eventually, we attempt to remove the end of address space
+		// mapping
 		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
 }
 
@@ -2628,6 +2633,8 @@ static void vfio_release_domain(struct vfio_domain *domain)
 		kfree(group);
 	}
 
+	// Is this backstop what saves us? Even though we didn't do individual
+	// unmaps, the "leaked" end of address space mappings get freed here?
 	iommu_domain_free(domain->domain);
 }
 
@@ -2643,10 +2650,12 @@ static void vfio_iommu_type1_release(void *iommu_data)
 		kfree(group);
 	}
 
+	// start here
 	vfio_iommu_unmap_unpin_all(iommu);
 
 	list_for_each_entry_safe(domain, domain_tmp,
 				 &iommu->domain_list, next) {
+		// eventually...
 		vfio_release_domain(domain);
 		list_del(&domain->next);
 		kfree(domain);

