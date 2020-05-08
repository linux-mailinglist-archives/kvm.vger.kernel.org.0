Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF701CA0B0
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEHCTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:19:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35864 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgEHCTp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 22:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588904384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JLgSaSiv4yYvs1EPOLMzvQOEIO76IkdBvqeIXiY7JGM=;
        b=KOUWFlT9xjBwouWRnTx01ihtTMyn43q5Yyb6WeFfFQFgswZdM2510KQuTBmQJzxrfZApHw
        NrJLeaqCm5vbxcX7GuKHE20dLhECt5rqP+h/TFZZD1CSYBm0WuyCHtEcfTHiBn2YrCVA43
        kjYMNq78aS3T485ZTc2I6Y4VaEa9i5U=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-bZ2uVfNIN_SLaPLUBciEaw-1; Thu, 07 May 2020 22:19:42 -0400
X-MC-Unique: bZ2uVfNIN_SLaPLUBciEaw-1
Received: by mail-qk1-f199.google.com with SMTP id p126so401327qke.8
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 19:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLgSaSiv4yYvs1EPOLMzvQOEIO76IkdBvqeIXiY7JGM=;
        b=kGL65sFNFXGBjFI0G1ykkVozNzERDaSOfThoLlF654bFrLmCpcYBvoZqBqagF0WceG
         ffDyNxWf14N0FiiD/1ekJTfxYku2ZGu4jceaj+bJ7q9yq8+ovLOm8i47D71LG/FGLYlX
         /mRRNifBee0WbnR8B2P+oDllnwusc+eq0cozmfVYCuJQSxEUGY7nLdIVOR8HIEMXwD6t
         60IrUawA9DhKcDPhzSqiNK3/g3Y9Fu/YHqQP9yHFG2QX80Jega2iflzQOD1Oa7GISoHv
         6ThkgIGzDhUUlYrUzPIGC8e/IDeVAwQGft5WNxAb0vPA4z+3AEG24PcnDkBMFgkV1H75
         ORlg==
X-Gm-Message-State: AGi0Pua+NKrapbAj/V700q7uR9mWHHZXqJ7tc2rqcb4s+g5Ravx3wbIK
        vIxo5fmYK8WT6XHuMH4MbjZQ95VpsuNJcV32igNLFrdoFE/NEIhS2Fvndxk8XLIUtEYY3FnoNb+
        0wHeoTk0k0VOZ
X-Received: by 2002:a37:b244:: with SMTP id b65mr495698qkf.329.1588904381906;
        Thu, 07 May 2020 19:19:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypK5WVcJu8AxnvxH75BqYI7fquWzH90Irnz0KNnKxL7u7e3h154rbjbL3aetQuw1D3Oexo6GEQ==
X-Received: by 2002:a37:b244:: with SMTP id b65mr495685qkf.329.1588904381668;
        Thu, 07 May 2020 19:19:41 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i59sm333207qtb.58.2020.05.07.19.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 19:19:41 -0700 (PDT)
Date:   Thu, 7 May 2020 22:19:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508021939.GT228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
 <20200507235421.GK26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507235421.GK26002@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 08:54:21PM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:
> > On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > the range being faulted into the vma.  Add support to manually provide
> > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > >  	return 0;
> > >  }
> > >  
> > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > +			    unsigned long vaddr, unsigned long *pfn,
> > > +			    bool write_fault)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > +	if (ret) {
> > > +		bool unlocked = false;
> > > +
> > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > +				       FAULT_FLAG_REMOTE |
> > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > +				       &unlocked);
> > > +		if (unlocked)
> > > +			return -EAGAIN;
> > 
> > Hi, Alex,
> > 
> > IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> > fault-in is done correctly with the valid PTE as long as ret==0, even if
> > unlocked==true.
> 
> It is true, and today it is fine, but be careful when reworking this
> to use notifiers as unlocked also means things like the vma pointer
> are invalidated.

Oh right, thanks for noticing that.  Then we should probably still keep the
retry logic... because otherwise the latter follow_pfn() could be referencing
an invalid vma already...

Thanks,

-- 
Peter Xu

