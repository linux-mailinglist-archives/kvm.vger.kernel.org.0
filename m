Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950A819D9DD
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgDCPOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:14:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403991AbgDCPOg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 11:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585926874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVs6NhxQjzozD2M9mDMSQSn8sBMyBHI3OmZY795chUs=;
        b=fyDAzajH9qnwQ5SiQ0QyZhdm1KVS5H9FVsjPFmxsA72kKQo4+svn8q44V5VzkuqJYBFEYq
        8+g6RI8JfMGHDXfbIyU9KoUa1uFFd/dmUeN7duVhUnJrZ4wmOxNiSs0Pt/9aNPqczfK2yi
        oploo8x+3rj7W/vULdJggBP4dbAARwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-IVqN5ft4P02cANa9XT4wtg-1; Fri, 03 Apr 2020 11:14:33 -0400
X-MC-Unique: IVqN5ft4P02cANa9XT4wtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ABA618B5FA9;
        Fri,  3 Apr 2020 15:14:31 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 003F15C1BE;
        Fri,  3 Apr 2020 15:14:24 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:14:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200403091424.39383958@w520.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D807BB9@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
        <20200402115017.0a0f55e2@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D807BB9@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Apr 2020 05:58:55 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 3, 2020 1:50 AM
> > 
> > On Sun, 22 Mar 2020 05:31:58 -0700
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > For a long time, devices have only one DMA address space from platform
> > > IOMMU's point of view. This is true for both bare metal and directed-
> > > access in virtualization environment. Reason is the source ID of DMA in
> > > PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> > > DMA isolation. However, this is changing with the latest advancement in
> > > I/O technology area. More and more platform vendors are utilizing the  
> > PCIe  
> > > PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> > > address spaces as identified by their individual PASIDs. For example,
> > > Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> > > let device access multiple process virtual address space by binding the
> > > virtual address space with a PASID. Wherein the PASID is allocated in
> > > software and programmed to device per device specific manner. Devices
> > > which support PASID capability are called PASID-capable devices. If such
> > > devices are passed through to VMs, guest software are also able to bind
> > > guest process virtual address space on such devices. Therefore, the guest
> > > software could reuse the bare metal software programming model, which
> > > means guest software will also allocate PASID and program it to device
> > > directly. This is a dangerous situation since it has potential PASID
> > > conflicts and unauthorized address space access. It would be safer to
> > > let host intercept in the guest software's PASID allocation. Thus PASID
> > > are managed system-wide.  
> > 
> > Providing an allocation interface only allows for collaborative usage
> > of PASIDs though.  Do we have any ability to enforce PASID usage or can
> > a user spoof other PASIDs on the same BDF?  
> 
> An user can access only PASIDs allocated to itself, i.e. the specific IOASID
> set tied to its mm_struct.

A user is only _supposed_ to access PASIDs allocated to itself.  AIUI
the mm_struct is used for managing the pool of IOASIDs from which the
user may allocate that PASID.  We also state that programming the PASID
into the device is device specific.  Therefore, are we simply trusting
the user to use a PASID that's been allocated to them when they program
the device?  If a user can program an arbitrary PASID into the device,
then what prevents them from attempting to access data from another
user via the device?   I think I've asked this question before, so if
there's a previous explanation or spec section I need to review, please
point me to it.  Thanks,

Alex

