Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85986382E28
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbhEQOEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:04:37 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:6957
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234578AbhEQOEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:04:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJBJEOkQMvzSJYKkbomRRZKFMgCsFofXZjtEbD98zWd/Zr/RQaVenJGZAdrZUjmJs6wh4X1GrcMpAkRTdryIvkUU3PmqfeQHTVbVmHRY3J/RIBFEPTNFH/VxdCec3zriQgCAnQD57SGvaVthI0YqeDZMXMcLd9ONQVx5OTRbt90XU+AltknX+HhJDzHwxZ8w11Hxj36B7RKCn/4oXyWPMSGjD0tOh0wvvUTzP+0zl+MjL4Stgh0Z4RsiYSSabK/O+TulYzZL/SZCCXSfxj4erz99OkK1w8myC6Bv0C1dpS7DK6JuUzi49abMv/Ah6FxS3F48g7ihPMgVwlnumqTlSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaFydMljmSDskDBdpdAk7yUlLbH9YsOVlndOmmdpOlI=;
 b=cZCOVtLyySb7EQ/osmy3qGaxmneiWbZjHvj7YVTOcBelopy3jVFh9/iUuEjjK3V5NjqkZA6rThx008qPDEtGdtip0cEp0NqyV4cqfl0Eh5923wvqNc0QlKvwSZ6cDNWWEeHtTEPVKdX6aLn1AtO8wO4RepWs1yn5LCaIe1BadTaXcd7wcQkigKtoySUwwBq41uzlgZFIiecRfFxXtCLKQyhdQmMuSUT1KJijRqdqWrDTC5ZlDSekPjVJcDWGzk8Wy150SV8IH7TY4T8r343acJ3jddw2LPfiIumvHvzIqHbWgd8x/VF27Pqf2wqFClTTgOqzLVPPB3JHDT7/aczPAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaFydMljmSDskDBdpdAk7yUlLbH9YsOVlndOmmdpOlI=;
 b=KtKdR8LlHCX2+eB7SQIJhdQjbQcADIBhI6AG3Glh+tHsJ2Bf/cH3zSBsNqRrJUi4Bql1SLOmvmBs1yfxPayjTjbQRINBg8025ydzQ+cRxW1brM0gPIwrDTMzDfB3KhbPG1Aki8UEx3OpN3A1Xr/jOP5/K3qI2rqWwtfp5Tj1+5C0u4Nxbrn7ymIKqPqAm7pMCGK5uri6dZyPusCtkBZ4jHsTFloW1EF3uKtuzSxQoTJmNf/VTEvtb2YHngHVaCDc9HAS+yJICcXAq2Ixdy8RdqgRMX13oK0OJYztMkXgAc03hlu/M1OBFe1l85tuM25A2o5UYgrTr5GZfUpe9nw1bQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2491.namprd12.prod.outlook.com (2603:10b6:3:eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 14:03:18 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 14:03:18 +0000
Date:   Mon, 17 May 2021 11:03:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v8 7/9] vfio/mdev: Add iommu related member in mdev_device
Message-ID: <20210517140316.GN1002214@nvidia.com>
References: <20190325013036.18400-1-baolu.lu@linux.intel.com>
 <20190325013036.18400-8-baolu.lu@linux.intel.com>
 <20210406200030.GA425310@nvidia.com>
 <2d6d3c70-0c6f-2430-3982-2705bfe9f5a6@linux.intel.com>
 <20210511173703.GO1002214@nvidia.com>
 <MWHPR11MB18866988310787FE573763878C529@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18866988310787FE573763878C529@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR20CA0061.namprd20.prod.outlook.com
 (2603:10b6:208:235::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR20CA0061.namprd20.prod.outlook.com (2603:10b6:208:235::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 14:03:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lidq0-009H7L-NU; Mon, 17 May 2021 11:03:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5eccd7b8-5df9-48cc-82e5-08d9193c85d5
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2491:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2491D7FE6E7F7EC4248B41EBC22D9@DM5PR1201MB2491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYx3ufjeh+hFd3X3g9UTf+OSw//75N0D9tZDHzsAvr26lHSZx+b4fJTDXMIzrZNoNYywLYhas1mYET8nEbQGTJPNXF3wySxJKsLl2/vIVKYjAEgYMIOhXmKy3qf3m4x046pBjv36qatusGODCvhun8g5JzxhHx4VBFA7rw+RyzG9UhpuuGiHiuNirOph0s7pD+TKwfOEhVCpN//0/cFMcEDozZug8txnVLkUApHf2E9AXMc0pHz/6FaSWu9xvm0z/AuHOal1AJXqO1mY+v5TLlFva/TtkdfsK5eTMzBO2TN52zrWs9/RV7Y0v0sbW8GsYE9GIErmLT+50b1H4pfK9vAWAtlNYTJAS4bNVsKEhHpoYqKeYCRORaiqajwNLH1wBEdqWKA1JCemb1jC0EC9iYFv2EtLjFctaLEizIcxo+iWuXFBrsbeBbVbH5tV3R9ZUIqa7N5fpmIX74XK5Ji9VopKDW23pkYlBeXnFI7LtiNYie2WFNvzX/jpt5GEQC/eNWrDnu8z1VMPU2pr+jm6EH+Hw92vYboQvmJ+EtSzmLJsvpju9dlZMTNJ0pD1RJrAf63TAQzU/QmtOaa78n+KRti02995mXFjb1p7b+nVSHU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(54906003)(478600001)(186003)(7416002)(36756003)(86362001)(9786002)(38100700002)(316002)(5660300002)(426003)(66476007)(66946007)(83380400001)(8936002)(8676002)(2906002)(1076003)(66556008)(6916009)(2616005)(9746002)(33656002)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SbCqV2kgmT37BcpSaEDqeoS5h7PBELIa/ZnCg/bWhsEBmcF6CKIHLOd804hn?=
 =?us-ascii?Q?UowWbmKcdGL0412vPDHOhMugkw8GJaw5PDy9pINLH5iPRXtI9f0L9yR86Uiu?=
 =?us-ascii?Q?YXWGTHjZX5/vXRJCuD6QGuF7/YAi6ItL/oOmLtJVI7wpcrV1TRlM7nfy/zfi?=
 =?us-ascii?Q?mPpF0zcoTyH7FMzSdk8bU5vJK0ybC6VRxhdUPR/lZB5lN1XwTTyrwA/kHuho?=
 =?us-ascii?Q?udH6mPctoIdxp8gnZpT3KBDW2QHXOJR+pd2UedOt/OVLAMmVHoAoxqqlXRzr?=
 =?us-ascii?Q?0mlehkxlVg2cEuC4ZPni+hpCQL6fW0i8Wc0+0STkCnJwMmheDluEdR7plxD5?=
 =?us-ascii?Q?LbX12dEmzT9o3BVMzfyFoueJ+PsNlk3u0MM7rlTb+KK5CzlP5bBJaQe0mmW+?=
 =?us-ascii?Q?bm1b3MY1FdPRAiq7qg37tiWxw9P/zsOU104rM2okBKqvKjKNDSul0PXV5veD?=
 =?us-ascii?Q?N7k1nE/fEjMmjxIizswgwf8Z8j1+MEWoCVPvSvwN4iFUZQSqE6KzGJtaiAxw?=
 =?us-ascii?Q?ed+A4iWME5+c9n72VTY8nzvJwL59ys+39U04gRewCktjUa9Kn9w0MLpLo8yD?=
 =?us-ascii?Q?KWp4hYHtObJM30F0a4hTEM9pMKiJ2A+tvqVTnHw3xqm1ZT21QVfYV+IRLfZK?=
 =?us-ascii?Q?NeWf5LjHs+H6u/xoePg+SpFYCj09SEQ3gRJqKg9gN2jq5IG8riHJQCH4mg3u?=
 =?us-ascii?Q?mEeo6RCuq5XlpGXwBsEorWHQKtKm6/NQiQzCkSNSZRix5tgIPvIJCuNOFDuS?=
 =?us-ascii?Q?r2A1yOClUZYd9yRSC0ZaJCzOFkgpX3AtqFT9VJnqwWrZSMBgeapMCTjic4zf?=
 =?us-ascii?Q?jQKjpPJFtATLUY8XaEuXGiIgLUEgCWjQ1iYnhWJxW5SjtgwveKcbEZA8Rb00?=
 =?us-ascii?Q?F+Cp+DmCVnQHojUe/eEmKDUyXCwi30fcjoXDijEqs0iGZ8k2eo0hFvdTNfVx?=
 =?us-ascii?Q?QRv5zglklgo9xVx/rUZ7kmRynjN0GV7XAfgheUhmkQHeYOJqOf5N2GU7owrC?=
 =?us-ascii?Q?LnPPONCVoUXnUJezCf/v9MAmJR3fTsqKppRULvhgWKdQhbHJpPLPHzTlglHO?=
 =?us-ascii?Q?ORM0ziRP7arpAoy1DbseekKu/0vU1mc5lTpc+ZIzUr+jFnxFzg189WWtoUnB?=
 =?us-ascii?Q?Yi6uhZGz/eEYLfJ8CUQ7IuHpEkBjdL0eouCyx2KyiZfyUMRLfW6PiGoKtioD?=
 =?us-ascii?Q?pY+bZ835bCieVdu6JnFuEGSJIjp88YOLQdqSkJ6hLB0FB8XBd8F8tHaeXoy0?=
 =?us-ascii?Q?2ibuUC2rLYF4/g2yjmdyBJDhhbtd61M2fWdlYBoStZ4wQv6o0TYMdxZfBYud?=
 =?us-ascii?Q?eQeJWJapoeEkoN1NGZdsAjdI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eccd7b8-5df9-48cc-82e5-08d9193c85d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 14:03:18.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ge02ImjPjuQQJGzXf45Gi1IljusyURiXVA1aefSm1sisdGD7Nktv9/Ur7Gp99eLZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2491
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 07:46:05AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 12, 2021 1:37 AM
> > 
> > On Tue, May 11, 2021 at 02:56:05PM +0800, Lu Baolu wrote:
> > 
> > > >     After my next series the mdev drivers will have direct access to
> > > >     the vfio_device. So an alternative to using the struct device, or
> > > >     adding 'if mdev' is to add an API to the vfio_device world to
> > > >     inject what iommu configuration is needed from that direction
> > > >     instead of trying to discover it from a struct device.
> > >
> > > Just want to make sure that I understand you correctly.
> > >
> > > We should use the existing IOMMU in-kernel APIs to connect mdev with the
> > > iommu subsystem, so that the upper lays don't need to use something
> > > like (if dev_is_mdev) to handle mdev differently. Do I get you
> > > correctly?
> > 
> > After going through all the /dev/ioasid stuff I'm pretty convinced
> > that none of the PASID use cases for mdev should need any iommu
> > connection from the mdev_device - this is an artifact of trying to
> > cram the vfio container and group model into the mdev world and is not
> > good design.
> > 
> > The PASID interfaces for /dev/ioasid should use the 'struct
> > pci_device' for everything and never pass in a mdev_device to the
> > iommu layer.
> 
> 'struct pci_device' -> 'struct device' since /dev/ioasid also needs to support
> non-pci devices?

I don't know. PASID is a PCI concept, I half expect to have at least
some wrappers for PCI specific IOMMU APIs so there is reasonable type
safety possible. But maybe it is all general enough that isn't needed.

> I assume the so-called connection here implies using iommu_attach_device 
> to attach a device to an iommu domain. 

yes

> Did you suggest this connection must be done by the mdev driver
> which implements vfio_device and then passing iommu domain to
> /dev/ioasid when attaching the device to an IOASID? 

Why do we need iommu domain in a uAPI at all? It is an artifact of the
current kernel implementation

> sort of like: ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid, domain);

ioasid and device_fd completely describe the IOMMU parameters, don't
they?

> If yes, this conflicts with one design in /dev/ioasid proposal that we're
> working on. In earlier discussion we agreed that each ioasid is associated
> to a singleton iommu domain and all devices that are attached to this 
> ioasid with compatible iommu capabilities just share this domain.

I think you need to stand back a bit more from the current detailed
implementation of the iommu API. /dev/ioasid needs to be able to
create IOASID objects that can be used with as many devices as
reasonable without duplicating the page tables. If or how that maps to
todays iommu layer I don't know.

Remember the uAPI is forever, the kernel internals can change.

> Baolu and I discussed below draft proposal to avoid passing mdev_device
> to the iommu layer. Please check whether it makes sense:
> 
> // for every device attached to an ioasid
> // mdev is represented by pasid (allocated by mdev driver)
> // pf/vf has INVALID_IOASID in pasid
> struct dev_info {
> 	struct list_head		next;
> 	struct device		*device;
> 	u32			pasid;
> }

This is a list of "attachments"? sure

> // for every allocated ioasid
> struct ioasid_info {
> 	// the handle to convey iommu operations
> 	struct iommu_domain	*domain;
> 	// metadata for map/unmap
> 	struct rb_node		dma_list;
> 	// the list of attached device
> 	struct dev_info		*dev_list;
> 	...
> }

Yes, probably something basically like that
 
> // called by VFIO/VDPA
> int ioasid_attach_device(struct *device, u32 ioasid, u32 pasid)

'u32 ioasid' should be a 'struct ioasid_info *' and 'pasid' is not
needed because ioasif_info->dev_list[..]->pasid already stores the
value.

Keep in mind at this API level the 'struct device *' here shuld be the
PCI device never the mdev device.

> {
> 	// allocate a new dev_info, filled with device/pasid
> 	// allocate iommu domain if it's the 1st attached device
> 	// check iommu compatibility if an domain already exists
> 
> 	// attach the device to the iommu domain
> 	if (pasid == INVALID_IOASID)
> 		iommu_attach_device(domain, device);
> 	else
> 		iommu_aux_attach_device(domain, device, pasid);

And if device is the pci_device I don't really see how this works.

This API layer would need to create some dummy struct device to attach
the aux domain too if you want to keep re-using the stuff we have
today.

The idea that a PASID is 1:1 with a 'struct device' is completely VFIO
centric thinking.

> // when attaching PF/VF to an ioasid
> ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid);

This would have to be a (ioasif_fd, ioasid) tuple as an ioasid is
scoped within each fd.

> -> get vfio_device of device_fd
> -> ioasid_attach_device(vfio_device->dev, ioasid, INVALID_IOASID);

The device knows if it is going to use a PASID or not. The API level
here should always very explicitly indicate *device* intention.

If the device knows it is going to form DMA's with a PASID tag then it
absoultely must be completely explict and clear in the API to the
layers below that is what is happening.

'INVALID_IOASID' does not communicate that ideal to me.

> // when attaching a mdev to an ioasid
> ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid);
> -> get vfio_device of device_fd
> -> find mdev_parent of vfio_device
> -> find pasid allocated to this mdev
> -> ioasid_attach_device(parent->dev, ioasid, pasid);

Again no, mdev shouldn't be involved, it is the wrong layering.

Jason
