Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D7C1ED8EB
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgFCXE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:04:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725876AbgFCXE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 19:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591225497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2487rGs+TC6tntrEqOtDUOH3rYGvUESRfM9RkW9d4E=;
        b=KhCxPfmiLMwyUvAqnbvku6POO1q8qac54ZpK7Dx1XvwWZ2ccjItHStzuoERzG9GRVBhPY2
        me49NBdgcYlwxcTLSo4/rSu1/V9JxEpbThu9/TAWW5WDqS7g58uFKpTrBDqoWSWT4U5bDk
        HJMWDYs2Hsmj+/O2cV5jUyZPHP/u7es=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-GFLXoTvkOEe6eS8rzLIuTA-1; Wed, 03 Jun 2020 19:04:55 -0400
X-MC-Unique: GFLXoTvkOEe6eS8rzLIuTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34090800685;
        Wed,  3 Jun 2020 23:04:54 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56C657B5E1;
        Wed,  3 Jun 2020 23:04:53 +0000 (UTC)
Date:   Wed, 3 Jun 2020 17:04:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200603170452.7f172baf@x1.home>
In-Reply-To: <20200603014058.GA12300@joy-OptiPlex-7040>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518025245.14425-1-yan.y.zhao@intel.com>
        <20200529154547.19a6685f@x1.home>
        <20200601065726.GA5906@joy-OptiPlex-7040>
        <20200601104307.259b0fe1@x1.home>
        <20200602082858.GA8915@joy-OptiPlex-7040>
        <20200602133435.1ab650c5@x1.home>
        <20200603014058.GA12300@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jun 2020 21:40:58 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:
> > I'm not at all happy with this.  Why do we need to hide the migration
> > sparse mmap from the user until migration time?  What if instead we
> > introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> > where the existing capability is the normal runtime sparse setup and
> > the user is required to use this new one prior to enabled device_state
> > with _SAVING.  The vendor driver could then simply track mmap vmas to
> > the region and refuse to change device_state if there are outstanding
> > mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> > required, no new irqfds, an incremental change to the protocol,
> > backwards compatible to the extent that a vendor driver requiring this
> > will automatically fail migration.
> >   
> right. looks we need to use this approach to solve the problem.
> thanks for your guide.
> so I'll abandon the current remap irq way for dirty tracking during live
> migration.
> but anyway, it demos how to customize irq_types in vendor drivers.
> then, what do you think about patches 1-5?

In broad strokes, I don't think we've found the right solution yet.  I
really question whether it's supportable to parcel out vfio-pci like
this and I don't know how I'd support unraveling whether we have a bug
in vfio-pci, the vendor driver, or how the vendor driver is making use
of vfio-pci.

Let me also ask, why does any of this need to be in the kernel?  We
spend 5 patches slicing up vfio-pci so that we can register a vendor
driver and have that vendor driver call into vfio-pci as it sees fit.
We have two patches creating device specific interrupts and a BAR
remapping scheme that we've decided we don't need.  That brings us to
the actual i40e vendor driver, where the first patch is simply making
the vendor driver work like vfio-pci already does, the second patch is
handling the migration region, and the third patch is implementing the
BAR remapping IRQ that we decided we don't need.  It's difficult to
actually find the small bit of code that's required to support
migration outside of just dealing with the protocol we've defined to
expose this from the kernel.  So why are we trying to do this in the
kernel?  We have quirk support in QEMU, we can easily flip
MemoryRegions on and off, etc.  What access to the device outside of
what vfio-pci provides to the user, and therefore QEMU, is necessary to
implement this migration support for i40e VFs?  Is this just an
exercise in making use of the migration interface?  Thanks,

Alex

