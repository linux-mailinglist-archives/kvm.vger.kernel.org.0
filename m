Return-Path: <kvm+bounces-56881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A51B4591B
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3249F1BC4BF8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D870F3568E6;
	Fri,  5 Sep 2025 13:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uUMTLApe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9F18C332;
	Fri,  5 Sep 2025 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079103; cv=fail; b=GwWwDHKsrtefkj7OjY8AuCKVvAxMUkUfAihnTQhD5BpSz7iTVycl1VwjSSwBCy2gxQmUh5lvOpKm2P6Puw1sXp9vG4ePtqgG+kuDzt74LACRWJNPMfbqvkGOxS6f1IQZ2OvR05kg/OHttRlr5UpJOl/GYX7jEyO6IOFVNllYnN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079103; c=relaxed/simple;
	bh=s58iD2qrZKUIKuAiufO77kCJaQbi53NibRmlHcMUOIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Om8xzJjzmFz/5QYfiMHisGpl4vqaSXCrhLff3GB6DK3kBy9UsQE2KAJVCP/zXwFngger2j1X66qjnZMPyS7hjYE6TQsoyiOzip0S322Sd4Bf7dWDr8B28wWyP+9ZRCvFFTqw0Opyn86PprVhhgClYfpCRNSpYQHor2Tt5UFEJ3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uUMTLApe; arc=fail smtp.client-ip=40.107.212.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnBCg3uz5jQuTEFp03Z5p95P2iMfU3690iK9q3bwDaMyzRtUZJKL4cxnkkKqw9oHt3KxAQ7c3oi9Tzn6BF3Ti6DjpVsS5CgLGOXuUvICg3X8BBmB7B5+ucZhHy8gbROKQjcoDxSaoATKPA5l15fsOS2EGvzQtXfTpkfY3A3ftGfU8grS49a21eFby704xC4GhFGuKpRNXlsoqvfowapOSRrnQJCxWmi626bGSnnaBD/FqpA920VXoxeb600a3rVWSNDwKUBNK5ctthUmu9Nvc6ScymExCMlOqCyaYjlCZhiUChVRXLUkoRdFyAQSzwOeDal3HorEPh4bIo2gn+XDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLgEmlj998TCq92QaqvKqY+pzWpEkBvyzfgCkvPx8XM=;
 b=k5abl16W4ofjp26iojb/Tu0uT7i94hgnmtHADL4u8Q30kcmfiQG4WWAVn8vcXrU+mugNFfziDBYOUYPaqHEZ/yDcobFjYY26PEj6R2vT6a4F5AR59N4zQj9hIBANBit6eQrCCbmLk+Nj8JLkGzXEnu4FTcMLBPyJZ/GP0YG5gv17zqM2QxD6dQzGFucUNYc18VPkOkvJiv0hD/mvmwKzdffkkH1+SisuqCdaUQi6qDPHER8gGe8RkF96Kju5ocmDlb1Rw5jjVjyw90S41LJHpoXNheeCU6/SRh9yImWa3H0n8BRnWaIk/ZfBGfGLHVC22fSm2Vr8U6iKst3mx9EaaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLgEmlj998TCq92QaqvKqY+pzWpEkBvyzfgCkvPx8XM=;
 b=uUMTLApe6kESszjq0/5NMZ0fluS8mmdsAlBwJcI4sjUW6di5x3+7ZDh7ovDBag/mZUGtI2J1VPF94IIO42Nx6DI0sM6SgSAHS1Ib5yYfaGFDA/6cbzFcTNsS6UK+OlciXwKSRPZDTaizErm/OMn9/S63ln41eL9mEGcd/Kzl79sUq68CvVByOG0Bnx52ezir6IKbFR06M6vWT2sj9ns3ltMNIh/6t9ryb6zt4/FTAqJZ+yYfmIvQs2NnPi5KecEP6X4yORId6MXlkQrJnqxk17oGdGoQfWyZKRSPNPR4/vrLZLW0sIGREtKdzEtUFgGh3pDLqpMMhXvkglIPR7wgdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 13:31:38 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:31:38 +0000
Date: Fri, 5 Sep 2025 10:31:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: alex.williamson@redhat.com, yishaih@nvidia.com, skolothumtho@nvidia.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, zhiw@nvidia.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	anuaggarwal@nvidia.com, mochs@nvidia.com, kjaju@nvidia.com,
	dnigam@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/14] vfio/nvgrace-egm: Register auxiliary driver ops
Message-ID: <20250905133136.GD616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-8-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-8-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0419.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::6) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: 08d4ec1f-4e3d-48e1-b620-08ddec808a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k9nmF1a6hYTAcWZeQ46nT/SIKigjqHX5tk34DaEr29qqwKGO4Wt/e8Z2jBIQ?=
 =?us-ascii?Q?yCjyXODpXyAlYEDf7d0yXo8nSEh5/XJmr+Gg5zbqGNpwmmm0OPUcfhoU2KP9?=
 =?us-ascii?Q?xUqLjdz88BRXEkF3VZENlkTuxpLf61Gdng41zCIVqNR8ZZHXgn6nJS27+J9Y?=
 =?us-ascii?Q?2jvTx2MeUGdnhxLsAJTeuIk+LpIAL1axECFkziVp4szAcMsb/w56FaLFJYRW?=
 =?us-ascii?Q?6FMlNNsgqk99dW0gUf38tlbeZiPk4dos7CmrXw5jOfZ8qJNGfBpY0CGnBMJS?=
 =?us-ascii?Q?pnrDWdxENMOjPuVOpxgmY5vw/pDprc0Nzhl0dUla0QT8d/hngE5okvCKM7V9?=
 =?us-ascii?Q?ouUqLfA9JxBOVu1Dyx30kBthlMa6gmLh2sGffartHkF16SBYBOMHUElEBxBb?=
 =?us-ascii?Q?noGuag72l5cwIr7oPKL3NbX3zChvbj3ql6yRvUhh8dYbntiswopqo3wlw05m?=
 =?us-ascii?Q?JxJHCckWFPqHyEsqmkv2xenmvF5QWsT35kl7orMzPWrJWvZS2wQF0iLa1QcE?=
 =?us-ascii?Q?AJYJ/P+NwZUuWm7C0T69RhRIa/HNbvSV9Rk1na2rfOjU+DPB68AiiFnMz12h?=
 =?us-ascii?Q?hBD5JeUxwudC8ITu4nR/ktXKcPjUM/n/QT2fcMUyvXNUaMwZ/W7oD409yopm?=
 =?us-ascii?Q?C/NigHUhkSGo7YLjGnN50cQw9yzZcCVtqtigZmxCWAC8LFEOuZd4puvk7hhZ?=
 =?us-ascii?Q?IC9ROBYbKZS3AY8QWngkvtZEfiSVfOpbpN9vJ+EYLISM3p13Lpa1RXb1yDgv?=
 =?us-ascii?Q?s+8ihBa98nqd8A1tQ/ohp2PZZS2EZkVzB9ZeKoPgrlJURrwosh2IOoxpO8J1?=
 =?us-ascii?Q?E/NeRHYlz33cy4aXDauR2eIWeL2IrXSPoC09Km2Tt3ZQB1ZOiqxigqktmVrE?=
 =?us-ascii?Q?H0ieP1TBKq9o9o5OqsUV8UQt1Ai3glvRBz14T8lJbsDpGUxyL8fdkzML25n6?=
 =?us-ascii?Q?KpgArj90Ag3tFoK6dm3GLAU4AdcXqtRKb2cA1W9C5I0XF3AJeIRSj+aEd5RQ?=
 =?us-ascii?Q?JO457cgEsPJYxPeSnbeCfy42DkttoHje4Dyi7cSDZPRgYNUCIxEALlcktCUw?=
 =?us-ascii?Q?kKFjrjzqwxkJc+4/X0G3lyWBRcWApT94rUyNPERDBrN7O09YgfcT+q0DsDmk?=
 =?us-ascii?Q?ZjzshFc2MfRMHueSKhrEvRO6+HoxbOWUwk6jF13h7HTEz33piySIdAUYuI5p?=
 =?us-ascii?Q?dcOlTVHW2BoFcmIjQ+CPFaxIfzCqxenokTyaWbIsJGnbJHeJx3vBs/Ogeypi?=
 =?us-ascii?Q?7MEtBrUrRDBL6k/oVvyYsbdnWsuRless68xgOanpk0tCtwBvF25t6+6Qf64y?=
 =?us-ascii?Q?nJvU2ZVijlsQxMPqzPUqLkFJhrXC3UK2t+iw/Zg5ZRtYI2WEMA3Qyp5eIS2l?=
 =?us-ascii?Q?iHVFlJ9sU3y5lvaxDUI5/i6oijiriQCKzJzeTnZSfzbqCWz9NS5ombM1EQWW?=
 =?us-ascii?Q?wsW9Geon+mQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cPm1FM1DrLdmtuH7d3jx32jOmfsE50XnJvjGvje0pXvspRnASCIQbKeERP4U?=
 =?us-ascii?Q?9T5CMdd+JsnzZVkk0zqefm2v7wUzx3fwiMD1cMZY3QPG6pBMMOMkmJPOV5dT?=
 =?us-ascii?Q?8m4tmff+GBRa8awQyuZJDX8x4AupiGXo/IzLr19QaaV0E/hY8CCXecuM2EUS?=
 =?us-ascii?Q?kNqVol9xezYlndnS58weFGsaKDg8HB+dP7QSUqj69kmmroy9KOiVIstfVbYC?=
 =?us-ascii?Q?Es7sYujYy7Qau+nt+lmlMcz/0kWGwU0m7WGgbVmmslcv7RPwDs25Zbatlo3y?=
 =?us-ascii?Q?6ar7/85Dgb0Uh9DOJkYIMdb/glAokiBpxqnzedqkVR+Y4+B+6teMen5KeOQr?=
 =?us-ascii?Q?eRNmtzQ5sRo+0LIIvSn94+e1tSbyo0WCFQveWNkqq/B2HmbFZjx9T1FcKhKK?=
 =?us-ascii?Q?+PJmmgUbTMZ4vvYwXnDhVMKV0+FKIyDqIamvfFmvesD6P36WTRryWogcFk+E?=
 =?us-ascii?Q?34h+lYri254BIVyQei+xnNaEOs15afnQQD6oTKoYw8GX3JLLe5yIwjEutAYq?=
 =?us-ascii?Q?LvOaoZQn7eLrdwSQCOVSuuqbwfcXaLTqhJo5d5dd2Y0eq4/OQDxc0j6AhR2W?=
 =?us-ascii?Q?T1IfVW+I+M2szFxzzOQj0wb3K1WTgrKiXxtnL2xnNQvCFhYAYI1/99GSH1VE?=
 =?us-ascii?Q?EvZ3EQqBNelUVEJorzuYs+hB+AoQNJHSO9NUQLr8SKQuOc/Bk9HB5KPe4mc9?=
 =?us-ascii?Q?Rqrh0Rai0If1S9Nn1u106tofKZHoUhTySKRt5Gpv7oqCXTRIRnIWQ+/TwF22?=
 =?us-ascii?Q?wsFaYAaKhdhMnlr5a6CJatfb0oAAPvVevoOXpUJ7a789MMLft8jKsV4bBcES?=
 =?us-ascii?Q?PAZl0voOaTWQwYABU/xwkkGQN+gSGNeJPmZ8+TcZs8/TZR83LmBSAUdclD6X?=
 =?us-ascii?Q?kS15VenCy+RuXr0UABhrmLlG0yXQFBHJZiKr6Ir4FiVBaTkGzQWunadUP0Cz?=
 =?us-ascii?Q?vWUtPXky234DOXL8WTInz7Xs34+m92rQ4GNgWHKiNwJrauRgCNKH9XC9eWNs?=
 =?us-ascii?Q?1jK066HJIvCXAJKsOYaXWRlgbBUZS3KY0U6lnluyvr4AmYvwm76Xj/kVklbv?=
 =?us-ascii?Q?8Yb/XAPy/+j0M/OvWer41Ug4l9XFUgNAJVzqdKNQz6qbSgI+pBshrOVW0ba6?=
 =?us-ascii?Q?lpdFDI9xqO2cj19HpYguvEdRRvEaoApubFtDtetrFq57T6isYKv5vFzJBFQi?=
 =?us-ascii?Q?sAjGpXlwh9Oq9tmlslpkq1eiCnYvUBazz2DySZ+mVUpdOm6nAtt1KIzTR/cE?=
 =?us-ascii?Q?USsXEN58agaOklEV1lNe4JXW2hmROmSfKm7u6KcO9uOYD1ZOnwLRO/wJey2M?=
 =?us-ascii?Q?MEyb1K15NlXa8WagrRD5lwmOyQm/tzwRY7jLZqRyccu/o08QnZkjNljVQeHf?=
 =?us-ascii?Q?1huCLeTOENzbK+8M1i2syyBBRQqqCZC8WpCd4FLtXlLZzP/ltMeKJtcTOSqc?=
 =?us-ascii?Q?LkhZzZ1BY1nkja4u3rbtVXNAxgGzRSjH7YQrhngvaskxvsS4gbOgu/joRrmm?=
 =?us-ascii?Q?4zw7nTxxOAekeLmEQxEqj/5EEmtrEGYlYL6Mw3oE/I750n36eCDTMlZ+yaxf?=
 =?us-ascii?Q?VlVtTPsDwrFvW3EdZgA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d4ec1f-4e3d-48e1-b620-08ddec808a92
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:31:38.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqffDYJtSY9U1qi6XquLhg5r1v0Kk6TYRwDDuFxdXeGHzj7RGkVwxsjjlhlCUuXq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

On Thu, Sep 04, 2025 at 04:08:21AM +0000, ankita@nvidia.com wrote:
> +static const struct auxiliary_device_id egm_id_table[] = {
> +	{ .name = "nvgrace_gpu_vfio_pci.egm" },
> +	{ .name = "nvidia_vgpu_vfio.egm" },

Not in tree

>  static char *egm_devnode(const struct device *device, umode_t *mode)
>  {
>  	if (mode)
> @@ -35,19 +59,28 @@ static int __init nvgrace_egm_init(void)
>  
>  	class = class_create(NVGRACE_EGM_DEV_NAME);
>  	if (IS_ERR(class)) {
> -		unregister_chrdev_region(dev, MAX_EGM_NODES);
> -		return PTR_ERR(class);
> +		ret = PTR_ERR(class);
> +		goto unregister_chrdev;
>  	}
>  
>  	class->devnode = egm_devnode;
>  
> -	return 0;
> +	ret = auxiliary_driver_register(&egm_driver);
> +	if (!ret)
> +		goto fn_exit;
> +
> +	class_destroy(class);
> +unregister_chrdev:
> +	unregister_chrdev_region(dev, MAX_EGM_NODES);
> +fn_exit:
> +	return ret;
>  }
>  
>  static void __exit nvgrace_egm_cleanup(void)
>  {
>  	class_destroy(class);
>  	unregister_chrdev_region(dev, MAX_EGM_NODES);
> +	auxiliary_driver_unregister(&egm_driver);
>  }

Out of order, the order should be the reverse of init. This will UAF
the class as-is.

Jason

