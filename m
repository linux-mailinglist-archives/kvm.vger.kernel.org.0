Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C7A4B513D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353932AbiBNNL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:11:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiBNNL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:11:27 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0566CCD3;
        Mon, 14 Feb 2022 05:11:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6hIRx8tSXBBaE95AoYMomvDRoeyI6Bzdxn1+6wmucnlfiEy6USOYDq7u8VKvMpujLHGecVtfBCPl6aHM0D3L7NC5QST81f0jaBRMkSWlZI3qGcE4QXtuKvwD6+s+wdKO9Un1X1rFp695g8ReJfOlfYq+IU46HByEh8wGDHHPgq1iYKfW3AeGYCfJKvhQzPbanNHXNkZP8mxp0WOmAb0B2AtUNuiPU2hHLcowX/S69dTIexpPULOgITqDGN7LIOl9ksJaD2rzSG9Y9gM3vznO+FM0cyyy4NSsfCXZShJjnfElPumFjC+5NY1eHzMk1GuqdR0OVkOeQjlfGneZUrqzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rcms/YUKb8ALQ5IrLcuMPAkKLbobmzKSFDyf4NIZXnc=;
 b=gO20NaVWEeAjNmKmBseARsgiPXAMXUdz3RDJ1pYM8eoDw9DXl9cwoOuF+zRdeDcEXrn8UQyVYfHcOOJ7ymSKszDhQw8hqP4DWcdpibmgLaoQmQ9uIic4ZvqEGNBk2ZuyGs8EZpXwN0mjqa/h4lrin/2ej8iiDb/w1nAOlPNQa3lTBYa+zMzvTlv9QqsH13ZNVJr46L9QJgszAd5ats4Q+zgDJFSPdWp4bc3m4bNKXjd0NcjYi1i5Wgunz7PMM/7ymM+AMVubwmd7Miz/BcuDbtX1fdAwvqxTO0P9A9T35Fokpp5mNb7zPcUxB7hZe/m4Cl6nKkXPxzAsUwf1yg9spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rcms/YUKb8ALQ5IrLcuMPAkKLbobmzKSFDyf4NIZXnc=;
 b=sO6LadfU2OBg2F8RYoIoj7foIKzFb6SkDEnALC5ZT3GbWejVBOQZEC0x5nsmXQDzmeLu0EwUV/xsZafL2qiFfe/nGHhdmcNvAaMb444KTjyRgQ4MjoQYuX0WrbV4MHM2NcIWxCFa03ekAYZDXcxsZrIhwo0shEfHS1wAeEulQ5n3LYxhYTorXO2ROYylVxGzkEDzi/zNJXwcW1vk0grfqZXoTNkR2mBh67/rnfwsOaclSwYkBCJHBlNBElO25OwGclFsuPYyS8h2GSDDh5aTrAN390pPkrBGkb1XrYKc04LznUGrsV1q3dBEF+0AUOoAq0e0mvRWHpibnz2xRpjPNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4762.namprd12.prod.outlook.com (2603:10b6:5:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 13:11:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:11:18 +0000
Date:   Mon, 14 Feb 2022 09:11:17 -0400
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
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <20220214131117.GW4160@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <Ygoo/lCt/G6tWDz9@kroah.com>
 <20220214123842.GT4160@nvidia.com>
 <YgpQOmBA7QJJu+2E@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgpQOmBA7QJJu+2E@kroah.com>
X-ClientProxiedBy: BL1PR13CA0320.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23f6ab3c-7206-4d9e-492b-08d9efbb7cbd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4762:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB47620B69302CD0C8D84BE328C2339@DM6PR12MB4762.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddCfqyE+9Kdgb/tJyDMzaFq76npJ+aXFqhAxDQ6iT0oMrYSMMrngoj8ZfI9Sao3xCa+Z6vcVNtgcC4ir/aGP2KgFIB9rkJB8Qf2/vLuQbYCa7nsfnBb9J/2s2/dwdhADiSUEroxhxPoFkBbIsPPDi5Z98E8vj4b4R5TY5TvgzhqWuqbksvMRSIkHCHThfaFYelp6s31UkpuwdmzmZqV4FoHiiMR1pLLlNaN+rX2ecxAT5OTCUHr/fnRskoK/eXk+wyt2sxH37er3ku+p1+DlrnH64wDCdbBvjq9sYiIfgQiBJzTxv1z8LBa4AikpaXw6JhT1phOH+hOrljBy5yjGHvMF9UDel/68mA0BU6hqmiNwUXpkwO72YA/g2LtU0cnwL56SDVHLfsAPRK0u9uxpKJ28/Z2od9IWkxzRtpP1/G5W0SgTqVyD/L7JGWkQxNy5pPqyhWARncLJjdGfXBQ8+MqCH/wQAA4Bs/MKBk2ko0xfDLJ3jomMoU9E6Rb2QoCMS+Vpo63lPfuACfqwoFaWHo1Q6dhVEr4zlq8tnxr2Sn2I+yUs8Lnv1vP9AXSoZnCoFU91iU7siYNfvAgpEr4n6Y3Er8q6ua5UXNalQkHxIp4sU7doL79ns1Sw4mhizMCl7U32PqR6VtbwcnghPD2cRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(26005)(38100700002)(36756003)(186003)(6512007)(83380400001)(86362001)(4326008)(2906002)(8676002)(7416002)(8936002)(508600001)(316002)(2616005)(66946007)(66556008)(66476007)(6486002)(54906003)(1076003)(6916009)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gg9PGY4oy1GomsZ+ItMhTRhs+gdVPDWRI/Y/hGpTy3j3SV3MLcRdjIhhMXM4?=
 =?us-ascii?Q?U9tMoSMcRZXABFss0x6aryJeTm4vzLE7Al6jlQ2nAOS3eJSMJp8Ywm+OjSQK?=
 =?us-ascii?Q?Gw15yAx22vHF2HpbLeujlGsg8l8B3W1yw5IhQ6mXAPVflU6HPWuejWiPSD1i?=
 =?us-ascii?Q?v0pmCM+d3AGALPyLI6QR4VgXHkht6A+eKijjAbBXfvJ2j3brGjQytT17scYg?=
 =?us-ascii?Q?rNBn4eS8ahhSXTdPZllB1ksEePRp7SYVOwRHDTTnMbUlyOH4kcy4uPCE0+H7?=
 =?us-ascii?Q?poHXTvfej8Zqt7IbSKknkhheul5BaezIdVg0szPwQXg6oh+6igUmEeiqgimS?=
 =?us-ascii?Q?WyklCuSwjqa8s7eDy481qBZs6VSafS5SikFSxodpjBwYrfHThohFtxdwgv5Y?=
 =?us-ascii?Q?wTGe2bO/3dlovvDHKS4lt1lfDU0RH07+UNSiaLcQzH0ZYbtJ+9QwAkOL2Yep?=
 =?us-ascii?Q?+tk9Tjag+JCS7753L+RVAV35mSUrVP1DpWGd/hlc0xhWoibyWmyZI3AJjZvs?=
 =?us-ascii?Q?aVnpeykuJ760mHykw4pqMrW9eEN1jSj9PIxKF4s21pB/7aXpMj2k2E7j7iZ0?=
 =?us-ascii?Q?obw9YzE8lC9YpSW1sMb7B3sBTnDxkep00YZRxoJuL0n2A9TEWmNwRgRyxaWg?=
 =?us-ascii?Q?Madq6nM3qgVFKMww6YVukBviWfik/0lGKdGT5c5PDQc3b9szVuB1hGCqFs1F?=
 =?us-ascii?Q?oG8mReEK4yU1dXPGb9i/G6+pzM4KsF5ljzyGpK2MyjN2tyXST/svHAArEPAX?=
 =?us-ascii?Q?zSAfpdRDJ5/dLyut+dJMJ63ZQptbqMnGVjDlHsYqn7h3Yv0ZI4FA9emr6eDI?=
 =?us-ascii?Q?9KuQSv6o9/Uz/XfdwNPQ5kVov7mGLcGOescT6ogbaLnBdjvqc14+Dobg8EgL?=
 =?us-ascii?Q?H0oayR+J7RBUeoqPV+dcpYeIUJ7qRZJT5uavtAYoz5de47wnAA7bU9oeDqER?=
 =?us-ascii?Q?GMgHpJks1fCmkX9p0/lMNJ31b7b8vlhRcPFlNie2/UvR5Qvn3ISLbKSkOFCL?=
 =?us-ascii?Q?eGy5uhdao5xXwLmUC+gJ29LAe5/3i4SD+Ag17DfpQvhfO+CL+IwEoDRck/GQ?=
 =?us-ascii?Q?jsBx33LEQIsN2eOLjPqec/m+rC0zAlTA2Y7wB12u4dXJ5d38DQ3cSB5uiniM?=
 =?us-ascii?Q?DhcW7iCzRJzd6hOS3jNTEx+NrzKrhEbLDDk4uBZKA7junpZeFHyCZ1xech3w?=
 =?us-ascii?Q?zHSJgT092DhW0VyBx5WnTpqnj1b4V4TFL1oAyDIbYnzXObELj2R+O6nLYmIA?=
 =?us-ascii?Q?JAE6YDycIDWqDCILyWwH9jvUbva2DmXGbwBAEoQvAs5MdxPghruT5WjpyAfT?=
 =?us-ascii?Q?7HUCSsJHip8pESaAHq75Wkth73VRdJCFcl7HFZV+bQkRpiDnvDWLpZZPLaEF?=
 =?us-ascii?Q?9AOfW+WGNGSLw3U8j7gpBMUfVGAJcLvjIMerLYwLcmlOcwIuuwODh2M7HCO/?=
 =?us-ascii?Q?eQfd49P4oHIRupwnqpry+vv5p3kQn5T0vBEVNDwRiOpyY/dy6T2ai5ACIqm7?=
 =?us-ascii?Q?ytT3g4jTtijanZ+Jg/xqE23uuwpFmSzpQQi87eRzTtBbu7jyC6az6exNlVgj?=
 =?us-ascii?Q?P42ExSPcCkaV/wkBIrs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f6ab3c-7206-4d9e-492b-08d9efbb7cbd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:11:18.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeyYaivzys/sKaIRFJKLuyzs1L9NhK3QPt7K9q7dw8wDrrq2tTEloI7yEFdt/Emr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4762
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 01:51:06PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 14, 2022 at 08:38:42AM -0400, Jason Gunthorpe wrote:
> > On Mon, Feb 14, 2022 at 11:03:42AM +0100, Greg Kroah-Hartman wrote:
> > > On Tue, Jan 04, 2022 at 09:56:37AM +0800, Lu Baolu wrote:
> > > > Multiple PCI devices may be placed in the same IOMMU group because
> > > > they cannot be isolated from each other. These devices must either be
> > > > entirely under kernel control or userspace control, never a mixture. This
> > > > checks and sets DMA ownership during driver binding, and release the
> > > > ownership during driver unbinding.
> > > > 
> > > > The device driver may set a new flag (no_kernel_api_dma) to skip calling
> > > > iommu_device_use_dma_api() during the binding process. For instance, the
> > > > userspace framework drivers (vfio etc.) which need to manually claim
> > > > their own dma ownership when assigning the device to userspace.
> > > > 
> > > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > >  include/linux/pci.h      |  5 +++++
> > > >  drivers/pci/pci-driver.c | 21 +++++++++++++++++++++
> > > >  2 files changed, 26 insertions(+)
> > > > 
> > > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > > index 18a75c8e615c..d29a990e3f02 100644
> > > > +++ b/include/linux/pci.h
> > > > @@ -882,6 +882,10 @@ struct module;
> > > >   *              created once it is bound to the driver.
> > > >   * @driver:	Driver model structure.
> > > >   * @dynids:	List of dynamically added device IDs.
> > > > + * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
> > > > + *		Drivers which don't require DMA or want to manually claim the
> > > > + *		owner type (e.g. userspace driver frameworks) could set this
> > > > + *		flag.
> > > 
> > > Again with the bikeshedding, but this name is a bit odd.  Of course it's
> > > in the kernel, this is all kernel code, so you can drop that.  And
> > > again, "negative" flags are rough.  So maybe just "prevent_dma"?
> > 
> > That is misleading too, it is not that DMA is prevented, but that the
> > kernel's dma_api has not been setup.
> 
> "has not been" or "will not be"?

"has not been" as that action was supposed to happen before probe(),
but the flag skips it.

A driver that sets this flag can still decide to enable the dma API on
its own. eg tegra drivers do this.

> What you want to prevent is the iommu core claiming the device
> automatically, right?  So how about "prevent_iommu_dma"?

"claim" is not a good description. iommu always "claims" the device -
eg sets a domain, sets the dev and bus parameters, etc.

This really is only about setting up the in-kernel dma api, eg
allowing dma_map_sg()/etc to work.

dma api is just one way to operate the iommu, there are others too.

Think of this flag as 
  false = the driver is going to use the dma api (most common)
  true = the driver will decide how to use the iommu by itself

Does it help think of a clearer name?

Jason
