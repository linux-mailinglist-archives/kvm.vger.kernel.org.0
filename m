Return-Path: <kvm+bounces-23656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC9594C666
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 23:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA0EEB247AF
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 21:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3916015B97B;
	Thu,  8 Aug 2024 21:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eEVhIfjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF5145324;
	Thu,  8 Aug 2024 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723153393; cv=none; b=QLwyfnXE3m5SfMVuXGA8AKZo+vcDtGKyqlgz2y8rJ3iHc5XIH3fMNyG0jmn9/U2MCNSI1e+8zstdxkkMPpShFUp2bKLcO0VcOGJygJtiND02FTC84NEBCyUiDjSg+BvkxgHPa4n43IYkvmdtTFLPURFIP9nCuatQwrVOzZL6snY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723153393; c=relaxed/simple;
	bh=iiVOkB4xyNGt5Ji9BBZS0LrYXkdJzAuatNcxlThBVP8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GseZ8qyRnYek2pZeC3sGyZNxPUp0oaELpJ/6xtOEJDYcQu4VOuS98MqgmIxWfdZwJbxppl48sF9NtDxjFVJFXIZ/bC+ygEDOjdaosBCvgfXbX/y+3tmJK2wOGjK25rCJzcppl1qKYSPg7XwzZRA1EKvnW424/UpzvV58M+RiFPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eEVhIfjZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478AgTUL018279;
	Thu, 8 Aug 2024 21:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=/w4EXjUZu5VjQ6P9pS53rZX6
	79O69cN7CRSEqBYc/6o=; b=eEVhIfjZ+Jko3gqbT23mzlDSqmOt4qv5TjmNpLb9
	79vj8+wqQjZ4EMaBCrNanYXEBrXj/cpEn/Et3wNWH/tpHE/XYSBSBNlZzuYK3zTo
	7Ov9ATuBKsAczdv6tJbBa6c2DU9efWF6tnM3rSCRxf4LH/nF16DuAXOgj927q68d
	kOL/ycSNxKB/zQQnvLF9mnzf7VMqkCBR+P+LAj41DD9d05/GQXCKKEuhPUZUFJ6Q
	2fb/FacrdG+6FNiZGpL6CNRla7BJZ7dHj3je7OHiNio4m8RL7tLK6JqktAcrpF2A
	3koSy9sLnEUrTC1YinovWehFgCGHdp1hl0lCVCUXwShXMQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40vvgm1n2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 21:43:00 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 478Lgwtf010204
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 Aug 2024 21:42:58 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 8 Aug 2024 14:42:58 -0700
Date: Thu, 8 Aug 2024 14:42:57 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <akpm@linux-foundation.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <tabba@google.com>, <david@redhat.com>, <roypat@amazon.co.uk>,
        <qperret@google.com>, <linux-coco@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
Message-ID: <20240808132450196-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <diqzr0ayn90d.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzr0ayn90d.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: wKWq1rQBhn0g9QePO9TgwnTys_nyqsBy
X-Proofpoint-GUID: wKWq1rQBhn0g9QePO9TgwnTys_nyqsBy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_21,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080155

On Thu, Aug 08, 2024 at 06:51:14PM +0000, Ackerley Tng wrote:
> Elliot Berman <quic_eberman@quicinc.com> writes:
> 
> > Confidential/protected guest virtual machines want to share some memory
> > back with the host Linux. For example, virtqueues allow host and
> > protected guest to exchange data. In MMU-only isolation of protected
> > guest virtual machines, the transition between "shared" and "private"
> > can be done in-place without a trusted hypervisor copying pages.
> >
> > Add support for this feature and allow Linux to mmap host-accessible
> > pages. When the owner provides an ->accessible() callback in the
> > struct guest_memfd_operations, guest_memfd allows folios to be mapped
> > when the ->accessible() callback returns 0.
> >
> > To safely make inaccessible:
> >
> > ```
> > folio = guest_memfd_grab_folio(inode, index, flags);
> > r = guest_memfd_make_inaccessible(inode, folio);
> > if (r)
> >         goto err;
> >
> > hypervisor_does_guest_mapping(folio);
> >
> > folio_unlock(folio);
> > ```
> >
> > hypervisor_does_s2_mapping(folio) should make it so
> > ops->accessible(...) on those folios fails.
> >
> > The folio lock ensures atomicity.
> 
> I am also working on determining faultability not based on the
> private-ness of the page but based on permission given by the
> guest. I'd like to learn from what you've discovered here.
> 
> Could you please elaborate on this? What races is the folio_lock
> intended to prevent, what operations are we ensuring atomicity of?

The contention I've been paying most attention to are racing userspace
and vcpu faults where guest needs the page to be private. There could
also be multiple vcpus demanding same page.

We had some chatter about doing the private->shared conversion via
separate ioctl (mem attributes). I think the same race can happen with
userspace whether it's vcpu fault or ioctl making the folio "finally
guest-private".

Also, in non-CoCo KVM private guest_memfd, KVM or userspace could also
convert private->shared and need to make sure that all the tracking for
the current state is consistent.

> Is this why you did a guest_memfd_grab_folio() before checking
> ->accessible(), and then doing folio_unlock() if the page is
> inaccessible?
> 

Right, I want to guard against userspace being able to fault in a page
concurrently with that same page doing a shared->private conversion. The
folio_lock seems like the best fine-grained lock to grab.

If the shared->private converter wins the folio_lock first, then the
userspace fault waits and will see ->accessible() == false as desired. 

If userspace fault wins the folio_lock first, it relinquishes the lock
only after installing the folio in page tables[*]. When the
shared->private converter finally gets the lock,
guest_memfd_make_inaccessible() will be able to unmap the folio from any
userspace page tables (and direct map, if applicable).

[*]: I'm not mm expert, but that was what I could find when I went
digging.

Thanks,
Elliot

> >
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > ---
> >  include/linux/guest_memfd.h |  7 ++++
> >  mm/guest_memfd.c            | 81 ++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 87 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> > index f9e4a27aed67..edcb4ba60cb0 100644
> > --- a/include/linux/guest_memfd.h
> > +++ b/include/linux/guest_memfd.h
> > @@ -16,12 +16,18 @@
> >   * @invalidate_end: called after invalidate_begin returns success. Optional.
> >   * @prepare: called before a folio is mapped into the guest address space.
> >   *           Optional.
> > + * @accessible: called after prepare returns success and before it's mapped
> > + *              into the guest address space. Returns 0 if the folio can be
> > + *              accessed.
> > + *              Optional. If not present, assumes folios are never accessible.
> >   * @release: Called when releasing the guest_memfd file. Required.
> >   */
> >  struct guest_memfd_operations {
> >  	int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
> >  	void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
> >  	int (*prepare)(struct inode *inode, pgoff_t offset, struct folio *folio);
> > +	int (*accessible)(struct inode *inode, struct folio *folio,
> > +			  pgoff_t offset, unsigned long nr);
> >  	int (*release)(struct inode *inode);
> >  };
> >  
> > @@ -48,5 +54,6 @@ struct file *guest_memfd_alloc(const char *name,
> >  			       const struct guest_memfd_operations *ops,
> >  			       loff_t size, unsigned long flags);
> >  bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops);
> > +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio);
> >  
> >  #endif
> > diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> > index e9d8cab72b28..6b5609932ca5 100644
> > --- a/mm/guest_memfd.c
> > +++ b/mm/guest_memfd.c
> > @@ -9,6 +9,8 @@
> >  #include <linux/pagemap.h>
> >  #include <linux/set_memory.h>
> >  
> > +#include "internal.h"
> > +
> >  static inline int guest_memfd_folio_private(struct folio *folio)
> >  {
> >  	unsigned long nr_pages = folio_nr_pages(folio);
> > @@ -89,7 +91,7 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >  			goto out_err;
> >  	}
> >  
> > -	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > +	if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
> >  		r = guest_memfd_folio_private(folio);
> >  		if (r)
> >  			goto out_err;
> > @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >  }
> >  EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> >  
> > +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> > +{
> > +	unsigned long gmem_flags = (unsigned long)file->private_data;
> > +	unsigned long i;
> > +	int r;
> > +
> > +	unmap_mapping_folio(folio);
> > +
> > +	/**
> > +	 * We can't use the refcount. It might be elevated due to
> > +	 * guest/vcpu trying to access same folio as another vcpu
> > +	 * or because userspace is trying to access folio for same reason
> > +	 *
> > +	 * folio_lock serializes the transitions between (in)accessible
> > +	 */
> > +	if (folio_maybe_dma_pinned(folio))
> > +		return -EBUSY;
> > +
> > +	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > +		r = guest_memfd_folio_private(folio);
> > +		if (r)
> > +			return r;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static vm_fault_t gmem_fault(struct vm_fault *vmf)
> > +{
> > +	struct file *file = vmf->vma->vm_file;
> > +	struct inode *inode = file_inode(file);
> > +	const struct guest_memfd_operations *ops = inode->i_private;
> > +	struct folio *folio;
> > +	pgoff_t off;
> > +	int r;
> > +
> > +	folio = guest_memfd_grab_folio(file, vmf->pgoff, GUEST_MEMFD_GRAB_UPTODATE);
> 
> Could grabbing the folio with GUEST_MEMFD_GRAB_UPTODATE cause unintended
> zeroing of the page if the page turns out to be inaccessible?
> 

I assume that if page is inaccessible, it would already have been marked
up to date and we wouldn't try to zero the page.

I'm thinking that if hypervisor zeroes the page when making the page
private, it would not give the GUEST_MEMFD_GRAB_UPTODATE flag when
grabbing the folio. I believe the hypervisor should know when grabbing
the folio if it's about to donate to the guest.

Thanks,
Elliot


