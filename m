Return-Path: <kvm+bounces-28911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0985499F2D2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9C21F240EE
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842C41F669E;
	Tue, 15 Oct 2024 16:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KOITgbMV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713621F6685
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010164; cv=fail; b=AbLzrW20bmGLlxmgfroLC7QixBUAx/uQjENeaZpUDn6MNQQLU3EqKxH65nyyJM4Z6fi1npJxWcHwmjPvn2MkFNq+9M+gQr1Pk8TgoLuo0nXVRJ/1upckE3iUq/WHBp/ArBHx2Kb23/xpfy/nqXJTIRK101qyJss3dsr+Ks9ecls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010164; c=relaxed/simple;
	bh=zFyJmrIIrsx60dIfr62tu6KeGZf0ON6QYWD/FlGK3iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OU2IIPmsJqptsv2MmxnNrOYE9mNHjtO7+KTcCD//l2j4Ilo8map37VfLZYXb9+Olgk5BbEFjK/FCd0TfWxK2WcYaaKvNGkAxeFP4Bx5LkUJm+hMuyof35xqevgQYBn8JiUwQ1MpvaZASg1lhuGC0blIeJxBIIQuBdwKFidwKjXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KOITgbMV; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1dc5qoP5RFgvuMHkHKbf9aqg3/K5eATbYKfcaK8Y94o3rLjhzBKiMj99k29gXfENR/u3kpkw9A0W+YHd5pCj8zt3e45lnVgLHvrTAGV0Dwupf6utzCuMp2Ap4370i72jeYSMeCAnYBBWt7arDsun6hVP8UE8ANrJ3X1QAKyOcFqfeRrPLPH4rEI4v46qFocuXfMh3zcBedzrfJHa4cKDRbPZxhsdTIn6oCdl1zL0/iBx0UBqJITkfeu49v+LsBkGQeZYbWrmXaSC1AGEY30y0AgCfNS/Bky+4/8qL0O9sZzNS1fOvL2TeK8Et4tIuH0ZDUE4S8QqxLbBi+xCSLRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26rjPR6SCcuVLIq2NVU0/glTl1GNtPDS/c6xfiIl/7U=;
 b=NoPz7ztJD0sm82gHCFYTm6Xx6T98jCWK+jkWL77tFyP1CAKZMxQ9HvUZWcI8ZfqyD2QL5LYTkYiqFxIsk+TnsDOW4ftr3G3aGqH2cWGlk6VorJCdQslckgThyNuau6YP+fBFkXfdQgW1v7pV1bR2xiTjE20DlDSNv4WX2OxEtBTMw1gnUb09Z9acBKm86Pf/D6UIT3v1VfwGEbjK6+X6tzyYh3hyEZdSWgFz5COv01uysjNzGeNQbg1UKFC+KSfccEajQ3wgh8688SLtj0iEWcdmnUdGH7p6184cl1kCPyKgAkf4SROtLCLJCpeIW8XUCIWr/oOuwxMYsKC9CSH66A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26rjPR6SCcuVLIq2NVU0/glTl1GNtPDS/c6xfiIl/7U=;
 b=KOITgbMVs2UfqZd6r+7QJM8wLaDSrol93dKtLs2pdXtaQqyf0efBu1XEfrmL0TXPgfyFlFkxiZf0LKIqGNhs1i8HHPhbB7SjyU7eFeIWsWb5aiZPOqWe501MiTaSrHdF8LwD0QRSpA4WkeVhCYoZUkdzApD1YT4ByG6pU/66gY7AG/yNVhZtY95EXjBMwtlTBjdqF0nuzCDfC+RcPAkM32HOe16tu75xFZjrf0co779K1Ru8Knii5o8vo/IKuYD4XQ37/0sJKy8zuA9MG1NWvDvg+9wWH/w+09uPS1t7SnaMuxlFHBcyf7FJduN/7xDrECHiRnUknbuI/YXAtwBG1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Tue, 15 Oct
 2024 16:35:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 16:35:57 +0000
Date: Tue, 15 Oct 2024 13:35:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Message-ID: <20241015163556.GN3394334@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-5-zhiw@nvidia.com>
 <20240926225100.GT9417@nvidia.com>
 <e76bf5fe-4ac7-44e3-a032-35f04249355f@nvidia.com>
 <20241015122057.GH3394334@nvidia.com>
 <4ab53705-c7bc-40a3-8907-1204597fb451@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ab53705-c7bc-40a3-8907-1204597fb451@nvidia.com>
X-ClientProxiedBy: MN2PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:208:d4::37) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db27e0b-0556-4f0d-1746-08dced377252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sYEikX8i5HCgH0bK7k292OfRF8a3LILSFTuk6rFZf5yBnmv5J09BanThw67i?=
 =?us-ascii?Q?iG20LdV/PLfl9HTWah95SxEEA/95yEpAjrqJsQWE6dYvJEwSrN+jVf+ARvXY?=
 =?us-ascii?Q?B8dGIQXQC2z6z0nVGtRfXwJJ8CVUdWu7047nju8aM6R50DMMV3VNRXtKzSxZ?=
 =?us-ascii?Q?qtz6iXZzK1RL2eUt3HxaVqgK5Uk0kTkubcgb8/x7pBticZ6tydeTywdusHT2?=
 =?us-ascii?Q?cFs0z4VLLWU8t3cQ5b9QYLIrKuk/tAIkCJPp0T8NJ9tHsQNQC9uG9Ofx8YaL?=
 =?us-ascii?Q?XuMqAi7WWS5I9jbWdmkSoCCMyJK0xPAsENhnWNEnVfoV98uBNIBVpHqQSLcF?=
 =?us-ascii?Q?70oUL+jjVzW2cEQeXpX4bwu6kJzer2UTzjGeWKaqhd3MwxOJL7T6PQb9/T3e?=
 =?us-ascii?Q?1p0q/7Yf0kmPyaRh7LO4kt2KZu4p+yq/1229nnkhZRUkWSOsEOxzDggkAoaP?=
 =?us-ascii?Q?podHSnYfKWFKzTKKOXB3xmMpDkHm199VBbVv5ffg5r69/N5fq5gi2bzBme14?=
 =?us-ascii?Q?dDJOuVo+4nnG7Oq86hH6hqw/GcDkLOcbJT9Goid1EWO8hJuxZzG2kPsrNxOt?=
 =?us-ascii?Q?sf6qg7gY5wuZ2EOdeY+zZNVyPwrF1NCDGGyH+7VObiAMXwi7ilk4rHds6BOL?=
 =?us-ascii?Q?eEhNJtkrjZFSkrF3FAjezs17442+hjK2PeCfyYYB0o/CekQuUVh5UpVbh0Z4?=
 =?us-ascii?Q?OOX6jSPg0f0nTHD4l7T7AmiQKaB6k4OiszoGDgYreYnhlfZPSNm0i9XVlj6u?=
 =?us-ascii?Q?BtzBbZnfZ5aKV9T/32vUkqF6sqE/9ozQrQ5Z6E+M5p0xkb7GoQPKnJlKHYB6?=
 =?us-ascii?Q?RqAHZCJpQHUs+zrYZn2bu6I8HZD7jMTwt37GM5LcM+2sdaXZ9rGqy9D81/QX?=
 =?us-ascii?Q?9Vt8pIJOI3qFlao7HqB/uORHPhyxnRO/vfortQRBxEZBYivsgIwuUFULea/I?=
 =?us-ascii?Q?miQwgpxiRZvBFxB8RPWtGUOq1K6GEiVVtrVwHKlVSIKgee18/W3Mp7Hxp/Uf?=
 =?us-ascii?Q?qc+AcSAiY0f0OBunyI653lWMW9WN34eqc/5hw7xal7HMnwwhcPGFTp8gk2AB?=
 =?us-ascii?Q?MehLt0J7UFTnpwyW/FxadM4GUf3eWmO3vC6s9D+jmNbTP/faLMG0430aQnyo?=
 =?us-ascii?Q?KsIOvATmOIHut3DxILxzuku2IkgJDm8bH8MatZ1wrYS3eNx06emuMe2dlcZh?=
 =?us-ascii?Q?+cCi9hO8jVvIJ+emmGmJKnK0vaOyRxdAhdYfv4SL+htDhVYtlJhWW/7B4i3a?=
 =?us-ascii?Q?LYalTJpxEZZnIdeaGNsIxpNSxc6FRJzRNzo7RXhVcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TsuFrYS+oX6wpQ6KdSG/5Kr9U1btyY85dmlSn+e9sS/6sdVlOelUdiaw08hU?=
 =?us-ascii?Q?QqcQzjlig/AelgcnPiYJd6h/+fHqFENECmdRZvzKxkEIUvR4hTwAPzxgL7ll?=
 =?us-ascii?Q?a4rEnOVNV75FQEPtKBqqTQV/axqhfDLjrLH5TCWHcFU5o155Ht8n3uFqp0gh?=
 =?us-ascii?Q?V4e/Quy9bkl95W4x2gOg1hHlMQVYB6SSn1cujU0HvZZARzQ9IuDJpZJl6uTE?=
 =?us-ascii?Q?il+gjEN4z7o+tZh0oH2K5SHxqrqknRSGgyxuvN97Ih/E+emIpyRX26cLYzoG?=
 =?us-ascii?Q?miPBHwW5rPnc25adWA5utTy0+jkGKR6YZrshAjEKxGapVCfc5+VXTQ7M3ho+?=
 =?us-ascii?Q?zRYwY2cES9CdvCVGu3nmzkz3pi7dzjtknDAGV0ZXtV3/qcR6aTwzm4R4YI3y?=
 =?us-ascii?Q?y607m9iW0JpcUQYk4ha8FrztPhCiIvXzJ8o8QvR133EOsm/DQX/lUUeIz8Fz?=
 =?us-ascii?Q?ZTgMohDVwfMYPSk6KdVGiibQf9rcNo7ZjTTwdAmj9nMgZH1KoggllmhjaCld?=
 =?us-ascii?Q?mpOyWyVYGsNJ7wKPICLlorvfTQgAL4atsMRpenIahu41bRb8LFqdUUGKiOrh?=
 =?us-ascii?Q?UeJoz8JqdKv+bDpVJ0et9pFhf8Qtj/pRi35EeoShK8kizOTqwM7dJPCs7bi8?=
 =?us-ascii?Q?bNnx4xeHZhxgVZieBrkQz18ByiHb7dgtQ++ONn/13n+JP3p82lW8dXidU+iV?=
 =?us-ascii?Q?Lr9B8CUdZz3uhpYHxaqL3Avk9nLNckgadhjgxfgMkxLfeeyo0sR+YsvQVOxj?=
 =?us-ascii?Q?m9QL/5P0KkZ0Iy58tkpMC9N+f3l18W1q1nIJ30c2ze0EI/J5LwxQOyfz4tUG?=
 =?us-ascii?Q?KUTfza1TXMlzekzRy7swV8cdoKPJTn2hVlwQa6WD8ns7/tzlqIRMSyg95r8Y?=
 =?us-ascii?Q?sXL3qitnE6tLT4ZpfM8O4kL5GkM0/eBOyJGo6q3lTkyXMlkDv4rxz952CpHm?=
 =?us-ascii?Q?6Ymnm1bv730PFMyxvvufB89VGpF7JsR5KJX1gLoziZKdb+1XFucx4G0L0kyK?=
 =?us-ascii?Q?okI2tsEdAzUjQEH1MO9oUf3qsneb1AMUwOu46MFUJp+L8tA++fy2H5MYthKm?=
 =?us-ascii?Q?iUe0ml3uZDPdHlgiByQVRF8nk3rJ4yZxV/Ikjw0UGf/J0vFWhd3KYDVJIpip?=
 =?us-ascii?Q?VyTWe9zeUQvfWpo66BQGARhxIS8UZOPzWOhWBFaYj5zp+wVAO56wAbVMSTL7?=
 =?us-ascii?Q?r5DmCPcqiv4sU9EyHWh/0ZOGTuZCQ/7A+DDB5IHr712Frnc5Gj8dRI38kK0i?=
 =?us-ascii?Q?8Wl563aa5A8FwTe4PhZLcOLCgaSccl7fawN+GBR3RdD4upxnWzKoQZalg5yp?=
 =?us-ascii?Q?C93WZp5U3VP4GZ2xqI3LAXXuvy5fvIS67ncRdG9RKW0ElmRotobg6jOKdEHz?=
 =?us-ascii?Q?zxum4D3AFhZHy+Uz9/hdswTX8Vy1S/x8HW6msoIiCs28ARWxvm0b0fKgkCkz?=
 =?us-ascii?Q?smgXyFOFTMLAfmlsovSbuUHTw87V0wYNBErW7DbZMFsTqo2lzuawXG1KkyHG?=
 =?us-ascii?Q?MItbfhkisBLH2CzTbGP3iMZGNraz5yy5uAb1W37fojAsCq5Rl0VFDMAYDqp4?=
 =?us-ascii?Q?d2s8v7u+Fmh0smxHr28=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db27e0b-0556-4f0d-1746-08dced377252
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 16:35:57.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBxSjyeKDG+QCSnO7QPtLkp6nKlgHEoVbEIX5Utx648VFl+h8aMJo7hBy/rUVS+D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792

On Tue, Oct 15, 2024 at 03:19:33PM +0000, Zhi Wang wrote:

> The FW needs to pre-calculate the reserved video memory for its own use, 
> which includes the size of metadata of max-supported vGPUs. It needs to 
> be decided at the FW loading time. We can always set it to the max 
> number and the trade-off is we lose some usable video memory, at around 
> (549-256)MB so far.

I think that is where you have to end up as we don't really want
probe-time configurables, and consider later updating how the FW works
to make this more optimal.

Jason

