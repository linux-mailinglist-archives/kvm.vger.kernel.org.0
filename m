Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF6E413D29
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 23:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhIUWAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 18:00:19 -0400
Received: from mail-sn1anam02on2049.outbound.protection.outlook.com ([40.107.96.49]:18981
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235825AbhIUWAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 18:00:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYYOomCqwy925Zaq4AYbE+OYNeL5JsJG+sDW4vj6FAMKGG8wR+PcY9h4LF0WwXUvIU3ixRxgALq5001CcSE4HLncz2ycpMZXZDP+i+Xx2MJj4OAnruP4zCjC+KwQqqVBfUjakM0Li1QbzBlAsJJnarfabfw/ZoASQmDMNrQQhBdVRjUxHcCSaCALazbyPLpuGKFfud1aQSFkKYyRh/e5qgjwZOi8BGZoOlsIfNxvmcS/EyC5dPPG85mNRhx4bnSPPQXefM/52dCs0Gym064i7iDzvI5xMAzYKjV2EcOi5b554Adqc2OuhshifGb+sOAcXg9oil7kHgKCS+WMHN+mNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=N2HBAX7d2mg3Rgmu13pml+cNWydZ2Zqc9d+zYKGF/8g=;
 b=aANTeiYxwI/XRP0c5Ec2tKrPH2OO780wHW8Sy8jq1vX8KlymGSrMB58+5QFSxX97/pRGN0PpkADc1L0QkKiXungroq67f9sxwj25T43NBeAKIqk/LRFrnQCeHSUA23MClytoEZkY71x1ZICRzuytVV2AsJ4GztqlJh6SpExmXFcsjkG4SdVOpi5RVPGVMwJOsIIpBLYimgxiO/CHSB9Jvwl8rTr80VtaIbXZoAynnEAeit+vK/0/1nhriMomDN5HunNfPiTnAF3AgzDOOVLH9i0+r7prtnshGd2MyA6lBSMOpto86bWLXPhhCmSSpkaG/W4DtCFekQaZgburst4RHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2HBAX7d2mg3Rgmu13pml+cNWydZ2Zqc9d+zYKGF/8g=;
 b=qVEs9ewS2cpAd9nPyWn7mAFLHx/RZsrVOrVC/9Q3P52TYAH+J0BzMeDwg6N5csqcoUXnr8379Pjzjo6JfcuOTwk7YJA2KsGI0j0haR7PNVz9r5RWDdE2oUH7AMYsEVU5PBBxu4HjB5WQp8ZzQflL41ShOYefpPVTYB9vXS3uikXc0LkbaIg374amrPWS0cWgOZ22+4vsX28ucwup16OhC3Q5pcIy/7Oe4bFDp7zWb3imIBez0HI2NsxrotY43vm14U+SiGWlk2ok9eMXMuf9eAy4X1ePzCgXg/Fsj7cdd7FIc1m3OADXxn0GcVRsi3P7pgNC0hwjSHh63V4ckHc98A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 21 Sep
 2021 21:58:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 21:58:47 +0000
Date:   Tue, 21 Sep 2021 18:58:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Message-ID: <20210921215846.GB327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-6-yi.l.liu@intel.com>
 <20210921164001.GR327412@nvidia.com>
 <20210921150929.5977702c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921150929.5977702c.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P223CA0027.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Tue, 21 Sep 2021 21:58:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSnmo-003kON-1q; Tue, 21 Sep 2021 18:58:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 285db925-64d3-41e5-c621-08d97d4afca7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143D16518E7413D65C09FE8C2A19@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fNgswTcPJZjP1WWbqoBgX1A1Uqs23WdwgrRHya9fWlPxottjx1bKKLBOrJNwwui3YD/phSj5aB5Q/oyBbBt4GSCSG+qbhLWM5789MLHdH/Y5x19Ww+3xOqle792MZdQMcHReb3WN7ThDoQ4ANVYQtmJMGGo7lpGOI2SRiry4Fqp2fcKHQmxdCYmUAU/+ubmPzt1DkMuGr9NRxDqr6MTSy+Ne56AiHnbBxXVdytHteH/fcpfHIm11d6TYOEzjyZD1QQjFjCRsV7akRhwsA5juByQ9tq2znlp7MNfVtv2OPkKOU2UqKF3U7JfANsDfTLRUwWhiGPc3lmWK4G/jISpo/SqGK50bqwXMhWrSNKCgXLW8EdJ66tCTropgWSTkxFDKsGJF3cEQI257W0qrKTDTeGnwf/MAKjNRC6wBPfaLjRzBr6CNbR+LyUoihdHvbzfD+KTReeb69+vnLiJxURs2fu2IHzS2gb0/TgITkMuME2XxYZU1UErVnGx1ozeP8O2XpRpdmAdw+3btL91AOwDpSRND5kgNfjLzWjnx/13rKHEByBuzuWE3tTGSWeYpzfqmRgryiFZWNctraCV95BMyNqUwxmfsXTl/KnDBO1HYsgFqPCfR7S3lw++seu3zkdwe/+mkznGuI7wvyD/w21WssX6TVTC35oMaBA96iAawObWJ7kOrVrQLUkKdhsMlg9B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(36756003)(2616005)(86362001)(508600001)(4326008)(2906002)(1076003)(426003)(83380400001)(8676002)(26005)(9786002)(66556008)(5660300002)(66476007)(7416002)(38100700002)(33656002)(9746002)(8936002)(186003)(66946007)(107886003)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dp7su0OpJJjLWmG7MDb+uHpIwdBGO1XfRvA3HEdCgzMpfMqUel78fWUv99J7?=
 =?us-ascii?Q?t7cZ+1CBcCxF5Cn04wOsTLyFsBqXMzTnb1Atm/aq0bxWmu0FEHGESVvOcrZK?=
 =?us-ascii?Q?r5v1/GtP59sDJ8pGYAStkzOWEIHB3i3y5fhRcBioNpD90pG7zIxtUCkZE1ld?=
 =?us-ascii?Q?4O3+ihJQWvvw86mPV2+eshaOKIobwIDSSjmJPoHYf84eJ3APMGo10uZRNYH0?=
 =?us-ascii?Q?5i8UEaBOCVjxzCoEISe8IGCNqhhHXrBeoWXB7NpX5q4gMIH2f2x7SEqwkcv0?=
 =?us-ascii?Q?dt5a/H5EDGf1IX6ZwCewN2UUSjlnFaeyWLzZ4b+GBPM6ew1T7oK7MeLaPQGc?=
 =?us-ascii?Q?sdrg0ybJUqnY//HidPuu+e1KaqK2ZQBgXCVsEAfE+OUbcriWp8VsqgsIo3PL?=
 =?us-ascii?Q?m76ojw1EwGy10qXIHXN/pWPUMYy0hWcPji/0TLaC58f2Pq50+i7NmoQ0NZJb?=
 =?us-ascii?Q?EtVIFI4t2s3k+yPNDINFErCVo2aIYdGalKIi+VVeLOgWZbTNnNflHyphXSIV?=
 =?us-ascii?Q?4/AZQfUWk51iK0MAd/WwgvMdXyJhQhd2YTNO+CqiL7w/NDRW5A3Eh5AAJcp2?=
 =?us-ascii?Q?95RkQXZj66nAshCxABGbDaNbVuv1pA8hoLUHSEJ50oyZrQVL4Vui6oLmD7M8?=
 =?us-ascii?Q?BJWIuI8P7wmPag+CRVjSxrtF3LZEDlv60EB6Pm3pFIc/GfRScuRwPTHg/DaN?=
 =?us-ascii?Q?Ksmd+MI0U0wrFvOxogsNGBkFLN+rU7RzDAX2EXXrRsII2K4sSXlshpfU0V0E?=
 =?us-ascii?Q?AhI3jxI38l5gMFGT5NLNg5vPvRqMo3JoMRYTV0b9XB9RQ3gKBGHkk/nC7MX1?=
 =?us-ascii?Q?Q6jvXEWxtl2t0YflyX6WJ4+X2cbjM8+Q3pYHFAP/EJSnVdBQ2zkQq9hy1GEo?=
 =?us-ascii?Q?nckutT4svYHsw2oVxJhBzGdDmic3FEKrVb8PuIGly2sTkWhNHZp4lA/93wmL?=
 =?us-ascii?Q?8nSZjPEvveWfti/KzRAP/g9lxDLzdmAHtMCwtLxPUc9X1KhaHcIdVgxZEgng?=
 =?us-ascii?Q?5CqZlONjHLEoNe5hzaW48zJXA+yIbDe/kdRBU8z2uAagglkPyfoahfPQNCj0?=
 =?us-ascii?Q?8yi3wrQkSAidUZEMnoNQFsd9En49Svzg7TKQ+J26FR4Qe3seDH+C6oOK19xx?=
 =?us-ascii?Q?4wWPAlGDhS3uRj0JyLlf0Uo8xi9yLsKCOu9NmO0rKMhe6ffmUgNCIUY0FR68?=
 =?us-ascii?Q?ZH3LlCihvaWTLtX/NGycngZiKqty0/Hm1SBNhOn1oXwdvjGUWL1X3eL21BYv?=
 =?us-ascii?Q?XljOPhlQkZHmtGEvf8Wzhb+bZKqIvYo2p1DjuOqCgYHfm9qiBwZZwPLA+Wyj?=
 =?us-ascii?Q?m3L5F3qqy3szD+yT7hE+C+Ik?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285db925-64d3-41e5-c621-08d97d4afca7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 21:58:47.1353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJVd3vsWgXBknIZgRdmpoeTpGCD055VBAPYCfabkoZGOIctcAeRx2g26bX6UjG5g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 03:09:29PM -0600, Alex Williamson wrote:

> the iommufd uAPI at all.  Isn't part of that work to understand how KVM
> will be told about non-coherent devices rather than "meh, skip it in the
> kernel"?  Also let's not forget that vfio is not only for KVM.

vfio is not only for KVM, but AFIACT the wbinv stuff is only for
KVM... But yes, I agree this should be sorted out at this stage

> > > When the device is opened via /dev/vfio/devices, vfio-pci should prevent
> > > the user from accessing the assigned device because the device is still
> > > attached to the default domain which may allow user-initiated DMAs to
> > > touch arbitrary place. The user access must be blocked until the device
> > > is later bound to an iommufd (see patch 08). The binding acts as the
> > > contract for putting the device in a security context which ensures user-
> > > initiated DMAs via this device cannot harm the rest of the system.
> > > 
> > > This patch introduces a vdev->block_access flag for this purpose. It's set
> > > when the device is opened via /dev/vfio/devices and cleared after binding
> > > to iommufd succeeds. mmap and r/w handlers check this flag to decide whether
> > > user access should be blocked or not.  
> > 
> > This should not be in vfio_pci.
> > 
> > AFAIK there is no condition where a vfio driver can work without being
> > connected to some kind of iommu back end, so the core code should
> > handle this interlock globally. A vfio driver's ops should not be
> > callable until the iommu is connected.
> > 
> > The only vfio_pci patch in this series should be adding a new callback
> > op to take in an iommufd and register the pci_device as a iommufd
> > device.
> 
> Couldn't the same argument be made that registering a $bus device as an
> iommufd device is a common interface that shouldn't be the
> responsibility of the vfio device driver? 

The driver needs enough involvment to signal what kind of IOMMU
connection it wants, eg attaching to a physical device will use the
iofd_attach_device() path, but attaching to a SW page table should use
a different API call. PASID should also be different.

Possibly a good arrangement is to have the core provide some generic
ioctl ops functions 'vfio_all_device_iommufd_bind' that everything
except mdev drivers can use so the code is all duplicated.

> non-group device anything more than a reservation of that device if
> access is withheld until iommu isolation?  I also don't really want to
> predict how ioctls might evolve to guess whether only blocking .read,
> .write, and .mmap callbacks are sufficient.  Thanks,

This is why I said the entire fops should be blocked in a dummy fops
so the core code the vfio_device FD parked and userspace unable to
access the ops until device attachment and thus IOMMU ioslation is
completed.

Simple and easy to reason about, a parked FD is very similar to a
closed FD.

Jason
