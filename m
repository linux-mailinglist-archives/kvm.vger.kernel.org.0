Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26276A670
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 12:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbfGPK0B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Jul 2019 06:26:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:5417 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732257AbfGPK0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 03:26:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="194841602"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 03:26:00 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jul 2019 03:26:00 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 16 Jul 2019 03:25:57 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 16 Jul 2019 03:25:56 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.3]) with mapi id 14.03.0439.000;
 Tue, 16 Jul 2019 18:25:55 +0800
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
Thread-Index: AQHVM+ylZdJ7a+KBXU2HFFh5qj+Ya6bKg4OAgAJ3NWA=
Date:   Tue, 16 Jul 2019 10:25:55 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A00D8BB@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
 <20190715025519.GE3440@umbus.fritz.box>
In-Reply-To: <20190715025519.GE3440@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjY5YTdiNTgtOGIxMi00ZmRlLWFiNDktYTNmZWZkOTAwYWFiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZ21mRWlwNUcxbVFkSXlkczZmdjRnMlRKZlhTSCtqcGRna3hsaVdiQTgydVhkRk9pMFpxSUJLdElGXC83ZjBFMkgifQ==
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
> Sent: Monday, July 15, 2019 10:55 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
> 
> On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> > This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
> > These two functions are used to propagate guest pasid allocation and
> > free requests to host via vfio container ioctl.
> 
> As I said in an earlier comment, I think doing this on the device is
> conceptually incorrect.  I think we need an explcit notion of an SVM
> context (i.e. the namespace in which all the PASIDs live) - which will
> IIUC usually be shared amongst multiple devices.  The create and free
> PASID requests should be on that object.

Actually, the allocation is not doing on this device. System wide, it is
done on a container. So not sure if it is the API interface gives you a
sense that this is done on device. Also, curious on the SVM context
concept, do you mean it a per-VM context or a per-SVM usage context?
May you elaborate a little more. :-)

Thanks,
Yi Liu

> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > ---
> >  hw/vfio/pci.c | 61
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index ce3fe96..ab184ad 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -2690,6 +2690,65 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice
> *vdev)
> >      vdev->req_enabled = false;
> >  }
> >
> > +static int vfio_pci_device_request_pasid_alloc(PCIBus *bus,
> > +                                               int32_t devfn,
> > +                                               uint32_t min_pasid,
> > +                                               uint32_t max_pasid)
> > +{
> > +    PCIDevice *pdev = bus->devices[devfn];
> > +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> > +    VFIOContainer *container = vdev->vbasedev.group->container;
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> > +    int pasid;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flag = VFIO_IOMMU_PASID_ALLOC;
> > +    req.min_pasid = min_pasid;
> > +    req.max_pasid = max_pasid;
> > +
> > +    rcu_read_lock();
> > +    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > +    if (pasid < 0) {
> > +        error_report("vfio_pci_device_request_pasid_alloc:"
> > +                     " request failed, contanier: %p", container);
> > +    }
> > +    rcu_read_unlock();
> > +    return pasid;
> > +}
> > +
> > +static int vfio_pci_device_request_pasid_free(PCIBus *bus,
> > +                                              int32_t devfn,
> > +                                              uint32_t pasid)
> > +{
> > +    PCIDevice *pdev = bus->devices[devfn];
> > +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> > +    VFIOContainer *container = vdev->vbasedev.group->container;
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> > +    int ret = 0;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flag = VFIO_IOMMU_PASID_FREE;
> > +    req.pasid = pasid;
> > +
> > +    rcu_read_lock();
> > +    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > +    if (ret != 0) {
> > +        error_report("vfio_pci_device_request_pasid_free:"
> > +                     " request failed, contanier: %p", container);
> > +    }
> > +    rcu_read_unlock();
> > +    return ret;
> > +}
> > +
> > +static PCIPASIDOps vfio_pci_pasid_ops = {
> > +    .alloc_pasid = vfio_pci_device_request_pasid_alloc,
> > +    .free_pasid = vfio_pci_device_request_pasid_free,
> > +};
> > +
> >  static void vfio_realize(PCIDevice *pdev, Error **errp)
> >  {
> >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> > @@ -2991,6 +3050,8 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> >      vfio_register_req_notifier(vdev);
> >      vfio_setup_resetfn_quirk(vdev);
> >
> > +    pci_setup_pasid_ops(pdev, &vfio_pci_pasid_ops);
> > +
> >      return;
> >
> >  out_teardown:
> 
> --
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson
