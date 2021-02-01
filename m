Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B930B18A
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 21:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBAUYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 15:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhBAUYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 15:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612211005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2divzMOJAtQWbOGCxdLrJaFfqfhzDFmvPYVXeElaPz4=;
        b=M95YBM2rW3Gthy8vSRrbzNQDEtJxi7Q12cXdaKWZ1xRQbmMIq3snVtwBC2kfQlPI8MZDiY
        c5AAmy3lTAmWtEHT0+H7vu6fXAYA4e8N+9NtVRiEZhYGX+z+040Ab9dt3xk4r5k3UJt5rw
        X3XVuIek8YTTHag9uYxcwtXO4Hx1Rkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-_d1zn_BaO0ylK1XK1SfrXg-1; Mon, 01 Feb 2021 15:23:20 -0500
X-MC-Unique: _d1zn_BaO0ylK1XK1SfrXg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 953E819251A2;
        Mon,  1 Feb 2021 20:23:19 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F4BA10013C0;
        Mon,  1 Feb 2021 20:23:19 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:23:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 0/9] vfio virtual address update
Message-ID: <20210201132318.36795807@omen.home.shazbot.org>
In-Reply-To: <29f7a496-f3c5-c273-538a-34ae87215e0c@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <20210129145550.566d5369@omen.home.shazbot.org>
        <29f7a496-f3c5-c273-538a-34ae87215e0c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 11:54:03 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 1/29/2021 4:55 PM, Alex Williamson wrote:
> > On Fri, 29 Jan 2021 08:54:03 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> Add interfaces that allow the underlying memory object of an iova range
> >> to be mapped to a new virtual address in the host process:
> >>
> >>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
> >>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
> >>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
> >>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
> >>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
> >>
> >> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
> >> vfio translation of host virtual addresses, but DMA to already-mapped pages
> >> continues.  Map-vaddr updates the base VA and resumes translation.  The
> >> implementation supports iommu type1 and mediated devices.  Unmap-all allows
> >> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
> >> userland code.
> >>
> >> This functionality is necessary for live update, in which a host process
> >> such as qemu exec's an updated version of itself, while preserving its
> >> guest and vfio devices.  The process blocks vfio VA translation, exec's
> >> its new self, mmap's the memory object(s) underlying vfio object, updates
> >> the VA, and unblocks translation.  For a working example that uses these
> >> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
> >> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
> >>
> >> Patches 1-3 define and implement the flag to unmap all ranges.
> >> Patches 4-6 define and implement the flags to update vaddr.
> >> Patches 7-9 add blocking to complete the implementation.  
> > 
> > Hi Steve,
> > 
> > It looks pretty good to me, but I have some nit-picky comments that
> > I'll follow-up with on the individual patches.  However, I've made the
> > changes I suggest in a branch that you can find here:
> > 
> > git://github.com/awilliam/linux-vfio.git vaddr-v3
> > 
> > If the changes look ok, just send me an ack, I don't want to attribute
> > something to you that you don't approve of.  Thanks,  
> 
> All changes look good, thanks!  
> Do you need anything more from me on this patch series?

Here's a new branch:

git://github.com/awilliam/linux-vfio.git vaddr-v3.1

Extent of the changes are s/may not/cannot/ on patches 1 & 4 and
addition of Connie's R-b for all (rebased to rc6).  If there are any
final comments, speak now.  Thanks,

Alex

