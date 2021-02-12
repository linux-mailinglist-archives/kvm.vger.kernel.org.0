Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC631A571
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhBLTbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231574AbhBLTbn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613158217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=raUaHGVETzgwtOYJENwGXkg1sLEzgrj+DX5uJcQ/C60=;
        b=TQwOWiwXh0BUKf/r/w3qyShwj7PH9N0C8rzFR0qYRgETxTrNCdKXv6H22TzMiVCvdHiD/X
        8AuV/3HSX5HHbYawGYo0/+Yi6I9Dpl7RIvF9VfpbH0kG3duc4SPH1+DWM9q9rslDYpN8D0
        8oGoJjj8J8vIj0l2DHUF0HStWRGbJu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-on4ZkOB1Pku6iRFeythbPg-1; Fri, 12 Feb 2021 14:30:16 -0500
X-MC-Unique: on4ZkOB1Pku6iRFeythbPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D68ED51B8;
        Fri, 12 Feb 2021 19:30:14 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 784585C3E0;
        Fri, 12 Feb 2021 19:30:11 +0000 (UTC)
Date:   Fri, 12 Feb 2021 12:30:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <peterx@redhat.com>
Subject: Re: [PATCH] vfio/type1: Use follow_pte()
Message-ID: <20210212123011.1ed7b062@omen.home.shazbot.org>
In-Reply-To: <20210212190851.GT4247@nvidia.com>
References: <161315649533.7249.11715726297751446001.stgit@gimli.home>
        <20210212190851.GT4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Feb 2021 15:08:51 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Feb 12, 2021 at 12:01:50PM -0700, Alex Williamson wrote:
> > follow_pfn() doesn't make sure that we're using the correct page
> > protections, get the pte with follow_pte() so that we can test
> > protections and get the pfn from the pte.
> > 
> > Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index ec9fd95a138b..90715413c3d9 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -463,9 +463,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> >  			    unsigned long vaddr, unsigned long *pfn,
> >  			    bool write_fault)
> >  {
> > +	pte_t *ptep;
> > +	spinlock_t *ptl;
> >  	int ret;
> >  
> > -	ret = follow_pfn(vma, vaddr, pfn);
> > +	ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);
> >  	if (ret) {
> >  		bool unlocked = false;
> >  
> > @@ -479,9 +481,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> >  		if (ret)
> >  			return ret;
> >  
> > -		ret = follow_pfn(vma, vaddr, pfn);
> > +		ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);  
> 
> commit 9fd6dad1261a541b3f5fa7dc5b152222306e6702 in linux-next is what
> export's follow_pte and it uses a different signature:
> 
> +int follow_pte(struct mm_struct *mm, unsigned long address,
> +              pte_t **ptepp, spinlock_t **ptlp)

Thanks, I stole it off the mailing list and hadn't noticed the change.

> Recommend you send this patch for rc1 once the right stuff lands in
> Linus's tree
> 
> Otherwise it looks OK
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks!

Alex

