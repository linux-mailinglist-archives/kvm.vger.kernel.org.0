Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14926F9DE
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 09:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfGVHCz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 22 Jul 2019 03:02:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:15435 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfGVHCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 03:02:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jul 2019 00:02:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,294,1559545200"; 
   d="scan'208";a="180310555"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 22 Jul 2019 00:02:53 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jul 2019 00:02:53 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jul 2019 00:02:53 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.162]) with mapi id 14.03.0439.000;
 Mon, 22 Jul 2019 15:02:51 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Thread-Topic: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Thread-Index: AQHVM+ylZdJ7a+KBXU2HFFh5qj+Ya6bKg4OAgAJ3NWCAALChAIAIjcJA
Date:   Mon, 22 Jul 2019 07:02:51 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0140E0@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
 <20190715025519.GE3440@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A00D8BB@SHSMSX104.ccr.corp.intel.com>
 <20190717030640.GG9123@umbus.fritz.box>
In-Reply-To: <20190717030640.GG9123@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTIyNTIwM2UtYzAxNy00MjgzLWI0ZGItMWRlZmRmMTEwZmRjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQ0ZrQXpOY0R3R1VTNkdGaFlVemE2TVFUeGhXKzVWT1g3dkdYaHRiZXVXNWNXRXJpTzlOMkFpWlE4alkwNUhuSCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
> Of David Gibson
> Sent: Wednesday, July 17, 2019 11:07 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
> 
> On Tue, Jul 16, 2019 at 10:25:55AM +0000, Liu, Yi L wrote:
> > > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf
> > > Of David Gibson
> > > Sent: Monday, July 15, 2019 10:55 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
> > >
> > > On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> > > > This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
> > > > These two functions are used to propagate guest pasid allocation and
> > > > free requests to host via vfio container ioctl.
> > >
> > > As I said in an earlier comment, I think doing this on the device is
> > > conceptually incorrect.  I think we need an explcit notion of an SVM
> > > context (i.e. the namespace in which all the PASIDs live) - which will
> > > IIUC usually be shared amongst multiple devices.  The create and free
> > > PASID requests should be on that object.
> >
> > Actually, the allocation is not doing on this device. System wide, it is
> > done on a container. So not sure if it is the API interface gives you a
> > sense that this is done on device.
> 
> Sorry, I should have been clearer.  I can see that at the VFIO level
> it is done on the container.  However the function here takes a bus
> and devfn, so this qemu internal interface is per-device, which
> doesn't really make sense.

Got it. The reason here is to pass the bus and devfn info, so that VFIO
can figure out a container for the operation. So far in QEMU, there is
no good way to connect the vIOMMU emulator and VFIO regards to
SVM. hw/pci layer is a choice based on some previous discussion. But
yes, I agree with you that we may need to have an explicit notion for
SVM. Do you think it is good to introduce a new abstract layer for SVM
(may name as SVMContext). The idea would be that vIOMMU maintain
the SVMContext instances and expose explicit interface for VFIO to get
it. Then VFIO register notifiers on to the SVMContext. When vIOMMU
emulator wants to do PASID alloc/free, it fires the corresponding
notifier. After call into VFIO, the notifier function itself figure out the
container it is bound. In this way, it's the duty of vIOMMU emulator to
figure out a proper notifier to fire. From interface point of view, it is no
longer per-device. Also, it leaves the PASID management details to
vIOMMU emulator as it can be vendor specific. Does it make sense?
Also, I'd like to know if you have any other idea on it. That would
surely be helpful. :-)

> > Also, curious on the SVM context
> > concept, do you mean it a per-VM context or a per-SVM usage context?
> > May you elaborate a little more. :-)
> 
> Sorry, I'm struggling to find a good term for this.  By "context" I
> mean a namespace containing a bunch of PASID address spaces, those
> PASIDs are then visible to some group of devices.

I see. May be the SVMContext instance above can include multiple PASID
address spaces. And again, I think this relationship should be maintained
in vIOMMU emulator.

Thanks,
Yi Liu

> 
> >
> > Thanks,
> > Yi Liu
> >
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > > ---
> > > >  hw/vfio/pci.c | 61
> > > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 61 insertions(+)
> > > >
> > > > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > > > index ce3fe96..ab184ad 100644
> > > > --- a/hw/vfio/pci.c
> > > > +++ b/hw/vfio/pci.c
> > > > @@ -2690,6 +2690,65 @@ static void
> vfio_unregister_req_notifier(VFIOPCIDevice
> > > *vdev)
> > > >      vdev->req_enabled = false;
> > > >  }
> > > >
> > > > +static int vfio_pci_device_request_pasid_alloc(PCIBus *bus,
> > > > +                                               int32_t devfn,
> > > > +                                               uint32_t min_pasid,
> > > > +                                               uint32_t max_pasid)
> > > > +{
> > > > +    PCIDevice *pdev = bus->devices[devfn];
> > > > +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> > > > +    VFIOContainer *container = vdev->vbasedev.group->container;
> > > > +    struct vfio_iommu_type1_pasid_request req;
> > > > +    unsigned long argsz;
> > > > +    int pasid;
> > > > +
> > > > +    argsz = sizeof(req);
> > > > +    req.argsz = argsz;
> > > > +    req.flag = VFIO_IOMMU_PASID_ALLOC;
> > > > +    req.min_pasid = min_pasid;
> > > > +    req.max_pasid = max_pasid;
> > > > +
> > > > +    rcu_read_lock();
> > > > +    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > > > +    if (pasid < 0) {
> > > > +        error_report("vfio_pci_device_request_pasid_alloc:"
> > > > +                     " request failed, contanier: %p", container);
> > > > +    }
> > > > +    rcu_read_unlock();
> > > > +    return pasid;
> > > > +}
> > > > +
> > > > +static int vfio_pci_device_request_pasid_free(PCIBus *bus,
> > > > +                                              int32_t devfn,
> > > > +                                              uint32_t pasid)
> > > > +{
> > > > +    PCIDevice *pdev = bus->devices[devfn];
> > > > +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> > > > +    VFIOContainer *container = vdev->vbasedev.group->container;
> > > > +    struct vfio_iommu_type1_pasid_request req;
> > > > +    unsigned long argsz;
> > > > +    int ret = 0;
> > > > +
> > > > +    argsz = sizeof(req);
> > > > +    req.argsz = argsz;
> > > > +    req.flag = VFIO_IOMMU_PASID_FREE;
> > > > +    req.pasid = pasid;
> > > > +
> > > > +    rcu_read_lock();
> > > > +    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > > > +    if (ret != 0) {
> > > > +        error_report("vfio_pci_device_request_pasid_free:"
> > > > +                     " request failed, contanier: %p", container);
> > > > +    }
> > > > +    rcu_read_unlock();
> > > > +    return ret;
> > > > +}
> > > > +
> > > > +static PCIPASIDOps vfio_pci_pasid_ops = {
> > > > +    .alloc_pasid = vfio_pci_device_request_pasid_alloc,
> > > > +    .free_pasid = vfio_pci_device_request_pasid_free,
> > > > +};
> > > > +
> > > >  static void vfio_realize(PCIDevice *pdev, Error **errp)
> > > >  {
> > > >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> > > > @@ -2991,6 +3050,8 @@ static void vfio_realize(PCIDevice *pdev, Error
> **errp)
> > > >      vfio_register_req_notifier(vdev);
> > > >      vfio_setup_resetfn_quirk(vdev);
> > > >
> > > > +    pci_setup_pasid_ops(pdev, &vfio_pci_pasid_ops);
> > > > +
> > > >      return;
> > > >
> > > >  out_teardown:
> > >
> >
> 
> --
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson
