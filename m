Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1027172706
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 06:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfGXE5K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 24 Jul 2019 00:57:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:65372 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfGXE5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 00:57:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 21:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="369176618"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2019 21:57:09 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 23 Jul 2019 21:57:09 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 21:57:08 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 21:57:08 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.55]) with mapi id 14.03.0439.000;
 Wed, 24 Jul 2019 12:57:07 +0800
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
Thread-Index: AQHVM+ylZdJ7a+KBXU2HFFh5qj+Ya6bKg4OAgAJ3NWCAALChAIAIjcJAgADufICAAiiQ4A==
Date:   Wed, 24 Jul 2019 04:57:06 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0160C9@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
 <20190715025519.GE3440@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A00D8BB@SHSMSX104.ccr.corp.intel.com>
 <20190717030640.GG9123@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A0140E0@SHSMSX104.ccr.corp.intel.com>
 <20190723035741.GR25073@umbus.fritz.box>
In-Reply-To: <20190723035741.GR25073@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzVhMzY1NDctZjIyNy00ODc4LTliNTItMmM1OTc0MDBkNjFkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRUFRQTJPMFRZSE84cytjbDRTTndudldZaXlwelwvOWFNTHg5MzQ1SjZHcWNjSGFjb3J0R2RvRkMzUzlERVJcL1hoIn0=
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
> Sent: Tuesday, July 23, 2019 11:58 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
> 
> On Mon, Jul 22, 2019 at 07:02:51AM +0000, Liu, Yi L wrote:
> > > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> > > On Behalf Of David Gibson
> > > Sent: Wednesday, July 17, 2019 11:07 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free
> > > implementation
> > >
> > > On Tue, Jul 16, 2019 at 10:25:55AM +0000, Liu, Yi L wrote:
> > > > > From: kvm-owner@vger.kernel.org
> > > > > [mailto:kvm-owner@vger.kernel.org] On
> > > Behalf
> > > > > Of David Gibson
> > > > > Sent: Monday, July 15, 2019 10:55 AM
> > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free
> > > > > implementation
> > > > >
> > > > > On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> > > > > > This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
> > > > > > These two functions are used to propagate guest pasid
> > > > > > allocation and free requests to host via vfio container ioctl.
> > > > >
> > > > > As I said in an earlier comment, I think doing this on the
> > > > > device is conceptually incorrect.  I think we need an explcit
> > > > > notion of an SVM context (i.e. the namespace in which all the
> > > > > PASIDs live) - which will IIUC usually be shared amongst
> > > > > multiple devices.  The create and free PASID requests should be on that object.
> > > >
> > > > Actually, the allocation is not doing on this device. System wide,
> > > > it is done on a container. So not sure if it is the API interface
> > > > gives you a sense that this is done on device.
> > >
> > > Sorry, I should have been clearer.  I can see that at the VFIO level
> > > it is done on the container.  However the function here takes a bus
> > > and devfn, so this qemu internal interface is per-device, which
> > > doesn't really make sense.
> >
> > Got it. The reason here is to pass the bus and devfn info, so that
> > VFIO can figure out a container for the operation. So far in QEMU,
> > there is no good way to connect the vIOMMU emulator and VFIO regards
> > to SVM.
> 
> Right, and I think that's an indication that we're not modelling something in qemu
> that we should be.
> 
> > hw/pci layer is a choice based on some previous discussion. But yes, I
> > agree with you that we may need to have an explicit notion for SVM. Do
> > you think it is good to introduce a new abstract layer for SVM (may
> > name as SVMContext).
> 
> I think so, yes.
> 
> If nothing else, I expect we'll need this concept if we ever want to be able to
> implement SVM for emulated devices (which could be useful for debugging, even if
> it's not something you'd do in production).
> 
> > The idea would be that vIOMMU maintain the SVMContext instances and
> > expose explicit interface for VFIO to get it. Then VFIO register
> > notifiers on to the SVMContext. When vIOMMU emulator wants to do PASID
> > alloc/free, it fires the corresponding notifier. After call into VFIO,
> > the notifier function itself figure out the container it is bound. In
> > this way, it's the duty of vIOMMU emulator to figure out a proper
> > notifier to fire. From interface point of view, it is no longer
> > per-device.
> 
> Exactly.

Cool, let me prepare another version with the ideas. Thanks for your
review. :-)

Regards,
Yi Liu

> > Also, it leaves the PASID management details to vIOMMU emulator as it
> > can be vendor specific. Does it make sense?
> > Also, I'd like to know if you have any other idea on it. That would
> > surely be helpful. :-)
> >
> > > > Also, curious on the SVM context
> > > > concept, do you mean it a per-VM context or a per-SVM usage context?
> > > > May you elaborate a little more. :-)
> > >
> > > Sorry, I'm struggling to find a good term for this.  By "context" I
> > > mean a namespace containing a bunch of PASID address spaces, those
> > > PASIDs are then visible to some group of devices.
> >
> > I see. May be the SVMContext instance above can include multiple PASID
> > address spaces. And again, I think this relationship should be
> > maintained in vIOMMU emulator.

