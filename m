Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A704F10E2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfKFISO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 03:18:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:61461 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbfKFISO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:18:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 00:18:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="402272507"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 00:18:13 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 00:18:13 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 16:18:11 +0800
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
Subject: RE: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Thread-Topic: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Thread-Index: AQHVimsrLg5zO45FAU+j+AEc4se2MKduQTGAgA+fOwA=
Date:   Wed, 6 Nov 2019 08:18:11 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EEFC2@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
 <20191027174341.GL3552@umbus.metropole.lan>
In-Reply-To: <20191027174341.GL3552@umbus.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWE1ZjVhMmEtYjdhNi00NGNiLWExNzAtNWE3NDZmNmJjOGNiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQnhCdG1yTEEyank3XC9OdHpUM1lCbUN6UGkyd09BU3NCYmJ1U0Y1UmRjN2F3RUpqd3VYK0ZveU9Ha1phRWMrRHcifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Monday, October 28, 2019 1:44 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
> 
> On Thu, Oct 24, 2019 at 08:34:27AM -0400, Liu Yi L wrote:
> > This patch modifies pci_setup_iommu() to set PCIIOMMUOps instead of
> > only setting PCIIOMMUFunc. PCIIOMMUFunc is previously used to get an
> > address space for a device in vendor specific way. The PCIIOMMUOps
> > still offers this functionality. Use PCIIOMMUOps leaves space to add
> > more iommu related vendor specific operations.
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
