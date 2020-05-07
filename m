Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323B81C9DD2
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgEGVry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 17:47:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgEGVry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 17:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588888073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NimXLPwW2cXlIec0hrGIyPRgpSOxgyz6NjChAU7LBg=;
        b=RPyA7NuoXtuW2hnET1iVNTNoKbj2iCTS1Jdw7jYD5Ai9lxa1bVQKhfMB/LQ/iZUKf89O2i
        OOvY2dMEj61iSJz+Trm7XHZDHygpNmBipO74H6at/1MNkh/N70riCqe57N5lbo2k5nhQY4
        GNH6+NO7w9Ao2a1//2Skq6oXi3VZ9Ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-aA9z9tkCP-SlVA92l8C7MA-1; Thu, 07 May 2020 17:47:49 -0400
X-MC-Unique: aA9z9tkCP-SlVA92l8C7MA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6055680058A;
        Thu,  7 May 2020 21:47:48 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 244065D9C5;
        Thu,  7 May 2020 21:47:44 +0000 (UTC)
Date:   Thu, 7 May 2020 15:47:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200507154743.306d2f3e@x1.home>
In-Reply-To: <20200507212443.GO228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
        <158871568480.15589.17339878308143043906.stgit@gimli.home>
        <20200507212443.GO228260@xz-x1>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 May 2020 17:24:43 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > the range being faulted into the vma.  Add support to manually provide
> > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 33 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index cc1d64765ce7..4a4cb7cd86b2 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> >  	return 0;
> >  }
> >  
> > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > +			    unsigned long vaddr, unsigned long *pfn,
> > +			    bool write_fault)
> > +{
> > +	int ret;
> > +
> > +	ret = follow_pfn(vma, vaddr, pfn);
> > +	if (ret) {
> > +		bool unlocked = false;
> > +
> > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > +				       FAULT_FLAG_REMOTE |
> > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > +				       &unlocked);
> > +		if (unlocked)
> > +			return -EAGAIN;  
> 
> Hi, Alex,
> 
> IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> fault-in is done correctly with the valid PTE as long as ret==0, even if
> unlocked==true.
> 
> Note: there's another patch just removed the similar retry in kvm:
> 
> https://lore.kernel.org/kvm/20200416155906.267462-1-peterx@redhat.com/

Great, I was basing this on that kvm code, so I can make essentially an
identical fix.  Thanks!

Alex

