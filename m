Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138CE193F59
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 13:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgCZM4U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 26 Mar 2020 08:56:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:20529 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgCZM4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 08:56:20 -0400
IronPort-SDR: cfs9XeRP9zJ6WaKyCTH+yKWQai43sQZKh9+4a6bWroOk+mI95eXbPPQk4Zar7YU/QXr23uLlZt
 YPd81w0DL1hQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 05:56:19 -0700
IronPort-SDR: yiOsM0HzQtPs7uCAalT1rmEaVhDVR7PBoOr5v2NRZQDpTvBCDiL/gALwpPAPkTAp+Rfv0LXRHs
 WUCGki2QgF7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="393970616"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 05:56:18 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 05:56:18 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.50]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 20:56:13 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 0/8] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v1 0/8] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Index: AQHWAEUdI4Sfhdx3H0+yWIyqzj+O7Kha2xeQ
Date:   Thu, 26 Mar 2020 12:56:13 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A20440A@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
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
> Sent: Sunday, March 22, 2020 8:32 PM
> To: alex.williamson@redhat.com; eric.auger@redhat.com
> Subject: [PATCH v1 0/8] vfio: expose virtual Shared Virtual Addressing to VMs
> 
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance security.
> 
> This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> guest application address space with passthru devices. This is called
> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> changes. For IOMMU and QEMU changes, they are in separate series (listed
> in the "Related series").
> 
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
> 
> 
>     .-------------.  .---------------------------.
>     |   vIOMMU    |  | Guest process CR3, FL only|
>     |             |  '---------------------------'
>     .----------------/
>     | PASID Entry |--- PASID cache flush -
>     '-------------'                       |
>     |             |                       V
>     |             |                CR3 in GPA
>     '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>       v        v                          v
> Host
>     .-------------.  .----------------------.
>     |   pIOMMU    |  | Bind FL for GVA-GPA  |
>     |             |  '----------------------'
>     .----------------/  |
>     | PASID Entry |     V (Nested xlate)
>     '----------------\.------------------------------.
>     |             |   |SL for GPA-HPA, default domain|
>     |             |   '------------------------------'
>     '-------------'
> Where:
>  - FL = First level/stage one page tables
>  - SL = Second level/stage two page tables
> 
> There are roughly four parts in this patchset which are
> corresponding to the basic vSVA support for PCI device
> assignment
>  1. vfio support for PASID allocation and free for VMs
>  2. vfio support for guest page table binding request from VMs
>  3. vfio support for IOMMU cache invalidation from VMs
>  4. vfio support for vSVA usage on IOMMU-backed mdevs
> 
> The complete vSVA kernel upstream patches are divided into three phases:
>     1. Common APIs and PCI device direct assignment
>     2. IOMMU-backed Mediated Device assignment
>     3. Page Request Services (PRS) support
> 
> This patchset is aiming for the phase 1 and phase 2, and based on Jacob's
> below series.
> [PATCH V10 00/11] Nested Shared Virtual Address (SVA) VT-d support:
> https://lkml.org/lkml/2020/3/20/1172
> 
> Complete set for current vSVA can be found in below branch.
> https://github.com/luxis1999/linux-vsva.git: vsva-linux-5.6-rc6
> 
> The corresponding QEMU patch series is as below, complete QEMU set can be
> found in below branch.
> [PATCH v1 00/22] intel_iommu: expose Shared Virtual Addressing to VMs
> complete QEMU set can be found in below link:
> https://github.com/luxis1999/qemu.git: sva_vtd_v10_v1

The ioasid extension is in the below link.

https://lkml.org/lkml/2020/3/25/874

Regards,
Yi Liu
