Return-Path: <kvm+bounces-24148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8D5951D8E
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CF98B27F05
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86CB31B4C51;
	Wed, 14 Aug 2024 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kETIiI9N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55A61B4C35
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646440; cv=fail; b=pL8+/ZTkdtYmspPyeGUwtaOeUXJBLthgo8GEOPDm8NuS1WC3zPcF3z7Oo0LOpkG0a6sTYbdbIjoDJ/xovKP0jXAZoSou9k/KWjqMSYhOATycvSt3VTwp+9moKcpDf9Ayg8WT8LsHx85UjLjAXJCkNTMmOFmQffaDUd6eQ6y5ILk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646440; c=relaxed/simple;
	bh=j8hfyhWZ86EnEG6/yEHwxvCPNWOC/+kMHUhLBejr8xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PR5Jfjs9zIuQFP3yKcvwkT3xnGTPVLbq6O7stn4dTE95OPgMQcMvde76+2wYmZ1ZIA4HRqouPBXdc32NqH4pofmk5alpRhB/yByNw9mkA99djvzHT5zxVjfW5OhpNLddj0euiUM5eJ/N2xXnbkx2IuAGa7m7WuzhfQpKXYRKKbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kETIiI9N; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXJewCGb8JW6P0M7zqOx4qinQSXJy7QtjdGh5YlaDRikqVkMw038dckUlp8Vs964skZIkolWHAjKLSRWla11GOq83eWDAG9eWx7VlQjDbycs9YL+M/WaYGSncZ1uxPx3Co3gzCsrgKJ72gjK8Riq/+BnFtK9JOunesqd/hEZZ7SevsN+JNdYN2GCGirFQe4o2VIuKFDsnatLWKz3yq6v8wI+Dr8HPU3rNfmBRQUaZqyQZix1KT+JbT1enGK+9I8eT1C9drb/W/Obzncg3+WX8D46SxUkaeFixU38B21MN0IJyiQmgbJvXFdUer5QI+q2slObN6bZzB8GhASN/5aXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ADFPqOEuAmyuLs/VVWYK7stF5a3+VbJuuQE5icYgPQ=;
 b=TIF+4h5/MRwCoJl8vrqaFk8BWW8k7OffW3J05lKeGLV/RUO9V2Y7peQGO9X5JBzQryJ4oQJG1k4HWHBVjQzYv4B9CT5iWCVLe8RWlDCiY10eEKi4IOokTEyAH5Zb+5erxZVRfSKgaokybDZfAzEwIUaZCsZ+vrqyP+MTbFbOCqANzhs/kj7RhvECUPsbGGp2j6Yqlwcd0ydOTScdNI/egi8iWWyC4MB4jj/zl+iam7QfCERl/fnC9AlJUW50NFM4mW9zuAr/LG5NF2OXZlKAcxNQuYnzwi/JPyOpQDHmdrhtknZx4mkC0DoHSCtbknYNHR6NTw8fA7IhmkA0FwzPkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ADFPqOEuAmyuLs/VVWYK7stF5a3+VbJuuQE5icYgPQ=;
 b=kETIiI9NEohe8fRekFLT64HyUZoxxuWMoWTW/BubAqMNgPQPMc4s1EBKAkvNiboOQOoJ2xg24Tzyv4/uqHdlBnozSPXcPoTyj8D/SPvPH/1WPs/wMfV2i2Db/iA4d7Wtg5rGYZH0qU6W3poj9i3PhU3Gacbg0Nj0gwtHD6EcfI/VcrlCt5FWvMlbIcqbYyZPJbPNIjmdw5scJ2WkIqT93DPaAggGGK3GF0VaW96/AW4ZtJifef+YOx6kH2ALeI/UzQLSKK/eh6hV9fVfKF9VCT2uDWQpRNZaG+VqFHdBtplvVgxAEYEAe+eag1cjmx1b5mP6IGltk89CDHHSWYHJUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by IA1PR12MB6115.namprd12.prod.outlook.com (2603:10b6:208:3e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Wed, 14 Aug
 2024 14:40:33 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 14:40:32 +0000
Date: Wed, 14 Aug 2024 11:40:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240814144031.GO2032816@nvidia.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
X-ClientProxiedBy: BN0PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:408:ec::25) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|IA1PR12MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: c4628c22-40a5-4bc0-d1bf-08dcbc6f0d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O67rNCf9ZlAuyRUNi194HyEzcjJYDcC9/Y01owJN7QglhhVBLlQyET+P5oPb?=
 =?us-ascii?Q?cFkjcqjTg8q4Yxq9/LKwHA7CfFrI+vUOpvYVr9rUyKGqUVOQdHtscOuwQ1O/?=
 =?us-ascii?Q?GCMoY1RjJuVjbZlPhHA5XFyYDk2DCrKOvppXQppd1vZdAuhbYliPupMRRGH1?=
 =?us-ascii?Q?8M0GDA29Oz0mLBsFtLCtrtj3Pwh2lP3ZvHOn4xyJk29ofiDa0YKXFcUiYnd6?=
 =?us-ascii?Q?OpcX3Oip8OHf2/Aay4C6GJtIcTcQuwNI7kluaVS5+AVGmaCUjoCKamqf3BJY?=
 =?us-ascii?Q?PeUhTbENmtV4P5DilCfUl9XSMUQbyKjp04kb1E2zVVeo9UkzShr03TsKO155?=
 =?us-ascii?Q?LUnI56oGWwzGfYOsrds7mxu1UYbDu8IshZ/0Ska/VcXx4XA5/eURubWkGmNS?=
 =?us-ascii?Q?rB668sVmQnSkH3NQqjmA6JxGMX22gnb/FDEaTFJYclAAL00Zux3Ywhz+QHmn?=
 =?us-ascii?Q?aiLaqgOLeLJ4daZkf6P0gPFtB353JT2jT4316TlcE10HskXvzPwWzo4veARp?=
 =?us-ascii?Q?Ncgp2O3s27MQS7h3PAM+bV+UJxFtCt2vSgPgbBkupYkx5vmT0I/9kPqhB2MA?=
 =?us-ascii?Q?+/XkQ0YEP0g25mxeAc1vWMjCLP4smsE+twtmTK+Ujvvk3oE1AtUjzpKL3eS1?=
 =?us-ascii?Q?K/ed/+UQJhF7nI5tkqpwyu5kao6gtbj+1dxCfLKmEmYT4Bqxok/mnufiZ8iV?=
 =?us-ascii?Q?kHYUK0hFe6UYS8dPpUp5xIBpOaL1G/kAhovMeQtpABaRFMFn8JDht0EZFbIP?=
 =?us-ascii?Q?w5w3Bcg/D3oqpZpV5zQybwMgWmiT5bTs7agga0aX7uzynrXwiogvzsMmRuBA?=
 =?us-ascii?Q?e8LR1DH4o+4uit9iB5i1uBaIXOeF+SzZK8ppyDbBH7zS46rWdAhnkFrrp5c/?=
 =?us-ascii?Q?g/B7QgT236JF6ddH48LNQfan6Njvh8SDC5FzffiHPuycm6p6odtCi+p4YODi?=
 =?us-ascii?Q?PKJxQq9VNdITp6tytKGDvA5wXdbkpwdOcmPbYMeiD2kcI+laZ7iByXRhcWZP?=
 =?us-ascii?Q?Yv8p/bWh9+S9xrYaBiGXCkHGBi+5nTJ+ZxHGKC5t8HvlN9pVdCVZJ33jnJiz?=
 =?us-ascii?Q?yyjKp5XgBFQTsXXLjCKkGHX9bWtKAHJTJIIDg8VtMGjtXXJZT7CHLVE3bRih?=
 =?us-ascii?Q?e2WzL7bK7WeWxk6WGgqo7xDphGFuLUlycAfD1ZdCB0neFQbnzZlg5MhnhZ3g?=
 =?us-ascii?Q?mXHhRoGuEkI74/UMlkGmoEJuNLaL2Vn5b9ja5wIG6ZzoSoeul0no8bzi+fOs?=
 =?us-ascii?Q?DQLeY2CtRbei+NWTHPUSIf0KELPngw77qyyNMd4wKU/FFZ23Z14rlmp2PvVe?=
 =?us-ascii?Q?etYtLWoQyUHeRSzF1DDNhwteSt/d49Gywi3CdncHktJTig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMXYY2BEzcBYGCMls9izFajusMOewKTzB7rNyKgS5GhAl2vioSeNXJBQCqdL?=
 =?us-ascii?Q?qGz8xnYxU5soEk4r6HraqtQW9BO7bhPIi9miU15izYEl3RaTGBvCMjaP3ux3?=
 =?us-ascii?Q?MDVmGfO00wBcSTtBGEwZXRbJAYA6H2/k4aRvJIpNmynoQbilvsMKdgeYjZnQ?=
 =?us-ascii?Q?zm8Dl0ZsuUlpgIkZPlqfWOX8iRp2JbouLLuf1lJLdzP3v/olNCAypLBckWtM?=
 =?us-ascii?Q?6xfiAc2ZVOlZ3LdWVk9RQuf20wI30T7a1b3HLHY7691Ci3xHt/sGgFYAW38Z?=
 =?us-ascii?Q?WObimgKhWrMD9IhaY8e5Oj8vWIYG0Qu5Ia3KYVokgkfkQrFtLAFzXlbPj1+H?=
 =?us-ascii?Q?+rOSlqfKIvKU9+r/CGMcm150SG0D5L42gq+Nb4Dz2NdJMYmssSWqSYHKSARB?=
 =?us-ascii?Q?HAUyWqmjVidjiZNX+QS7xF7j150OQbxb/ckTDuOZLDro9GXbUpSx163rMNYU?=
 =?us-ascii?Q?W2Fc7g4cq6qYMx6RlibaslDClHHsBtCZjTIz+aUG7zZiiyITS/WXFPglRGup?=
 =?us-ascii?Q?ypbnpRFgVWrnjF0vILIUriwt8YlZ0R1CnYPRIaMLrVl8NxwlXXN6S2z2Yu9W?=
 =?us-ascii?Q?K4Bs0hVpOWqKsRw+UrexL8IZrRw8TsbGNeqVuJYkLCXhbiAnzxVY11KkQFEE?=
 =?us-ascii?Q?4WqVkysVERLqboaC8vOoTXomPAeuG2FyIPzPZ2MSUAmG4/CVA1I/0xZ1xU18?=
 =?us-ascii?Q?DSYCVkOAU9sfi/bL2n3bvlIuC0vViA249EhXQZMjuiCoTDaxsFcnZBl9MHJJ?=
 =?us-ascii?Q?hYbilfVKhWhtqUdtdHciBzazhXppiLmriYT01VieQRjah5h0FnLxHx+VmdUV?=
 =?us-ascii?Q?VrynwXlRU+/33dKlvT8QMj9Tu8Iwjow15ginC2nK7aF6ftNKo2ct9qMVh0Qm?=
 =?us-ascii?Q?1TqkFrKEKTZfqcI6OWLPKJbgOyfZMY25TKkROWvMQJicTZXVk6g62kF31/Sp?=
 =?us-ascii?Q?CKVDTgzBNNSEouI4+4zHIMVe4Bai8WfwbMPBOZj1xvYVWRd9TPpxzNvtWoMA?=
 =?us-ascii?Q?68JyvG7aQTXJRUNIOHtl0jDl4/T62tUhxX1fJDzxyJyWAiVh1rTzYZKVU9nB?=
 =?us-ascii?Q?8qeR6HlBUdnKaD5sgYXWiKg7Vrr1N02P4uT7NWq8hM8Cza6p0Eiwf/MBJ67T?=
 =?us-ascii?Q?9AWgepgnMSi/59W2rC0UIUTgmXNFjaIIrErsS1Y0Cl6CcD0RkUxfvaDzWtCV?=
 =?us-ascii?Q?AgBJ+KiH1PMPPZ0RxKM83P3Wi1yBJWMrazMci92N4FgZN+7znIG+QfCfCgjY?=
 =?us-ascii?Q?Yg+t3yuMYMYCOm1GG+1ZF52GbMdATbyEgQiDsrNuj/jksO0IZXUzgg1xDGcj?=
 =?us-ascii?Q?KLFuqPn5JVEbszJmkhOEk/1ubFtHX9su33SwdEM9UgOTTM4fqkuxp44Kg1y5?=
 =?us-ascii?Q?mPf9zAa34y61tu4P4sAIh+rvRfc4NuIBX3apNn+QEvQU2+tMhIY/btTisduN?=
 =?us-ascii?Q?X/pelMRyAtHUt9XuGI8Hu7frR/iILrsyiy1OtIt7DazIfs43Nxo4DRQDh0cO?=
 =?us-ascii?Q?Ht1CxFELT71zOfnFy02jHwxKBQHUccXztSAve/2HKeWrtj0V3CPOMTHwFJXF?=
 =?us-ascii?Q?GbrOBBcZfY/QolAGxBCVt2dLPiCenZT0SG3MXDfv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4628c22-40a5-4bc0-d1bf-08dcbc6f0d0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 14:40:32.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ga4rhQJnZ0w9ldPnilE3Yb04zNhZirjiUpMC/RMJR8wiV9VJpDDI/dfVeyggVa/S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6115

On Wed, Aug 14, 2024 at 04:19:13PM +0800, Yi Liu wrote:

> /**
>  * enum iommufd_hw_capabilities
>  * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>  *                               If available, it means the following APIs
>  *                               are supported:
>  *
>  *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>  *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>  *
>  */
> enum iommufd_hw_capabilities {
> 	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
> };

I think it would be appropriate to add the flag here

Is it OK to rely on the PCI config space PASID enable? I see all the
drivers right now are turning on PASID support during probe if the
iommu supports it.

Jason

