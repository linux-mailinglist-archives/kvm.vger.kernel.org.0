Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B18464B0E
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242457AbhLAJ5x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Dec 2021 04:57:53 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28211 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhLAJ5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 04:57:52 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J3vWz6sJ1z8vhN;
        Wed,  1 Dec 2021 17:52:31 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 17:54:30 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 17:54:29 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.020; Wed, 1 Dec 2021 09:54:27 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        liulongfang <liulongfang@huawei.com>
Subject: RE: [PATCH RFC v2] vfio: Documentation for the migration region
Thread-Topic: [PATCH RFC v2] vfio: Documentation for the migration region
Thread-Index: AQHX5S/pH80pYVu+o0az8lQb+t8Cn6wcVFyAgAAZ+wCAADx+gIAATcuAgABn8BA=
Date:   Wed, 1 Dec 2021 09:54:27 +0000
Message-ID: <90226a3c13a2404086dc555e4aced7cb@huawei.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
In-Reply-To: <20211201031407.GG4670@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 01 December 2021 03:14
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>; linux-doc@vger.kernel.org; Cornelia
> Huck <cohuck@redhat.com>; kvm@vger.kernel.org; Kirti Wankhede
> <kwankhede@nvidia.com>; Max Gurtovoy <mgurtovoy@nvidia.com>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Yishai
> Hadas <yishaih@nvidia.com>
> Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
> 
> On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:
> 
> > > From what HNS said the device driver would have to trap every MMIO to
> > > implement NDMA as it must prevent touches to the physical HW MMIO to
> > > maintain the NDMA state.
> > >
> > > The issue is that the HW migration registers can stop processing the
> > > queue and thus enter NDMA but a MMIO touch can resume queue
> > > processing, so NDMA cannot be sustained.
> > >
> > > Trapping every MMIO would have a huge negative performance impact.
> So
> > > it doesn't make sense to do so for a device that is not intended to be
> > > used in any situation where NDMA is required.
> >
> > But migration is a cooperative activity with userspace.  If necessary
> > we can impose a requirement that mmap access to regions (other than the
> > migration region itself) are dropped when we're in the NDMA or !RUNNING
> > device_state.
> 
> It is always NDMA|RUNNING, so we can't fully drop access to
> MMIO. Userspace would have to transfer from direct MMIO to
> trapping. With enough new kernel infrastructure and qemu support it
> could be done.

As far as our devices are concerned we put the dev queue into a PAUSE state
in the !RUNNUNG state. And since we don't have any P2P support, is it ok
to put the onus on userspace here that it won't try to access the MMIO during
!RUNNUNG state?

So just to make it clear , if a device declares that it doesn't support NDMA
and P2P, is the v1 version of the spec good enough or we still need to take
care the case that a malicious user might try MMIO access in !RUNNING
state and should have kernel infrastructure in place to safe guard that?

> 
> Even so, we can't trap accesses through the IOMMU so such a scheme
> would still require removing IOMMU acess to the device. Given that the
> basic qemu mitigation for no NDMA support is to eliminate P2P cases by
> removing the IOMMU mappings this doesn't seem to advance anything and
> only creates complexity.
> 
> At least I'm not going to insist that hns do all kinds of work like
> this for a edge case they don't care about as a precondition to get a
> migration driver.

Yes. That's our concern too.

(Just a note to clarify that these are not HNS devices per se. HNS actually
stands for HiSilicon Network Subsystem and doesn't currently have live
migration capability. The devices capable of live migration are HiSilicon
Accelerator devices).

Thanks,
Shameer
