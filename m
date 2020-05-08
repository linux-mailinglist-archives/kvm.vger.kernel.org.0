Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238371CB1D6
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgEHObB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 10:31:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45170 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726873AbgEHObB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 10:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588948259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lIRjAGCSvbO1PdVeTIb+ibHQAikoDQgX7hMGEBLwgkE=;
        b=bLxCpf7RASqSQKjPP6jHdJ62mCdcZb9NX1i2TQeBDKsSsJfh6n32kY6C2f7Am7E7aa7jCh
        NVSYrdimWeW6HdSngxq4sTajowM2dw9D0BR+Kfqafs0fZrUYNESFwvKAK1yO6350HoH869
        ADlpdc2eEWORrCpQxSJEvU0XOynfLaM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-Rxe0gd7VOuCHzoEN3AptAg-1; Fri, 08 May 2020 10:30:48 -0400
X-MC-Unique: Rxe0gd7VOuCHzoEN3AptAg-1
Received: by mail-qk1-f200.google.com with SMTP id d19so2181622qkj.21
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 07:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lIRjAGCSvbO1PdVeTIb+ibHQAikoDQgX7hMGEBLwgkE=;
        b=I5V9dZCORRw7qFnqsCUnnF1hy4jKTu8V0keAs9ST5Q7pqzH0Hn6xqbcpxTH3wlWz1H
         V9dASqPD7aiQ33dvUqm8Aq8Xfqus4un83S/lrJgj4miYnRkN7uyVvAF4Um7qBbPGhoPA
         fy07nfvFXO4jk2h9/AL9NyQO223MmAZ4O50MnvpZw90BTQI5CwDyrh+UzJG6JQI/RZLA
         1xKDm7ZeJ9e77EA4mRhOT24fHqhSHWBK7kDOcgffDsA54v9uJ3lXUCAPODrM1leDe70Q
         Qh5KYaPtKwj9kfURy+P6FYzzGCUQnhBHkWMdqiRrefFe9tNXYRZhmyHVYjn//uhc9rwq
         CIug==
X-Gm-Message-State: AGi0PuaZ4+2YqxvKxsCaeXarnrHtYN57gnw7Ef4Dz1S3H4qHHekfJ2a4
        duWQqdqIEQ/1fOmSDt5XtUFB9S7KWN1hM87LkZCzUeZ0IyDyy10nDMpZYZsguMfoDAwTuR9VAl3
        4XvseiezqbdnQ
X-Received: by 2002:aed:2e24:: with SMTP id j33mr3254493qtd.117.1588948247011;
        Fri, 08 May 2020 07:30:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypLpIgVamTZ1EUCABaqOg/LRWWRWl2ZAJbE/Vu45j1TY2btxCLAF4n4xUil/Okkd6JIjfe6Bqg==
X-Received: by 2002:aed:2e24:: with SMTP id j33mr3254355qtd.117.1588948245283;
        Fri, 08 May 2020 07:30:45 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k58sm1603302qtf.40.2020.05.08.07.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 07:30:44 -0700 (PDT)
Date:   Fri, 8 May 2020 10:30:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508143042.GY228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
 <20200507235421.GK26002@ziepe.ca>
 <20200508021939.GT228260@xz-x1>
 <20200508121013.GO26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200508121013.GO26002@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 09:10:13AM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2020 at 10:19:39PM -0400, Peter Xu wrote:
> > On Thu, May 07, 2020 at 08:54:21PM -0300, Jason Gunthorpe wrote:
> > > On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:
> > > > On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > > > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > > > the range being faulted into the vma.  Add support to manually provide
> > > > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > > > 
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > > > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > > > +			    unsigned long vaddr, unsigned long *pfn,
> > > > > +			    bool write_fault)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > > > +	if (ret) {
> > > > > +		bool unlocked = false;
> > > > > +
> > > > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > > > +				       FAULT_FLAG_REMOTE |
> > > > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > > > +				       &unlocked);
> > > > > +		if (unlocked)
> > > > > +			return -EAGAIN;
> > > > 
> > > > Hi, Alex,
> > > > 
> > > > IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> > > > fault-in is done correctly with the valid PTE as long as ret==0, even if
> > > > unlocked==true.
> > > 
> > > It is true, and today it is fine, but be careful when reworking this
> > > to use notifiers as unlocked also means things like the vma pointer
> > > are invalidated.
> > 
> > Oh right, thanks for noticing that.  Then we should probably still keep the
> > retry logic... because otherwise the latter follow_pfn() could be referencing
> > an invalid vma already...
> 
> I looked briefly and thought this flow used the vma only once?

        ret = follow_pfn(vma, vaddr, pfn);
        if (ret) {
                bool unlocked = false;
 
                ret = fixup_user_fault(NULL, mm, vaddr,
                                       FAULT_FLAG_REMOTE |
                                       (write_fault ?  FAULT_FLAG_WRITE : 0),
                                       &unlocked);
                if (unlocked)
                        return -EAGAIN;
 
                if (ret)
                        return ret;
 
                ret = follow_pfn(vma, vaddr, pfn);      <--------------- [1]
        }

So imo the 2nd follow_pfn() [1] could be racy if without the unlocked check.

Thanks,

-- 
Peter Xu

