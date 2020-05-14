Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02051D40A5
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 00:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgENWRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 18:17:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727835AbgENWRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 18:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589494639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=82TddMEg4mqYZ099LI536goDZAY+X+1mxtBAUJ3Zp9g=;
        b=B9GUQaoLnFrRxqkqN/DQI3/gCo4bTm/Cqdl/HwcvhGkLcGM9WWXbazZTj08bTaU9egEkbl
        kG3AKv2zBgVn4yoh1hWE5Q+r0Bye9yxeQ6U34t2edQoypeIS1sYqW736qLvsYcLLyxAe4J
        mDCx15wh9XzcZmUrRkP+YJqs4IMneGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-GMJsk-wZMmaYpUcuBx_Htg-1; Thu, 14 May 2020 18:17:18 -0400
X-MC-Unique: GMJsk-wZMmaYpUcuBx_Htg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FEF28014D7;
        Thu, 14 May 2020 22:17:17 +0000 (UTC)
Received: from w520.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A502C2C26A;
        Thu, 14 May 2020 22:17:13 +0000 (UTC)
Date:   Thu, 14 May 2020 16:17:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200514161712.14b34984@w520.home>
In-Reply-To: <20200514212538.GB449815@xz-x1>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
        <20200514212538.GB449815@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 17:25:38 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Thu, May 14, 2020 at 10:51:46AM -0600, Alex Williamson wrote:
> > This is a follow-on series to "vfio-pci: Block user access to disabled
> > device MMIO"[1], which extends user access blocking of disabled MMIO
> > ranges to include unmapping the ranges from the IOMMU.  The first patch
> > adds an invalidation callback path, allowing vfio bus drivers to signal
> > the IOMMU backend to unmap ranges with vma level granularity.  This
> > signaling is done both when the MMIO range becomes inaccessible due to
> > memory disabling, as well as when a vma is closed, making up for the
> > lack of tracking or pinning for non-page backed vmas.  The second
> > patch adds registration and testing interfaces such that the IOMMU
> > backend driver can test whether a given PFNMAP vma is provided by a
> > vfio bus driver supporting invalidation.  We can then implement more
> > restricted semantics to only allow PFNMAP DMA mappings when we have
> > such support, which becomes the new default.  
> 
> Hi, Alex,
> 
> IIUC we'll directly tearing down the IOMMU page table without telling the
> userspace for those PFNMAP pages.  I'm thinking whether there be any side
> effect on the userspace side when userspace cached these mapping information
> somehow.  E.g., is there a way for userspace to know this event?
> 
> Currently, QEMU VT-d will maintain all the IOVA mappings for each assigned
> device when used with vfio-pci.  In this case, QEMU will probably need to
> depend some invalidations sent from the guest (either userspace or kernel)
> device drivers to invalidate such IOVA mappings after they got removed from the
> hardware IOMMU page table underneath.  I haven't thought deeper on what would
> happen if the vIOMMU has got an inconsistent mapping of the real device.

Full disclosure, I haven't tested vIOMMU, there might be issues.  Let's
puzzle through this.  Without a vIOMMU the vfio MemoryListener in QEMU
makes use of address_space_memory, which is essentially the vCPU view
of memory.  When the memory bit of a PCI device is disabled, QEMU
correctly removes the MMIO regions of the device from this AddressSpace.
When re-enabled, they get re-added.  In that case what we're doing here
is a little bit redundant, the IOMMU mappings get dropped in response
to the memory bit and the subsequent callback from the MemoryListener
is effectively a no-op since the range is already unmapped.  When the
memory bit is re-enabled, the AddressSpace gets updated, the
MemoryListener fires and we re-fault the mmap as we're re-adding the
IOMMU mapping.

When we have a vIOMMU, the address_space_memory behavior should be the
same as above; the vIOMMU isn't involved in vCPU to device access.  So
I think our concern is explicit mappings, much like vfio itself makes.
That feels like a gap.  When the vma is being closed, I think dropping
those mappings out from under the user is probably still the right
approach and I think this series would still be useful if we only did
that much.  I think this would also address Jason's primary concern.
It's better to get an IOMMU fault from the user trying to access those
mappings than it is to leave them in place.

OTOH, if we're dropping mappings in response to disabling the memory
bit, we're changing a potential disabled MMIO access fault into an
IOMMU fault, where the platform response might very well be fatal in
either case.  Maybe we need to look at a more temporary invalidation
due to the memory enable bit.  If we could remap the range to a kernel
page we could maybe avoid the IOMMU fault and maybe even have a crude
test for whether any data was written to the page while that mapping
was in place (ie. simulating more restricted error handling, though
more asynchronous than done at the platform level).  Let me look into
it.  Thanks,

Alex

