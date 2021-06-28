Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6513B6B39
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 01:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhF1XQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 19:16:03 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:50272
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235349AbhF1XP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 19:15:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv28IIyQ8vRJlnw1IApcXNUd+UNECNdOLxJia6iCNcHJJNlwa4A6ut8bU54YVgYw+5hohxgx6aw3i5JFQLdmiXz9hGITcVoJ6fCvHb5kzI6XCrXhJC526dQMt/af3bb0n+WzgjreHEoy4WOfhCuVTlhgpwCpp4Lv/Qn/pmXiGwpEMLQ45TRpSlqIM8aWMsz0FY0ikVCoT81a822KKZkKJXU2Ad/0p1x0BoUzajBd3OEFps27YjwG3VpYAx0UDGL/sk2HFTmixOBhBUHLx48K7t5O4XNOjBzYMArUyIEHKk1oV5JhBamIZFcm3kkrAzCNDOTr51ARUEC6tDful3Lq2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLfXmaJAB9AzxsUp0XgMnMUx7yuHqAXuIdEON9FZ8Uo=;
 b=HJReHFmh73FRbnHgKHcjlIgHm9/QEww7I70OW+Is3q8JCVJy73DfDBBvSYAqvOccMm6Y5p5MOD0GzObM/R4/q80ewhFPgSu6yiS2mF4vwp0Sugy9s5OQfEbEfOJkCwDVoiFfAE0EE8tGrMtl7TrahF+7uICSUzft6kmPY8SqgnsDRCnaaamU9ztxw9Um+oij9jps2R1YTek9KaCGls+KkuExwEJZUdjUU2QnHtHtx7zpQn/ay/GFa9alXGAN7LEcSpn5D5c2u+Mh1xY+6BNfWNIi/asInYQJ1fqAfPC+ZlDC3Wh9VWwrjnAM7fg3D6kSJ2qf8+xYqpIg4URPMf17Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLfXmaJAB9AzxsUp0XgMnMUx7yuHqAXuIdEON9FZ8Uo=;
 b=KGE+eDEQXbROnhwtcOXmXNPPqnQfhew/G5lZlT9Ig+EhnjeNc5s3nrJSf0XsCqVoZNgNApy+l0glkvLwHuThAvgFgag9ptakoZmPVCIrcwTaHO/TC2yOhBUeYQgx+ULFdY6T2iPtVDPirdHG+TTUNIT+Ue5CsCgaW5mMwkb/r41gaIF3xhAyWwT1p6gr+qpQxygF35dDonuVGRkbPtWcT6gU84Vh7HCSKjJGRgL2havq5NE+HDSiR7qoTPohdFWmygRFUef0Y5Te0aEZrhX2nLrHjZorm4D4FyN7D8Co8Dyfvtx+9ZQR9Ad5YRQaDtuZ8K5KtD1S64JT2vFNoMi9Zg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 23:13:30 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 23:13:30 +0000
Date:   Mon, 28 Jun 2021 20:13:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210628231328.GK4459@nvidia.com>
References: <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
 <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210628163145.1a21cca9.alex.williamson@redhat.com>
 <20210628224818.GJ4459@nvidia.com>
 <20210628170902.61c0aa1d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628170902.61c0aa1d.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:208:32d::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0053.namprd03.prod.outlook.com (2603:10b6:208:32d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 23:13:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ly0RV-000m0Z-0Q; Mon, 28 Jun 2021 20:13:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6313f32a-5f42-4858-a466-08d93a8a5783
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5286D714C5FC1A7945D1A541C2039@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqEnawq3Z+9maUZQ/DvNp9Mp5umCPwxJAGja0kaALKErVr4VoPjtTnVhldg2wtbHmi/ocwZ6wfiR4vIpVtJRDX0Jf5p5tyqs6KMcDyLYXvJnL9DaL+bTKVfi2xg1pCy7UP2Pnff95kfU3mp/FM3J+HDwr6f3qNezgs2P2fWAYchWrKGG7bZ7DIC3Q78qzXIG10WGzfZd+aI9aJ5s4L2r/RILW5fuQ4mXzzMsuOXM4JwIIvz10YOFQpIpGkJneqmj87WD2K974iRpqrrcbaYuEZYeYyiQa5k/u77zXWFt0w14qwq/rTuaa2hjMgWzdWfi5rhqXrblihUDCdq7ORykOlMdL4pxhCPE88LVUM8sE0KNFG/ga8mWiipTPsFKDBndej1FzBjeMHMgCpHfQEOzvDDUx1yse56kMOW6Q8hjOmCAlbFIkh3qXx0FeketfQLXzt8/aAyIiZ7q7Hyq0WUuYZRPXuxYf9EDkH72WgCclYr4Q6gVf+qGX3rSTRSSyURZFIrZlk3Jhbo+YGdiyFt6M0JkeJ+J9FKpqDEC+6Dv4ey/E5ae5EIsUwACoamg1+1tseRFqQTbYCBbuaFzP4HiLeLt/qdsu/kfPBSgN4PaHOk53gapNOSBLpJk8aHcZF7Qwk20DGmNv8RL2MLYbzYNwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(54906003)(478600001)(4326008)(186003)(86362001)(1076003)(36756003)(316002)(26005)(2906002)(426003)(6916009)(7416002)(9746002)(9786002)(8936002)(8676002)(66556008)(66476007)(38100700002)(66946007)(5660300002)(2616005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jqZnnxBz9Oqxc7k0zklv25QFCu9kYgS9qEw1/f9ZBjkIjic3hwLrdYnth89x?=
 =?us-ascii?Q?yfTYBClvrEFEhi2DMsD8lmOY7quVVH9XcT43KcvpKMC4kOmblt2iVEVnUZA0?=
 =?us-ascii?Q?TQB+l+re7ok3Wgh3J+RjJ8qWab6DhuDAuTS3h8ikON3JYxn4SYLXpYRuXZ99?=
 =?us-ascii?Q?oO/00fp5v8zhYQrKIv62QnsmLGbdFEyZRQCPjvO8CW2en/qXHK7Gug6k7RXj?=
 =?us-ascii?Q?SzKypi444cGpR6GOP4LeDhUBmxoufmDXgUde4rZ30RceCSxFQhAj5WaXt4Yr?=
 =?us-ascii?Q?PqxAX9BeJ6+lL11NyU40rBP/1NUX3zN/TCsnZOSMjDd8Ehgl5zDCVcThHTRz?=
 =?us-ascii?Q?TDIg5wGu9WKnEIkCg5tgIxz04bZmEPmlEjhZ/LMZo81kYJZR+gnSt+J7bg6n?=
 =?us-ascii?Q?ynVHy7Sk/neVKbj3aD8WzAD+srReDlS/VFcm0UTdC5nQNfdfzC/Aw22hg1cA?=
 =?us-ascii?Q?j+5hmfZa/10yD4PqhqGBSO4Lq0zfnXO3QEC7XzIiK85j1uzClH/ujN/LayXM?=
 =?us-ascii?Q?VOe6nQ8fTLm8TVcHDEtTpC14G7uo0QriesESMTyo1lv9ul5QVadzDTfcQ3bE?=
 =?us-ascii?Q?g8K590NErCjzRwWUG7CFjTpTTH3OgOGFUj6rEIcNusjXm7jeSjX65Z72JXAC?=
 =?us-ascii?Q?ij84kokbNfMz+WY67EWxImwksqaI+LZuDMGD5Jb8ksbCwRbr9r4topOnsDYj?=
 =?us-ascii?Q?eNtFXD5SSLCnBAyxBOXKEnHshkEoQgC8XJXO7zkJFAmlr/0qFheA7tlTpnIe?=
 =?us-ascii?Q?LaY3VPT/R0cWaiUXxLWXRpemytzHqmOC5CIRf5kFfyrHyaF4Youo9iMcddN1?=
 =?us-ascii?Q?tZ+Cc1uzHvZTU+tVGLMBkFl2l+ELAhxaIP4sLhAc/I8ATebMC8CVGXIlsImg?=
 =?us-ascii?Q?inRLFk7EtxqsrUXxduF54qaUw31ILN/dz8RaQ5fhuyVvhl8Bcgvvt+cgLkIa?=
 =?us-ascii?Q?ySqijokFW1STq6JQgOU3CBt2+fMHWmj5R2rQgrCLjbTyj8SdSeFhCIsn9UFc?=
 =?us-ascii?Q?pcDZdzQgKLlnScN/8x7NVDdo++1AlWT2R+WdSjWmkGrmcZGRNK3OGdlSXTaI?=
 =?us-ascii?Q?80NOdMposVs638ajhkLbeanaDvVVJdWcZwMF4bpKsCvPt+Bcnulq6l9SfBmg?=
 =?us-ascii?Q?Uj6z2FiUCPg0q13qyxb7alGZxLAIF3zjslINenY2bx6aBGPcMyaFu8kDIT6E?=
 =?us-ascii?Q?3Af6C5Svk1UNrtI7pTyNHLbbG1Nu5o5mPsG40FMLXMtJY/N1htt5tCeZBklu?=
 =?us-ascii?Q?lkwSoRNDbwlNvlCPlBB+InbmW3dZceWSTLqiDGdrxMsLzxSCqvkrK9rMJGzi?=
 =?us-ascii?Q?CgeF272SWsAB7yDO9B8uf64S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6313f32a-5f42-4858-a466-08d93a8a5783
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 23:13:30.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bhm85INimm8QOY7zDRnf08QzpS6QsL73ScFbZWa41EhME5c6iYtzmh6LCbfYI6mA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 05:09:02PM -0600, Alex Williamson wrote:
> On Mon, 28 Jun 2021 19:48:18 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jun 28, 2021 at 04:31:45PM -0600, Alex Williamson wrote:
> > 
> > > I'd expect that /dev/iommu will be used by multiple subsystems.  All
> > > will want to bind devices to address spaces, so shouldn't binding a
> > > device to an iommufd be an ioctl on the iommufd, ie.
> > > IOMMU_BIND_VFIO_DEVICE_FD.  Maybe we don't even need "VFIO" in there and
> > > the iommufd code can figure it out internally.  
> > 
> > It wants to be the other way around because iommu_fd is the lower
> > level subsystem. We don't/can't teach iommu_fd how to convert a fd
> > number to a vfio/vdpa/etc/etc, we teach all the things building on
> > iommu_fd how to change a fd number to an iommu - they already
> > necessarily have an inter-module linkage.
> 
> These seem like peer subsystems, like vfio and kvm.  vfio shouldn't
> have any hard dependencies on the iommufd module, especially so long as
> we have the legacy type1 code.

It does, the vfio_device implementation has to tell the iommu subsystem
what kind of device behavior it has and possibly interact with the
iommu subsystem with it in cases like PASID. This was outlined in part
of the RFC.

In any event a module dependency from vfio to iommu is not bothersome,
while the other way certainly is.

> Likewise iommufd shouldn't have any on vfio.  As much as you
> dislike the symbol_get hack of the kvm-vfio device, it would be
> reasonable for iommufd to reach for a vfio symbol when an
> IOMMU_BIND_VFIO_DEVICE_FD ioctl is called.

We'd have to add a special ioctl to iommu for every new subsystem, it
doesn't scale. iommu is a core subsystem, vfio is a driver subsystem.
The direction of dependency is clear, I think.

Jason
