Return-Path: <kvm+bounces-4113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6CA80DDA7
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E19FF1C215EB
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 21:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5846D55767;
	Mon, 11 Dec 2023 21:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tuDuU0lt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4592FA1;
	Mon, 11 Dec 2023 13:57:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap0PnTyIVxdRJxPZT9Ae88J0WD566GxZXY4wLzb9ojUks8UQC4hMKeTiSd4CqJfT6NFA7lJdciS1smHCIBYO8wm55bGLY2P6GCooDnScThpO5GJwnZPcjqdGG3LpK5Q6sj1EFZSP2Cf0vKuXjXBoP5ydrsPeNeO7/2FfxgX/zXyPEtWKAjWU+3TAN3F6ki0ALScYk78W33MT/Mi/SgQOrBmccCKRCCJwcOJyqVEEJsVgaI/9Y7qPS9DceGkyKvIA53Ji9H+MXTDrolnwobOcFvMiu3GjxVVUuswEoZP9kY94Ap0FU1u7ME9HGr/UndKgEAm6ENHcMzadE3lIQrDcnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlL5eLRoUdedfh821ze9eHzie1om8tI74i+byygAh0o=;
 b=awma7i/mjYA4Xgopjs7ewL9RDDo60JSe/mZ8scZUQ7/PDDcmQIHEE1hx9HI4+AkTko1GkHIxcgdOSthbFB7YqltnFyCeSUPiZ//i79nmLgfdsQm/c1L8e4mWbB9e69mShVPTGLNQwd8sRAeO8uqkgbiSKyCQy5sRRfNh8xjmBAGK5phPy2COsDdWbXcIyiWbOYOtmG3sWIiXN19MpHhtHUyd6VqpziD8hTDoqfUEIWPNO8y4cQlCZO6oxqGSBZM4eQpOj9TnxOtD2jwlN8q43kLwAYA/+yB08pQzR350IBR/yOUiDF/E5o3iGH2S6mBTDKEaUezB8Dhr/hx+2REJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlL5eLRoUdedfh821ze9eHzie1om8tI74i+byygAh0o=;
 b=tuDuU0ltKXqgJTgbvXpwikMGo2FX0tp11Ir7EaGg0TEde+B9ywlfjVD4fP07YAOF5axrBkpqjIdjO2SgiwLH1qpHZn/1HpIXSAJMq8CN3x4tRaSTDcAFliZZ9w4kzfiiugS6jbJ1V8B/GEO1JAePNYm90wJO7YDdFJEaxAVkvP1eOPNNtJutxdokAZ7me9P7Mavp3bwJaCTzd8rh7IfbttgcGe8KHkt75KtXCNAurwKCt3bBlfeCr9gwY0pGa0adyoMBLPM0N3yC8v4dPhmaykk8+8KrP8c/+7MSZjEcT/sqo47CHfOBwyd4Fhu9YHS8Is+Pe2RorIGSnYKPT/zhgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5821.namprd12.prod.outlook.com (2603:10b6:408:17a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Mon, 11 Dec
 2023 21:57:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7068.031; Mon, 11 Dec 2023
 21:57:39 +0000
Date: Mon, 11 Dec 2023 17:57:38 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, "Giani, Dhaval" <Dhaval.Giani@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	joro@8bytes.org, alex.williamson@redhat.com, kevin.tian@intel.com,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, cohuck@redhat.com,
	eric.auger@redhat.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
	chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
	peterx@redhat.com, jasowang@redhat.com,
	shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, zhenzhong.duan@intel.com,
	joao.m.martins@oracle.com, xin.zeng@intel.com, yan.y.zhao@intel.com
Subject: Re: [PATCH v6 0/6] iommufd: Add nesting infrastructure (part 2/2)
Message-ID: <20231211215738.GB3014157@nvidia.com>
References: <20231117130717.19875-1-yi.l.liu@intel.com>
 <20231209014726.GA2945299@nvidia.com>
 <ZXd+1UVrcAQePjnD@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXd+1UVrcAQePjnD@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:208:237::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d23b5a4-b982-4b0f-5656-08dbfa943158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f//jZAvKCNs+EB6DhagzhZ6LCvXpWfswG1yoODWk3niKAm32kPSQeWNYWNujxnHF/DigE0BcF7l7ISnHHe/RpbTH4rx0wTacP5Rj1sJjcjZJFO20QTljqHXZat5mjuCfU9dDh95XNE0tqjMlYq/W+3biNY0PkxA7gXlE7hTDgM3AZAB7CeiZxAzoVZBwlfkM4Un7ZITMBnjZzDX+lqaRZoLi/fJh+UThKCBOZ2JnA/U8Pgzgv0r6c8vqr/uURc9Fa2sJLK+7RXhxBttVxqgPUibAXMljW9c0K2kIE391TtmioL4JJGHK+wlXJ3qgCNom6zDbhm8I1E/xCSr2UU0r+dZEQ3EhMKmInwrCHM3OFj0WQWwj427AyJv8rLl2seq4dPwHOX6Nex+9mEcE32V3RrUno8Rq20w5QDiFcIQy5lUoeFIiwfa2IDpcd4ChAI4oMNwkGDGA4wYCK3dlC1orse4H+TFQYPYwDNtR1dewqWwZl4BApX3Jg11yEYE1O1fqKpN6OZ9rXgXaj+GrmV1jFO+o8jWpQ3esNh6GTENLsoJTMinYFET6VlXATzN0WsoB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(396003)(366004)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6486002)(26005)(2616005)(1076003)(478600001)(6512007)(6506007)(7416002)(83380400001)(5660300002)(41300700001)(54906003)(66946007)(2906002)(6636002)(66476007)(6862004)(37006003)(316002)(8676002)(66556008)(8936002)(4326008)(38100700002)(86362001)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bX6fCWPY3F/ouWVNXyunK7+gCMAsCp2zxjtm6IMhhCsBhuvhcMw6pWOCOwQK?=
 =?us-ascii?Q?COmF3Wb42RFpSyV+B/jgqC8D8l3xb8AwJTdrmlfiz5uJ+ILpI3pDYDM37BnF?=
 =?us-ascii?Q?E62ABmWZST2KkqJEWZQn9OTrWkijRKYLAmkd9xRAZW3cW80EkDfpJxX7ImAw?=
 =?us-ascii?Q?a5VEre6ItVcrZky8e9FtHVk069VcZQ2U5r8nWw4OyRGfEb+qQkAr/rFn+Hif?=
 =?us-ascii?Q?oGsmH0yaYx21yYJvBnBx0vkTrSzZj3+PmTEy7+otGP4PhVEFqDBJ4JSIE/od?=
 =?us-ascii?Q?eigYMUF1Kib3kUg2HNOq0pbn46STDPWS5vHYj9X1aGPSUVIilPf2iu2JSt45?=
 =?us-ascii?Q?rbm80bk2Nb4iHzu0korTIfxetKI9PrwBuid1omRZOuhevZGniy1fNsjjLn+N?=
 =?us-ascii?Q?UJPuB4GPl0WwVWdV2aXBdaYhmxFUWlP0sFQMmP7qYp2ss/I5+HdAofNkufc8?=
 =?us-ascii?Q?a6GCkh7TzUWw7XELZEIdQQ6j1JUSUVlP5nR4sbkNFjI292YVnDbPH7SXa4S6?=
 =?us-ascii?Q?6VSC9WdJP7vCSdTH1RPI+/R/bgS9Pu4gOAyYFDUwssjh962HMa2LsTLy9yzd?=
 =?us-ascii?Q?eTDSdJyMsN5ReNcQ0bxc5CmXHc0yHZ1QUMObA3jpnsoxNB7spw/d8xlM+ukg?=
 =?us-ascii?Q?CnIzNupcWeADQhTCxaRHsSIG/XWocJtdSCbPSUtDB7od5anyCO2ywui8XcBp?=
 =?us-ascii?Q?+EzVBKjC/YeRzA6brI9hV9SkeFGEm4/1cp3TvixAUiMDpHa0GMCBe6jtT8kn?=
 =?us-ascii?Q?oZCLnLn8rpPv+8gNkB2cc0FkWgM2m+ej86uFjGZANaMqmJyMDUnXFj8gbdEG?=
 =?us-ascii?Q?u+FsIkdmrHWz1NAqS3XSFFU3JY6JNvKOeTxGWqSbIiao1K0cL9MxjgbmO25x?=
 =?us-ascii?Q?85h4annTR4w69IaIPbQIBg8alO9qJGZAEca7wBJlrrnzhnnxDkYXWO98MSnP?=
 =?us-ascii?Q?MqpIVi9W3Ez8Q1oJNqIX7uP38A1B2G+iuSdmBlpXyD4lkg92gRCJDBdNRgO2?=
 =?us-ascii?Q?W53LAU3TosMQ+pnqX6G53mPCxGYNEa55amb1cSoNbMLyTzNRDuAotmbY2Qa6?=
 =?us-ascii?Q?qKBUVo5hZLOlQlirKXeQk+ahMyo5ZfsV65Bt3o7Ou7D6GbDWikjUEWxhlQu2?=
 =?us-ascii?Q?+HXXherHUIKvQAx+UygNGy5lFIrJXpM+/uNjOc/bLmER0JGiDXRtu4UhXGTc?=
 =?us-ascii?Q?05jLPkd7psZy1iepzKhmvizmVNVdXaE9xd2muoeTOZTv8a4A0JUPmBtsNeBW?=
 =?us-ascii?Q?EJvVdT2yzSOGLQbCtLaWcPS2y2tl4oZF1ouob42b1mU37vy3JJue1F54lBBg?=
 =?us-ascii?Q?rtFrybDRPmhJHl5EUEAMszn2T4SKW1BJhYk5/vR04a1nxkGYssB7Tuw7DmVr?=
 =?us-ascii?Q?5bwKoWVdoh5Vp9XKkffIN9v6dH5Wf2FeVBgHESak+TyXYsNxZy9W5XwhGgaM?=
 =?us-ascii?Q?OpI+CRuRFgLppADOmxQOYLNUEyQxmxtnBLpNRjld+TQcWO+L9fFwG716C9hS?=
 =?us-ascii?Q?I4YJ9TxeWFSOXsjSKqx7uGA3lVf1bDqvHpidYJUHFD7rPTAVH+3tGb9LaAMB?=
 =?us-ascii?Q?YO+fzQH324n3C6hsitguJubfATVS2RSH/UTZJTUM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d23b5a4-b982-4b0f-5656-08dbfa943158
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2023 21:57:39.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Ezl5umSFvAHYBApy9xMgl71Iudsvw6hIqSOAmHtGexCZ4D8OGClWDVqZzb5Jty0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5821

On Mon, Dec 11, 2023 at 01:27:49PM -0800, Nicolin Chen wrote:
> On Fri, Dec 08, 2023 at 09:47:26PM -0400, Jason Gunthorpe wrote:
> > What is in a Nested domain:
> >  ARM: A CD table pointer
> >       Nesting domains are created for every unique CD table top pointer.
> 
> I think we basically implemented in a way of syncing STE, i,e,
> vSTE.Config must be "S1 Translate" besides a CD table pointer,
> and a nested domain is freed when vSTE.Config=BYPASS even if a
> CD table pointer is present, right?

Yes, but you can also de-duplicate the nested domains based on the CD
table pointer. It is not as critical for ARM as others, but may
still be worth doing.

> > To make this work the iommu needs to be programmed with:
> >  AMD: A vDomain-ID -> pDomain-ID table
> >       A vRID -> pRID table
> >       This is all bound to some "virtual function"
> >  ARM: A vRID -> pRID table
> >       The vCMDQ is bound to a VM_ID, so to the Nesting Parent
> 
> VCMDQ also has something called "virtual interface" that holds
> a VMID and a list of CMDQ queues, which might be a bit similar
> to AMD's "virtual function".

Yeah, there must be some kind of logical grouping of HW objects to
build that kind of stuff.

> > The vRID->pRID table should be some mostly common
> > IOMMUFD_DEV_ASSIGN_VIRTUAL_ID. AMD will need to pass in the virtual
> > function ID and ARM will need to pass in the Nesting Parent ID.
> 
> It sounds like our previous IOMMUFD_SET/UNSET_IDEV_DATA. I'm
> wondering if we need to make it exclusive to the ID assigning?
> Maybe set_idev_data could be reused for other potential cases?

No, it should be an API only for the ID
 
> If we do implement an IOMMUFD_DEV_ASSIGN_VIRTUAL_ID, do we need
> an IOMMUFD_DEV_RESIGN_VIRTUAL_ID? (or better word than resign).

I don't think so.. The vRID is basically fixed, if it needs to be
changed then the device can be destroyed (or assign can just change it)

> Could the structure just look like this?
> struct iommu_dev_assign_virtual_id {
>        __u32 size;
>        __u32 dev_id;
>        __u32 id_type;
>        __u32 id;
> };

It needs to take in the viommu_id also, and I'd make the id 64 bits
just for good luck.

> > In many ways the nesting parent/virtual function are very similar
> > things. Perhaps ARM should also create a virtual function object which
> > is just welded to the nesting parent for API consistency.
> 
> A virtual function that holds an S2 domain/iopt + a VMID? If
> this is for VCMDQ, the VMCDQ extension driver has that kinda
> object holding an S2 domain: I implemented as the extension
> function at the end of arm_smmu_finalise_s2() previously.

Not so much hold a S2, but that the VMID would be forced to be shared
amung them somehow.

> > IOMMUFD_DEV_INVALIDATE should be introduced with the same design as
> > HWPT invalidate. This would be used for AMD/ARM's ATC invalidation
> > (and just force the stream ID, userspace must direct the vRID to the
> > correct dev_id).
> 
> SMMU's CD invalidations could fall into this category too.

Yes, I forgot to look closely at the CD/GCR3 table invalidations :(
I actually can't tell how AMD invalidates any GCR3 cache, maybe
INVALIDATE_DEVTAB_ENTRY?

> > Then in yet another series we can tackle the entire "virtual function"
> > vRID/pRID translation stuff when the mmapable queue thing is
> > introduced.
> 
> VCMDQ is also a mmapable queue. I feel that there could be
> more common stuff between "virtual function" and "virtual
> interface", I'll need to take a look at AMD's stuff though.

I'm not thinking of two things right now at least..

> I previously drafted something to test it out with iommufd.
> Basically it needs the pairing of vRID/pRID in attach_dev()
> and another ioctl to mmap/config user queue(s):
> +struct iommu_hwpt_cache_config_tegra241_vcmdq {
> +       __u32 vcmdq_id;			// queue id
> +       __u32 vcmdq_log2size;		// queue size
> +       __aligned_u64 vcmdq_base;	// queue guest PA
> +};

vRID/pRID pairing should come from IOMMUFD_DEV_ASSIGN_VIRTUAL_ID. When
a HWPT is allocated it would be connected to the viommu_id and then it
would all be bundled together in the HW somehow

From there you can ask the viommu_id to setup a queue.

Jason

