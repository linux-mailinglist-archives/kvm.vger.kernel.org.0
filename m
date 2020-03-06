Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD8D17C232
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCFPuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 10:50:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgCFPuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 10:50:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583509812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMxkSL6yFboV4hL3iA1r2NbH/sCtc48z1ZRDDZkcdNY=;
        b=NTal1r4MQqm90vFtnjUtIcki1g2cYiYLkc/D5uXTlqGgkuni/BnhDd4AjVn2Z2JLqJ2sFF
        RQtstMx/Iswz2HnfFObOb3ppE97nTA1JI+94u5RipBU66HS4bWNTIpU6BnP0GLzcjeCBC3
        LsIzs5fM8uE0B4o7cMMcHZ60uq/vnkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ijdBUH5eNBCXAmmXHiihLw-1; Fri, 06 Mar 2020 10:50:10 -0500
X-MC-Unique: ijdBUH5eNBCXAmmXHiihLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 168C91923184;
        Fri,  6 Mar 2020 15:50:09 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81C0473892;
        Fri,  6 Mar 2020 15:50:06 +0000 (UTC)
Date:   Fri, 6 Mar 2020 08:50:05 -0700
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
Message-ID: <20200306085005.465a0201@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7C0A43@SHSMSX104.ccr.corp.intel.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <158213846731.17090.37693075723046377.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A943@SHSMSX104.ccr.corp.intel.com>
        <20200305112230.0dd77712@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C0A43@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Mar 2020 09:45:40 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Tian, Kevin
> > Sent: Friday, March 6, 2020 3:57 PM
> >   
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, March 6, 2020 2:23 AM
> > >
> > > On Tue, 25 Feb 2020 03:08:00 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >  
> > > > > From: Alex Williamson
> > > > > Sent: Thursday, February 20, 2020 2:54 AM
> > > > >
> > > > > With the VF Token interface we can now expect that a vfio userspace
> > > > > driver must be in collaboration with the PF driver, an unwitting
> > > > > userspace driver will not be able to get past the GET_DEVICE_FD step
> > > > > in accessing the device.  We can now move on to actually allowing
> > > > > SR-IOV to be enabled by vfio-pci on the PF.  Support for this is not
> > > > > enabled by default in this commit, but it does provide a module option
> > > > > for this to be enabled (enable_sriov=1).  Enabling VFs is rather
> > > > > straightforward, except we don't want to risk that a VF might get
> > > > > autoprobed and bound to other drivers, so a bus notifier is used to
> > > > > "capture" VFs to vfio-pci using the driver_override support.  We
> > > > > assume any later action to bind the device to other drivers is
> > > > > condoned by the system admin and allow it with a log warning.
> > > > >
> > > > > vfio-pci will disable SR-IOV on a PF before releasing the device,
> > > > > allowing a VF driver to be assured other drivers cannot take over the
> > > > > PF and that any other userspace driver must know the shared VF token.
> > > > > This support also does not provide a mechanism for the PF userspace
> > > > > driver itself to manipulate SR-IOV through the vfio API.  With this
> > > > > patch SR-IOV can only be enabled via the host sysfs interface and the
> > > > > PF driver user cannot create or remove VFs.  
> > > >
> > > > I'm not sure how many devices can be properly configured simply
> > > > with pci_enable_sriov. It is not unusual to require PF driver prepare
> > > > something before turning PCI SR-IOV capability. If you look kernel
> > > > PF drivers, there are only two using generic pci_sriov_configure_
> > > > simple (simple wrapper like pci_enable_sriov), while most others
> > > > implementing their own callback. However vfio itself has no idea
> > > > thus I'm not sure how an user knows whether using this option can
> > > > actually meet his purpose. I may miss something here, possibly
> > > > using DPDK as an example will make it clearer.  
> > >
> > > There is still the entire vfio userspace driver interface.  Imagine for
> > > example that QEMU emulates the SR-IOV capability and makes a call out
> > > to libvirt (or maybe runs with privs for the PF SR-IOV sysfs attribs)
> > > when the guest enables SR-IOV.  Can't we assume that any PF specific
> > > support can still be performed in the userspace/guest driver, leaving
> > > us with a very simple and generic sriov_configure callback in vfio-pci?  
> > 
> > Makes sense. One concern, though, is how an user could be warned
> > if he inadvertently uses sysfs to enable SR-IOV on a vfio device whose
> > userspace driver is incapable of handling it. Note any VFIO device,
> > if SR-IOV capable, will allow user to do so once the module option is
> > turned on and the callback is registered. I felt such uncertainty can be
> > contained by toggling SR-IOV through a vfio api, but from your description
> > obviously it is what you want to avoid. Is it due to the sequence reason,
> > e.g. that SR-IOV must be enabled before userspace PF driver sets the
> > token?
> >   
> 
> reading again I found that you specifically mentioned "the PF driver user 
> cannot create or remove VFs.". However I failed to get the rationale 
> behind. If the VF drivers have built the trust with the PF driver through
> the token, what is the problem of allowing the PF driver to further manage 
> SR-IOV itself? suppose any VF removal will be done in a cooperate way
> to avoid surprise impact to related VF drivers. then possibly a new vfio
> ioctl for setting the VF numbers plus a token from the userspace driver
> could also serve the purpose of this patch series (GET_DEVICE_FD + sysfs)?

If a user is allowed to create VFs, does that user automatically get
ownership of those devices?  How is that accomplished?  What if we want
to make use of the VF via a separate process?  How do we coordinate
that with the PF driver?  All of these problems are resolved if we
assume the userspace PF driver needs to operate in collaboration with a
privileged entity to interact with sysfs to configure SR-IOV and manage
the resulting VFs.  I have no desire to take on that responsibility
within vfio-pci and I also feel that a user owning a PF device should
not inherently grant that user the ability to create and remove other
devices on the host, even if they are sourced from the PF.  Thanks,

Alex

