Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2F1CB39B
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgEHPmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 11:42:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbgEHPmV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 11:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588952540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nlu92I5sNSCPo/A7wi9FFbA90CNs5A1PvYXZQYpD8lI=;
        b=a6gNMi89r9m6H07ixiqxPVCjmvzqCuOt4aQ3sJ2Ji4e02pS8VZoCgSRAZwFoyCO6IHQy6u
        U0H6ONtgcC7xglSR2kxzB4XwRCVv6K1htCUWxQjNcSxgS/g98GSbSTRKEiJcvXfsLyPdv1
        ZTD+m6DkyttRxcN6MgGYaFJvkmhIO+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-51njguVJOxW4iJO6G4aJtQ-1; Fri, 08 May 2020 11:42:18 -0400
X-MC-Unique: 51njguVJOxW4iJO6G4aJtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D4B31005510;
        Fri,  8 May 2020 15:42:17 +0000 (UTC)
Received: from w520.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5072F1001B07;
        Fri,  8 May 2020 15:42:14 +0000 (UTC)
Date:   Fri, 8 May 2020 09:42:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508094213.0183c645@w520.home>
In-Reply-To: <20200508150540.GP26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
        <158871568480.15589.17339878308143043906.stgit@gimli.home>
        <20200507212443.GO228260@xz-x1>
        <20200507235421.GK26002@ziepe.ca>
        <20200508021939.GT228260@xz-x1>
        <20200508121013.GO26002@ziepe.ca>
        <20200508143042.GY228260@xz-x1>
        <20200508150540.GP26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 May 2020 12:05:40 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, May 08, 2020 at 10:30:42AM -0400, Peter Xu wrote:
> > On Fri, May 08, 2020 at 09:10:13AM -0300, Jason Gunthorpe wrote:  
> > > On Thu, May 07, 2020 at 10:19:39PM -0400, Peter Xu wrote:  
> > > > On Thu, May 07, 2020 at 08:54:21PM -0300, Jason Gunthorpe wrote:  
> > > > > On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:  
> > > > > > On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:  
> > > > > > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > > > > > the range being faulted into the vma.  Add support to manually provide
> > > > > > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > > > > > 
> > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > > > > > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > > > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > > > > > >  	return 0;
> > > > > > >  }
> > > > > > >  
> > > > > > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > > > > > +			    unsigned long vaddr, unsigned long *pfn,
> > > > > > > +			    bool write_fault)
> > > > > > > +{
> > > > > > > +	int ret;
> > > > > > > +
> > > > > > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > > > > > +	if (ret) {
> > > > > > > +		bool unlocked = false;
> > > > > > > +
> > > > > > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > > > > > +				       FAULT_FLAG_REMOTE |
> > > > > > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > > > > > +				       &unlocked);
> > > > > > > +		if (unlocked)
> > > > > > > +			return -EAGAIN;  
> > > > > > 
> > > > > > Hi, Alex,
> > > > > > 
> > > > > > IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> > > > > > fault-in is done correctly with the valid PTE as long as ret==0, even if
> > > > > > unlocked==true.  
> > > > > 
> > > > > It is true, and today it is fine, but be careful when reworking this
> > > > > to use notifiers as unlocked also means things like the vma pointer
> > > > > are invalidated.  
> > > > 
> > > > Oh right, thanks for noticing that.  Then we should probably still keep the
> > > > retry logic... because otherwise the latter follow_pfn() could be referencing
> > > > an invalid vma already...  
> > > 
> > > I looked briefly and thought this flow used the vma only once?  
> > 
> >         ret = follow_pfn(vma, vaddr, pfn);
> >         if (ret) {
> >                 bool unlocked = false;
> >  
> >                 ret = fixup_user_fault(NULL, mm, vaddr,
> >                                        FAULT_FLAG_REMOTE |
> >                                        (write_fault ?  FAULT_FLAG_WRITE : 0),
> >                                        &unlocked);
> >                 if (unlocked)
> >                         return -EAGAIN;
> >  
> >                 if (ret)
> >                         return ret;
> >  
> >                 ret = follow_pfn(vma, vaddr, pfn);      <--------------- [1]
> >         }
> > 
> > So imo the 2nd follow_pfn() [1] could be racy if without the unlocked check.  
> 
> Ah yes, I didn't notice that, you can't touch vma here if unlocked is true.

Thanks for the discussion.  I gather then that this patch is correct as
written, which probably also mean the patch Peter linked for KVM should
not be applied since the logic is the same there.  Correct?  Thanks,

Alex

