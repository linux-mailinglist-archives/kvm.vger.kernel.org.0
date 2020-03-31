Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648AD198C60
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgCaGfP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 02:35:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:35205 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgCaGfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 02:35:15 -0400
IronPort-SDR: 43Dbim0nfVNzlGvkm8twjwPeJik4zzRZRzJMH6wHq2428B7uVRgq1+DD2RHNlRKBARwRNGIIQ5
 ABOpm4+520Bw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 23:35:14 -0700
IronPort-SDR: mU6pStwPFYGu0M94JQjxJM+3SvfamtjAOlCPQ1DezUR97gQuUe6yzJSzqhbYhJ6rRPhMgr74Yw
 Vizk80G+7nXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="448555984"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2020 23:35:14 -0700
Received: from fmsmsx163.amr.corp.intel.com (10.18.125.72) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:35:13 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx163.amr.corp.intel.com (10.18.125.72) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:35:13 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 14:35:09 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [PATCH v1 0/2] vfio/pci: expose device's PASID capability to VMs
Thread-Topic: [PATCH v1 0/2] vfio/pci: expose device's PASID capability to
 VMs
Thread-Index: AQHWAEVE1+HhDDDknUKu1iBKdD1ORKhiSCUA
Date:   Tue, 31 Mar 2020 06:35:08 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D801252@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, March 22, 2020 8:33 PM
> 
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance security.
> 
> To enable SVA, device needs to have PASID capability, which is a key
> capability for SVA. This patchset exposes the device's PASID capability
> to guest instead of hiding it from guest.
> 
> The second patch emulates PASID capability for VFs (Virtual Function) since
> VFs don't implement such capability per PCIe spec. This patch emulates such
> capability and expose to VM if the capability is enabled in PF (Physical
> Function).
> 
> However, there is an open for PASID emulation. If PF driver disables PASID
> capability at runtime, then it may be an issue. e.g. PF should not disable
> PASID capability if there is guest using this capability on any VF related
> to this PF. To solve it, may need to introduce a generic communication
> framework between vfio-pci driver and PF drivers. Please feel free to give
> your suggestions on it.

I'm not sure how this is addressed on bate metal today, i.e. between normal 
kernel PF and VF drivers. I look at pasid enable/disable code in intel-iommu.c.
There is no check on PF/VF dependency so far. The cap is toggled when 
attaching/detaching the PF to its domain. Let's see how IOMMU guys 
respond, and if there is a way for VF driver to block PF driver from disabling
the pasid cap when it's being actively used by VF driver, then we may
leverage the same trick in VFIO when emulation is provided to guest.

Thanks
Kevin

> 
> Regards,
> Yi Liu
> 
> Changelog:
> 	- RFC v1 -> Patch v1:
> 	  Add CONFIG_PCI_ATS #ifdef control to avoid compiling error.
> 
> Liu Yi L (2):
>   vfio/pci: Expose PCIe PASID capability to guest
>   vfio/pci: Emulate PASID/PRI capability for VFs
> 
>  drivers/vfio/pci/vfio_pci_config.c | 327
> ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 324 insertions(+), 3 deletions(-)
> 
> --
> 2.7.4

