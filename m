Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857AD26C4D4
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgIPQCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 12:02:47 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:60482 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgIPP4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 11:56:11 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f6224f10000>; Wed, 16 Sep 2020 22:45:05 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 07:45:05 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Wed, 16 Sep 2020 07:45:05 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 14:45:04 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Sep 2020 14:45:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2YzPJAGbXPnqcIDIBY5ess/Fuz/3u9fjbbmVgXZbq2+MHmLkYygcDmmVTWuVnbOVvfqVt6v0ooQFcK0ARpFPMq3DRXxHkoFjjH1d7RRDu7CWBwgxej6gdxHQASuoDtykDXHTeUNvZ7RdEy/Pq6KikpIkLFbl+TjF4O6kJXADieU8SwC/XjvzxEvfQoGNn/lRhmLgaFe6SqSzRk9cn4XTq1w3dFjdw+4fxiJDWSrT3EcRUvf1Gw12g5d8IgwgSmSuXXBlQv+gXA/gcNg0yWEvXXD49pUdWgOfaOeXXj/wq/h6UojZYUsJjboDg/x7cbHd0GanItjVuJtPIRVV2P7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzYZSSVKCkJQZhZA+HDpDGnRTubhdVTgS2kIRgojQZU=;
 b=VOry+FRn9f2GiaZg0Re/ZtgOeFJLwy4uFD/DQx5nNz/Nz07xE9WZ7/kwYHdoOkOEpNzXPZOcgAJruuTmC0rFS5NtmBEqyI5mgSgg09Ge6lttupxUPXrEltSWDJPNJHeHF2XXRWDB7FiSmmdtKijypfuQ7P93p8rLCj3eLhI0RjJYJGGRvum7PATvnssPmlLc/BpDTM9kOISx/DaNfO60VIkfJw2Wjt+7PDbDKmkcMTUtdjKGjPsny/0+XFd/OvOs254R/1GEI8naoJrahGu5R1m5oxBRTnXU1xfJiVdZqatFRj+dwGkyQyfVILvAZhBBEveOWSVyfKFOMz4HcL3s2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 14:45:01 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 14:45:01 +0000
Date:   Wed, 16 Sep 2020 11:44:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916144459.GC6199@nvidia.com>
References: <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03> <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914163310.450c8d6e@x1.home> <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:160::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR13CA0018.namprd13.prod.outlook.com (2603:10b6:208:160::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.6 via Frontend Transport; Wed, 16 Sep 2020 14:45:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIYg7-0003Dj-Rt; Wed, 16 Sep 2020 11:44:59 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0b09e29-9a85-4d6e-3280-08d85a4f172e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2601:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2601C819093567713340E620C2210@DM6PR12MB2601.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cNvNlH7n8LDgEJiLuijNYu9YAdqbQqp48Y2gNVQT3YGW2izejgdLaSTF6iOTwfKldlcCeC9nn/tAEYroOQyvtxHE4hM/c71yHbER+b0tBBtYe+Rvr/dHlsJleJVDYj4xQMLEaWy2IXpFtXVA9L10UNwyoNBT+1mHLfT9eFjEpo1RYac+o6UK7n/o5pUyk3t5FH1ohQaqpa7xliv6C/QKLda3UFESDzx1Ccu/Kn5OZViFkIrR2goUe6jDFa80I4pm/C+NAwaqxeUxaj6zWdx+aAYVxygVdfFQbcBOSurbnp6QQ0J/5LH/gs2H1XJ/3mii0qJeYIKltK66Eeu+8arx/Ok6nRx3yzsNBbzBhs2YtfWQz5f8oVLsXjYxLjZw8qi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6916009)(2616005)(26005)(478600001)(9746002)(426003)(8936002)(54906003)(4326008)(9786002)(316002)(66946007)(86362001)(8676002)(66476007)(66556008)(186003)(36756003)(5660300002)(2906002)(1076003)(33656002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9CfJtNr7Tf5Cv9ytmoORqX57ruqD3acVuAdgGP9CLvtp7vpXKRcuFShUWapMOLUPmterVZunFwglND4d8aROhLThl42wB9i1TAJGjXC4CtsAMwM47DG7OUSNn1N+XMAaOu1DmfbmBWqQivu7WSO1LgLyZvjEWEbqfj2HCn3ruCDaHH/9Jk1v/0rKzE63A5rqJqvjQEaa4XdltK4iZ31uAVbKasHPx8gmqWHFxIO0m2Ho1aQqUnhpwDs9aHkFh0EgGV12Kujkz+rRyRsO4xMFzboptzVWOeYmqcOjpi2C80XC7vpCfU700ICCCG4qcVHUnCO+RL6ceiFYGbWrBH6exGQC9XD9F1cnXlV/BAqcQPtK5Hiq8UTthi9aFbv+FlShBQjN0yka2sO6XJMbLMYw5+2lKf2w2EXK/zbKP22wS1K1CHhDUsZ3CG4HeSxuSqYwmsuti7MgY+N8ObYou8EJxmS9fZeRdwj1cdVc5AgpbhHf3gT/I4Q37JFnoWZ6Ui4go49FM96/ZqXl5ELg9P0MpMQEPtpBRm7xDqouGjYnINn2M9RQ8uJETUrSSApo5xc6YJIAdycily1BHWlIbewonNeDNH3aHlZrhfN9ODFgu4PI75kgBOzMEt35MW7oggBu40sl4vmVoRZGuDISYxk4lg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b09e29-9a85-4d6e-3280-08d85a4f172e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 14:45:01.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0LHyzGiDBt4HKFlp8VzCddzRgsFdYdCqOic9NPyakJFYwGRlJ/mcevYt/rEHVTu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2601
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600267505; bh=DzYZSSVKCkJQZhZA+HDpDGnRTubhdVTgS2kIRgojQZU=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=pZcPgCcTmwgLRaEo9M7yp6GNYXx2L0qWifgazIARt6ZUv34gfZlKRWbFoM72PIFh+
         NyQqIKSX8LaiUflNgyxJJFM59KbD8c3FvA6cq84ThA+dONwT+/TUZ4MengIlwNtHvP
         XFfhBvVxYtzulNohppxoIfAsyNiW+5nZxgA5/J0KQATmoxYTgr6O2r13uWifxl9Lrk
         QezIjzieMUiui1eM6iDvUSzwGyHOqaWgH5CiA/PLhtCOUUdsung0P1AuZT64hydMF+
         1T2G2Bs8uNwT6bfa4Iw5B/I7dzPg59N81/DmCcjvDri6UsEblThhbDw9kmmNGCezrS
         zZjztDGZi/uvQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 01:19:18AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, September 15, 2020 10:29 PM
> >
> > > Do they need a device at all?  It's not clear to me why RID based
> > > IOMMU management fits within vfio's scope, but PASID based does not.
> > 
> > In RID mode vfio-pci completely owns the PCI function, so it is more
> > natural that VFIO, as the sole device owner, would own the DMA mapping
> > machinery. Further, the RID IOMMU mode is rarely used outside of VFIO
> > so there is not much reason to try and disaggregate the API.
> 
> It is also used by vDPA.

A driver in VDPA, not VDPA itself.

> > PASID on the other hand, is shared. vfio-mdev drivers will share the
> > device with other kernel drivers. PASID and DMA will be concurrent
> > with VFIO and other kernel drivers/etc.
> 
> Looks you are equating PASID to host-side sharing, while ignoring 
> another valid usage that a PASID-capable device is passed through
> to the guest through vfio-pci and then PASID is used by the guest
> for guest-side sharing. In such case, it is an exclusive usage in host
> side and then what is the problem for VFIO to manage PASID given
> that vfio-pci completely owns the function?

This is no different than vfio-pci being yet another client to
/dev/sva

Jason
