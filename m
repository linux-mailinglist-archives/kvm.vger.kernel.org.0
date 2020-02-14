Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683A315DAE5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBNP1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 10:27:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28478 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729416AbgBNP1g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 10:27:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581694055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cJ+Xk7qyaraR/uRI6tZODgQtIaX5nAojDdzg+mNT8vM=;
        b=LgeO7iHIOox8sm9rnDiVHXWI6R334IDqZ+IUUyVFLVe6L3ifB0Fi38zZKePWL8K9FiPh7i
        83FZ+vG4QinPctdgCv3/zFEyHV88m8E8qgbL7Fn9whi2Nz5Iv9f/WY4+o/ehUPix6nVguE
        LlnpOipCaXbXePSdYbyT6Hk5ZwhgjFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-bSDR5wp4PgaWC_0NihOuow-1; Fri, 14 Feb 2020 10:27:31 -0500
X-MC-Unique: bSDR5wp4PgaWC_0NihOuow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6070819251A0;
        Fri, 14 Feb 2020 15:27:29 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBEBA5C241;
        Fri, 14 Feb 2020 15:27:27 +0000 (UTC)
Date:   Fri, 14 Feb 2020 08:27:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Subject: Re: [PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200214082720.7dc33bdf@x1.home>
In-Reply-To: <22153755-598f-d25c-55a2-799c008d8d2b@ozlabs.ru>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
        <22153755-598f-d25c-55a2-799c008d8d2b@ozlabs.ru>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Feb 2020 15:57:04 +1100
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> On 12/02/2020 10:05, Alex Williamson wrote:
> > Given the mostly positive feedback from the RFC[1], here's a new
> > non-RFC revision.  Changes since RFC:
> > 
> >  - vfio_device_ops.match semantics refined
> >  - Use helpers for struct pci_dev.physfn to avoid breakage without
> >    CONFIG_PCI_IOV
> >  - Relax to allow SR-IOV configuration changes while PF is opened.
> >    There are potentially interesting use cases here, including
> >    perhaps QEMU emulating an SR-IOV capability and calling out
> >    to a privileged entity to manipulate sriov_numvfs and corral
> >    the resulting devices.
> >  - Retest vfio_device_feature.argsz to include uuid length.
> >  - Add Connie's R-b on 6/7
> > 
> > I still wish we had a solution to make it less opaque to the user
> > why a VFIO_GROUP_GET_DEVICE_FD() has failed if a VF token is
> > required, but this is still the best I've been able to come up with.
> > If there are objections or better ideas, please raise them now.
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
> > provided with the RFC[2] is still current for this version.  Thanks,  
> 
> 
> It is a cool feature. One question - what device have you tested it with?
> 
> Does not a PF want to control/manage VFs on a PF driver side? I am
> thinking of Mellanox CX5 or similar NIC and it acts as an managed
> ethernet switch which might want to do something to VFs and VFs may not
> work as expected without PF's native driver doing things to it, or this
> is not a concern, is it? Thanks,

TBH, I'm starting with the premise that a userspace PF driver already
works.  The DPDK folks have produced some "interesting" code that
allows SR-IOV to be enabled on a PF underneath vfio-pci.  There's also
a non-upstream igb-uio driver associated with DPDK that seems to be
recommended for SR-IOV PF driver use cases, particularly for an FPGA
device.  The testing I've done, and what's provided by the QEMU patch I
reference, is really only unit testing the vf_token support and
DEVICE_FEATURE ioctl provided here.  I used this with an Intel 82576
(igb) where the PF driver doesn't particularly like being assigned to a
VM with SR-IOV enabled.  Likewise, I can prove that the interfaces here
provide the correct restrictions for the VF, but the VF doesn't work in
a VM due to the state of the PF.  I'm hoping we'll have some
confirmation from the DPDK folks that this provides what they need to
abandon the non-upstream drivers and more nefarious hacks.  There's a
lot more virtualization work to be done in QEMU before I'd propose
patch I reference above upstream.

To your specific question regarding CX5, I think there are very few
SR-IOV devices where the PF doesn't act as some kind of packet router
or ring management engine.  The Amazon device listed in the pci-pf-stub
driver seems to be one of the few SR-IOV devices which claim the PF has
no special interfaces other than exposing the SR-IOV capability itself.
So I think we generally expect a device specific SR-IOV aware driver
running on the PF via this interface.  That's certainly the case for
the DPDK code for the FPGA device above.  Thanks,

Alex

