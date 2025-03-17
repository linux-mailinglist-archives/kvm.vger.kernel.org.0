Return-Path: <kvm+bounces-41307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9C5A65DE5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 20:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96A60174706
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF211E834A;
	Mon, 17 Mar 2025 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OCQ0Sa7C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D566E15573A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 19:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742239702; cv=fail; b=pvjFLFv6YVc4Jvtcks0NEUR/r/Xs0JPkwCB/WxepK/iUVWJVD+vLNLJGTEGzM8tKUI4DXyYYodQ+5+piIds5vJErKmJaPdbNmbj9oeOubp0yhtQixM1/jM3RZeYXjK0h0ZSKdp5e3cfvCCKX02DgjiJgwVlm8CBSGRB1oaaUJFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742239702; c=relaxed/simple;
	bh=ApOEPmK/14hB+TEGYVh/PNXS7rd1bkQgy5phqB3rO7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OuUiChELAaq+AliRP2OcCjZi37IAiJj8i5ZtnsY+OJsfF9HnoHv9XQImvG3CqgTmCYM1OI2Xq7Rp9zpkLEctxMUjHn1KmZ7eTSuZNVcHGJSZzwvRXgejdcXQlxLUUSmwOGpVor4x8Cc4XHL2KpURbN9j2Kif21CzLiG4IiUo4XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OCQ0Sa7C; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t7WF38BCkRpctPOsGkJK7lXYiTBrbX7rCVxZC8nmQIK48xn8w6+KmuWQhaMJ74lCy/F++gL8EVisAR7xM7psRmsW5t44Kd7W/RJaOlJfHPN2mkM2rXfxjBnDw6/9QV0vINO/sgRXt7UeXyMenluVX2A0ktzbus4YtXBbjzx4FLpBOirila4EnQkCwWs1F7AX91jMo4qkGezx+CKY5rS3bNdW9o32KyQaHUd7hnC0lrniB3Nu3yHQ8UF65f7HI/6rAF/JxeVaZGxZrFe6tOE2JczLC8pzpHltsiZ40fmDCIt7O9uklW1RnNL4MMUF+OzgPmH7kCSxvBoPX1NwbSqb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iODbClHmyKvjVhE9GNyyfJq9g/RuDBlHCZhocJ4NLik=;
 b=HK4Bansf2F281cXvz6D69nJ4Hur+nvU18gbT5EWaOZOiXeHn2MR0/a2RVEQhy1cvwSEX2d5JpGFK4jDMMi4bp3iQl4SKSTZ1xfYmMX21zNbpuOf6g27Rj3a2WwZZVG/1fS61zSTuN+LRbWBvfDSE2bvSuzEUwzPgD/foI4PPW8NrtAxwfzBzVjWc6iZ+Z+a/xWyQdW2hOLEudUCrslJD8bBFgVGXl5IEdbjxmyl7enc+EmXkDEvaEh4epLS7j7JZ5aW+fNIvoO3fIqG0054x2PP11obJgaxpQrTpLmn6SeOZGki9/fIIw2brNEVRlAuTQnTY5k+JbFAEySEGDKzf7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iODbClHmyKvjVhE9GNyyfJq9g/RuDBlHCZhocJ4NLik=;
 b=OCQ0Sa7CgbvZH6cNXv9ZQHnMyKzbM7xXnVaXtmxvpfQrd43XLRtUTDb4jFwnHMUBKao8JFfd4+ZAreXq8kkMAjO70hHC3THj5SSZHGaHqCp/iPYnLpCQM2T5P0na+Yu/Gw/toJS0wg9dvv5+tjuSvpIOZbo6xfFh0HQw+WloilC8FMXckYThS9sGhm7/G4dQ0IMupiCJuanbXVxWEu+iGeZMK1UaC6fBoXZGr/no0YFoEGpaJQqg6Uf7BzYR58Fwf1yIAcGPKTG4XaWpqAao+6fhGadujdeS1DgjZwVwccNOsCpNvRdLovp6SlesR8CmPPk8/XmjxZOEfuCzjFvsCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6327.namprd12.prod.outlook.com (2603:10b6:8:a2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.28; Mon, 17 Mar 2025 19:28:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 19:28:15 +0000
Date: Mon, 17 Mar 2025 16:28:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kevin.tian@intel.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v8 0/5] vfio-pci support pasid attach/detach
Message-ID: <20250317192813.GT9311@nvidia.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250314084813.1a263b66.alex.williamson@redhat.com>
 <f5cf80ed-0761-4b2c-a721-f41f9556d520@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5cf80ed-0761-4b2c-a721-f41f9556d520@intel.com>
X-ClientProxiedBy: BLAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:36e::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: 8170d153-f0bb-4c91-f51a-08dd6589dce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yjvsqq9IYtlboYRIToE7cCDSm1LS8SwhIMraprB/i2OSQY30UomI8eT0Qiu8?=
 =?us-ascii?Q?8LWB2fG5MxRDGtPhARhjtWIXRMysAL+o6f0+MchOJeM+PLkbZ1HVEK0gfdWJ?=
 =?us-ascii?Q?ENvToMKf2QbWwh/55uiFGJnDQzFSdMovz4PD6xH5N2v8/HZwEUk35yGrohi1?=
 =?us-ascii?Q?elxHbImO7Y5Vc72anm3wG3J+GZzRfbYWsBCQXIn+iLljIrSAP8WhDMiMEGL4?=
 =?us-ascii?Q?OXo0taJgrigE4mRXXVDgZQSKE/DVPcwsQR0MpE+yfWZOIHhO8AjJ59Dt03hr?=
 =?us-ascii?Q?GJDq976NF9ORXpWpoYjgpR/uDluO0sfhsiPvjUrtqOujjPoGP6izoXRl2oxS?=
 =?us-ascii?Q?TsZtvpLyLeAtDTxnzBKxbPe2OtTb18sZtz1MEe86iQ1QgrK3k5izev2f0mPK?=
 =?us-ascii?Q?uptJaiBoiwnP0U3Z/r5uR/fwqUwEKsbbK9Tu8yp/tlFpgZhdbR7C6+QOHoIn?=
 =?us-ascii?Q?yo4pQdrTa3UjUWwY9ZoInYl8nP9PBxOz+Zr5anRBqhtp5CUiwwmQEziDsC8p?=
 =?us-ascii?Q?g5dN4oTbDmur7odKbY2zt359h18R7MR7GYcnNPXLlRcCCsRhsQHxj0RtweZP?=
 =?us-ascii?Q?cCCi2JP1rSUjo039fYWlqCCqtpMTx5pZYAB7tSQKHtbDJw5rtf+hYIvIKTX2?=
 =?us-ascii?Q?Zms9Y61cXYuHhP+fSTcPrKqtmGoG8ppKTy0v0Up5cFXr45Pjv3Vd9ZvuP1PV?=
 =?us-ascii?Q?zPzR/Am1eVl+Eqk7mp26+9Oc3+KviJGxl/7V3rfqouGyzjV4/br8EepKBQw3?=
 =?us-ascii?Q?s7nP5qdhQhermKQep+6cfGURIZnqI0s81HnPucWn3YA3kVEI8etBtjReH/LB?=
 =?us-ascii?Q?6RcsLI3cTmt9K4h/iDN/dpovAUc/MF/Tn3x65R4gfvKw3bVbOgCXBbCmNs1J?=
 =?us-ascii?Q?OoxjaYMmMC9jWSUTiYs5b6566UuGlkXLqTpDz+2zGhIPH287EXjqxPoc4xa0?=
 =?us-ascii?Q?2/JtLe0xaDYwvU8kNggDDmrYa6SNCwbGpU+6/RRUljN2hbdshQls99lAaGsW?=
 =?us-ascii?Q?GQPaH4HKI9ovhXBBxMBiNkrb8X0YeaU8wFjlsSJhxyvOoSxqmgDRS3QSCksg?=
 =?us-ascii?Q?+442Z/+ZQikPoknMlJggwmuThKiZFhTpOsZQ+05PqEjSt9aG02lmGLp8Po5Y?=
 =?us-ascii?Q?Qx6MCypWMA2Y3Tqiu25zj8T9QN8yHaJ2Pg/5huaUc+qyTzZdi3l6Z3Xn8oC8?=
 =?us-ascii?Q?Yd0aolaopaTcrZU33Od8b+fLIa9Lugr1XlWUz9Ec7McXRg/TPyx+i8K5ASuA?=
 =?us-ascii?Q?8OCTdXq27KtVW6nPFhM4RDf3BFemyP5DF6rmhfzqKHkuw48tQ7PJG09dAvn1?=
 =?us-ascii?Q?oEOoh043zTuwE7q6sESDy3BRLml13i4nD6sJRlVPQ0nDEA6VcPAyajp9GYR6?=
 =?us-ascii?Q?9XA4IqhoNXlFQ31VWfjIas5OVWyk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dCysAzp1mvIoCqwH4GQCkFbEsTT/QQYn8mcilMiP3a3Gn2+UuHLaX98SKuwQ?=
 =?us-ascii?Q?pxkBJqMRY8mhYD48s25Phf79Vp9KXpZUy87OZO5aaq9V/t8qBM29dpZ7rmms?=
 =?us-ascii?Q?+UEidTKeZnHV2uUj234IonQajDlTUjTbR/3lRY5W11cEHTXKM/79L2lOf56z?=
 =?us-ascii?Q?GLN9E0R/ef6PnCnYCIAroq1ImlRNqFbnv4BEBizuWm+tqETRHAQ73A4a6Dba?=
 =?us-ascii?Q?nN/hCYh0KknCAQ/oskmbyKA8keNowqv7hpD2EhEka3X5cJiOjJK7Boeny35/?=
 =?us-ascii?Q?t7g2PEmO8KdLQ4iR2D0t5d7mb014gZ5YQE6esJVjG3aNJo8eTcGVp0RI6QZ0?=
 =?us-ascii?Q?SHadlRPotKL8YgO/DhGtxBiOWaZDK5skqWmZiTkxZ/Z+AvsGngcZ+0itA+BN?=
 =?us-ascii?Q?RJS80GPlWvLhzfoEPyr3dpdpocnre3rrt2b+G+Yr8j5GbfH3oVhPpdyDzS4V?=
 =?us-ascii?Q?KP33bcLzMJNPUaZjWZbDU/+Seq75ioLHrAgDVTwMUfewCADp1jSJuGVieK2O?=
 =?us-ascii?Q?viWjiN+Dt06F7B94qwLXX//cy7sXcDBl6kN1hdhYYyjK0ExUVLeFXgnJ/1ae?=
 =?us-ascii?Q?X4Eaxs2EAB/TVyCkTbYgaNz3RWXwcN4E+ur/2GENfTqSW5lWQTC4TziYj8QK?=
 =?us-ascii?Q?8X+R8Oq/YkTisDklmlbM1bRnurasgfiE2/yKZNAbAQ23S7R9u5R191K0Gxvc?=
 =?us-ascii?Q?jFQPBsWfPtwR+NQOPUMwsGW4hhtXf0Knmo+MvhRJhK2xibIm9m14Ih7lO3Sk?=
 =?us-ascii?Q?7/onOB1cxV+lkLUoyzYM22ZPLYOnK6K+NZLDZwM0h99PK58iGrvoGJ0gTdS6?=
 =?us-ascii?Q?+LmR91sxDVSAp4hNp0MZH+awbwphldUduh9GnelnZIq13DxDIYkn9wH90iNZ?=
 =?us-ascii?Q?ZDV9y8tpRslrxahQoBCjNQnI1dH7kVum7rQV9BBs3QXSSZ+oudjGvesplDkc?=
 =?us-ascii?Q?WhonXrcTXXIpkYmHD1+XDazo49S4Hm20bkKTQMa9kRGFkzTWWcgyX9Fo4Auq?=
 =?us-ascii?Q?jo6Fj62PUQsnD83Ee2QMYd6hr/FyKwVQMwjoSiUujR1Au+2Iw6WjZOuN4ghF?=
 =?us-ascii?Q?DpxFX3nKRw//TAEcuMTQW8OqCzzblapMdfGtmsCEppkYbIGB+PMb0AzHN3AC?=
 =?us-ascii?Q?H4wJYDA4Yj0BpYVvj60Z36EiQoImI+KMc4pIAB2KlNpiKpgtgYME7r4uUG72?=
 =?us-ascii?Q?9OS2LIEsG+QEEDVYFviWj3XDe0AEa9YV7iVXaubmuekKhxjYQegZPaeNWqur?=
 =?us-ascii?Q?qW2d1FZj0IGLB6Itq99CzTy4vm2tAKRPV6oK9PWcJZQqjp5ulVdfjl55OgjD?=
 =?us-ascii?Q?nEs8HA6Xv42NOEZVQZnbZHCPfYbf4rjjPCoIl/y8/K+hpgWoYzTrtcXacrfo?=
 =?us-ascii?Q?+zR7mssP2KV6W/XITenJYsu5/01XjkcoZLtliiUzr7I9I1TqPQNENC+p06ps?=
 =?us-ascii?Q?RN32n0RuoMwWIiQwozZcciGNCFDrykJYhWCVAwNN9YtSAFCOwn7p5vumNpSW?=
 =?us-ascii?Q?VRCYTmf6d4b0ZYyoSMguUz7/M0J6+1lLGDaachMaQV8Cn8fGETGESFyAWdoW?=
 =?us-ascii?Q?1wEo+G9L7pYAotPhxKy5jxEXPK/M8IiDI17fyzZ7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8170d153-f0bb-4c91-f51a-08dd6589dce4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 19:28:14.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnzOlRgZBDgEBv2FfYUrTPL7ZQPHmEnqkYiS87b096ok+ZDGeTK1YM0LLW6YrkZM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6327

On Mon, Mar 17, 2025 at 03:25:18PM +0800, Yi Liu wrote:
> On 2025/3/14 22:48, Alex Williamson wrote:
> > On Thu, 13 Mar 2025 05:47:48 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> > 
> > > This series introduces the PASID attach/detach user APIs (uAPIs) that
> > > allow userspace to attach or detach a device's PASID to or from a specified
> > > IOAS/hwpt. Currently, only the vfio-pci driver is enabled in this series.
> > > 
> > > Following this update, PASID-capable devices bound to vfio-pci can report
> > > PASID capabilities to userspace and virtual machines (VMs), facilitating
> > > PASID use cases such as Shared Virtual Addressing (SVA). In discussions
> > > about reporting the virtual PASID (vPASID) to VMs [1], it was agreed that
> > > the userspace virtual machine monitor (VMM) will synthesize the vPASID
> > > capability. The VMM must identify a suitable location to insert the vPASID
> > > capability, including handling hidden bits for certain devices. However,
> > > this responsibility lies with userspace and is not the focus of this series.
> > > 
> > > This series begins by adding helpers for PASID attachment in the vfio core,
> > > then extends the device character device (cdev) attach/detach ioctls to
> > > support PASID attach/detach operations. At the conclusion of this series,
> > > the IOMMU_GET_HW_INFO ioctl is extended to report PCI PASID capabilities
> > > to userspace. Userspace should verify this capability before utilizing any
> > > PASID-related uAPIs provided by VFIO, as agreed in [2]. This series depends
> > > on the iommufd PASID attach/detach series [3].
> > > 
> > > The complete code is available at [4] and has been tested with a modified
> > > QEMU branch [5].
> > 
> > What's missing for this to go in and which tree will take it?  At a
> > glance it seems like 4/ needs a PCI sign-off and 5/ needs an IOMMUFD
> > sign-off.  Thanks,
> 
> Hi Alex,
> 
> yep, I just looped Bjorn in patch 4. While for patch 5, Jason is cced. I
> thought this may need to be taken together with the iommufd pasid
> series [1] due to dependency. Jason also mentioned this in the before [2].
> It might be a shared tree from both of you I guess. :)

Yes, it all has to go together.. Everything is waiting on this:

> [1] https://lore.kernel.org/linux-iommu/20250313123532.103522-1-yi.l.liu@intel.com/

Which will hopefully be done in a few days??

Jason

