Return-Path: <kvm+bounces-41973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C2CA7022D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 14:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C377188EE75
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 13:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A6E26158F;
	Tue, 25 Mar 2025 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZQtMsys"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8B125EF91
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742909128; cv=fail; b=RgxUxLzQFI2Xdursezvaf3cZZ3u90Hob7r8Wj86SFdnVZdZ/jQ/OyJIszkX3Rh8UVEqTCSJuZIvJVYRyfaYZWmhKDaANMMa0zyF3blsy7roR3+b9tRrSbA/ksnbV7BmeeRa571mukBtDhUixMCCPBd5iiylkIuMgDSLKQMH0aTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742909128; c=relaxed/simple;
	bh=65gx5cn5C+XnUTc6j5rT82rj4sDGkYZewlSIQixMs0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EdnNM1adKdoHVzRBNJM3TUtBdZElVmlPvJIngSfh71hpmvcEJxZ3/utEnLbKYK36m2dl5vfYNo4Ryv4EvY04S35KnWqeFLnTRn+8zdx9jDBgtN75vy6uG+gd2992QK9iJROvR62aDaqWSa2fi2gkeBcS6GpYPtMaK6KasNOQphc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZQtMsys; arc=fail smtp.client-ip=40.107.92.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Giv7KOXmfyy7XcO2yRwn7LFqIHd9mI8pxyIdwux0GHAszE3VDpaRJPzB0+/OJEMKqhZpaAeQumEcwprW/O+su0Eix6yKNpm2/Ve4Hm/zVFu9dDuHO8zbKMfrPBtVA8XSlA9eqt2Y91LN0M9/qRxc4n1aWzFyIdOBAcsOLaDvmXL0WmRgGEap0vVvozq62AEKGg4B+CXyGkKrhxGJtw3phqePD49bqp6Vlq55U/bdtFaACpXKgKJZypzcSo0iplvtqOITT0/wHSgJvNdQq9SXj7MTH50kGX8w3QUR6dqJ5ZPf1S9X4KIO9M7BpLootM5+51k69DGKAOeTlswi5C0Tow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NtnofUICGLXCdg+E2RArNWCuWnF4XtYJhtcV1aHsh8=;
 b=Osltu26jZPxoyd8imoaO7RKvTYRoxHTHq16OIHHA9zCjtBCmQG6pD7PaEh8YsSppVsP5Ji39kFqc/Xz9uNyT4A8eqxqpDW5ESXmu8lq85ItiEMUIyigRXKvKj3XnXFkFG9PJ/D+tZsF1nnwiEpC//rrgECvaeae94iK5qDRN86pdph2Gb0ahkqHWTJPEVbgx5qzmeRK5zdwUeB6Ds6GdJ6W1DFXRzF+z1TP/OH7Ks2R1SoL9F4r0UOq/4jGCReXZXaxHHruOv7lHw1A1cghX06B1ocp6p2dZnAauXllyOJ/PLUAf3SMd+AUSKdOo1Y+aw04n1EYOppnC7xnG+bENIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NtnofUICGLXCdg+E2RArNWCuWnF4XtYJhtcV1aHsh8=;
 b=iZQtMsysQbgLlQQiq3EBqCfzFjzm3ZHz1GzDyRhXVDeyXGD8OKio8YI/gQQNgKFhC5EwQlvQBnOb52vdfyRLjU5Zv9Jm3IB7jn3oYRfG7+6npL8jayu9muVDvf3LQnaNNbZN8vPqkYNPNl5FE48MEsIY+Rg0YGyL+yX4FB6Q8XvaDBEf5Wn4quExSB0VPGP7e+TCn+BauK5bHvewD1RrqsYY3uY9lk9TCcorEFA24+8VpKu3+sTp3O3sM5tNWAqeJkidSg2KrcClJMEoveCWC4MVe/oNlqEmvT1gXVLJ6hJfr/W1/zquY7BEZhiMFcPa38zryQqe+I3TAtOMd9Dq6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by DS0PR12MB8246.namprd12.prod.outlook.com (2603:10b6:8:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 13:25:23 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 13:25:22 +0000
Date: Tue, 25 Mar 2025 10:25:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, eric.auger@redhat.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com, willy@infradead.org,
	zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v9 0/5] vfio-pci support pasid attach/detach
Message-ID: <Z+KuwfSNHnG2DwHr@nvidia.com>
References: <20250321180143.8468-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321180143.8468-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BN8PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:408:d4::25) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|DS0PR12MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: d8bdecda-dd0c-45b0-9c17-08dd6ba07ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LKFFslp8o8LTyZvo89ZgAv83RsddcQVc9QAIIhxVckPrZK2G2dBy2WDCCyBu?=
 =?us-ascii?Q?ehJR0fwodwOzRQY1VX4hjR/MLLJDjzI4X6Sa3F034wU9B2I44fFYRQ/Tf2US?=
 =?us-ascii?Q?FARfQl+OE/zbWHJy59ODE1eJI562ebaL37rsalHW+mrgj2Uy+mEncCfdIAEG?=
 =?us-ascii?Q?FRSnE+1ZS/+XHzMjSJznfJKYonccIOd9CyS7UcmlOnyMNmL2bZOeJqzRfGGM?=
 =?us-ascii?Q?ylKUPwWSzgGw0zQ3+jfvrVFSkPSgw40UPx80rXFlZBof5vE/rETILAafirGf?=
 =?us-ascii?Q?IxaF/cGX7UcpOOC55vuf8fkEaxiYjXmQgG6gBlVhBoRgJAk+7vLZS3+pE4fs?=
 =?us-ascii?Q?DZ0l+tRHM0hGvDKUSoOrdscj2cTRbvWW1MyDJiWzfl6umnSPy4jegyJ9KK6j?=
 =?us-ascii?Q?Ys4PXa+JiffKvPZtvCSeTwNnyybS9bp03b3Wthz62k6xh2sH0eOo1fbeH7GE?=
 =?us-ascii?Q?C8NiL+Oyith6FmxT39lqj9TiPbvj/pigB2DSx9jrBkdfHBHYHf2sPGlqIQT7?=
 =?us-ascii?Q?7cP21MnHM0ZqYNvjxcw93tSIDdZMqo4nOeC96wxCA+1eYJNEs2h24ijLA/lB?=
 =?us-ascii?Q?axMekacy95O1BZUDvFbBg61vqQ8PY0yffztkBAT+WQJWmBtlabb3zH1Zr/sN?=
 =?us-ascii?Q?5Q8hza9nS45ut7vJ17FVAYdQiS75mFk1kqEOApBRU0b7ovgSkwllqBmLoozw?=
 =?us-ascii?Q?mC4kWBZPBRlEP003oLj3xiNRyiwFvcIAtI6G5hKRjlwYAJqmR7d+26qlP6aG?=
 =?us-ascii?Q?WT+b9b6Wgwh+RrfAa5gvG0mWTSXzZV5hRnkM83jgaQbjvDg0BMH8Lrao8iEe?=
 =?us-ascii?Q?n4VwrhoB6vWa/raO2QnruL6pHvUANECPzdg8FkDhCqLTZa1Onf+NtGfhBC28?=
 =?us-ascii?Q?IpsocFk9S+XEscH58BinsRLnTClp8VQAlK6rjILK1C9CFGE2WsCePDMZ24V5?=
 =?us-ascii?Q?GJBd6K4mYpcQuwmvd5u9HOHSwQJYHgYfmPr2Ukd24/myE23WuyuD9CNNARgS?=
 =?us-ascii?Q?rmfLza/pAO7CoCjfCgbS+UWahTxGlB8BUbifqQCLaPv8/FnEDZLV8MKgSciC?=
 =?us-ascii?Q?a9GwXH2r5nohJ0SMwNXnDxuu3l35vjBlCZW6KZnZv1dmjAQK5VT/OoP0Kqic?=
 =?us-ascii?Q?3GJ4pMF3nDToANm5mtmfm/CecSTTMPeCCCPWNxLC/02JG8FxqvBMNR+f+tKd?=
 =?us-ascii?Q?nbU+rrZPS+y2/8JaEE+sMVRramIHjjPVdlyT+TE/6HK71h9EMfbgdVsgUnGz?=
 =?us-ascii?Q?HBxYKITe4GfVJGN8m802o/1PsBnwUseKKCs7u7Qlnl+GbiaLMyWne6koU7Hb?=
 =?us-ascii?Q?UA9hhJ9BbZ2nRBBpjPNgLpUQ6kbzKyKVIIJIPgyPhmEejxOwcbO3EOlYqiWQ?=
 =?us-ascii?Q?9vgYfml9kfXD7luImXL/nCOQZg/G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ow+JIksG1RPVt2Ekfzxpv4ruv54/LYwqre9ODn3/6kkj1Xt1gQJurFj20Nwq?=
 =?us-ascii?Q?DiBbnhAXjXKpGZK3dfSit/adZf5FN7otgd1bUkP8BewK0Bp7KZ2vHbKNHrFe?=
 =?us-ascii?Q?rzE8y+vstJ5+HIybqSNi2bZBEueadVEhhKKbZenUogbIODSY9tjje2NkvEZ1?=
 =?us-ascii?Q?leejqBRcILhg5yoU8f9knV1+yv9HKDhY7c4pjrL2UVSB8U0eArjW/8PLPCno?=
 =?us-ascii?Q?JBTkLUkfJac3M+PTEC3CcW8DbolZdbCZVmZ72o2kuFXP3oDRbkUohzzgjvX8?=
 =?us-ascii?Q?o97paLdnMIyISukz3l9FBPOb4d97tPp4wpC7ESPpXO9LZUMMlRnsQBKj3eAd?=
 =?us-ascii?Q?fG9e1fD19w4ZEb/d5bPsj6ehp1gOGTuIDP6TTxLJYsy18VqJvbl/IL6tP1/V?=
 =?us-ascii?Q?NhTb0SKkwQVCby4R2tNvDGqDLPnWQJnmGXwhe4zJbthxZYtu8uMSodeM0DGR?=
 =?us-ascii?Q?kEtwU06ZKpfzsUjMmtsqU/n6pIya36m/Ob8k2HbuwjePTkNlK5I+a8qq+OAr?=
 =?us-ascii?Q?fEZzkFgiM0DRPiR6EGcWd36F4z7llzvTR3jkZlpdtxT8zIWmG6jOqUGS98Jj?=
 =?us-ascii?Q?a7Jttjl7FVCEA2aoFLPzDiK9c6Pn+6wr8rSogbLLYquarNh4zF7UPcZimIV2?=
 =?us-ascii?Q?S6BSooJrerMtxSzLs6saql4RjeD2aVZ2JcY9OnvxZElEY3Os1tzWnQvxG7WV?=
 =?us-ascii?Q?XV/tVPxBhoSIZHu85CNGCtXlUpUl/bo9xVK0UlUS7tEZTT4ID7FHm3yxpy0G?=
 =?us-ascii?Q?8r4uXPfsgBrHReNbIta2OdoHQiyMFfmGsdJnldTFncxpmdFQjM63mdDkkqg8?=
 =?us-ascii?Q?cJH/adkVNeN3t1+IHJes23VuPOxas25W0UHbGktyaVHhgxEEp7h/LVkGg+h8?=
 =?us-ascii?Q?2IvL4Hfaz577i9DQ4DAF4MmiExva6rnRK1SHY5k/+kKG8ajme3dt7OBFxx4r?=
 =?us-ascii?Q?m8HWHTEr0yErVFthYH6b4n9mqlchp7qtZjTHP9HbeFoVi1JCVo3SHb7FpbAD?=
 =?us-ascii?Q?FELFtlHVwLaJQtW6KmsrDYCSwLJJL6zF0sedIEycuF9Hms+6Al+DbUnkY580?=
 =?us-ascii?Q?z8qBEMOZTzrkIZjsWp5wabtg2oojCaBZbD/euoYrs2iIhUwaJ8TK170u2UkV?=
 =?us-ascii?Q?3OZANqcAzthBVAM5ExRWvLtgZ16DaV0l7gcS8+fTYbk3/QhGXJlncKsoVDTT?=
 =?us-ascii?Q?FkfekXm/r27dMorLt1g8GQWfOaDrD0rV3BO26hLuMf7Ap5lMtVJ178klFGJl?=
 =?us-ascii?Q?k0jEMLO+ep1wnbtJb97r0YiGN2TKeYV/MYG+htT6XryzfIQoPb/1d3gExybE?=
 =?us-ascii?Q?rxJKKutUMscAtC8PBnvj6GUoOl5H0M4JTTkXgE+DuobdbAgjqmg7/KpbqPOI?=
 =?us-ascii?Q?PJOzRhhFgi80/wSbaVe/zJOYjjMZtcekR9dyYOPphiewSeIUeYQWvuCAKVT0?=
 =?us-ascii?Q?p+qYfwAY5Ka9Q3afqZ43uOEowFaIrlNk6F6xi3XTN2tSJzYMMQ22nElyo/8r?=
 =?us-ascii?Q?HLlfEFQy+o+b6vOiNPdMli2bClZfwyJbMget5BCKR7nl9glZxP7VW/euWHI+?=
 =?us-ascii?Q?bjMkAwGLPi6BflpnzBI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8bdecda-dd0c-45b0-9c17-08dd6ba07ed9
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 13:25:22.5158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DuQ0C+H16sqzpu4gYcs2p4C8y++yhkDImQQBszU9hE3G8+ddtLKXrD6WOy7mPTvd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8246

On Fri, Mar 21, 2025 at 11:01:38AM -0700, Yi Liu wrote:

> Yi Liu (5):
>   ida: Add ida_find_first_range()
>   vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
>   vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
>   iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
>   iommufd/selftest: Add coverage for reporting max_pasid_log2 via
>     IOMMU_HW_INFO

Applied to iommufd for-next, thanks

Jason

