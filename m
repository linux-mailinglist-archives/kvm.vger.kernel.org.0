Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E9F3E8439
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhHJUUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231398AbhHJUUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628626815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gr9ydGicGYYIpIdPqhG9R+Yfix/AQszzOwnKSS/8chs=;
        b=QqbzQWmfoJWI/tFHZsoJArzdb1nN3ZAMyoctqwaLC1vUJEHlzcvon4RgGSBhw0YTv5tlL/
        P9+lBUSQAc8R6FQsSjIsj568rDAjYUUM8bLTfUTR4BnceXDbubeRgsPuaDyIWN70m3LV1d
        PScyrFhTZSYjO4LrHsKnlO5DpkMbOUw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-fVS7KglANDOfOR84IS0kTQ-1; Tue, 10 Aug 2021 16:20:14 -0400
X-MC-Unique: fVS7KglANDOfOR84IS0kTQ-1
Received: by mail-qv1-f72.google.com with SMTP id z25-20020a0ca9590000b029033ba243ffa1so17744290qva.0
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 13:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gr9ydGicGYYIpIdPqhG9R+Yfix/AQszzOwnKSS/8chs=;
        b=JXquaKLWDE7QzbAtq6rApgfLMpLbTgYVdSd7vsWz8/NpVt1AP1yJAesIKyKGnLrVBB
         XRwZUgFT5JTxzW0Uw55GQGHRrlnpLgz2tfzoYCOCsh8WHTYqpDogur4z92hMYCmoRAau
         TW7/HMNsC4hM0dokzZ51XtYcMITVz5SQbCtPEFsb/REBtGYbWnyUqJI90Ebzo4TRMZ7d
         W6aTKoMBPErb72SAmbEFD5KNWZvebsR3PMLDiFZwQyS37kq5LxOUH32VoT3Pvb85A+q9
         Tm/2+W+YP8v1xCTajFnf3KXdR/vRTkhCzjsnwyiqlpbOh1W+lSIbxeUTbfO5nIKCbgYZ
         RWkg==
X-Gm-Message-State: AOAM533PlY2XwXUTMpEdsP6n7XYat8CeZ3gcaiyJFJClruhX37INS8H6
        A8vQ0YDGDVU8AGm2Ee79ynb5KAs16HIt+rnfJZiqGMRlAEs0fxgMZ+mIubfZSW0cqDxjy+iGEMq
        fdH3uqTvHuyIG
X-Received: by 2002:a37:a7d2:: with SMTP id q201mr30795010qke.158.1628626814048;
        Tue, 10 Aug 2021 13:20:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD/SBX1bvWaqNT+p/rP4m0OLiPIsi3i5KBCXy2l6Fk5Kcju97nlz7lIXDz3fxmxzfZ8fQHSA==
X-Received: by 2002:a37:a7d2:: with SMTP id q201mr30794980qke.158.1628626813765;
        Tue, 10 Aug 2021 13:20:13 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id a18sm11026048qkg.62.2021.08.10.13.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 13:20:13 -0700 (PDT)
Date:   Tue, 10 Aug 2021 16:20:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRLffH221xvfABvf@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <YRLJ/wdiY/fnGj2d@t490s>
 <20210810135932.6825833b.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810135932.6825833b.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 01:59:32PM -0600, Alex Williamson wrote:
> On Tue, 10 Aug 2021 14:48:31 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> > > @@ -1690,7 +1554,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
> > >  
> > >  	vma->vm_private_data = vdev;
> > >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > -	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> > > +	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);  
> > 
> > This addition seems to be an accident. :) Thanks,
> 
> Nope, Jason noted on a previous version that io_remap_pfn_range() is
> essentially:
> 
>   remap_pfn_range(vma, addr, pfn, size, pgprot_decrypted(prot));
> 
> So since we switched to vmf_insert_pfn() I added this page protection
> flag to the vma instead, then it gets removed later when we switch back
> to io_remap_pfn_range().  Thanks,

I see, I read it wrongly as pgprot_noncached() previously.  Yes, it makes sense
to do so.  Thanks,

-- 
Peter Xu

