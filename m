Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4A618B7BF
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgCSNfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 09:35:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40586 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728187AbgCSNLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 09:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwfqKsawwlA7QavpNFSxuBUqzZRSHs2EJIIMOQG0ECg=;
        b=gM6HbN9IvKlzzSKy3d0MGqWwwYS0liwDCz2hv+8VYSnkhM6em0d797aOyT1I2jqm7xKd/R
        4bnyoje9YLIKBbGaUsEZ2bFwlg43W/QQiy550bmGGEH+qtYk1cdAADOMb8aenO1A6hV7eL
        f5bQxIICBo+2d+qO+eR8yADBXxcX7dI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-jZHvhMY7OgWTkqmVKPZukg-1; Thu, 19 Mar 2020 09:11:29 -0400
X-MC-Unique: jZHvhMY7OgWTkqmVKPZukg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EAD918B6383;
        Thu, 19 Mar 2020 13:11:27 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 891275C1D8;
        Thu, 19 Mar 2020 13:11:26 +0000 (UTC)
Date:   Thu, 19 Mar 2020 07:11:26 -0600
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
Subject: Re: [PATCH v3 0/7] vfio/pci: SR-IOV support
Message-ID: <20200319071126.6f5e1b78@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7DAFD5@SHSMSX104.ccr.corp.intel.com>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7DAFD5@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 06:32:25 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, March 12, 2020 5:58 AM
> > 
> > Only minor tweaks since v2, GET and SET on VFIO_DEVICE_FEATURE are
> > enforced mutually exclusive except with the PROBE option as suggested
> > by Connie, the modinfo text has been expanded for the opt-in to enable
> > SR-IOV support in the vfio-pci driver per discussion with Kevin.
> > 
> > I have not incorporated runtime warnings attempting to detect misuse
> > of SR-IOV or imposed a session lifetime of a VF token, both of which
> > were significant portions of the discussion of the v2 series.  Both of
> > these also seem to impose a usage model or make assumptions about VF
> > resource usage or configuration requirements that don't seem necessary
> > except for the sake of generating a warning or requiring an otherwise
> > unnecessary and implicit token reinitialization.  If there are new
> > thoughts around these or other discussion points, please raise them.
> > 
> > Series overview (same as provided with v1):
> > 
> > The synopsis of this series is that we have an ongoing desire to drive
> > PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
> > for this with DPDK drivers and potentially interesting future use
> > cases in virtualization.  We've been reluctant to add this support
> > previously due to the dependency and trust relationship between the
> > VF device and PF driver.  Minimally the PF driver can induce a denial
> > of service to the VF, but depending on the specific implementation,
> > the PF driver might also be responsible for moving data between VFs
> > or have direct access to the state of the VF, including data or state
> > otherwise private to the VF or VF driver.
> > 
> > To help resolve these concerns, we introduce a VF token into the VFIO
> > PCI ABI, which acts as a shared secret key between drivers.  The
> > userspace PF driver is required to set the VF token to a known value
> > and userspace VF drivers are required to provide the token to access
> > the VF device.  If a PF driver is restarted with VF drivers in use, it
> > must also provide the current token in order to prevent a rogue
> > untrusted PF driver from replacing a known driver.  The degree to
> > which this new token is considered secret is left to the userspace
> > drivers, the kernel intentionally provides no means to retrieve the
> > current token.
> > 
> > Note that the above token is only required for this new model where
> > both the PF and VF devices are usable through vfio-pci.  Existing
> > models of VFIO drivers where the PF is used without SR-IOV enabled
> > or the VF is bound to a userspace driver with an in-kernel, host PF
> > driver are unaffected.
> > 
> > The latter configuration above also highlights a new inverted scenario
> > that is now possible, a userspace PF driver with in-kernel VF drivers.
> > I believe this is a scenario that should be allowed, but should not be
> > enabled by default.  This series includes code to set a default
> > driver_override for VFs sourced from a vfio-pci user owned PF, such
> > that the VFs are also bound to vfio-pci.  This model is compatible
> > with tools like driverctl and allows the system administrator to
> > decide if other bindings should be enabled.  The VF token interface
> > above exists only between vfio-pci PF and VF drivers, once a VF is
> > bound to another driver, the administrator has effectively pronounced
> > the device as trusted.  The vfio-pci driver will note alternate
> > binding in dmesg for logging and debugging purposes.
> > 
> > Please review, comment, and test.  The example QEMU implementation
> > provided with the RFC is still current for this version.  Thanks,
> > 
> > Alex  
> 
> The whole series looks good to me:
> 	Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks!

> and confirm one understanding here, since it is not discussed anywhere. For
> VM live migration with assigned VF device, it is not necessary to migrate the
> VF token itself and actually we don't allow userspace to retrieve it. Instead,
> Qemu just follows whatever token requirement on the dest to open the new
> VF: could be same or different token as/from src, or even no token if PF
> driver runs in kernel on dest. I suppose either combination could work, correct?

That's correct.  Thanks,

Alex

> > RFC:
> > https://lore.kernel.org/lkml/158085337582.9445.17682266437583505502.stg
> > it@gimli.home/
> > v1:
> > https://lore.kernel.org/lkml/158145472604.16827.15751375540102298130.st
> > git@gimli.home/
> > v2:
> > https://lore.kernel.org/lkml/158213716959.17090.8399427017403507114.stg
> > it@gimli.home/
> > 
> > ---
> > 
> > Alex Williamson (7):
> >       vfio: Include optional device match in vfio_device_ops callbacks
> >       vfio/pci: Implement match ops
> >       vfio/pci: Introduce VF token
> >       vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
> >       vfio/pci: Add sriov_configure support
> >       vfio/pci: Remove dev_fmt definition
> >       vfio/pci: Cleanup .probe() exit paths
> > 
> > 
> >  drivers/vfio/pci/vfio_pci.c         |  390
> > +++++++++++++++++++++++++++++++++--
> >  drivers/vfio/pci/vfio_pci_private.h |   10 +
> >  drivers/vfio/vfio.c                 |   20 +-
> >  include/linux/vfio.h                |    4
> >  include/uapi/linux/vfio.h           |   37 +++
> >  5 files changed, 433 insertions(+), 28 deletions(-)  
> 

