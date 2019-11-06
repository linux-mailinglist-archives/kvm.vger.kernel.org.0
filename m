Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF1F10ED
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbfKFIUR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 03:20:17 -0500
Received: from mga17.intel.com ([192.55.52.151]:19672 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbfKFIUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:20:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 00:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="227409276"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 06 Nov 2019 00:20:17 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 00:20:17 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 16:20:15 +0800
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
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 07/22] hw/pci: introduce pci_device_iommu_context()
Thread-Topic: [RFC v2 07/22] hw/pci: introduce pci_device_iommu_context()
Thread-Index: AQHVimss5m6QyXCJlkWMz4ReUQcoB6dxA0GAgAzdywA=
Date:   Wed, 6 Nov 2019 08:20:15 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EEFDE@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-8-git-send-email-yi.l.liu@intel.com>
 <20191029115047.GR3552@umbus.metropole.lan>
In-Reply-To: <20191029115047.GR3552@umbus.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTk1ZWVkM2EtMDc4Ni00ZTU1LWI2ZDItOTZiYmFmMzQ4Mjg5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT2c3enZpblBsazJDZ1pwNkNNTFJWeHVmYlRaY0lPTDhGSkFWK1ptNVZiNUg1QWN0SnZcL1wvUU9cL3MwQ1dzeE9BYiJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Tuesday, October 29, 2019 7:51 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 07/22] hw/pci: introduce pci_device_iommu_context()
> 
> On Thu, Oct 24, 2019 at 08:34:28AM -0400, Liu Yi L wrote:
> > This patch adds pci_device_iommu_context() to get an iommu_context for
> > a given device. A new callback is added in PCIIOMMUOps. Users who
> > wants to listen to events issued by vIOMMU could use this new
> > interface to get an iommu_context and register their own notifiers,
> > then wait for notifications from vIOMMU. e.g. VFIO is the first user
> > of it to listen to the PASID_ALLOC/PASID_BIND/CACHE_INV events and
> > propagate the events to host.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> 
> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

Thanks for the review.

Regards,
Yi Liu
