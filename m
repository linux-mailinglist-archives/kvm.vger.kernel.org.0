Return-Path: <kvm+bounces-52552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D9BB069B8
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74E941AA754F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0952D3728;
	Tue, 15 Jul 2025 23:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hVunNKCr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D4274B5A
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 23:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620784; cv=fail; b=WDg5I+hG8hiY3dOIt9a+4CJdFvY1+bAyqwsvwkcc57/wwZn1C7tWJ+VzyfCq1MT/jdmLLYTEU20dudDSvAHKz7c1ZbzzS/vHQLpgeX7SdmJ950wJlsi+31meA/h7Qw5AtLoQtDnxdGXjXcAvBgUsZ7BzkCpeFKGfxeHV3R+emCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620784; c=relaxed/simple;
	bh=GiYsImW/hoq/7En+FhgGZAxZ8PJFxpLbcy2WC+0+CTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F8Lmag/Vt8EqX3ByJXAiEg2E/iZbm++4QNOe7TTJsesSl5pujCv2FHBp7YLPnuAfi7uTL3u4v15t9WugZWlenyYsoFX2Uu0Zszma2sBsEsiEnDKHhyc/jKEOCV0PIWZgsQM7XFJCnBwrQiQaBbbC81pGX7XalY7T6eGUHweenMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hVunNKCr; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egKncoy6EIpkJdjO8crnLg9X/ldGOlOmrlFNybYKp3LYcSf4ExALdVJQzsPWkXaCHxx2nKaFu76f653i7cLw8B5x58PHm4GUEpBoYMqL10kzppnpFLtkrDbYztNP86TClb/aTZugA2QObnEm1tfcBVPb4Rj7UsZhpbTJrvvauh4j+NabAoL6gCRF1B7VN80Gq1vJvUMhTqnMc+qRKwituUIZ5QCkpF1u61ypmgmkvXuLXIXtHw9fxVLdWGgcEOTFm7xmKNQR9V4w4jtw7NP0ke/Ra37X+i1s2Ne/KxvOSiNpI/SyIJKwMM6Jb9YVmIQwlOYdQqaQzyIDb2NoRLrRFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8th83DLt0rkS9fDxPIsPdyGHQ+6iYhQ5qkxeZiTiPv4=;
 b=kvzdtx40xrsLWY4Tn5WY1G1hrgNJhETiSbZuxStEHqA8jGtDvTtirnKfUcK61qpGX0Yl05yNqP5AGm9CZwvzLsgx0QcJxX4kq5yKcuNweC5Iw3LP/gRI6h32FkkiteSeFAwbHD8Vo3Eh+WndEGbqN7fDc4CBsa16f6jp/7Hy5If8TIYLy6TbhSNGt2H3MvOOi6q5iUb0Mq3N2eECazqxgt6lkRmhj/SZB41+2sUuvixgRgdPzI0JfMGCGqmTpN5MrXTfpKrbJTt555PTNxvLS97nilJ6+i33MRspI71/IlcUO/xiuGKb4BJJ/r4oVonUr8He2b+N1u8dSrD0xjIZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8th83DLt0rkS9fDxPIsPdyGHQ+6iYhQ5qkxeZiTiPv4=;
 b=hVunNKCraRytCwTg7fMQjgtlnP8ttWm0WzFJIQ3o1L+dJb2aaxUNG3FwA6X02Oa02ZJ5BIjOdn+1UfErLR7SjrvwnSfCsNodXS297fci8Zz7yJSqCLg353qqz7FWFWiCe/Bx45Tl7/B54+reFooee5fXMTnNHlx8dALYR9SVNv9rPLyOWW+0UlrhFdKlkz4V4aYpNmmzybV7SV4Nj/RSFMBf19psQEGqhnMQy3twcVtwcmcge0CJ2giLP3NYDt6Ljt2gcGlTEvaVwpmWjHmvlCTAX/rJat/25nOXt9+87kkRWL8Fx7YXtrc9jCXEP4NU+O5nRp2hn1L4BaUwQoIVtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 15 Jul
 2025 23:06:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 23:06:19 +0000
Date: Tue, 15 Jul 2025 20:06:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250715230618.GV2067380@nvidia.com>
References: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
 <76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
X-ClientProxiedBy: MN2PR19CA0042.namprd19.prod.outlook.com
 (2603:10b6:208:19b::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: 88165ed8-f426-4bee-eec2-08ddc3f4354c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k+CUtbz0ionJTwwwearsvvsiDdh+PvS4m78lqaOyp5u9Zam45vA8dbfuQJON?=
 =?us-ascii?Q?Ap0huUKuHpGfKsPvBACaVxtaUE3iesR5BKqpJtJgkRH5S5dcrH0LsJYNxAcu?=
 =?us-ascii?Q?r/OutXR/UuUKKpOytKX2L7OLqlhd1wyAEuskmYjBIMWeLi5LUIdXo6wElEH7?=
 =?us-ascii?Q?bj/llgkJcvE7hP9gZ3jaRujcy8aKVyCDOAeCP+oB4YAx3yHgwK1W9HdAlVT2?=
 =?us-ascii?Q?nSibiK/wDOjDTqb2Xq2yXl60zeTj+vt2EiDzICtG8g6lSipWf1iAFgP39zLo?=
 =?us-ascii?Q?E4gPg2oEFLBuJt6h81mT6KXHg+NJ340OEs/k+hOLJoDP0K59AYlGM8Ur56od?=
 =?us-ascii?Q?fuYvsLMBrZ8XGLKN9cr3B9xzYnAQ8Xw0eTthlS+n/eJDYFt8wsCAZuwpie2R?=
 =?us-ascii?Q?QF2Pu8v3rMSpxCoKbMwCFWFaDBvvPFgUzVwlJrRjucQxK023eBJAO8RBwSaB?=
 =?us-ascii?Q?B/RiZ0/9NcputzzjyvNfrfWd7ZlAdW849jjOPExJ5ejjNLKIQg+6sKi4iUAX?=
 =?us-ascii?Q?GgyErL1UOekpbCp7TJbKuycquciGOq4/nlmwdrsRzhw2fSCnLlqYfnZkRFh+?=
 =?us-ascii?Q?RA3PLe3geQS//FGLByVwQi0dVE+rWbKyRNfFRKbFBLdyyaGjZNZaGgovIzNd?=
 =?us-ascii?Q?aga9JJgEou7DHmkcYi+5Gt6Gcko2xrQUdee8z/Z8W/cUyaJBNNVJGz1w+d6/?=
 =?us-ascii?Q?FcM1ASt2zruNRGueiUIvQ4I8qVEjkG3NXckZxKK14qNyNHBjnEWunkhlLNxy?=
 =?us-ascii?Q?wY4lLQ7Nvejv0BYg1BnAqed+w9KhrpED5midBkAqeOJQLLPo/3gefP4l+lkP?=
 =?us-ascii?Q?YyX6UklMungvlttJFqON6+biNE4E3e43app/wR1lBQ8/hjSvQ0480XwHNUD7?=
 =?us-ascii?Q?Yp/5dpNpp+V5jm1W8ZdV/lggkhSy1F5QHCQSmJ81uHSZAhAAeOI/cy5zUIIa?=
 =?us-ascii?Q?OgNVxqf3Hhwxzk4bbVMmO2xynL0lvRUBmEvuFcyOiN5KIqNl/br6L5SrmYeZ?=
 =?us-ascii?Q?Z3Q0H8Yee2f8UsBPQqop7r/Mn0I0w3I5wo3b84+8kkPXHwrw7sXzib+fT+Zy?=
 =?us-ascii?Q?4lKHmcElrAqKdb0fzNojwQKRZQGkMNLw+aDcVtfemy6TWaLOmUPH+1N8/M8y?=
 =?us-ascii?Q?UL5sMStIDIjLSHzSJqJPn6LOZZclXIcVNI1X3vYEeVRK3MjjRU+iYa5d+viK?=
 =?us-ascii?Q?vprYB0LEgeeqsfrHJdvOrUpff22/PMfkZzNumjUjqrcMGpl9l3WgeidVHEm2?=
 =?us-ascii?Q?UBtipFZLshzgI5zHxK4fUgcV4Uk+TH10LE2cnYDj7d4+kLfzfNeSQlLXjzhf?=
 =?us-ascii?Q?hU0MG06Volk1AlQ9euptOeKE0cl9o5PQSjNvoJgu/6Ku5bMRM7nfrc3IeFmS?=
 =?us-ascii?Q?Y6C4aZ67DZIRTBUfbch823o9gakaVynAriwIdqQsGb9dzB5cwjkFdts7zM3h?=
 =?us-ascii?Q?NQ+hASKDYTg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ctY729hCs/pnwSbCKAiJHm3H4IoeO6r1hYFhsYI5K7TFYib/FZDHmCgqIb9l?=
 =?us-ascii?Q?EYLegBGTdBf4eFpbxpBz7iZ2ZgaHwc3UdFjkYitb7AykTAzPUki9DeCG0McQ?=
 =?us-ascii?Q?0sgM2L7KpqbViRsTTAEEuCiqeYUQM0PSwvjyBYscN90YNSck2RYvn49BcqNe?=
 =?us-ascii?Q?2wvNNWTond1lOFDIZD/YFflW0m7nHwp187hZf3zGfQsmck29oPYys3LDjEKa?=
 =?us-ascii?Q?4v1lCmZ2b6GJpJyfiUamKKVqX8mophvH07g9UEjvSfBi3EniDX6fRmIeqQrs?=
 =?us-ascii?Q?8B1dmdyr9RmkPPSdKe8Z7TeIJj1VmQvX3rfFIdL4TP2FLraD/9kLiMrDAM4T?=
 =?us-ascii?Q?ADKyh5AzjNBKogYv7DZ59LC+trKQ500Up+L5PM2/paet4BALabA7rKfSe2dQ?=
 =?us-ascii?Q?mR0r3TSySoYTxdtIxtLIJRfubLjkQQwABXa1hrtQbr5mJCYr428+QRKg0Hwg?=
 =?us-ascii?Q?2vbh57PSPpk+s9554yBsGjjAU0WsY804zx1MNZF+us1gNBisQHfKNYVyUyaF?=
 =?us-ascii?Q?rCHC3a/xal17wFFIcIEck8hMhmTSaEBUTvmUJjDiKQ5Df+9MQmlFgqhGsSpi?=
 =?us-ascii?Q?FndiVpEDwHtSLrCnZ4C9YiM3V5mC0spU8tubABXt7BK1MlaHR8K5/d+ujJ8x?=
 =?us-ascii?Q?0hQit/WVAC8RKMJ6gBV9iFXRkO/VYJmyJv6rhLgnGJI0qrZbggC4zGp+sXBw?=
 =?us-ascii?Q?94qbIF0xgjvLOX5TavHtRONBlQO1WsYe9f96q88SArr9QimxLmCukTyv5Lc2?=
 =?us-ascii?Q?8XqQu42cF7Kf97vkVB0rj7223O/QaCiR4UGhsU6r8mU80T9tUm6PfzYwBnxH?=
 =?us-ascii?Q?Rpp8htKAQD74Ehiwe8URwxNinOiJYD9O8jZFAO76TQUbZHttV7+HP9y/5nzR?=
 =?us-ascii?Q?BVOB37rL7DRkeliYhxLicEGS8PLmi5E7D7NcvCBJA3tAU8A2jJYi4SWa81ni?=
 =?us-ascii?Q?a25KryAVUSmchex/KKMBfzStOQgLO1XiadQe3WIjH3MRvV/OPcY7Z4SxpxIV?=
 =?us-ascii?Q?RRlOwzVCyvLoHr4MFpvgzdC0Ujpp52Jm5cNh9iYnmVm9+kByimNzgK9y+9es?=
 =?us-ascii?Q?15HqFlKZOAOFBVVtVb6F0gvR2lUpvB1qgKVO1tjoJMaNKpu/rOFtXSO9sVxJ?=
 =?us-ascii?Q?R4vctIT4q7sNH9Dmzvs65qVc5LOvyfDeedPzMzB1LSck1SyZo5hnVBlrIoRn?=
 =?us-ascii?Q?HSzDN5Xcvv9BHwrVSaES/tClImAjlZ862eNelEIJTdg5KTUPwT0DGCc3wGhV?=
 =?us-ascii?Q?QUHaX/hkpqc1MmyS+zb6Af24bpQQjMu5AuKVFz4OcVc6+/is2ldxmlfsI1JQ?=
 =?us-ascii?Q?Ctw/NryayVYV6gc0v1Epqtg1ktNC+MON9XbZWQBYCJdscncZanuGJnIadazG?=
 =?us-ascii?Q?89C7vTSNmSIsl2LMDb/tbfs3BR3ik3GJnDYq+QFnA5sFQ0qr3bF/FQYp/FxQ?=
 =?us-ascii?Q?M0JOHXlsdVqkAi56UvC8Gvj8g89hxoP8alpuGJQNUoDZnuLbw0Qesj9B9Kt+?=
 =?us-ascii?Q?PYDLWOUci97Qr53apIFGgd42wN8P/2W7k1prMTpCWTT37MP8IS39I3HxOEmB?=
 =?us-ascii?Q?p1fDbkIfxWdSfSsYwrdfoXzjb+iYSAt4lYmwq36M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88165ed8-f426-4bee-eec2-08ddc3f4354c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 23:06:19.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NiCNU88DqxwFhhR96SDt8LAyTZGOeujfOdJPcc6yyC/jp5samkiIW+qGGrXRwbob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8200

On Wed, Jul 16, 2025 at 01:55:45AM +0300, Dan Carpenter wrote:
> 5fcc26969a164e Yi Liu          2023-07-18  117  	mutex_lock(&device->dev_set->lock);
> 5fcc26969a164e Yi Liu          2023-07-18  118  	/* one device cannot be bound twice */
> 5fcc26969a164e Yi Liu          2023-07-18  119  	if (df->access_granted) {
> 5fcc26969a164e Yi Liu          2023-07-18  120  		ret = -EINVAL;
> 5fcc26969a164e Yi Liu          2023-07-18  121  		goto out_unlock;
> 5fcc26969a164e Yi Liu          2023-07-18  122  	}
> 5fcc26969a164e Yi Liu          2023-07-18  123  
> be2e70b96c3e54 Jason Gunthorpe 2025-07-14  124  	ret = vfio_df_check_token(device, &bind);
> be2e70b96c3e54 Jason Gunthorpe 2025-07-14  125  	if (ret)
> be2e70b96c3e54 Jason Gunthorpe 2025-07-14 @126  		return ret;
> 
> This needs to be a goto unlock.

Oop yes, thank you

Alex can you fix it up when applying?

Thanks,
Jason

