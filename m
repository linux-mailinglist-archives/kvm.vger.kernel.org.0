Return-Path: <kvm+bounces-27588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AA1987B5B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB89E1C2273D
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122101B1414;
	Thu, 26 Sep 2024 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NU8ZrzVi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1CC1B07D1
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391086; cv=fail; b=mBfkG6wcfxLJyI/Ms2D8YIAzQAJgpX0iBr4hLgbWkGwKKYVNJVyEdqpqbln2ykFEm2c+sUTKL84fRiUX08R4gMda1HaUTDmlyhMqHEnFySwK4P7Ec4pedVAKNSF03wVVlskGA0bg0fL0dTSGoBbTWDbZuH0r5e9V2k/EJq2yJbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391086; c=relaxed/simple;
	bh=BO/dE7BvKlNe9DFxSQfpDxhpyJHpMGZR94AT8biIbVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G5Mk1bZ/rCnGr1bDWkvNaBOD9Q7Bm0kZoRb3iHSeBi8n38lvlUsCsE82rGc4H9V+GtsQyc7TPqlcE541nD86joHVnZANbXuLVP0+JzbXFgQrx6U6914D9JXF/TLKwhpq5+X0e3kv9CCNTzeEoBjbTYIFvNQt4yF6MKjhEymA5ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NU8ZrzVi; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hEqg/4CTzq571jbeV5VT0LgfWMz4OQFsitJh+yJUgvcKbhgOeMt+4+eoSMV1kXJyZiGJVjaTUVo1A1k2VcnNJuJBF1lo4+KndtCMU36PVdesxJGGVlrfkDJXxcN2xfj0sD1t8uE7b8Z1YZF9CQZuyar1KQFGxiG/XXtzwDlQjfifgrDOvMCOKLpAbrZLcvS9zCbuEoHDlQIZDCS1SoFftBAIkMuM+ULyFM4bviS2Rk8NQiK06ZKd9/6rW+Cd4dE/reUJ3JzJdaD41uP7uAG6fDVovuLkR2WUH+tnY1YVANQqGPPed6MdnAmLK5EsNlmGIaGPlRZl+dFCG8g+xn6CdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5K4gGx5Om5XfuFqUT2PKq1N4P1fdowJiHPfmg7z0d8=;
 b=Pot42YKnqc8iqpWZ4OrzDmnI7zlJrlSDVkR2C0tbZWmpBhxezCrix1N2sd+wvm734WrtgRdyEgLU9zgZq83lpJ4ouvRO/Jim8ed1iWoqluCTr0j7j7or0YoloexOlEY1WNy/fK/+75yZRIOYf3MmaSKjL7SDwTbrDPQ9rB4JFgLmlkePl8Hj+4Juga+TjzkrSVZOWcC9iAY4KqyT52vbw9FHnt7K9HaEksAjOOuWn5SwyunCkrlqMnHuWimzm+Ym70LAB8gNEKkBe0HBR51RZ+10dMv31nsLQIv5Ru9gX/GajN7ztIQJdCO+tiKvyH6AfH0dpzdxNkzdhQ+ZA+FsWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5K4gGx5Om5XfuFqUT2PKq1N4P1fdowJiHPfmg7z0d8=;
 b=NU8ZrzViuw75BfJF/yhPdlvpl2JC7qmKzrAY1aV5t0qDXsjD5EhBnskYN+WEr27v35RLo4YEt1yaES/9w+QLy4vOCVbIGA/pOjw6MSarCSGQMZDTsnCiOKh0F29H+GSWCZwDaxagNVON6kQxnqF9Wv4hS6Mhf8o13puWybuhkzAKzAyG8TGis3qY9A2VDB/GrieAgBstbWU9rkp65VMaDIhNuCzwUHWZGOLM5YYojfT1KhxHiquW6fdj+WLbKsc5ZEv+cZITmhnMhNlVIg8Ez8cUJEs/VdL87y8hA50zesZUKHvkNZso/ItlqkMEuUbbJGx/S7RQ8ISw0UFZbS3ZjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 22:51:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:51:20 +0000
Date: Thu, 26 Sep 2024 19:51:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Message-ID: <20240926225100.GT9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-5-zhiw@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922124951.1946072-5-zhiw@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0309.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: b993e58e-b7be-4981-53c5-08dcde7dbd26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OBQX6AVwXErK0OgVOwzTpPPtfn5GVBXqodLGe7mxUs5Im5SdQwJgSRrcMh/p?=
 =?us-ascii?Q?Pd4OXHRnAoGxumLoRQpNfAfSSdtrlI3qfZLyB8bKXMWC83n0ayFsv+OsP1a1?=
 =?us-ascii?Q?RNuSFutKmMc/OOE+tbAhs0s8TZghXNlt8Zdz34aOStTJv1aZSiyHbS0eERUv?=
 =?us-ascii?Q?SN3/f1cM4rBCBpU883xDlQ8X3/GjQ6eTc6LTdQrMGTtDABS1Ch9qdGQd0i+K?=
 =?us-ascii?Q?C1FrpALwrDFo31GnuffZRm+4fyLC/ZVhr2XhyevruYPGv/POCfuyohZq4K03?=
 =?us-ascii?Q?saYMI5+7w9yI3hPYyjXry1BMJ4+8wQ5KHswEmGfjY6k57E7PBoLF5lkyGMKr?=
 =?us-ascii?Q?cjHcC9IOWTKUQkWc+F6l4N2nVeZ8YHKYQtI4Kxwa/liTmQCjgONllyCAiL6c?=
 =?us-ascii?Q?8sfOoiDTdX+/noQ+9TXFBPjJ+kP1Pa1ti7JKorcQAeUzBdPSLnGSdYpdUivA?=
 =?us-ascii?Q?v0xgEz/vAYsBkTKlE1GyiKAYJZvGlAKwxriN4UJwuqG7f/UkUgVRRLmttoox?=
 =?us-ascii?Q?/Qd6t/GBI7EJwHOk+wZarBL6Tfb4hCIos+5NzAaaex++uegOHre1pSGim1CZ?=
 =?us-ascii?Q?+O9BNUTa8TjAd+QRVgjlZu6jK8yCDY+tkVVRqUsiHTeApaXyVGM7sbx+nRFN?=
 =?us-ascii?Q?gyTnCJa6SHD5uWsF226xvp0m8T1WIlyoJ1ZwaAqoqnWMmzxDFKD3GjEbxrZ/?=
 =?us-ascii?Q?ncAlMciAYTWCw+dcGHCX7rriCriaNLZO/1QBsVNlRAiZiG7lnZCWIEhAJmmf?=
 =?us-ascii?Q?GiUvexfk/V2Qkh3hci0NUfFOqXxmGtu8WOM/tFUAunuFnAa99NGuqrHLtIaV?=
 =?us-ascii?Q?ZCACfsEQpz0JU6a6kpF364yyuCQKnBMmfw4kJOQusS06FY+Cozm4KRVvaXhh?=
 =?us-ascii?Q?+ni/d32sm0w95UCfR0V4IGJdM63XScj4+RGCVwrfNZ62UX7atgeeOit9cscA?=
 =?us-ascii?Q?chPwg0YmLTYRvLQHOApCx4KEXGpQvm1HBH3AUgROwGWekLWjfxTHvRB3Egin?=
 =?us-ascii?Q?k66sP1iZe6N1KFXz0R59LyiNc8LzzadZvMFU6n/pS5QxXdPa6vc6pHfx43bk?=
 =?us-ascii?Q?BsU5XMM9PXeStKC8r7n5mlaWY2zte/+USEj+APeEBtiaow8p/yrmyhR1S2+G?=
 =?us-ascii?Q?3xzK+nNsVfkR9dp05coPvRJAe/up8blDcm+NDrLLH7thQJHT6KUFYa3TUUt6?=
 =?us-ascii?Q?fNYlJh7H1r1ufQe+udHHB7GnL4CqkaW4iKymJqn23FSPG4tbOmyHY73u7/nA?=
 =?us-ascii?Q?1HyLSwAOactpYMcwl7CmXLoA2tB6cc6tA5G3Oox2Kw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ThOnmEL1LoYk7BZsUGHRIfw+ot0VTHzHz3jxG+QUhSxVtPFoZb4WgBPwlgYM?=
 =?us-ascii?Q?X80UMfNvGPbtHYV9hoiOLx1I3X/3k21g76atLQ4nECKZjFbbptgm00KYFmRu?=
 =?us-ascii?Q?/nY30Qof7fO7ENwtSHGkA6YIyTunVJzd2zPMKQmA8L2xBqPegjHhwd65+BDe?=
 =?us-ascii?Q?weUHAsvu895hCjuM3Ds/7yrJjB6NA/0IzAXQM6WKY6dKbspKqW3hABMR3L1h?=
 =?us-ascii?Q?XCKT+shjPOityAmc9SD4cJJv366F1IP6calFt+CuyJeNHgNF7cIRAOdCF5lh?=
 =?us-ascii?Q?6jMo4MpGEzsvgGSFRUPLbzmK5Emn2PLNpSdNk9F7EuxJrC80St/E6Kmd9ltz?=
 =?us-ascii?Q?UQLp5LS767poas161PfmLVr/Q8uFIxDtSLWeBuI4EmgzvJtLkf2POkWBBAcn?=
 =?us-ascii?Q?kZtoTmQFF7DuInV7clDavtSHxpfQ4s17yLt7wtjjLkkB4h/THYuCLNTx4xM8?=
 =?us-ascii?Q?x2Q4nIpJ8lvP3ixMuAG8uKG1aBLPoxq6ix/OOMsCItTvYdc10E3DOXT6eEFo?=
 =?us-ascii?Q?uXtvBph7+w/XKBX4KYsl5JWIKa8UppitUw5LIDmBVScN7tcIG6LWfd+0ghLx?=
 =?us-ascii?Q?CdBXONFUAm5iaB3lKuO2wvPMRfyCOF0YZOCNZCyoJ9ch1hx5W7rG9V3h1uTU?=
 =?us-ascii?Q?x4yedAr1cZ32JL6HhQi7KFMI3kjWO5XB/kXy7ZLzbfX2aAicRdFjyaDxveER?=
 =?us-ascii?Q?fGffRCVXmM+ncpEK62poS6A9gb64meIIVjvhiOOk+BziYwGehUjSJR0efn8k?=
 =?us-ascii?Q?2rOvzRlkHYGGmAen+GY2eEjiECrMd2w7mf6ngQu6QUUT4+JB96umBFH1Vk0i?=
 =?us-ascii?Q?eGyDeF8BDk2wKyj0agY9PZVZoR6c56nLebBIwj8tJZwx2tv/BA3AAEsTcTBZ?=
 =?us-ascii?Q?V3Vb4e/OV17w8NLRv3m0lEWX1ENaleIzy0Po9dBVd2TGTQtK0Ih5KqKUJKCd?=
 =?us-ascii?Q?osyrxzaObypj/XepNx1ptLHL8cWmSQYewApinBNhz+faTucvIBZIQWjxPVdp?=
 =?us-ascii?Q?JD6Q0iYXMia0rdR52PNxGGFkxnoW0oO5i0yZ1wOi0hW1Mz4aIAjArbbNen7l?=
 =?us-ascii?Q?hqLbX6JG3FHF1bdtdJiNgvCG32hs8H4siKLjWxeSsVUCGf1lzKpGIzno5VEU?=
 =?us-ascii?Q?TUY3aGUXVXIbxyzPEm/IdWWz1EfS1YZQwUHFZfKGJXmFsdhB5byVkzMy7vsY?=
 =?us-ascii?Q?GP9NF2yO8pO8/ZMR0XOjgkx9R+kUHnHUZANmS9UCUaxo0+yEgu+R6P+voxwH?=
 =?us-ascii?Q?2mc+xf+uHlpgvTE7kz2T9XdXh7XC82ljFTVqsvwf195PCkT8IdBs+Of+V6+c?=
 =?us-ascii?Q?1f3g4aXjzQBRJhMGa4A0vosSL3hHckYqF6K9qKBw8v7vssG4UcZvWyYCoSx4?=
 =?us-ascii?Q?ALEEnCl2w1kk94zLlqQirRBCzAjxi+vmln61OYZEqCQEu5k5YGb7FPOQ/SQM?=
 =?us-ascii?Q?aeFPkNdLRZgLlu0/EaNpt5I60OyMJII58UGHUbJWAAWg+7ZNXnn5hqqA+8+O?=
 =?us-ascii?Q?zPfM+Ik58Z1JGjr/8zvP/vzc0JktlxQjAseA1Pag6V/zyD5HAAvU52HqvowP?=
 =?us-ascii?Q?r6/zKvHPo0o9Skv25Z0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b993e58e-b7be-4981-53c5-08dcde7dbd26
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:51:20.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtJXe7hqEbpwsu8wC1tLUrrm12pvnyevlGAcfHfxbpJT1KRktMkBSlieMDKCGy8I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Sun, Sep 22, 2024 at 05:49:26AM -0700, Zhi Wang wrote:
> GSP firmware needs to know the number of max-supported vGPUs when
> initialization.
> 
> The field of VF partition count in the GSP WPR2 is required to be set
> according to the number of max-supported vGPUs.
> 
> Set the VF partition count in the GSP WPR2 when NVKM is loading the GSP
> firmware and initializes the GSP WPR2, if vGPU is enabled.

How/why is this different from the SRIOV num_vfs concept?

The way the SRIOV flow should work is you boot the PF, startup the
device, then userspace sets num_vfs and you get the SRIOV VFs.

Why would you want less/more partitions than VFs? Is there some way to
consume more than one partition per VF?

At least based on the commit message this seems like a very poor FW
interface.

Jason

