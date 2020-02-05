Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273DE153286
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBEOLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:11:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726748AbgBEOLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:11:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580911864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4/IAIkLz0D/Z/IjxmMi8dEqQry7xSlVGHBtHnUX7vg=;
        b=Z1WcrUakHCqJ+6Xe7XtsyRXOwm/JSLTyS7nmmeExkpk3SoTpAdpyy340czNHSNtGMGHG1W
        6IN6Y81+eEu230c0RB2Q2ubKgNB3M6VH1IJxjkgNIJmGjt7mO7a1YpfwjFLC3f6phjJCLY
        6TsKMcwg7+xeYKF0grZYuyZhFlPiyVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-ugnoM9xKOA6feBUjQwI-mQ-1; Wed, 05 Feb 2020 09:11:00 -0500
X-MC-Unique: ugnoM9xKOA6feBUjQwI-mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AFB41336563;
        Wed,  5 Feb 2020 14:10:58 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E01660C05;
        Wed,  5 Feb 2020 14:10:57 +0000 (UTC)
Date:   Wed, 5 Feb 2020 07:10:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200205071056.101ad3f2@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1ABFE0@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <A2975661238FB949B60364EF0F2C25743A1ABFE0@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 07:57:21 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> Silly questions on the background:
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, February 5, 2020 7:06 AM
> > Subject: [RFC PATCH 0/7] vfio/pci: SR-IOV support
> > 
> > There seems to be an ongoing desire to use userspace, vfio-based
> > drivers for both SR-IOV PF and VF devices.   
> 
> Is this series to make PF be bound-able to vfio-pci even SR-IOV is
> enabled on such PFs? If yes, is it allowed to assign PF to a VM? or
> it can only be used by userspace applications like DPDK?

No, this series does not change the behavior of vfio-pci with respect
to probing a PF where VFs are already enabled.  This is still
disallowed.  I haven't seen a use case that requires this and allowing
it tends to subvert the restrictions here.  For instance, if an
existing VF is already in use by a vfio-pci driver, the PF can
transition from a trusted host driver to an unknown userspace driver.

> > The fundamental issue
> > with this concept is that the VF is not fully independent of the PF
> > driver.  Minimally the PF driver might be able to deny service to the
> > VF, VF data paths might be dependent on the state of the PF device,
> > or the PF my have some degree of ability to inspect or manipulate the
> > VF data.  It therefore would seem irresponsible to unleash VFs onto
> > the system, managed by a user owned PF.
> > 
> > We address this in a few ways in this series.  First, we can use a bus
> > notifier and the driver_override facility to make sure VFs are bound
> > to the vfio-pci driver by default.  This should eliminate the chance
> > that a VF is accidentally bound and used by host drivers.  We don't
> > however remove the ability for a host admin to change this override.
> > 
> > The next issue we need to address is how we let userspace drivers
> > opt-in to this participation with the PF driver.  We do not want an
> > admin to be able to unwittingly assign one of these VFs to a tenant
> > that isn't working in collaboration with the PF driver.  We could use
> > IOMMU grouping, but this seems to push too far towards tightly coupled
> > PF and VF drivers.  This series introduces a "VF token", implemented
> > as a UUID, as a shared secret between PF and VF drivers.  The token
> > needs to be set by the PF driver and used as part of the device
> > matching by the VF driver.  Provisions in the code also account for
> > restarting the PF driver with active VF drivers, requiring the PF to
> > use the current token to re-gain access to the PF.  
> 
> How about the scenario in which PF driver is vfio-based userspace
> driver but VF drivers are mixed. This means not all VFs are bound
> to vfio-based userspace driver. Is it also supported here? :-)

It's allowed.  Userspace VF drivers will need to participate in the VF
token scheme, host drivers may be bound to VFs normally after removing
the default driver_override.  Thanks,

Alex

