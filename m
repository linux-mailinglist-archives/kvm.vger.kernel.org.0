Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C204615B2
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 14:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbhK2NFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 08:05:20 -0500
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:23392
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350487AbhK2NDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 08:03:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7l+xqZxnCXelcDrQQpgHdTjzrwdTrGvLKeRwe+/fC/LcFTzJRk3iUAVUu65RVEV09JDP+AgjGNiL91NArucHiX/EjqsPdCkYbWAFYTkVpUqqyAHq/517EX8CxiAubyFp8h7nuogv86mzOvjmYe9MDsiypKrWV6bNDYRl9y/bVioXLCgJrA9dkZ3BiqcmQEksCxRmBxNrZ+H+CJwg4ThEvPfuHV6cU23V6jCA3RYRIF0op1kL1PVf026aI1osXfei8aL+n9Mh7b9HiiZh8MOYShmQdVIGlad6U+lNZP40lZY/eO/ZOdQm7csvDUJ7v9Hu/sC6KpBbPNrcBHPRjrUOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/bswR6sd8pOUIcroDh34UG+IDB6uqffqEm0OWrgWCM=;
 b=A6uUA6YJlc8yym4tHlnyUICwemP9/2UMInmGRmWJJolK/ULaGPQLCTozlV/swGCpZeUmCNPCm5tiJ1i7jw99BXwX8DOCnNWSfJ+Gpug33sdpoG7uvx1Jvd91isx5CZHQxdxbGKz9s2ThNe9B+iPDDeJxe3iMF9iVKwm5ppamPyJbV5mUcbdE0mTmWnk/5qN2NTxiAo2WU6pUIWmaqodKz426aLzio1liWA1ov9rqIRVI+eJLTYbSlGSBw4lzSYVkHdyN4Lzb6z6hRyCGD1rWc7uS4D2CzdkwqPk7GMyfolp87yc54zUSleDhcEo/XAk8rSdlh4KAlmfStBfMnDzuOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/bswR6sd8pOUIcroDh34UG+IDB6uqffqEm0OWrgWCM=;
 b=uigwqjayQSNXvW57og+MmGYYOIgyU4J1WjuXrmo7queJJZrj/cO27+Udu6arbjBo5s2629q1c0aRZj69kLwYqY9IHxE2gM2/EE54NJB8AZC+qn77tMSWoe0qSlDvMEl1P26jJtJXtSOVkW/JWHGscAtizaCmjk+Fg2MBn08wduEYDXOd8i34fo1fKlu8Jp6BNNI2i//qQkwsCtgl4rCI+o5TWY9PxteRyoTiyHMZz5Kg6bhHV7I0RBNPZpSqybEvsgAca2IjU48sBhQK485aE+x2tMBRhS1TmsjYUkT2QPsznchKOWapVcEEtl4BkzAndLsPDwfXYptltVL850E0dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5335.namprd12.prod.outlook.com (2603:10b6:208:317::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 12:59:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 12:59:59 +0000
Date:   Mon, 29 Nov 2021 08:59:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] driver core: platform: Add driver dma ownership
 management
Message-ID: <20211129125958.GW4670@nvidia.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <20211128025051.355578-5-baolu.lu@linux.intel.com>
 <YaM5Zv1RrdidycKe@kroah.com>
 <20211128231509.GA966332@nvidia.com>
 <YaSsv5Z1WS7ldgu3@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaSsv5Z1WS7ldgu3@kroah.com>
X-ClientProxiedBy: MN2PR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0027.namprd15.prod.outlook.com (2603:10b6:208:1b4::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 12:59:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mrgGE-004F8P-Bu; Mon, 29 Nov 2021 08:59:58 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 236dede2-1e0c-4a47-76e6-08d9b3382685
X-MS-TrafficTypeDiagnostic: BL1PR12MB5335:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5335AA362C51C8FBCA1C02C7C2669@BL1PR12MB5335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WG2ESH5YHbmM/Vy1+p21M/G6uLSiB5VWvYKjFP0JqhTN+ZBEmfv6yZDlv3KSA9t09tcnjIpQ7BFVLEbM4/xS+9ABsLdETpXhcsBfxqFnJGo9yxZAJcABC9F4nqzWdK8061trs5B4s1I2G3GoeGXw24e2P1GP6A6X/R4x/u/8y4L8xuXijODTvZ9DU6xm3bicsPoGavWMfVjj7Ej5yZ3oQfKkQlpURo8qoQh9X+o2s254y+W2uvmufNKa/AhyG+YcLJSWKDnVNpz28sI7anC3b65UvZY5dlBxBuiBw9EX76P9lT1Q72MdEsde5O74mpMEG8I57xfqa9+Q/9bZeVDP1hX61XR054KnTXRiFrP5j13fhzBVGS3AeSj/gRgImsLbZqX3/jxOvKMYgFRiAsqFPeuGJkG2k/b8XO8UdrB9/hze5+SvW4l7FzF38Lte3xpQMmpUMj+zUZNiVtoinowcrY7tKkdOQgXVFecvfF0TbqdWS1SCx/YfBA+m7dHJzvB/6bllAVqKTqvGgpRMSCcyxEvLU6/IIlin2MIHvGz6my00wlTotgWY5vEcL7DLAmbYE94swIsb24V38buZ1cId5nmmxdiTZvvhdCSDB5bbQpuYizykc1a5mero4ZlrjdDywl0TRbbK+gGDIepQZVsxII4OJ2kaX/BYdDB+ZKRibmJBpSGbxUC/1G0EFkuItOOt+ekW36Vv8YuRY/mk1ikO1dmsN27rkpFVJyQXtrFG6vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(426003)(36756003)(38100700002)(8676002)(26005)(2906002)(966005)(1076003)(86362001)(83380400001)(66556008)(66476007)(316002)(66946007)(508600001)(4326008)(9786002)(5660300002)(8936002)(186003)(7416002)(6916009)(54906003)(33656002)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ca5rJcTwgYCpueMG2ick/mZHf0JJ/wvS7lyUXjXmc/I33Mzzbp0nV7fIOX6L?=
 =?us-ascii?Q?Blbekw3aMDfc9Euso/F0eLAhqJOQ05YN5evITKFUN/y9YWT5shbBVGWbQHCw?=
 =?us-ascii?Q?2DjQggbXWKub3mcEliuCfrv0DyT3hmN6R/AvTLTqfkFb/j1KHWbxpLnMgFLE?=
 =?us-ascii?Q?VjnErPO+fzG4kPPEZNbPcvdu2dd7yhG0ARrL2dsHAHINSZ/+l9YZpC5uaIOc?=
 =?us-ascii?Q?p0awdXcl0EFlPoHRniPhPg9JjYl8SaG80y94ATScfWIgNTgT+0i4xdXlVOP9?=
 =?us-ascii?Q?8aX7DekDzXaVzmriy2CrAbkz5XVumK4K/2sZJW9RDmInqBe8Gl4fmJ183bFR?=
 =?us-ascii?Q?+OwCOAT3maJODOPpzCbt0fcTqku4IRcyt5QHaYLNLSjBepsAYUeftVWbjMpo?=
 =?us-ascii?Q?xIPwXm0QZXNSDaGxnoqWFshD8KBYFgVhPanuPMLOONgzfdUwnFKtuvLhb0C4?=
 =?us-ascii?Q?tdJ8VJ4OhpGSCBgApQH5h0GP4Kho9bK/ILY2TfGNcjN5cw384XNq6+j7vnUt?=
 =?us-ascii?Q?+cU2sZZeQFr5gRdjnfWMD/oub41pWZoAqSB7oAkahh1k1GOU5Owo/6FhUBil?=
 =?us-ascii?Q?7fMFC+zz6v6ZSxQsR95C+F+LByHtUeWTJ3jlsxKH5yOGwf1MDWJf5NUaJ9Ca?=
 =?us-ascii?Q?9Ei9zHEsNB4LDxpTG3x5j104LYmf0JvPu3ZK8Mk4wJbYLQypgTu/dMHfKjMU?=
 =?us-ascii?Q?aucjPSl1t4ikujLJ4TVYnYv0nctKI6ohMgapaFPBdKpyodR+DsAYZeN9WUlH?=
 =?us-ascii?Q?pfySURpT9aUNMfPDi8GcGgnaSyFCky/W8+GI2v26Fs8yGuy2Sb9O0W/BNZ28?=
 =?us-ascii?Q?hl+z6b1iPbMW2nvGqyTRSSaZkq619Y8tLhn5QrWlx7s5Hiwjn8C/x9JF5BZG?=
 =?us-ascii?Q?9byUYMR4JkaRH6Mf0zee1G0/Vz0lbjYhmNf6lWFdhQOLV5YTyJKxhBxvalBf?=
 =?us-ascii?Q?uvgBriwr5XThD55S7F5Q39wHEZeF6YtCVpTlyT2hed4u1uU5QIYChaiKkr2b?=
 =?us-ascii?Q?lAPZNR7k2umHmwhceLoYBRu75OmqR0F5n3ENjB97OX5k/MsaO4VG76wA518I?=
 =?us-ascii?Q?Zxflu9GOfdEYTU804/wWVtM24hTaKVnF+ekJTHjQDMcDgqoEQyxP0gANeJtW?=
 =?us-ascii?Q?e624PjaJQSlp4iSEdFkmBXM7nYrhJN7T95wB+lkRe92Hj7I177/vnSEer7yI?=
 =?us-ascii?Q?YWYqqnh6O697Uo0JOU4775plclCpo5lBXRtm/7T2aOwEcj/CI+bNQr+u1JTo?=
 =?us-ascii?Q?kqGYIvZ1bdHZLsvr8yRpwCECV3XePl2nF8dvnlpnCL8/s1xPBmSXkQEfbQrM?=
 =?us-ascii?Q?rFTK1IV+KL2kq6F3CLho8QHJZ7/15DBJNGA2Wfe/Bielxld/spNt20GsDUX9?=
 =?us-ascii?Q?sA7/+f8nNIDcSerSVhqzhe3+whjLo6Jf9U69Y+F+mLAQ5QMr3RihRrXs3Pqw?=
 =?us-ascii?Q?KPBAYMN8ZK9F4/0ofMCNKtLDDWsGOXMQ/eSVg6Ed44Xtiej+OeXmppc7zdRF?=
 =?us-ascii?Q?6PmtmyBuvs96a+pTyXaqKAD8uUEQ94GAT468ku792zrQBXJUHcUxblFuDG3u?=
 =?us-ascii?Q?si61puTFDmmt2un3xgk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 236dede2-1e0c-4a47-76e6-08d9b3382685
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 12:59:59.8135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4uKQzUST2JJCIPfznwGQ8JswObaRovABb9leWOZYhy2A0SStBWx8gieCb2zkOGg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5335
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 11:34:39AM +0100, Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 07:15:09PM -0400, Jason Gunthorpe wrote:
> > On Sun, Nov 28, 2021 at 09:10:14AM +0100, Greg Kroah-Hartman wrote:
> > > On Sun, Nov 28, 2021 at 10:50:38AM +0800, Lu Baolu wrote:
> > > > Multiple platform devices may be placed in the same IOMMU group because
> > > > they cannot be isolated from each other. These devices must either be
> > > > entirely under kernel control or userspace control, never a mixture. This
> > > > checks and sets DMA ownership during driver binding, and release the
> > > > ownership during driver unbinding.
> > > > 
> > > > Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
> > > > claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
> > > > the userspace framework drivers (vfio etc.) which need to manually claim
> > > > DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.
> > > 
> > > Why would any vfio driver be a platform driver?  
> > 
> > Why not? VFIO implements drivers for most physical device types
> > these days. Why wouldn't platform be included?
> 
> Because "platform" is not a real device type.  It's a catch-all for
> devices that are only described by firmware, so why would you have a
> virtual device for that?  Why would that be needed?

Why does it matter how a physical device is enumerated?
PCI/DT/ACPI/setup.c - it doesn't matter. There is still a physical
device with physical DMA and MMIO.

As long as people are making ethernet controllers and other
interesting devices enumerated through platform_device there will be
need to expose them to userspace through VFIO too.

> Ok, nevermind, you do have a virtual platform device, which personally,
> I find crazy as why would firmware export a "virtual device"?

Why do you keep saying "virtual device"?

The "VF" in vfio refers to language in the PCI-SIG SRIOV
specification. You are better to think of the V as meaning "for
virtualization".

Today vfio is just a nonsense acronym. The subsystem's job is to allow
user space to fully operate a physical HW device, including using its
DMA and interrupts. With the advent of DPDK/SPDK/etc it isn't even
related to virtualization use-cases any more.

It is a lot like UIO except VFIO can operate devices that use DMA too.

> > @@ -76,6 +76,7 @@ static struct platform_driver vfio_platform_driver = {
> >         .driver = {
> >                 .name   = "vfio-platform",
> >         },
> > +       .suppress_auto_claim_dma_owner = true,
> >  };
> > 
> > Which is how VFIO provides support to DPDK for some Ethernet
> > controllers embedded in a few ARM SOCs.
> 
> Ick.  Where does the DT file for these devices live that describe a
> "virtual device" to match with this driver?

The DT describes a physical ethernet device that would normally load
it's netdev driver. If the admin wishes to use that physical ethernet
device in userspace, say with DPDK, then the admin switches the driver
from netdev to vfio.

The OF compatible string 'calxeda,hb-xgmac' is one example:
 Documentation/devicetree/bindings/net/calxeda-xgmac.yaml
 arch/arm/boot/dts/ecx-common.dtsi
 drivers/net/ethernet/calxeda/xgmac.c
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c

We all recently went over the switching mechanim in a lot of detail
when you Ack'd this patch series:

https://lore.kernel.org/kvm/20210721161609.68223-1-yishaih@nvidia.com/

(though vfio platform has not yet been revised to use this mechanism,
it still uses the sysfs driver_override)

> > It is also used in patch 17 in five tegra platform_drivers to make
> > their sharing of an iommu group between possibly related
> > platform_driver's safer.
> 
> Safer how?

tegra makes assumptions that the DT configures the IOMMU in a certain
way. If the DT does something else then the kernel will probably corrupt
memory with wild DMAs. After this series the conflicting IOMMU usages
will be detected and blocked instead.

Thanks,
Jason
