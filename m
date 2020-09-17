Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322EA26E26C
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 19:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIQRbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 13:31:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgIQRbM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 13:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600363830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDy+vxvRfZGmnu6cg8GKuFwx7k+u4v4T4TYyDPV/nUE=;
        b=IeIgZ/2g/ePIYaLY7usR4r9Cw5GY+IfTgN7KlqSnFAjD4Rk8pD6HdXUhFSBx8Pp7NypUS3
        haL/AGG6X73HSFAoF0qZP17Q0IFgr+YJeKt8BEvrFwYrY3cnkce6eshK0Wl9XuEBlzmdVs
        pbzsSRqoDyoRrAQHEC5NzDk7FKi2jkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-vjKounHvMB-E6fZzxPGr2w-1; Thu, 17 Sep 2020 13:30:26 -0400
X-MC-Unique: vjKounHvMB-E6fZzxPGr2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92E0C8015C6;
        Thu, 17 Sep 2020 17:30:22 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5522160BEC;
        Thu, 17 Sep 2020 17:30:17 +0000 (UTC)
Date:   Thu, 17 Sep 2020 11:30:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        tglx@linutronix.de, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20200917113016.425dcde7@x1.home>
In-Reply-To: <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
        <20200917150641.GM3699@nvidia.com>
        <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 10:15:24 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 9/17/2020 8:06 AM, Jason Gunthorpe wrote:
> > On Tue, Sep 15, 2020 at 04:27:35PM -0700, Dave Jiang wrote:  
> >>   drivers/dma/idxd/idxd.h                            |   65 +
> >>   drivers/dma/idxd/init.c                            |  100 ++
> >>   drivers/dma/idxd/irq.c                             |    6
> >>   drivers/dma/idxd/mdev.c                            | 1089 ++++++++++++++++++++
> >>   drivers/dma/idxd/mdev.h                            |  118 ++  
> > 
> > It is common that drivers of a subsystem will be under that
> > subsystem's directory tree. This allows the subsystem community to
> > manage pages related to their subsystem and it's drivers.
> > 
> > Should the mdev parts be moved there?  
> 
> I personally don't have a preference. I'll defer to Alex or Kirti to provide 
> that guidance. It may make certains things like dealing with dma fault regions 
> and etc easier using vfio calls from vfio_pci_private.h later on for vSVM 
> support. It also may be the better code review and maintenance domain and 
> alleviate Vinod having to deal with that portion since it's not dmaengine domain.

TBH, I'd expect an mdev driver to be co-located with the remainder of
its parent driver.  It's hopefully sharing more code with that driver
than anything in mdev of vfio (either of which should be exported for
the vendor driver).  mdev support is largely expected to be a feature of
a driver, much like it is for i915, not necessarily its sole purpose for
existing (see the rejected fpga mdev driver).  Also being nearby
vfio_pci_private shouldn't invite anyone other than vfio_pci to make
use of that header.  Thanks,

Alex

