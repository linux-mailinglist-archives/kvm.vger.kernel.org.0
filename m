Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D54115416
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 16:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfLFPUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 10:20:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbfLFPUq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 10:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575645646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pfl977vnjhBWvFbZf/0f4eWRm+7D+y6Nr6bdSL6ElAo=;
        b=FVutT6I8snFSZRnzOAVnkeqkVf6TF203ltNXybo8Ml0bFZ8iEA1yl/1pBGtbOyRlidA7Li
        rYRK2XNRVCdJhQ5f4od2GSyc1cW3b+82A+VYx57y6UWsyS/InolHxizUbHM3PBZc+H3oGj
        hYSIm+wk33HEsFy2gHNA60+du6rguIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-6Lh95lYzNf-q7nqL4q1hig-1; Fri, 06 Dec 2019 10:20:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AB1A800D4C;
        Fri,  6 Dec 2019 15:20:43 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4A3960135;
        Fri,  6 Dec 2019 15:20:39 +0000 (UTC)
Date:   Fri, 6 Dec 2019 08:20:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 4/9] vfio-pci: register default
 dynamic-trap-bar-info region
Message-ID: <20191206082038.2b1078d9@x1.home>
In-Reply-To: <20191206060407.GF31791@joy-OptiPlex-7040>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <20191205032650.29794-1-yan.y.zhao@intel.com>
        <20191205165530.1f29fe85@x1.home>
        <20191206060407.GF31791@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 6Lh95lYzNf-q7nqL4q1hig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Dec 2019 01:04:07 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Dec 06, 2019 at 07:55:30AM +0800, Alex Williamson wrote:
> > On Wed,  4 Dec 2019 22:26:50 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > Dynamic trap bar info region is a channel for QEMU and vendor driver to
> > > communicate dynamic trap info. It is of type
> > > VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO and subtype
> > > VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO.
> > > 
> > > This region has two fields: dt_fd and trap.
> > > When QEMU detects a device regions of this type, it will create an
> > > eventfd and write its eventfd id to dt_fd field.
> > > When vendor drivre signals this eventfd, QEMU reads trap field of this
> > > info region.
> > > - If trap is true, QEMU would search the device's PCI BAR
> > > regions and disable all the sparse mmaped subregions (if the sparse
> > > mmaped subregion is disablable).
> > > - If trap is false, QEMU would re-enable those subregions.
> > > 
> > > A typical usage is
> > > 1. vendor driver first cuts its bar 0 into several sections, all in a
> > > sparse mmap array. So initally, all its bar 0 are passthroughed.
> > > 2. vendor driver specifys part of bar 0 sections to be disablable.
> > > 3. on migration starts, vendor driver signals dt_fd and set trap to true
> > > to notify QEMU disabling the bar 0 sections of disablable flags on.
> > > 4. QEMU disables those bar 0 section and hence let vendor driver be able
> > > to trap access of bar 0 registers and make dirty page tracking possible.
> > > 5. on migration failure, vendor driver signals dt_fd to QEMU again.
> > > QEMU reads trap field of this info region which is false and QEMU
> > > re-passthrough the whole bar 0 region.
> > > 
> > > Vendor driver specifies whether it supports dynamic-trap-bar-info region
> > > through cap VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR in
> > > vfio_pci_mediate_ops->open().
> > > 
> > > If vfio-pci detects this cap, it will create a default
> > > dynamic_trap_bar_info region on behalf of vendor driver with region len=0
> > > and region->ops=null.
> > > Vvendor driver should override this region's len, flags, rw, mmap in its
> > > vfio_pci_mediate_ops.  
> > 
> > TBH, I don't like this interface at all.  Userspace doesn't pass data
> > to the kernel via INFO ioctls.  We have a SET_IRQS ioctl for
> > configuring user signaling with eventfds.  I think we only need to
> > define an IRQ type that tells the user to re-evaluate the sparse mmap
> > information for a region.  The user would enumerate the device IRQs via
> > GET_IRQ_INFO, find one of this type where the IRQ info would also
> > indicate which region(s) should be re-evaluated on signaling.  The user
> > would enable that signaling via SET_IRQS and simply re-evaluate the  
> ok. I'll try to switch to this way. Thanks for this suggestion.
> 
> > sparse mmap capability for the associated regions when signaled.  
> 
> Do you like the "disablable" flag of sparse mmap ?
> I think it's a lightweight way for user to switch mmap state of a whole region,
> otherwise going through a complete flow of GET_REGION_INFO and re-setup
> region might be too heavy.

No, I don't like the disable-able flag.  At what frequency do we expect
regions to change?  It seems like we'd only change when switching into
and out of the _SAVING state, which is rare.  It seems easy for
userspace, at least QEMU, to drop the entire mmap configuration and
re-read it.  Another concern here is how do we synchronize the event?
Are we assuming that this event would occur when a user switch to
_SAVING mode on the device?  That operation is synchronous, the device
must be in saving mode after the write to device state completes, but
it seems like this might be trying to add an asynchronous dependency.
Will the write to device_state only complete once the user handles the
eventfd?  How would the kernel know when the mmap re-evaluation is
complete.  It seems like there are gaps here that the vendor driver
could miss traps required for migration because the user hasn't
completed the mmap transition yet.  Thanks,

Alex

