Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7476E252211
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgHYUnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 16:43:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbgHYUnk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 16:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598388218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxP4EgaB0Xz0w6dYf0l2wcvtIDiO0CRcIDu5KxI9VFs=;
        b=bamuOPJ6/ydvnZ1R8THB1Fs+/LGudd8l30WZbXEs3szQTcql+hBmPJ8wfL/KIQcDZnCzBn
        J9fZD7B4S6F55SP5Htbo3N28X7VXi/838ddrxR10sXHA0Io5JYcBuq0M2eit4CUJBHi0m8
        dks6HpeyqCJTbugbXHI9/FhPUMjHYM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-7wO29EiuOyeMIOLpHIkNRQ-1; Tue, 25 Aug 2020 16:43:34 -0400
X-MC-Unique: 7wO29EiuOyeMIOLpHIkNRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 175A71DDE0;
        Tue, 25 Aug 2020 20:43:32 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3723119C58;
        Tue, 25 Aug 2020 20:43:31 +0000 (UTC)
Date:   Tue, 25 Aug 2020 14:43:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
Message-ID: <20200825144330.70530629@x1.home>
In-Reply-To: <6917634d-0976-6f7b-6efc-a7a855686fb9@linux.ibm.com>
References: <1597333243-29483-1-git-send-email-mjrosato@linux.ibm.com>
        <1597333243-29483-2-git-send-email-mjrosato@linux.ibm.com>
        <6917634d-0976-6f7b-6efc-a7a855686fb9@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Aug 2020 10:21:24 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 8/13/20 11:40 AM, Matthew Rosato wrote:
> > s390x has the notion of providing VFs to the kernel in a manner
> > where the associated PF is inaccessible other than via firmware.
> > These are not treated as typical VFs and access to them is emulated
> > by underlying firmware which can still access the PF.  After
> > the referened commit however these detached VFs were no longer able
> > to work with vfio-pci as the firmware does not provide emulation of
> > the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> > these detached VFs so that vfio-pci can allow memory access to
> > them again. >
> > Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>  
> 
> Polite ping - If unhappy with the approach moving in this direction, I 
> have also played around with Alex's prior suggestion of a dev_flags bit 
> that denotes a device that doesn't implement PCI_COMMAND_MEMORY.  Please 
> advise.


I'm not unhappy with it, but there are quite a number of users of
is_virtfn and I wonder to what extent we can replace all of them.  For
instance if the longer term plan would be to consider is_virtfn private
then I think there are places in vfio-pci where we'd need to test
(pci_physfn(pdev) != pdev) in order to make sure we're working on the
topology we expect (see VF token handling).  If we want to consider
these detached VFs as actual VFs (minus the PF) everywhere in the code,
rather than a PF that doesn't implement random features as determined
by the bare metal hypervisor, then this might be the way to go.  The
former implies that we'd migrate away from is_virtfn to this new
interface, potentially changing the code path these devices would take
as that adoption proceeds.  Have you taken a look at other is_virtfn
use cases to see if any would be strictly undesirable for this class of
devices?  Otherwise I think Bjorn needs to weigh in since the PCI-core
change is a central aspect to this proposal.  Thanks,

Alex


> > ---
> >   arch/s390/pci/pci_bus.c            | 13 +++++++++++++
> >   drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
> >   include/linux/pci.h                |  4 ++++
> >   3 files changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
> > index 642a993..1b33076 100644
> > --- a/arch/s390/pci/pci_bus.c
> > +++ b/arch/s390/pci/pci_bus.c
> > @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
> >   }
> >   #endif
> >   
> > +void pcibios_bus_add_device(struct pci_dev *pdev)
> > +{
> > +	struct zpci_dev *zdev = to_zpci(pdev);
> > +
> > +	/*
> > +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
> > +	 * detached from its parent PF.  We rely on firmware emulation to
> > +	 * provide underlying PF details.
> > +	 */
> > +	if (zdev->vfn && !zdev->zbus->multifunction)
> > +		pdev->detached_vf = 1;
> > +}
> > +
> >   static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
> >   {
> >   	struct pci_bus *bus;
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index d98843f..98f93d1 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
> >   	 * PF SR-IOV capability, there's therefore no need to trigger
> >   	 * faults based on the virtual value.
> >   	 */
> > -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> > +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);
> >   }
> >   
> >   /*
> > @@ -420,7 +420,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
> >   	u16 cmd;
> >   	int i;
> >   
> > -	if (pdev->is_virtfn)
> > +	if (dev_is_vf(&pdev->dev))
> >   		return;
> >   
> >   	pci_info(pdev, "%s: reset recovery - restoring BARs\n", __func__);
> > @@ -521,7 +521,7 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
> >   	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
> >   
> >   	/* Mask in virtual memory enable for SR-IOV devices */
> > -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> > +	if ((offset == PCI_COMMAND) && (dev_is_vf(&vdev->pdev->dev))) {
> >   		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> >   		u32 tmp_val = le32_to_cpu(*val);
> >   
> > @@ -1713,7 +1713,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
> >   	vdev->rbar[5] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_5]);
> >   	vdev->rbar[6] = le32_to_cpu(*(__le32 *)&vconfig[PCI_ROM_ADDRESS]);
> >   
> > -	if (pdev->is_virtfn) {
> > +	if (dev_is_vf(&pdev->dev)) {
> >   		*(__le16 *)&vconfig[PCI_VENDOR_ID] = cpu_to_le16(pdev->vendor);
> >   		*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(pdev->device);
> >   
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 8355306..7c062de 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -445,6 +445,7 @@ struct pci_dev {
> >   	unsigned int	is_probed:1;		/* Device probing in progress */
> >   	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
> >   	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> > +	unsigned int	detached_vf:1;		/* VF without local PF access */
> >   	pci_dev_flags_t dev_flags;
> >   	atomic_t	enable_cnt;	/* pci_enable_device has been called */
> >   
> > @@ -1057,6 +1058,8 @@ struct resource *pci_find_parent_resource(const struct pci_dev *dev,
> >   void pci_sort_breadthfirst(void);
> >   #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
> >   #define dev_is_pf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_physfn : false))
> > +#define dev_is_vf(d) ((dev_is_pci(d) ? (to_pci_dev(d)->is_virtfn || \
> > +					to_pci_dev(d)->detached_vf) : false))
> >   
> >   /* Generic PCI functions exported to card drivers */
> >   
> > @@ -1764,6 +1767,7 @@ static inline struct pci_dev *pci_get_domain_bus_and_slot(int domain,
> >   
> >   #define dev_is_pci(d) (false)
> >   #define dev_is_pf(d) (false)
> > +#define dev_is_vf(d) (false)
> >   static inline bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
> >   { return false; }
> >   static inline int pci_irqd_intx_xlate(struct irq_domain *d,
> >   
> 

