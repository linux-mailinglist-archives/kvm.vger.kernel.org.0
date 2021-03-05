Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8799832DE3C
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 01:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhCEAHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 19:07:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhCEAHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 19:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614902858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6l5+K0Gr4gH4UEeNthFmTFNjx300eie785UyYH0gW4=;
        b=XTxY973kssu0YY4kStjdY4KtcYHVyOKsZhPtVzKC4ltNpPj7vLwScnV+kg7Pt0TZoF8T8F
        8+E3SmgmSq4SYjldYv82ioA9mISkhd836v0bH8CVmAIQ275YiclQPZnoMcegXITOZN7iIj
        wlAWlUl2YF8E3jWRrlgA83TgCWL3utg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-ZDW2kIJPMneREUkzWYmAcg-1; Thu, 04 Mar 2021 19:07:37 -0500
X-MC-Unique: ZDW2kIJPMneREUkzWYmAcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF5F9101F7A5;
        Fri,  5 Mar 2021 00:07:35 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A790D5C1A1;
        Fri,  5 Mar 2021 00:07:31 +0000 (UTC)
Date:   Thu, 4 Mar 2021 17:07:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210304170731.72039a23@omen.home.shazbot.org>
In-Reply-To: <20210304231633.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401268537.16443.2329805617992345365.stgit@gimli.home>
        <20210222172913.GP4247@nvidia.com>
        <20210224145506.48f6e0b4@omen.home.shazbot.org>
        <20210225000610.GP4247@nvidia.com>
        <20210225152113.3e083b4a@omen.home.shazbot.org>
        <20210225234949.GV4247@nvidia.com>
        <20210304143757.1ca42cfc@omen.home.shazbot.org>
        <20210304231633.GP4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 Mar 2021 19:16:33 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Mar 04, 2021 at 02:37:57PM -0700, Alex Williamson wrote:
> 
> > Therefore unless a bus driver opts-out by replacing vm_private_data, we
> > can identify participating vmas by the vm_ops and have flags indicating
> > if the vma maps device memory such that vfio_get_device_from_vma()
> > should produce a device reference.  The vfio IOMMU backends would also
> > consume this, ie. if they get a valid vfio_device from the vma, use the
> > pfn_base field directly.  vfio_vm_ops would wrap the bus driver
> > callbacks and provide reference counting on open/close to release this
> > object.  
> 
> > I'm not thrilled with a vfio_device_ops callback plumbed through
> > vfio-core to do vma-to-pfn translation, so I thought this might be a
> > better alternative.  Thanks,  
> 
> Maybe you could explain why, because I'm looking at this idea and
> thinking it looks very complicated compared to a simple driver op
> callback?

vfio-core needs to export a vfio_vma_to_pfn() which I think assumes the
caller has already used vfio_device_get_from_vma(), but should still
validate the vma is one from a vfio device before calling this new
vfio_device_ops callback.  vfio-pci needs to validate the vm_pgoff
value falls within a BAR region, mask off the index and get the
pci_resource_start() for the BAR index.

Then we need a solution for how vfio_device_get_from_vma() determines
whether to grant a device reference for a given vma, where that vma may
map something other than device memory.  Are you imagining that we hand
out device references independently and vfio_vma_to_pfn() would return
an errno for vm_pgoff values that don't map device memory and the IOMMU
driver would release the reference?

It all seems rather ad-hoc.
 
> The implementation of such an op for vfio_pci is one line trivial, why
> do we need allocated memory and a entire shim layer instead? 
> 
> Shim layers are bad.

The only thing here I'd consider a shim layer is overriding vm_ops,
which just seemed like a cleaner and simpler solution than exporting
open/close functions and validating the bus driver installs them, and
the error path should they not.

> We still need a driver op of some kind because only the driver can
> convert a pg_off into a PFN. Remember the big point here is to remove
> the sketchy follow_pte()...

The bus driver simply writes the base_pfn value in the example
structure I outlined in its .mmap callback.  I'm just looking for an
alternative place to store our former vm_pgoff in a way that doesn't
prevent using unmmap_mapping_range().  The IOMMU backend, once it has a
vfio_device via vfio_device_get_from_vma() can know the format of
vm_private_data, cast it as a vfio_vma_private_data and directly use
base_pfn, accomplishing the big point.  They're all operating in the
agreed upon vm_private_data format.  Thanks,

Alex

