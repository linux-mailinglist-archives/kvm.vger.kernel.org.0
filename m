Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE51332E81
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 19:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCISr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 13:47:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhCISru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 13:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615315664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CasSRYvlyrDxSTrN8PaoTkzFKzX6/cN2TKA9gMzN2Gw=;
        b=ajxzSM8uzJtin1b1Nk/maNkC7AQsLdspRWzEtUrdfs2m+l5rpljnzy7WTJGIFZzBM1yDwd
        Rzpl9Z+tbElzOuT2QyEQI7qIypCIx+9AObrFZgsPQ8dwBjQZlKu/2LnDElFtSqtQKTVWTG
        N7fa42cKX4DvZ7cToV82tdAY3FnpPd8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-YfmmDUe5M7yhfQ4-qPDWzQ-1; Tue, 09 Mar 2021 13:47:43 -0500
X-MC-Unique: YfmmDUe5M7yhfQ4-qPDWzQ-1
Received: by mail-qv1-f72.google.com with SMTP id i1so10904324qvu.12
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 10:47:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CasSRYvlyrDxSTrN8PaoTkzFKzX6/cN2TKA9gMzN2Gw=;
        b=Jv6FzyVlmJd5KuOX25TzaWISrp3J4Sa3KDI2eosoKjg198r1OvrxnlxURn36cpi9+H
         BBDVHoiEF99v+iRMdTSYvyg30KHTxQTrc8nSjdl4sND5LUYO+LpJnB+PTbc5d1m7I4MZ
         xmmm3IuTql2z1yso6KKUiVHyTfE4U/rfkHVb7T6CrS7xP0uN5eeRVVKz+LAIZroH1/M1
         cuBHQ+DtOoygfQ2vpvK51KZ9sqFgBR+jkL0e7G5DOatyhHSKQI9ZFYBn6Qu8GidQKGTh
         fTPbY0+pb6/rSqA51yTDAOZp/5H2t/tNVTQtnqYobeRmvUZLWdNQilLogDIXUFgcif0l
         2Tqw==
X-Gm-Message-State: AOAM5322PTUAFJEwAakEeoLU2Eum+f5dtBuGqVoptwMoIpSiFMjUE3C/
        Q/XEYYW3gu2B93VN9bXdAn8FVdhw2V6MyMYh0ZNKvzL6elGJBoJrGZWIhQTI/oa5FX0rnN6HyqH
        m+HvhfwAz2iQA
X-Received: by 2002:a37:4f49:: with SMTP id d70mr26729194qkb.353.1615315662587;
        Tue, 09 Mar 2021 10:47:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnKE8AmumIMKaOWMZ/WiSbxCcrja5iHb60AVgSdkZ7BSupOSp3qdWeEdsOnKlMgsZBgb3fog==
X-Received: by 2002:a37:4f49:: with SMTP id d70mr26729175qkb.353.1615315662323;
        Tue, 09 Mar 2021 10:47:42 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id c73sm11004840qkg.6.2021.03.09.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 10:47:41 -0800 (PST)
Date:   Tue, 9 Mar 2021 13:47:39 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20210309184739.GD763132@xz-x1>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
 <20210309124609.GG2356281@nvidia.com>
 <20210309082951.75f0eb01@x1.home.shazbot.org>
 <20210309164004.GJ2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309164004.GJ2356281@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 12:40:04PM -0400, Jason Gunthorpe wrote:
> On Tue, Mar 09, 2021 at 08:29:51AM -0700, Alex Williamson wrote:
> > On Tue, 9 Mar 2021 08:46:09 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:
> > > > Hi guys:
> > > > 
> > > > Thanks for the helpful comments, after rethinking the issue, I have proposed
> > > >  the following change: 
> > > > 1. follow_pte instead of follow_pfn.  
> > > 
> > > Still no on follow_pfn, you don't need it once you use vmf_insert_pfn
> > 
> > vmf_insert_pfn() only solves the BUG_ON, follow_pte() is being used
> > here to determine whether the translation is already present to avoid
> > both duplicate work in inserting the translation and allocating a
> > duplicate vma tracking structure.
>  
> Oh.. Doing something stateful in fault is not nice at all
> 
> I would rather see __vfio_pci_add_vma() search the vma_list for dups
> than call follow_pfn/pte..

It seems to me that searching vma list is still the simplest way to fix the
problem for the current code base.  I see io_remap_pfn_range() is also used in
the new series - maybe that'll need to be moved to where PCI_COMMAND_MEMORY got
turned on/off in the new series (I just noticed remap_pfn_range modifies vma
flags..), as you suggested in the other email.

Thanks,

-- 
Peter Xu

