Return-Path: <kvm+bounces-61304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4345EC1579E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7C33BE5D3
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 15:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C237833CE89;
	Tue, 28 Oct 2025 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="EJYW7osJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133392BB17
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761665402; cv=none; b=nrg1qIDtROGk7Pe0X0djDLt+KlM/bbmw7fNfkenvUAXs5v+ITAIRWPEe9jHM8j4thQjV9SDJPMFv3OKlSg6jvDXH6aeeWRBe9CjFhuxiyeF05TxALJZQbNNVWeRff+C9zJ/HFs10CbteWu+hFaM83VTWTB/I5ow8liXGWYY5XhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761665402; c=relaxed/simple;
	bh=0+JcJSZRv+5cEPbScn4cJij1GB/yKUcRRKLWCDt4cKc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKueBvuiJXZe6wPKmkRNEwP+Pbm1hqsXrm5EPRYLKdwmBF7hYov91tg0ZvNWGEh2P941mDlD8QsUP7XdWQwAlpmvJ+KN5OyRoRWw1dqoEtcmpXVl1zITXtG70qvRGKazSxI02c+cozCdgRN958bQTTGODUt3gEXrmRu6a6i7ZWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=EJYW7osJ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59SCtGED2340083
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:30:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=J6s9huE7CzeVZWd+xdRL
	81JG8jOCmMWfuJ8kW6UvvEU=; b=EJYW7osJHOsP1saNlEkBmCXNvinNXDBkHMur
	7bqEvs/wb3YPYTIbb2hMO6DuO+vs4s88k2eHmo5A0TwYr3w+4AiX8u23cH8aigs7
	uByPbVTnXrLeuV5hSFuRzUYAicWPDUgucrRH1hcOWgMXmpBjlwrRQOqCHkFv6G6g
	MQf9jETx7RoV3H9716BZowd3ZwdMAetQM1eUPsz0s2wsyrc+IXSI2U2KIeRRrmHm
	9bwGAvkcNQAmUscdaWUJgBdgIsE4vbYQiD0Dr9sYR86P+doHjAf/okO33Xseso1q
	PUgLavOObg3yGaydoQ7JRso6xdXthKFWjiDk+s4rbV/IWmF8FA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2x8t1emg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:29:59 -0700 (PDT)
Received: from twshared31684.07.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 28 Oct 2025 15:29:58 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 0511B503217; Tue, 28 Oct 2025 08:29:51 -0700 (PDT)
Date: Tue, 28 Oct 2025 08:29:51 -0700
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David
 Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aQDhb7HahKWLuUG4@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
 <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org>
 <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org>
 <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
 <aP+Xr1DrNM7gYD8v@devgpu012.nha5.facebook.com>
 <20251027195732.2b7d1d3f@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251027195732.2b7d1d3f@shazbot.org>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: mU73JxvT52Sc_wcqnfqTIyFL_eUobOZj
X-Proofpoint-GUID: mU73JxvT52Sc_wcqnfqTIyFL_eUobOZj
X-Authority-Analysis: v=2.4 cv=ZKTaWH7b c=1 sm=1 tr=0 ts=6900e177 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=ufEAdIiS26JpeJN-8DcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDEzMCBTYWx0ZWRfX2AHg947Dl8/I
 URMw62/Wm9lSZXFPkmEQapf+6Npa8Hj+Qeahsh6YlkXRGD487hY2tia8YMLUM16IFbgH3kjv3HP
 UsSAQ5zthl9V/uaXKSQl+X9EwCEd5rx1Ex9rJ7RSWbSO/wKwUKHkGP/XQ+KJrfd5PYKnvmFBTEk
 2xN11SbcYDE3OC9Ip8OCclZGltPXr1pNwTk29NUjJ6IPKavrOMJHAHYMce2k7YS3famOjuSKpgm
 6FH+TlhIDIeXMqsqVbST1CL/Esx00YRTsM6GG9pAZ1sXc++61jsKM9ovMrtRKl6gjamixAmoJCM
 iz3jOixLicNPz2zV3nTcMqxYfWm3PhAgc2SNTZV/cBJZ7sNFBGA+5F61XR79lXhVwj1aeJl3fyf
 +Eu9hi/4hfCA58iD+iTvddE8bnuWvw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01

On Mon, Oct 27, 2025 at 07:57:32PM -0600, Alex Williamson wrote:
> On Mon, 27 Oct 2025 09:02:55 -0700
> Alex Mastro <amastro@fb.com> wrote:
> 
> > On Tue, Oct 21, 2025 at 09:25:55AM -0700, Alex Mastro wrote:
> > > On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:     
> > > > Along with the tag, it would probably be useful in that same commit to
> > > > expand on the scope of the issue in the commit log.  I believe we allow
> > > > mappings to be created at the top of the address space that cannot be
> > > > removed via ioctl, but such inconsistency should result in an
> > > > application error due to the failed ioctl and does not affect cleanup
> > > > on release.  
> > 
> > I want to make sure I understand the cleanup on release path. Is my supposition
> > below correct?
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 916cad80941c..7f8d23b06680 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -1127,6 +1127,7 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
> >  static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  			     bool do_accounting)
> >  {
> > +	// end == 0 due to overflow
> >  	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
> >  	struct vfio_domain *domain, *d;
> >  	LIST_HEAD(unmapped_region_list);
> > @@ -1156,6 +1157,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  	}
> >  
> >  	iommu_iotlb_gather_init(&iotlb_gather);
> > +	// doesn't enter the loop, never calls iommu_unmap
> 
> If it were only that, I think the iommu_domain_free() would be
> sufficient, but it looks like we're also missing the unpin.  Freeing

Oh, right.

> the IOMMU domain isn't going to resolve that.  So it actually appears
> we're leaking those pinned pages and this isn't as self-resolving as I
> had thought.  I imagine if you ran your new unit test to the point where
> we'd pinned and failed to unpin the majority of memory you'd start to
> see system-wide problems.  Thanks,

Makes sense.

> Alex
> 
> >  	while (iova < end) {
> >  		size_t unmapped, len;
> >  		phys_addr_t phys, next;
> > @@ -1210,6 +1212,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >  {
> >  	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
> > +	// go here
> >  	vfio_unmap_unpin(iommu, dma, true);
> >  	vfio_unlink_dma(iommu, dma);
> >  	put_task_struct(dma->task);
> > @@ -2394,6 +2397,8 @@ static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
> >  	struct rb_node *node;
> >  
> >  	while ((node = rb_first(&iommu->dma_list)))
> > +		// eventually, we attempt to remove the end of address space
> > +		// mapping
> >  		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
> >  }
> >  
> > @@ -2628,6 +2633,8 @@ static void vfio_release_domain(struct vfio_domain *domain)
> >  		kfree(group);
> >  	}
> >  
> > +	// Is this backstop what saves us? Even though we didn't do individual
> > +	// unmaps, the "leaked" end of address space mappings get freed here?
> >  	iommu_domain_free(domain->domain);
> >  }
> >  
> > @@ -2643,10 +2650,12 @@ static void vfio_iommu_type1_release(void *iommu_data)
> >  		kfree(group);
> >  	}
> >  
> > +	// start here
> >  	vfio_iommu_unmap_unpin_all(iommu);
> >  
> >  	list_for_each_entry_safe(domain, domain_tmp,
> >  				 &iommu->domain_list, next) {
> > +		// eventually...
> >  		vfio_release_domain(domain);
> >  		list_del(&domain->next);
> >  		kfree(domain);
> 

