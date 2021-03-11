Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90E337984
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 17:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCKQg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 11:36:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCKQgA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 11:36:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615480559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tay6Xgbuz3P/9tYVnN/Yi/OQ+TCFlVqNrtCNDEB7Y/s=;
        b=HU1/5bs8PUdGZKW5oj+y63/20WF6EGbp0tWfl6yIV0RZBWMdM5OS5xDxpwUPOWUP9J6pqL
        /Kx3hO6aU0hW1W5fu17P8KMtKG4tpGrFScSyXzCRREnZAMShNJq9GhNAotnubluS5vRXwk
        DUv8i3K/PmcbA5XgwP9IaKOEa/WtBeo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-aPu5uoQ0MqiY5FPqfo8O2Q-1; Thu, 11 Mar 2021 11:35:56 -0500
X-MC-Unique: aPu5uoQ0MqiY5FPqfo8O2Q-1
Received: by mail-qk1-f199.google.com with SMTP id i188so15904651qkd.7
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 08:35:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tay6Xgbuz3P/9tYVnN/Yi/OQ+TCFlVqNrtCNDEB7Y/s=;
        b=MJ1KYyyT4S9TrXcsEKdjHP5g3I3iPIqCO6SXU79FD6TznZ9yPVISv7PzVHQRngVqxX
         nzkz8MFnr39VNBdfTVU+f0UitCDQED457wNeUhtvvZeL5uFT70vqrbPMnwHCpw9lLU5w
         /kN3TpcbaFWP5d5b8/hJnjdF0UqnrgOjH4OUynYhnLMKcaTrYd+hhXS7IX5wgVNHNY6F
         p/tLyGy7VEgFjTaBxdt974DPqcgVXLjLVxSGklRDf4lYTcYo1REE7O+aXgf+L9RwKC5+
         rTO+ifie75peP5boqwqo36HsIS5roGULjObXRLmTSXwwartwprq8oPXH9Wbx+DVZ5yx+
         T31g==
X-Gm-Message-State: AOAM533Yh3YLJjjOf+VPQ8n42L++rIgBzRU8mYLyMHUtB8qRfCwHZ4eI
        W+KaGFTuccrbE36v9jCebgSrXlYwmaWy/K4GpknXUQXZy1vz3GqacHZCCcdHPs+ga+hJEvdS4h7
        jXHlRYzNoEXP8
X-Received: by 2002:a37:9a0b:: with SMTP id c11mr8237488qke.190.1615480555660;
        Thu, 11 Mar 2021 08:35:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBEq2SKvtDtQPh3zMaWyeZa3af5J/uC4Fodmrf19+O1LZ0aBfUedVd1TcizvkOzhtg2aXt5A==
X-Received: by 2002:a37:9a0b:: with SMTP id c11mr8237467qke.190.1615480555413;
        Thu, 11 Mar 2021 08:35:55 -0800 (PST)
Received: from xz-x1 ([142.126.89.138])
        by smtp.gmail.com with ESMTPSA id c13sm2259269qkc.99.2021.03.11.08.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 08:35:54 -0800 (PST)
Date:   Thu, 11 Mar 2021 11:35:53 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210311163553.GE194839@xz-x1>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
 <20210310184011.GA2356281@nvidia.com>
 <20210310200607.GG6530@xz-x1>
 <20210311113524.GA1726872@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210311113524.GA1726872@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 11:35:24AM +0000, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 03:06:07PM -0500, Peter Xu wrote:
> > On Wed, Mar 10, 2021 at 02:40:11PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> > > 
> > > > > I think after the address_space changes this should try to stick with
> > > > > a normal io_rmap_pfn_range() done outside the fault handler.
> > > > 
> > > > I assume you're suggesting calling io_remap_pfn_range() when device
> > > > memory is enabled,
> > > 
> > > Yes, I think I saw Peter thinking along these lines too
> > > 
> > > Then fault just always causes SIGBUS if it gets called
> 
> I feel much more comfortable having the io_remap_pfn_range in place.

It's just that Jason convinced me with the fact that io_remap_pfn_range() will
modify vma flags, and I tend to agree that's not a good thing to do during a
fault() handler (in remap_pfn_range):

	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;

Although this case is special and it does not do harm it seems, since all these
four flags are already set by vfio_pci_mmap() anyways, so the flag didn't
really change at least with current code base.  It's just still cleaner to not
use io_remap_pfn_range() in vfio fault() since future change to the function
io_remap_pfn_range() may not guarantee to match with vfio mmap().

> 
> > 
> > Indeed that looks better than looping in the fault().
> > 
> > But I don't know whether it'll be easy to move io_remap_pfn_range() to device
> > memory enablement.  If it's a two-step thing, we can fix the BUG_ON and vma
> > duplication issue first, then the full rework can be done in the bigger series
> > as what be chosen as the last approach.
> 
> What kind of problems do you envision?  It seems pretty simple to do,
> at least when combined with the unmap_mapping_range patch.

Moving the prefault into device memory enablement will even remove the 1st
fault delay when doing the first MMIO access that triggers this fault().  Also
in that case I think we can also call io_remap_pfn_range() directly and safely,
rather than looping over vmf_insert_pfn_prot().

Thanks,

-- 
Peter Xu

