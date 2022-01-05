Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31D484BC0
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 01:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiAEAfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 19:35:21 -0500
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:51935
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233341AbiAEAfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 19:35:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/aPacn20pPCqdrBmiQdoZHRC3qvECPlnRN/JUqzmyPhHVu5Sevkj4Us7wWT/SyHJcHD+uMvyD7aYH5FsG2epsBK2SuJPKbiPlA+gYkOMwrbY1WDU73pSYxUx+assV/3OzjKkJiXb3mHzDi/qvi6MfAW2dGCTrFyWzpW/m96MEMk52//F3VDrvX7oyDijJGI8jKl19a3T/g54nfU7RfEMEzvG9iGpXVsGAHdwHwinNesWweg9Biow8pUCrd0KFwpxSkGQPEGtQOrKIoFO9nm9Qk7I5zMmsvH4S1YylQy5I5zmaKzmeZ++bui3brZkQMnzC1t1RtUatF+b0zwTWLpeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HCt1endtkLN0WZobU041Cj/u6/PSXscaHa8oJmIOSA=;
 b=oXQT/ntefneElREHkwlP9Vp5606B3gdlx7GXXEx2hAiRc8+XlnhQpFIcLBMcp56MZnr7NbzeiMUGpqB9QY8JeEMU1HfagXzYDBLgWoZPGl0r0wp37L5KKLFhMMsoo4xzJ5aq4HHkRMYjv8p4R2JNs2c92mQ5hFBVbdVkW2VxzY2kSzVVnVIXV7qPt10BpEnxkx730yMvmjTAwx+d1+k5yoZlM7paq0svfSTLBE3StDoomE/qiSrYenclM4aBQtaQFRQJnSbYHCj2sIIta9kplECdcm4cZoL3qDPVESvZrLm3NyLcisbnKjyBsb//UQmcSx7i8F940gGdFCalY6CR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HCt1endtkLN0WZobU041Cj/u6/PSXscaHa8oJmIOSA=;
 b=oW3wcVtQ16KY/Xy/kkM4D+rMqfQ9zNpouKFLEUo7L1Zx5TkARalZ3+3bNCfRdQ0WfI6O+TcNk0PCWF2D1Oxhcer98LQUVuNGKNJVEDbdAVZD1ZcSwO4Qa5l45Dd4QfKhj0F6iGQuAIuKllqLCkDlYBtIdeM5TNHR1gBfdXeggGLuBb/L3Do//JrIMwD4zOBViLulNKoaLolyf0JlAVKPAz//VN822Z0QqbnBtbO+ioDERjcUO2FERmZNFdi+6nenmWc5CRnbuMkmHw9WobFdCvW2VqRxqLe96tpUtjqa1t4sCqo05l54skANqkZNpf8IBFQ0b1QCUOlifvgFnupK7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM8PR12MB5494.namprd12.prod.outlook.com (2603:10b6:8:24::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Wed, 5 Jan 2022 00:35:19 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 00:35:19 +0000
Date:   Tue, 4 Jan 2022 20:35:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20220105003516.GN2328285@nvidia.com>
References: <20220104192614.GL2328285@nvidia.com>
 <20220104195130.GA117830@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104195130.GA117830@bhelgaas>
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cbd900a-686a-4fc5-36c2-08d9cfe33ff4
X-MS-TrafficTypeDiagnostic: DM8PR12MB5494:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5494D8DD1C823FE8DB9DC17FC24B9@DM8PR12MB5494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uz+jICspxd6KiYmf/Ais0HyhuciS0BISd8+diD/c6KWiijrySwhuumK1Dn4oBehGvKWpbKvIxso+ZvSH9peLK/QZlBGbT4ugcXusvk3J/2ameVaje2DPz56fkZcMoYbUGFC8TwFjGRBaYFsJg7accE3YodSEkom0KMlWQdo9oJJXMc2vzqiU+C/fgdTRLWrdQYrPAQZgP23eqtgaxA0/Tt+QgxE2mLotOt1pwjbyAQdA9Yy02aGqBtdM2UwE0zejItnRkS3zTlEKu8YtCcv0hyJRaBX2p40BBLXgTIeO5R7WKJO4vUK+MnC/anq/5mkZRMRnACD4SkiM+RJoeNtGwsIXrXpCpo1Xcb+fMjYWpk5fDRTCOf6vWuPhabnASgFdwMng5ZiyVqEEncUAt5FWTXt4Wudfd5kYBmvp6FMYoPvKGNlYVzrFCPQx2G/ApimDEThqx79uTDrYWoONR6UIyHiVBUOn2nKX2ZTHAb44tNzwXJTicwT2/XJhiRM+LneWA12zt+oBsottYdXMP9fpT42QJto39A7xhDhrWJyC/DCQ02fyYLb9hi6yHt9CkJHt0eUtiDrQJpaBoWPbm1VUhlVc+TMDcG6Kx4SaQdnLCQVtmnuQobjQ5/JAW/95XcfRjE2rD/taHOUh5Tkhcc9rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(66946007)(6486002)(2616005)(36756003)(6666004)(83380400001)(2906002)(6916009)(1076003)(6512007)(7416002)(66476007)(66556008)(26005)(316002)(508600001)(8676002)(4326008)(54906003)(5660300002)(8936002)(38100700002)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hqLtM4LV5HnjtSNcf7TZkJccrBATc3Hux1HB8AJGOlPze2X12Y8M94p41pME?=
 =?us-ascii?Q?Y2DbWjchiyCZFzk/XpikSoVOLKKZvwMc7fdNPQdl3WWDZmqcp2yWXnKVp7zc?=
 =?us-ascii?Q?sgp1rmuMyzw5cQrG8RAxVIrjimfmBIj6LFd9AQLATc+OtQKMfWLKEpX+9MAW?=
 =?us-ascii?Q?xLuEdpr+LG9xLndS7+NHTp546TOfeZVFVGtVOhELrQLp8x5/5QGq4rGwxSGS?=
 =?us-ascii?Q?0G7PFgeUK4vijf6PzdX6kBJ1leIXtLTj5Wdm2mqEO2yloAiSSwg8RGmfphov?=
 =?us-ascii?Q?hd0JsQmGgIVb1+VrxKG/BJutaWhsJicfH0Le68/SVT7xpV/GcDoGbjrp7aOX?=
 =?us-ascii?Q?qSq/fQeovC+ZxGdkuO7w/b51d5v5WEc54EdSkvt+VHfj9Oj/2meZwK8n0AQC?=
 =?us-ascii?Q?0X/pC6oZVh9Aq7vht48e13Onz7bfqAv+GvvLQSOmNnoHx5YXqO+TRFXxMtfI?=
 =?us-ascii?Q?MXtxyvFkO26bfKWPJxnumjySMudZy30U8A62YQCNz1RqHOHQnqY1ILXJlNrJ?=
 =?us-ascii?Q?xGFk2USvlPeQKYoBqxjG7L+xzju9azTjAJCYEe3F3FBhBQ/W6aqmBnnvwrl4?=
 =?us-ascii?Q?POz+7CIbXZe6KzkE412vvLB8cKdwkgh9UZE8Ydh/GsGnOUr8SadatRq/xV6e?=
 =?us-ascii?Q?PUiLIcwJbbeujueBhjkZk3n8Go0K5v70Q99RR0JA+hi/tVR3HAfdN8lSPI58?=
 =?us-ascii?Q?xzqewHTIYb++7HrrsrRpIcxv69rAfoSSJJ5EtT71YQ0wjx9YruryKGFKObh0?=
 =?us-ascii?Q?x0tJSVZn3P7a5PPTb4nw5f5lMzVYbw9KIOsU9tkit9fXLq73QraAGv4BgUGp?=
 =?us-ascii?Q?rI3gsI5WJer2INhjRwWoMWC5uFHgSyCjrl737fO7y62Y/EK1R4oTLXYLgNy0?=
 =?us-ascii?Q?T7iClbNlCKKG24DMO+57YVtDKwhpXvZlwEJFRqAymuDZmCun6grN/m+Zc5lS?=
 =?us-ascii?Q?DPFPdYseOzeTkrCG5xNVidHpQuQfSESlmOxZdps/yMBx39FFtAutyQTGUnkp?=
 =?us-ascii?Q?9pCXl/19MWTEzYE9VvqwqWVvgdvylwWyhQupm/sfshvD0q23MmLMYLyHxSdC?=
 =?us-ascii?Q?DANTfyYPEdkwnKSHexaybkoZwZEKfZ0SdtEUAS9EjB3BjMt/2l47Sd0Ohk0q?=
 =?us-ascii?Q?wfTmPY6PqMn/x/ocq7B4a91luLpSX0w5SHaaJrzG72wyOFeGFLPe1c7G/Fx1?=
 =?us-ascii?Q?gbHVaAUep6+kT1AcR+w5/lKHQBie0LgHYNBEBqDZ5FaQY1YFEnJSteo7a4dO?=
 =?us-ascii?Q?tU18rYRskEW5kuNECjqBCe+t8SgUTxVj0DKI5aYagoLb2VN4UlLdmLvConjF?=
 =?us-ascii?Q?+rYrCMNkPXFe3DWwSAhJ0MRZHFDEGO+Lu/LjaB/LpaL1bo7YLI8HVpygWi2T?=
 =?us-ascii?Q?jOKyE+iUedUNUnaf/LPfl7ZZd84ETb21X93e6Y7yMOyPuIws4fsQ+M5AoJkv?=
 =?us-ascii?Q?eidWjL80cn9EWY6wr1V3VsygOrEIUBfXnmeRcvAByNAOwjAG+IMUac8VSSLh?=
 =?us-ascii?Q?IxvihXkMiDigXUfoJKz6i8icfgcl4+k35TRSe0mYYwSxyM4W/JaT44nHh+O3?=
 =?us-ascii?Q?wLGLUCn23mAzzrPp1dQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbd900a-686a-4fc5-36c2-08d9cfe33ff4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 00:35:19.3080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEXkkHblMyiOGb5q6WgUByJpXb/UmAviozTxVh2RRYliQUDRbZ65oOAXiRA1EXuD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5494
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 01:51:30PM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 04, 2022 at 03:26:14PM -0400, Jason Gunthorpe wrote:
> > On Tue, Jan 04, 2022 at 11:06:31AM -0600, Bjorn Helgaas wrote:
> > 
> > > > The existing vfio framework allows the portdrv driver to be bound
> > > > to the bridge while its downstream devices are assigned to user space.
> > > 
> > > I.e., the existing VFIO framework allows a switch to be in the same
> > > IOMMU group as the devices below it, even though the switch has a
> > > kernel driver and the other devices may have userspace drivers?
> > 
> > Yes, this patch exists to maintain current VFIO behavior which has this
> > same check.
> > 
> > I belive the basis for VFIO doing this is that the these devices
> > cannot do DMA, so don't care about the DMA API or the group->domain,
> > and do not expose MMIO memory so do not care about the P2P attack.
> 
> "These devices" means bridges, right?  Not sure why we wouldn't care
> about the P2P attack.

Yes bridges. I said "I belive" because VFIO was changed to ignore
bridges a long time ago and the security rational was a bit unclear in
the commit.

See 5f096b14d421 ("vfio: Whitelist PCI bridges")

> PCIe switches use MSI or MSI-X for hotplug, PME, etc, so they do DMA
> for that.  Is that not relevant here?

Alex's comment in the above commit notes about interrupts, but I think
the answer today is that it does not matter.

For platforms like x86 that keep interrupts and DMA seperate it
works fine.

For platforms that comingle the iommu_domain and interrupts (do some
exist?) we expect the platform to do whatever is necessary at
iommu_domain attach time to ensure interrupts continue to
work. (AFAICT at least)

In other words we don't have an API restriction to use
iommu_device_use_dma_api() to use request_irq().

So the main concern should be P2P attacks on bridge MMIO registers.

> Is there something that *prohibits* a bridge from having
> device-specific functionality including DMA?

I'm not sure, I think not, but the 'Bus Master Enable' language does
have a different definition for Type 1..

However, it doesn't matter - the question here is not about what the
device HW is capable of, but what does the kernel driver do. The
portdrv does not use the DMA API, so that alone is half the
requirement to skip the iommu_device_use_dma_api() call.

Some future device-specific bridge driver that is able to issue the
device-specific MMIO's and operate the DMA API should be coded to use
iommu_device_use_dma_api(), probably by using a different
device_driver for the bridge.

> I know some bridges have device-specific BARs for performance counters
> and the like.

Yep.

IMHO it is probably not so great as-is..

However, this patch is just porting the status-quo of commit 5f09 into
this new framework.

What this new framework does allow is for portdrv to police itself. eg
it could check if there is a MMIO BAR and call
iommu_device_use_dma_api() out of caution. It could also have an
allowance list of devices where we know hostile writes to the MMIO are
known harmless.

Without knowing more about what motivated 5f09 it is hard to say,
other than it has been 7 years like this and nobody has complained
yet :)

Jason
