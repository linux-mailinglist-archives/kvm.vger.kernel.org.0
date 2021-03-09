Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD9332F4B
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 20:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCITsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 14:48:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhCITs3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 14:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615319309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+6T9g+65HR3GbghKP+E5VatQ1Ly1n65wA9dNu8qYeVw=;
        b=jB/Da70AShmWoeH3lYdtniMbMkqL3pXGZB2eiYMDID6BldmFNzOxu/zt1+KvyEN8HA2x3s
        E527OQgI9sWmYS8puGUkGCgj2To+q4IadqPP0vuv8TYBzq/ZbxMLyuTI4KY/jHNXBtpBoi
        pZV4NBhjGtGitrJ0/RjKTIqUgU4ONnY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-2agK5NJlOt6ZBEHvqIRwIQ-1; Tue, 09 Mar 2021 14:48:27 -0500
X-MC-Unique: 2agK5NJlOt6ZBEHvqIRwIQ-1
Received: by mail-qv1-f69.google.com with SMTP id da16so11023834qvb.2
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 11:48:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+6T9g+65HR3GbghKP+E5VatQ1Ly1n65wA9dNu8qYeVw=;
        b=AHscymNN+YZ1GzU0SJxWmsKFqfgq1Y0QXbkFpOdiu5TzfoV5SXmKj5UovxeYgS4oZa
         N58RHNLQqM4Z0N0jry/u5gAvHO8iK9IDxmBDx0s1edN+3MjS8uXegkCzRMzZ7yJnx8dO
         nnaslSHEp7vTheBbpNgHBM2tfYWh3UGOGh/RXbij+xsODUVqjZVX0sz6E4RszXiKtco2
         LuSL/U1zID9sAFPsFWSF3FlBAgQi92+ZSQ9/tlhGmNB198OOXyWRZ52J49Oj9DrrVrC3
         UKVYK6k0Oo12VwjrogSXnQkpkgm8LuLsGp/l51bsQTPNPeFK1B9+uLojEm/wy6rwM636
         loCg==
X-Gm-Message-State: AOAM533FRHhtifpjPHMUNnHOACrm0O5C1E4cRcWKSYyEnFy35i0bYn4M
        7ywxpevchcao2/e0tkQIwSSiLNh9Qu8+eWCvRJxLDefJMQimiZAPa8hsvSohge61ajDEF+U924a
        VTslwu71NqfGu
X-Received: by 2002:a37:e315:: with SMTP id y21mr11481588qki.418.1615319306893;
        Tue, 09 Mar 2021 11:48:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaGEqVNvsBQoPcSdxfnsw5oRVjX3r8bvAG+qMNLXv5SKRlwQkcaxHeXJhDMwZzFbft/7lk/w==
X-Received: by 2002:a37:e315:: with SMTP id y21mr11481572qki.418.1615319306602;
        Tue, 09 Mar 2021 11:48:26 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id a9sm10360544qtx.96.2021.03.09.11.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 11:48:26 -0800 (PST)
Date:   Tue, 9 Mar 2021 14:48:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309194824.GE763132@xz-x1>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
 <20210309124609.GG2356281@nvidia.com>
 <20210309082951.75f0eb01@x1.home.shazbot.org>
 <20210309164004.GJ2356281@nvidia.com>
 <20210309184739.GD763132@xz-x1>
 <20210309122607.0b68fb9b@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309122607.0b68fb9b@omen.home.shazbot.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 12:26:07PM -0700, Alex Williamson wrote:
> On Tue, 9 Mar 2021 13:47:39 -0500
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Tue, Mar 09, 2021 at 12:40:04PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Mar 09, 2021 at 08:29:51AM -0700, Alex Williamson wrote:  
> > > > On Tue, 9 Mar 2021 08:46:09 -0400
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >   
> > > > > On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:  
> > > > > > Hi guys:
> > > > > > 
> > > > > > Thanks for the helpful comments, after rethinking the issue, I have proposed
> > > > > >  the following change: 
> > > > > > 1. follow_pte instead of follow_pfn.    
> > > > > 
> > > > > Still no on follow_pfn, you don't need it once you use vmf_insert_pfn  
> > > > 
> > > > vmf_insert_pfn() only solves the BUG_ON, follow_pte() is being used
> > > > here to determine whether the translation is already present to avoid
> > > > both duplicate work in inserting the translation and allocating a
> > > > duplicate vma tracking structure.  
> > >  
> > > Oh.. Doing something stateful in fault is not nice at all
> > > 
> > > I would rather see __vfio_pci_add_vma() search the vma_list for dups
> > > than call follow_pfn/pte..  
> > 
> > It seems to me that searching vma list is still the simplest way to fix the
> > problem for the current code base.  I see io_remap_pfn_range() is also used in
> > the new series - maybe that'll need to be moved to where PCI_COMMAND_MEMORY got
> > turned on/off in the new series (I just noticed remap_pfn_range modifies vma
> > flags..), as you suggested in the other email.
> 
> 
> In the new series, I think the fault handler becomes (untested):
> 
> static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> {
>         struct vm_area_struct *vma = vmf->vma;
>         struct vfio_pci_device *vdev = vma->vm_private_data;
>         unsigned long base_pfn, pgoff;
>         vm_fault_t ret = VM_FAULT_SIGBUS;
> 
>         if (vfio_pci_bar_vma_to_pfn(vma, &base_pfn))
>                 return ret;
> 
>         pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> 
>         down_read(&vdev->memory_lock);
> 
>         if (__vfio_pci_memory_enabled(vdev))
>                 ret = vmf_insert_pfn(vma, vmf->address, pgoff + base_pfn);
> 
>         up_read(&vdev->memory_lock);
> 
>         return ret;
> }

It's just that the initial MMIO access delay would be spread to the 1st access
of each mmio page access rather than using the previous pre-fault scheme.  I
think an userspace cares the delay enough should pre-fault all pages anyway,
but just raise this up.  Otherwise looks sane.

Thanks,

-- 
Peter Xu

