Return-Path: <kvm+bounces-28890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F20F99EBB0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B27F01C2336B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3547A1D89E2;
	Tue, 15 Oct 2024 13:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kjk4u+bl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17641AF0B7;
	Tue, 15 Oct 2024 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997783; cv=fail; b=HNxES4mbx0VwEqVlvW5HGmt7MFjs/WjndFoOAvbKa8VSqBhKk+5eYRS7krnuV3BixxekFbrECUq+liMp45UEscj8Kg/VpohuFLh/62ISJm4KTNhRIkvpzZEWaULTVfSx0nBkqd1W8G9IanAAdLHQ7TpbI9jkpZTMIqL7Lwzxy28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997783; c=relaxed/simple;
	bh=rOS/MIufUpxVdNPbjX2h9Xiz5a4LHRfVnp+Z+Fcldyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QU1xhpQ9tMc//3rkd4UgbMxeitg0Sb0mma3coolTzyHi0SxjELmq/npvOAMW4nKUa8sbaRXAtM/eUjqbFPwxXQD5spJMv/tKBFCJ3S1RRCKRvsCkNOJvgE07f/AZ1YvUI86r2ZeCrdNtTm+EI4fPSZ87K2MnxfSDYuk10IIRd8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kjk4u+bl; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gk/mf3sBDpvBSGN4Ihr7AC9qi/M9s6iTfvRmZL7Xc8xkQxeDJ8I4lNHIkzvty59W7bGdbK/mJQwpV2nJZPhiZT30PfwlfhSKlXd8J5GgA6mj2JyvHx2y0I1TIQP7dMUZkMHaa2jusUDU91beLZQU9L9ofiU7//iJsJ7iP5xNrpe8velJHiXTOASO7NlHrKCJJhOkjvZlUp8TTLKvnLQ1rdixsiIaLLWgNhNcdZzk9IgwB4VYwPMVgJmySc0KAjkzmZv9qGi5NJyT7O/UOk5Yzl51OVci8XOUZModBu94kxI9TXG+NI3LNCM75n6O5KfgvJpwNQN1sbmC5LE3pO08Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXOGXn+t1pWCPLt+evmJc75W8p8BcVFEEzubWczeD2Q=;
 b=m+ZfU9ZsopQYvuKiAMUIgbe7Sipj2NxelBeTouE41IcrCT4GSmHq8Qmi8NUYMSTsYgFvuCBnZG35Flj7ly3OLP7fm2VlOXlNXwPMW5Ee5BeKj1Ym3KKX5gyH3o6l3ESgOPvWGVEH0QMN23mKqtN3uFS+oPxeBmaP7hxB6vGAWldlgHoiDcUpqOLSW4WT9OzVQI3x/T2+dZPIj4g9QWWV6/Ed7v72bKxJbzhL6phQfKpSZODzEjr5eoCHyarFsVWDbu98InanDZpl4D7n70v7aNMYdO3x+7KpdKIREf24BDHdKUQ5EueG05DArlI9RchlBYHSTncGfBS/ZaNWmKbCzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXOGXn+t1pWCPLt+evmJc75W8p8BcVFEEzubWczeD2Q=;
 b=kjk4u+blYA4LnYeuUw62bmRnWrn9FeMzuT3vxHb3XA9y741NFhOPfbRlTI7zHykXYk7Cpu3TvNfQg/14cxEH1dedlpeEB80slzaVtMk8zSI2Ks11NPZpJSYfoBBQ6ZGwVI3CY7LWP6UUekeusC4O/plKsQiG3AGqkUPbEU9f17VRIiOO7z3+n0Jbeb29IOx7f5piXRI4BUmik572Bb9c+JuzX1H55GwIl75X7+FkZvl8SqhtTaYnKV1BsV5pO6BJQy6sVImsNuDs/oSoO+b0q4JmDz+Vxs0qmWdduNPyYpdjnOLmioQa3tYBvi7fnnxgZRK28C8ReEvWyik6pvGwdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6119.namprd12.prod.outlook.com (2603:10b6:8:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.26; Tue, 15 Oct 2024 13:09:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 13:09:38 +0000
Date: Tue, 15 Oct 2024 10:09:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <20241015130936.GM3394334@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
 <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0671.namprd03.prod.outlook.com
 (2603:10b6:408:10e::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB6119:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b65bc5a-0cde-450a-86ee-08dced1a9f87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aLEVKQqmq/gB94pnEv4VUav7bKpUb8DZt8haSNDkBsmtziBmFONZUjt+nyGH?=
 =?us-ascii?Q?B1dplWMAnpjmifjWVrlu+Oi6gKhHuiuTinwfp/nX+Ae/bg2Brpk2NdArgFhO?=
 =?us-ascii?Q?58EzTcQ94mKUj4N1Eslm6LBuLU+GDbohG3bThYyTa0t0m4ouqA71eU9Si05M?=
 =?us-ascii?Q?uzjVk5PDds60EziILGvlF+sftac8J3GhksUDrRijDX+PkOVRj8E37tg3agVw?=
 =?us-ascii?Q?b9txTgPtDT03h7Vs8P9eWemUV1aC1hbBebcBTXKYzbmMg8EcRcFa9urqY1/Z?=
 =?us-ascii?Q?2VNCPGkAFGrOOXGYgefu4eTFmuAAvsSKSGgZljSuN6Q8jb5WSELwpyomRNZV?=
 =?us-ascii?Q?odkbBsh5KgajqWUfn0nvMv+RrIuUwbd1iFZoHl6COZ219LHPv354DpphoQV+?=
 =?us-ascii?Q?7sb28tdt08HTzks8xIOaxUODpMl3nrSErIADCr0tzUXj2bVOGj8yfRjFrUav?=
 =?us-ascii?Q?oJKngX3AI6xlSfrV+j5mshE57RjmTQ/RgiSrhKLXHDpl5depWB/ThFlaJte3?=
 =?us-ascii?Q?6a7ztRb6LkzJWylYJ2BLT9qD3sE0+YReErDLbBU/EJtB1ESbKHowX2JYSZ5O?=
 =?us-ascii?Q?M7lxJc2LB7lqtX5i4BKWS+URQ6cEI6uWHdrgBZ74NvAxCpGZF+QytQCdFsz2?=
 =?us-ascii?Q?/jmlDEIgfbGuLOBaiCl6r1Km3CDlTmCbW5AczvWNKdtmWLsR8RaZBNchJXji?=
 =?us-ascii?Q?ndtiBRJBxhaGmZZzvV8C5z5U/Ogn2UzFmeihuwGpvg+r36MfvAFzZU5F+HzC?=
 =?us-ascii?Q?iF0HPzDIoW2oGpZEqZHxUtr7iwFlb5JDIrrygQrDsLDc/GESRY6YyMqHYw6Y?=
 =?us-ascii?Q?IdMqF7kgaGV9ksY3KdYzmYAOX5LIv3B3WCF3OQk5fS/Bfhp39iuMtFsFpb8L?=
 =?us-ascii?Q?2lYXl6MXuyGmBNXIDr00KJjJPo6DD2Ok+Ah36Pc5hbPZDBsbFlzKHvZ/pbCI?=
 =?us-ascii?Q?SwuRvfyELSStVgPlsIeogMenb4ES1Qy91trMpTxysIDR8VRlnp25zZjRygc6?=
 =?us-ascii?Q?PD8lkd6MqQgVg60QFVID4UbpvjVNz2KkFhuzcnu+hAH0bgE+JnUKaVKhRA4J?=
 =?us-ascii?Q?xbLaRc2Hz0M9yPWs3a0pv7pIE5Tofy9Ko80qWp52MS29A8dbneX/fWHcuigO?=
 =?us-ascii?Q?C8bTbdIuTKR5SDai7x/gy2dDVRD3z/aqad6CshPbZl8/mIcn/0dkevxfaL7a?=
 =?us-ascii?Q?AAuioRsBLWom7ywh5YrPOcoclE0QC6DPk3fiqgJG4/tTbih/zO7bjCaUxMsw?=
 =?us-ascii?Q?yPDcB/4QqfMCjw+xEDdVskQfxtHWMvxjy5RQyKKKNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nGZwIk+CnHVU1U3Q2VDnZgQni2u1a3rh+ULKTy2c9vhuJVbz9oYRfIsjCE/T?=
 =?us-ascii?Q?TTAx+9HZ5gjpe/V6D0zulViW5MFkAVAELZy/SnbLAC3ejJA0SBnpsp8yPYVi?=
 =?us-ascii?Q?YZlUyl+oeq9/8u1GHQ8QhPgMz+gt5KYw7KoDjqPCxrMaFnr2J9Vrqe8Q4XbZ?=
 =?us-ascii?Q?5Dc3NrQmF+aXgeMq4UXydCzYHYw/plnjIU1TOCXpFWF/2AkZdVrKAS6MHC4V?=
 =?us-ascii?Q?sTJhtK8k2WPXNqo1ndPj/LR4SOip4wcsSg+9O4Hj1fNiCP2nyWZlt+MDj2N0?=
 =?us-ascii?Q?jpbNkWOTiVd0BX40HQN1euNdIgSg6eRV8Xykmj+SzLvze9FWVdt8I5cNpNFV?=
 =?us-ascii?Q?z0MBl14AqHGhwgcLbRAZnbC9UJTm9EUa0pISfiFTAvy0KhMAv0cbQru/v+yN?=
 =?us-ascii?Q?j18d2F3kNU+ymzsthZUb4Vlsn1OOjPbD23lVfK3E6SkyoqNLPXDB/eG5T9im?=
 =?us-ascii?Q?35X3L8GGSTxcsJcTgCGMx5lK5HNkq4ulsDIDPfz09cANZKi8PusL5uI5C0SZ?=
 =?us-ascii?Q?vi0RUN25qiYnaM4gIE1gcj/YULrZ0RTthuYcBr6rEnwC6gulb4UFBMlpgvel?=
 =?us-ascii?Q?MWOPpPD/wn09lsqkxMVouawJFiB2gl3nTnWjQrqrKPaedLyOCKizxVNbbrbF?=
 =?us-ascii?Q?o5Ri5kvrNMP4dAzBiL/hjMDbTnEc7LGqnzLWdjA0mWiLDnMZ2ArwW54AjGX0?=
 =?us-ascii?Q?oUkOQCSvaDQxpp91FRAsAtc9ukY7xEdmjriSaT0omE8DuVEGsOwwvmhwbB/g?=
 =?us-ascii?Q?1B3NqEZbVEy0TKTK71jrcEFZdDA1VktdP7eJ3JixorLbluCLPAYihcpOxiZg?=
 =?us-ascii?Q?b60MQEK77tBekjwX1Iq9kAI79mV+YX5NxInn4wF4FQKrFqpMRWzSzPJSUILQ?=
 =?us-ascii?Q?vwWP33UMa0RQwD0vanqn17x7Ms2QRXd3S3vrK1tWllvWPn11aqqVsAlAPT+q?=
 =?us-ascii?Q?zLXCQBbW1v/GRIMjs8WXzzRIOnT5C7ISaz6oZyn1nWksaLOxbXnQGNEZTkkI?=
 =?us-ascii?Q?9MUTy7fbZgYas4+7dwOjJ2cIGwPSNEX7N7VgF+hVLaRYPehBtxU76LoiafWE?=
 =?us-ascii?Q?FFaSVA11U//7LtC9wJJKdAb9WFTwjbuqXNBy0t/Z0g0mC5j/xXrPZ5T7A783?=
 =?us-ascii?Q?ssRN60eo602JJy8DzmF9B4eRYLQ6AC2o0VA7wRU5FsIiVuqObHbmokyyiYpf?=
 =?us-ascii?Q?ir09y3/ugxZ9frIkV3+gQrFZDGXiiwfeFxoEDhDjPj9Z3kMnmVlgB3dQClZL?=
 =?us-ascii?Q?gwIKhtCoF5afxOuqvuAqgFeLC7ZxojiKgp0Srw8nsBC0b/A3goTGoambr7CA?=
 =?us-ascii?Q?mB8rYXSMIJXH+iaRct8YBYPQ8t6Yno75fbBG0t0P5Z2m09bb4cxcEMliftWR?=
 =?us-ascii?Q?FY7GI6ml8zbE9SzRTU2yqSILgox+BTHssb37er4Q3kPQ3bL+h05SxbDrxjXZ?=
 =?us-ascii?Q?p8Lwl/GInaImXPfPVhNMNV7QFj3jPhgBQ4YdmnijwScicY5KDYCAPKlSRc+7?=
 =?us-ascii?Q?xNAuc6ofgP7Jjcd60P6JiXn8ThqlATTyhEcSeY3o+V8BZ3kT/mhp+rGDsGhM?=
 =?us-ascii?Q?mOUgUAZt5nG2ssLX/38=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b65bc5a-0cde-450a-86ee-08dced1a9f87
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 13:09:38.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BK4gqdHDaxmIfxyvJvEQDX3oer+KN2SsVljvRvAqlVAvkvATfPY5NoiRW+OhREgv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6119

On Tue, Oct 15, 2024 at 11:21:54AM +0800, Zhangfei Gao wrote:
> On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
> 
> > > Have you tested the user page fault?
> > >
> > > I got an issue, when a user page fault happens,
> > >   group->attach_handle = iommu_attach_handle_get(pasid)
> > > return NULL.
> > >
> > > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> > >
> > >   __fault_domain_replace_dev
> > > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > > &handle->handle);
> > > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> > >
> > > not find where the code attach user pasid with the attach_handle.
> >
> > Have you set iommu_ops::user_pasid_table for SMMUv3 driver?
> 
> Thanks Baolu
> 
> Can we send a patch to make it as default?
> 
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
>         .viommu_alloc           = arm_vsmmu_alloc,
>         .pgsize_bitmap          = -1UL, /* Restricted during device attach */
>         .owner                  = THIS_MODULE,
> +       .user_pasid_table       = 1,

You shouldn't need this right now as smmu3 doesn't support nesting
domains yet.

			if (!ops->user_pasid_table)
				return NULL;
			/*
			 * The iommu driver for this device supports user-
			 * managed PASID table. Therefore page faults for
			 * any PASID should go through the NESTING domain
			 * attached to the device RID.
			 */
			attach_handle = iommu_attach_handle_get(
					dev->iommu_group, IOMMU_NO_PASID,
					IOMMU_DOMAIN_NESTED);
			if (IS_ERR(attach_handle))
                        ^^^^^^^^^^^^^^^^^^^^^ Will always fail


But I will add it to the patch that adds IOMMU_DOMAIN_NESTED

Jason

