Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B24A17C83A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 23:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCFWRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 17:17:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgCFWRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 17:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583533059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhLjWZmMblh8piGopc216qqrZDQpLjpYk5IINjE+qLM=;
        b=ZNSH4bAOWEnz3E7+/IAQMobxDmV5Le5yDsz3WKuClzbLpHZwGMrVcHdJDj+jHDK5SUH8O2
        /Z8pobKgxQ7lIniKmCqfUckSXq/UECWAqQl1BiucBe+l7snFz+exPSQOOycQVQZCwWtBo+
        FNd7Gs4oEC2QCR/a90qNNXn7EAbGWyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-sFjXm69vOXGmT09efohuUQ-1; Fri, 06 Mar 2020 17:17:37 -0500
X-MC-Unique: sFjXm69vOXGmT09efohuUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC9F41005509;
        Fri,  6 Mar 2020 22:17:35 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00CD95C1B5;
        Fri,  6 Mar 2020 22:17:34 +0000 (UTC)
Date:   Fri, 6 Mar 2020 15:17:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
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
Subject: Re: [PATCH v2 5/7] vfio/pci: Add sriov_configure support
Message-ID: <20200306151734.741d1d58@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7C07A0@SHSMSX104.ccr.corp.intel.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <158213846731.17090.37693075723046377.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A943@SHSMSX104.ccr.corp.intel.com>
        <20200305112230.0dd77712@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C07A0@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Mar 2020 07:57:19 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, March 6, 2020 2:23 AM
> > 
> > On Tue, 25 Feb 2020 03:08:00 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson
> > > > Sent: Thursday, February 20, 2020 2:54 AM
> > > >
> > > > With the VF Token interface we can now expect that a vfio userspace
> > > > driver must be in collaboration with the PF driver, an unwitting
> > > > userspace driver will not be able to get past the GET_DEVICE_FD step
> > > > in accessing the device.  We can now move on to actually allowing
> > > > SR-IOV to be enabled by vfio-pci on the PF.  Support for this is not
> > > > enabled by default in this commit, but it does provide a module option
> > > > for this to be enabled (enable_sriov=1).  Enabling VFs is rather
> > > > straightforward, except we don't want to risk that a VF might get
> > > > autoprobed and bound to other drivers, so a bus notifier is used to
> > > > "capture" VFs to vfio-pci using the driver_override support.  We
> > > > assume any later action to bind the device to other drivers is
> > > > condoned by the system admin and allow it with a log warning.
> > > >
> > > > vfio-pci will disable SR-IOV on a PF before releasing the device,
> > > > allowing a VF driver to be assured other drivers cannot take over the
> > > > PF and that any other userspace driver must know the shared VF token.
> > > > This support also does not provide a mechanism for the PF userspace
> > > > driver itself to manipulate SR-IOV through the vfio API.  With this
> > > > patch SR-IOV can only be enabled via the host sysfs interface and the
> > > > PF driver user cannot create or remove VFs.  
> > >
> > > I'm not sure how many devices can be properly configured simply
> > > with pci_enable_sriov. It is not unusual to require PF driver prepare
> > > something before turning PCI SR-IOV capability. If you look kernel
> > > PF drivers, there are only two using generic pci_sriov_configure_
> > > simple (simple wrapper like pci_enable_sriov), while most others
> > > implementing their own callback. However vfio itself has no idea
> > > thus I'm not sure how an user knows whether using this option can
> > > actually meet his purpose. I may miss something here, possibly
> > > using DPDK as an example will make it clearer.  
> > 
> > There is still the entire vfio userspace driver interface.  Imagine for
> > example that QEMU emulates the SR-IOV capability and makes a call out
> > to libvirt (or maybe runs with privs for the PF SR-IOV sysfs attribs)
> > when the guest enables SR-IOV.  Can't we assume that any PF specific
> > support can still be performed in the userspace/guest driver, leaving
> > us with a very simple and generic sriov_configure callback in vfio-pci?  
> 
> Makes sense. One concern, though, is how an user could be warned
> if he inadvertently uses sysfs to enable SR-IOV on a vfio device whose
> userspace driver is incapable of handling it. Note any VFIO device, 
> if SR-IOV capable, will allow user to do so once the module option is 
> turned on and the callback is registered. I felt such uncertainty can be 
> contained by toggling SR-IOV through a vfio api, but from your description 
> obviously it is what you want to avoid. Is it due to the sequence reason,
> e.g. that SR-IOV must be enabled before userspace PF driver sets the 
> token? 

As in my other reply, enabling SR-IOV via a vfio API suggests that
we're not only granting the user owning the PF device access to the
device itself, but also the ability to create and remove subordinate
devices on the host.  That implies an extended degree of trust in the
user beyond the PF device itself and raises questions about whether a
user who is allowed to create VF devices should automatically be
granted access to those VF devices, what the mechanism would be for
that, and how we might re-assign those devices to other users,
potentially including host kernel usage.  What I'm proposing here
doesn't preclude some future extension in that direction, but instead
tries to simplify a first step towards enabling SR-IOV by leaving the
SR-IOV enablement and VF assignment in the realm of a privileged system
entity.

So, what I think you're suggesting here is that we should restrict
vfio_pci_sriov_configure() to reject enabling SR-IOV until a user
driver has configured a VF token.  That requires both that the
userspace driver has initialized to this point before SR-IOV can be
enabled and that we would be forced to define a termination point for
the user set VF token.  Logically, this would need to be when the
userspace driver exits or closes the PF device, which implies that we
need to disable SR-IOV on the PF at this point, or we're left in an
inconsistent state where VFs are enabled but cannot be disabled because
we don't have a valid VF token.  Now we're back to nearly a state where
the user has control of not creating devices on the host, but removing
them by closing the device, which will necessarily require that any VF
driver release the device, whether userspace or kernel.

I'm not sure what we're gaining by doing this though.  I agree that
there will be users that enable SR-IOV on a PF and then try to, for
example, assign the PF and all the VFs to a VM.  The VFs will fail due
to lacking VF token support, unless they've patch QEMU with my test
code, but depending on the PF driver in the guest, it may, or more
likely won't work.  But don't you think the VFs and probably PF not
working is a sufficient clue that the configuration is invalid?  OTOH,
from what I've heard of the device in the ID table of the pci-pf-stub
driver, they might very well be able to work with both PF and VFs in
QEMU using only my test code to set the VF token.

Therefore, I'm afraid what you're asking for here is to impose a usage
restriction as a sanity test, when we don't really know what might be
sane for this particular piece of hardware or use case.  There are
infinite ways that a vfio based userspace driver can fail to configure
their hardware and make it work correctly, many of them are device
specific.  Isn't this just one of those cases?  Thanks,

Alex

