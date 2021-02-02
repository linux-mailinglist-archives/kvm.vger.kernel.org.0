Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7871230B902
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 08:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhBBH4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 02:56:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229632AbhBBH4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 02:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612252488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WQLUAIHSmC2jzVpO3T/JTVH3vEJZYxGWpzkwK5n8xAI=;
        b=PJHAkfvpnZlTvBQc9X+pFGqITvxva/WUbMx1sH5HHyIEh/bduA2k8c3YNZzejV8Ysdan2M
        T+aKO0MtUzgJz/in80ECp0QFiDhMTn7v2AGR3dXF0btWmfwxX3s6cQmCWG+nASmVO197MY
        JShHIpnSLX+GBy6UJjhpqenyGk3mxrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-jz2JWWNHPU-cHlEHtGWAWg-1; Tue, 02 Feb 2021 02:54:46 -0500
X-MC-Unique: jz2JWWNHPU-cHlEHtGWAWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BA2F800D62;
        Tue,  2 Feb 2021 07:54:45 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12FFA10016F4;
        Tue,  2 Feb 2021 07:54:39 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:54:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steven Sistare <steven.sistare@oracle.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 0/9] vfio virtual address update
Message-ID: <20210202085437.51ad8423.cohuck@redhat.com>
In-Reply-To: <20210201132318.36795807@omen.home.shazbot.org>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <20210129145550.566d5369@omen.home.shazbot.org>
        <29f7a496-f3c5-c273-538a-34ae87215e0c@oracle.com>
        <20210201132318.36795807@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 13:23:18 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Sat, 30 Jan 2021 11:54:03 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
> > On 1/29/2021 4:55 PM, Alex Williamson wrote:  
> > > On Fri, 29 Jan 2021 08:54:03 -0800
> > > Steve Sistare <steven.sistare@oracle.com> wrote:
> > >     
> > >> Add interfaces that allow the underlying memory object of an iova range
> > >> to be mapped to a new virtual address in the host process:
> > >>
> > >>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
> > >>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
> > >>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
> > >>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
> > >>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
> > >>
> > >> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
> > >> vfio translation of host virtual addresses, but DMA to already-mapped pages
> > >> continues.  Map-vaddr updates the base VA and resumes translation.  The
> > >> implementation supports iommu type1 and mediated devices.  Unmap-all allows
> > >> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
> > >> userland code.
> > >>
> > >> This functionality is necessary for live update, in which a host process
> > >> such as qemu exec's an updated version of itself, while preserving its
> > >> guest and vfio devices.  The process blocks vfio VA translation, exec's
> > >> its new self, mmap's the memory object(s) underlying vfio object, updates
> > >> the VA, and unblocks translation.  For a working example that uses these
> > >> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
> > >> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
> > >>
> > >> Patches 1-3 define and implement the flag to unmap all ranges.
> > >> Patches 4-6 define and implement the flags to update vaddr.
> > >> Patches 7-9 add blocking to complete the implementation.    
> > > 
> > > Hi Steve,
> > > 
> > > It looks pretty good to me, but I have some nit-picky comments that
> > > I'll follow-up with on the individual patches.  However, I've made the
> > > changes I suggest in a branch that you can find here:
> > > 
> > > git://github.com/awilliam/linux-vfio.git vaddr-v3
> > > 
> > > If the changes look ok, just send me an ack, I don't want to attribute
> > > something to you that you don't approve of.  Thanks,    
> > 
> > All changes look good, thanks!  
> > Do you need anything more from me on this patch series?  
> 
> Here's a new branch:
> 
> git://github.com/awilliam/linux-vfio.git vaddr-v3.1
> 
> Extent of the changes are s/may not/cannot/ on patches 1 & 4 and
> addition of Connie's R-b for all (rebased to rc6).  If there are any
> final comments, speak now.  Thanks,
> 
> Alex

LGTM.

